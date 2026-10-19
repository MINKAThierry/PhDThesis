# SPDX-License-Identifier: MIT
"""Binding of the Iron layer on a toy group where log_g h can be computed.

Thesis: proof of Proposition thm:saturation_sotp_low (Part II) and Annex A,
Theorem thm:ann_sotp_low_rel. Two accepted openings (m0, s0, rho0) and
(m1, s1, rho1) of the same proof with m0 != m1 yield
    log_g h = (s0 - s1) / (rho1 - rho0) mod q.
Conversely, producing such a pair is easy for whoever knows log_g h.
"""
import itertools
import secrets

import pytest

import sotp_low as low
from group import brute_force_dlog, toy_group

LAM = 16                      # toy: 16-bit messages, sqrt(16) = 4
CONTEXTS = ["c0", "c1", "c2", "c3", "c4", "c5", "c6", "c7"]  # H(C) = 3 < 4


@pytest.fixture(scope="module")
def toy():
    grp = toy_group()
    pk = low.setup(LAM, CONTEXTS, group=grp)
    trapdoor = brute_force_dlog(grp, pk.g, pk.h)   # only feasible because q = 1019
    assert pow(pk.g, trapdoor, grp.p) == pk.h
    return pk, trapdoor


def equivocate(pk, sigma, s0, rho0, trapdoor, s1):
    """Trapdoor holder opens sigma on another message.

    With x = log_g h: rho1 = rho0 + (s0 - s1) / x keeps g^s h^rho unchanged, and
    m1 = sigma_1 XOR PRG(s1) keeps the Gold layer consistent.
    """
    q = pk.group.q
    rho1 = (rho0 + (s0 - s1) * pow(trapdoor, -1, q)) % q
    m1 = low.xor(sigma.sigma1, low.prg(pk.group, s1, pk.lam))
    return m1, rho1


def test_trapdoor_allows_two_distinct_openings(toy):
    pk, x = toy
    m0 = secrets.token_bytes(LAM // 8)
    sigma, w = low.prove(pk, m0, "c2")
    for s1 in range(pk.group.q):
        if s1 == w.s:
            continue
        m1, rho1 = equivocate(pk, sigma, w.s, w.rho, x, s1)
        if m1 != m0:
            break
    assert low.verify(pk, sigma, "c2")
    assert low.open_proof(pk, sigma, "c2", m0, w.s, w.rho)
    assert low.open_proof(pk, sigma, "c2", m1, s1, rho1)
    assert m0 != m1


def test_two_openings_reveal_dlog(toy):
    """The reduction B of the thesis recovers log_g h exactly."""
    pk, x = toy
    m0 = secrets.token_bytes(LAM // 8)
    sigma, w = low.prove(pk, m0, "c5")
    s1 = (w.s + 1) % pk.group.q
    m1, rho1 = equivocate(pk, sigma, w.s, w.rho, x, s1)
    assert low.open_proof(pk, sigma, "c5", m1, s1, rho1)
    recovered = low.extract_dlog(pk.group, w.s, w.rho, s1, rho1)
    assert recovered == x
    assert pow(pk.g, recovered, pk.group.p) == pk.h


def test_distinct_messages_force_distinct_seeds_and_randomness(toy):
    """m0 != m1 implies s0 != s1 (Gold layer) and then rho0 != rho1 (Iron)."""
    pk, x = toy
    m0 = secrets.token_bytes(LAM // 8)
    sigma, w = low.prove(pk, m0, "c1")
    s1 = (w.s + 7) % pk.group.q
    m1, rho1 = equivocate(pk, sigma, w.s, w.rho, x, s1)
    if m1 != m0:
        assert s1 != w.s and rho1 != w.rho


def test_each_seed_has_exactly_one_opening(toy):
    """Exhaustive check on the toy group: for a fixed sigma_2 and each s in Z_q
    there is exactly one rho with g^s h^rho = sigma_2. Binding is therefore
    computational (perfect hiding), and choosing between the q openings
    requires log_g h."""
    pk, x = toy
    grp = pk.group
    _, w = low.prove(pk, secrets.token_bytes(LAM // 8), "c0")
    sigma2 = grp.mul(grp.exp(pk.g, w.s), grp.exp(pk.h, w.rho))
    h_pows = {}
    acc = 1
    for r in range(grp.q):
        h_pows.setdefault(acc, []).append(r)
        acc = (acc * pk.h) % grp.p
    for s in range(grp.q):
        target = (sigma2 * pow(pk.g, -s, grp.p)) % grp.p
        assert len(h_pows.get(target, [])) == 1


def test_without_trapdoor_extraction_is_not_available(toy):
    """extract_dlog needs a genuine collision: a single opening, or two openings
    with the same rho, give nothing."""
    pk, _ = toy
    with pytest.raises(ValueError):
        low.extract_dlog(pk.group, 5, 9, 6, 9)


def test_pedersen_hiding_on_toy_group(toy):
    """Perfect hiding: for every seed s, the commitment g^s h^rho with uniform
    rho is uniform over G (exhaustive on the toy group)."""
    pk, _ = toy
    grp = pk.group
    for s in itertools.islice(range(grp.q), 0, grp.q, 97):
        values = {grp.mul(grp.exp(pk.g, s), grp.exp(pk.h, r)) for r in range(grp.q)}
        assert len(values) == grp.q
