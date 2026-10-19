"""Estimators of entropy and conditional mutual information (simulated data only)."""

import numpy as np
import pytest

from cro_terrain.information import (alpha_hat, conditional_entropy, conditional_mutual_information,
                                     delta_hat, entropy, entropy_from_counts, gamma_from_alpha,
                                     h_v_given_c, opp_emp, opp_emp_shuffle,
                                     shuffle_corrected_cmi)
from cro_terrain.simulate import ExtractionModel, HeliosModel, simulate_extraction, simulate_helios_audit


def test_entropy_uniform_and_degenerate():
    assert entropy(list("abcd") * 10) == pytest.approx(2.0)
    assert entropy(["a"] * 7) == 0.0
    assert entropy_from_counts([]) == 0.0


def test_miller_madow_correction_formula():
    counts = [5, 3, 2]
    n = 10
    plug = entropy_from_counts(counts, "plugin")
    mm = entropy_from_counts(counts, "mm")
    assert mm - plug == pytest.approx((3 - 1) / (2 * n * np.log(2)))


def test_nsb_less_biased_than_plugin_on_small_samples():
    rng = np.random.default_rng(0)
    K = 8
    errs_plug, errs_nsb = [], []
    for _ in range(40):
        x = rng.integers(0, K, size=15)
        errs_plug.append(entropy(x, "plugin") - 3.0)
        errs_nsb.append(entropy(x, "nsb", alphabet_size=K) - 3.0)
    assert abs(np.mean(errs_nsb)) < abs(np.mean(errs_plug))


def test_cmi_simple_cases():
    rng = np.random.default_rng(1)
    x = rng.integers(0, 2, 5000)
    y = x.copy()
    z = rng.integers(0, 3, 5000)
    assert conditional_mutual_information(x, y, [z]) == pytest.approx(1.0, abs=0.01)
    w = rng.integers(0, 2, 5000)
    assert abs(conditional_mutual_information(x, w, [z], method="mm")) < 0.01
    # chain rule: I(X;Y,Z) = I(X;Z) + I(X;Y|Z)
    lhs = conditional_mutual_information(x, list(zip(y, z)))
    rhs = conditional_mutual_information(x, z) + conditional_mutual_information(x, y, [z])
    assert lhs == pytest.approx(rhs)


@pytest.mark.parametrize("method", ["plugin", "mm", "nsb"])
def test_delta_hat_recovers_known_delta(method):
    model = ExtractionModel(k_messages=4, n_variants=2, n_verdicts=4, n_contexts=2,
                            leak=0.6, rho_s=0.5, noise=0.1)
    truth = model.truth()
    data = simulate_extraction(model, n_participants=100, items_per_participant=100, seed=11)
    est = delta_hat(data["verdict"], data["sigma_code"], data["message_m"], data["context_id"],
                    method=method, alphabet_size=4)
    assert est == pytest.approx(truth["delta"], abs=0.06)


def test_delta_hat_tracks_extraction_strength():
    """A larger rho_s (more use of proof features beyond the message) gives a larger Delta."""
    vals = []
    for rho in (0.0, 0.5, 1.0):
        model = ExtractionModel(rho_s=rho)
        data = simulate_extraction(model, 60, 100, seed=5)
        est = delta_hat(data["verdict"], data["sigma_code"], data["message_m"], data["context_id"])
        assert est == pytest.approx(model.truth()["delta"], abs=0.08)
        vals.append(est)
    assert vals[0] < vals[1] < vals[2] or vals[0] < vals[2]


def test_opp_emp_extraction_model():
    model = ExtractionModel()
    truth = model.truth()
    data = simulate_extraction(model, 100, 100, seed=3)
    est = opp_emp(data["verdict"], data["sigma_code"], data["context_id"], method="mm", alphabet_size=4)
    assert est == pytest.approx(truth["opp"], abs=0.04)


def test_opp_emp_helios_model_large_panel():
    model = HeliosModel()
    truth = model.truth()
    data = simulate_helios_audit(model, n_trustees=400, seed=4)
    est = opp_emp(data["verdict"], data["proof_id"], method="mm", alphabet_size=4)
    assert est == pytest.approx(truth["opp"], abs=0.03)


def test_opp_undefined_when_all_verdicts_equal():
    v = ["1"] * 20
    s = list(range(20))
    assert np.isnan(opp_emp(v, s))


def test_h_v_given_c_and_alpha():
    v = ["a", "b"] * 50
    c = ["x"] * 100
    assert h_v_given_c(v, c, method="plugin") == pytest.approx(1.0)
    assert conditional_entropy(v, [c]) == pytest.approx(1.0)
    # Helios: |V| = 4, H(C) = 8 bits (case scale) -> alpha_hat = 0.25
    assert alpha_hat(4, 8.0) == pytest.approx(0.25)
    assert gamma_from_alpha(1.0, 20.0) == pytest.approx(19.0)
    with pytest.raises(ValueError):
        alpha_hat(0, 8.0)


def test_shuffle_correction_removes_small_sample_bias_helios_design():
    """Thesis design (10 trustees x 50 proofs, Sigma = proof id): Miller-Madow
    leaves a large positive bias, the shuffle correction removes most of it."""
    model = HeliosModel()
    truth = model.truth()["opp"]
    mm, sc = [], []
    for r in range(8):
        d = simulate_helios_audit(model, n_trustees=10, seed=200 + r)
        mm.append(opp_emp(d["verdict"], d["proof_id"], method="mm", alphabet_size=4))
        sc.append(opp_emp_shuffle(d["verdict"], d["proof_id"], n_shuffle=30, seed=r, alphabet_size=4))
    assert np.mean(mm) - truth > 0.04
    assert abs(np.mean(sc) - truth) < 0.025


def test_shuffle_corrected_cmi_is_near_zero_under_independence():
    rng = np.random.default_rng(3)
    x = rng.integers(0, 4, 400)
    y = rng.integers(0, 50, 400)
    assert conditional_mutual_information(x, y) > 0.2
    assert abs(shuffle_corrected_cmi(x, y, n_shuffle=40, seed=1)) < 0.05
