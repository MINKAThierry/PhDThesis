# SPDX-License-Identifier: MIT
"""SOTP-Low (thesis, Chapter 3, Algorithm 1 `alg:sotp_low`).

PEDAGOGICAL REFERENCE IMPLEMENTATION - NOT AUDITED - DO NOT USE IN PRODUCTION.

Layer mapping (Gold-Iron-Clay paradigm):

* Gold : sigma_1 = m XOR PRG(s),  s <-$ Z_q,  PRG = SHAKE-256 (lambda-bit output)
* Iron : sigma_2 = g^s * h^rho,   rho <-$ Z_q  (Pedersen commitment to the seed)
* Clay : sigma_3 = (phi(c), Hash(c), V(c))     (deterministic context encoding)

Line numbers in comments refer to Algorithm 1 of the thesis.

Implementation choices that the thesis leaves open (documented in README):

* The context space is a finite, publicly enumerated list of contexts.
  phi(c) is the index of c in that list, written on ceil(log2 |C|) bits, which
  is a lossless deterministic encoding C -> {0,1}^{H(C)} for a uniform context.
* Hash is SHA-256 truncated to lambda bits (Hash : C -> {0,1}^lambda).
* Messages are lambda-bit strings, as implied by PRG : Z_q -> {0,1}^lambda.
* The group is the RFC 3526 group 14 subgroup (|q| = 2047 bits), not a group
  with |q| = lambda; lambda only fixes message length and regime thresholds.
"""
from __future__ import annotations

import hashlib
import math
from dataclasses import dataclass
from typing import Callable, Hashable, Sequence

from group import SchnorrGroup, generators, rfc3526_group14

Verdict = Hashable


# --------------------------------------------------------------------------
# Primitives
# --------------------------------------------------------------------------
def prg(group: SchnorrGroup, s: int, out_bits: int) -> bytes:
    """PRG : Z_q -> {0,1}^out_bits, instantiated with SHAKE-256."""
    if not (0 <= s < group.q):
        raise ValueError("seed must lie in Z_q")
    seed = s.to_bytes(group.scalar_bytes(), "big")
    return hashlib.shake_256(b"SOTP/PRG/" + seed).digest(out_bits // 8)


def xor(a: bytes, b: bytes) -> bytes:
    if len(a) != len(b):
        raise ValueError("length mismatch in XOR")
    return bytes(x ^ y for x, y in zip(a, b))


def context_hash(c: str, out_bits: int) -> bytes:
    """Hash : C -> {0,1}^lambda (SHA-256 truncated, lambda <= 256)."""
    return hashlib.sha256(b"SOTP/Hash/" + c.encode("utf-8")).digest()[: out_bits // 8]


# --------------------------------------------------------------------------
# Data structures
# --------------------------------------------------------------------------
@dataclass(frozen=True)
class PublicKeyLow:
    """pk = (G, q, g, h, PRG, Hash, phi) (Algorithm 1, line 8)."""

    group: SchnorrGroup
    g: int
    h: int
    lam: int
    contexts: tuple[str, ...]          # public, enumerated context space C
    verdict_fn: Callable[[str], Verdict]

    @property
    def phi_bits(self) -> int:
        return max(1, math.ceil(math.log2(len(self.contexts))))

    def phi(self, c: str) -> str:
        """Deterministic encoding phi : C -> {0,1}^{H(C)} (line 7)."""
        try:
            idx = self.contexts.index(c)
        except ValueError as exc:
            raise ValueError("context outside the public context space") from exc
        return format(idx, f"0{self.phi_bits}b")


@dataclass(frozen=True)
class Clay:
    """sigma_3 = (phi(c), Hash(c), V(c)).

    In Algorithm 1, Verify names the components sigma_3.h_c (= phi(c)) and
    sigma_3.hc (= Hash(c)).
    """

    phi_c: str      # sigma_3.h_c
    hash_c: bytes   # sigma_3.hc
    verdict: Verdict


@dataclass(frozen=True)
class ProofLow:
    sigma1: bytes   # Gold
    sigma2: int     # Iron
    sigma3: Clay    # Clay


@dataclass(frozen=True)
class Witness:
    """Secret witness (s, rho) kept by the prover (line 16)."""

    s: int
    rho: int


# --------------------------------------------------------------------------
# Algorithm 1
# --------------------------------------------------------------------------
def default_verdict(c: str) -> Verdict:
    """Illustrative institutional verdict V(c): a public function of c."""
    return "conforme" if hashlib.sha256(c.encode()).digest()[0] % 2 == 0 else "non-conforme"


def h_star(lam: int) -> float:
    """Construction threshold H*(lambda) = sqrt(lambda)."""
    return math.sqrt(lam)


def setup(
    lam: int,
    contexts: Sequence[str],
    verdict_fn: Callable[[str], Verdict] = default_verdict,
    group: SchnorrGroup | None = None,
    check_regime: bool = True,
) -> PublicKeyLow:
    """Setup(1^lambda) (lines 2-8)."""
    if lam % 8 or not (8 <= lam <= 256):
        raise ValueError("lambda must be a multiple of 8 in [8, 256]")
    ctx = tuple(contexts)
    if len(ctx) < 2 or len(set(ctx)) != len(ctx):
        raise ValueError("context space must contain at least two distinct contexts")
    # Parameter line: H(C) < H*(lambda), with H(C) = log2|C| for a uniform context.
    if check_regime and not (math.log2(len(ctx)) < h_star(lam)):
        raise ValueError("SOTP-Low requires H(C) < H*(lambda) = sqrt(lambda)")
    grp = group or rfc3526_group14()          # line 3: (G, q) with hard DLog
    g, h = generators(grp)                    # line 4: g, h with log_g h unknown
    # lines 5-7: PRG (SHAKE-256), Hash (SHA-256), phi (index encoding)
    return PublicKeyLow(grp, g, h, lam, ctx, verdict_fn)  # line 8


def prove(pk: PublicKeyLow, m: bytes, c: str) -> tuple[ProofLow, Witness]:
    """Prove(pk, m, c) (lines 9-16)."""
    if len(m) * 8 != pk.lam:
        raise ValueError("message must be exactly lambda bits")
    grp = pk.group
    # Gold (line 11)
    s = grp.random_scalar()
    sigma1 = xor(m, prg(grp, s, pk.lam))
    # Iron (line 13)
    rho = grp.random_scalar()
    sigma2 = grp.mul(grp.exp(pk.g, s), grp.exp(pk.h, rho))
    # Clay (line 15)
    sigma3 = Clay(pk.phi(c), context_hash(c, pk.lam), pk.verdict_fn(c))
    # line 16
    return ProofLow(sigma1, sigma2, sigma3), Witness(s, rho)


def verify(pk: PublicKeyLow, sigma: ProofLow, c: str) -> bool:
    """Verify(pk, sigma, c) (lines 17-18).

    Checks Hash(c) = sigma_3.hc, phi(c) = sigma_3.h_c and sigma_2 in G.
    As stated in the thesis, Verify does not link sigma_1 to sigma_2: that
    link is only checked by Open, which needs the witness.
    """
    try:
        phi_c = pk.phi(c)
    except ValueError:
        return False
    return (
        context_hash(c, pk.lam) == sigma.sigma3.hash_c
        and phi_c == sigma.sigma3.phi_c
        and pk.group.contains(sigma.sigma2)
    )


def open_proof(pk: PublicKeyLow, sigma: ProofLow, c: str, m: bytes, s: int, rho: int) -> bool:
    """Open(pk, sigma, c, (m, s, rho)) (lines 19-20).

    Accept iff sigma_2 = g^s h^rho and sigma_1 = m XOR PRG(s).
    """
    grp = pk.group
    if not (0 <= s < grp.q and 0 <= rho < grp.q):
        return False
    if len(m) * 8 != pk.lam or len(sigma.sigma1) * 8 != pk.lam:
        return False
    commit_ok = sigma.sigma2 == grp.mul(grp.exp(pk.g, s), grp.exp(pk.h, rho))
    mask_ok = sigma.sigma1 == xor(m, prg(grp, s, pk.lam))
    return commit_ok and mask_ok


# --------------------------------------------------------------------------
# Binding reduction (thesis, proof of Proposition thm:saturation_sotp_low,
# Part II, and Annex A, Theorem thm:ann_sotp_low_rel)
# --------------------------------------------------------------------------
def extract_dlog(group: SchnorrGroup, s0: int, rho0: int, s1: int, rho1: int) -> int:
    """Given two accepted openings with s0 != s1 of the same sigma_2,
    return log_g h = (s0 - s1) * (rho1 - rho0)^{-1} mod q."""
    if (rho1 - rho0) % group.q == 0:
        raise ValueError("rho0 = rho1: openings are not a commitment collision")
    return ((s0 - s1) * pow(rho1 - rho0, -1, group.q)) % group.q
