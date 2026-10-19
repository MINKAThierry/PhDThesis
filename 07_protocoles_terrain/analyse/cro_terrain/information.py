"""Discrete information-theoretic estimators used by the field protocols.

All quantities are returned in bits.

Estimators
----------
* ``plugin``  : maximum-likelihood (empirical frequency) estimator.
* ``mm``      : plug-in with the Miller--Madow first-order bias correction,
                applied to each stratum entropy ((m - 1) / (2 N ln 2), where m
                is the number of occupied bins of the stratum).
* ``nsb``     : Nemenman--Shafee--Bialek estimator (posterior mean entropy
                under the NSB mixture of symmetric Dirichlet priors). It needs
                the alphabet size of the target variable; by default the number
                of distinct values observed in the whole sample is used, which
                must be overridden by the declared size of the verdict space
                when it is known (e.g. |V| = 4 for the Helios audit).

Conditional quantities are computed by stratification:

    H(X | Z)      = sum_z  p(z) H(X | Z = z)
    I(X ; Y | Z)  = H(X | Z) - H(X | Y, Z)

Thesis references: chapter 4, eq:estimateur_delta (Delta_hat = I(V;Sigma|M,C)),
eq:opp_empirique (Opp_emp = I(V;Sigma|C) / H(V|C)), def:alpha_granularite.
"""

from __future__ import annotations

from collections import Counter, defaultdict
from typing import Hashable, Iterable, Sequence

import numpy as np
from scipy.special import digamma, gammaln, polygamma

LN2 = np.log(2.0)
_trapz = getattr(np, "trapezoid", None) or np.trapz  # numpy < 2.0 compatibility
METHODS = ("plugin", "mm", "nsb")


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _as_list(x: Sequence) -> list:
    return list(x.tolist()) if isinstance(x, np.ndarray) else list(x)


def joint_labels(*columns: Sequence) -> list:
    """Combine several columns into a single column of tuples (joint variable)."""
    cols = [_as_list(c) for c in columns]
    if not cols:
        raise ValueError("at least one column is required")
    n = len(cols[0])
    if any(len(c) != n for c in cols):
        raise ValueError("columns must have the same length")
    if len(cols) == 1:
        return cols[0]
    return list(zip(*cols))


def _check_method(method: str) -> None:
    if method not in METHODS:
        raise ValueError(f"unknown method {method!r}; expected one of {METHODS}")


# ---------------------------------------------------------------------------
# Entropy of a single count vector
# ---------------------------------------------------------------------------

def _nsb_entropy_nats(counts: np.ndarray, alphabet_size: int) -> float:
    """NSB posterior-mean entropy (nats) for a count vector.

    The integral over the Dirichlet concentration beta is computed on a
    logarithmic grid with the trapezoidal rule; this is accurate enough for
    the alphabet sizes met in the protocols (|V| <= a few hundred).
    """
    counts = counts[counts > 0].astype(float)
    m = counts.size
    K = int(alphabet_size)
    if K < m:
        raise ValueError("alphabet_size is smaller than the number of observed symbols")
    N = counts.sum()
    if N == 0 or K <= 1:
        return 0.0
    t = np.linspace(np.log(1e-7), np.log(1e5), 4000)
    beta = np.exp(t)
    kb = K * beta
    # log evidence p(n | beta) up to a constant
    log_ev = gammaln(kb) - gammaln(N + kb)
    log_ev = log_ev + np.sum(gammaln(counts[:, None] + beta[None, :]) - gammaln(beta)[None, :], axis=0)
    # NSB prior: d xi / d beta, with xi(beta) the prior mean entropy
    dxi = K * polygamma(1, kb + 1.0) - polygamma(1, beta + 1.0)
    dxi = np.clip(dxi, 1e-300, None)
    log_w = log_ev + np.log(dxi) + t  # + t because d beta = beta dt
    w = np.exp(log_w - np.max(log_w))
    # posterior mean entropy given beta
    h_beta = digamma(N + kb + 1.0)
    h_beta = h_beta - np.sum((counts[:, None] + beta[None, :]) / (N + kb)[None, :]
                             * digamma(counts[:, None] + beta[None, :] + 1.0), axis=0)
    h_beta = h_beta - (K - m) * beta / (N + kb) * digamma(beta + 1.0)
    return float(_trapz(w * h_beta, t) / _trapz(w, t))


def entropy_from_counts(counts: Iterable[int], method: str = "plugin",
                        alphabet_size: int | None = None) -> float:
    """Entropy (bits) of the empirical distribution given by ``counts``."""
    _check_method(method)
    c = np.asarray(list(counts), dtype=float)
    c = c[c > 0]
    N = c.sum()
    if N == 0:
        return 0.0
    if method == "nsb":
        K = alphabet_size if alphabet_size is not None else c.size
        return _nsb_entropy_nats(c, K) / LN2
    p = c / N
    h = float(-np.sum(p * np.log2(p)))
    if method == "mm":
        h += (c.size - 1) / (2.0 * N * LN2)
    return h


# ---------------------------------------------------------------------------
# Entropies and mutual information on columns of labels
# ---------------------------------------------------------------------------

def entropy(x: Sequence[Hashable], method: str = "plugin",
            alphabet_size: int | None = None) -> float:
    """Entropy H(X) in bits."""
    x = _as_list(x)
    if alphabet_size is None and method == "nsb":
        alphabet_size = len(set(x))
    return entropy_from_counts(Counter(x).values(), method, alphabet_size)


def conditional_entropy(x: Sequence[Hashable], given: Sequence[Sequence[Hashable]] = (),
                        method: str = "plugin", alphabet_size: int | None = None) -> float:
    """Conditional entropy H(X | Z) in bits, Z being the joint of ``given``.

    ``given`` is a sequence of columns (possibly empty, then H(X) is returned).
    """
    _check_method(method)
    x = _as_list(x)
    n = len(x)
    if n == 0:
        return float("nan")
    if alphabet_size is None:
        alphabet_size = len(set(x))
    if len(given) == 0:
        return entropy_from_counts(Counter(x).values(), method, alphabet_size)
    z = joint_labels(*given)
    if len(z) != n:
        raise ValueError("x and conditioning columns must have the same length")
    strata: dict = defaultdict(Counter)
    for xi, zi in zip(x, z):
        strata[zi][xi] += 1
    h = 0.0
    for counter in strata.values():
        n_s = sum(counter.values())
        h += (n_s / n) * entropy_from_counts(counter.values(), method, alphabet_size)
    return h


def conditional_mutual_information(x: Sequence[Hashable], y: Sequence[Hashable],
                                   given: Sequence[Sequence[Hashable]] = (),
                                   method: str = "plugin",
                                   alphabet_size: int | None = None) -> float:
    """I(X ; Y | Z) = H(X | Z) - H(X | Y, Z), in bits.

    ``alphabet_size`` is the size of the alphabet of X (used by NSB only).
    Bias-corrected estimates may be slightly negative when the true value is
    close to zero; they are returned as is so that the bootstrap and the
    refutation criteria see the unclipped estimator.
    """
    given = list(given)
    if alphabet_size is None:
        alphabet_size = len(set(_as_list(x)))
    h_x_z = conditional_entropy(x, given, method, alphabet_size)
    h_x_yz = conditional_entropy(x, given + [y], method, alphabet_size)
    return h_x_z - h_x_yz


# ---------------------------------------------------------------------------
# Thesis-level estimators
# ---------------------------------------------------------------------------

def delta_hat(verdict, sigma, message, context=None, method: str = "mm",
              alphabet_size: int | None = None) -> float:
    """Delta_hat = I(V ; Sigma | M, C)  (thesis eq:estimateur_delta).

    The same function gives Delta_q_hat = I(V^q ; Sigma | M, C)
    (eq:estimateur_delta_q) when fed with the post-quantum session data.
    """
    given = [message] if context is None else [message, context]
    return conditional_mutual_information(verdict, sigma, given, method, alphabet_size)


def h_v_given_c(verdict, context=None, method: str = "mm",
                alphabet_size: int | None = None) -> float:
    """H_hat(V | C)."""
    given = [] if context is None else [context]
    return conditional_entropy(verdict, given, method, alphabet_size)


def opp_emp(verdict, sigma, context=None, method: str = "mm",
            alphabet_size: int | None = None) -> float:
    """Opp_emp = I_hat(V ; Sigma | C) / H_hat(V | C)  (thesis eq:opp_empirique).

    Returns NaN when H_hat(V | C) is (numerically) zero, i.e. when every
    verdict is identical within each context: opposability is then undefined.
    """
    given = [] if context is None else [context]
    i = conditional_mutual_information(verdict, sigma, given, method, alphabet_size)
    h = conditional_entropy(verdict, given, method, alphabet_size)
    if h <= 1e-12:
        return float("nan")
    return i / h


def shuffle_corrected_cmi(x, y, given=(), n_shuffle: int = 50, seed: int | None = None,
                          method: str = "plugin", alphabet_size: int | None = None) -> float:
    """I(X ; Y | Z) minus its mean under random permutations of Y within the
    strata of Z ("shuffle" bias correction, Panzeri et al. 2007).

    The permutations destroy the X-Y dependence while keeping the marginal
    counts, so their mean estimates the small-sample bias of the estimator.
    This correction matters when Y has many values observed a few times each,
    e.g. Sigma coded by the proof identifier in the Helios audit (50 proofs,
    10 trustees each), where the Miller--Madow correction alone leaves a large
    positive bias.
    """
    given = list(given)
    rng = np.random.default_rng(seed)
    y_arr = np.asarray(_as_list(y), dtype=object)
    raw = conditional_mutual_information(x, y_arr, given, method, alphabet_size)
    if given:
        strata = joint_labels(*given)
        groups: dict = defaultdict(list)
        for i, s in enumerate(strata):
            groups[s].append(i)
        groups_idx = [np.asarray(ix) for ix in groups.values()]
    else:
        groups_idx = [np.arange(len(y_arr))]
    null = []
    for _ in range(n_shuffle):
        yp = y_arr.copy()
        for ix in groups_idx:
            yp[ix] = y_arr[ix][rng.permutation(len(ix))]
        null.append(conditional_mutual_information(x, yp, given, method, alphabet_size))
    return raw - float(np.mean(null))


def opp_emp_shuffle(verdict, sigma, context=None, n_shuffle: int = 50, seed: int | None = None,
                    alphabet_size: int | None = None) -> float:
    """Opp_emp with a shuffle-corrected plug-in numerator and a Miller--Madow
    denominator. Recommended estimator for the Helios audit (P3) when Sigma is
    coded by the proof identifier [to be decided by the team]."""
    given = [] if context is None else [context]
    h = conditional_entropy(verdict, given, "mm", alphabet_size)
    if h <= 1e-12:
        return float("nan")
    i = shuffle_corrected_cmi(verdict, sigma, given, n_shuffle, seed, "plugin", alphabet_size)
    return i / h


def alpha_hat(n_verdicts: int, h_c: float) -> float:
    """alpha_hat = log2 |V| / H(C)  (thesis alg:estimation_conjointe, step 5)."""
    if n_verdicts < 1:
        raise ValueError("the verdict space must contain at least one verdict")
    if h_c <= 0:
        raise ValueError("H(C) must be positive")
    return float(np.log2(n_verdicts) / h_c)


def gamma_from_alpha(alpha: float, h_c: float) -> float:
    """gamma = alpha H(C) - 1  (thesis ass:verdicts_efficace)."""
    return alpha * h_c - 1.0
