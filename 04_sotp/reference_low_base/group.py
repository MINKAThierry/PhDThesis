# SPDX-License-Identifier: MIT
"""Prime-order group for the Iron layer of SOTP-Low / SOTP-Base.

PEDAGOGICAL REFERENCE IMPLEMENTATION - NOT AUDITED - DO NOT USE IN PRODUCTION.
Pure Python big-integer arithmetic, no constant-time guarantees, no side-channel
protection.

The group G is the subgroup of quadratic residues of Z_p^* where p = 2q + 1 is
a safe prime. G is cyclic of prime order q. Two instances are provided:

* ``rfc3526_group14()``: the 2048-bit MODP safe prime of RFC 3526 (group 14),
  |q| = 2047 bits. This is the default group.
* ``toy_group()``: a tiny safe prime (p = 2039, q = 1019) used only by the
  tests, where discrete logarithms can be brute-forced.

The generators g and h are derived by hash-to-group (SHAKE-256 output reduced
mod p, then squared to land in the quadratic-residue subgroup), from public
domain-separation labels. Nobody knows log_g h, which is the requirement of
line 4 of Algorithm 1 (SOTP-Low Setup) in the thesis.
"""
from __future__ import annotations

import hashlib
import secrets
from dataclasses import dataclass

# RFC 3526, section 3: 2048-bit MODP group (group 14). p is a safe prime.
_RFC3526_P14_HEX = (
    "FFFFFFFFFFFFFFFFC90FDAA22168C234C4C6628B80DC1CD1"
    "29024E088A67CC74020BBEA63B139B22514A08798E3404DD"
    "EF9519B3CD3A431B302B0A6DF25F14374FE1356D6D51C245"
    "E485B576625E7EC6F44C42E9A637ED6B0BFF5CB6F406B7ED"
    "EE386BFB5A899FA5AE9F24117C4B1FE649286651ECE45B3D"
    "C2007CB8A163BF0598DA48361C55D39A69163FA8FD24CF5F"
    "83655D23DCA3AD961C62F356208552BB9ED529077096966D"
    "670C354E4ABC9804F1746C08CA18217C32905E462E36CE3B"
    "E39E772C180E86039B2783A2EC07A28FB5C55DF06F4C52C9"
    "DE2BCBF6955817183995497CEA956AE515D2261898FA0510"
    "15728E5A8AACAA68FFFFFFFFFFFFFFFF"
)


@dataclass(frozen=True)
class SchnorrGroup:
    """Quadratic-residue subgroup of Z_p^*, p = 2q + 1 safe prime."""

    p: int
    q: int
    name: str

    # ---- element-level operations -------------------------------------
    def contains(self, x: object) -> bool:
        """Membership test sigma_2 in G (used by Verify)."""
        if not isinstance(x, int) or isinstance(x, bool):
            return False
        if not (1 <= x < self.p):
            return False
        return pow(x, self.q, self.p) == 1

    def mul(self, a: int, b: int) -> int:
        return (a * b) % self.p

    def exp(self, base: int, e: int) -> int:
        return pow(base, e % self.q, self.p)

    def random_scalar(self) -> int:
        """Uniform element of Z_q."""
        return secrets.randbelow(self.q)

    # ---- hash-to-group -------------------------------------------------
    def hash_to_group(self, label: bytes) -> int:
        """Map a public label to a non-identity element of G.

        SHAKE-256 is expanded to |p| + 128 bits (statistically close to
        uniform mod p), reduced mod p and squared. The result is a uniform
        quadratic residue. The counter loop discards the identity and 0.
        """
        out_len = (self.p.bit_length() + 128 + 7) // 8
        counter = 0
        while True:
            data = b"SOTP/hash-to-group/" + self.name.encode() + b"/" + label
            data += counter.to_bytes(4, "big")
            u = int.from_bytes(hashlib.shake_256(data).digest(out_len), "big") % self.p
            x = pow(u, 2, self.p)
            if x not in (0, 1):
                return x
            counter += 1

    def scalar_bytes(self) -> int:
        """Fixed byte length used to serialise elements of Z_q."""
        return (self.q.bit_length() + 7) // 8


def rfc3526_group14() -> SchnorrGroup:
    p = int(_RFC3526_P14_HEX, 16)
    return SchnorrGroup(p=p, q=(p - 1) // 2, name="rfc3526-modp-2048")


def toy_group() -> SchnorrGroup:
    """Tiny safe-prime group (p = 2039, q = 1019). Tests only: DLog is trivial."""
    return SchnorrGroup(p=2039, q=1019, name="toy-2039")


def generators(group: SchnorrGroup) -> tuple[int, int]:
    """Return (g, h) with log_g h unknown (nothing-up-my-sleeve labels)."""
    g = group.hash_to_group(b"generator-g")
    h = group.hash_to_group(b"generator-h")
    if g == h:  # cannot happen except with negligible probability
        raise RuntimeError("degenerate generators")
    return g, h


def brute_force_dlog(group: SchnorrGroup, g: int, y: int) -> int:
    """Exhaustive discrete log, usable only on the toy group."""
    if group.q > 1 << 20:
        raise ValueError("brute force only allowed on toy groups")
    acc = 1
    for x in range(group.q):
        if acc == y:
            return x
        acc = (acc * g) % group.p
    raise ValueError("no discrete log found")
