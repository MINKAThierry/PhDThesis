"""P2 (measurement of H(C)): structural decomposition, MDS volume, Delphi.

Status: PROPOSAL, reference implementation for a protocol that has not been
deployed. Thesis, Chapter 4, section 4.2.2:

* Approach 1 (structural decomposition): H(C) = H(L) + H(T|L) + H(R|L,T),
  summed over elements under approximate independence; an element with k
  equiprobable categories contributes log2 k bits.
* Approach 2 (MDS): dissimilarity matrix D, classical MDS, effective volume
  V_eff = det(Sigma_hat)^(1/2), H(C) ~ log2 V_eff.
* Approach 3 (Delphi): up to four rounds, stop when IQR < 5 bits; the value
  kept is the median of the last round.

Caveat implemented and tested here: log2 V_eff depends on the unit of the
dissimilarity scale and on the number of MDS dimensions kept. Changing the
unit by a factor s shifts the estimate by -k log2 s bits for k dimensions.
Both choices must be fixed before data collection (analysis plan, 8.2).
"""

from __future__ import annotations

from collections import defaultdict
from typing import Iterable, Mapping, Sequence

import numpy as np

DOMAINS = ("ELEC", "FIN", "CONT")
COMPONENTS = ("L", "T", "R")
# Thesis, table tab:estimations_structurelles_HC (domain-level H(C), bits).
THESIS_RANGES = {"ELEC": (30.0, 50.0), "FIN": (40.0, 70.0), "CONT": (20.0, 40.0)}
DELPHI_IQR_STOP_BITS = 5.0
DELPHI_MAX_ROUNDS = 4


# ---------------------------------------------------------------------------
# Approach 1: structural decomposition
# ---------------------------------------------------------------------------

def element_entropy(n_categories: int | None = None,
                    probabilities: Sequence[float] | None = None) -> float:
    """Entropy in bits of one element: log2 k, or -sum p log2 p if probabilities are given."""
    if probabilities is not None:
        p = np.asarray(probabilities, dtype=float)
        if np.any(p < 0) or not np.isclose(p.sum(), 1.0):
            raise ValueError("probabilities must be non-negative and sum to 1")
        p = p[p > 0]
        return float(-(p * np.log2(p)).sum())
    if n_categories is None or int(n_categories) < 1:
        raise ValueError("n_categories must be >= 1")
    return float(np.log2(int(n_categories)))


def decomposition_totals(expert_ids, domains, components, entropies) -> dict:
    """Sum of element entropies per (expert, domain), with the L/T/R split.

    Returns {(expert, domain): {"L": .., "T": .., "R": .., "total": ..}}.
    """
    out: dict = defaultdict(lambda: {c: 0.0 for c in COMPONENTS} | {"total": 0.0})
    for e, d, c, h in zip(expert_ids, domains, components, entropies):
        if c not in COMPONENTS:
            raise ValueError(f"unknown component {c!r}")
        if not np.isfinite(h):
            continue
        out[(e, d)][c] += float(h)
        out[(e, d)]["total"] += float(h)
    return dict(out)


def median_iqr(values: Iterable[float]) -> tuple[float, float, float, float]:
    """(median, q1, q3, iqr) with linear interpolation (numpy default)."""
    v = np.asarray([x for x in values if np.isfinite(x)], dtype=float)
    if v.size == 0:
        return (float("nan"),) * 4
    q1, med, q3 = np.percentile(v, [25, 50, 75])
    return float(med), float(q1), float(q3), float(q3 - q1)


def summarize_by_domain(totals: Mapping) -> dict:
    """Median and IQR of the experts' totals, per domain."""
    per = defaultdict(list)
    for (_, d), t in totals.items():
        per[d].append(t["total"])
    return {d: dict(zip(("median", "q1", "q3", "iqr"), median_iqr(v))) for d, v in per.items()}


# ---------------------------------------------------------------------------
# Approach 2: MDS
# ---------------------------------------------------------------------------

def dissimilarity_matrix(ctx_i, ctx_j, values, ids: Sequence[str] | None = None):
    """Average the judged dissimilarities into a symmetric matrix.

    Returns (ids, D, counts). Missing pairs are NaN in D and 0 in counts.
    """
    ctx_i = [str(x) for x in ctx_i]
    ctx_j = [str(x) for x in ctx_j]
    if ids is None:
        ids = sorted(set(ctx_i) | set(ctx_j))
    idx = {c: k for k, c in enumerate(ids)}
    n = len(ids)
    s = np.zeros((n, n))
    cnt = np.zeros((n, n), dtype=int)
    for a, b, v in zip(ctx_i, ctx_j, values):
        if a == b or not np.isfinite(v):
            continue
        i, j = idx[a], idx[b]
        s[i, j] += v
        s[j, i] += v
        cnt[i, j] += 1
        cnt[j, i] += 1
    with np.errstate(invalid="ignore", divide="ignore"):
        D = np.where(cnt > 0, s / np.maximum(cnt, 1), np.nan)
    np.fill_diagonal(D, 0.0)
    return list(ids), D, cnt


def classical_mds(D: np.ndarray, n_dims: int | None = None):
    """Torgerson classical MDS. Returns (coords, eigenvalues sorted decreasingly)."""
    D = np.asarray(D, dtype=float)
    if np.isnan(D).any():
        raise ValueError("dissimilarity matrix has missing pairs")
    n = D.shape[0]
    J = np.eye(n) - np.ones((n, n)) / n
    B = -0.5 * J @ (D ** 2) @ J
    w, V = np.linalg.eigh(B)
    order = np.argsort(w)[::-1]
    w, V = w[order], V[:, order]
    pos = int((w > 1e-9 * max(1.0, abs(w[0]))).sum())
    k = pos if n_dims is None else min(n_dims, pos)
    coords = V[:, :k] * np.sqrt(w[:k])
    return coords, w


def kruskal_stress(D: np.ndarray, coords: np.ndarray) -> float:
    """Kruskal stress-1 between D and the Euclidean distances of coords."""
    diff = coords[:, None, :] - coords[None, :, :]
    d = np.sqrt((diff ** 2).sum(-1))
    iu = np.triu_indices(D.shape[0], 1)
    return float(np.sqrt(((D[iu] - d[iu]) ** 2).sum() / (D[iu] ** 2).sum()))


def choose_dimensions(D: np.ndarray, stress_max: float, k_max: int | None = None) -> int:
    """Smallest number of dimensions whose Kruskal stress is <= stress_max."""
    _, w = classical_mds(D)
    pos = int((w > 1e-9 * max(1.0, abs(w[0]))).sum())
    k_max = pos if k_max is None else min(k_max, pos)
    for k in range(1, k_max + 1):
        coords, _ = classical_mds(D, k)
        if kruskal_stress(D, coords) <= stress_max:
            return k
    return k_max


def mds_entropy(D: np.ndarray, n_dims: int, unit: float = 1.0) -> float:
    """H(C) ~ log2 V_eff with V_eff = det(Sigma_hat)^(1/2) of the MDS coordinates.

    ``unit`` is the length on the dissimilarity scale taken as one
    distinguishable step (analysis plan 8.2, point 4).
    """
    if unit <= 0:
        raise ValueError("unit must be positive")
    coords, _ = classical_mds(D, n_dims)
    if coords.shape[1] < n_dims:
        raise ValueError("not enough positive eigenvalues for n_dims")
    cov = np.atleast_2d(np.cov(coords / unit, rowvar=False))
    sign, logdet = np.linalg.slogdet(cov)
    if sign <= 0:
        raise ValueError("degenerate covariance")
    return float(0.5 * logdet / np.log(2))


def mds_entropy_bootstrap(expert_ids, ctx_i, ctx_j, values, ids, n_dims: int,
                          unit: float = 1.0, n_boot: int = 500, seed: int = 0):
    """Bootstrap over experts of the MDS estimate. Returns (estimate, low95, high95)."""
    expert_ids = np.asarray([str(e) for e in expert_ids])
    ctx_i, ctx_j = np.asarray(ctx_i), np.asarray(ctx_j)
    values = np.asarray(values, dtype=float)
    experts = np.unique(expert_ids)
    _, D, _ = dissimilarity_matrix(ctx_i, ctx_j, values, ids)
    est = mds_entropy(D, n_dims, unit)
    rng = np.random.default_rng(seed)
    boots = []
    for _ in range(n_boot):
        draw = rng.choice(experts, size=len(experts), replace=True)
        sel = np.concatenate([np.flatnonzero(expert_ids == e) for e in draw])
        _, Db, _ = dissimilarity_matrix(ctx_i[sel], ctx_j[sel], values[sel], ids)
        if np.isnan(Db).any():
            continue
        try:
            boots.append(mds_entropy(Db, n_dims, unit))
        except ValueError:
            continue
    lo, hi = np.percentile(boots, [2.5, 97.5]) if boots else (np.nan, np.nan)
    return est, float(lo), float(hi)


def within_domain_pairs(ids: Sequence[str]) -> list[tuple[str, str]]:
    """All unordered pairs of a list of context ids (one domain)."""
    return [(ids[a], ids[b]) for a in range(len(ids)) for b in range(a + 1, len(ids))]


# ---------------------------------------------------------------------------
# Approach 3: Delphi
# ---------------------------------------------------------------------------

def delphi_round_summary(estimates: Iterable[float]) -> dict:
    """Anonymous feedback of one round for one domain: n, median, quartiles, IQR, range."""
    v = np.asarray([x for x in estimates if np.isfinite(x)], dtype=float)
    med, q1, q3, iqr = median_iqr(v)
    return {"n": int(v.size), "median": med, "q1": q1, "q3": q3, "iqr": iqr,
            "min": float(v.min()) if v.size else float("nan"),
            "max": float(v.max()) if v.size else float("nan")}


def delphi_should_stop(iqr: float, round_number: int,
                       threshold: float = DELPHI_IQR_STOP_BITS,
                       max_rounds: int = DELPHI_MAX_ROUNDS) -> tuple[bool, str]:
    """Stopping rule of the thesis: IQR < 5 bits, at most four rounds."""
    if np.isfinite(iqr) and iqr < threshold:
        return True, "consensus"
    if round_number >= max_rounds:
        return True, "max_rounds"
    return False, "continue"


def in_thesis_range(domain: str, value: float) -> bool:
    lo, hi = THESIS_RANGES[domain]
    return lo <= value <= hi
