"""Expressions heuristiques de conception des variantes SOTP (chapitre 3).

Statut : ces expressions sont des heuristiques de conception, non des
minorations prouvées (voir 03_resultats_these/resultats_these_fr.md du dépôt PhDThesis). Les valeurs
qu'elles donnent ne sont pas comparables aux produits CLO des systèmes
déployés ni à la borne du trilemme.
"""
from __future__ import annotations

import math


def sotp_low(delta: float, lam: float, H: float | None = None) -> float:
    """0,75·Δ/λ (calcul du texte) ; avec H, forme de l'énoncé 0,75·min{Δ,H(C)}/λ."""
    base = delta if H is None else min(delta, H)
    return 0.75 * base / lam


def sotp_base(delta: float, beta: float, d: int) -> float:
    """0,5·min{Δ/d, Δ/(β log₂ d)}."""
    return 0.5 * min(delta / d, delta / (beta * math.log2(d)))


def sotp_high(beta: float, lam: float) -> float:
    """0,45·β·log₂λ/λ."""
    return 0.45 * beta * math.log2(lam) / lam


def dimension_jl(delta: float, H: float, eps: float) -> int:
    """d = ⌈4ΔH(C)/ε²⌉ (dimension de projection annoncée pour SOTP-Base)."""
    return math.ceil(4 * delta * H / eps**2)


def heuristique(variant: str, delta: float, beta: float, lam: float,
                H: float | None = None, d: int | None = None) -> float:
    if variant == "SOTP-Low":
        return sotp_low(delta, lam)
    if variant == "SOTP-Base":
        if d is None:
            raise ValueError("SOTP-Base : dimension d requise")
        return sotp_base(delta, beta, d)
    if variant == "SOTP-High":
        return sotp_high(beta, lam)
    raise ValueError(f"variante inconnue : {variant}")
