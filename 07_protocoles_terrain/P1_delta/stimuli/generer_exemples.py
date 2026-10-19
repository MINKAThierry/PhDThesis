# SPDX-License-Identifier: MIT
"""Generate the cryptographic values of the two worked P1 stimuli.

PROPOSAL - field protocol not deployed. PEDAGOGICAL CODE - NOT AUDITED.

Two context-proof pairs of the P1 catalogue are written out in full:

* ``ECD-C01``: ECDSA P-256 / SHA-256 signature of a commercial lease
  (two lease versions M1, M2; two signatures per version S1..S4).
* ``HEL-C01``: Helios-style ballot, exponential ElGamal in the 2048-bit
  MODP group of RFC 3526 (group 14) with disjunctive Chaum-Pedersen proofs
  (two choices M1, M2; two encryptions per choice S1..S4).

All randomness (keys, ECDSA nonces, ElGamal randomness, proof commitments)
is derived from public labels with SHAKE-256 so that the stimuli can be
regenerated bit for bit. This is acceptable for stimulus material only.
A real signer must never derive nonces this way from public data.

Usage::

    python3 generer_exemples.py            # writes exemples_stimuli.json
    python3 generer_exemples.py --check    # regenerates and verifies

The ECDSA signatures are cross-checked with the ``cryptography`` package
when it is installed.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

OUT = Path(__file__).with_name("exemples_stimuli.json")
SEED = b"MINKAThierry/PhDThesis/P1/stimuli/v1"


def derive(label: str, modulus: int) -> int:
    """Public, reproducible pseudo-random integer in [1, modulus - 1]."""
    out_len = (modulus.bit_length() + 128 + 7) // 8
    x = int.from_bytes(hashlib.shake_256(SEED + b"/" + label.encode()).digest(out_len), "big")
    return 1 + x % (modulus - 1)


# ---------------------------------------------------------------------------
# ECDSA P-256 (FIPS 186-5), affine arithmetic, pure Python
# ---------------------------------------------------------------------------
P256_P = 2**256 - 2**224 + 2**192 + 2**96 - 1
P256_A = P256_P - 3
P256_B = 0x5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B
P256_N = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551
P256_G = (0x6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296,
          0x4FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5)


def ec_add(P, Q):
    if P is None:
        return Q
    if Q is None:
        return P
    if P[0] == Q[0] and (P[1] + Q[1]) % P256_P == 0:
        return None
    if P == Q:
        lam = (3 * P[0] * P[0] + P256_A) * pow(2 * P[1], -1, P256_P) % P256_P
    else:
        lam = (Q[1] - P[1]) * pow(Q[0] - P[0], -1, P256_P) % P256_P
    x = (lam * lam - P[0] - Q[0]) % P256_P
    return x, (lam * (P[0] - x) - P[1]) % P256_P


def ec_mul(k, P):
    R = None
    while k:
        if k & 1:
            R = ec_add(R, P)
        P = ec_add(P, P)
        k >>= 1
    return R


def compress(P) -> str:
    return ("02" if P[1] % 2 == 0 else "03") + format(P[0], "064x")


def ecdsa_sign(d: int, msg: bytes, nonce_label: str) -> tuple[int, int]:
    e = int.from_bytes(hashlib.sha256(msg).digest(), "big")
    k = derive(nonce_label, P256_N)
    r = ec_mul(k, P256_G)[0] % P256_N
    s = pow(k, -1, P256_N) * (e + r * d) % P256_N
    return r, s


def ecdsa_verify(Q, msg: bytes, r: int, s: int) -> bool:
    if not (1 <= r < P256_N and 1 <= s < P256_N):
        return False
    e = int.from_bytes(hashlib.sha256(msg).digest(), "big")
    w = pow(s, -1, P256_N)
    X = ec_add(ec_mul(e * w % P256_N, P256_G), ec_mul(r * w % P256_N, Q))
    return X is not None and X[0] % P256_N == r


LEASE = {
    "M1": "BAIL-FICTIF-ECD-C01 | version A | loyer mensuel 850000 FCFA | "
          "revision annuelle 3 % | duree 6 ans | preneur SARL FICTIVE",
    "M2": "BAIL-FICTIF-ECD-C01 | version B | loyer mensuel 850000 FCFA | "
          "revision annuelle 8 % | duree 6 ans | preneur SARL FICTIVE",
}


def build_ecd_c01() -> dict:
    d = derive("ECD-C01/signing-key", P256_N)
    Q = ec_mul(d, P256_G)
    variants = []
    for msg_id, sig_ids in (("M1", ("S1", "S2")), ("M2", ("S3", "S4"))):
        msg = LEASE[msg_id].encode()
        for sid in sig_ids:
            r, s = ecdsa_sign(d, msg, f"ECD-C01/nonce/{sid}")
            assert ecdsa_verify(Q, msg, r, s)
            variants.append({
                "id_preuve_sigma": f"ECD-C01-{sid}",
                "id_message_m": f"ECD-C01-{msg_id}",
                "condense_sha256": hashlib.sha256(msg).hexdigest(),
                "r": format(r, "064x"),
                "s": format(s, "064x"),
                "signature_r_s_64_octets": format(r, "064x") + format(s, "064x"),
            })
    return {
        "id_stimulus": "ECD-C01",
        "schema": "ECDSA P-256 / SHA-256 (FIPS 186-5), signature brute r||s",
        "cle_publique_compressee": compress(Q),
        "messages": {k: v for k, v in LEASE.items()},
        "variantes": variants,
    }


# ---------------------------------------------------------------------------
# Helios-style ballot: exponential ElGamal + disjunctive Chaum-Pedersen
# ---------------------------------------------------------------------------
MODP14_P = int(
    "FFFFFFFFFFFFFFFFC90FDAA22168C234C4C6628B80DC1CD1"
    "29024E088A67CC74020BBEA63B139B22514A08798E3404DD"
    "EF9519B3CD3A431B302B0A6DF25F14374FE1356D6D51C245"
    "E485B576625E7EC6F44C42E9A637ED6B0BFF5CB6F406B7ED"
    "EE386BFB5A899FA5AE9F24117C4B1FE649286651ECE45B3D"
    "C2007CB8A163BF0598DA48361C55D39A69163FA8FD24CF5F"
    "83655D23DCA3AD961C62F356208552BB9ED529077096966D"
    "670C354E4ABC9804F1746C08CA18217C32905E462E36CE3B"
    "E39E772C180E86039B2783A2EC07A28FB5C55DF06F4C52C9"
    "DE2BCBF6955817183995497CEA956AE515D2261898FA0510"
    "15728E5A8AACAA68FFFFFFFFFFFFFFFF", 16)
MODP14_Q = (MODP14_P - 1) // 2
MODP14_G = 2  # generates the order-q subgroup (RFC 3526, p = 7 mod 8)
p, q, g = MODP14_P, MODP14_Q, MODP14_G


def fs_challenge(*items: int) -> int:
    h = hashlib.sha256()
    for it in items:
        h.update(format(it, "x").encode() + b"|")
    return int.from_bytes(h.digest(), "big") % q


def prove_disjunctive(y, alpha, beta, r, plaintext, allowed, label):
    """Prove that (alpha, beta) encrypts g^v for some v in ``allowed``."""
    commits, chals, resps = {}, {}, {}
    for v in allowed:
        if v == plaintext:
            continue
        c_v = derive(f"{label}/sim-c/{v}", q)
        z_v = derive(f"{label}/sim-z/{v}", q)
        beta_v = beta * pow(pow(g, v, p), -1, p) % p
        a = pow(g, z_v, p) * pow(pow(alpha, c_v, p), -1, p) % p
        b = pow(y, z_v, p) * pow(pow(beta_v, c_v, p), -1, p) % p
        commits[v], chals[v], resps[v] = (a, b), c_v, z_v
    w = derive(f"{label}/w", q)
    commits[plaintext] = (pow(g, w, p), pow(y, w, p))
    flat = [x for v in allowed for x in commits[v]]
    c = fs_challenge(y, alpha, beta, *flat)
    chals[plaintext] = (c - sum(chals[v] for v in allowed if v != plaintext)) % q
    resps[plaintext] = (w + chals[plaintext] * r) % q
    return [{"valeur": v, "A": commits[v][0], "B": commits[v][1],
             "c": chals[v], "z": resps[v]} for v in allowed]


def verify_disjunctive(y, alpha, beta, proof) -> bool:
    flat = []
    for item in proof:
        v, A, B, c_v, z_v = item["valeur"], item["A"], item["B"], item["c"], item["z"]
        beta_v = beta * pow(pow(g, v, p), -1, p) % p
        if pow(g, z_v, p) != A * pow(alpha, c_v, p) % p:
            return False
        if pow(y, z_v, p) != B * pow(beta_v, c_v, p) % p:
            return False
        flat += [A, B]
    return sum(i["c"] for i in proof) % q == fs_challenge(y, alpha, beta, *flat)


def abbrev(x: int) -> str:
    h = format(x, "x")
    return h if len(h) <= 32 else f"{h[:16]}...{h[-16:]}"


CHOICES = {"M1": [1, 0], "M2": [0, 1]}  # one 0/1 ciphertext per list


def build_hel_c01() -> dict:
    x = derive("HEL-C01/trustee-secret", q)
    y = pow(g, x, p)
    variants = []
    for msg_id, ballot_ids in (("M1", ("S1", "S2")), ("M2", ("S3", "S4"))):
        for sid in ballot_ids:
            cts, rs = [], []
            for j, v in enumerate(CHOICES[msg_id]):
                r = derive(f"HEL-C01/{sid}/r/{j}", q)
                alpha, beta = pow(g, r, p), pow(g, v, p) * pow(y, r, p) % p
                proof = prove_disjunctive(y, alpha, beta, r, v, [0, 1], f"HEL-C01/{sid}/opt{j}")
                assert verify_disjunctive(y, alpha, beta, proof)
                cts.append({"alpha": alpha, "beta": beta, "preuve_0_1": proof})
                rs.append(r)
            A = cts[0]["alpha"] * cts[1]["alpha"] % p
            B = cts[0]["beta"] * cts[1]["beta"] % p
            overall = prove_disjunctive(y, A, B, sum(rs) % q, 1, [1], f"HEL-C01/{sid}/overall")
            assert verify_disjunctive(y, A, B, overall)
            tracker = hashlib.sha256(
                b"|".join(format(c[k], "x").encode() for c in cts for k in ("alpha", "beta"))
            ).hexdigest()
            variants.append({
                "id_preuve_sigma": f"HEL-C01-{sid}",
                "id_message_m": f"HEL-C01-{msg_id}",
                "empreinte_bulletin_sha256": tracker,
                "chiffres": [{"alpha": abbrev(c["alpha"]), "beta": abbrev(c["beta"])} for c in cts],
                "verification_preuves_0_1": True,
                "verification_preuve_somme_1": True,
                "_valeurs_completes": {
                    "chiffres": [{k: format(c[k], "x") for k in ("alpha", "beta")} for c in cts],
                    "preuves_0_1": [[{k: format(i[k], "x") if k != "valeur" else i[k]
                                      for k in i} for i in c["preuve_0_1"]] for c in cts],
                    "preuve_somme_1": [{k: format(i[k], "x") if k != "valeur" else i[k]
                                        for k in i} for i in overall],
                },
            })
    return {
        "id_stimulus": "HEL-C01",
        "schema": "ElGamal exponentiel, groupe MODP 2048 bits (RFC 3526 groupe 14), g = 2, "
                  "preuves de Chaum-Pedersen disjonctives (style Helios)",
        "cle_publique_scrutin": abbrev(y),
        "messages": {"M1": "choix liste 1 (vecteur [1, 0])", "M2": "choix liste 2 (vecteur [0, 1])"},
        "variantes": variants,
    }


def crosscheck_ecdsa(data: dict) -> str:
    try:
        from cryptography.hazmat.primitives import hashes
        from cryptography.hazmat.primitives.asymmetric import ec
        from cryptography.hazmat.primitives.asymmetric.utils import encode_dss_signature
    except ImportError:
        return "cryptography non installé, contrôle croisé ignoré"
    pk = ec.EllipticCurvePublicKey.from_encoded_point(
        ec.SECP256R1(), bytes.fromhex(data["cle_publique_compressee"]))
    for v in data["variantes"]:
        msg = data["messages"][v["id_message_m"].split("-")[-1]].encode()
        sig = encode_dss_signature(int(v["r"], 16), int(v["s"], 16))
        pk.verify(sig, msg, ec.ECDSA(hashes.SHA256()))  # raises on failure
    return "4 signatures ECDSA vérifiées par le paquet cryptography"


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--check", action="store_true",
                    help="regenerate and compare with the committed JSON file")
    args = ap.parse_args()
    data = {"ECD-C01": build_ecd_c01(), "HEL-C01": build_hel_c01()}
    print(crosscheck_ecdsa(data["ECD-C01"]))
    text = json.dumps(data, indent=1, ensure_ascii=False) + "\n"
    if args.check:
        same = OUT.exists() and OUT.read_text(encoding="utf-8") == text
        print("identique au fichier versionné" if same else "DIFFÉRENT du fichier versionné")
        raise SystemExit(0 if same else 1)
    OUT.write_text(text, encoding="utf-8")
    print(f"écrit : {OUT.name}")


if __name__ == "__main__":
    main()
