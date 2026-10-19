#!/usr/bin/env python3
"""Calibration illustrative des systèmes de référence (chapitre 4 de la thèse).

Usage (lignes de commande de la section « Reproductibilité ») :

    python validate_sotp.py --system all --type classical --lambda 128
    python validate_sotp.py --system all --type postquantum --lambda 128

Ce script NE valide PAS le Trilemme CRO sur des systèmes déployés : ces
systèmes, dont la fiabilité opérationnelle Rel_ver est proche de 1, ne sont
pas des instances du théorème (qui porte sur Rel_rec ≤ (1+κ/λ)/λ). Il calcule,
pour chaque système :

* la capacité implicite Δ := λ·produit CLO (calibration, circulaire par construction) ;
* les bornes explicite, raffinée et de Fano, le seuil H♯ et le régime ;
* le contrôle de l'Hypothèse 2′ avec le contexte d'espèce (H(V|C) ≥ γ) ;
* le rapport produit CLO / Δ/(γλ), contexte d'espèce (> 1 : hors champ, attendu) ;
* la valeur des expressions heuristiques SOTP (chapitre 3).
"""
from __future__ import annotations

import argparse
import csv
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from cro import bornes, sotp  # noqa: E402
from cro.donnees import calibration_pq, parametres_reference  # noqa: E402

BANDEAU = ("CALIBRATION ILLUSTRATIVE — les systèmes ci-dessous ne sont pas des instances\n"
           "du Théorème du trilemme (fiabilité de vérification Rel_ver ≈ 1) ; aucune\n"
           "validation empirique n'est revendiquée.")


def classique(systemes: list[str], lam: int, kappa: float) -> list[dict]:
    lignes = []
    for p in parametres_reference():
        if "all" not in systemes and p["system"] not in systemes:
            continue
        D, a, Hd, He = p["Delta"], p["alpha"], p["H_C_domaine"], p["H_C_espece"]
        g_dom, g_esp = bornes.gamma(a, Hd), bornes.gamma(a, He)
        prod = p["product_clo"]
        bexp = bornes.borne_explicite(D, a, Hd, lam, kappa)
        lignes.append({
            "system": p["system"],
            "product_clo": prod,
            "Delta_implicite": round(p["lambda"] * prod, 1),
            "Delta": D,
            "Delta_sur_lambda": round(D / lam, 4),
            "gamma_domaine": round(g_dom, 2),
            "borne_explicite": round(bexp, 5),
            "borne_raffinee": round(bornes.borne_raffinee(D, a, Hd, lam, kappa), 5),
            "borne_fano": round(bornes.borne_fano(lam, kappa), 5),
            "H_diese": round(bornes.seuil_activite(D, a, lam, kappa), 2),
            "regime": bornes.regime(D, a, Hd, lam, kappa),
            "gamma_espece": round(g_esp, 2),
            "H_V_C_espece": p["H_V_C_espece"],
            "hyp2_espece": "oui" if p["H_V_C_espece"] >= g_esp else "NON",
            "rapport_produit_terme_dominant": round(prod / (D / (g_esp * lam)), 1),  # produit / (Δ/(γλ)), contexte d'espèce
            "sotp_variant": p["sotp_variant"],
            "sotp_heuristique": round(sotp.heuristique(p["sotp_variant"], D, p["beta"], lam,
                                                       d=p["sotp_d"]), 4),
            "statut": "hors champ (Rel_ver)",
        })
    return lignes


def postquantique(systemes: list[str], lam: int, kappa: float) -> list[dict]:
    lignes = []
    for p in calibration_pq():
        if p["lambda"] != lam:
            continue
        if "all" not in systemes and p["system"] not in systemes:
            continue
        Dq, a, H, eta = p["Delta_q"], p["alpha_q"], p["H_C"], p["eta_q"]
        baff = bornes.borne_pq_affaiblie(Dq, eta, H, lam)
        bser = bornes.borne_pq_serree(Dq, a, H, lam, kappa)
        lignes.append({
            "system": p["system"],
            "nature": p["nature"],
            "eta_q": eta,
            "product_clo": p["product_clo"],
            "borne_affaiblie": round(baff, 4),
            "borne_these": p["borne_these"],
            "gamma_q": round(bornes.gamma(a, H), 2),
            "borne_serree": round(bser, 5),
            "rapport_produit_borne_affaiblie": round(p["product_clo"] / baff, 2),
            "statut": "hors champ (Rel_ver)",
        })
    return lignes


def afficher(lignes: list[dict]) -> None:
    if not lignes:
        print("(aucune ligne pour ces paramètres)")
        return
    # tableau transposé : une ligne par grandeur, une colonne par système
    cles = list(lignes[0])
    gauche = max(len(k) for k in cles)
    larg = [max(len(str(l[k])) for k in cles) for l in lignes]
    for k in cles:
        print(f"{k:<{gauche}}  " + "  ".join(f"{str(l[k]):>{w}}" for l, w in zip(lignes, larg)))


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--system", nargs="+", default=["all"],
                    help="all | ECDSA Helios zkSNARK | Dilithium-3 Kyber-1024 SPHINCS+")
    ap.add_argument("--type", choices=["classical", "postquantum"], default="classical")
    ap.add_argument("--lambda", dest="lam", type=int, default=128)
    ap.add_argument("--kappa", type=float, default=1.0, help="constante de l'Hypothèse 4 (défaut 1)")
    ap.add_argument("--out", type=Path, help="fichier CSV de sortie (optionnel)")
    args = ap.parse_args(argv)

    f = classique if args.type == "classical" else postquantique
    lignes = f(args.system, args.lam, args.kappa)
    print(BANDEAU)
    print(f"type={args.type}  λ={args.lam}  κ={args.kappa}\n")
    afficher(lignes)
    if args.out and lignes:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        with open(args.out, "w", newline="", encoding="utf-8") as fh:
            w = csv.DictWriter(fh, fieldnames=list(lignes[0]))
            w.writeheader()
            w.writerows(lignes)
        print(f"\n→ {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
