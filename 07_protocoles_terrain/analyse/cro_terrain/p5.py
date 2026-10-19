"""P5 (measurement of Delta_q): estimators by condition, eta_q by regression, predictions.

Status: PROPOSAL, reference implementation of algorithm
``alg:estimation_delta_q`` (thesis, Chapter 4, section 4.2.5) for a protocol
that has not been deployed.

Scope reminder (thesis, sections 4.2.5.1 and 4.2.6.1): ML-DSA and SLH-DSA
signatures are classical bit strings. For them Delta_q_hat = I(V^q ; Sigma | M, C)
coincides with the classical estimator and eta_q = 0. The noise conditions
B, C, D of phase 2 belong to the HYPOTHETICAL scenario of a quantum medium
or verifier, simulated here by the verification interface
(``noisy_verification_result``).

* Delta_q_hat per noise condition and per aid modality (``delta_q_by_condition``).
* eta_q_hat(p) = [I(V;Sigma|C)_A - I(V;Sigma|C)_p] / H(C)  (eq:estimateur_eta_q
  applied to condition A as reference), then the slope on p
  (``eta_q_regression``), as in line 8 of the algorithm.
* interpretation errors = verdict != gold verdict (``interpretation_errors``).
"""

from __future__ import annotations

from typing import Mapping, Sequence

import numpy as np

from . import information as inf
from .statistics import ols_slope

CONDITIONS = {"A": 0.0, "B": 0.001, "C": 0.01, "D": 0.1}  # thesis, phase 2
STRATA = ("RQJ", "RQS", "ACL", "AEX")  # proposal for tab:stratification_delta_q
PREDICTED = {"RQJ": 28.0, "RQS": 45.0, "ACL": 35.0, "AEX": 67.0}  # bits, thesis table
PREDICTED_RANGE = (28.0, 67.0)  # prediction 3, well-prepared institutions


def depolarizing_flip_probability(p: float) -> float:
    """Probability that a one-qubit verification outcome is read flipped after a
    depolarizing channel rho -> (1 - p) rho + p I/2, i.e. p / 2."""
    if not 0.0 <= p <= 1.0:
        raise ValueError("p must lie in [0, 1]")
    return p / 2.0


def noisy_verification_result(true_result: bool, p: float, rng: np.random.Generator) -> bool:
    """Result displayed by the simulated quantum verifier of the interface."""
    return (not true_result) if rng.random() < depolarizing_flip_probability(p) else true_result


def latin_square_order(participant_index: int, conditions: Sequence[str] = ("A", "B", "C", "D")):
    """Balanced Williams-type order of the 4 conditions for a participant."""
    base = [0, 1, 3, 2]  # Williams design for 4 treatments, first row
    n = len(conditions)
    r = participant_index % n
    return [conditions[(b + r) % n] for b in base]


def _mask(data, **eq):
    m = np.ones(len(data["verdict"]), dtype=bool)
    for k, v in eq.items():
        m &= np.asarray([str(x) == str(v) for x in data[k]])
    return m


def _sel(data, m):
    return {k: np.asarray(v, dtype=object)[m] for k, v in data.items() if not k.startswith("_")}


def delta_q_by_condition(data: Mapping[str, Sequence], aid: str | None = "0",
                         method: str = "mm", alphabet_size: int | None = None) -> dict:
    """Delta_q_hat = I(V^q ; Sigma | M, C) for each noise condition (aid modality fixed)."""
    out = {}
    for cond in CONDITIONS:
        eq = {"noise_condition": cond}
        if aid is not None:
            eq["aid"] = aid
        d = _sel(data, _mask(data, **eq))
        if len(d["verdict"]) == 0:
            continue
        out[cond] = inf.delta_hat(d["verdict"], d["sigma_code"], d["message_m"], d["context_id"],
                                  method=method, alphabet_size=alphabet_size)
    return out


def eta_q_regression(data: Mapping[str, Sequence], h_c: float, aid: str | None = "0",
                     method: str = "mm", alphabet_size: int | None = None) -> dict:
    """eta_q_hat(p) relative to condition A, and slope of eta_q_hat on p."""
    if h_c <= 0:
        raise ValueError("H(C) must be positive")
    i_c = {}
    for cond in CONDITIONS:
        eq = {"noise_condition": cond}
        if aid is not None:
            eq["aid"] = aid
        d = _sel(data, _mask(data, **eq))
        if len(d["verdict"]) == 0:
            continue
        i_c[cond] = inf.conditional_mutual_information(d["verdict"], d["sigma_code"],
                                                       [d["context_id"]], method, alphabet_size)
    if "A" not in i_c:
        raise ValueError("condition A (reference) is missing")
    eta = {c: (i_c["A"] - i) / h_c for c, i in i_c.items()}
    ps = [CONDITIONS[c] for c in eta]
    a0, slope = ols_slope(ps, list(eta.values()))
    return {"i_v_sigma_given_c": i_c, "eta_q": eta, "intercept": a0, "slope_per_unit_p": slope}


def interpretation_errors(data: Mapping[str, Sequence]) -> np.ndarray:
    """1 if the verdict differs from the gold verdict, 0 otherwise, NaN if either is missing."""
    out = []
    for v, g in zip(data["verdict"], data["gold_verdict"]):
        v, g = str(v), str(g)
        out.append(np.nan if v in ("", "nan") or g in ("", "nan") else float(v != g))
    return np.asarray(out, dtype=float)


def error_rate_by_condition(data: Mapping[str, Sequence]) -> dict:
    e = interpretation_errors(data)
    out = {}
    for cond in CONDITIONS:
        m = _mask(data, noise_condition=cond) & np.isfinite(e)
        if m.any():
            out[cond] = float(e[m].mean())
    return out


def check_predictions(delta_q: Mapping[str, float], delta_classical: Mapping[str, float] | None = None,
                      trained: Mapping[str, bool] | None = None,
                      eta_slope: float | None = None, training_corr: float | None = None) -> dict:
    """Descriptive reading of predictions 1 to 5 of section 4.2.5.5.

    ``delta_q`` and ``delta_classical`` map a group to an estimate (bits);
    ``trained`` says whether the group is trained in PQC. Each prediction is
    returned as True/False/None (None when the inputs are missing). The
    confirmatory test of each prediction is fixed in the pre-registration.
    """
    res = {}
    if delta_classical and trained:
        un = [g for g, t in trained.items() if not t and g in delta_q and g in delta_classical]
        tr = [g for g, t in trained.items() if t and g in delta_q and g in delta_classical]
        res["1_untrained_penalty"] = all(delta_q[g] < delta_classical[g] for g in un) if un else None
        res["2_experts_converge"] = (all(abs(delta_q[g] - delta_classical[g]) <= 0.1 * delta_classical[g]
                                         for g in tr) if tr else None)  # 10 % tolerance [to be decided]
    else:
        res["1_untrained_penalty"] = res["2_experts_converge"] = None
    if trained:
        lo, hi = PREDICTED_RANGE
        tr = [g for g, t in trained.items() if t and g in delta_q]
        res["3_range_28_67"] = all(lo <= delta_q[g] <= hi for g in tr) if tr else None
    else:
        res["3_range_28_67"] = None
    res["4_decrease_with_noise"] = None if eta_slope is None else bool(eta_slope > 0)
    res["5_training_correlation"] = None if training_corr is None else bool(training_corr > 0)
    return res
