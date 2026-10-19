> **Status: PROPOSAL — reference implementation** (SOTP-High construction, not audited, demonstration) · Source: thesis, Chapter 3, SOTP-High subsection (Algorithm 3, proposition and remarks); Appendix A, theorem `thm:ann_sotp_high`

# SOTP-High — executable reference implementation

[Version française](README_fr.md)

This folder contains an executable implementation of the SOTP-High construction described in Chapter 3 of the thesis. The circuit is written in Circom 2 and the proof is a Groth16 zk-SNARK over the BN254 curve (called `bn128` in snarkjs). The whole folder is a demonstration. It has not been security-audited, and the setup ceremony it runs is local, hence not secure for real use.

## Proved relation

The circuit establishes the relation of Appendix A (theorem `thm:ann_sotp_high`)

$$
\mathcal{R} = \{((h_c, c_m), (m, c, \rho)) : h_c = \mathsf{Poseidon}(c) \wedge c_m = m\cdot G + \rho\cdot H \wedge \mathsf{Conforme}(m, c) = 1\}.
$$

The thesis writes the commitment multiplicatively ($c_m = g^m h^\rho$). The circuit uses the additive notation of the Baby Jubjub curve, which is equivalent.

### Mapping circuit ↔ relation $\mathcal{R}$ ↔ Gold/Iron/Clay layers

| Thesis element | Layer | Realisation in `circuits/sotp_high.circom` |
|---|---|---|
| $h_c = \mathsf{Poseidon}(c)$ | Clay | circomlib `Poseidon(4)` over `c[0..3]`, public output `h_c` |
| $c_m = g^m h^\rho$ | Iron | `PedersenCommitBJJ`: `EscalarMulFix(64, G)` + `EscalarMulFix(253, H)` + `BabyAdd`, public outputs `cm_x`, `cm_y` |
| $\mathsf{Conforme}(m, c) = 1$ | certified assertion | `ConformeAML`: `Num2Bits(64)` (range checks) + `LessThan(64)` + allowed-list membership |
| ZK of $\pi$ | Gold | provided by Groth16 (snarkjs), not by the circuit |
| $\mathsf{Groth16.Verify}$, line 15 ($b_1$) | — | `snarkjs.groth16.verify` in `scripts/verify.js` and `scripts/verify.sh` |
| $[c_m \in \mathbb{G}]$, line 16 ($b_2$) | Iron | `babyjub.inCurve` and `babyjub.inSubgroup` (circomlibjs) in `scripts/verify.js` |
| $\sigma = (h_c, \pi, c_m, \mathsf{metadata})$, line 13 | Clay | `sigma.json` written by `scripts/prove.js` |
| Setup with destruction of toxic waste, lines 2 to 7 | — | `scripts/build.sh` (local demonstration ceremony, see below) |

The public signals appear in `public.json` in the order `[h_c, cm_x, cm_y]`. The private witness consists of `m`, `c[0..3]` and `rho`.

### Clay layer: encoded institutional context

The context $c$ is a vector of four elements of the BN254 scalar field.

| Field | Meaning in the example |
|---|---|
| `c[0]` | reporting threshold $T$ (currency units, $< 2^{64}$) |
| `c[1]` | operation type code |
| `c[2]` | jurisdiction code (120 in the examples, ISO 3166 numeric code of Cameroon) |
| `c[3]` | rule-set version |

The digest $h_c$ is a BN254 field element (about 254 bits), whereas the thesis speaks of a 256-bit digest. Fields `c[2]` and `c[3]` only enter through $h_c$ in this example.

### Iron layer: in-circuit Pedersen commitment

The commitment $c_m = m\cdot G + \rho\cdot H$ is computed inside the circuit on Baby Jubjub, a twisted Edwards curve defined over the BN254 scalar field, which makes curve arithmetic native in the circuit. The generators $G$ and $H$ are the first two base points of circomlib's Pedersen hash (`BASE[0]` and `BASE[1]` in `pedersen.circom`). circomlib obtains them by try-and-increment from `blake256("PedersenGenerator_<i>_<try>")`. The first encoding that decompresses to a curve point is kept and multiplied by the cofactor 8, which puts the point in the prime-order subgroup of order $\ell$ (about $2^{251}$). This nothing-up-my-sleeve derivation is public and reproducible. Nobody therefore knows $\log_G H$, on which the binding property of the commitment relies under the DLog assumption. The test `generators G, H are the nothing-up-my-sleeve circomlib Pedersen bases` recomputes both points with circomlibjs and checks that they match the circuit constants.

The prover samples $\rho$ uniformly in $[0, \ell)$ (`sampleRho` in `scripts/lib.js`). The commitment is then uniform in the subgroup whatever $m$ is, which gives the perfect hiding invoked by the thesis proposition. The amount $m$ is constrained to 64 bits and $\rho$ to 253 bits.

### Predicate $\mathsf{Conforme}(m, c)$: an example

The implemented predicate is an anti-money-laundering (AML) style compliance rule, chosen for illustration.

$$
\mathsf{Conforme}(m, c) = 1 \iff m < c[0] \ \wedge\ c[1] \in \{1, 2, 3\}.
$$

The amount must be strictly below the threshold set by the context, and the operation type must belong to the allowed list, which is fixed in the circuit and therefore public. The `Num2Bits(64)` range checks on $m$ and $c[0]$ are required, otherwise the `LessThan(64)` comparator could be fooled by wrap-around modulo $p$ (the case `inputs/hors_plage.json`, a "negative" amount $p-1$, checks this).

This predicate is only an example. Another institutional context would call for another predicate, hence another circuit and another circuit-specific Groth16 setup.

## What the run demonstrates

- **Completeness.** For a witness satisfying $\mathcal{R}$, the proof is generated and accepted ($b_1 \wedge b_2$). The public signals match an off-circuit computation of $\mathsf{Poseidon}(c)$ and $m\cdot G + \rho\cdot H$.
- **Rejection.** A proof with one modified public signal ($h_c$, `cm_x` or `cm_y`) is rejected, as is a proof replayed with the digest of another context or a proof with a tampered element. No witness can be produced for a non-compliant input (amount above the threshold, amount equal to the threshold, disallowed operation type, out-of-range amount).
- **Zero knowledge.** It is inherited from Groth16 (a property of the proof system, not tested by the run). The hiding test only observes that two commitments to the same $m$ with different $\rho$ differ while $h_c$ stays the same.

## What the run does not demonstrate

- No lower bound on opposability. In line with remark `rem:heuristique_sotp_high` and theorem `thm:ann_sotp_high`, $h_c$ and the metadata are functions of the public context ($I(V; h_c \mid C) = 0$). The expression $0.45\,\beta\log_2\lambda/\lambda$ remains an unproven design heuristic. The institutional parameters $\Delta$, $\alpha$, $\beta$ do not appear in this code.
- No optimality. Optimality of the SOTP family is a conjecture of the thesis.
- No setup security. The Powers of Tau ceremony and phase 2 are run locally by a single party with randomness from `/dev/urandom`. Whoever runs `build.sh` could keep the toxic waste and forge proofs. The thesis lists the trusted setup as a limitation of SOTP-High. Real use would require a multi-party ceremony.
- No audit of the code, the circuit or the dependencies. Correctness of the example predicate only holds for the toy rule described above.
- No post-quantum security (Groth16 and Pedersen rest on discrete-logarithm and pairing assumptions).

## Requirements

- Node.js ≥ 18 (tested with Node 22.22.2) and npm.
- No global installation. The Circom compiler is provided by the npm package `circom2` (circom 2.2.2 compiled to WebAssembly).

Versions are pinned in `package.json` and `package-lock.json`.

| Package | Version | Role |
|---|---|---|
| `circom2` | 0.2.22 (circom 2.2.2) | circuit compilation |
| `snarkjs` | 0.7.6 | Powers of Tau, Groth16 setup, proving and verification |
| `circomlib` | 2.0.5 | Poseidon, Baby Jubjub and comparator gadgets |
| `circomlibjs` | 0.1.7 | off-circuit reference computations and $b_2$ check |

## Commands

```bash
npm install                      # pinned dependencies
bash scripts/build.sh            # compile + Powers of Tau 2^13 + Groth16 setup (~5 min)
bash scripts/prove.sh inputs/conforme.json          # -> build/out/conforme/
bash scripts/verify.sh build/out/conforme           # b1 (snarkjs CLI then JS) and b2
node scripts/verify.js build/out/conforme --open build/out/conforme/opening.json   # opening of c_m
node scripts/prove.js inputs/non_conforme.json build/out/nc   # fails, exit code 2
npm test                         # node --test test/sotp_high.test.js
bash scripts/run_all.sh          # full chain (REBUILD=1 to redo the setup)
```

### Input files

| File | Content | Expected result |
|---|---|---|
| `inputs/conforme.json` | $m = 750{,}000$, threshold $10^6$, type 1 | proof accepted |
| `inputs/conforme_limite.json` | $m = 999{,}999$, threshold $10^6$, type 3 | proof accepted |
| `inputs/non_conforme.json` | $m = 1{,}500{,}000$, threshold $10^6$ | no witness |
| `inputs/seuil_atteint.json` | $m = 10^6$ equal to the threshold | no witness |
| `inputs/type_non_autorise.json` | type 7 | no witness |
| `inputs/hors_plage.json` | $m = p - 1$ | no witness (range check) |

An optional `rho` field fixes the commitment randomness. When absent, `prove.js` samples it uniformly in $[0, \ell)$.

### Output files

`scripts/prove.js` writes `proof.json` ($\pi$), `public.json` ($h_c$, `cm_x`, `cm_y`), `sigma.json` ($\sigma$ with metadata, including the SHA-256 fingerprint of the verification key) and `opening.json` to the output folder. The latter holds the secret opening $(m, c, \rho)$ kept by the prover. It is excluded from version control.

The `examples/` folder keeps `verification_key.json`, one proof `proof.json`, its signals `public.json` and `sigma.json`. Large files (`.ptau`, `.zkey`, `.r1cs`, `.wasm`) are git-ignored and regenerated by `scripts/build.sh`. The verification key in `examples/` matches the last setup that was run. A new run of `build.sh` produces another key, after which `run_all.sh` regenerates the examples.

## Expected output (excerpt of `run_all.sh`)

```text
[prove] witness + Groth16 proof OK for inputs/conforme.json in 1239 ms
[verify] b1 Groth16.Verify = true
[verify] b2 c_m in subgroup = true
[verify] opening (m, c, rho) matches (h_c, c_m) = true
[verify] ACCEPT
   non_conforme: no witness (expected)
   seuil_atteint: no witness (expected)
   type_non_autorise: no witness (expected)
   hors_plage: no witness (expected)
# tests 15
# pass 15
# fail 0
### run_all: all steps passed
```

## Measured performance

Measurements were taken on the development machine (Linux, Node 22.22.2, snarkjs 0.7.6). They are indicative.

| Quantity | Value |
|---|---|
| R1CS constraints | 6,135 (5,457 non-linear, 678 linear) |
| Wires | 6,135 |
| Private inputs / public outputs | 6 / 3 |
| Powers of Tau | $2^{13}$ = 8,192 |
| Full setup (`build.sh`) | ~4 min 40 s (dominated by `powersoftau prepare phase2`) |
| Size of `proof.json` (snarkjs compact JSON) | ~723 bytes |
| Size of `public.json` | ~238 bytes |
| Compressed size of $\pi$ (3 group elements, A and C in $\mathbb{G}_1$, B in $\mathbb{G}_2$), informative | 32 + 64 + 32 = 128 bytes |
| Witness and proof generation | ~0.85 to 1.25 s |
| Groth16 verification (warm, median of 10) | ~26 ms |
| Cold verification (including curve initialisation) | ~0.3 to 0.9 s |

The 128-byte size is the lower end of the 128 to 200 byte range quoted in the thesis. It does not depend on the circuit size.

## Layout

```text
circuits/sotp_high.circom   circuit (ConformeAML, PedersenCommitBJJ, SotpHigh)
scripts/build.sh            compilation and local demonstration setup
scripts/prove.js|prove.sh   Prove: witness, proof, sigma, opening
scripts/verify.js|verify.sh Verify: b1 and b2, optional opening
scripts/run_all.sh          full chain
scripts/lib.js              helpers (Poseidon, Baby Jubjub, generators, randomness)
inputs/                     example inputs
test/sotp_high.test.js      tests (node:test)
examples/                   example verification key, proof and public signals
```

## License

Code under the MIT license. Documentation under CC BY 4.0.
