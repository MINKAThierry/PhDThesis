"""Refined forms of the conditional CRO trilemma (classical and post-quantum).

Thesis references:
* classical: chapter 2, thm:trilemme_cro_conditionnel, eq:trilemme_cro_raffine,
  threshold H_sharp of rem:activite_delta (eq:seuil_activite);
* post-quantum: chapter 2, rem:forme_raffinee_pq, eq:trilemme_pq_raffine,
  threshold H_sharp_q.

    classical : Conf * Rel * Opp <= (1 + kappa/lambda)/lambda
                                     * min{1, (kappa/lambda + Delta)/gamma},
                gamma = alpha H(C) - 1
    PQ        : Conf^q * Rel^q * Opp^q <= (1 + kappa/lambda)/lambda
                                     * min{1, (kappa/lambda + Delta_q)/gamma_q},
                gamma_q = theta_q alpha_q H(C)

eta_q does not appear in the refined PQ form (it only appears in the weakened
majorant (Delta_q + eta_q H(C))/lambda + O(lambda^-2)).

These functions evaluate the bound; they do not check the hypotheses of the
theorems. A comparison between a measured product and the bound is probative
only if Hypotheses 1, 2', 3, 4 and admissibility hold
(see ``refutation.confront_bound`` and P7_combine/liste_verification_hypotheses).
"""

from __future__ import annotations

from dataclasses import dataclass


def gamma_classical(alpha: float, h_c: float) -> float:
    """gamma = alpha H(C) - 1 (ass:verdicts_efficace)."""
    return alpha * h_c - 1.0


def gamma_pq(theta_q: float, alpha_q: float, h_c: float) -> float:
    """gamma_q = theta_q alpha_q H(C) (ass:verdict_quantique)."""
    return theta_q * alpha_q * h_c


def fano_factor(lam: float, kappa: float) -> float:
    """(1 + kappa/lambda) / lambda: the Fano majorant of Rel under ass:regime."""
    _check_lambda(lam)
    return (1.0 + kappa / lam) / lam


def _check_lambda(lam: float) -> None:
    if lam < 64:
        raise ValueError("the theorems are stated for lambda >= 64")


def _check_gamma(g: float, name: str) -> None:
    if g < 1:
        raise ValueError(f"{name} = {g:.4g} < 1: the efficient-verdict hypothesis "
                         f"requires {name} >= 1, the refined bound is not defined")


def borne_raffinee(lam: float, kappa: float, delta: float, alpha: float, h_c: float) -> float:
    """Classical refined bound, eq:trilemme_cro_raffine."""
    g = gamma_classical(alpha, h_c)
    _check_gamma(g, "gamma")
    return fano_factor(lam, kappa) * min(1.0, (kappa / lam + delta) / g)


def borne_raffinee_pq(lam: float, kappa: float, delta_q: float, theta_q: float,
                      alpha_q: float, h_c: float) -> float:
    """Post-quantum refined bound, eq:trilemme_pq_raffine."""
    g = gamma_pq(theta_q, alpha_q, h_c)
    _check_gamma(g, "gamma_q")
    return fano_factor(lam, kappa) * min(1.0, (kappa / lam + delta_q) / g)


def borne_explicite(lam: float, kappa: float, delta: float, gamma: float) -> float:
    """Explicit form (eq:trilemme_cro_explicite and the tight PQ form with gamma_q)."""
    _check_lambda(lam)
    _check_gamma(gamma, "gamma")
    return (delta / lam + kappa * (delta + 1.0) / lam ** 2 + kappa ** 2 / lam ** 3) / gamma


def majorant_affaibli_pq(lam: float, delta_q: float, eta_q: float, h_c: float) -> float:
    """Leading term (Delta_q + eta_q H(C)) / lambda of the weakened PQ majorant
    (eq:cro_pq_borne_principale), without the O(lambda^-2) terms."""
    _check_lambda(lam)
    return (delta_q + eta_q * h_c) / lam


def h_sharp(delta: float, alpha: float, kappa: float, lam: float) -> float:
    """H_sharp = (Delta + 1 + kappa/lambda) / alpha (eq:seuil_activite)."""
    return (delta + 1.0 + kappa / lam) / alpha


def h_sharp_q(delta_q: float, theta_q: float, alpha_q: float, kappa: float, lam: float) -> float:
    """H_sharp_q = (Delta_q + kappa/lambda) / (theta_q alpha_q) (rem:forme_raffinee_pq)."""
    return (delta_q + kappa / lam) / (theta_q * alpha_q)


@dataclass
class BoundReport:
    regime: str          # "classical" or "pq"
    lam: float
    kappa: float
    capacity: float      # Delta or Delta_q
    gamma: float
    h_c: float
    h_threshold: float   # H_sharp or H_sharp_q
    binding: str         # "capacity" (H(C) > threshold) or "fano"
    fano: float
    bound: float


def report_classical(lam, kappa, delta, alpha, h_c) -> BoundReport:
    g = gamma_classical(alpha, h_c)
    hs = h_sharp(delta, alpha, kappa, lam)
    return BoundReport("classical", lam, kappa, delta, g, h_c, hs,
                       "capacity" if h_c > hs else "fano",
                       fano_factor(lam, kappa), borne_raffinee(lam, kappa, delta, alpha, h_c))


def report_pq(lam, kappa, delta_q, theta_q, alpha_q, h_c) -> BoundReport:
    g = gamma_pq(theta_q, alpha_q, h_c)
    hs = h_sharp_q(delta_q, theta_q, alpha_q, kappa, lam)
    return BoundReport("pq", lam, kappa, delta_q, g, h_c, hs,
                       "capacity" if h_c > hs else "fano",
                       fano_factor(lam, kappa),
                       borne_raffinee_pq(lam, kappa, delta_q, theta_q, alpha_q, h_c))


# English aliases
refined_bound = borne_raffinee
refined_bound_pq = borne_raffinee_pq
