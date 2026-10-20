# Lean 4 formalisation of the Conditional CRO Trilemma

> **Status: PROPOSAL. formalisation** · Source: thesis, Chapter 3, §3.4, and Appendix B

[Version française](README_fr.md)

`ConditionalCRO.lean`, version 2.2, is a single file that certifies the algebraic core of the classical Conditional CRO Trilemma. It contains no `sorry` and declares no `axiom`. An article presenting this formalisation has been submitted to the *Journal of Automated Reasoning*; it is not published.

| Item | Value |
|---|---|
| Lean | v4.34.0 ([`lean-toolchain`](lean-toolchain)) |
| Mathlib | v4.34.0, commit `5ed2965256430c3649e86755f9576b54eca72435` ([`lakefile.toml`](lakefile.toml), [`lake-manifest.json`](lake-manifest.json)) |
| Licence | MIT |
| Reference output | [`results/lean_build.log`](results/lean_build.log) and its checksum [`results/SHA256SUMS`](results/SHA256SUMS) |

## Building

Install `elan` (<https://github.com/leanprover/elan>), then, from this folder,

```bash
lake exe cache get && lake build
lake env lean ConditionalCRO.lean    # prints the #check and #print axioms output
```

`lake exe cache get` downloads the precompiled Mathlib, which avoids several hours of compilation. The expected result is a build with no error and no `sorry`. Each of the ten `#print axioms` commands in the file must print exactly `[propext, Classical.choice, Quot.sound]`, namely the three standard axioms of Lean and Mathlib. The script [`../06_calcul/reproduire.sh`](../06_calcul/reproduire.sh) runs these commands and rewrites `results/lean_build.log`.

## What is certified

| File section | Declarations | Thesis statement |
|---|---|---|
| 1–2 | `c0`, `c0_gt_half`, `Negligible`, `negligible_eps0` | Pinsker constant; negligibility of $2^{-\lambda}$ proved by a limit argument |
| 3–4 | `InstitutionalParams`, `gamma`, `ProtocolInstance`, `InstitutionalAssumptions` | Parameters $(\Delta,\alpha,\beta,H(C))$, $\gamma=\alpha H(C)-1$, Assumptions 1, 2′ and 3 |
| 5 | `lemma4_confidentiality_guarantee` | $\mathrm{Conf}\ge 1-\sqrt{c_0\beta I}$ (`lem:confidentiality_guarantee`) |
| 6 | `trilemma_explicit`, `trilemma_instance`, `conditional_CRO_trilemma` | Explicit and published forms of the trilemma under Assumption 4, $I\le\kappa/\lambda$ (`thm:trilemme_cro_conditionnel`) |
| 7 | `assumptions_consistent_and_bound_attained`, `regime_assumption_necessary` | Non-vacuity of the abstract model; necessity of Assumption 4 (`rem:scope_trilemme_classique`) |
| 8 | `capacity_regime` and examples | Institutional capacity regimes |
| 9 (v2.2) | `opp_eq_one_of_deterministic`, `deterministic_forces_capacity`, `trilemma_refined`, `refined_bound_is_fano_when_delta_ge_gamma` | Deterministic verdict, refined form and threshold $H^\sharp$ (`rem:verdict_deterministe`, `rem:activite_delta`) |
| 10 | `#check` and `#print axioms` block | Axiom check |

### Compiled statement of the main theorem

Excerpt from `results/lean_build.log`.

```
ConditionalCRO.conditional_CRO_trilemma : ∀ (F : ProtocolFamily) (κ : ℝ),
  0 ≤ κ →
  (∀ lam, InstitutionalAssumptions (F.inst lam)) →
  (∀ lam, (F.inst lam).I ≤ κ / ↑lam) →
  ∃ K ε, Negligible ε ∧ ∀ lam, 64 ≤ lam →
    (F.inst lam).Conf * (F.inst lam).Rel * (F.inst lam).Opp ≤ F.params.Δ / ↑lam + K / ↑lam ^ 2 + ε lam
```

## What is assumed

Fano's and Pinsker's inequalities are not formalised in Mathlib. They are not proved here from probability theory. They are built in as **properties of each protocol instance** (fields `fano` and `pinsker` of `ProtocolInstance`), Fano in the relaxed form $I\ge\mathrm{Rel}\cdot\lambda-1$. The institutional Assumptions 1, 2′ and 3 are fields of `InstitutionalAssumptions` and Assumption 4 is an explicit argument of the theorems. The certification therefore covers the algebraic core of the proof. The formalisation covers neither the SOTP constructions nor the quantum extension of the trilemma (thesis, §3.4, "Ce que la formalisation ne couvre pas").

## Scope of the witnesses

A `ProtocolInstance` is a point of the abstract model, that is, a set of real numbers satisfying the Pinsker and Fano constraints and the assumptions. The **consistency witness** `assumptions_consistent_and_bound_attained` shows that these assumptions are not empty and that the bound is attained in the relaxed model ($I=0$, $\mathrm{Rel}=1/\lambda$, $\Delta=\gamma=1$). This witness **is not realisable** by a protocol. For an actual probability distribution with $M$ uniform on $\lambda$ bits, $I=0$ forces $\mathrm{Rel}_{\mathrm{rec}}=2^{-\lambda}$ and not $1/\lambda$ (thesis, `rem:portee_temoin`). The scope witness `regime_assumption_necessary`, on the other hand, is realised by an explicit distribution, checked numerically by check V6 of [`../06_calcul/python/verifications.py`](../06_calcul/python/verifications.py) and by the script in [`cas_limite/`](cas_limite/).

## Files

| File | Contents |
|---|---|
| [`ConditionalCRO.lean`](ConditionalCRO.lean) | Formalisation v2.2 (comments in French, kept as in the version appended to the thesis) |
| [`lakefile.toml`](lakefile.toml), [`lean-toolchain`](lean-toolchain), [`lake-manifest.json`](lake-manifest.json) | Pinned versions of Lean and Mathlib |
| [`results/`](results/) | Reference output of `lake env lean ConditionalCRO.lean` |
| [`cas_limite/`](cas_limite/) | Script for the limiting case of Theorem 1 of P2 in its initial formulation |

The listing of Appendix B of the thesis (`lst:lean4_complet`) is this version 2.2. The changes since version 2.1 are described in [`../docs/historique_en.md`](../docs/historique_en.md). The `.lake/` folder produced by the build is not versioned.
