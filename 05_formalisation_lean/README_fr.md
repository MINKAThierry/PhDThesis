# Formalisation Lean 4 du Trilemme CRO conditionnel

> **Statut : PROPOSITION. formalisation** · Source : thèse, chapitre 3 (§3.4) et annexe B

[English version](README_en.md)

`ConditionalCRO.lean`, version 3.4, est un fichier unique qui certifie le Trilemme CRO conditionnel classique, du noyau algébrique aux lois de probabilité finies. Il ne contient aucun `sorry` et ne déclare aucun `axiom`. Un article qui présente le noyau algébrique est soumis au *Journal of Automated Reasoning* ; il n'est pas publié. La couche concrète (section 10 du fichier) est propre à la thèse.

| Élément | Valeur |
|---|---|
| Lean | v4.35.0 ([`lean-toolchain`](lean-toolchain)) |
| Mathlib | v4.35.0, commit `56a005855ea17e0b0958f73ec801ae140b0a1679` ([`lakefile.toml`](lakefile.toml), [`lake-manifest.json`](lake-manifest.json)) |
| Licence | MIT |
| Sortie de référence | [`results/lean_build_v3.4.log`](results/lean_build_v3.4.log) ; versions antérieures : `lean_build.log` (v2.2), `lean_build_v3.0.log` à `lean_build_v3.3.log` |

## Compiler

Installer `elan` (<https://github.com/leanprover/elan>), puis, depuis ce dossier,

```bash
lake exe cache get && lake build
lake env lean ConditionalCRO.lean    # affiche les #check et les #print axioms
```

`lake exe cache get` télécharge la version précompilée de Mathlib, ce qui évite plusieurs heures de compilation. Le résultat attendu est une compilation sans erreur, sans avertissement et sans `sorry`. Chacun des vingt `#print axioms` du fichier doit afficher exactement `[propext, Classical.choice, Quot.sound]`, c'est-à-dire les trois axiomes standard de Lean et de Mathlib. Le fichier se vérifie aussi en le collant dans <https://live.lean-lang.org> (projet Mathlib) ; la version 3.2 y a été vérifiée le 22 novembre 2026.

## Ce qui est certifié

| Section du fichier | Déclarations | Énoncé de la thèse |
|---|---|---|
| 1–2 | `c0`, `c0_gt_half`, `Negligible`, `negligible_eps0` | Constante de Pinsker ; négligeabilité de $2^{-\lambda}$ prouvée par passage à la limite |
| 3–4 | `InstitutionalParams`, `gamma`, `ProtocolInstance`, `InstitutionalAssumptions` | Paramètres $(\Delta,\alpha,\beta,H(C))$, $\gamma=\alpha H(C)-1$, Hypothèses 1, 2′ et 3 |
| 5 | `lemma4_confidentiality_guarantee` | $\mathrm{Conf}\ge 1-\sqrt{c_0\beta I}$ (`lem:confidentiality_guarantee`) |
| 6 | `trilemma_explicit`, `trilemma_instance`, `conditional_CRO_trilemma` | Formes explicite et publiée du trilemme sous l'Hypothèse 4, $I\le\kappa/\lambda$ (`thm:trilemme_cro_conditionnel`) ; l'Hypothèse 3 n'y sert pas |
| 7 | `assumptions_consistent_and_bound_attained`, `regime_assumption_necessary` | Non-vacuité du modèle abstrait ; nécessité de l'Hypothèse 4 (`rem:scope_trilemme_classique`) |
| 8 | `capacity_regime` et exemples | Régimes de capacité institutionnelle |
| 9 | `opp_eq_one_of_deterministic`, `deterministic_forces_capacity`, `trilemma_refined`, `refined_bound_is_fano_when_delta_ge_gamma` | Verdict déterministe, forme raffinée et seuil $H^\sharp$ (`rem:verdict_deterministe`, `rem:activite_delta`) |
| 10 (v3) | `pinsker_finite`, `fano_finite`, `CLOModel`, `trilemma_explicit_concrete`, `trilemma_refined_concrete`, `lemma4_concrete`, `conditional_CRO_trilemma_concrete`, `famModel`, `concrete_assumptions_satisfiable`, `concrete_asymptotic_applies` | Couche concrète : Pinsker (forme serrée) et Fano démontrés pour des lois finies, trilemme sur de vraies lois avec $\gamma=\alpha H(C)-1$ tiré de la loi, famille de lois témoins pour tout $\lambda$ (`subsec:lean4_concret`) |
| 11 | Bloc `#check` et `#print axioms` | Contrôle des axiomes |

### Énoncé compilé du théorème principal

Extrait de `results/lean_build_v3.4.log`.

```
ConditionalCRO.conditional_CRO_trilemma : ∀ (F : ConditionalCRO.ProtocolFamily) (κ : ℝ),
  0 ≤ κ →
    (∀ (lam : ℕ), 64 ≤ lam → ConditionalCRO.InstitutionalAssumptions (F.inst lam)) →
      (∀ (lam : ℕ), 64 ≤ lam → (F.inst lam).I ≤ κ / ↑lam) →
        ∃ K ε, ConditionalCRO.Negligible ε ∧ ∀ (lam : ℕ), 64 ≤ lam →
          (F.inst lam).Conf * (F.inst lam).Rel * (F.inst lam).Opp ≤ F.params.Δ / ↑lam + K / ↑lam ^ 2 + ε lam
```

## Ce qui est posé comme hypothèse

Dans le noyau algébrique (sections 1 à 9), les inégalités de Fano et de Pinsker sont intégrées comme **propriétés de chaque instance de protocole** (champs `fano` et `pinsker` de `ProtocolInstance`), Fano sous la forme relâchée $I\ge\mathrm{Rel}\cdot\lambda-1$. La couche concrète (section 10) les **démontre** pour des lois de probabilité finies sur $(C,M,\Sigma,V)$, avec $M$ uniforme sur $2^\lambda$ valeurs et indépendant de $C$ et une interprétation admissible ; seule leur dérivation pour des lois quelconques reste à faire. Les hypothèses institutionnelles 1, 2′ et 4 sont des hypothèses explicites des théorèmes ; l'Hypothèse 3 et une condition de supports communs ne servent qu'au Lemme 4. La formalisation ne couvre ni l'extension quantique du trilemme ni SOTP ; une mécanisation réduite des réductions game-based de SOTP-Low se trouve dans [`../04_sotp/preuves_game_based/lean/`](../04_sotp/preuves_game_based/lean/).

## Portée des témoins

Une `ProtocolInstance` est un point du modèle abstrait. Le **témoin de cohérence** `assumptions_consistent_and_bound_attained` établit que les hypothèses ne sont pas vides et que la borne est atteinte dans le modèle relâché ($I=0$, $\mathrm{Rel}=1/\lambda$, $\Delta=\gamma=1$) ; il **n'est pas réalisable** par un protocole (thèse, `rem:portee_temoin`). La famille `famModel` de la couche concrète satisfait en revanche toutes les hypothèses sur de vraies lois, pour tout $\lambda$. Le témoin de portée `regime_assumption_necessary` est réalisé par une loi explicite, vérifiée numériquement par le contrôle V6 de [`../06_calcul/python/verifications.py`](../06_calcul/python/verifications.py) et par le script de [`cas_limite/`](cas_limite/).

## Fichiers

| Fichier | Contenu |
|---|---|
| [`ConditionalCRO.lean`](ConditionalCRO.lean) | Formalisation v3.4 (commentaires en français) ; l'en-tête porte les noms des auteurs, omis du listing de l'annexe B |
| [`lakefile.toml`](lakefile.toml), [`lean-toolchain`](lean-toolchain), [`lake-manifest.json`](lake-manifest.json) | Versions figées de Lean et de Mathlib |
| [`results/`](results/) | Sorties de `lake env lean ConditionalCRO.lean` pour chaque version |
| [`cas_limite/`](cas_limite/) | Script du cas limite du Théorème 1 de P2 dans sa formulation initiale |

Le listing de l'annexe B de la thèse (`lst:lean4_complet`) est cette version 3.4. L'historique des versions est décrit dans [`../docs/historique_fr.md`](../docs/historique_fr.md). Le dossier `.lake/` produit par la compilation n'est pas versionné.
