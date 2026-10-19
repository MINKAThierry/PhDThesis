"""P2: structural decomposition, MDS volume (unit dependence), Delphi rule."""

import numpy as np
import pytest

from cro_terrain import p2


def test_element_entropy():
    assert p2.element_entropy(16) == pytest.approx(4.0)
    assert p2.element_entropy(1) == 0.0
    assert p2.element_entropy(probabilities=[0.5, 0.25, 0.25]) == pytest.approx(1.5)
    with pytest.raises(ValueError):
        p2.element_entropy(0)


def test_decomposition_totals_and_summary():
    rows = [("P2-EX-01", "CONT", "L", 10.0), ("P2-EX-01", "CONT", "T", 8.0),
            ("P2-EX-01", "CONT", "R", 12.0), ("P2-EX-02", "CONT", "L", 6.0),
            ("P2-EX-02", "CONT", "T", 6.0), ("P2-EX-02", "CONT", "R", 8.0)]
    tot = p2.decomposition_totals(*zip(*rows))
    assert tot[("P2-EX-01", "CONT")]["total"] == 30.0
    assert tot[("P2-EX-02", "CONT")]["T"] == 6.0
    s = p2.summarize_by_domain(tot)
    assert s["CONT"]["median"] == 25.0
    assert p2.in_thesis_range("CONT", 25.0) and not p2.in_thesis_range("ELEC", 25.0)


def _points(n=30, k=4, scale=2.0, seed=1):
    rng = np.random.default_rng(seed)
    X = rng.normal(0, scale, size=(n, k))
    D = np.sqrt(((X[:, None] - X[None]) ** 2).sum(-1))
    return X, D


def test_classical_mds_recovers_euclidean_configuration():
    X, D = _points()
    coords, w = p2.classical_mds(D, 4)
    Dc = np.sqrt(((coords[:, None] - coords[None]) ** 2).sum(-1))
    assert np.allclose(D, Dc, atol=1e-8)
    assert p2.kruskal_stress(D, coords) < 1e-8
    assert p2.choose_dimensions(D, 0.01) == 4


def test_mds_entropy_matches_covariance_and_unit_shift():
    X, D = _points()
    h1 = p2.mds_entropy(D, 4, unit=1.0)
    Xc = X - X.mean(0)
    expected = 0.5 * np.log2(np.linalg.det(np.cov(Xc, rowvar=False)))
    assert h1 == pytest.approx(expected, abs=1e-8)
    # a unit twice smaller adds k = 4 bits: the estimate is unit-dependent
    assert p2.mds_entropy(D, 4, unit=0.5) == pytest.approx(h1 + 4, abs=1e-8)


def test_dissimilarity_matrix_averages_and_flags_missing():
    ids, D, cnt = p2.dissimilarity_matrix(["a", "a", "b"], ["b", "b", "c"], [2, 4, 6],
                                          ids=["a", "b", "c"])
    assert D[0, 1] == 3 and D[1, 0] == 3 and cnt[0, 1] == 2
    assert np.isnan(D[0, 2])
    with pytest.raises(ValueError):
        p2.classical_mds(D)


def test_bootstrap_over_experts():
    X, D = _points(n=12, k=2, seed=3)
    ids = [f"CTX-{i:03d}" for i in range(12)]
    rng = np.random.default_rng(0)
    e, ci, cj, v = [], [], [], []
    for ex in range(6):
        for a, b in p2.within_domain_pairs(ids):
            i, j = ids.index(a), ids.index(b)
            e.append(f"P2-EX-{ex:02d}"); ci.append(a); cj.append(b)
            v.append(D[i, j] + rng.normal(0, 0.2))
    est, lo, hi = p2.mds_entropy_bootstrap(e, ci, cj, v, ids, n_dims=2, n_boot=100)
    assert lo <= est <= hi
    assert len(p2.within_domain_pairs(ids)) == 66


def test_delphi_rule():
    s = p2.delphi_round_summary([30, 34, 38, 40, 45, np.nan])
    assert s["n"] == 5 and s["median"] == 38 and s["iqr"] == 6
    assert p2.delphi_should_stop(s["iqr"], 2) == (False, "continue")
    assert p2.delphi_should_stop(4.9, 2) == (True, "consensus")
    assert p2.delphi_should_stop(8.0, 4) == (True, "max_rounds")


def test_corpus_matches_protocol():
    import csv
    from pathlib import Path
    root = Path(__file__).resolve().parents[2] / "P2_entropie_contexte"
    rows = list(csv.DictReader((root / "corpus_contextes.csv").open(encoding="utf-8")))
    assert len(rows) == 100 and len({r["id_ctx"] for r in rows}) == 100
    by = {d: [r["id_ctx"] for r in rows if r["domaine"] == d] for d in p2.DOMAINS}
    assert {d: len(v) for d, v in by.items()} == {"ELEC": 34, "FIN": 33, "CONT": 33}
    assert sum(len(p2.within_domain_pairs(v)) for v in by.values()) == 1617
    assert len({r["niveaux"] for r in rows}) == 100
