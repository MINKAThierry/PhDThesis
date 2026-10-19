"""Reliability statistics required by the validation step of the protocols.

Thesis references: chapter 4, alg:estimation_conjointe, step 6
(ICC >= 0.8 for test-retest, kappa >= 0.7 for inter-rater agreement).

* ICC(2,1): two-way random effects, absolute agreement, single measurement
  (Shrout & Fleiss 1979; McGraw & Wong 1996, "ICC(A,1)").
* Cohen's kappa: two raters, nominal categories.
* Fleiss' kappa: any fixed number of raters per subject, nominal categories.
"""

from __future__ import annotations

from collections import Counter
from typing import Sequence

import numpy as np

ICC_THRESHOLD = 0.8
KAPPA_THRESHOLD = 0.7


def icc_2_1(ratings: Sequence[Sequence[float]]) -> float:
    """ICC(2,1) for an n x k matrix (n targets, k raters or occasions).

    For test-retest reliability, the k = 2 columns are the two sessions
    (T1, T2). Rows with missing values must be removed beforehand.
    """
    y = np.asarray(ratings, dtype=float)
    if y.ndim != 2 or y.shape[0] < 2 or y.shape[1] < 2:
        raise ValueError("ratings must be an n x k matrix with n >= 2 and k >= 2")
    if not np.all(np.isfinite(y)):
        raise ValueError("ratings contain missing values")
    n, k = y.shape
    grand = y.mean()
    row_m = y.mean(axis=1)
    col_m = y.mean(axis=0)
    msr = k * np.sum((row_m - grand) ** 2) / (n - 1)
    msc = n * np.sum((col_m - grand) ** 2) / (k - 1)
    resid = y - row_m[:, None] - col_m[None, :] + grand
    mse = np.sum(resid ** 2) / ((n - 1) * (k - 1))
    den = msr + (k - 1) * mse + k * (msc - mse) / n
    if den == 0:
        return float("nan")
    return float((msr - mse) / den)


def cohen_kappa(rater_a: Sequence, rater_b: Sequence) -> float:
    """Cohen's kappa between two raters over the same subjects."""
    a = list(rater_a)
    b = list(rater_b)
    if len(a) != len(b) or not a:
        raise ValueError("both raters must rate the same non-empty list of subjects")
    n = len(a)
    po = sum(1 for x, y in zip(a, b) if x == y) / n
    ca, cb = Counter(a), Counter(b)
    pe = sum(ca[c] * cb.get(c, 0) for c in ca) / (n * n)
    if pe == 1.0:
        return float("nan")
    return float((po - pe) / (1.0 - pe))


def fleiss_kappa_from_table(table: Sequence[Sequence[int]]) -> float:
    """Fleiss' kappa from an N x q table of counts (subjects x categories).

    Every row must sum to the same number of raters r >= 2.
    """
    t = np.asarray(table, dtype=float)
    r = t.sum(axis=1)
    if not np.allclose(r, r[0]) or r[0] < 2:
        raise ValueError("every subject must be rated by the same number (>= 2) of raters")
    r = r[0]
    N = t.shape[0]
    p_j = t.sum(axis=0) / (N * r)
    P_i = (np.sum(t * t, axis=1) - r) / (r * (r - 1))
    p_bar = P_i.mean()
    pe = np.sum(p_j ** 2)
    if pe == 1.0:
        return float("nan")
    return float((p_bar - pe) / (1.0 - pe))


def fleiss_kappa(subjects: Sequence, ratings: Sequence) -> float:
    """Fleiss' kappa from long-format data (one row per (subject, rating)).

    Subjects rated by a number of raters different from the modal number are
    dropped (Fleiss' kappa requires a constant number of raters).
    """
    subj = list(subjects)
    rat = list(ratings)
    cats = sorted(set(rat), key=str)
    per: dict = {}
    for s, x in zip(subj, rat):
        per.setdefault(s, Counter())[x] += 1
    sizes = Counter(sum(c.values()) for c in per.values())
    r = sizes.most_common(1)[0][0]
    rows = [[c[k] for k in cats] for c in per.values() if sum(c.values()) == r]
    return fleiss_kappa_from_table(rows)


def reliability_verdict(icc: float | None = None, kappa: float | None = None) -> dict:
    """Compare the statistics with the thesis thresholds (ICC >= 0.8, kappa >= 0.7)."""
    out = {}
    if icc is not None:
        out["icc"] = {"value": icc, "threshold": ICC_THRESHOLD,
                      "satisfied": bool(np.isfinite(icc) and icc >= ICC_THRESHOLD)}
    if kappa is not None:
        out["kappa"] = {"value": kappa, "threshold": KAPPA_THRESHOLD,
                        "satisfied": bool(np.isfinite(kappa) and kappa >= KAPPA_THRESHOLD)}
    return out
