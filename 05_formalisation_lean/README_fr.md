# Formalisation Lean 4 du Trilemme CRO conditionnel

> **Statut : PROPOSITION. formalisation** · Source : thèse, chapitre 3 (§3.4) et annexe B

[English version](README_en.md)

`ConditionalCRO.lean`, version 3.10, est un fichier unique qui certifie le Trilemme CRO conditionnel classique, du noyau algébrique aux lois de probabilité finies. Il ne contient aucun `sorry` et ne déclare aucun `axiom`. Le manuscrit qui présentait le noyau algébrique avait été soumis au *Journal of Automated Reasoning* ; son retrait a été demandé en novembre 2026. La couche concrète (section 10 du fichier) est propre à la thèse. La version 3.5 y ajoute, en section 12, les résultats d'information classique du chapitre 2 : DPI, Théorèmes 2.1 à 2.3, Proposition 2.1 et plusieurs remarques. La version 3.6 y ajoute, en section 14, le noyau algébrique du Trilemme CRO conditionnel quantique (Théorème 2.5, Corollaire 2.2, Lemme 2.8 et Remarques 2.27 à 2.41), où Fano quantique, Holevo et Pinsker quantique sont posés comme le sont Fano et Pinsker dans le noyau classique. La version 3.7 y ajoute, en section 16, la borne aiguë en κ/λ² de la Proposition 2.2 sur lois finies, le témoin réalisable de la Remarque 2.20 et les remarques d'ordre. La version 3.8 y ajoute, en section 18, les jeux IND-CONF, BIND-REL et EXT-OPP sur lois finies, leurs ponts vers Conf, Relver et Opp, l'inégalité de Fano générale (Lemme A.1), le Corollaire A.2 et la Remarque A.6. La version 3.9 y ajoute, en section 20, l'encodage classique diagonal : distance de trace égale à la variation totale, Conf^q = Conf, S(ρ) = H(X) et le cas limite de la Remarque 2.34. La version 3.10 y ajoute, en section 22, les parties informationnelles du Théorème 3.1 (S-OTP) et la Remarque 3.2. Le plan qui doit étendre la formalisation à tout le manuscrit est décrit dans [`FEUILLE_DE_ROUTE_FORMALISATION_fr.md`](FEUILLE_DE_ROUTE_FORMALISATION_fr.md) ; l'état énoncé par énoncé est dans [`INVENTAIRE_LEAN_MANUSCRIT_fr.md`](INVENTAIRE_LEAN_MANUSCRIT_fr.md).

| Élément | Valeur |
|---|---|
| Lean | v4.35.0 ([`lean-toolchain`](lean-toolchain)) |
| Mathlib | v4.35.0, commit `56a005855ea17e0b0958f73ec801ae140b0a1679` ([`lakefile.toml`](lakefile.toml), [`lake-manifest.json`](lake-manifest.json)) |
| Licence | MIT |
| Sortie de référence | [`results/lean_build_v3.10.log`](results/lean_build_v3.10.log) ; versions antérieures : `lean_build.log` (v2.2), `lean_build_v3.0.log` à `lean_build_v3.9.log` |

## Compiler

Installer `elan` (<https://github.com/leanprover/elan>), puis, depuis ce dossier,

```bash
lake exe cache get && lake build
lake env lean ConditionalCRO.lean    # affiche les #check et les #print axioms
```

`lake exe cache get` télécharge la version précompilée de Mathlib, ce qui évite plusieurs heures de compilation. Le résultat attendu est une compilation sans erreur, sans avertissement et sans `sorry`. Chacun des vingt `#print axioms` du fichier doit afficher exactement `[propext, Classical.choice, Quot.sound]`, c'est-à-dire les trois axiomes standard de Lean et de Mathlib. Le fichier se vérifie aussi en le collant dans <https://live.lean-lang.org> (projet Mathlib) ; la version 3.2 y a été vérifiée le 22 novembre 2026.

## Dossier de vérification

Le dossier [`VERIFICATION_fr.md`](VERIFICATION_fr.md) permet de juger ce qui est prouvé sans lire tout le code. Il est additif et ne modifie pas les preuves de `ConditionalCRO.lean`. [`Verification/Enonces.lean`](Verification/Enonces.lean) contient les 97 énoncés de la thèse sans preuve. [`Verification/Principal.lean`](Verification/Principal.lean) relie chacun au théorème existant en une ligne. [`Verification/Coherence.lean`](Verification/Coherence.lean) teste la non-vacuité des définitions propres. Le script [`verifier.sh`](verifier.sh) audite les sources, la compilation, les axiomes et le noyau. Ses sorties sont dans [`results/verification.log`](results/verification.log) et [`results/axiomes.txt`](results/axiomes.txt). Le workflow [`../.github/workflows/verification_lean.yml`](../.github/workflows/verification_lean.yml) l'exécute sur GitHub.

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
| 12 (v3.5) | `dpi_finite`, `tv_pushforward_le`, `bornes_mesures`, `goulot_contexte`, `capacite_le_gamma_add_one`, `conf_post`, `rel_post`, `opp_post`, `composition_parallele`, `chain_rule`, `fondement_extraction`, `opp_eq_one_of_det_concrete` | Information classique finie du chapitre 2 : DPI, Théorèmes 2.1 à 2.3, Proposition 2.1, Remarques 2.3 à 2.5, 2.11, 2.12, 2.15 et 3.9 |
| 13 (v3.5) | Bloc `#print axioms` de l'extension | Contrôle des axiomes des 24 théorèmes ajoutés |
| 14 (v3.6) | `QuantumProtocolInstance`, `QuantumAssumptions`, `conf_guarantee`, `trilemma_pq_explicit`, `conditional_CRO_trilemma_pq`, `trilemma_pq_refined`, `seuil_Hsharp_q`, `etaQ_bounds`, `regime_q_necessary` | Noyau algébrique quantique : Théorème 2.5, Corollaire 2.2, Lemme 2.8, Hypothèses 2.5 à 2.8, Définitions 2.27 et 2.30, Remarques 2.27, 2.29, 2.31 à 2.33, 2.35 à 2.37, 2.39 et 2.41 |
| 15 (v3.6) | Bloc `#print axioms` du noyau quantique | Contrôle des axiomes des 17 théorèmes ajoutés |
| 16 (v3.7) | `fano_sharp_model`, `rel_aigu`, `trilemma_aigu_concrete`, `conf_regime_concrete`, `witModel`, `temoin_realisable`, `borne_forte_statut`, `trilemma_aigu_q` | Bornes avancées : Proposition 2.2, dernière phrase du Théorème 2.4, Corollaire 2.1, Remarques 2.19 (majoration), 2.20, 2.24, 2.40 et 5.5 |
| 17 (v3.7) | Bloc `#print axioms` des bornes avancées | Contrôle des axiomes des 13 théorèmes ajoutés |
| 18 (v3.8) | `succIND_eq`, `ind_conf_le_conf`, `neyman_pearson`, `winBindRel`, `relver_ge`, `rel_of_conf_one`, `fano_general`, `ext_opp_bridge`, `product_from_games`, `echelles_distinctes` | Jeux et ponts : Définitions 2.5 à 2.7 et A.5 à A.7, Remarques 2.2, 2.6 à 2.8, A.1 à A.3 et A.6, Lemme A.1, Corollaire A.2 |
| 19 (v3.8) | Bloc `#print axioms` des jeux et ponts | Contrôle des axiomes des 15 théorèmes ajoutés |
| 20 (v3.9) | `diagState`, `eigenvalues_diag`, `traceDist_eq_tv`, `confQ_diag_eq`, `vonNeumann_diag`, `cas_limite_lemme6` | Encodage classique diagonal : Remarques 2.9, 2.25, 2.26 et 2.34 |
| 21 (v3.9) | Bloc `#print axioms` de l'encodage diagonal | Contrôle des axiomes des 6 théorèmes ajoutés |
| 22 (v3.10) | `maskLaw`, `sotp_mask_tv`, `conf_eq_one_of_indep`, `miN_le_ent_of_factor`, `sotp_opp_le`, `sotp_opp_zero_of_public` | Construction S-OTP : Théorème 3.1 et Remarque 3.2 |
| 23 (v3.10) | Bloc `#print axioms` de S-OTP | Contrôle des axiomes des 6 théorèmes ajoutés |

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

Dans le noyau algébrique (sections 1 à 9), les inégalités de Fano et de Pinsker sont intégrées comme **propriétés de chaque instance de protocole** (champs `fano` et `pinsker` de `ProtocolInstance`), Fano sous la forme relâchée $I\ge\mathrm{Rel}\cdot\lambda-1$. La couche concrète (section 10) les **démontre** pour des lois de probabilité finies sur $(C,M,\Sigma,V)$, avec $M$ uniforme sur $2^\lambda$ valeurs et indépendant de $C$ et une interprétation admissible ; seule leur dérivation pour des lois quelconques reste à faire. Les hypothèses institutionnelles 1, 2′ et 4 sont des hypothèses explicites des théorèmes ; l'Hypothèse 3 et une condition de supports communs ne servent qu'au Lemme 4. Le noyau quantique (section 14) pose Fano quantique, la borne de Holevo et Pinsker quantique comme champs de `QuantumProtocolInstance` ; leur démonstration relève de Physlib et n'est pas faite. La formalisation ne couvre pas encore SOTP ; une mécanisation réduite des réductions game-based de SOTP-Low se trouve dans [`../04_sotp/preuves_game_based/lean/`](../04_sotp/preuves_game_based/lean/).

## Portée des témoins

Une `ProtocolInstance` est un point du modèle abstrait. Le **témoin de cohérence** `assumptions_consistent_and_bound_attained` établit que les hypothèses ne sont pas vides et que la borne est atteinte dans le modèle relâché ($I=0$, $\mathrm{Rel}=1/\lambda$, $\Delta=\gamma=1$) ; il **n'est pas réalisable** par un protocole (thèse, `rem:portee_temoin`). La famille `famModel` de la couche concrète satisfait en revanche toutes les hypothèses sur de vraies lois, pour tout $\lambda$. Le témoin de portée `regime_assumption_necessary` est réalisé par une loi explicite, vérifiée numériquement par le contrôle V6 de [`../06_calcul/python/verifications.py`](../06_calcul/python/verifications.py) et par le script de [`cas_limite/`](cas_limite/).

## Fichiers

| Fichier | Contenu |
|---|---|
| [`ConditionalCRO.lean`](ConditionalCRO.lean) | Formalisation v3.10 (commentaires en français) ; l'en-tête porte les noms des auteurs, omis du listing de l'annexe B |
| [`lakefile.toml`](lakefile.toml), [`lean-toolchain`](lean-toolchain), [`lake-manifest.json`](lake-manifest.json) | Versions figées de Lean et de Mathlib |
| [`results/`](results/) | Sorties de `lake env lean ConditionalCRO.lean` pour chaque version |
| [`cas_limite/`](cas_limite/) | Script du cas limite du Théorème 1 de P2 dans sa formulation initiale |

Le listing de l'annexe B de la thèse (`lst:lean4_complet`) est la version 3.4, dont les lignes 5 à 1575 du fichier actuel sont la copie exacte. L'historique des versions est décrit dans [`../docs/historique_fr.md`](../docs/historique_fr.md). Le dossier `.lake/` produit par la compilation n'est pas versionné.
