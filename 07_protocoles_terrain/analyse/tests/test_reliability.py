"""Reliability statistics checked against published worked examples."""

import pytest

from cro_terrain.reliability import (cohen_kappa, fleiss_kappa, fleiss_kappa_from_table, icc_2_1,
                                     reliability_verdict)

# Shrout & Fleiss (1979), Table 2: 6 targets x 4 judges; ICC(2,1) = 0.29
SHROUT_FLEISS = [
    [9, 2, 5, 8],
    [6, 1, 3, 2],
    [8, 4, 6, 8],
    [7, 1, 2, 6],
    [10, 5, 6, 9],
    [6, 2, 4, 7],
]

# Fleiss (1971) worked example as reproduced in many textbooks: kappa = 0.210
FLEISS_TABLE = [
    [0, 0, 0, 0, 14], [0, 2, 6, 4, 2], [0, 0, 3, 5, 6], [0, 3, 9, 2, 0], [2, 2, 8, 1, 1],
    [7, 7, 0, 0, 0], [3, 2, 6, 3, 0], [2, 5, 3, 2, 2], [6, 5, 2, 1, 0], [0, 2, 2, 3, 7],
]


def test_icc_shrout_fleiss():
    assert icc_2_1(SHROUT_FLEISS) == pytest.approx(0.29, abs=0.005)


def test_icc_perfect_test_retest():
    data = [[1, 1], [5, 5], [3, 3], [8, 8]]
    assert icc_2_1(data) == pytest.approx(1.0)


def test_icc_rejects_bad_input():
    with pytest.raises(ValueError):
        icc_2_1([[1, 2]])
    with pytest.raises(ValueError):
        icc_2_1([[1, float("nan")], [2, 3]])


def test_cohen_kappa_textbook():
    # 2x2 table [[20, 5], [10, 15]]: po = 0.70, pe = 0.50 -> kappa = 0.40
    a = ["y"] * 20 + ["y"] * 5 + ["n"] * 10 + ["n"] * 15
    b = ["y"] * 20 + ["n"] * 5 + ["y"] * 10 + ["n"] * 15
    assert cohen_kappa(a, b) == pytest.approx(0.40)


def test_fleiss_kappa_textbook():
    assert fleiss_kappa_from_table(FLEISS_TABLE) == pytest.approx(0.210, abs=0.001)


def test_fleiss_long_format_matches_table():
    subjects, ratings = [], []
    for i, row in enumerate(FLEISS_TABLE):
        for cat, n in enumerate(row):
            subjects += [i] * n
            ratings += [cat] * n
    assert fleiss_kappa(subjects, ratings) == pytest.approx(0.210, abs=0.001)


def test_thresholds():
    r = reliability_verdict(icc=0.85, kappa=0.65)
    assert r["icc"]["satisfied"] and not r["kappa"]["satisfied"]
