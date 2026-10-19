# SPDX-License-Identifier: MIT
"""SOTP-Low: correctness and rejection of forged openings (Algorithm 1)."""
import dataclasses
import secrets

import pytest

import sotp_low as low

LAM = 128
# |C| = 8 contexts, H(C) = 3 bits < sqrt(128) ~ 11.3 bits (SOTP-Low regime)
CONTEXTS = [f"contrat type {i} entre parties A et B" for i in range(8)]


@pytest.fixture(scope="module")
def pk():
    return low.setup(LAM, CONTEXTS)


@pytest.fixture()
def honest(pk):
    m = secrets.token_bytes(LAM // 8)
    c = CONTEXTS[3]
    sigma, w = low.prove(pk, m, c)
    return m, c, sigma, w


# ---- correctness -------------------------------------------------------------
def test_verify_accepts_honest_proof(pk, honest):
    m, c, sigma, w = honest
    assert low.verify(pk, sigma, c)


def test_open_accepts_honest_witness(pk, honest):
    m, c, sigma, w = honest
    assert low.open_proof(pk, sigma, c, m, w.s, w.rho)


def test_honest_proofs_for_every_context(pk):
    for c in CONTEXTS:
        m = secrets.token_bytes(LAM // 8)
        sigma, w = low.prove(pk, m, c)
        assert low.verify(pk, sigma, c)
        assert low.open_proof(pk, sigma, c, m, w.s, w.rho)


def test_clay_layer_contents(pk, honest):
    m, c, sigma, w = honest
    assert sigma.sigma3.phi_c == pk.phi(c)
    assert len(sigma.sigma3.phi_c) == pk.phi_bits == 3
    assert sigma.sigma3.hash_c == low.context_hash(c, LAM)
    assert sigma.sigma3.verdict == pk.verdict_fn(c)


def test_sigma1_hides_message_length_only(pk, honest):
    m, c, sigma, w = honest
    assert len(sigma.sigma1) == LAM // 8
    assert sigma.sigma1 != m


# ---- rejection of forged openings ------------------------------------------------
def test_open_rejects_wrong_message(pk, honest):
    m, c, sigma, w = honest
    m2 = bytes([m[0] ^ 1]) + m[1:]
    assert not low.open_proof(pk, sigma, c, m2, w.s, w.rho)


def test_open_rejects_wrong_seed(pk, honest):
    m, c, sigma, w = honest
    assert not low.open_proof(pk, sigma, c, m, (w.s + 1) % pk.group.q, w.rho)


def test_open_rejects_wrong_randomness(pk, honest):
    m, c, sigma, w = honest
    assert not low.open_proof(pk, sigma, c, m, w.s, (w.rho + 1) % pk.group.q)


def test_open_rejects_tampered_sigma1(pk, honest):
    m, c, sigma, w = honest
    bad = dataclasses.replace(sigma, sigma1=bytes([sigma.sigma1[0] ^ 0x80]) + sigma.sigma1[1:])
    assert not low.open_proof(pk, bad, c, m, w.s, w.rho)


def test_open_rejects_tampered_sigma2(pk, honest):
    m, c, sigma, w = honest
    bad = dataclasses.replace(sigma, sigma2=pk.group.mul(sigma.sigma2, pk.g))
    assert not low.open_proof(pk, bad, c, m, w.s, w.rho)


def test_open_rejects_out_of_range_scalars(pk, honest):
    m, c, sigma, w = honest
    # s + q would give the same commitment: seeds must lie in Z_q
    assert not low.open_proof(pk, sigma, c, m, w.s + pk.group.q, w.rho)


# ---- rejection by Verify ------------------------------------------------------
def test_verify_rejects_other_context(pk, honest):
    m, c, sigma, w = honest
    assert not low.verify(pk, sigma, CONTEXTS[4])


def test_verify_rejects_unknown_context(pk, honest):
    m, c, sigma, w = honest
    assert not low.verify(pk, sigma, "contexte hors espace")


def test_verify_rejects_forged_hash(pk, honest):
    m, c, sigma, w = honest
    clay = dataclasses.replace(sigma.sigma3, hash_c=bytes(LAM // 8))
    assert not low.verify(pk, dataclasses.replace(sigma, sigma3=clay), c)


def test_verify_rejects_forged_phi(pk, honest):
    m, c, sigma, w = honest
    clay = dataclasses.replace(sigma.sigma3, phi_c=pk.phi(CONTEXTS[0]))
    assert not low.verify(pk, dataclasses.replace(sigma, sigma3=clay), c)


def test_verify_rejects_sigma2_outside_group(pk, honest):
    m, c, sigma, w = honest
    assert not low.verify(pk, dataclasses.replace(sigma, sigma2=pk.group.p - 1), c)
    assert not low.verify(pk, dataclasses.replace(sigma, sigma2=0), c)


def test_verify_does_not_link_sigma1_and_sigma2(pk, honest):
    """Documented property of Algorithm 1: Verify alone accepts any well-formed
    pair (sigma_1, sigma_2); the link is checked only by Open."""
    m, c, sigma, w = honest
    other = dataclasses.replace(sigma, sigma1=secrets.token_bytes(LAM // 8))
    assert low.verify(pk, other, c)
    assert not low.open_proof(pk, other, c, m, w.s, w.rho)


# ---- parameters -----------------------------------------------------------------
def test_setup_enforces_low_regime():
    too_many = [f"c{i}" for i in range(4096)]  # H(C) = 12 bits > sqrt(128)
    with pytest.raises(ValueError):
        low.setup(LAM, too_many)


def test_prove_rejects_wrong_message_length(pk):
    with pytest.raises(ValueError):
        low.prove(pk, b"short", CONTEXTS[0])
