"""Lecture des fichiers de data/ (bibliothèque standard uniquement)."""
from __future__ import annotations

import csv
from pathlib import Path

RACINE = Path(__file__).resolve().parents[2]
DATA = RACINE / "data"


def _convertir(v: str):
    if v == "":
        return None
    try:
        f = float(v)
        return int(f) if f.is_integer() and "." not in v else f
    except ValueError:
        return v


def lire(nom: str) -> list[dict]:
    with open(DATA / nom, newline="", encoding="utf-8") as fh:
        return [{k: _convertir(v) for k, v in ligne.items()} for ligne in csv.DictReader(fh)]


def parametres_reference() -> list[dict]:
    return lire("parametres_reference.csv")


def calibration_pq() -> list[dict]:
    return lire("calibration_pq.csv")
