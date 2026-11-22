# Lean 4 formalisation of the Conditional CRO Trilemma

> **Status: PROPOSAL. formalisation** · Source: thesis, Chapter 3, §3.4, and Appendix B

[Version française](README_fr.md)

`ConditionalCRO.lean`, version 3.3, is a single file that certifies the classical Conditional CRO Trilemma, from the algebraic core to finite probability distributions. It contains no `sorry` and declares no `axiom`. An article presenting the algebraic core has been submitted to the *Journal of Automated Reasoning*; it is not published. The concrete layer (Section 10 of the file) is specific to the thesis.

| Item | Value |
|---|---|
| Lean | v4.35.0 ([`lean-toolchain`](lean-toolchain)) |
| Mathlib | v4.35.0, commit `56a005855ea17e0b0958f73ec801ae140b0a1679` ([`lakefile.toml`](lakefile.toml), [`lake-manifest.json`](lake-manifest.json)) |
| Licence | MIT |
| Reference output | [`results/lean_build_v3.3.log`](results/lean_build_v3.3.log); earlier versions: `lean_build.log` (v2.2), `lean_build_v3.0.log` to `lean_build_v3.2.log` |

## Build

Install `elan` (<https://github.com/leanprover/elan>), then, from this folder,

```bash
lake exe cache get && lake build
lake env lean ConditionalCRO.lean    # prints the #check and #print axioms outputs
```

`lake exe cache get` downloads the precompiled Mathlib, which avoids several hours of compilation. The expected result is a build with no error, no warning and no `sorry`. Each of the eighteen `#print axioms` in the file must print exactly `[propext, Classical.choice, Quot.sound]`, the three standard axioms of Lean and Mathlib. The file can also be checked by pasting it into <https://live.lean-lang.org> (Mathlib project); version 3.2 was checked there on 22 November 2026.

## What is certified

| File section | Declarations | Thesis statement |
|---|---|---|
| 1–2 | `c0`, `c0_gt_half`, `Negligible`, `negligible_eps0` | Pinsker constant; negligibility of $2^{-\lambda}$ proved by a limit argument |
| 3–4 | `InstitutionalParams`, `gamma`, `ProtocolInstance`, `InstitutionalAssumptions` | Parameters $(\Delta,\alpha,\beta,H(C))$, $\gamma=\alpha H(C)-1$, Assumptions 1, 2′ and 3 |
| 5 | `lemma4_confidentiality_guarantee` | $\mathrm{Conf}\ge 1-\sqrt{c_0\beta I}$ (`lem:confidentiality_guarantee`) |
| 6 | `trilemma_explicit`, `trilemma_instance`, `conditional_CRO_trilemma` | Explicit and published forms of the trilemma under Assumption 4, $I\le\kappa/\lambda$ (`thm:trilemme_cro_conditionnel`); Assumption 3 is not used |
| 7 | `assumptions_consistent_and_bound_attained`, `regime_assumption_necessary` | Non-vacuity of the abstract model; necessity of Assumption 4 (`rem:scope_trilemme_classique`) |
| 8 | `capacity_regime` and examples | Institutional capacity regimes |
| 9 | `opp_eq_one_of_deterministic`, `deterministic_forces_capacity`, `trilemma_refined`, `refined_bound_is_fano_when_delta_ge_gamma` | Deterministic verdict, refined form and threshold $H^\sharp$ (`rem:verdict_deterministe`, `rem:activite_delta`) |
| 10 (v3) | `pinsker_finite`, `fano_finite`, `CLOModel`, `trilemma_explicit_concrete`, `trilemma_refined_concrete`, `lemma4_concrete`, `conditional_CRO_trilemma_concrete`, `famModel`, `concrete_assumptions_satisfiable`, `concrete_asymptotic_applies` | Concrete layer: Pinsker (tight form) and Fano proved for finite distributions, trilemma on actual distributions with $\gamma=\alpha H(C)-1$ computed from the distribution, family of witness distributions for every $\lambda$ (`subsec:lean4_concret`) |
| 11 | `#check` and `#print axioms` block | Axiom check |

### Compiled statement of the main theorem

Excerpt from `results/lean_build_v3.3.log`.

```
ConditionalCRO.conditional_CRO_trilemma : ∀ (F : ConditionalCRO.ProtocolFamily) (κ : ℝ),
  0 ≤ κ →
    (∀ (lam : ℕ), 64 ≤ lam → ConditionalCRO.InstitutionalAssumptions (F.inst lam)) →
      (∀ (lam : ℕ), 64 ≤ lam → (F.inst lam).I ≤ κ / ↑lam) →
        ∃ K ε, ConditionalCRO.Negligible ε ∧ ∀ (lam : ℕ), 64 ≤ lam →
          (F.inst lam).Conf * (F.inst lam).Rel * (F.inst lam).Opp ≤ F.params.Δ / ↑lam + K / ↑lam ^ 2 + ε lam
```

## What is assumed

In the algebraic core (Sections 1 to 9), Fano's and Pinsker's inequalities are built in as **properties of each protocol instance** (fields `fano` and `pinsker` of `ProtocolInstance`), Fano in the relaxed form $I\ge\mathrm{Rel}\cdot\lambda-1$. The concrete layer (Section 10) **proves** them for finite probability distributions on $(C,M,\Sigma,V)$, with $M$ uniform over $2^\lambda$ values and independent of $C$ and an admissible interpretation; only their derivation for arbitrary distributions remains. Institutional Assumptions 1, 2′ and 4 are explicit hypotheses of the theorems; Assumption 3 and a common-support condition are used only for Lemma 4. The formalisation covers neither the quantum extension of the trilemma nor SOTP; a reduced mechanisation of the game-based reductions of SOTP-Low is in [`../04_sotp/preuves_game_based/lean/`](../04_sotp/preuves_game_based/lean/).

## Scope of the witnesses

A `ProtocolInstance` is a point of the abstract model. The **consistency witness** `assumptions_consistent_and_bound_attained` shows that the assumptions are not empty and that the bound is attained in the relaxed model ($I=0$, $\mathrm{Rel}=1/\lambda$, $\Delta=\gamma=1$); it is **not realisable** by a protocol (thesis, `rem:portee_temoin`). The family `famModel` of the concrete layer, by contrast, satisfies all assumptions on actual distributions, for every $\lambda$. The scope witness `regime_assumption_necessary` is realised by an explicit distribution, checked numerically by control V6 of [`../06_calcul/python/verifications.py`](../06_calcul/python/verifications.py) and by the script in [`cas_limite/`](cas_limite/).

## Files

| File | Content |
|---|---|
| [`ConditionalCRO.lean`](ConditionalCRO.lean) | Formalisation v3.3 (comments in French); the header carries the authors' names, omitted from the Appendix B listing |
| [`lakefile.toml`](lakefile.toml), [`lean-toolchain`](lean-toolchain), [`lake-manifest.json`](lake-manifest.json) | Pinned versions of Lean and Mathlib |
| [`results/`](results/) | Outputs of `lake env lean ConditionalCRO.lean` for each version |
| [`cas_limite/`](cas_limite/) | Script for the limiting case of Theorem 1 of P2 in its initial formulation |

The listing of Appendix B of the thesis (`lst:lean4_complet`) is this version 3.3. The version history is described in [`../docs/historique_en.md`](../docs/historique_en.md). The `.lake/` folder produced by the build is not versioned.
