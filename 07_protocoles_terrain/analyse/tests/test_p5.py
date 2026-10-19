"""P5: Delta_q by noise condition, eta_q by regression, verifier noise model, predictions."""

from collections import Counter

import numpy as np
import pytest

from cro_terrain import p5
from cro_terrain.simulate import ExtractionModel, simulate_extraction


def _p5_data(seed=0):
    parts = []
    for k, (cond, p) in enumerate(p5.CONDITIONS.items()):
        m = ExtractionModel(leak=0.6, rho_s=0.5, noise=min(0.05 + 5 * p, 1.0))
        d = simulate_extraction(m, 80, 40, seed=seed + k)
        n = len(d["verdict"])
        d["noise_condition"] = np.asarray([cond] * n, dtype=object)
        d["aid"] = np.asarray(["0"] * n, dtype=object)
        d["gold_verdict"] = np.asarray(["1"] * n, dtype=object)
        parts.append(d)
    return {k: np.concatenate([d[k] for d in parts]) for k in parts[0]}


def test_flip_probability_and_display():
    assert p5.depolarizing_flip_probability(0.1) == pytest.approx(0.05)
    rng = np.random.default_rng(0)
    shown = [p5.noisy_verification_result(True, 0.1, rng) for _ in range(20000)]
    assert abs(1 - np.mean(shown) - 0.05) < 0.01
    assert all(p5.noisy_verification_result(True, 0.0, rng) for _ in range(100))
    with pytest.raises(ValueError):
        p5.depolarizing_flip_probability(1.5)


def test_latin_square_balanced():
    orders = [tuple(p5.latin_square_order(i)) for i in range(4)]
    for pos in range(4):
        assert Counter(o[pos] for o in orders) == Counter("ABCD")
    # each condition immediately precedes each other condition once (Williams)
    pairs = Counter((o[i], o[i + 1]) for o in orders for i in range(3))
    assert len(pairs) == 12 and set(pairs.values()) == {1}


def test_delta_q_decreases_and_eta_slope_positive():
    d = _p5_data()
    dq = p5.delta_q_by_condition(d, alphabet_size=4)
    assert set(dq) == set("ABCD")
    assert dq["A"] > dq["D"]
    reg = p5.eta_q_regression(d, h_c=10.5, alphabet_size=4)
    assert reg["eta_q"]["A"] == 0.0
    assert reg["slope_per_unit_p"] > 0
    pred = p5.check_predictions(dq, eta_slope=reg["slope_per_unit_p"])
    assert pred["4_decrease_with_noise"] is True and pred["1_untrained_penalty"] is None


def test_interpretation_errors_and_predictions():
    d = {"verdict": ["1", "2", "", "3"], "gold_verdict": ["1", "1", "1", ""],
         "noise_condition": ["A", "A", "B", "B"]}
    e = p5.interpretation_errors(d)
    assert e[0] == 0 and e[1] == 1 and np.isnan(e[2]) and np.isnan(e[3])
    assert p5.error_rate_by_condition(d) == {"A": 0.5}
    pred = p5.check_predictions({"RQJ": 20.0, "AEX": 60.0}, {"RQJ": 25.0, "AEX": 62.0},
                                {"RQJ": False, "AEX": True}, training_corr=0.3)
    assert pred["1_untrained_penalty"] and pred["2_experts_converge"]
    assert pred["3_range_28_67"] and pred["5_training_correlation"]
