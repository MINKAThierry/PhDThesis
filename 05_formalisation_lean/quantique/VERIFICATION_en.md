# Verification dossier for the quantum layer

*Version française : [VERIFICATION_fr.md](VERIFICATION_fr.md)*

This dossier accompanies `QuantiqueCRO.lean`, version 1.2 of 27 November 2026 (lot L5c of the [roadmap](../FEUILLE_DE_ROUTE_FORMALISATION_fr.md), in French). It follows the structure of [`../VERIFICATION_en.md`](../VERIFICATION_en.md), taken from the repository of the Lean proof of the Riemann hypothesis.

## Why a separate project

The quantum core of `ConditionalCRO.lean` (Section 14) takes quantum Pinsker, quantum Fano and the Holevo bound as fields of an abstract instance. To ground this layer in actual quantum states, this project uses the [Physlib](https://github.com/leanprover-community/physlib) library, QuantumInfo part, at commit `31f35373ab937172abc689c128177c98405dc936`. Physlib pins Lean and Mathlib at v4.36.0 while `ConditionalCRO.lean` stays at v4.35.0. The project therefore has its own `lakefile.toml` and `lean-toolchain`. live.lean-lang.org does not load Physlib: verification goes through the GitHub workflow [`verification_lean_quantique.yml`](../../.github/workflows/verification_lean_quantique.yml).

## What to read and in which order

| Order | File | Role |
|---|---|---|
| 1 | this document | Map, traceability and limits |
| 2 | [`Verification/Enonces.lean`](Verification/Enonces.lean) | The 16 statements, without proof, with their reference to manuscript v36 |
| 3 | [`Verification/Principal.lean`](Verification/Principal.lean) | One line per statement |
| 4 | [`Verification/Coherence.lean`](Verification/Coherence.lean) | Non-vacuity tests of `confQ`, `krausAD` and `krausEr` |
| 5 | [`QuantiqueCRO.lean`](QuantiqueCRO.lean) | The proofs, 278 lines |

## How to check

```bash
cd 05_formalisation_lean/quantique
lake exe cache get && lake build QuantiqueCRO Verification
bash verifier.sh
```

## What has been built

| Check | Where | Result |
|---|---|---|
| Version 1.2, `verifier.sh` steps 1 to 6 | run by GitHub on 27 November 2026 | workflow `verification_lean_quantique.yml`, run 46041616405 passed: 16 statements and 4 coherence lemmas limited to the three standard axioms, no warning, `leanchecker` on the four modules, `nanoda_bin` on `Principal.lean` |
| Version 1.1, `verifier.sh` steps 1 to 6 | run by GitHub on 27 November 2026 | workflow `verification_lean_quantique.yml`, run 46037284662 passed: 13 statements and 2 coherence lemmas limited to the three standard axioms, `leanchecker` on the four modules, `nanoda_bin` on `Principal.lean` |
| Version 1.0, `verifier.sh` steps 1 to 6 | run by GitHub on 27 November 2026 | workflow `verification_lean_quantique.yml`, run 46029211703 passed: 10 statements and 2 coherence lemmas limited to the three standard axioms, `leanchecker` on the four modules, `nanoda_bin` on `Principal.lean` |
| Local build | working container | not done: the Mathlib v4.36.0 cache is not reachable there |

## Traceability table

| Statement of the manuscript | Label | No. and page v36 | Lean name | File | E / P | Status |
|---|---|---|---|---|---|---|
| Conf^q ∈ [0, 1] | `def:conf_quantique_clo`, `def:conf_quantique` | Definitions 2.8 (p. 52) and 2.24 (p. 73) | `confQ_bornes` | 58 | 19 / 14 | proved |
| Family independent of the message, Conf^q = 1 | `def:conf_quantique_clo` | Definition 2.8, p. 52 | `confQ_eq_one_of_indep` | 75 | 25 / 15 | proved |
| S(A\|B) = S(AB) − S(B) | `def:entropie_conditionnelle_quantique` | Definition 2.14, p. 69 | `entropie_conditionnelle_def` | 94 | 31 / 16 | Physlib definition |
| I(A;B) = S(A) + S(B) − S(AB) | `def:information_mutuelle_quantique` | Definition 2.15, p. 69 | `information_mutuelle_def` | 98 | 36 / 17 | Physlib definition |
| 0 ≤ S(ρ) ≤ log d | `subsubsec:von_neumann` | 1.3.2.1, p. 18 | `vonNeumann_bornes` | 102 | 41 / 18 | proved (Physlib) |
| D_max = log d − S(ρ̄) ≥ 0 | `lem:q_conf_mi_pq` | Lemma 2.8, p. 77 | `Dmax_nonneg` | 109 | 46 / 19 | proved |
| Subadditivity of the von Neumann entropy | `subsubsec:von_neumann` | 1.3.2.1, p. 18 | `sous_additivite` | 113 | 51 / 20 | proved (Physlib) |
| I(A;B) ≥ 0 | `def:information_mutuelle_quantique` | Definition 2.15, p. 69 | `information_mutuelle_nonneg` | 118 | 56 / 21 | proved |
| Strong subadditivity, I(A;B\|C) ≥ 0 | `subsubsec:von_neumann` | 1.3.2.1, p. 18 | `cmi_quantique_nonneg` | 123 | 61 / 22 | proved (Physlib) |
| Discarding a subsystem, I(A;BC) ≥ I(A;B) | `subsubsec:holevo`, `lem:holevo_helstrom` | 1.3.2.3 (p. 19), Lemma 2.7 (p. 71), step | `info_mutuelle_oubli` | 130 | 66 / 23 | proved (Physlib) |
| Quantum DPI of the relative entropy | `eq:qdpi` | (1.14), p. 18 | `dpi_quantique` | 138 | 72 / 24 | proved (Physlib) |
| Depolarising channel, Δ_1 = replacement by I/d, Δ_0 = identity | `def:canal_depolarisant` | Definition 2.18, p. 72 | `depolarisant_extremes` | 158 | 78 / 26 | proved |
| Conf^q = 1 after total depolarisation | `def:canal_depolarisant` | Definition 2.18, p. 72 | `conf_depolarisation_totale` | 165 | 84 / 27 | proved |
| Amplitude-damping channel, E₀ᴴE₀ + E₁ᴴE₁ = I | `def:canal_amortissement` | Definition 2.19, p. 72 | `krausAD_normalise` | 187 | 91 / 29 | proved |
| Dephasing channel, (1 − p)·I + p·ZᴴZ = I | `def:canal_dephasage` | Definition 2.20, p. 72 | `krausPh_normalise` | 211 | 96 / 30 | proved |
| Erasure channel into d ⊕ {⊥}, Σ_κ K_κᴴ K_κ = I | `def:canal_effacement` | Definition 2.21, p. 72 | `krausEr_normalise` | 236 | 101 / 31 | proved |

"Proved (Physlib)" means that the theorem of this dossier applies a proved Physlib theorem directly (`Sᵥₙ_le_log_d`, `Sᵥₙ_subadditivity`, `qcmi_nonneg`, `qMutualInfo_strong_subadditivity`, `sandwichedRenyiEntropy_DPI`). The `#print axioms` confirm that none of them uses a Physlib `sorry`.

## Limits stated plainly

1. **Lemmas still assumed.** Quantum Pinsker (Lemmas 1.4 and 2.4), gentle measurement (Lemmas 1.5 and 2.5), quantum Fano (Lemmas 1.6 and 2.6) and the Holevo bound with Helstrom measurement (Lemma 2.7) are not in Physlib in this form. They remain fields of the quantum core of `ConditionalCRO.lean`. The planned route is: quantum Pinsker via the Helstrom measurement, the finite Pinsker of `ConditionalCRO.lean` and `dpi_quantique`; quantum Fano by reduction to the classical case on the outcome of a POVM.
2. **No formal link with `ConditionalCRO.lean`.** The two projects do not use the same Lean version. The link between `confQ` and the `Conf` field of `QuantumProtocolInstance` is therefore described, not proved.
3. **Classical decidable equality.** Physlib's trace-distance lemmas are stated with classical decidable equality. Section 1 opens `Classical` to match, which does not change the meaning of the statements.
4. **Channels and diamond norm.** The depolarising channel (Definition 2.18) is written as a convex mixture of Physlib channels. Since version 1.2, the amplitude-damping (qubit), dephasing (qubit) and erasure (any dimension) channels are built from Kraus operators, with their normalisation proved. The diamond norm (Definition 2.22) is not written yet.
5. **Holevo bound.** `info_mutuelle_oubli` gives the DPI of mutual information when a subsystem is discarded. Deriving Lemma 2.7 for an arbitrary measurement requires writing the measurement as an isometry followed by discarding, or showing that the partial trace commutes with a local channel. Neither is in Physlib today.

## Reproducibility

| Item | Value |
|---|---|
| Lean | v4.36.0 ([`lean-toolchain`](lean-toolchain)) |
| Physlib | commit `31f35373ab937172abc689c128177c98405dc936` ([`lake-manifest.json`](lake-manifest.json)) |
| Mathlib | v4.36.0, commit `fc4f59e577feb1a4956671bc04ac18aaaf8cd842` |
| SHA-256 of `QuantiqueCRO.lean` | `74f1b8bead92277d967f0be9350de922badfcbac4773e081ac38e87b919a9a9d` (version 1.2) |
