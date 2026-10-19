#!/usr/bin/env python3
"""Sensibilité des bornes post-quantiques au coefficient η_q.

Usage (ligne de commande de la section « Reproductibilité ») :

    python sensitivity_eta_q.py --range 0.01:0.20 --steps 20

Pour chaque valeur de η_q, le script calcule :
* la majoration affaiblie (Δ_q + η_q H(C))/λ, qui CROÎT avec η_q
  (un terme additif positif relâche la borne : ce n'est pas un plancher) ;
* la borne serrée (1/γ_q)(Δ_q/λ + κ(Δ_q+1)/λ² + κ²/λ³), INDÉPENDANTE de η_q.

Remarque : ML-DSA, SLH-DSA et Falcon produisent des chaînes de bits
classiques ; η_q > 0 n'a de sens que dans le scénario (hypothétique) d'un
support ou d'un vérificateur quantique.
"""
from __future__ import annotations

import argparse
import csv
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from cro import bornes  # noqa: E402
from cro.donnees import calibration_pq  # noqa: E402


def grille(intervalle: str, pas: int) -> list[float]:
    a, b = (float(x) for x in intervalle.split(":"))
    if pas < 2:
        return [a]
    return [a + i * (b - a) / (pas - 1) for i in range(pas)]


def calculer(etas: list[float], systeme: str, lam: int, kappa: float) -> list[dict]:
    p = next(r for r in calibration_pq() if r["system"] == systeme and r["lambda"] == 128)
    Dq, a, H = p["Delta_q"], p["alpha_q"], p["H_C"]
    serree = bornes.borne_pq_serree(Dq, a, H, lam, kappa)
    return [{
        "system": systeme, "lambda": lam, "eta_q": round(e, 4),
        "borne_affaiblie": round(bornes.borne_pq_affaiblie(Dq, e, H, lam), 5),
        "borne_serree": round(serree, 5),
    } for e in etas]


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--range", default="0.01:0.20", help="intervalle a:b de η_q")
    ap.add_argument("--steps", type=int, default=20)
    ap.add_argument("--system", default="Dilithium-3")
    ap.add_argument("--lambda", dest="lam", type=int, default=128)
    ap.add_argument("--kappa", type=float, default=1.0)
    ap.add_argument("--out", type=Path)
    args = ap.parse_args(argv)

    lignes = calculer(grille(args.range, args.steps), args.system, args.lam, args.kappa)
    print(f"{'eta_q':>7}  {'affaiblie':>10}  {'serrée':>9}")
    for l in lignes:
        print(f"{l['eta_q']:>7.4f}  {l['borne_affaiblie']:>10.5f}  {l['borne_serree']:>9.5f}")
    print("\nLa borne serrée ne dépend pas de η_q ; seule la majoration affaiblie varie.")
    if args.out:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        with open(args.out, "w", newline="", encoding="utf-8") as fh:
            w = csv.DictWriter(fh, fieldnames=list(lignes[0]))
            w.writeheader()
            w.writerows(lignes)
        print(f"→ {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
