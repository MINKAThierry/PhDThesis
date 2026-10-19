"""P4: standardised joint estimation of (Delta_hat, alpha_hat), alg:estimation_conjointe."""

import numpy as np
import pytest

from cro_terrain import p4
from cro_terrain.simulate import ExtractionModel, simulate_extraction


def _dataset(n=32, seed=0, retest_noise=0.05):
    model = ExtractionModel(k_messages=4, n_variants=2, n_verdicts=4, n_contexts=2,
                            leak=0.6, rho_s=0.5, noise=0.1)
    d = simulate_extraction(model, n_participants=n, items_per_participant=40, seed=seed)
    rng = np.random.default_rng(seed)
    nrow = len(d["verdict"])
    d["stratum"] = np.asarray(["JG" if int(p[1:]) % 2 else "RS" for p in d["participant_id"]],
                              dtype=object)
    d["confidence"] = rng.integers(3, 11, nrow).astype(float)
    d["session"] = np.asarray(["1"] * nrow, dtype=object)
    # items numbered within each participant, so that participants share items
    rank = {}
    pid = []
    for p in d["participant_id"]:
        rank[p] = rank.get(p, -1) + 1
        pid.append(f"I{rank[p]:03d}")
    d["proof_id"] = np.asarray(pid, dtype=object)
    # test-retest: the first 3 items of each participant presented again
    idx = [i for p in sorted(set(d["participant_id"]))
           for i in np.flatnonzero(d["participant_id"] == p)[:3]]
    rt = {k: v[idx].copy() for k, v in d.items()}
    flip = rng.random(len(idx)) < retest_noise
    rt["verdict"] = np.where(flip, rng.choice(["1", "2", "3", "4"], len(idx)), rt["verdict"])
    rt["confidence"] = np.clip(rt["confidence"] + rng.normal(0, 0.5, len(idx)), 0, 10)
    rt["session"] = np.asarray(["2"] * len(idx), dtype=object)
    out = {k: np.concatenate([d[k], rt[k]]) for k in d}
    return model, out


def test_full_algorithm_runs_and_recovers_delta():
    model, d = _dataset()
    rep = p4.estimation_conjointe(d, n_verdicts=4, h_c=8.0, delta_prereg=2.0,
                                  institutional_agreement=True, ethics_approval=True,
                                  n_perm=99, n_boot=100)
    assert rep.prerequisites.satisfied()
    assert set(rep.steps) == {1, 2, 3, 4, 5, 6}
    lo, hi = rep.steps[4]["ci"]
    assert lo - 0.15 <= model.truth()["delta"] <= hi + 0.15
    assert rep.steps[4]["criterion"] == "not_refuted"
    assert rep.steps[5]["alpha_hat"] == pytest.approx(2 / 8)
    assert rep.steps[6]["icc"] > 0.8
    assert np.isfinite(rep.steps[6]["kappa_inter_rater"])
    assert len(rep.summary()) == 7


def test_prerequisites_block_is_reported():
    _, d = _dataset(n=12)
    rep = p4.estimation_conjointe(d, n_verdicts=4, h_c=8.0, institutional_agreement=True,
                                  ethics_approval=False, n_perm=19, n_boot=20)
    assert not rep.prerequisites.satisfied()
    miss = rep.prerequisites.missing()
    assert any("ethics" in x for x in miss) and any("n >= 30" in x for x in miss)


def test_verdict_space_size():
    space = {"institution_id": ["INST-01"] * 5 + ["INST-02"],
             "context_id": ["C1", "C1", "C1", "C2", "C2", "C1"],
             "verdict_code": ["1", "2", "3", "4", "4", "1"],
             "retained": ["oui", "yes", "non", "1", "oui", "oui"]}
    assert p4.verdict_space_size(space, "INST-01") == 3
    assert p4.verdict_space_size(space, "INST-01", "C1") == 2
    assert p4.verdict_space_size(space, "INST-02") == 1
    space["notes"] = ["D-A", "D-B", "D-A", "consolidee", "consolidee", ""]
    assert p4.verdict_space_size(space, "INST-01") == 1


def test_p1_mapping():
    p1 = {"participant_id": ["P1-JG-001"] * 2, "stratum": ["JG"] * 2,
          "context_id": ["ECD-C01"] * 2, "stimulus_id": ["ECD-C01"] * 2,
          "sigma_id": ["ECD-C01-S1"] * 2, "proof_type": ["ECD"] * 2,
          "message_id": ["ECD-C01-M1"] * 2, "verdict_v": [2.0, np.nan],
          "confidence": [7.0, 6.0], "time_s": [900.0, 800.0], "phase": [1.0, 2.0]}
    d = p4.p1_to_p4(p1, "juridiction")
    assert d["verdict"].tolist() == ["2", ""] and d["session"].tolist() == ["1", "2"]


def test_inter_rater_kappa_on_shared_items():
    d = {"participant_id": ["A"] * 6 + ["B"] * 6, "stratum": ["JG"] * 12,
         "context_id": ["C1"] * 12, "proof_id": [f"X{i}" for i in range(6)] * 2,
         "sigma_code": ["S1"] * 6 + ["S2"] * 6, "verdict": list("121234") + list("121234"),
         "session": ["1"] * 12}
    assert p4.pairwise_inter_rater_kappa(d) == pytest.approx(1.0)


def test_duplicate_item_rejected():
    d = {"participant_id": ["A", "A"], "context_id": ["C1"] * 2, "proof_id": ["X"] * 2,
         "sigma_code": ["S"] * 2, "verdict": ["1", "2"], "confidence": [5.0, 6.0],
         "session": ["1", "1"]}
    with pytest.raises(ValueError):
        p4.retest_pairs(d)
