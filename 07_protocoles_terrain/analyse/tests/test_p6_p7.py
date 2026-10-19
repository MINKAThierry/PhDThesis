"""P6 simulation summary and predictions; P7 combined validation (hypotheses, bound)."""

import numpy as np
import pytest

from cro_terrain import p6, p7, quantum
from cro_terrain.bounds import borne_raffinee_pq
from cro_terrain.templates import read_template


@pytest.fixture(scope="module")
def plan(tmp_path_factory):
    out = tmp_path_factory.mktemp("p6") / "plan.csv"
    quantum.run_plan(str(out), "fr", h_c_values=(10.5,), n_qubits_values=(2,))
    return read_template(out, "p6_simulation")


def test_afw_and_ceiling():
    assert p6.afw_bound(0.0, 4) == 0.0
    assert p6.afw_bound(0.1, 4) == pytest.approx(0.4 + 2.2 * p6.h2(0.1 / 1.1))
    assert p6.eta_ceiling(1.5, 10.5) == pytest.approx(1.5 / 10.5)
    with pytest.raises(ValueError):
        p6.afw_bound(1.5, 4)


def test_simulation_summary_and_predictions(plan):
    s = p6.summarize(plan)
    q = [x for x in s if x["encoding"] == "quantum"]
    assert {x["channel"] for x in q} == {"depolarizing", "dephasing", "amplitude_damping", "combined"}
    assert all(x["eta_max"] <= x["eta_ceiling"] + 1e-12 for x in q)
    pred = p6.check_predictions(s)
    assert pred["3_increasing_in_noise"] and pred["4_negative_control_zero"]
    assert pred["2_within_afw_heuristic"]
    # toy model: the combined NISQ channel stays far below the predicted 0.05-0.15
    assert pred["1_combined_in_predicted_range"] is False


def _classical_state(p):
    return np.diag(np.asarray(p, dtype=complex))


def test_relative_entropy_and_beta_q():
    a, b = _classical_state([0.6, 0.4]), _classical_state([0.4, 0.6])
    kl = 0.6 * np.log2(0.6 / 0.4) + 0.4 * np.log2(0.4 / 0.6)
    assert p7.relative_entropy(a, b) == pytest.approx(kl)
    chi = p7.holevo_chi([0.5, 0.5], [a, b])
    r = p7.beta_q_min({"c1": ([0.5, 0.5], [a, b])})
    assert r["beta_q"] == pytest.approx(kl / chi) and r["chi_max"] == pytest.approx(chi)
    # signature-like: disjoint supports, not quantum-regular
    s0, s1 = _classical_state([1, 0]), _classical_state([0, 1])
    assert p7.relative_entropy(s0, s1) == float("inf")
    assert p7.beta_q_min({"c": ([0.5, 0.5], [s0, s1])})["beta_q"] == float("inf")


def _hyp(**kw):
    base = dict(lam=128, kappa=2.0, delta_q_ci_low=20.0, delta_q_prereg=28.0, admissibility_p=0.4,
                admissibility_informative_strata=12, log2_verdicts=2.0, alpha_q=0.2, theta_q=0.5,
                h_c=20.0, h_v_c_ci=(1.8, 2.0), beta_q=1.04, chi_max=0.01)
    base.update(kw)
    return p7.Hypotheses(**base)


def test_combined_protocol_with_and_without_hypotheses():
    h = _hyp()
    assert h.all_hold()
    rep = p7.protocole_combine(hyp=h, eta_ci=(0.0, 0.01), eta_predicted=(0.05, 0.15),
                               product_ci_low=0.001,
                               cross_rows=[{"standard": "ML-DSA-65", "parameter": "Delta_q",
                                            "predicted": 28.0, "measured": 25.0,
                                            "ci_low": 22.0, "ci_high": 29.0}])
    b = borne_raffinee_pq(128, 2.0, 28.0, 0.5, 0.2, 20.0)
    assert rep["C_bound"]["bound"] == pytest.approx(b)
    assert rep["C_bound"]["decision"] == "not_refuted"
    assert rep["B_eta_q"]["decision"] == "refuted"
    assert rep["D_cross_validation"][0]["prediction_in_ci"]
    assert rep["D_cross_validation"][0]["relative_error"] == pytest.approx(-3 / 28)
    # a signature reveals m: chi_max far above kappa/lambda, beta_q infinite -> not probative
    rep2 = p7.protocole_combine(hyp=_hyp(chi_max=8.0, beta_q=float("inf")), eta_ci=(0, 0),
                                eta_predicted=(0, 0), product_ci_low=0.5)
    assert rep2["C_bound"]["decision"] == "not_probative"
    assert "H4q_regime" in rep2["C_bound"]["reason"] and "H3q_regularity" in rep2["C_bound"]["reason"]


def test_reference_output_is_reproducible(tmp_path):
    from pathlib import Path
    for lang in ("fr", "en"):
        ref = Path(__file__).resolve().parents[2] / "P6_eta_q" / f"sortie_plan_reference_{lang}.csv"
        out = tmp_path / f"again_{lang}.csv"
        quantum.run_plan(str(out), lang)
        assert out.read_text(encoding="utf-8") == ref.read_text(encoding="utf-8")
