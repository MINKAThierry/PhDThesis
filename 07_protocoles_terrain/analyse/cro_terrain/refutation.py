"""Pre-registered refutation criteria (thesis tab:criteres_refutation, §4.2.7.3)
and the Helios agreement criterion (§4.2.3.5).

Every function returns a ``Decision`` whose ``status`` is one of

* ``"refuted"``      : the criterion of tab:criteres_refutation is met;
* ``"not_refuted"``  : the data were analysable and the criterion is not met;
* ``"not_probative"``: the comparison cannot be made (hypotheses not verified,
                       missing input, undefined estimate).

The thresholds are indicative in the thesis and must be fixed at
pre-registration; the *form* of each criterion is what this module encodes.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Mapping

import numpy as np

from .bounds import borne_raffinee, borne_raffinee_pq

REFUTED = "refuted"
NOT_REFUTED = "not_refuted"
NOT_PROBATIVE = "not_probative"


@dataclass
class Decision:
    criterion: str
    status: str
    detail: str
    values: dict = field(default_factory=dict)


def _finite(*xs) -> bool:
    return all(x is not None and np.isfinite(x) for x in xs)


def criterion_delta(cmi_ci_low: float, delta_prereg: float) -> Decision:
    """Delta (Hyp. 1): refuted if the lower 95% CI bound of I(V;Sigma|M,C)
    exceeds the capacity fixed before the experiment."""
    if not _finite(cmi_ci_low, delta_prereg):
        return Decision("delta", NOT_PROBATIVE, "missing input", {})
    st = REFUTED if cmi_ci_low > delta_prereg else NOT_REFUTED
    return Decision("delta", st, f"CI low {cmi_ci_low:.4g} vs pre-registered Delta {delta_prereg:.4g}",
                    {"ci_low": cmi_ci_low, "delta_prereg": delta_prereg})


def criterion_admissibility(p_value: float, n_informative_strata: int | None = None,
                            threshold: float = 0.01) -> Decision:
    """Admissibility (def:interp_admissible): refuted if a permutation test
    rejects V independent of M given (Sigma, C) at the 0.01 level."""
    if n_informative_strata == 0:
        return Decision("admissibility", NOT_PROBATIVE,
                        "M constant within every (Sigma, C) stratum: not testable", {})
    if not _finite(p_value):
        return Decision("admissibility", NOT_PROBATIVE, "missing input", {})
    st = REFUTED if p_value < threshold else NOT_REFUTED
    return Decision("admissibility", st, f"p = {p_value:.4g} (threshold {threshold})",
                    {"p_value": p_value, "threshold": threshold})


def criterion_gamma(h_ci_high: float, alpha: float, h_c: float) -> Decision:
    """gamma (Hyp. 2'): refuted if the upper 95% CI bound of H(V|C) is below
    alpha H(C) - 1."""
    if not _finite(h_ci_high, alpha, h_c):
        return Decision("gamma", NOT_PROBATIVE, "missing input", {})
    g = alpha * h_c - 1.0
    st = REFUTED if h_ci_high < g else NOT_REFUTED
    return Decision("gamma", st, f"CI high of H(V|C) {h_ci_high:.4g} vs gamma {g:.4g}",
                    {"h_ci_high": h_ci_high, "gamma": g})


def criterion_eta_q(eta_ci: tuple[float, float], predicted: tuple[float, float]) -> Decision:
    """eta_q (quantum scenario): refuted if the 95% CI of eta_q_hat excludes the
    interval predicted before the experiment (the two intervals are disjoint)."""
    lo, hi = eta_ci
    plo, phi = predicted
    if not _finite(lo, hi, plo, phi):
        return Decision("eta_q", NOT_PROBATIVE, "missing input", {})
    disjoint = hi < plo or lo > phi
    st = REFUTED if disjoint else NOT_REFUTED
    return Decision("eta_q", st, f"CI [{lo:.4g}, {hi:.4g}] vs predicted [{plo:.4g}, {phi:.4g}]",
                    {"ci": (lo, hi), "predicted": (plo, phi)})


def criterion_bound(product_ci_low: float, bound: float, hypotheses_verified: bool) -> Decision:
    """Bound: refuted if, hypotheses verified, the measured product exceeds the
    refined bound with 95% confidence (lower CI bound of the product > bound)."""
    if not hypotheses_verified:
        return Decision("bound", NOT_PROBATIVE,
                        "hypotheses of the theorem not verified: no comparison is probative "
                        "(rem:portee_cas_etude)", {"bound": bound})
    if not _finite(product_ci_low, bound):
        return Decision("bound", NOT_PROBATIVE, "missing input", {})
    st = REFUTED if product_ci_low > bound else NOT_REFUTED
    return Decision("bound", st, f"product CI low {product_ci_low:.4g} vs refined bound {bound:.4g}",
                    {"product_ci_low": product_ci_low, "bound": bound})


def confront_bound(product_ci_low: float, hypotheses_verified: bool, *, lam: float, kappa: float,
                   capacity: float, h_c: float, alpha: float | None = None,
                   theta_q: float | None = None, alpha_q: float | None = None) -> Decision:
    """Compute the refined bound (classical if ``alpha`` is given, PQ if
    ``theta_q`` and ``alpha_q`` are given) and apply ``criterion_bound``."""
    if alpha is not None:
        b = borne_raffinee(lam, kappa, capacity, alpha, h_c)
    elif theta_q is not None and alpha_q is not None:
        b = borne_raffinee_pq(lam, kappa, capacity, theta_q, alpha_q, h_c)
    else:
        raise ValueError("give alpha (classical) or theta_q and alpha_q (post-quantum)")
    return criterion_bound(product_ci_low, b, hypotheses_verified)


# ---------------------------------------------------------------------------
# Helios: agreement with Opp_predicted = 0.50 (§4.2.3.5)
# ---------------------------------------------------------------------------

def criterion_opp_helios(opp: float, ci: tuple[float, float], predicted: float = 0.50,
                         tolerance: float = 0.05) -> Decision:
    """Thesis rule: agreement if |Opp_emp - 0.50| <= 0.05; disagreement (the
    value 0.50 and the uniformity hypothesis behind it are refuted) if 0.50
    lies outside the 95% bootstrap CI of Opp_emp.

    The two conditions are not exclusive. This function reports both flags and
    a combined label; the priority rule when both hold
    ("agreement_with_significant_gap") is [to be decided by the team].
    """
    lo, hi = ci
    if not _finite(opp, lo, hi):
        return Decision("opp_helios", NOT_PROBATIVE, "Opp_emp undefined (H(V|C) = 0?)", {})
    close = abs(opp - predicted) <= tolerance
    outside = predicted < lo or predicted > hi
    if close and not outside:
        label = "agreement"
    elif outside and not close:
        label = "disagreement"
    elif close and outside:
        label = "agreement_with_significant_gap"
    else:
        label = "inconclusive"
    st = REFUTED if label == "disagreement" else NOT_REFUTED
    return Decision("opp_helios", st, label,
                    {"opp": opp, "ci": (lo, hi), "predicted": predicted, "tolerance": tolerance,
                     "within_tolerance": close, "predicted_outside_ci": outside, "label": label})


def apply_criteria(results: Mapping) -> list[Decision]:
    """Apply every criterion for which ``results`` provides the inputs.

    Recognised keys (all optional):
      delta_ci_low, delta_prereg
      admissibility_p, admissibility_informative_strata
      h_v_c_ci_high, alpha, h_c
      eta_ci, eta_predicted
      product_ci_low, hypotheses_verified, lam, kappa, capacity,
      (alpha | theta_q, alpha_q)
      opp, opp_ci
    """
    r = dict(results)
    out: list[Decision] = []
    if "delta_ci_low" in r and "delta_prereg" in r:
        out.append(criterion_delta(r["delta_ci_low"], r["delta_prereg"]))
    if "admissibility_p" in r:
        out.append(criterion_admissibility(r["admissibility_p"],
                                           r.get("admissibility_informative_strata")))
    if "h_v_c_ci_high" in r and "alpha" in r and "h_c" in r:
        out.append(criterion_gamma(r["h_v_c_ci_high"], r["alpha"], r["h_c"]))
    if "eta_ci" in r and "eta_predicted" in r:
        out.append(criterion_eta_q(tuple(r["eta_ci"]), tuple(r["eta_predicted"])))
    if "product_ci_low" in r:
        try:
            out.append(confront_bound(r["product_ci_low"], bool(r.get("hypotheses_verified", False)),
                                      lam=r["lam"], kappa=r["kappa"], capacity=r["capacity"],
                                      h_c=r["h_c"], alpha=r.get("alpha") if "theta_q" not in r else None,
                                      theta_q=r.get("theta_q"), alpha_q=r.get("alpha_q")))
        except (KeyError, ValueError) as exc:
            out.append(Decision("bound", NOT_PROBATIVE, f"cannot evaluate the bound: {exc}", {}))
    if "opp" in r and "opp_ci" in r:
        out.append(criterion_opp_helios(r["opp"], tuple(r["opp_ci"])))
    return out
