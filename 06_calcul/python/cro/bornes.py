"""Bornes du Trilemme CRO conditionnel (chapitre 2 de la thèse).

Notations : Δ capacité d'extraction institutionnelle (bits), α granularité des
verdicts, H = H(C) entropie contextuelle (bits), γ = αH(C) − 1, λ paramètre de
sécurité, κ constante de l'Hypothèse 4 (I(M;Σ|C) ≤ κ/λ).

* ``borne_publiee``   Δ/λ + κ(Δ+1)/λ² + κ²/λ³            (forme publiée, P2)
* ``borne_explicite`` (1/γ)(Δ/λ + κ(Δ+1)/λ² + κ²/λ³)      (Théorème, forme explicite)
* ``borne_raffinee``  (1+κ/λ)/λ · min{1, (κ/λ+Δ)/γ}       (forme raffinée)
* ``borne_fano``      (1+κ/λ)/λ                           (Fano seul, Étape 1)

La forme raffinée est la plus précise ; la capacité institutionnelle est
contraignante si et seulement si Δ < γ − κ/λ, c'est-à-dire H(C) > H♯ avec
H♯ = (Δ + 1 + κ/λ)/α. Ces énoncés sont certifiés en Lean
(``trilemma_refined``, ``refined_bound_is_fano_when_delta_ge_gamma``).
"""
from __future__ import annotations


def gamma(alpha: float, H: float) -> float:
    """γ = αH(C) − 1 (Hypothèse 2′ ; le théorème exige γ ≥ 1)."""
    return alpha * H - 1.0


def borne_publiee(delta: float, lam: float, kappa: float = 1.0) -> float:
    return delta / lam + kappa * (delta + 1) / lam**2 + kappa**2 / lam**3


def borne_explicite(delta: float, alpha: float, H: float, lam: float,
                    kappa: float = 1.0) -> float:
    g = gamma(alpha, H)
    if g < 1:
        raise ValueError(f"γ = {g:.3f} < 1 : Hypothèse 2′ non satisfaite")
    return borne_publiee(delta, lam, kappa) / g


def borne_fano(lam: float, kappa: float = 1.0) -> float:
    return (1 + kappa / lam) / lam


def facteur_institutionnel(delta: float, alpha: float, H: float, lam: float,
                           kappa: float = 1.0) -> float:
    """min{1, (κ/λ + Δ)/γ} : fraction du plafond de Fano exploitable."""
    g = gamma(alpha, H)
    if g < 1:
        raise ValueError(f"γ = {g:.3f} < 1 : Hypothèse 2′ non satisfaite")
    return min(1.0, (kappa / lam + delta) / g)


def borne_raffinee(delta: float, alpha: float, H: float, lam: float,
                   kappa: float = 1.0) -> float:
    return borne_fano(lam, kappa) * facteur_institutionnel(delta, alpha, H, lam, kappa)


def seuil_activite(delta: float, alpha: float, lam: float, kappa: float = 1.0) -> float:
    """H♯ = (Δ + 1 + κ/λ)/α : au-delà, Δ est la contrainte liante."""
    return (delta + 1 + kappa / lam) / alpha


def delta_actif(delta: float, alpha: float, H: float, lam: float, kappa: float = 1.0) -> bool:
    return H > seuil_activite(delta, alpha, lam, kappa)


def regime(delta: float, alpha: float, H: float, lam: float, kappa: float = 1.0) -> str:
    return "contexte riche (Δ liant)" if delta_actif(delta, alpha, H, lam, kappa) \
        else "contexte rare (Fano liant)"


# --- Post-quantique (section cro_pq) ------------------------------------------

def borne_pq_affaiblie(delta_q: float, eta_q: float, H: float, lam: float) -> float:
    """Terme dominant de la forme publiée de P3 : (Δ_q + η_q H(C))/λ.

    η_q n'apparaît que dans cette majoration affaiblie ; un terme additif
    positif relâche la borne (il ne constitue pas un plancher).
    """
    return (delta_q + eta_q * H) / lam


def borne_pq_serree(delta_q: float, alpha_q: float, H: float, lam: float,
                    kappa: float = 1.0) -> float:
    """(1/γ_q)(Δ_q/λ + κ(Δ_q+1)/λ² + κ²/λ³) : indépendante de η_q."""
    return borne_explicite(delta_q, alpha_q, H, lam, kappa)
