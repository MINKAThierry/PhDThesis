"""Chaque nombre cité dans la thèse (version finale) doit être reproduit ici.

Lancer depuis la racine du dépôt :  pytest -q
"""
import itertools
import math
import sys
from pathlib import Path

import numpy as np
import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "python"))

from cro import bornes, sotp  # noqa: E402
from cro.donnees import calibration_pq, parametres_reference  # noqa: E402
from cro.information import (entropie_conditionnelle,  # noqa: E402
                             information_mutuelle_conditionnelle)

LAM, KAPPA = 128, 1.0


# --- Chapitre 2 : bornes -------------------------------------------------------

def test_forme_raffinee_exemples_G2_13():
    # Δ = 5, α = 1, H(C) = 20 (γ = 19), κ = 1, λ = 128
    assert bornes.borne_raffinee(5, 1.0, 20, LAM) == pytest.approx(2.08e-3, rel=1e-2)
    # Δ = 35 > γ : retombe sur Fano
    assert bornes.borne_raffinee(35, 1.0, 20, LAM) == pytest.approx(bornes.borne_fano(LAM))
    assert bornes.borne_fano(LAM) == pytest.approx(7.87e-3, rel=1e-3)


def test_raffinee_plus_forte_que_explicite():
    for D in (1, 5, 20, 35, 56, 73):
        for a, H in ((1.0, 20), (1.2, 40), (1.5, 70), (1.0, 3)):
            assert bornes.borne_raffinee(D, a, H, LAM) <= bornes.borne_explicite(D, a, H, LAM) + 1e-15
            assert bornes.borne_explicite(D, a, H, LAM) <= bornes.borne_publiee(D, LAM) + 1e-15


def test_exemple_corollaire_facteur_gamma():
    # « Δ = 50, γ = 9, λ = 128 » : Δ/(γλ) = 0,043 (et non 0,39)
    assert 50 / (9 * 128) == pytest.approx(0.0434, abs=1e-4)


def test_regimes_G2_15():
    p = {r["system"]: r for r in parametres_reference()}
    assert not bornes.delta_actif(35, 1.0, 20, LAM)            # ECDSA : rare
    assert not bornes.delta_actif(56, 1.2, 40, LAM)            # Helios : rare
    assert bornes.delta_actif(73, 1.5, 70, LAM)                # zk : riche
    assert bornes.seuil_activite(56, 1.2, LAM) == pytest.approx(47.5, abs=0.1)
    assert bornes.facteur_institutionnel(73, 1.5, 70, LAM) == pytest.approx(0.702, abs=1e-3)
    assert set(p) == {"ECDSA", "Helios", "zkSNARK"}


def test_hypothese2_espece_violee_helios_zk():
    p = {r["system"]: r for r in parametres_reference()}
    for s, ok in (("ECDSA", True), ("Helios", False), ("zkSNARK", False)):
        g = bornes.gamma(p[s]["alpha"], p[s]["H_C_espece"])
        assert (p[s]["H_V_C_espece"] >= g) is ok


def test_facteurs_de_depassement():
    p = {r["system"]: r for r in parametres_reference()}
    attendus = {"Helios": 8.6, "zkSNARK": 15.5, "ECDSA": 19.0}
    for s, f in attendus.items():
        g = bornes.gamma(p[s]["alpha"], p[s]["H_C_espece"])
        assert p[s]["product_clo"] / (p[s]["Delta"] / (g * LAM)) == pytest.approx(f, abs=0.15)


def test_triplets_P1():
    p = {r["system"]: r for r in parametres_reference()}
    for s in p:
        assert p[s]["Conf_clo"] * p[s]["Rel_ver_clo"] * p[s]["Opp_clo"] == pytest.approx(p[s]["product_clo"], abs=1e-3)


# --- Chapitre 3 : heuristiques SOTP --------------------------------------------

def test_heuristiques_sotp():
    assert sotp.sotp_low(35, LAM) == pytest.approx(0.205, abs=1e-3)
    assert sotp.sotp_base(56, 1.4, 560) == pytest.approx(0.050, abs=1e-3)
    assert sotp.sotp_high(1.5, LAM) == pytest.approx(0.0369, abs=1e-4)
    assert sotp.dimension_jl(56, 40, 0.1) == 896_000


# --- Chapitre 2 / 4 : post-quantique -------------------------------------------

def test_bornes_pq_tableau_these():
    for r in calibration_pq():
        b = bornes.borne_pq_affaiblie(r["Delta_q"], r["eta_q"], r["H_C"], r["lambda"])
        assert b == pytest.approx(r["borne_these"], abs=1.5e-3)
        assert r["product_clo"] > b          # dépassement : hors champ


def test_borne_serree_independante_de_eta():
    import sensitivity_eta_q as se
    lignes = se.calculer(se.grille("0.01:0.20", 20), "Dilithium-3", LAM, KAPPA)
    assert len({l["borne_serree"] for l in lignes}) == 1
    aff = [l["borne_affaiblie"] for l in lignes]
    assert aff == sorted(aff) and aff[-1] > aff[0]      # croissante : relâchement, pas plancher


def test_scripts_cli(tmp_path):
    import validate_sotp as vs
    assert vs.main(["--system", "all", "--type", "classical", "--lambda", "128",
                    "--out", str(tmp_path / "c.csv")]) == 0
    assert vs.main(["--system", "all", "--type", "postquantum", "--lambda", "128"]) == 0
    assert (tmp_path / "c.csv").read_text(encoding="utf-8").count("\n") == 4


# --- Chapitre 4 : statistiques -------------------------------------------------

def test_p_valeur_minimale_trois_points():
    assert 1 / math.factorial(3) == pytest.approx(0.1667, abs=1e-4)


def test_stabilite_en_lambda():
    assert 35 / 256 == pytest.approx(0.5 * 35 / 128)


# --- Résultats structurels (T1, option A) --------------------------------------

def _loi(rng, nM=3, nS=5, nC=2, nV=3, deterministe=False):
    PM = rng.dirichlet(np.ones(nM)); PC = rng.dirichlet(np.ones(nC))
    PS = rng.dirichlet(np.ones(nS), size=(nM, nC))
    if deterministe:
        f = rng.integers(0, nV, size=(nS, nC))
        P = np.zeros((nM, nS, nC, nV))
        for m, s, c in itertools.product(range(nM), range(nS), range(nC)):
            P[m, s, c, f[s, c]] += PM[m] * PC[c] * PS[m, c, s]
        return P
    PV = rng.dirichlet(np.ones(nV), size=(nS, nC))
    return np.einsum("m,c,mcs,scv->mscv", PM, PC, PS, PV)


def test_T1_verdict_deterministe_opp_egal_1():
    rng = np.random.default_rng(1)
    for _ in range(200):
        P = _loi(rng, deterministe=True)
        hvc = entropie_conditionnelle(P, [3], [2])
        if hvc > 1e-9:
            assert information_mutuelle_conditionnelle(P, [3], [1], [2]) / hvc == pytest.approx(1.0, abs=1e-9)


def test_proposition_fondement_extraction():
    rng = np.random.default_rng(2)
    for _ in range(300):
        P = _loi(rng)                                             # V ⊥ M | (Σ, C)
        lhs = information_mutuelle_conditionnelle(P, [3], [1], [2])          # I(V;Σ|C)
        delta = information_mutuelle_conditionnelle(P, [3], [1], [0, 2])     # I(V;Σ|M,C)
        ims = information_mutuelle_conditionnelle(P, [0], [1], [2])          # I(M;Σ|C)
        ivm = information_mutuelle_conditionnelle(P, [3], [0], [2])          # I(V;M|C)
        assert lhs == pytest.approx(ivm + delta, abs=1e-9)                   # égalité
        assert lhs <= ims + delta + 1e-9                                     # Hyp. 1


def test_composante_fonction_du_contexte():
    rng = np.random.default_rng(3)
    for _ in range(100):
        PCV = rng.dirichlet(np.ones(20)).reshape(5, 4)
        g = rng.integers(0, 3, size=5)
        P = np.zeros((5, 3, 4))
        for c in range(5):
            P[c, g[c], :] = PCV[c]
        assert abs(information_mutuelle_conditionnelle(P, [2], [1], [0])) < 1e-12


def test_temoin_coherence_non_realisable():
    # Témoin Lean : I(M;Σ|C) = 0 et Rel = 1/λ. Pour M uniforme sur λ bits,
    # I = 0 impose Σ ⊥ M | C, donc Rel_rec = 2^(-λ) << 1/λ.
    for lam in (8, 16, 64, 128):
        assert 2.0 ** (-lam) < 1 / lam
