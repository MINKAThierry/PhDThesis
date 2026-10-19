"""Reproducible random sampling of proofs for the Helios post-election audit (P3).

Procedure (thesis §4.2.3.3, phase 3: random sample of 50 proofs, i.e. 10 %):
each proof identifier ``x`` receives the rank key SHA-256(seed + "|" + x);
the ``k`` identifiers with the smallest keys form the sample, listed in key
order. The procedure depends only on SHA-256, so anyone holding the published
seed and the published list of identifiers can recompute the sample with any
language (the P3 form ``tirage_echantillon`` gives a manual check).

Command line:
    python -m cro_terrain.sampling --seed "<published seed>" --ids ids.txt --k 50
"""

from __future__ import annotations

import argparse
import hashlib
from pathlib import Path
from typing import Iterable


def rank_key(seed: str, identifier: str) -> str:
    return hashlib.sha256(f"{seed}|{identifier}".encode("utf-8")).hexdigest()


def draw_sample(identifiers: Iterable[str], k: int, seed: str) -> list[tuple[str, str]]:
    """Return the k sampled identifiers with their rank keys, in key order."""
    ids = [str(x).strip() for x in identifiers if str(x).strip()]
    if len(set(ids)) != len(ids):
        raise ValueError("identifiers must be unique")
    if not seed:
        raise ValueError("the seed must be non-empty")
    if k > len(ids):
        raise ValueError("k exceeds the number of identifiers")
    keyed = sorted((rank_key(seed, x), x) for x in ids)
    return [(x, key) for key, x in keyed[:k]]


def seed_from_parts(*parts: str) -> str:
    """Build the published seed from public components (e.g. the bulletin-board
    fingerprint and digits drawn in public), joined by '|'. The choice of the
    components is fixed in the P3 form [to be decided by the team]."""
    return "|".join(p.strip() for p in parts)


def main(argv=None) -> None:
    ap = argparse.ArgumentParser(description="Reproducible SHA-256 sampling (protocol P3)")
    ap.add_argument("--seed", required=True)
    ap.add_argument("--ids", required=True, help="text file, one identifier per line")
    ap.add_argument("--k", type=int, default=50)
    a = ap.parse_args(argv)
    ids = Path(a.ids).read_text(encoding="utf-8").splitlines()
    for rank, (x, key) in enumerate(draw_sample(ids, a.k, a.seed), start=1):
        print(f"{rank}\t{x}\t{key}")


if __name__ == "__main__":
    main()
