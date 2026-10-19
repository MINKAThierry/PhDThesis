"""Entropies et informations mutuelles (en bits) pour des lois jointes finies.

Une loi jointe est un ``numpy.ndarray`` de réels positifs de somme 1 ; chaque
axe correspond à une variable (par exemple ``P[m, s, c, v]``).
"""
from __future__ import annotations

from typing import Sequence

import numpy as np


def entropie(p) -> float:
    """Entropie de Shannon H(p) en bits (les zéros sont ignorés)."""
    p = np.asarray(p, dtype=float).ravel()
    p = p[p > 0]
    return float(-(p * np.log2(p)).sum())


def marginale(P: np.ndarray, garder: Sequence[int]) -> np.ndarray:
    """Marginale de P sur les axes ``garder`` (ordre des axes conservé)."""
    retirer = tuple(i for i in range(P.ndim) if i not in garder)
    return P.sum(axis=retirer) if retirer else P


def entropie_conditionnelle(P: np.ndarray, a: Sequence[int], c: Sequence[int]) -> float:
    """H(A | C) = H(A, C) − H(C)."""
    return entropie(marginale(P, list(a) + list(c))) - entropie(marginale(P, list(c)))


def information_mutuelle_conditionnelle(P: np.ndarray, a: Sequence[int],
                                        b: Sequence[int], c: Sequence[int]) -> float:
    """I(A ; B | C) = H(A,C) + H(B,C) − H(A,B,C) − H(C)."""
    a, b, c = list(a), list(b), list(c)
    return (entropie(marginale(P, a + c)) + entropie(marginale(P, b + c))
            - entropie(marginale(P, a + b + c)) - entropie(marginale(P, c)))


def opposabilite(P: np.ndarray, v: int, sigma: int, c: int) -> float:
    """Opp = I(V ; Σ | C) / H(V | C) (Définition d'opposabilité)."""
    hvc = entropie_conditionnelle(P, [v], [c])
    if hvc <= 0:
        raise ValueError("H(V|C) = 0 : opposabilité non définie")
    return information_mutuelle_conditionnelle(P, [v], [sigma], [c]) / hvc
