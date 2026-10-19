# SPDX-License-Identifier: MIT
"""Generate and check the post-quantum signatures of the two worked P5 stimuli.

PROPOSAL - field protocol not deployed. PEDAGOGICAL CODE - NOT AUDITED.

* ``MLD-C01``: ML-DSA-65 (FIPS 204), hedged signing, two documents M1, M2,
  two signatures per document (S1..S4). Signature length 3,309 bytes.
* ``SLH-C01``: SLH-DSA-SHAKE-128f (FIPS 205), randomised signing, two
  documents M1, M2, two signatures per document (S1..S4). Signature length
  17,088 bytes.

Both schemes are randomised, so two signatures of the same document differ
while both verify: this is what makes I(V ; Sigma | M, C) estimable.

The signatures depend on fresh randomness, so the JSON file is not
reproducible bit for bit. ``--check`` therefore verifies every stored
signature against its stored public key and message, and checks that the
four variants of a pair are pairwise distinct.

Dependencies (pure Python implementations, used as is):
    pip install dilithium-py==1.4.0 slh-dsa==0.2.5

Usage::

    python3 generer_signatures_pqc.py           # writes exemples_signatures_pqc.json
    python3 generer_signatures_pqc.py --check   # verifies the committed file
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

OUT = Path(__file__).with_name("exemples_signatures_pqc.json")

DOCS = {
    "MLD-C01": {
        "M1": "ORDRE-FICTIF-MLD-C01 | virement 12 500 000 FCFA | beneficiaire compte 0042 | date de valeur J+1",
        "M2": "ORDRE-FICTIF-MLD-C01 | virement 12 500 000 FCFA | beneficiaire compte 0917 | date de valeur J+1",
    },
    "SLH-C01": {
        "M1": "ATTESTATION-FICTIVE-SLH-C01 | conformite LBC/FT exercice 2025 | sans reserve",
        "M2": "ATTESTATION-FICTIVE-SLH-C01 | conformite LBC/FT exercice 2025 | reserve sur deux clients",
    },
}


def _mldsa():
    from dilithium_py.ml_dsa import ML_DSA_65
    return ML_DSA_65


def _slh():
    import slhdsa
    return slhdsa


def abbrev(b: bytes) -> str:
    h = b.hex()
    return f"{h[:16]}…{h[-16:]}"


def build() -> dict:
    out = {"bibliotheques": {"ML-DSA-65": "dilithium-py 1.4.0", "SLH-DSA-SHAKE-128f": "slh-dsa 0.2.5"}}
    M = _mldsa()
    pk, sk = M.keygen()
    variants = []
    for mid, sids in (("M1", ("S1", "S2")), ("M2", ("S3", "S4"))):
        msg = DOCS["MLD-C01"][mid].encode()
        for sid in sids:
            sig = M.sign(sk, msg)  # hedged: fresh randomness
            assert M.verify(pk, msg, sig)
            variants.append({"id_preuve_sigma": f"MLD-C01-{sid}", "id_message_m": f"MLD-C01-{mid}",
                             "condense_sha256_message": hashlib.sha256(msg).hexdigest(),
                             "signature_hex": sig.hex(), "octets": len(sig)})
    out["MLD-C01"] = {"schema": "ML-DSA-65 (FIPS 204), signature hedged", "cle_publique_hex": pk.hex(),
                      "octets_cle_publique": len(pk), "messages": DOCS["MLD-C01"], "variantes": variants}

    S = _slh()
    kp = S.KeyPair.gen(S.shake_128f)
    variants = []
    for mid, sids in (("M1", ("S1", "S2")), ("M2", ("S3", "S4"))):
        msg = DOCS["SLH-C01"][mid].encode()
        for sid in sids:
            sig = kp.sign_pure(msg, randomize=True)
            assert kp.verify_pure(msg, sig)
            variants.append({"id_preuve_sigma": f"SLH-C01-{sid}", "id_message_m": f"SLH-C01-{mid}",
                             "condense_sha256_message": hashlib.sha256(msg).hexdigest(),
                             "signature_hex": sig.hex(), "octets": len(sig)})
    pub = kp.pub.digest()
    out["SLH-C01"] = {"schema": "SLH-DSA-SHAKE-128f (FIPS 205), signature randomisée",
                      "cle_publique_hex": pub.hex(), "octets_cle_publique": len(pub),
                      "messages": DOCS["SLH-C01"], "variantes": variants}
    return out


def check(data: dict) -> list[str]:
    errors = []
    M = _mldsa()
    d = data["MLD-C01"]
    pk = bytes.fromhex(d["cle_publique_hex"])
    for v in d["variantes"]:
        msg = d["messages"][v["id_message_m"].split("-")[-1]].encode()
        if not M.verify(pk, msg, bytes.fromhex(v["signature_hex"])):
            errors.append(v["id_preuve_sigma"])
        other = d["messages"]["M2" if v["id_message_m"].endswith("M1") else "M1"].encode()
        if M.verify(pk, other, bytes.fromhex(v["signature_hex"])):
            errors.append(v["id_preuve_sigma"] + " (accepted on the other message)")
    S = _slh()
    d = data["SLH-C01"]
    pub = S.PublicKey.from_digest(bytes.fromhex(d["cle_publique_hex"]), S.shake_128f)
    for v in d["variantes"]:
        msg = d["messages"][v["id_message_m"].split("-")[-1]].encode()
        if not pub.verify_pure(msg, bytes.fromhex(v["signature_hex"])):
            errors.append(v["id_preuve_sigma"])
        other = d["messages"]["M2" if v["id_message_m"].endswith("M1") else "M1"].encode()
        if pub.verify_pure(other, bytes.fromhex(v["signature_hex"])):
            errors.append(v["id_preuve_sigma"] + " (accepted on the other message)")
    for k in ("MLD-C01", "SLH-C01"):
        sigs = [v["signature_hex"] for v in data[k]["variantes"]]
        if len(set(sigs)) != 4:
            errors.append(f"{k}: variants not pairwise distinct")
    return errors


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--check", action="store_true")
    a = ap.parse_args()
    if a.check:
        errs = check(json.loads(OUT.read_text(encoding="utf-8")))
        print("8 signatures vérifiées, variantes distinctes" if not errs else f"ERREURS : {errs}")
        raise SystemExit(1 if errs else 0)
    data = build()
    OUT.write_text(json.dumps(data, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
    for k in ("MLD-C01", "SLH-C01"):
        print(k, data[k]["octets_cle_publique"], [abbrev(bytes.fromhex(v["signature_hex"])) + f" ({v['octets']} o)"
                                                 for v in data[k]["variantes"]])
    print(f"écrit : {OUT.name}")


if __name__ == "__main__":
    main()
