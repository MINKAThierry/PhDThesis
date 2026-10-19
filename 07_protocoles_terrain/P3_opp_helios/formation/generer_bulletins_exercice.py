# SPDX-License-Identifier: MIT
"""Generate the six exercise ballots of the P3 trustee training.

PROPOSAL - field protocol not deployed. PEDAGOGICAL CODE - NOT AUDITED.

The ballots use the Helios-style construction of the P1 reference stimuli
(exponential ElGamal in the RFC 3526 2048-bit group, g = 2, disjunctive
Chaum-Pedersen proofs made non-interactive with SHA-256). They are NOT in the
Helios wire format and must not be fed to a real Helios verifier. Their only
purpose is to let trustees practise the audit form on known cases before the
real audit, which uses the verification tools of the deployed Helios instance.

Two-list election, one ciphertext per list, one "0 or 1" proof per ciphertext
and one "sum equals 1" proof per ballot.

    EX-1  valid ballot, list 1
    EX-2  valid ballot, list 2
    EX-3  list-1 ballot whose first "0 or 1" proof was altered after creation
    EX-4  ballot encrypting (1, 1): each "0 or 1" proof is valid, the
          "sum equals 1" proof cannot be and fails
    EX-5  ballot encrypting 2 for list 1: its "0 or 1" proof fails
    EX-6  exact copy of EX-1 (replayed ballot): every proof verifies

Usage::

    python3 generer_bulletins_exercice.py           # writes bulletins_exercice.json
    python3 generer_bulletins_exercice.py --check   # regenerates and compares
    python3 generer_bulletins_exercice.py --verifier EX-3   # verifies one ballot from the JSON file
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import importlib.util
import json
from pathlib import Path

HERE = Path(__file__).parent
OUT = HERE / "bulletins_exercice.json"
_P1 = HERE.parents[1] / "P1_delta" / "stimuli" / "generer_exemples.py"
_spec = importlib.util.spec_from_file_location("p1_stimuli", _P1)
G = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(G)
p, q, g = G.p, G.q, G.g


def encrypt(y, v, label):
    r = G.derive(label, q)
    return r, pow(g, r, p), pow(g, v, p) * pow(y, r, p) % p


def make_ballot(y, values, label, prove_values=None):
    """Ballot with one ciphertext per list. ``prove_values`` lets the prover
    claim other plaintexts (to build a ballot whose proofs must fail)."""
    prove_values = prove_values or values
    cts, rs = [], []
    for j, (v, pv) in enumerate(zip(values, prove_values)):
        r, a, b = encrypt(y, v, f"{label}/r/{j}")
        proof = G.prove_disjunctive(y, a, b, r, pv if pv in (0, 1) else 0, [0, 1], f"{label}/p{j}")
        cts.append({"alpha": a, "beta": b, "proof": proof})
        rs.append(r)
    A = cts[0]["alpha"] * cts[1]["alpha"] % p
    B = cts[0]["beta"] * cts[1]["beta"] % p
    overall = G.prove_disjunctive(y, A, B, sum(rs) % q, 1, [1], f"{label}/sum")
    return {"ciphertexts": cts, "overall": overall}


def verify(y, ballot):
    ok01 = [G.verify_disjunctive(y, c["alpha"], c["beta"], c["proof"]) for c in ballot["ciphertexts"]]
    A = ballot["ciphertexts"][0]["alpha"] * ballot["ciphertexts"][1]["alpha"] % p
    B = ballot["ciphertexts"][0]["beta"] * ballot["ciphertexts"][1]["beta"] % p
    return ok01, G.verify_disjunctive(y, A, B, ballot["overall"])


def fingerprint(ballot):
    return hashlib.sha256(b"|".join(format(c[k], "x").encode() for c in ballot["ciphertexts"]
                                    for k in ("alpha", "beta"))).hexdigest()


def hexify(obj):
    if isinstance(obj, dict):
        return {k: hexify(v) for k, v in obj.items()}
    if isinstance(obj, list):
        return [hexify(v) for v in obj]
    if isinstance(obj, int) and obj > 10:
        return format(obj, "x")
    return obj


def build():
    x = G.derive("P3-formation/trustee-secret", q)
    y = pow(g, x, p)
    b = {
        "EX-1": make_ballot(y, [1, 0], "P3-formation/EX-1"),
        "EX-2": make_ballot(y, [0, 1], "P3-formation/EX-2"),
        "EX-3": make_ballot(y, [1, 0], "P3-formation/EX-3"),
        "EX-4": make_ballot(y, [1, 1], "P3-formation/EX-4"),
        "EX-5": make_ballot(y, [2, 0], "P3-formation/EX-5"),
    }
    b["EX-3"]["ciphertexts"][0]["proof"][0]["z"] = (b["EX-3"]["ciphertexts"][0]["proof"][0]["z"] + 1) % q
    b["EX-6"] = copy.deepcopy(b["EX-1"])
    out = {"schema": "ElGamal exponentiel, groupe MODP 2048 bits (RFC 3526 groupe 14), g = 2, "
                     "preuves de Chaum-Pedersen disjonctives, Fiat-Shamir SHA-256. "
                     "Format pédagogique, différent du format Helios.",
           "cle_publique_scrutin": format(y, "x"), "bulletins": {}}
    for k, ballot in b.items():
        ok01, oksum = verify(y, ballot)
        out["bulletins"][k] = {
            "empreinte_sha256": fingerprint(ballot),
            "verification": {"preuves_0_1": ok01, "preuve_somme_1": oksum},
            "valeurs": hexify(ballot),
        }
    return out


def unhex(obj):
    if isinstance(obj, dict):
        return {k: (v if k == "valeur" else unhex(v)) for k, v in obj.items()}
    if isinstance(obj, list):
        return [unhex(v) for v in obj]
    if isinstance(obj, str):
        return int(obj, 16)
    return obj


def verify_from_file(ballot_id):
    """Verify one exercise ballot read from the JSON file (exercise for trustees)."""
    data = json.loads(OUT.read_text(encoding="utf-8"))
    y = int(data["cle_publique_scrutin"], 16)
    ballot = unhex(data["bulletins"][ballot_id]["valeurs"])
    ok01, oksum = verify(y, ballot)
    print(f"{ballot_id} empreinte recalculée : {fingerprint(ballot)}")
    for j, ok in enumerate(ok01, start=1):
        print(f"  preuve 0 ou 1, liste {j} : {'acceptée' if ok else 'REJETÉE'}")
    print(f"  preuve somme égale à 1 : {'acceptée' if oksum else 'REJETÉE'}")


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--check", action="store_true")
    ap.add_argument("--verifier", metavar="EX-n", help="verify one ballot of the JSON file")
    a = ap.parse_args()
    if a.verifier:
        verify_from_file(a.verifier)
        return
    data = build()
    for k, v in data["bulletins"].items():
        print(k, v["empreinte_sha256"][:16], v["verification"])
    text = json.dumps(data, indent=1, ensure_ascii=False) + "\n"
    if a.check:
        same = OUT.exists() and OUT.read_text(encoding="utf-8") == text
        print("identique au fichier versionné" if same else "DIFFÉRENT du fichier versionné")
        raise SystemExit(0 if same else 1)
    OUT.write_text(text, encoding="utf-8")
    print(f"écrit : {OUT.name}")


if __name__ == "__main__":
    main()
