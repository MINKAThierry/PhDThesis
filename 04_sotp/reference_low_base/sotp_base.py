# SPDX-License-Identifier: MIT
"""SOTP-Base (thesis, Chapter 3, Algorithm 2 `alg:sotp_base`).

PEDAGOGICAL REFERENCE IMPLEMENTATION - NOT AUDITED - DO NOT USE IN PRODUCTION.

Gold and Iron layers are identical to SOTP-Low (imported from sotp_low).
The Clay layer is a Johnson-Lindenstrauss projection:

    d     = ceil(4 * Delta * H(C) / eps^2)        (line 4, embedding dimension)
    k     = ceil(8 * log(2^{H(C)}) / eps^2)       (line 5, output dimension, natural log)
    Phi  <-$ N(0, 1/k)^{k x d}                    (line 6)
    sigma_3 = Phi * embed(c) in R^k               (lines 11-12)

Verify recomputes Phi * embed(c) and accepts if it lies within eps of sigma_3
(line 15), checks sigma_2 in G and the Gold coherence (line 16), interpreted
here as "sigma_1 is a lambda-bit string" (the only Gold check possible without
the witness).

Note on k: with N = 2^{H(C)} contexts, line 5 equals (4/eps^2) ln(N^2), which
is the dimension of the sizing lemma of Annex A (Theorem thm:ann_sotp_base_opp)
without its failure-probability term. ``jl_dimension_lemma`` implements the
lemma with the constant 8 used in its proof.

Phi is generated from a public seed so that any verifier can rebuild it.
"""
from __future__ import annotations

import hashlib
import math
import secrets
from dataclasses import dataclass

import numpy as np

from group import SchnorrGroup, generators, rfc3526_group14
from sotp_low import Witness, prg, xor


# --------------------------------------------------------------------------
# Dimensioning rules
# --------------------------------------------------------------------------
def embed_dimension(delta: float, h_c: float, eps: float) -> int:
    """d = ceil(4 Delta H(C) / eps^2) (Algorithm 2, line 4)."""
    return math.ceil(4 * delta * h_c / eps**2)


def output_dimension(h_c: float, eps: float) -> int:
    """k = ceil(8 log(2^{H(C)}) / eps^2) (Algorithm 2, line 5), natural log."""
    return math.ceil(8 * h_c * math.log(2) / eps**2)


def jl_dimension_lemma(n_points: int, delta: float, eps_fail: float, constant: float = 8.0) -> int:
    """Projection dimension of the Annex A sizing lemma.

    Statement: dim >= (4/delta^2) ln(N^2/eps').  Proof: the union bound with
    the per-pair tail 2 exp(-dim delta^2 / 8) requires (8/delta^2) ln(N^2/eps').
    The default constant 8 is the one that the proof actually establishes.
    """
    return math.ceil(constant / delta**2 * math.log(n_points**2 / eps_fail))


def h_star(lam: int) -> float:
    return math.sqrt(lam)


def h_star_star(lam: int) -> float:
    return lam / math.log2(lam)


# --------------------------------------------------------------------------
# Data structures
# --------------------------------------------------------------------------
@dataclass(frozen=True)
class PublicKeyBase:
    """pk = (G, q, g, h, PRG, Hash, Phi, k, d) (Algorithm 2, line 7)."""

    group: SchnorrGroup
    g: int
    h: int
    lam: int
    eps: float
    k: int
    d: int
    phi_seed: bytes
    Phi: np.ndarray

    def embed(self, c: str) -> np.ndarray:
        return embed(c, self.d)


@dataclass(frozen=True)
class ProofBase:
    sigma1: bytes
    sigma2: int
    sigma3: np.ndarray  # Phi * embed(c) in R^k


# --------------------------------------------------------------------------
# embed : C -> R^d
# --------------------------------------------------------------------------
def embed(c: str, d: int) -> np.ndarray:
    """Signed feature hashing of the context tokens, L2-normalised.

    Contexts sharing tokens map to nearby vectors, so that semantic proximity
    becomes Euclidean proximity (the role the thesis assigns to embed).
    """
    v = np.zeros(d, dtype=np.float64)
    tokens = c.split() or [""]
    for tok in tokens:
        digest = hashlib.sha256(b"SOTP/embed/" + tok.encode("utf-8")).digest()
        idx = int.from_bytes(digest[:8], "big") % d
        sign = 1.0 if digest[8] & 1 else -1.0
        v[idx] += sign
    norm = np.linalg.norm(v)
    return v / norm if norm > 0 else v


def jl_matrix(seed: bytes, k: int, d: int) -> np.ndarray:
    """Phi <-$ N(0, 1/k)^{k x d}, reproducible from a public seed."""
    rng = np.random.default_rng(int.from_bytes(hashlib.sha256(seed).digest(), "big"))
    return rng.normal(loc=0.0, scale=math.sqrt(1.0 / k), size=(k, d))


# --------------------------------------------------------------------------
# Algorithm 2
# --------------------------------------------------------------------------
def setup(
    lam: int,
    delta: float,
    h_c: float,
    eps: float = 0.1,
    group: SchnorrGroup | None = None,
    phi_seed: bytes | None = None,
    check_regime: bool = True,
    max_entries: int = 50_000_000,
) -> PublicKeyBase:
    """Setup(1^lambda) (lines 2-7)."""
    if lam % 8 or not (8 <= lam <= 256):
        raise ValueError("lambda must be a multiple of 8 in [8, 256]")
    # Parameter line: H*(lambda) <= H(C) <= lambda / log lambda
    if check_regime and not (h_star(lam) <= h_c <= h_star_star(lam)):
        raise ValueError("SOTP-Base requires sqrt(lambda) <= H(C) <= lambda/log2(lambda)")
    grp = group or rfc3526_group14()
    g, h = generators(grp)                       # line 3 (as SOTP-Low)
    d = embed_dimension(delta, h_c, eps)         # line 4
    k = output_dimension(h_c, eps)               # line 5
    if k * d > max_entries:
        raise MemoryError(
            f"Phi would have {k}x{d} entries; choose a larger eps or smaller Delta "
            "for this pedagogical implementation"
        )
    seed = phi_seed if phi_seed is not None else secrets.token_bytes(32)
    Phi = jl_matrix(seed, k, d)                  # line 6
    return PublicKeyBase(grp, g, h, lam, eps, k, d, seed, Phi)  # line 7


def prove(pk: PublicKeyBase, m: bytes, c: str) -> tuple[ProofBase, Witness]:
    """Prove(pk, m, c) (lines 8-13)."""
    if len(m) * 8 != pk.lam:
        raise ValueError("message must be exactly lambda bits")
    grp = pk.group
    # Gold and Iron identical to SOTP-Low (line 9)
    s = grp.random_scalar()
    sigma1 = xor(m, prg(grp, s, pk.lam))
    rho = grp.random_scalar()
    sigma2 = grp.mul(grp.exp(pk.g, s), grp.exp(pk.h, rho))
    # Clay JL (lines 10-12)
    c_vec = pk.embed(c)
    sigma3 = pk.Phi @ c_vec
    return ProofBase(sigma1, sigma2, sigma3), Witness(s, rho)


def verify(pk: PublicKeyBase, sigma: ProofBase, c: str) -> bool:
    """Verify(pk, sigma, c) (lines 14-16), by recomputation."""
    s3 = np.asarray(sigma.sigma3, dtype=np.float64)
    if s3.shape != (pk.k,) or not np.all(np.isfinite(s3)):
        return False
    clay_ok = float(np.linalg.norm(pk.Phi @ pk.embed(c) - s3)) <= pk.eps   # line 15
    iron_ok = pk.group.contains(sigma.sigma2)                               # line 16
    gold_ok = isinstance(sigma.sigma1, (bytes, bytearray)) and len(sigma.sigma1) * 8 == pk.lam
    return bool(clay_ok and iron_ok and gold_ok)


def open_proof(pk: PublicKeyBase, sigma: ProofBase, c: str, m: bytes, s: int, rho: int) -> bool:
    """Open, identical to SOTP-Low: sigma_2 = g^s h^rho and sigma_1 = m XOR PRG(s)."""
    grp = pk.group
    if not (0 <= s < grp.q and 0 <= rho < grp.q):
        return False
    if len(m) * 8 != pk.lam or len(sigma.sigma1) * 8 != pk.lam:
        return False
    commit_ok = sigma.sigma2 == grp.mul(grp.exp(pk.g, s), grp.exp(pk.h, rho))
    mask_ok = sigma.sigma1 == xor(m, prg(grp, s, pk.lam))
    return commit_ok and mask_ok
