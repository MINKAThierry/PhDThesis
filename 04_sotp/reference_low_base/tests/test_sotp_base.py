# SPDX-License-Identifier: MIT
"""SOTP-Base: correctness, forged openings, JL distance preservation (Algorithm 2)."""
import dataclasses
import itertools
import math
import secrets

import numpy as np
import pytest

import sotp_base as base

LAM = 128
H_C = 12.0       # sqrt(128) ~ 11.31 <= 12 <= 128/7 ~ 18.29 (transition regime)
DELTA = 2.0
EPS = 0.3        # larger than the thesis default 0.1 to keep Phi small (pedagogical)


@pytest.fixture(scope="module")
def pk():
    return base.setup(LAM, DELTA, H_C, eps=EPS, phi_seed=b"public-test-seed")


@pytest.fixture()
def honest(pk):
    m = secrets.token_bytes(LAM // 8)
    c = "scrutin municipal bureau 12 registre electeurs proces-verbal"
    sigma, w = base.prove(pk, m, c)
    return m, c, sigma, w


def test_dimensions_follow_algorithm(pk):
    assert pk.d == math.ceil(4 * DELTA * H_C / EPS**2)
    assert pk.k == math.ceil(8 * math.log(2**H_C) / EPS**2)
    assert pk.Phi.shape == (pk.k, pk.d)


def test_thesis_example_dimension():
    # Thesis: eps = 0.1, Delta = 56, H(C) = 40 gives d = 896 000
    assert base.embed_dimension(56, 40, 0.1) == 896_000


def test_phi_is_reproducible_from_public_seed(pk):
    again = base.jl_matrix(pk.phi_seed, pk.k, pk.d)
    assert np.array_equal(again, pk.Phi)


def test_phi_variance(pk):
    assert abs(pk.Phi.var() * pk.k - 1.0) < 0.02
    assert abs(pk.Phi.mean()) < 0.01


# ---- correctness -------------------------------------------------------------
def test_verify_accepts_honest_proof(pk, honest):
    m, c, sigma, w = honest
    assert base.verify(pk, sigma, c)


def test_open_accepts_honest_witness(pk, honest):
    m, c, sigma, w = honest
    assert base.open_proof(pk, sigma, c, m, w.s, w.rho)


def test_verify_tolerates_noise_below_eps(pk, honest):
    m, c, sigma, w = honest
    noise = np.zeros(pk.k)
    noise[0] = 0.9 * pk.eps
    assert base.verify(pk, dataclasses.replace(sigma, sigma3=sigma.sigma3 + noise), c)


# ---- rejection ------------------------------------------------------------------
def test_verify_rejects_other_context(pk, honest):
    m, c, sigma, w = honest
    assert not base.verify(pk, sigma, "transaction bancaire multi-juridictionnelle")


def test_verify_rejects_clay_beyond_eps(pk, honest):
    m, c, sigma, w = honest
    noise = np.zeros(pk.k)
    noise[0] = 1.5 * pk.eps
    assert not base.verify(pk, dataclasses.replace(sigma, sigma3=sigma.sigma3 + noise), c)


def test_verify_rejects_malformed_clay(pk, honest):
    m, c, sigma, w = honest
    assert not base.verify(pk, dataclasses.replace(sigma, sigma3=sigma.sigma3[:-1]), c)
    bad = sigma.sigma3.copy()
    bad[0] = np.nan
    assert not base.verify(pk, dataclasses.replace(sigma, sigma3=bad), c)


def test_verify_rejects_sigma2_outside_group(pk, honest):
    m, c, sigma, w = honest
    assert not base.verify(pk, dataclasses.replace(sigma, sigma2=pk.group.p - 1), c)


def test_verify_rejects_malformed_gold(pk, honest):
    m, c, sigma, w = honest
    assert not base.verify(pk, dataclasses.replace(sigma, sigma1=sigma.sigma1[:-1]), c)


def test_open_rejects_forged_openings(pk, honest):
    m, c, sigma, w = honest
    q = pk.group.q
    m2 = bytes([m[0] ^ 1]) + m[1:]
    assert not base.open_proof(pk, sigma, c, m2, w.s, w.rho)
    assert not base.open_proof(pk, sigma, c, m, (w.s + 1) % q, w.rho)
    assert not base.open_proof(pk, sigma, c, m, w.s, (w.rho + 1) % q)
    assert not base.open_proof(pk, sigma, c, m, w.s + q, w.rho)


def test_setup_enforces_transition_regime():
    with pytest.raises(ValueError):
        base.setup(LAM, DELTA, 5.0, eps=EPS)      # below sqrt(lambda)
    with pytest.raises(ValueError):
        base.setup(LAM, DELTA, 30.0, eps=EPS)     # above lambda / log2 lambda


def test_setup_refuses_thesis_scale_matrix():
    # eps = 0.1, Delta = 56, H(C) = 18 would require a k x d matrix far too large
    with pytest.raises(MemoryError):
        base.setup(LAM, 56, 18, eps=0.1)


# ---- empirical JL preservation ------------------------------------------------------
def test_jl_preserves_pairwise_distances_of_contexts(pk):
    vocab = [f"tok{i}" for i in range(400)]
    rng = np.random.default_rng(2026)
    contexts = [" ".join(rng.choice(vocab, size=12, replace=False)) for _ in range(40)]
    X = np.stack([pk.embed(c) for c in contexts])
    Y = X @ pk.Phi.T
    ratios = []
    for i, j in itertools.combinations(range(len(contexts)), 2):
        dx = np.sum((X[i] - X[j]) ** 2)
        if dx == 0:
            continue
        ratios.append(np.sum((Y[i] - Y[j]) ** 2) / dx)
    ratios = np.array(ratios)
    assert ratios.size > 700
    assert np.all((1 - EPS <= ratios) & (ratios <= 1 + EPS))


def test_jl_preserves_distances_of_random_points():
    """Dimension from the Annex A sizing lemma (constant 8 of its proof)."""
    n_points, delta, eps_fail, d_in = 60, 0.3, 0.01, 2000
    k = base.jl_dimension_lemma(n_points, delta, eps_fail)
    Phi = base.jl_matrix(b"lemma-check", k, d_in)
    rng = np.random.default_rng(7)
    X = rng.normal(size=(n_points, d_in))
    Y = X @ Phi.T
    worst = 0.0
    for i, j in itertools.combinations(range(n_points), 2):
        r = np.sum((Y[i] - Y[j]) ** 2) / np.sum((X[i] - X[j]) ** 2)
        worst = max(worst, abs(r - 1))
    assert worst <= delta


def test_close_contexts_stay_close(pk):
    a = "registre electeurs bureau 12 proces-verbal scrutin municipal"
    b = "registre electeurs bureau 12 proces-verbal scrutin regional"
    c = "contrat de pret hypothecaire banque emprunteur garantie"
    pa, pb, pc = (pk.Phi @ pk.embed(x) for x in (a, b, c))
    assert np.linalg.norm(pa - pb) < np.linalg.norm(pa - pc)
