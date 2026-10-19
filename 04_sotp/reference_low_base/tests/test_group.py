# SPDX-License-Identifier: MIT
"""Sanity checks on the prime-order groups."""
import pytest

from group import brute_force_dlog, generators, rfc3526_group14, toy_group


def _probable_prime(n: int, bases=(2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37)) -> bool:
    if n < 2:
        return False
    for p in bases:
        if n % p == 0:
            return n == p
    d, r = n - 1, 0
    while d % 2 == 0:
        d //= 2
        r += 1
    for a in bases:
        x = pow(a, d, n)
        if x in (1, n - 1):
            continue
        for _ in range(r - 1):
            x = pow(x, 2, n)
            if x == n - 1:
                break
        else:
            return False
    return True


@pytest.mark.parametrize("grp", [rfc3526_group14(), toy_group()], ids=["group14", "toy"])
def test_safe_prime_structure(grp):
    assert grp.p == 2 * grp.q + 1
    assert _probable_prime(grp.p)
    assert _probable_prime(grp.q)


def test_group14_sizes():
    grp = rfc3526_group14()
    assert grp.p.bit_length() == 2048
    assert grp.q.bit_length() == 2047


@pytest.mark.parametrize("grp", [rfc3526_group14(), toy_group()], ids=["group14", "toy"])
def test_generators_in_subgroup(grp):
    g, h = generators(grp)
    for x in (g, h):
        assert grp.contains(x)
        assert x != 1
        assert pow(x, grp.q, grp.p) == 1  # order q (q prime, x != 1)
    assert g != h


def test_membership_rejects_non_residue():
    grp = rfc3526_group14()
    # p = 3 mod 4, so -1 is a quadratic non-residue: not in G
    assert not grp.contains(grp.p - 1)
    assert not grp.contains(0)
    assert not grp.contains(grp.p)
    assert not grp.contains("17")


def test_toy_dlog_is_brute_forceable():
    grp = toy_group()
    g, h = generators(grp)
    x = brute_force_dlog(grp, g, h)
    assert pow(g, x, grp.p) == h
