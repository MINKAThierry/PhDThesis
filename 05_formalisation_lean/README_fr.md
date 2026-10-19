# Formalisation Lean 4 du Trilemme CRO conditionnel

> **Statut : PROPOSITION: formalisation (soumise au *Journal of Automated Reasoning*)** · Source : thèse, chapitre 3 (§3.4) et annexe B

[English version](README_en.md)

`ConditionalCRO.lean`, version 2.2, est un fichier unique qui certifie le noyau algébrique du Trilemme CRO conditionnel classique. Il ne contient aucun `sorry` et ne déclare aucun `axiom`. Un article qui présente cette formalisation est soumis au *Journal of Automated Reasoning* ; il n'est pas publié.

| Élément | Valeur |
|---|---|
| Lean | v4.34.0 ([`lean-toolchain`](lean-toolchain)) |
| Mathlib | v4.34.0, commit `5ed2965256430c3649e86755f9576b54eca72435` ([`lakefile.toml`](lakefile.toml), [`lake-manifest.json`](lake-manifest.json)) |
| Licence | MIT |
| Sortie de référence | [`results/lean_build.log`](results/lean_build.log) et son empreinte [`results/SHA256SUMS`](results/SHA256SUMS) |

## Compiler

Installer `elan` (<https://github.com/leanprover/elan>), puis, depuis ce dossier,

```bash
lake exe cache get && lake build
lake env lean ConditionalCRO.lean    # affiche les #check et les #print axioms
```

`lake exe cache get` télécharge la version précompilée de Mathlib, ce qui évite plusieurs heures de compilation. Le résultat attendu est une compilation sans erreur ni `sorry`. Chacun des dix `#print axioms` du fichier doit afficher exactement `[propext, Classical.choice, Quot.sound]`, c'est-à-dire les trois axiomes standard de Lean et de Mathlib. Le script [`../06_calcul/reproduire.sh`](../06_calcul/reproduire.sh) enchaîne ces commandes et réécrit `results/lean_build.log`.

## Ce qui est certifié

| Section du fichier | Déclarations | Énoncé de la thèse |
|---|---|---|
| 1–2 | `c0`, `c0_gt_half`, `Negligible`, `negligible_eps0` | Constante de Pinsker ; négligeabilité de $2^{-\lambda}$ prouvée par passage à la limite |
| 3–4 | `InstitutionalParams`, `gamma`, `ProtocolInstance`, `InstitutionalAssumptions` | Paramètres $(\Delta,\alpha,\beta,H(C))$, $\gamma=\alpha H(C)-1$, Hypothèses 1, 2′ et 3 |
| 5 | `lemma4_confidentiality_guarantee` | $\mathrm{Conf}\ge 1-\sqrt{c_0\beta I}$ (`lem:confidentiality_guarantee`) |
| 6 | `trilemma_explicit`, `trilemma_instance`, `conditional_CRO_trilemma` | Formes explicite et publiée du trilemme sous l'Hypothèse 4, $I\le\kappa/\lambda$ (`thm:trilemme_cro_conditionnel`) |
| 7 | `assumptions_consistent_and_bound_attained`, `regime_assumption_necessary` | Non-vacuité du modèle abstrait ; nécessité de l'Hypothèse 4 (`rem:scope_trilemme_classique`) |
| 8 | `capacity_regime` et exemples | Régimes de capacité institutionnelle |
| 9 (v2.2) | `opp_eq_one_of_deterministic`, `deterministic_forces_capacity`, `trilemma_refined`, `refined_bound_is_fano_when_delta_ge_gamma` | Verdict déterministe, forme raffinée et seuil $H^\sharp$ (`rem:verdict_deterministe`, `rem:activite_delta`) |
| 10 | Bloc `#check` et `#print axioms` | Contrôle des axiomes |

### Énoncé compilé du théorème principal

Extrait de `results/lean_build.log`.

```
ConditionalCRO.conditional_CRO_trilemma : ∀ (F : ProtocolFamily) (κ : ℝ),
  0 ≤ κ →
  (∀ lam, InstitutionalAssumptions (F.inst lam)) →
  (∀ lam, (F.inst lam).I ≤ κ / ↑lam) →
  ∃ K ε, Negligible ε ∧ ∀ lam, 64 ≤ lam →
    (F.inst lam).Conf * (F.inst lam).Rel * (F.inst lam).Opp ≤ F.params.Δ / ↑lam + K / ↑lam ^ 2 + ε lam
```

## Ce qui est posé comme hypothèse

Les inégalités de Fano et de Pinsker ne sont pas formalisées dans Mathlib. Elles ne sont pas prouvées ici à partir de la théorie des probabilités. Elles sont intégrées comme **propriétés de chaque instance de protocole** (champs `fano` et `pinsker` de `ProtocolInstance`), Fano sous la forme relâchée $I\ge\mathrm{Rel}\cdot\lambda-1$. Les hypothèses institutionnelles 1, 2′ et 3 sont des champs de `InstitutionalAssumptions` et l'Hypothèse 4 est un argument explicite des théorèmes. La certification porte donc sur le noyau algébrique de la preuve. La formalisation ne couvre ni les constructions SOTP ni l'extension quantique du trilemme (thèse, §3.4, « Ce que la formalisation ne couvre pas »).

## Portée des témoins

Une `ProtocolInstance` est un point du modèle abstrait, c'est-à-dire un ensemble de réels qui satisfont les contraintes de Pinsker, de Fano et les hypothèses. Le **témoin de cohérence** `assumptions_consistent_and_bound_attained` établit que ces hypothèses ne sont pas vides et que la borne est atteinte dans le modèle relâché ($I=0$, $\mathrm{Rel}=1/\lambda$, $\Delta=\gamma=1$). Ce témoin **n'est pas réalisable** par un protocole. Pour une loi de probabilité réelle avec $M$ uniforme sur $\lambda$ bits, $I=0$ impose $\mathrm{Rel}_{\mathrm{rec}}=2^{-\lambda}$ et non $1/\lambda$ (thèse, `rem:portee_temoin`). Le témoin de portée `regime_assumption_necessary` est en revanche réalisé par une loi explicite, vérifiée numériquement par le contrôle V6 de [`../06_calcul/python/verifications.py`](../06_calcul/python/verifications.py) et par le script de [`cas_limite/`](cas_limite/).

## Fichiers

| Fichier | Contenu |
|---|---|
| [`ConditionalCRO.lean`](ConditionalCRO.lean) | Formalisation v2.2 (commentaires en français, repris tels quels de la version annexée à la thèse) |
| [`lakefile.toml`](lakefile.toml), [`lean-toolchain`](lean-toolchain), [`lake-manifest.json`](lake-manifest.json) | Versions figées de Lean et de Mathlib |
| [`results/`](results/) | Sortie de référence de `lake env lean ConditionalCRO.lean` |
| [`cas_limite/`](cas_limite/) | Script du cas limite du Théorème 1 de P2 dans sa formulation initiale |

Le listing de l'annexe B de la thèse (`lst:lean4_complet`) est cette version 2.2. Les changements depuis la version 2.1 sont décrits dans [`../docs/historique_fr.md`](../docs/historique_fr.md). Le dossier `.lake/` produit par la compilation n'est pas versionné.
