"""Admissibility permutation test, participant bootstrap and slopes (simulated data)."""

import numpy as np
import pytest

from cro_terrain.information import delta_hat, opp_emp, opp_emp_shuffle
from cro_terrain.simulate import ExtractionModel, HeliosModel, simulate_extraction, simulate_helios_audit
from cro_terrain.statistics import (admissibility_permutation_test, cluster_bootstrap, ols_slope,
                                    slope_through_origin)


def test_permutation_rejects_non_admissible_interpretation():
    model = ExtractionModel(m_leak=0.4)
    assert model.truth()["i_v_m_given_sigma_c"] > 0.1
    data = simulate_extraction(model, 40, 60, seed=21)
    res = admissibility_permutation_test(data["verdict"], data["message_m"], data["sigma_code"],
                                         data["context_id"], n_perm=199, seed=1)
    assert res.rejects(0.01)


def test_permutation_does_not_reject_admissible_interpretation():
    model = ExtractionModel(m_leak=0.0)
    assert model.truth()["i_v_m_given_sigma_c"] == pytest.approx(0.0, abs=1e-12)
    data = simulate_extraction(model, 40, 60, seed=22)
    res = admissibility_permutation_test(data["verdict"], data["message_m"], data["sigma_code"],
                                         data["context_id"], n_perm=199, seed=2)
    assert not res.rejects(0.01)
    assert res.n_informative_strata > 0


def test_permutation_untestable_when_sigma_determines_m():
    m = ["m0", "m1"] * 30
    sigma = m[:]  # each Sigma code carries a single message
    v = ["1", "2", "1"] * 20
    res = admissibility_permutation_test(v, m, sigma, n_perm=50, seed=0)
    assert res.n_informative_strata == 0 and res.p_value == 1.0


def test_cluster_bootstrap_covers_truth_and_counts_clusters():
    model = ExtractionModel()
    truth = model.truth()["delta"]
    data = simulate_extraction(model, 40, 60, seed=31, participant_sd=0.3)

    def stat(d):
        return delta_hat(d["verdict"], d["sigma_code"], d["message_m"], d["context_id"])

    res = cluster_bootstrap(data, stat, cluster="participant_id", n_boot=300, seed=7)
    assert res.n_clusters == 40
    assert res.low < res.estimate < res.high
    assert res.low - 0.05 < truth < res.high + 0.05


def test_bootstrap_helios_ten_trustees():
    model = HeliosModel()
    data = simulate_helios_audit(model, n_trustees=10, seed=8)

    def stat(d):
        return opp_emp(d["verdict"], d["proof_id"], method="mm", alphabet_size=4)

    data["_language"] = np.asarray(["fr"], dtype=object)  # metadata as returned by read_template
    res = cluster_bootstrap(data, stat, cluster="trustee_id", n_boot=300, seed=9)
    assert res.n_clusters == 10
    assert 0.0 <= res.low <= res.high <= 1.0


def test_slopes():
    x = [0.001, 0.01, 0.05, 0.1]
    y = [2 * v for v in x]
    assert slope_through_origin(x, y) == pytest.approx(2.0)
    a, b = ols_slope(x, [1 + 3 * v for v in x])
    assert a == pytest.approx(1.0) and b == pytest.approx(3.0)
    assert np.isnan(slope_through_origin([0, 0], [1, 2]))


def test_bootstrap_over_proofs_with_relabelling_covers_truth():
    model = HeliosModel()
    truth = model.truth()["opp"]
    data = simulate_helios_audit(model, n_trustees=10, seed=41)

    def stat(d):
        return opp_emp_shuffle(d["verdict"], d["proof_id"], n_shuffle=5, seed=0, alphabet_size=4)

    res = cluster_bootstrap(data, stat, cluster="proof_id", n_boot=150, seed=3, relabel=True)
    assert res.n_clusters == 50
    assert res.low <= truth <= res.high
