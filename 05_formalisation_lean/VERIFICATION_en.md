# Verification dossier of the Lean formalisation

[Version française](VERIFICATION_fr.md)

This dossier lets a reader judge what the formalisation proves without reading the 1,575 lines of `ConditionalCRO.lean`. It follows the model of the repository of the Lean proof of the Riemann hypothesis (November 2026). Statements are isolated from proofs, a thin entry point links them to the theorems and a script audits the axioms. The limits are stated plainly.

The dossier is **additive**. `ConditionalCRO.lean` (version 3.4) is not modified. It remains identical to listing B.1 in Appendix B of the thesis, up to the four author lines of the header. The new files import it.

## What to read and in which order

| Order | File | Role |
|---|---|---|
| 1 | this document | Map, traceability and limits |
| 2 | [`Verification/Enonces.lean`](Verification/Enonces.lean) | The 29 statements of the thesis, with no proof at all, each with its reference to manuscript v35 |
| 3 | [`Verification/Principal.lean`](Verification/Principal.lean) | One line per statement, of the form `theorem principal_x : Enonces.X := existingName` |
| 4 | [`Verification/Coherence.lean`](Verification/Coherence.lean) | Non-vacuity tests of the project's own definitions |
| 5 | [`results/verification.log`](results/verification.log), [`results/axiomes.txt`](results/axiomes.txt) | Outputs of the audit script |
| 6 | [`ConditionalCRO.lean`](ConditionalCRO.lean) | The proofs, to be opened only at the lines given by the map below |

The reviewer first compares each statement of `Enonces.lean` with the text of the manuscript. This is the only human step. Compiling `Principal.lean` then guarantees that each statement is exactly the one proved by the theorem. Any mismatch, even a weakening, breaks the build. Five mutation tests confirmed this (see below).

## How to verify

Run these commands from this folder, with `elan` installed.

```bash
lake exe cache get        # precompiled Mathlib v4.35.0
bash verifier.sh          # or bash verifier.sh --cache to chain both
```

The script fails in six cases. The first is a proof in `Enonces.lean` (keyword `by`, or a declaration other than `def Name : Prop :=`). The second is a `sorry`, `admit`, `native_decide` or `axiom` in the sources, comments excluded. The third is a line of `Principal.lean` that does not link a statement to an existing theorem. The fourth is a build failure. The fifth is a `#print axioms` that shows anything other than `[propext, Classical.choice, Quot.sound]`. The sixth is a rejection by an independent kernel checker.

This last step uses two tools shipped with the Lean 4.35.0 toolchain. `leanchecker` replays the declarations in Lean's kernel. `nanoda_bin` is a second checker, written in Rust, that reads an export produced by `leanexport`. The export covers the 29 theorems of `Principal.lean` and all their dependencies, Mathlib included. Only the three standard axioms are admitted.

The workflow [`../.github/workflows/verification_lean.yml`](../.github/workflows/verification_lean.yml) runs this script on GitHub whenever the folder changes. It complements the `lean` job of `ci.yml` without replacing it.

## What was compiled and what was not

| Check | Where | Result |
|---|---|---|
| `lake build ConditionalCRO Verification` | local, 26 November 2026, Lean 4.35.0, Mathlib v4.35.0 | passed, no warning in `Verification` |
| `bash verifier.sh`, steps 1 to 6 | local | passed, see `results/verification.log` |
| `#print axioms` on the 29 theorems of `Principal.lean` | local | `[propext, Classical.choice, Quot.sound]` for each |
| `leanchecker` on the four modules | local | passed |
| `leanchecker --fresh Verification.Principal` (full replay from scratch) | local, outside the script | passed in 6 min 23 s |
| `nanoda_bin` on the export of `Principal.lean` | local | 28,867 declarations checked, no type error |
| Mutation tests (modified statement, weakened Pinsker, proof in `Enonces.lean`, `sorry`, `axiom`) | local | the script fails in all five cases |
| Build with the full `import Mathlib` | done by GitHub on 26 November 2026 | workflow `verification_lean.yml`, run 45889126160 succeeded, the 20 `#print axioms` list only propext, Classical.choice and Quot.sound |
| Workflow `verification_lean.yml` | run and passed | runs on every change to the Lean folder, logs in the Actions tab |

**Caveat on the local build.** The Mathlib cache hosts were unreachable. The local build therefore used a copy of `ConditionalCRO.lean` in which only line 46 differs. There `import Mathlib` is replaced by seven targeted imports from Mathlib v4.35.0, already used to check version 3.4. The rest of the file is byte-for-byte identical. The repository version, with `import Mathlib`, was not rebuilt here.

## Traceability table

Numbers and pages are those of manuscript v35 (`index_labels_v35.tsv`). "File" is the line in `ConditionalCRO.lean`; the line in listing B.1 is four less. `E` and `P` are the lines in `Enonces.lean` and `Principal.lean`. All 29 theorems show `[propext, Classical.choice, Quot.sound]`.

### Proved statements

| Manuscript statement | Label | No. and page v35 | Lean name | File | E / P | Status |
|---|---|---|---|---|---|---|
| Negligibility of ε₀ = 2^(−λ) | `lem:negligeabilite_eps0` | Lemma 3.1, p. 113 | `negligible_eps0` | 80 | 66 / 19 | proved |
| Confidentiality guarantee, Conf ≥ 1 − √(c₀βI) | `lem:confidentiality_guarantee` | Lemma 2.3, (2.46), p. 57 | `lemma4_confidentiality_guarantee` | 172 | 72 / 22 | proved, Pinsker assumed (a) |
| Trilemma, explicit form | `eq:trilemme_cro_explicite`, `eq:main_theorem_lean4_explicit` | (2.49) p. 58; (3.30) p. 114 | `trilemma_explicit` | 195 | 79 / 23 | proved, Fano assumed (a) |
| Trilemma, published form | `rem:corollaire_publie`, `thm:original_lean4` | Remark 2.17, p. 61; Theorem 3.2, p. 109 | `trilemma_instance` | 244 | 88 / 24 | proved, Fano assumed (a) |
| Trilemma, asymptotic form | `thm:conditional_CRO_trilemma`, `eq:trilemme_cro_conditionnel` | Theorem 3.3, p. 113, (3.29) p. 114; (2.48) p. 58 | `conditional_CRO_trilemma` | 274 | 96 / 25 | proved, Fano assumed (a) |
| Trilemma, refined form | `eq:trilemme_cro_raffine` | (2.50), p. 58 | `trilemma_refined` | 415 | 106 / 26 | proved, I(V;Σ\|C) ≤ H(V\|C) assumed (a) |
| Consistency witness | `thm:witness_consistency` | Theorem 3.4, p. 114 | `assumptions_consistent_and_bound_attained` | 322 | 115 / 27 | proved (b) |
| Necessity of the regime | `thm:scope_necessity` | Theorem 3.5, p. 115 | `regime_assumption_necessary` | 356 | 125 / 28 | proved |
| Helios regime | `thm:regime_helios` | Theorem 3.6, p. 120 | `Helios_regime_at_128` | 379 | 134 / 29 | proved |
| zk-SNARK regime | `thm:regime_snarks` | Theorem 3.7, p. 120 | `zkSNARK_regime_at_256` | 386 | 138 / 30 | proved |
| Traditional audit regime | `thm:regime_audit` | Theorem 3.8, p. 121 | `TraditionalAudit_regime_at_128` | 393 | 142 / 31 | proved |
| Deterministic verdict, Opp = 1 | `rem:verdict_deterministe` | Remark 2.4, p. 48 | `opp_eq_one_of_deterministic` | 402 | 147 / 32 | proved |
| Deterministic verdict, γ − I ≤ Δ | `subsec:lean4_extensions` | 3.4.8, p. 115 | `deterministic_forces_capacity` | 408 | 152 / 33 | proved |
| Institutional factor equal to 1 if Δ ≥ γ | `rem:activite_delta` | Remark 2.18, p. 61 | `refined_bound_is_fano_when_delta_ge_gamma` | 447 | 158 / 34 | proved |
| Factor < 1 if and only if Δ < γ − κ/λ | `rem:activite_delta` | Remark 2.18, p. 61; 3.4.8, p. 116 | `factor_lt_one_iff` | 459 | 167 / 35 | proved |
| Threshold H♯ = (Δ + 1 + κ/λ)/α | `eq:seuil_activite` | (2.65), p. 61; 3.4.8, p. 116 | `seuil_Hsharp` | 470 | 174 / 36 | proved |
| Finite Pinsker, TV² ≤ KL/2 (nats) | `subsec:lean4_concret` | 3.4.9, step 2, p. 117 | `pinsker_finite` | 673 | 182 / 39 | proved |
| Non-negativity of mutual information | `subsec:lean4_concret` | 3.4.9, step 3, p. 117 | `miN_nonneg` | 729 | 190 / 40 | proved |
| Mutual information bounded by entropy | `subsec:lean4_concret` | 3.4.9, step 3, p. 117 | `miN_le_entN2` | 765 | 196 / 41 | proved |
| Finite Fano, p·log N − log 2 ≤ I(M;Σ) | `subsec:lean4_concret`, `eq:fano_inequality` | 3.4.9, step 4, p. 117; (1.9), p. 17 | `fano_finite` | 793 | 202 / 42 | proved |
| I(V;Σ\|C) ≤ H(V\|C) on the model | `subsec:lean4_concret` | 3.4.9, p. 117 | `CLOModel.IV_le_HV` | 1027 | 213 / 45 | proved |
| Pinsker on the model, TVmax² ≤ c₀·KLmax | `subsec:lean4_concret`, `rem:constante_c0` | 3.4.9, p. 117; Remark 2.16, p. 58 | `CLOModel.pinsker_model` | 1077 | 220 / 46 | proved under common supports |
| Fano on the model, Rel(D)·λ − 1 ≤ I(M;Σ\|C) | `ass:reliability_axiom` | Assumption 3.4, p. 109 (now a theorem) | `CLOModel.fano_model` | 1128 | 229 / 47 | proved |
| Explicit trilemma on finite distributions | `eq:trilemme_cro_explicite`, `subsec:lean4_concret` | (2.49), p. 58; 3.4.9, p. 117 | `trilemma_explicit_concrete` | 1319 | 237 / 48 | proved under Assumptions 2.1, 2.2, 2.4 (c) |
| Refined trilemma on finite distributions | `eq:trilemme_cro_raffine`, `subsec:lean4_concret` | (2.50), p. 58; 3.4.9, p. 117 | `trilemma_refined_concrete` | 1336 | 250 / 49 | proved under Assumptions 2.1, 2.2, 2.4 (c) |
| Lemma 2.3 on finite distributions | `lem:confidentiality_guarantee`, `subsec:lean4_concret` | Lemma 2.3, p. 57; 3.4.9, p. 117 | `lemma4_concrete` | 1351 | 265 / 50 | proved under Assumption 2.3 and common supports |
| Asymptotic trilemma on finite distributions | `thm:conditional_CRO_trilemma`, `subsec:lean4_concret` | Theorem 3.3, p. 113; 3.4.9, p. 118 | `conditional_CRO_trilemma_concrete` | 1367 | 275 / 51 | proved under Assumptions 2.1, 2.2, 2.4 (c) |
| Witness family, all assumptions satisfied | `subsec:lean4_concret` | 3.4.9, p. 118 | `concrete_assumptions_satisfiable` | 1516 | 295 / 54 | proved |
| The asymptotic trilemma applies to the witness family | `subsec:lean4_concret` | 3.4.9, p. 118 | `concrete_asymptotic_applies` | 1535 | 310 / 55 | proved |

(a) In the abstract model, Fano (I ≥ Rel·λ − 1) and Pinsker (TV² ≤ c₀·KL) are fields of `ProtocolInstance`. The concrete layer proves them (lines 1077 and 1128).
(b) A point of the abstract model, not realisable by a distribution (Remark 3.10, p. 114).
(c) The institutional assumptions are explicit premises of the theorem. They carry the content specific to institutional cryptography (Δ, γ = αH(C) − 1, κ).

### Named assumptions

| Manuscript assumption | Label | No. and page v35 | Lean form | File | Role in the proofs |
|---|---|---|---|---|---|
| Bounded extraction, I(V;Σ\|C) ≤ I(M;Σ\|C) + Δ | `ass:extraction_bornee` | Assumption 2.1, p. 55; 3.1, p. 108 | field `A1`, premise `A1` | 161, 1323 | used by every trilemma |
| Efficient verdict, H(V\|C) ≥ γ = αH(C) − 1 ≥ 1 | `ass:verdicts_efficace` | Assumption 2.2, p. 56; 3.2, p. 108 | fields `A2`, `A2γ`, premises `A2`, `A2γ` | 163, 1323 | used by every trilemma |
| Efficient verdict, \|V\| ≤ 2^(αH(C)) | `ass:verdicts_efficace` | Assumption 2.2, p. 56 | premise `hcard` | 1322 | **unused** (d) |
| Regularity, D_KL ≤ β·I(M;Σ\|C) | `ass:regularite` | Assumption 2.3, p. 56; 3.3, p. 109 | field `A3`, premise `A3` | 167, 1354 | Lemma 2.3 only (d) |
| Regime, I(M;Σ\|C) ≤ κ/λ | `ass:regime` | Assumption 2.4, p. 57 | premise `hA4` or `A4` | 197, 1324 | used by every trilemma |
| Reliability-information (relaxed Fano) | `ass:reliability_axiom` | Assumption 3.4, p. 109 | field `fano` | 156 | assumed in the abstract model, proved in the concrete layer |
| Pinsker | `subsubsec:constante_pinsker` | 3.4.6.1, p. 112 | field `pinsker` | 155 | assumed in the abstract model, proved in the concrete layer |
| Common supports | `subsec:lean4_concret` | 3.4.9, p. 118 | `CLOModel.CommonSupport` | 919 | Pinsker and Lemma 2.3 only |

(d) The code says so in its own comments, as does the manuscript (3.4.7.1, p. 114; 3.4.9, p. 117).

### Outside the scope of the formalisation

| Manuscript result | Label | No. and page v35 | Status |
|---|---|---|---|
| Conf ≥ 1 − √(c₀βκ/λ), last sentence of Theorem 2.4 | `thm:trilemme_cro_conditionnel` | Theorem 2.4, p. 58 | not stated as such in Lean; it follows from Lemma 2.3 and Assumption 2.4 by monotonicity of the square root |
| Sharp bound on reliability | `prop:borne_aigue` | Proposition 2.2, p. 62 | proved on paper, not formalised |
| Realisable witness of the institutional factor | `rem:temoin_realisable` | Remark 2.20, p. 63 | proved on paper, not formalised |
| Elementary bounds, contextual bottleneck, composition | `thm:bornes_mesures`, `thm:goulot_contexte`, `thm:composition_sequentielle` | Theorems 2.1 to 2.3, pp. 46 to 49 | not formalised |
| Quantum trilemma and quantum lemmas | `thm:trilemme_pq` | Theorem 2.5, p. 77 | not formalised |
| Properties of SOTP | `thm:proprietes_sotp` | Theorem 3.1, p. 89 | outside this dossier; reduced mechanisation in `04_sotp/` |

### Consistency tests of the project's own definitions

| Definition | Satisfying case | Non-satisfying case | Lines of `Coherence.lean` |
|---|---|---|---|
| γ = αH(C) − 1 | Helios, γ = 47 | H(C) = α = 1, γ = 0 < 1 | 26 to 41 |
| `InstitutionalParams` | Helios | no parameter set with α = 0, β < 1 or Δ < 0 | 43 to 55 |
| `tv`, `klN`, `miN` | tv = 0 and KL = 0 for two equal laws; I = 0 for two independent bits | tv = 1 for two disjoint Diracs; I = log 2 for a copied bit | 59 to 87 |
| `CLOModel` | `copyModel` (Σ = M), `famModel` | no distribution where M is not uniform; no model at λ = 2 with two messages | 93 to 117 |
| `Conf` | Conf = 1 for `famModel` | Conf = 0 for `copyModel` | 120 to 153 |
| `Rel` | Rel = 1 for `copyModel` and the decoder that reads the proof | Rel = 2^(−λ) for `famModel` and a constant decoder | 136, 156 |
| `Opp` | Opp = 1 for `famModel` (verdict copying the proof) | Opp = 0 for `blindModel` (verdict ignoring the proof), with H(V\|C) = 1 | 164 to 197 |
| `InstitutionalAssumptions` | `witnessInstance` | `degenerateInstance`, where H(V\|C) = 0 | 224 to 243 |
| Division by zero in Opp | the assumptions force H(V\|C) ≥ 1 and Opp·H(V\|C) = I(V;Σ\|C) | in Lean 1/0 = 0; the degenerate instance would have Opp = 0 with I(V;Σ\|C) = 1 | 202 to 237 |

## Map of the proof in plain language

**General idea.** The whole proof expresses the three metrics through a single quantity, x = I(M;Σ|C). Fano says that Rel requires a large x. Assumptions 2.1 and 2.2 say that Opp is capped by (x + Δ)/γ. The regime of Assumption 2.4 forces x ≤ κ/λ. The product is then bounded.

**Chain of reductions in the concrete layer** (lines of `ConditionalCRO.lean`).

1. *Common tool.* Mathlib's inequality log x ≥ 1 − 1/x gives `term_ineq` (488), then the log-sum inequality `log_sum_ineq` (504). Short.
2. *Fano.* `log_sum_ineq` and `binEnt_le_log_two` (529) give `fano_finite` (793). The proof splits the (message, proof) pairs by the success of the decoder. `fano_model` (1128) applies it context by context and converts to bits. **This is one of the two hard parts** (about 100 and 45 lines).
3. *Pinsker.* A derivative argument on [q, p] gives `pinsker_aux` (549) and `pinsker_aux_one` (603). They give `pinsker_binary` (645), then `pinsker_finite` (673) by log-sum on {P > Q} and its complement. `pinsker_model` (1077) converts to bits with c₀. **This is the other hard part** (about 170 lines).
4. *Opposability.* `miN_le_entN2` (765) gives `IV_le_HV` (1027), hence Opp ≤ 1 with no assumption. Short.
5. *Product.* `product_bound_explicit` (1202) and `product_bound_refined` (1240) are real algebra. Conf ≤ 1, Rel ≤ (x + 1)/λ, Opp ≤ (x + Δ)/γ, monotonicity in x, then x ≤ κ/λ. Short and readable.
6. *Assembly.* `trilemma_explicit_concrete` (1319) and `trilemma_refined_concrete` (1336) take two lines each. `asymptotic_of_explicit` (1266) and `negligible_eps0` (80) give `conditional_CRO_trilemma_concrete` (1367). Short.
7. *Non-vacuity.* `famModel` (1401) and the `fam_*` computations (1420 to 1507) give `concrete_assumptions_satisfiable` (1516) and `concrete_asymptotic_applies` (1535). Direct computations.

**Abstract model.** `trilemma_explicit` (195) redoes step 5 with the fields of a `ProtocolInstance`. `trilemma_instance` (244) uses γ ≥ 1. `conditional_CRO_trilemma` (274) passes to the asymptotic form. `lemma4_confidentiality_guarantee` (172) chains Pinsker and regularity. Everything there is short because Fano and Pinsker are assumed.

**Where the difficulty lies.** Mathematically, the difficulty lies in Fano and Pinsker on finite distributions. The trilemma itself is short once these two inequalities are available. Its content comes from the institutional assumptions, which bring in Δ, γ = αH(C) − 1 and κ.

## Limits stated plainly

1. **Validity relative to the definitions.** The build proves that the statements follow from the definitions. It does not prove that these definitions faithfully render the manuscript. `Coherence.lean` rules out an empty or trivial definition. It does not replace peer review.
2. **Concrete layer on finite distributions.** The concrete theorems concern finite distributions, with M uniform over 2^λ values and independent of C. The verdict follows a kernel that depends only on (Σ, C). The asymptotic form keeps the sets of contexts and verdicts fixed. Continuous and arbitrary distributions are not covered.
3. **Divergence outside common supports.** With Lean's conventions (log 0 = 0, x/0 = 0), `klN` underestimates the true divergence when supports differ. It is therefore used only under `CommonSupport`.
4. **Institutional assumptions are posited.** Assumptions 2.1, 2.2 and 2.4 are premises, not theorems. This is their status in the thesis. Their information-theoretic grounding (Proposition 2.1, p. 55) is not formalised.
5. **Silent premises.** The condition `hcard` (|V| ≤ 2^(αH(C))) appears in the concrete theorems without being used by the proofs. The decoder `D` of `lemma4_concrete` only serves to build the instance. Assumption 2.3 is carried by `InstitutionalAssumptions` without being used by the trilemmas. These premises do not make the statements false. They make them look slightly stronger than they are.
6. **Abstract consistency witness.** `assumptions_consistent_and_bound_attained` is a point of the relaxed model (Rel = 1/λ with I = 0). An actual distribution would give Rel = 2^(−λ) (`fam_Rel`, line 156 of `Coherence.lean`). The family `famModel` has Δ = γ = 1, so the institutional factor is not active there.
7. **Local build with targeted imports.** See the caveat above. The version with `import Mathlib` was built by the GitHub workflow on 26 November 2026. Lean 4.35.0 prints a warning that suggests the `module` keyword, with no effect on the proofs. A run on live.lean-lang.org is still advised before any presentation.
8. **Statements written by copying.** The statements of `Enonces.lean` were written from the existing theorems. The build guarantees that they match the proofs. Their faithfulness to the manuscript text remains for the reader to judge, with the table above.

## Reproducibility

| Item | Value |
|---|---|
| Lean | v4.35.0 ([`lean-toolchain`](lean-toolchain)) |
| Mathlib | v4.35.0, commit `56a005855ea17e0b0958f73ec801ae140b0a1679` ([`lake-manifest.json`](lake-manifest.json)) |
| Lake libraries | `ConditionalCRO` (default target) and `Verification` (files `Verification/*.lean`) |
| SHA-256 of `ConditionalCRO.lean` | `33876520f8e925d2c9e71aa1f0be74bdc88dde89128e829fd9ecb25a41faf7d8` |
