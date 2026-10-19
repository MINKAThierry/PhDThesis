"""Pre-registered refutation criteria applied to simulated results."""

import pytest

from cro_terrain.information import h_v_given_c, opp_emp
from cro_terrain.refutation import (NOT_PROBATIVE, NOT_REFUTED, REFUTED, apply_criteria,
                                    criterion_admissibility, criterion_bound, criterion_delta,
                                    criterion_eta_q, criterion_gamma, criterion_opp_helios)
from cro_terrain.simulate import HeliosModel, simulate_helios_audit
from cro_terrain.statistics import cluster_bootstrap


def test_delta_criterion():
    assert criterion_delta(30.0, 25.0).status == REFUTED
    assert criterion_delta(20.0, 25.0).status == NOT_REFUTED
    assert criterion_delta(float("nan"), 25.0).status == NOT_PROBATIVE


def test_admissibility_criterion():
    assert criterion_admissibility(0.005).status == REFUTED
    assert criterion_admissibility(0.02).status == NOT_REFUTED
    assert criterion_admissibility(1.0, n_informative_strata=0).status == NOT_PROBATIVE


def test_gamma_criterion_helios_case_scale():
    # Helios, case scale: H(V|C) <= 2 bits, alpha = 1.2, H(C) = 8 -> gamma = 8.6
    d = criterion_gamma(2.0, 1.2, 8.0)
    assert d.status == REFUTED and d.values["gamma"] == pytest.approx(8.6)


def test_eta_criterion():
    assert criterion_eta_q((0.0, 0.01), (0.05, 0.15)).status == REFUTED
    assert criterion_eta_q((0.04, 0.08), (0.05, 0.15)).status == NOT_REFUTED


def test_bound_criterion_requires_hypotheses():
    assert criterion_bound(0.5, 0.01, hypotheses_verified=False).status == NOT_PROBATIVE
    assert criterion_bound(0.5, 0.01, hypotheses_verified=True).status == REFUTED
    assert criterion_bound(0.001, 0.01, hypotheses_verified=True).status == NOT_REFUTED


@pytest.mark.parametrize("opp,ci,label", [
    (0.52, (0.40, 0.60), "agreement"),
    (0.30, (0.20, 0.40), "disagreement"),
    (0.53, (0.51, 0.56), "agreement_with_significant_gap"),
    (0.60, (0.40, 0.75), "inconclusive"),
])
def test_opp_helios_labels(opp, ci, label):
    assert criterion_opp_helios(opp, ci).values["label"] == label


def test_apply_criteria_on_simulated_helios_audit():
    model = HeliosModel()
    data = simulate_helios_audit(model, n_trustees=10, seed=12)

    def opp(d):
        return opp_emp(d["verdict"], d["proof_id"], method="mm", alphabet_size=4)

    def hvc(d):
        return h_v_given_c(d["verdict"], d["context_id"], method="mm", alphabet_size=4)

    b_opp = cluster_bootstrap(data, opp, "trustee_id", n_boot=200, seed=1)
    b_h = cluster_bootstrap(data, hvc, "trustee_id", n_boot=200, seed=2)
    out = apply_criteria({
        "opp": b_opp.estimate, "opp_ci": (b_opp.low, b_opp.high),
        "h_v_c_ci_high": b_h.high, "alpha": 1.2, "h_c": 8.0,
        "product_ci_low": 0.4, "hypotheses_verified": False, "lam": 128, "kappa": 1, "capacity": 56,
    })
    names = [d.criterion for d in out]
    assert names == ["gamma", "bound", "opp_helios"]
    # deployed Helios is outside the scope of the theorem: no probative comparison
    assert out[1].status == NOT_PROBATIVE
