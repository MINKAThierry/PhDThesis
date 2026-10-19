"""Resampling procedures: admissibility permutation test and cluster bootstrap.

Thesis references: chapter 4, alg:estimation_delta (line 6),
alg:estimation_conjointe (step 3), tab:criteres_refutation (admissibility row,
threshold 0.01), and the participant-level bootstrap required in
subsubsec:objectif_delta.
"""

from __future__ import annotations

from collections import defaultdict
from dataclasses import dataclass
from typing import Callable, Mapping, Sequence

import numpy as np

from .information import conditional_mutual_information, joint_labels


# ---------------------------------------------------------------------------
# Admissibility: V independent of M given (Sigma, C)
# ---------------------------------------------------------------------------

@dataclass
class PermutationResult:
    statistic: float          # plug-in I(V ; M | Sigma, C) on the observed data
    p_value: float            # (1 + #{T_perm >= T_obs}) / (1 + n_perm)
    n_perm: int
    n_informative_strata: int  # strata of (Sigma, C) in which M takes >= 2 values

    def rejects(self, threshold: float = 0.01) -> bool:
        return self.p_value < threshold


def admissibility_permutation_test(verdict: Sequence, message: Sequence, sigma: Sequence,
                                   context: Sequence | None = None, n_perm: int = 999,
                                   seed: int | None = None) -> PermutationResult:
    """Conditional permutation test of V independent of M given (Sigma, C).

    The statistic is the plug-in estimate of I(V ; M | Sigma, C). Under the
    null hypothesis, M is exchangeable within each stratum of (Sigma, C), so
    M is permuted inside the strata and the statistic recomputed.

    The test only has power in strata where M takes at least two values; the
    number of such strata is returned so that the analyst can report it. If
    every stratum is uninformative, the test cannot reject (p = 1), which must
    be reported as "not testable with this coding of Sigma", not as evidence
    of admissibility.
    """
    v = list(verdict)
    m = np.asarray(list(message), dtype=object)
    strata_cols = [sigma] if context is None else [sigma, context]
    strata = joint_labels(*strata_cols)
    groups: dict = defaultdict(list)
    for i, s in enumerate(strata):
        groups[s].append(i)
    groups_idx = [np.asarray(ix) for ix in groups.values()]
    informative = sum(1 for ix in groups_idx if len(set(m[ix].tolist())) > 1)

    def stat(mm) -> float:
        return conditional_mutual_information(v, list(mm), [strata], method="plugin")

    t_obs = stat(m)
    if informative == 0:
        return PermutationResult(t_obs, 1.0, 0, 0)
    rng = np.random.default_rng(seed)
    exceed = 0
    for _ in range(n_perm):
        mp = m.copy()
        for ix in groups_idx:
            if len(ix) > 1:
                mp[ix] = m[ix][rng.permutation(len(ix))]
        if stat(mp) >= t_obs - 1e-12:
            exceed += 1
    return PermutationResult(t_obs, (1 + exceed) / (1 + n_perm), n_perm, informative)


# ---------------------------------------------------------------------------
# Cluster (participant-level) bootstrap
# ---------------------------------------------------------------------------

@dataclass
class BootstrapResult:
    estimate: float
    low: float
    high: float
    level: float
    samples: np.ndarray
    n_clusters: int

    def as_tuple(self) -> tuple[float, float, float]:
        return self.estimate, self.low, self.high


def subset(data: Mapping[str, Sequence], index: np.ndarray) -> dict:
    """Return a new column dict restricted to (and ordered by) ``index``."""
    return {k: np.asarray(v, dtype=object)[index] for k, v in data.items()}


def cluster_bootstrap(data: Mapping[str, Sequence], statistic: Callable[[dict], float],
                      cluster: str, n_boot: int = 2000, level: float = 0.95,
                      seed: int | None = None, relabel: bool = True) -> BootstrapResult:
    """Non-parametric percentile bootstrap resampling whole clusters.

    ``cluster`` is the name of the column identifying the resampling unit
    (participant / trustee). Each replicate draws as many clusters as observed,
    with replacement, and keeps all rows of each drawn cluster. Replicates for
    which the statistic is not finite are discarded (their number is visible
    through ``len(samples)``).

    With ``relabel=True`` (default) every drawn copy of a cluster receives a
    distinct label in the ``cluster`` column. This matters when the cluster
    column is also an analysis variable: resampling the *proofs* of the
    Helios audit (cluster = proof_id) must treat two copies of the same proof
    as two distinct values of Sigma.

    Caveat for the Helios audit. When Sigma is the proof identifier and every
    trustee rates every proof, resampling *trustees* duplicates identical
    (proof, verdict) pairs and inflates the apparent dependence between V and
    Sigma; the percentile interval is then shifted upwards. P3 therefore
    reports the bootstrap over proofs next to the participant bootstrap
    required by the thesis [to be decided by the team].

    With few clusters (e.g. the 10 trustees of the Helios audit) the
    percentile interval is coarse; the protocols report the number of clusters
    next to every interval.
    """
    # metadata entries (keys starting with "_", e.g. "_language") are not columns
    cols = {k: np.asarray(v, dtype=object) for k, v in data.items() if not k.startswith("_")}
    ids = cols[cluster]
    groups: dict = defaultdict(list)
    for i, g in enumerate(ids.tolist()):
        groups[g].append(i)
    keys = list(groups.keys())
    idx_by_key = [np.asarray(groups[k]) for k in keys]
    est = float(statistic(cols))
    rng = np.random.default_rng(seed)
    out = []
    for _ in range(n_boot):
        draw = rng.integers(0, len(keys), size=len(keys))
        index = np.concatenate([idx_by_key[j] for j in draw])
        rep = subset(cols, index)
        if relabel:
            rep[cluster] = np.asarray([f"{keys[j]}#{r}" for r, j in enumerate(draw)
                                       for _ in range(len(idx_by_key[j]))], dtype=object)
        val = float(statistic(rep))
        if np.isfinite(val):
            out.append(val)
    samples = np.asarray(out)
    a = (1.0 - level) / 2.0
    if samples.size == 0:
        lo = hi = float("nan")
    else:
        lo, hi = np.quantile(samples, [a, 1.0 - a])
    return BootstrapResult(est, float(lo), float(hi), level, samples, len(keys))


# ---------------------------------------------------------------------------
# Regression on noise levels (Delta_q, eta_q)
# ---------------------------------------------------------------------------

def slope_through_origin(x: Sequence[float], y: Sequence[float]) -> float:
    """Least-squares slope of y = b x (no intercept)."""
    x = np.asarray(x, dtype=float)
    y = np.asarray(y, dtype=float)
    den = float(np.sum(x * x))
    if den == 0:
        return float("nan")
    return float(np.sum(x * y) / den)


def ols_slope(x: Sequence[float], y: Sequence[float]) -> tuple[float, float]:
    """Ordinary least squares y = a + b x; returns (a, b)."""
    x = np.asarray(x, dtype=float)
    y = np.asarray(y, dtype=float)
    b, a = np.polyfit(x, y, 1)
    return float(a), float(b)
