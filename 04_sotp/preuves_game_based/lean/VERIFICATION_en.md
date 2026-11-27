# Verification dossier for the game-based proofs of SOTP

*Version française : [VERIFICATION_fr.md](VERIFICATION_fr.md)*

This dossier lets a reader judge what `GameBasedSOTP.lean` proves without reading all the code. It follows the structure of [`../../../05_formalisation_lean/VERIFICATION_en.md`](../../../05_formalisation_lean/VERIFICATION_en.md), itself taken from the repository of the Lean proof of the Riemann hypothesis. It is **additive**. Version 1.1 of 27 November 2026 reuses version 1.0 of 22 November unchanged. Version 1.2 of the same day appends Sections 5 and 6. Lines 5 to 275 remain those of version 1.0; only line 4, which carries the version number, has changed.

## What to read and in which order

| Order | File | Role |
|---|---|---|
| 1 | this document | Map, traceability and limits |
| 2 | [`Verification/Enonces.lean`](Verification/Enonces.lean) | The 12 statements of Appendix A and Chapter 3, with no proof at all, each with its reference to manuscript v36 |
| 3 | [`Verification/Principal.lean`](Verification/Principal.lean) | One line per statement, of the form `theorem principal_x : Enonces.X := existingName` |
| 4 | [`Verification/Coherence.lean`](Verification/Coherence.lean) | Non-vacuity tests of the project's own definitions |
| 5 | `results/verification.log`, `results/axiomes.txt` | Outputs of the audit script (produced by the workflow) |
| 6 | [`GameBasedSOTP.lean`](GameBasedSOTP.lean) | The proofs, 541 lines |

## How to check

```bash
cd 04_sotp/preuves_game_based/lean
lake exe cache get && lake build GameBasedSOTP Verification
bash verifier.sh
```

The script fails if `Enonces.lean` contains a proof, if `sorry`, `admit`, `native_decide` or `axiom` appears in the sources, if `Principal.lean` does not link every statement to an existing theorem, if the build fails, if a `#print axioms` goes beyond the three standard axioms or if `leanchecker` or `nanoda_bin` rejects the declarations. The main file can also be checked by pasting it into <https://live.lean-lang.org> (Mathlib project).

## What has been built and what has not

| Check | Where | Result |
|---|---|---|
| Version 1.1: `GameBasedSOTP`, then `Enonces`, `Principal` and `Coherence` | local, 27 November 2026, Lean 4.35.0, Mathlib v4.35.0 with targeted imports | passed, no error and no warning; 6 `#print axioms` in the file, 6 on `Principal.lean` and 5 on `Coherence.lean`, all standard |
| Version 1.0 on live.lean-lang.org and locally | 22 November 2026 | passed, six standard `#print axioms` |
| Version 1.2 pasted into <https://live.lean-lang.org> (Mathlib project) | run by Thierry MINKA on 27 November 2026 | no error; all 12 `#print axioms` show `[propext, Classical.choice, Quot.sound]` |
| Version 1.2 with full `import Mathlib`, `verifier.sh` steps 1 to 6 | run by GitHub on 27 November 2026 | workflow `verification_lean_sotp.yml`, run 46011771993 passed (commit f73fa3d): 12 statements and 7 coherence lemmas limited to the three standard axioms, `leanchecker` on the four modules, `nanoda_bin` on `Principal.lean` |
| Version 1.2: `GameBasedSOTP`, then `Enonces`, `Principal` and `Coherence` | local, 27 November 2026, Lean 4.35.0, Mathlib v4.35.0 with targeted imports | passed, no error and no warning; 12 `#print axioms` in the file, 12 on `Principal.lean` and 7 on `Coherence.lean`, all standard |
| Version 1.1 with full `import Mathlib`, `verifier.sh` steps 1 to 6 | run by GitHub on 27 November 2026 | workflow `verification_lean_sotp.yml`, run 46004902085 passed (commit 771e24b): 6 statements and 5 coherence lemmas limited to the three standard axioms, `leanchecker` on the four modules, `nanoda_bin` on `Principal.lean` |

## Traceability table

Numbers and pages are those of manuscript v36 (`index_labels_v36.tsv`). "File" is the line in `GameBasedSOTP.lean`. `E` and `P` are the lines in `Enonces.lean` and `Principal.lean`. All twelve theorems show `[propext, Classical.choice, Quot.sound]`.

| Statement of the manuscript | Label | No. and page v36 | Lean name | File | E / P | Status |
|---|---|---|---|---|---|---|
| One-time pad, the law of m + y does not depend on m | `thm:ann_sotp_low_conf` | Theorem A.1, proof, p. 225 | `otp_uniform` | 78 | 35 / 17 | proved |
| Reduction of SOTP-Low to the PRG, Adv^IND-CONF(A) = Adv^PRG(B) | `thm:ann_sotp_low_conf` | Theorem A.1, p. 225 | `ind_conf_eq_prg` | 139 | 42 / 18 | proved in the reduced setting (a) |
| Uniform mask, zero advantage | `thm:ann_sotp_low_conf` | Theorem A.1, p. 225 | `ind_conf_perfect_otp` | 149 | 48 / 19 | proved |
| Discrete-log extraction from two Pedersen openings | `def:ann_pedersen` | Definition A.2, p. 220 | `pedersen_extract` | 196 | 56 / 22 | proved |
| Reduction of SOTP-Low to DLOG, a win yields x | `thm:ann_sotp_low_rel` | Theorem A.2, p. 226 | `bind_rel_gives_dlog` | 234 | 63 / 23 | proved in the reduced setting (a) |
| Win^BIND-REL(A) ≤ Adv^DLOG(B) | `thm:ann_sotp_low_rel`, `eq:ann_sotp_low_rel` | Theorem A.2 (p. 226), (A.18) p. 228 | `win_bind_le_dlog` | 247 | 71 / 24 | proved in the reduced setting (a) |
| Theorem A.5, (A.17): with the Iron layer, Adv^IND-CONF(A) ≤ Adv^PRG(B) + 1/q | `thm:ann_sotp_low_games`, `eq:ann_sotp_low_conf` | Theorem A.5, p. 228 | `ind_conf_complet` | 364 | 87 / 28 | proved in the reduced setting (a) (b) |
| Theorem A.5, (A.18): Win^BIND-REL(A) ≤ Adv^DLOG(B) + 1/q | `thm:ann_sotp_low_games`, `eq:ann_sotp_low_rel` | Theorem A.5, p. 228 | `win_bind_complet` | 413 | 94 / 29 | proved in the reduced setting (a) |
| Law of s mod N, k + 1 or k preimages | `rem:masque_troncature` | Remark 3.5, p. 96 | `card_mod_eq` | 430 | 107 / 30 | proved |
| Statistical distance of the truncation mask, r(N − r)/(qN) | `rem:masque_troncature` | Remark 3.5, p. 96 | `trunc_dist` | 469 | 113 / 31 | proved |
| Bounds N/(4q) and 2^(−λ−1) | `rem:masque_troncature` | Remark 3.5, p. 96 | `trunc_bound` | 508 | 120 / 32 | proved |
| Case q ≥ 2^252, λ = 128: 2^(−126) and 2^(−125) | `rem:masque_troncature` | Remark 3.5, p. 96 | `trunc_ecdsa` | 522 | 127 / 33 | proved |

(a) Reduced setting of the section "Mechanisation in a reduced setting" (p. 230). Probabilities are uniform averages over finite sets. Adversaries are functions whose own randomness is absorbed in their description. The Iron layer is not modelled in the confidentiality game of version 1.0 and the Clay layer is not modelled at all.

(b) Iron layer (Section 5). The adversary receives σ₁ = m_b + G(s) and the exponent s + xρ of σ₂ = g^s·h^ρ, with h = g^x. Lemmas `com_eq` and `zpowq_inj` justify this move to the exponent. For x ≠ 0, ρ ↦ s + xρ is a bijection of ZMod q (`avg_affine`), so σ₂ is uniform and independent of s. The case x = 0, of probability 1/q, gives the 1/q term.

The IND-CONF, BIND-REL and EXT-OPP games on finite distributions and their bridges to Conf, Relver and Opp (Definitions 2.5 to 2.7 and A.5 to A.7, Remarks 2.6 to 2.8 and A.1 to A.3, Lemma A.1, Corollary A.2, Remark A.6) are proved in `ConditionalCRO.lean` version 3.8, Section 18, because they use the `CLOModel` model. See [`../../../05_formalisation_lean/VERIFICATION_en.md`](../../../05_formalisation_lean/VERIFICATION_en.md).

### Coherence tests of the project's own definitions

| Definition | Satisfying case | Non-satisfying case | Lines of `Coherence.lean` |
|---|---|---|---|
| `avg`, `ind` | avg = 1/2 for the indicator of a bit; ind = 1 on a true proposition | ind = 0 on a false proposition | 20 to 30 |
| `winIND`, `advIND`, `accB`, `advPRG` | advantage 1/2 for the adversary that reads the bit under G = 0, passed on to the reducer | advantage 0 for a constant adversary | 32 to 48 |
| `com`, `accepts`, `winsBIND`, `extract` | a proof in ZMod 2 opened on 0 and on 1, the extractor returns x = 1 | two identical openings do not win | 50 to 66 |
| `winIND2`, `advIND2`, `truncLaw`, `distStat` (version 1.2) | distance 1/6 for q = 3 and N = 2 | constant adversary, advantage 0; distance 0 for q = N | 67 to 82 |

## Map of the proof in plain language

1. *One-time pad.* `otp_uniform` (78) is the change of variable y ↦ m + y in a finite sum. Short.
2. *Confidentiality.* `accB_uniform` (113) applies the one-time pad to the uniform challenge, on which B returns 1 with probability 1/2. `ind_conf_eq_prg` (139) then swaps two averages. Short.
3. *Reliability.* `com_eq` (178) writes the commitment as g^(s + xρ). `zpowq_inj` (187) derives equality of the exponents in ZMod q, then `pedersen_extract` (196) solves for x. `bind_rel_gives_dlog` (234) shows that distinct messages force distinct seeds. `win_bind_le_dlog` (247) compares the indicators pointwise.
4. *Complete bounds.* `ind_conf_complet` (364) splits the average over x into x = 0 and x ≠ 0. For x ≠ 0, `avg_affine` (328) makes the exponent uniform and B's simulation is exact. `accB2_uniform` (339) shows that B returns 1 with probability 1/2 on a uniform challenge. Medium length.
5. *Truncation.* `card_mod_eq` (430) counts the preimages with Mathlib's `Nat.count_modEq_card_eq_ceil`. `trunc_dist` (469) sums the positive gaps, which are (N − r)/(qN) for y < r and 0 otherwise. Short.

## Limits stated plainly

1. **Reduced setting.** The theorems are not about time-bounded probabilistic adversaries nor about families indexed by λ. The full probabilistic model (VCVio) is an option of lot L4 of the roadmap.
2. **PRG and DLOG.** Their security is not proved. The theorems relate the advantage of A to that of the reducer B, which is the exact form of a reduction.
3. **Iron and Clay layers.** Since version 1.2 the Iron layer appears in the confidentiality game (Section 5). The Clay layer is not modelled.
4. **SOTP-Base and SOTP-High.** They are not mechanised here (lot L4).
5. **Local build with targeted imports.** The local build replaces `import Mathlib` with ten Mathlib modules. The GitHub workflow builds with the full `import Mathlib`. Lean 4.35.0 prints a warning there that suggests the `module` keyword, with no effect on the proofs.
6. **Truncation.** Section 6 computes the distance between G(s) and the uniform law. The step to Conf ≥ 1 − 2^(−λ) for the laws of σ given two messages follows from the triangle inequality; it is not formalised here.

## Reproducibility

| Item | Value |
|---|---|
| Lean | v4.35.0 ([`lean-toolchain`](lean-toolchain)) |
| Mathlib | v4.35.0, commit `56a005855ea17e0b0958f73ec801ae140b0a1679` ([`lake-manifest.json`](lake-manifest.json)) |
| Lake libraries | `GameBasedSOTP` (default target) and `Verification` |
| SHA-256 of `GameBasedSOTP.lean` | `cf39e99aadaa4a16b1edb7b57a95bf826f9a3225395cd047b950397e97044a70` (version 1.2) |
