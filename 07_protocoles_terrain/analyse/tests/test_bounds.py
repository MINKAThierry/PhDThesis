"""Refined bounds checked against the values printed in the thesis (chapter 2)."""

import pytest

from cro_terrain.bounds import (borne_explicite, borne_raffinee, borne_raffinee_pq, fano_factor,
                                gamma_classical, gamma_pq, h_sharp, h_sharp_q, majorant_affaibli_pq,
                                report_classical, report_pq)


def test_figure_cro_bound_point_lambda_128():
    # fig:cro_bound: Delta = 5, alpha = 1, H(C) = 20 (gamma = 19), kappa = 1, lambda = 128
    # refined: ordinate 0.830 on a scale where 2.0 <-> 0.005, i.e. 0.002075
    assert borne_raffinee(128, 1, 5, 1.0, 20) == pytest.approx(0.830 * 0.0025, rel=0.01)
    # Fano: ordinate 3.149 -> 0.007873
    assert fano_factor(128, 1) == pytest.approx(3.149 * 0.0025, rel=0.01)


def test_refined_equals_fano_when_capacity_exceeds_gamma():
    assert borne_raffinee(128, 1, 40, 1.0, 20) == pytest.approx(fano_factor(128, 1))


def test_zksnark_ratio_to_fano():
    # subsubsec:regime_haute_contexte: Delta = 73, alpha = 1.5, H(C) = 70, gamma = 104,
    # "la borne vaut environ 0,70 fois la borne de Fano"
    assert gamma_classical(1.5, 70) == pytest.approx(104)
    ratio = borne_raffinee(128, 1, 73, 1.5, 70) / fano_factor(128, 1)
    assert ratio == pytest.approx(0.70, abs=0.01)


def test_h_sharp_thesis_examples():
    assert h_sharp(35, 1.0, 1, 128) == pytest.approx(36, abs=0.1)   # contract
    assert h_sharp(56, 1.2, 1, 128) == pytest.approx(48, abs=0.6)   # election
    assert h_sharp(73, 1.5, 1, 128) == pytest.approx(49, abs=0.5)   # zk-SNARK
    assert report_classical(128, 1, 73, 1.5, 70).binding == "capacity"
    assert report_classical(128, 1, 35, 1.0, 20).binding == "fano"


def test_refined_implies_explicit():
    g = gamma_classical(1.5, 70)
    assert borne_raffinee(128, 1, 73, 1.5, 70) <= borne_explicite(128, 1, 73, g) + 1e-15


def test_pq_bound_has_no_eta_and_matches_classical_shape():
    g = gamma_pq(0.5, 1.0, 40)
    assert g == pytest.approx(20)
    b = borne_raffinee_pq(192, 1, 10, 0.5, 1.0, 40)
    assert b == pytest.approx(fano_factor(192, 1) * (1 / 192 + 10) / 20)
    assert h_sharp_q(10, 0.5, 1.0, 1, 192) == pytest.approx((10 + 1 / 192) / 0.5)
    assert report_pq(192, 1, 10, 0.5, 1.0, 40).binding == "capacity"
    # weakened majorant contains eta_q H(C)
    assert majorant_affaibli_pq(192, 10, 0.05, 40) == pytest.approx((10 + 2) / 192)


def test_hypothesis_checks():
    with pytest.raises(ValueError):
        borne_raffinee(128, 1, 5, 0.1, 5)       # gamma = -0.5 < 1
    with pytest.raises(ValueError):
        borne_raffinee(32, 1, 5, 1.0, 20)       # lambda < 64
    with pytest.raises(ValueError):
        borne_raffinee_pq(128, 1, 5, 0.1, 1.0, 5)  # gamma_q = 0.5 < 1
