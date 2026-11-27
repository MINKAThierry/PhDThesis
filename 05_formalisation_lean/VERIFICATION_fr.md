# Dossier de vérification de la formalisation Lean

[English version](VERIFICATION_en.md)

Ce dossier permet de juger ce que la formalisation prouve sans lire les 5 407 lignes de `ConditionalCRO.lean`. Il suit le modèle du dépôt de la preuve Lean de l'hypothèse de Riemann (novembre 2026). Les énoncés y sont isolés des preuves, un point d'entrée mince les relie aux théorèmes et un script audite les axiomes. Les limites y sont dites franchement.

Le dossier est **additif**. Les versions 3.5 à 3.13 de `ConditionalCRO.lean` (27 novembre 2026) prolongent la 3.4 par ajout des sections 12 à 29 en fin de fichier. Ses lignes 5 à 1575 restent identiques au listing B.1 de l'annexe B de la thèse, aux quatre lignes d'auteurs de l'en-tête près. Seule la ligne 4, qui porte le numéro de version, a changé. Les numéros de ligne cités pour la version 3.4 restent donc valables. Les fichiers de vérification importent `ConditionalCRO`.

## Ce qu'il faut lire et dans quel ordre

| Ordre | Fichier | Rôle |
|---|---|---|
| 1 | ce document | Carte, traçabilité et limites |
| 2 | [`Verification/Enonces.lean`](Verification/Enonces.lean) | Les 117 énoncés de la thèse, sans aucune preuve, chacun avec son renvoi au manuscrit v36 |
| 3 | [`Verification/Principal.lean`](Verification/Principal.lean) | Une ligne par énoncé, de la forme `theorem principal_x : Enonces.X := nomExistant` |
| 4 | [`Verification/Coherence.lean`](Verification/Coherence.lean) | Tests de non-vacuité des définitions propres |
| 5 | [`results/verification.log`](results/verification.log), [`results/axiomes.txt`](results/axiomes.txt) | Sorties du script d'audit |
| 6 | [`ConditionalCRO.lean`](ConditionalCRO.lean) | Les preuves, à ouvrir seulement aux lignes indiquées par la carte ci-dessous |

Le relecteur compare d'abord chaque énoncé de `Enonces.lean` avec le texte du manuscrit. C'est la seule étape humaine. La compilation de `Principal.lean` garantit ensuite que chaque énoncé est exactement celui que prouve le théorème. Un écart, même un affaiblissement, empêche la compilation. Cinq tests de mutation l'ont confirmé (voir plus bas).

## Comment vérifier

On lance ces commandes depuis ce dossier, avec `elan` installé.

```bash
lake exe cache get        # Mathlib v4.35.0 précompilée
bash verifier.sh          # ou bash verifier.sh --cache pour enchaîner les deux
```

Le script échoue dans six cas. Le premier est une preuve dans `Enonces.lean` (mot-clé `by`, déclaration autre que `def Nom : Prop :=`). Le deuxième est un `sorry`, `admit`, `native_decide` ou `axiom` dans les sources, commentaires exclus. Le troisième est une ligne de `Principal.lean` qui ne relie pas un énoncé à un théorème existant. Le quatrième est un échec de compilation. Le cinquième est un `#print axioms` qui affiche autre chose que `[propext, Classical.choice, Quot.sound]`. Le sixième est un rejet par un vérificateur indépendant du noyau.

Cette dernière étape emploie deux outils fournis avec la chaîne Lean 4.35.0. `leanchecker` rejoue les déclarations dans le noyau de Lean. `nanoda_bin` est un second vérificateur, écrit en Rust, qui relit un export produit par `leanexport`. L'export porte sur les théorèmes de `Principal.lean` (29 en version 3.4, 47 en version 3.5, 64 en version 3.6, 74 en version 3.7, 89 en version 3.8, 93 en version 3.9, 97 en version 3.10, 107 en version 3.11) et sur toutes leurs dépendances, Mathlib comprise. Seuls les trois axiomes standard y sont admis.

Le workflow [`../.github/workflows/verification_lean.yml`](../.github/workflows/verification_lean.yml) exécute ce script sur GitHub à chaque modification du dossier. Il complète le job `lean` de `ci.yml` sans le remplacer.

## Ce qui a été compilé et ce qui ne l'a pas été

| Contrôle | Où | Résultat |
|---|---|---|
| Version 3.13 avec `import Mathlib` complet, `verifier.sh` étapes 1 à 6 | faite par GitHub le 27 novembre 2026 | workflow `verification_lean.yml`, exécution 46059764129 réussie (commit cc3f3c1) : 117 énoncés et 69 lemmes de cohérence limités aux trois axiomes standard, `leanchecker` sur les quatre modules, `nanoda_bin` sur `Principal.lean` |
| Version 3.13 : `ConditionalCRO`, puis `Enonces`, `Principal` et `Coherence` | local, 27 novembre 2026, Lean 4.35.0, Mathlib v4.35.0 à imports ciblés | réussi, aucune erreur ni aucun avertissement ; 123 `#print axioms` dans le fichier, 117 sur `Principal.lean` et 69 sur `Coherence.lean`, tous standard |
| Version 3.12 avec `import Mathlib` complet, `verifier.sh` étapes 1 à 6 | faite par GitHub le 27 novembre 2026 | workflow `verification_lean.yml`, exécution 46058753895 réussie (commit 516276a) : 113 énoncés et 66 lemmes de cohérence limités aux trois axiomes standard, `leanchecker` sur les quatre modules, `nanoda_bin` sur `Principal.lean` |
| Version 3.12 : `ConditionalCRO`, puis `Enonces`, `Principal` et `Coherence` | local, 27 novembre 2026, Lean 4.35.0, Mathlib v4.35.0 à imports ciblés | réussi, aucune erreur ni aucun avertissement ; 118 `#print axioms` dans le fichier, 113 sur `Principal.lean` et 66 sur `Coherence.lean`, tous standard |
| Version 3.11 avec `import Mathlib` complet, `verifier.sh` étapes 1 à 6 | faite par GitHub le 27 novembre 2026 | workflow `verification_lean.yml`, exécution 46020036841 réussie (commit fc9490b) : 107 énoncés et 61 lemmes de cohérence limités aux trois axiomes standard, `leanchecker` sur les quatre modules, `nanoda_bin` sur `Principal.lean` |
| Version 3.11 : `ConditionalCRO`, puis `Enonces`, `Principal` et `Coherence` | local, 27 novembre 2026, Lean 4.35.0, Mathlib v4.35.0 à imports ciblés | réussi, aucune erreur ni aucun avertissement ; 111 `#print axioms` dans le fichier, 107 sur `Principal.lean` et 61 sur `Coherence.lean`, tous standard |
| Version 3.10 avec `import Mathlib` complet, `verifier.sh` étapes 1 à 6 | faite par GitHub le 27 novembre 2026 | workflow `verification_lean.yml`, exécution 46013544278 réussie (commit 38ef312) : 97 énoncés et 61 lemmes de cohérence limités aux trois axiomes standard, `leanchecker` sur les quatre modules, `nanoda_bin` sur `Principal.lean` |
| Version 3.10 : `ConditionalCRO`, puis `Enonces`, `Principal` et `Coherence` | local, 27 novembre 2026, Lean 4.35.0, Mathlib v4.35.0 à imports ciblés | réussi, aucune erreur ni aucun avertissement ; 101 `#print axioms` dans le fichier, 97 sur `Principal.lean` et 61 sur `Coherence.lean`, tous standard |
| Version 3.9 collée dans <https://live.lean-lang.org> (projet Mathlib) | faite par Thierry MINKA le 27 novembre 2026 | aucune erreur ; les 95 `#print axioms` affichent `[propext, Classical.choice, Quot.sound]` |
| Version 3.9 avec `import Mathlib` complet, `verifier.sh` étapes 1 à 6 | faite par GitHub le 27 novembre 2026 | workflow `verification_lean.yml`, exécution 46009728045 réussie (commit 539738c) : 93 énoncés et 59 lemmes de cohérence limités aux trois axiomes standard, `leanchecker` sur les quatre modules, `nanoda_bin` sur `Principal.lean` |
| Version 3.9 : `ConditionalCRO`, puis `Enonces`, `Principal` et `Coherence` | local, 27 novembre 2026, Lean 4.35.0, Mathlib v4.35.0 à imports ciblés | réussi, aucune erreur ni aucun avertissement ; 95 `#print axioms` dans le fichier, 93 sur `Principal.lean` et 59 sur `Coherence.lean`, tous standard |
| Version 3.8 avec `import Mathlib` complet, `verifier.sh` étapes 1 à 6 | faite par GitHub le 27 novembre 2026 | workflow `verification_lean.yml`, exécution 46004107163 réussie (commit ac4fc98) : 89 énoncés et 56 lemmes de cohérence limités aux trois axiomes standard, `leanchecker` sur les quatre modules, `nanoda_bin` sur `Principal.lean` |
| Version 3.8 : `ConditionalCRO`, puis `Enonces`, `Principal` et `Coherence` | local, 27 novembre 2026, Lean 4.35.0, Mathlib v4.35.0 à imports ciblés | réussi, aucune erreur ni aucun avertissement ; 89 `#print axioms` dans le fichier, 89 sur `Principal.lean` et 56 sur `Coherence.lean`, tous standard |
| Version 3.7 avec `import Mathlib` complet, `verifier.sh` étapes 1 à 6 | faite par GitHub le 27 novembre 2026 | workflow `verification_lean.yml`, exécution 46001043885 réussie (commit ebfc833) : 74 énoncés et 51 lemmes de cohérence limités aux trois axiomes standard, `leanchecker` sur les quatre modules, `nanoda_bin` sur `Principal.lean` |
| Version 3.7 : `ConditionalCRO`, puis `Enonces`, `Principal` et `Coherence` | local, 27 novembre 2026, Lean 4.35.0, Mathlib v4.35.0 à imports ciblés | réussi, aucune erreur ni aucun avertissement ; 74 `#print axioms` dans le fichier, 74 sur `Principal.lean` et 51 sur `Coherence.lean`, tous standard |
| Version 3.6 avec `import Mathlib` complet, `verifier.sh` étapes 1 à 6 | faite par GitHub le 27 novembre 2026 | workflow `verification_lean.yml`, exécution 45998003187 réussie (commit 8993e9d) : 64 énoncés et 48 lemmes de cohérence limités aux trois axiomes standard, `leanchecker` sur les quatre modules, `nanoda_bin` sur `Principal.lean` |
| Version 3.6 : `ConditionalCRO`, puis `Enonces`, `Principal` et `Coherence` | local, 27 novembre 2026, Lean 4.35.0, Mathlib v4.35.0 à imports ciblés | réussi, aucune erreur ni aucun avertissement ; 61 `#print axioms` dans le fichier, 64 sur `Principal.lean` et 48 sur `Coherence.lean`, tous standard |
| Version 3.5 : `ConditionalCRO`, puis `Enonces`, `Principal` et `Coherence` | local, 27 novembre 2026, Lean 4.35.0, Mathlib v4.35.0 à imports ciblés | réussi, aucune erreur ni aucun avertissement |
| Version 3.5 avec `import Mathlib` complet, `verifier.sh` étapes 1 à 6 | faite par GitHub le 27 novembre 2026 | workflow `verification_lean.yml`, exécution 45995428572 réussie (commit 2fc83b7) : 47 énoncés et 40 lemmes de cohérence limités aux trois axiomes standard, `leanchecker` sur les quatre modules, `nanoda_bin` sur `Principal.lean` |
| `#print axioms`, version 3.5 | local, 27 novembre 2026 | 44 dans le fichier, 47 sur `Principal.lean` et 40 sur `Coherence.lean`, tous limités à `[propext, Classical.choice, Quot.sound]` |
| `lake build ConditionalCRO Verification`, version 3.4 | local, 26 novembre 2026, Lean 4.35.0, Mathlib v4.35.0 | réussi, aucun avertissement dans `Verification` |
| `bash verifier.sh`, étapes 1 à 6 | local | réussi, voir `results/verification.log` |
| `#print axioms` sur les 29 théorèmes de `Principal.lean`, version 3.4 | local | `[propext, Classical.choice, Quot.sound]` pour chacun |
| `leanchecker` sur les quatre modules | local | réussi |
| `leanchecker --fresh Verification.Principal` (rejeu complet depuis zéro) | local, hors script | réussi en 6 min 23 s |
| `nanoda_bin` sur l'export de `Principal.lean` | local | 28 867 déclarations vérifiées, aucune erreur de typage |
| Tests de mutation (énoncé modifié, Pinsker affaibli, preuve dans `Enonces.lean`, `sorry`, `axiom`) | local | le script échoue dans les cinq cas |
| Compilation avec `import Mathlib` complet | faite par GitHub le 26 novembre 2026 | workflow `verification_lean.yml`, exécution 45889126160 réussie, 20 `#print axioms` limités à propext, Classical.choice et Quot.sound |
| Workflow `verification_lean.yml` | exécuté et réussi | contrôle à chaque modification du dossier Lean, journaux dans l'onglet Actions |

**Réserve sur la compilation locale.** Les hôtes du cache Mathlib étaient inaccessibles. La compilation locale a donc porté sur une copie de `ConditionalCRO.lean` dont seule la ligne 46 diffère. `import Mathlib` y est remplacé par sept imports ciblés de Mathlib v4.35.0, déjà utilisés pour vérifier la version 3.4. Le reste du fichier est identique octet pour octet. La version du dépôt, avec `import Mathlib`, n'a pas été recompilée ici.

## Tableau de traçabilité

Les numéros et les pages sont ceux du manuscrit v36 (`index_labels_v36.tsv`), identiques à ceux de la v35 pour les énoncés de la version 3.4. « Fichier » désigne la ligne de `ConditionalCRO.lean` ; la ligne du listing B.1 vaut quatre de moins. `E` et `P` désignent les lignes de `Enonces.lean` et de `Principal.lean`. Les 117 théorèmes affichent tous `[propext, Classical.choice, Quot.sound]`. Les lignes à partir de 1634 sont celles des sections 12 (version 3.5), 14 (version 3.6), 16 (version 3.7), 18 (version 3.8), 20 (version 3.9), 22 (version 3.10), 24 (version 3.11), 26 (version 3.12) et 28 (version 3.13), absentes du listing B.1.

### Énoncés démontrés

| Énoncé du manuscrit | Label | N° et page v36 | Nom Lean | Fichier | E / P | Statut |
|---|---|---|---|---|---|---|
| Négligeabilité de ε₀ = 2^(−λ) | `lem:negligeabilite_eps0` | Lemme 3.1, p. 113 | `negligible_eps0` | 80 | 69 / 19 | démontré |
| Garantie de confidentialité, Conf ≥ 1 − √(c₀βI) | `lem:confidentiality_guarantee` | Lemme 2.3, (2.46), p. 57 | `lemma4_confidentiality_guarantee` | 172 | 75 / 22 | démontré, Pinsker posé (a) |
| Trilemme, forme explicite | `eq:trilemme_cro_explicite`, `eq:main_theorem_lean4_explicit` | (2.49) p. 58 ; (3.30) p. 114 | `trilemma_explicit` | 195 | 82 / 23 | démontré, Fano posé (a) |
| Trilemme, forme publiée | `rem:corollaire_publie`, `thm:original_lean4` | Remarque 2.17, p. 61 ; Théorème 3.2, p. 109 | `trilemma_instance` | 244 | 91 / 24 | démontré, Fano posé (a) |
| Trilemme, forme asymptotique | `thm:conditional_CRO_trilemma`, `eq:trilemme_cro_conditionnel` | Théorème 3.3, p. 113, (3.29) p. 114 ; (2.48) p. 58 | `conditional_CRO_trilemma` | 274 | 99 / 25 | démontré, Fano posé (a) |
| Trilemme, forme raffinée | `eq:trilemme_cro_raffine` | (2.50), p. 58 | `trilemma_refined` | 415 | 109 / 26 | démontré, I(V;Σ\|C) ≤ H(V\|C) posé (a) |
| Témoin de cohérence | `thm:witness_consistency` | Théorème 3.4, p. 114 | `assumptions_consistent_and_bound_attained` | 322 | 118 / 27 | démontré (b) |
| Nécessité du régime | `thm:scope_necessity` | Théorème 3.5, p. 115 | `regime_assumption_necessary` | 356 | 128 / 28 | démontré |
| Régime Helios | `thm:regime_helios` | Théorème 3.6, p. 120 | `Helios_regime_at_128` | 379 | 137 / 29 | démontré |
| Régime zk-SNARKs | `thm:regime_snarks` | Théorème 3.7, p. 120 | `zkSNARK_regime_at_256` | 386 | 141 / 30 | démontré |
| Régime audit traditionnel | `thm:regime_audit` | Théorème 3.8, p. 121 | `TraditionalAudit_regime_at_128` | 393 | 145 / 31 | démontré |
| Verdict déterministe, Opp = 1 | `rem:verdict_deterministe` | Remarque 2.4, p. 48 | `opp_eq_one_of_deterministic` | 402 | 150 / 32 | démontré |
| Verdict déterministe, γ − I ≤ Δ | `subsec:lean4_extensions` | 3.4.8, p. 115 | `deterministic_forces_capacity` | 408 | 155 / 33 | démontré |
| Facteur institutionnel égal à 1 si Δ ≥ γ | `rem:activite_delta` | Remarque 2.18, p. 61 | `refined_bound_is_fano_when_delta_ge_gamma` | 447 | 161 / 34 | démontré |
| Facteur < 1 si et seulement si Δ < γ − κ/λ | `rem:activite_delta` | Remarque 2.18, p. 61 ; 3.4.8, p. 116 | `factor_lt_one_iff` | 459 | 170 / 35 | démontré |
| Seuil H♯ = (Δ + 1 + κ/λ)/α | `eq:seuil_activite` | (2.65), p. 61 ; 3.4.8, p. 116 | `seuil_Hsharp` | 470 | 177 / 36 | démontré |
| Pinsker fini, TV² ≤ KL/2 (nats) | `subsec:lean4_concret` | 3.4.9, étape 2, p. 117 | `pinsker_finite` | 673 | 185 / 39 | démontré |
| Positivité de l'information mutuelle | `subsec:lean4_concret` | 3.4.9, étape 3, p. 117 | `miN_nonneg` | 729 | 193 / 40 | démontré |
| Information mutuelle majorée par l'entropie | `subsec:lean4_concret` | 3.4.9, étape 3, p. 117 | `miN_le_entN2` | 765 | 199 / 41 | démontré |
| Fano fini, p·log N − log 2 ≤ I(M;Σ) | `subsec:lean4_concret`, `eq:fano_inequality` | 3.4.9, étape 4, p. 117 ; (1.9), p. 17 | `fano_finite` | 793 | 205 / 42 | démontré |
| I(V;Σ\|C) ≤ H(V\|C) sur le modèle | `subsec:lean4_concret` | 3.4.9, p. 117 | `CLOModel.IV_le_HV` | 1027 | 216 / 45 | démontré |
| Pinsker sur le modèle, TVmax² ≤ c₀·KLmax | `subsec:lean4_concret`, `rem:constante_c0` | 3.4.9, p. 117 ; Remarque 2.16, p. 58 | `CLOModel.pinsker_model` | 1077 | 223 / 46 | démontré sous supports communs |
| Fano sur le modèle, Rel(D)·λ − 1 ≤ I(M;Σ\|C) | `ass:reliability_axiom` | Hypothèse 3.4, p. 109 (devenue théorème) | `CLOModel.fano_model` | 1128 | 232 / 47 | démontré |
| Trilemme explicite sur lois finies | `eq:trilemme_cro_explicite`, `subsec:lean4_concret` | (2.49), p. 58 ; 3.4.9, p. 117 | `trilemma_explicit_concrete` | 1319 | 240 / 48 | démontré sous Hypothèses 2.1, 2.2, 2.4 (c) |
| Trilemme raffiné sur lois finies | `eq:trilemme_cro_raffine`, `subsec:lean4_concret` | (2.50), p. 58 ; 3.4.9, p. 117 | `trilemma_refined_concrete` | 1336 | 253 / 49 | démontré sous Hypothèses 2.1, 2.2, 2.4 (c) |
| Lemme 2.3 sur lois finies | `lem:confidentiality_guarantee`, `subsec:lean4_concret` | Lemme 2.3, p. 57 ; 3.4.9, p. 117 | `lemma4_concrete` | 1351 | 268 / 50 | démontré sous Hypothèse 2.3 et supports communs |
| Trilemme asymptotique sur lois finies | `thm:conditional_CRO_trilemma`, `subsec:lean4_concret` | Théorème 3.3, p. 113 ; 3.4.9, p. 118 | `conditional_CRO_trilemma_concrete` | 1367 | 278 / 51 | démontré sous Hypothèses 2.1, 2.2, 2.4 (c) |
| Famille témoin, toutes hypothèses satisfaites | `subsec:lean4_concret` | 3.4.9, p. 118 | `concrete_assumptions_satisfiable` | 1516 | 298 / 54 | démontré |
| Le trilemme asymptotique s'applique à la famille témoin | `subsec:lean4_concret` | 3.4.9, p. 118 | `concrete_asymptotic_applies` | 1535 | 313 / 55 | démontré |
| DPI finie, I(X;Z) ≤ I(X;Y) | `lem:dpi`, `lem:ann_dpi` | Lemme 1.3 (p. 17) et Lemme A.2 (p. 221) | `dpi_finite` | 1634 | 331 / 58 | démontré |
| DPI pour la variation totale | `prv:composition` | preuve du Théorème 2.3, p. 49 | `tv_pushforward_le` | 1691 | 339 / 59 | démontré |
| Bornes élémentaires, Conf, Rel, Opp dans [0, 1] | `thm:bornes_mesures` | Théorème 2.1, (2.6), p. 46 | `bornes_mesures` | 1752 | 346 / 60 | démontré |
| Goulot contextuel, I(V;Σ\|C) ≤ min{H(Σ\|C), H(V\|C)} ≤ log₂\|V\| ≤ αH(C) | `thm:goulot_contexte` | Théorème 2.2, (2.14), p. 48 | `goulot_contexte` | 1763 | 356 / 61 | démontré |
| Capacité, I(V;Σ\|C) − I(M;Σ\|C) ≤ γ + 1, d'où Δ* ≤ γ + 1 | `rem:delta_capacite` | Remarque 2.11, p. 56 | `capacite_le_gamma_add_one` | 1779 | 366 / 62 | démontré |
| La borne sur \|V\| n'entraîne pas H(V\|C) ≥ γ (contre-exemple) | `rem:statut_verdict_efficace` | Remarque 2.12, p. 56 | `verdict_card_not_efficient` | 1830 | 375 / 63 | démontré |
| Composition séquentielle, Conf(P₁ ∘ P₂) ≥ Conf(P₁) | `thm:composition_sequentielle` | Théorème 2.3, (2.21), p. 49 | `conf_post` | 1906 | 381 / 64 | démontré |
| Composition séquentielle, Relrec(P₁ ∘ P₂) ≤ Relrec(P₁) | `thm:composition_sequentielle` | Théorème 2.3, (2.22), p. 49 | `rel_post` | 1925 | 392 / 65 | démontré |
| Opposabilité composée à verdict fixé | `rem:composition_opp` | Remarque 2.5, p. 49 | `opp_post` | 1968 | 403 / 66 | démontré |
| Composition parallèle, Conf ≤ min et relèvement des décodeurs | `thm:composition_sequentielle` | Théorème 2.3, (2.23) et (2.24), p. 49 | `composition_parallele` | 2008 | 412 / 67 | démontré |
| Inégalité de Fréchet, ab ≥ a + b − 1 | `rem:composition_opp` | Remarque 2.5, p. 49 | `frechet` | 2023 | 424 / 68 | démontré |
| Pas de sous-additivité (V = B₁ ⊕ B₂) | `rem:composition_opp` | Remarque 2.5, p. 49 | `xor_not_subadditive` | 2034 | 428 / 69 | démontré |
| Pas de sur-additivité (Σ₁ = Σ₂ = V) | `rem:composition_opp` | Remarque 2.5, p. 49 | `copy_not_superadditive` | 2045 | 435 / 70 | démontré |
| Règle de chaîne, I(A;B,G) = I(A;B) + I(A;G\|B) | `prv:fondement_extraction` | preuves de la Proposition 2.1 et du Lemme 1.3 | `chain_rule` | 2071 | 443 / 71 | démontré |
| Positivité de l'information mutuelle conditionnelle | `lem:dpi` | preuve du Lemme 1.3, p. 17 | `condMI_nonneg` | 2110 | 450 / 72 | démontré |
| Fondement de l'extraction bornée | `prop:fondement_extraction` | Proposition 2.1, (2.40), p. 55 | `fondement_extraction` | 2200 | 457 / 73 | démontré |
| Verdict déterministe sur lois finies, Opp = 1 | `rem:verdict_deterministe`, `rem:opp_lean4_admissible` | Remarque 2.4 (p. 48) et Remarque 3.9 (p. 108) | `opp_eq_one_of_det_concrete` | 2289 | 465 / 74 | démontré |
| Le minorant 1 − √(c₀βI) décroît avec I et vaut 1 en I = 0 | `rem:interpretation_lemme`, `rem:interp_lemme4` | Remarque 2.3 (p. 47) et Remarque 2.15 (p. 58) | `conf_guarantee_antitone` | 2312 | 474 / 75 | démontré |
| Tension confidentialité et information mutuelle | `lem:compromis_conf_mi` | Lemme 2.1, p. 46 | `lemma4_concrete` | 1351 | 268 / 50 | démontré sous Hypothèse 2.3 et supports communs ; même énoncé que le Lemme 2.3 |
| Garantie de confidentialité quantique, Conf^q ≥ 1 − ½√(2β_qχmax + 2ζ_qDmax) | `lem:q_conf_mi_pq` | Lemme 2.8, (2.108), p. 77 | `conf_guarantee` | 2442 | 491 / 78 | démontré, Pinsker quantique posé (e) |
| Trilemme quantique, forme explicite | `thm:trilemme_pq` | Théorème 2.5, (2.110), p. 77 | `trilemma_pq_explicit` | 2463 | 497 / 79 | démontré, Fano quantique et Holevo posés (e) |
| Trilemme quantique, majoration publiée | `rem:corollaire_publie_pq` | Remarque 2.41, p. 80 | `trilemma_pq_published` | 2475 | 505 / 80 | démontré (e) |
| Trilemme quantique, forme asymptotique | `thm:trilemme_pq` | Théorème 2.5, p. 77 | `conditional_CRO_trilemma_pq` | 2510 | 512 / 81 | démontré (e) |
| Trilemme quantique, forme raffinée | `rem:forme_raffinee_pq` | Remarque 2.39, (2.117), p. 79 | `trilemma_pq_refined` | 2524 | 521 / 82 | démontré (e) |
| Seuil H♯_q, facteur < 1 ⟺ H(C) > (Δ_q + κ/λ)/(θ_qα_q) | `rem:forme_raffinee_pq` | Remarque 2.39, p. 79 | `seuil_Hsharp_q` | 2536 | 528 / 83 | démontré |
| Forme simplifiée quantique, rapport → 1 | `cor:forme_simplifiee_pq` | Corollaire 2.2, (2.118), p. 80 | `forme_simplifiee_pq` | 2547 | 535 / 84 | démontré |
| k_λ ≤ 2^(α_qH(C)) n'entraîne pas H(V\|C) ≥ γ_q | `rem:statut_verdict_quantique` | Remarque 2.31, p. 76 | `verdict_q_card_not_efficient` | 2567 | 540 / 85 | démontré |
| Raccord γ_q = γ, θ_q = 1 − 1/(αH(C)) ∈ [1/2, 1) | `rem:raccord_gamma_q` | Remarque 2.32, p. 76 | `raccord_gamma_q` | 2580 | 546 / 86 | démontré |
| Statut du régime quantique | `rem:statut_regime_quantique` | Remarque 2.33, p. 76 | `statut_regime_q` | 2601 | 552 / 87 | démontré (e) |
| Constantes de Pinsker, (ln 2)/2 < 1/2 < c₀ | `rem:raccord_pinsker` | Remarque 2.35, p. 77 | `constantes_pinsker` | 2614 | 559 / 88 | démontré |
| Décomposition de Δ_q, Δ_q ≤ Δ sans renforcement | `def:decomposition_delta_q` | Définition 2.30, p. 75 | `deltaQ_le` | 2622 | 562 / 89 | démontré |
| Encadrement de η_q sur lois finies | `def:perte_interp_quantique_pq`, `rem:encadrement_eta_q` | Définition 2.27 et Remarque 2.27, p. 74 | `etaQ_bounds` | 2634 | 566 / 90 | démontré |
| La DPI ne fournit pas l'Hypothèse 2.5 | `rem:capacite_institutionnelle_quantique` | Remarque 2.29, p. 74 | `capacite_q_non_dpi` | 2668 | 577 / 91 | démontré |
| Le régime quantique est nécessaire | `rem:scope_trilemme_pq` | Remarque 2.37, p. 79 | `regime_q_necessary` | 2716 | 582 / 92 | démontré |
| Cohérence du modèle quantique, borne atteinte | `thm:trilemme_pq` | Théorème 2.5, p. 77 | `assumptions_q_consistent` | 2750 | 592 / 93 | démontré (b) |
| D_max ≥ 25 960 bits pour ML-DSA-65 | `rem:interp_lemme7` | Remarque 2.36, p. 77 | `dilithium_Dmax` | 2764 | 601 / 94 | démontré |
| Fano aigu, I·ln 2 ≥ pλ ln 2 + p ln p − p | `prop:borne_aigue` | Proposition 2.2, étapes 1 à 3, p. 62 | `fano_sharp_model` | 2873 | 611 / 97 | démontré |
| Borne aiguë, Rel ≤ 2κ/(λ(λ−3)) + 2^(−λ/2) | `prop:borne_aigue`, `eq:fano_aigu` | Proposition 2.2, (2.61), p. 62 | `rel_aigu` | 3000 | 619 / 98 | démontré |
| Produit sous la borne aiguë | `eq:trilemme_aigu` | Proposition 2.2, (2.62), p. 62 | `trilemma_aigu_concrete` | 3011 | 627 / 99 | démontré |
| Conf ≥ 1 − √(c₀βκ/λ) sur lois finies | `thm:trilemme_cro_conditionnel` | Théorème 2.4, dernière phrase, p. 58 | `conf_regime_concrete` | 3043 | 639 / 100 | démontré |
| Conf ≥ 1 − √(c₀βκ/λ), modèle abstrait | `thm:trilemme_cro_conditionnel` | Théorème 2.4, dernière phrase, p. 58 | `conf_regime` | 3051 | 647 / 101 | démontré |
| Forme simplifiée, rapport → 1 et 1 + 7/640 | `cor:forme_simplifiee` | Corollaire 2.1, p. 64 | `forme_simplifiee` | 3066 | 654 / 102 | démontré |
| Portée des études de cas, 129/128² < 0,008 | `rem:portee_cas_etude` | Remarque 2.24, p. 65 | `portee_cas_etude` | 3075 | 661 / 103 | démontré |
| Ordre λ⁻¹ de la forme explicite, ordre λ⁻² de la borne aiguë | `rem:borne_forte_statut`, `rem:borne_aigue_portee` | Remarque 5.5 (p. 185) et Remarque 2.19 (p. 62) | `borne_forte_statut` | 3103 | 667 / 104 | démontré |
| Borne aiguë quantique | `rem:borne_aigue_pq` | Remarque 2.40, p. 80 | `trilemma_aigu_q` | 3148 | 674 / 105 | démontré, minoration fine posée pour l'issue de la mesure (e) |
| Témoin réalisable, Conf = 1 et Opp = Δ/γ | `rem:temoin_realisable` | Remarque 2.20, p. 63 | `temoin_realisable` | 3365 | 684 / 106 | démontré |
| Jeu IND-CONF, succès = ½ + avantage | `def:jeu_ind_conf`, `def:ann_ind_conf` | Définition 2.5 (p. 50) et Définition A.5 (p. 222) | `succIND_eq` | 3437 | 704 / 110 | démontré (f) |
| Avantage d'un test au plus TV/2 | `rem:jeu_ind_conf_link` | Remarque 2.6, preuve, p. 50 | `advDist_le_tv` | 3447 | 710 / 111 | démontré |
| Égalité pour le test de Neyman-Pearson | `rem:jeu_ind_conf_link` | Remarque 2.6, preuve, p. 50 | `neyman_pearson` | 3458 | 715 / 112 | démontré |
| Pont IND-CONF ↔ Conf, Adv ≤ (1 − Conf)/2 | `rem:jeu_ind_conf_link`, `rem:ann_ind_conf_link` | Remarque 2.6 (p. 50) et Remarque A.1 (p. 222) | `ind_conf_le_conf` | 3471 | 721 / 113 | démontré (f) |
| Réciproque en défaut, supports disjoints donnent TV = 1 | `rem:jeu_ind_conf_link` | Remarque 2.6, preuve, p. 50 | `tv_disjoint` | 3484 | 729 / 114 | démontré |
| Jeu BIND-REL, gain dans [0, 1] | `def:jeu_bind_rel`, `def:ann_bind_rel` | Définition 2.6 (p. 51) et Définition A.6 (p. 223) | `winBindRel_bounds` | 3512 | 734 / 115 | démontré (f) |
| Pont BIND-REL ↔ Relver, Relver ≥ 1 − ε_bind − ν | `rem:jeu_bind_rel_link`, `rem:ann_bind_rel_link`, `eq:rel_ver` | Remarque 2.7 (p. 51), Remarque A.2 (p. 223), (2.4) p. 45 | `relver_ge` | 3501 | 741 / 116 | démontré, ν et t(λ) en paramètres (f) |
| Ouverture liante, gain nul et Relver = complétude | `rem:jeu_bind_rel_link` | Remarque 2.7, preuve, p. 51 | `relver_of_liant` | 3522 | 746 / 117 | démontré |
| Conf = 1 entraîne Relrec = 2^(−λ) | `rem:rel_ver`, `rem:jeu_bind_rel_link`, `rem:ann_bind_rel_link` | Remarque 2.2 (p. 45), Remarque 2.7 (p. 51), Remarque A.2 (p. 223) | `rel_of_conf_one` | 3538 | 754 / 118 | démontré |
| Inégalité de Fano, H(A\|B) ≤ h(ε) + ε log(\|A\| − 1) | `lem:ann_g_fano` | Lemme A.1, p. 221 | `fano_general` | 3595 | 761 / 119 | démontré (nats) |
| I(V;Σ\|C) = H(V\|C) − H(V\|Σ,C) | `rem:jeu_ext_opp_link` | Remarque 2.8, preuve, p. 52 | `CLOModel.IV_eq_HV_sub` | 3729 | 768 / 120 | démontré |
| Jeu EXT-OPP et pont EXT-OPP ↔ Opp | `def:jeu_ext_opp`, `def:ann_ext_opp`, `rem:jeu_ext_opp_link`, `rem:ann_ext_opp_link` | Définitions 2.7 (p. 51) et A.7 (p. 224), Remarques 2.8 (p. 52) et A.3 (p. 224) | `CLOModel.ext_opp_bridge` | 3756 | 776 / 121 | démontré pour un interprète qui lit (C, Σ) (f) |
| Pont EXT-OPP avec les ressources K | `rem:jeu_ext_opp_link`, `rem:ann_ext_opp_link` | Remarques 2.8 (p. 52) et A.3 (p. 224) | `ext_opp_bridge_K` | 3776 | 785 / 122 | démontré, règle de chaîne en prémisse (f) |
| Produit CLO depuis les jeux | `cor:ann_cro_from_games`, `eq:ann_cro_product_games` | Corollaire A.2, p. 229 | `product_from_games` | 3789 | 791 / 123 | démontré |
| Deux échelles distinctes | `rem:ann_pas_de_contradiction` | Remarque A.6, p. 230 | `echelles_distinctes` | 3806 | 801 / 124 | démontré |
| Distance de trace d'états diagonaux égale à la variation totale | `rem:compatibilite_conf`, `rem:compatibilite_classique` | Remarques 2.9 (p. 53) et 2.26 (p. 73) | `traceDist_eq_tv` | 3923 | 817 / 128 | démontré (g) |
| Conf^q = Conf en encodage diagonal | `rem:compatibilite_conf`, `rem:compatibilite_classique`, `def:conf_quantique_clo` | Remarques 2.9 (p. 53) et 2.26 (p. 73), Définition 2.8 (p. 52) | `CLOModel.confQ_diag_eq` | 3954 | 822 / 129 | démontré (g) |
| S(ρ) = H(X) pour un état diagonal | `rem:relation_shannon` | Remarque 2.25, p. 70 | `vonNeumann_diag` | 3975 | 828 / 130 | démontré (g) |
| Cas limite de l'inégalité (68) publiée, 1 bit contre 1/2 | `rem:retrait_lemma6` | Remarque 2.34, p. 76 | `cas_limite_lemme6` | 3995 | 835 / 131 | démontré pour la mesure dans la base calculatoire (g) |
| Masque uniforme, TV(P_{M*\|m₀}, P_{M*\|m₁}) = 0 | `thm:proprietes_sotp`, `prv:sotp_conf` | Théorème 3.1, preuve, p. 89 | `sotp_mask_tv` | 4059 | 850 / 135 | démontré |
| S-OTP, Conf = 1 quand la loi de Σ ne dépend pas de M | `thm:proprietes_sotp`, `prv:sotp_conf` | Théorème 3.1, p. 89 | `CLOModel.conf_eq_one_of_indep` | 4071 | 856 / 136 | démontré (h) |
| S-OTP, I(V;Σ\|C) ≤ H(h\|C) et Opp ≤ H(h\|C)/H(V\|C) | `thm:proprietes_sotp`, `prv:sotp_opp` | Théorème 3.1, p. 89 et 90 | `CLOModel.sotp_opp_le` | 4165 | 863 / 137 | démontré (h) |
| h fonction du contexte public, H(h\|C) = 0 et Opp = 0 | `rem:portee_sotp` | Remarque 3.2, p. 89 | `CLOModel.sotp_opp_zero_of_public` | 4182 | 873 / 138 | démontré |
| Minorant par traits, I(V;T₁) + I(V;T₂) ≤ I(V;T₁,T₂) pour des traits indépendants | `prop:minorant_traits`, `eq:minorant_traits` | Proposition 4.1, p. 129 | `traits_superadditif` | 4287 | 890 / 142 | démontré pour deux traits, cas général par `traits_superadditif_k` (i) |
| Minorant par traits, I(g(V);T) ≤ I(V;T) | `prop:minorant_traits` | Proposition 4.1, p. 129 | `trait_stat_le` | 4321 | 898 / 143 | démontré (i) |
| Minorant par traits, I(V;T(Σ)) ≤ I(V;Σ) | `prop:minorant_traits` | Proposition 4.1, p. 129 | `trait_fonction_preuve` | 4335 | 904 / 144 | démontré (i) |
| Un trait binaire porte au plus 1 bit | `prop:minorant_traits` | Proposition 4.1, p. 129 | `trait_binaire_le` | 4347 | 910 / 145 | démontré |
| Estimateur pour une preuve masquante | `rem:estimateur_masquant` | Remarque 4.2, p. 129 | `CLOModel.estimateur_masquant` | 4363 | 915 / 146 | démontré |
| Formulation initiale de l'estimateur, minorant éventuellement négatif | `def:capacite_extraction_op` | Définition 4.1, p. 127 | `estimateur_initial` | 4388 | 923 / 147 | démontré |
| Exemple αH(C) = 20, λ = 128 : −107 | `def:capacite_extraction_op` | Définition 4.1, p. 127 | `estimateur_initial_exemple` | 4394 | 928 / 148 | démontré |
| Calibration Δ := λ·produit (56, 73, 35 bits) | `tab:validation_cro_classique`, `tab:comparaison_produits_cro` | Tableaux 2.2 (p. 67) et 4.18 (p. 151) | `calibration_delta` | 4406 | 932 / 149 | vérifié numériquement |
| Totaux de la décomposition de Δ, somme naïve de 100 bits | `tab:decomposition_delta`, `tab:composantes_delta` | Tableaux 4.13 (p. 149) et 4.12 (p. 148) | `decomposition_delta` | 4414 | 937 / 150 | vérifié numériquement |
| γ̂ = 19, 1 et 1,97 ; H♯ = 47,5 bits pour Helios | `tab:parametres_reference` | Tableau 4.2, p. 126 | `parametres_reference` | 4422 | 942 / 151 | vérifié numériquement |
| Ordre λ⁻² exact de la borne aiguë : témoin de fiabilité optimale κ/λ², Conf = 1 − ρ, Opp = Δ/γ, Hypothèses 2.1, 2.2 et 2.4 | `rem:borne_aigue_portee`, `rem:temoin_combine` | Remarques 2.19 (p. 62) et 2.21 (p. 63) | `borne_aigue_atteinte` | 4800 | 955 / 154 | démontré (j) |
| Borne aiguë atteinte à un facteur entre 2,02 et 2,11 (Δ = γ = 1), entre 2,02 et 2,13 ((Δ, γ) = (5, 19) ou (10, 40)) | `rem:borne_aigue_portee`, `rem:temoin_combine` | Remarques 2.19 et 2.21 | `rapports_borne_aigue` | 5204 | 975 / 155 | vérifié numériquement (j) |
| Hypothèse 2.3 du témoin avec β = 1,03, supports communs | `rem:borne_aigue_portee` | Remarque 2.19, p. 62 | `regularite_temoin` | 5065 | 986 / 156 | démontré (j) |
| Minorant par traits, ∑_j I(V;T_j) ≤ I(V;T) pour k traits mutuellement indépendants | `prop:minorant_traits`, `eq:minorant_traits` | Proposition 4.1, p. 129 | `traits_superadditif_k` | 5090 | 995 / 157 | démontré (i) |
| Les trois inégalités de la Proposition 4.1 pour k traits | `prop:minorant_traits`, `eq:minorant_traits` | Proposition 4.1, p. 129 | `minorant_traits` | 5153 | 1004 / 158 | démontré (i) |
| Le minorant ne dépasse pas k bits | `prop:minorant_traits` | Proposition 4.1, p. 129 | `minorant_k_bits` | 5172 | 1019 / 159 | démontré |
| Moyenne sur C au plus le maximum, I(M;Σ\|C) ≤ χmax, encodage diagonal | `rem:statut_regime_quantique` | Remarque 2.33, p. 76 | `CLOModel.I_le_chiMax` | 5264 | 1030 / 162 | démontré (k) |
| Pinsker quantique pour des états diagonaux, TDmax² ≤ D/2 en nats | `lem:pinsker_quantique` | Lemme 2.4, p. 70 | `CLOModel.pinsker_nats` | 5300 | 1037 / 163 | démontré pour l'encodage diagonal (k) |
| Trilemme CRO conditionnel quantique, forme explicite, sans hypothèse posée | `thm:trilemme_pq` | Théorème 2.5, p. 77 | `trilemme_pq_diagonal` | 5376 | 1046 / 164 | démontré pour l'encodage diagonal (k) |
| Garantie de confidentialité quantique, sans hypothèse posée | `lem:q_conf_mi_pq` | Lemme 2.8, p. 77 | `conf_guarantee_diagonal` | 5389 | 1058 / 165 | démontré pour l'encodage diagonal (k) |

(a) Dans le modèle abstrait, Fano (I ≥ Rel·λ − 1) et Pinsker (TV² ≤ c₀·KL) sont des champs de `ProtocolInstance`. La couche concrète les démontre (lignes 1077 et 1128).
(b) Point du modèle abstrait, non réalisable par une loi (Remarque 3.10, p. 114).
(e) Noyau quantique (section 14). Comme Fano et Pinsker dans le modèle abstrait classique, Fano quantique (Lemme 2.6), la borne de Holevo (Lemme 2.7) et Pinsker quantique (Lemme 2.4) sont des champs de `QuantumProtocolInstance`. Ils ne sont pas démontrés dans le cas général (lot L5c de la feuille de route). Ils le sont pour l'encodage diagonal depuis la version 3.13, voir (k).
(f) Jeux sur lois finies (section 18). Les adversaires et l'interprète sont des fonctions sur des ensembles finis, leur aléa propre étant moyenné. La borne de temps t(λ), le défaut de complétude ν et le terme négligeable restent des paramètres réels. Le pont EXT-OPP avec ressources reçoit la règle de chaîne H(V\|Σ,C) = H(V\|Σ,C,K) + I(V;K\|Σ,C) en prémisse. Sans ressources, il est démontré sur `CLOModel`.
(g) Encodage classique diagonal (section 20). L'état ρ = Σ_s p(s)\|s⟩⟨s\| est une matrice complexe diagonale. Son spectre est tiré du polynôme caractéristique (`Matrix.IsHermitian.roots_charpoly_eq_eigenvalues` de Mathlib), sans hypothèse posée. La norme de trace est la somme des valeurs absolues du spectre. Pour la Remarque 2.34, le théorème porte sur la mesure dans la base calculatoire, qui donne I_acc ≥ 1 bit ; il ne formalise pas le supremum sur toutes les mesures.
(h) Construction S-OTP (section 22). Le masque uniforme et l'engagement parfaitement masquant se traduisent par une loi de Σ sachant (M, C) indépendante de M. L'hypothèse « l'interprète ne lit la preuve qu'à travers h » est la factorisation du noyau de verdict, ker(c, s, ·) = k(c, h(c, s), ·), c'est-à-dire la chaîne V − (h, C) − Σ du manuscrit. La preuve combine la DPI finie et I ≤ H. La fiabilité de vérification relève du pont BIND-REL (section 18) et de la réduction au logarithme discret de `GameBasedSOTP.lean`.
(i) Minorant par traits (sections 24 et 26). Les énoncés portent sur une valeur fixée de (M, C) et passent à la moyenne. La version 3.11 démontre la seconde inégalité pour deux traits, par deux règles de chaîne et la nullité de I(T₁;T₂). La version 3.12 en tire le cas de k traits par récurrence sur k : T = (T₀, T_reste) par `Fin.consEquiv`, puis le cas de deux traits et l'hypothèse de récurrence. Les traits prennent leurs valeurs dans un même type fini, ce qui ne restreint pas la généralité.
(j) Atteinte de la borne aiguë (section 26). Le protocole `rhoModel` publie Σ = (Σ_ρ, B) : Σ_ρ révèle M avec probabilité ρ, B est uniforme sur Δ bits et le verdict est V = (B, K). Pour Δ = γ = 1, c'est le protocole de la Remarque 2.19 ; pour 1 ≤ Δ < γ, le témoin combiné de la Remarque 2.21. Le décodeur qui lit Σ_ρ est démontré optimal. Les rapports numériques sont des calculs exacts sur des rationnels. La constante β = 1,03 repose sur log 2 > 0,6931471803 (Mathlib) et sur −log(1 − ρ) ≤ ρ/(1 − ρ).
(k) Encodage diagonal sans hypothèse posée (section 28). `diagInstance` construit, à partir d'un protocole CLO fini, une instance du noyau quantique dont tous les champs sont démontrés : Conf^q est la distance de trace des états diagonaux (`confQ_diag_eq`), Pinsker quantique vient de Pinsker fini, Fano quantique de `fano_model`, la borne de Holevo est une égalité et χmax est le maximum sur c des informations I(M;Σ\|C = c). L'information accessible et la fiabilité sont celles de la mesure dans la base calculatoire ; le supremum sur toutes les mesures n'est pas formalisé. Les Hypothèses 2.5 à 2.8 restent des prémisses, comme dans la thèse.
(c) Les hypothèses institutionnelles sont des prémisses explicites du théorème. Elles portent le contenu propre à la cryptographie institutionnelle (Δ, γ = αH(C) − 1, κ).

### Hypothèses nommées

| Hypothèse du manuscrit | Label | N° et page v36 | Forme Lean | Fichier | Rôle dans les preuves |
|---|---|---|---|---|---|
| Extraction bornée, I(V;Σ\|C) ≤ I(M;Σ\|C) + Δ | `ass:extraction_bornee` | Hypothèse 2.1, p. 55 ; 3.1, p. 108 | champ `A1`, prémisse `A1` | 161, 1323 | utilisée par tous les trilemmes |
| Verdict efficace, H(V\|C) ≥ γ = αH(C) − 1 ≥ 1 | `ass:verdicts_efficace` | Hypothèse 2.2, p. 56 ; 3.2, p. 108 | champs `A2`, `A2γ`, prémisses `A2`, `A2γ` | 163, 1323 | utilisée par tous les trilemmes |
| Verdict efficace, \|V\| ≤ 2^(αH(C)) | `ass:verdicts_efficace` | Hypothèse 2.2, p. 56 | prémisse `hcard` | 1322 | **inutilisée** (d) |
| Régularité, D_KL ≤ β·I(M;Σ\|C) | `ass:regularite` | Hypothèse 2.3, p. 56 ; 3.3, p. 109 | champ `A3`, prémisse `A3` | 167, 1354 | Lemme 2.3 seulement (d) |
| Régime, I(M;Σ\|C) ≤ κ/λ | `ass:regime` | Hypothèse 2.4, p. 57 | prémisse `hA4` ou `A4` | 197, 1324 | utilisée par tous les trilemmes |
| Fiabilité-information (Fano relâché) | `ass:reliability_axiom` | Hypothèse 3.4, p. 109 | champ `fano` | 156 | posée dans le modèle abstrait, démontrée dans la couche concrète |
| Pinsker | `subsubsec:constante_pinsker` | 3.4.6.1, p. 112 | champ `pinsker` | 155 | posée dans le modèle abstrait, démontrée dans la couche concrète |
| Supports communs | `subsec:lean4_concret` | 3.4.9, p. 118 | `CLOModel.CommonSupport` | 919 | Pinsker et Lemme 2.3 seulement |

(d) Le code le dit lui-même dans ses commentaires, comme le manuscrit (3.4.7.1, p. 114 ; 3.4.9, p. 117).

### Hors du périmètre de la formalisation

| Résultat du manuscrit | Label | N° et page v36 | Statut |
|---|---|---|---|
| Optimalité de l'ordre λ⁻² (protocole à révélation ρ) et témoin combiné | `rem:borne_aigue_portee`, `rem:temoin_combine` | Remarques 2.19 et 2.21, p. 62 et 63 | démontrés sur papier, non formalisés ; la majoration en λ⁻² l'est |
| Lemmes d'information quantique (Pinsker, mesure douce, Fano, Holevo) | `lem:pinsker_quantique`, `lem:fano_quantique`, `lem:holevo_helstrom` | Lemmes 2.4 à 2.7, p. 70 et 71 | posés comme champs dans le noyau quantique, non démontrés |
| Propriétés de SOTP | `thm:proprietes_sotp` | Théorème 3.1, p. 89 | hors de ce dossier ; mécanisation réduite dans `04_sotp/` |

### Tests de cohérence des définitions propres

| Définition | Cas qui satisfait | Cas qui ne satisfait pas | Lignes de `Coherence.lean` |
|---|---|---|---|
| γ = αH(C) − 1 | Helios, γ = 47 | H(C) = α = 1, γ = 0 < 1 | 26 à 41 |
| `InstitutionalParams` | Helios | aucun jeu de paramètres avec α = 0, β < 1 ou Δ < 0 | 43 à 55 |
| `tv`, `klN`, `miN` | tv = 0 et KL = 0 pour deux lois égales ; I = 0 pour deux bits indépendants | tv = 1 pour deux Dirac disjoints ; I = log 2 pour un bit recopié | 59 à 87 |
| `CLOModel` | `copyModel` (Σ = M), `famModel` | aucune loi où M n'est pas uniforme ; aucun modèle à λ = 2 avec deux messages | 93 à 117 |
| `Conf` | Conf = 1 pour `famModel` | Conf = 0 pour `copyModel` | 120 à 153 |
| `Rel` | Rel = 1 pour `copyModel` et le décodeur qui lit la preuve | Rel = 2^(−λ) pour `famModel` et un décodeur constant | 136, 156 |
| `Opp` | Opp = 1 pour `famModel` (verdict qui recopie la preuve) | Opp = 0 pour `blindModel` (verdict qui ignore la preuve), avec H(V\|C) = 1 | 164 à 197 |
| `InstitutionalAssumptions` | `witnessInstance` | `degenerateInstance`, où H(V\|C) = 0 | 224 à 243 |
| Division par zéro dans Opp | les hypothèses imposent H(V\|C) ≥ 1 et Opp·H(V\|C) = I(V;Σ\|C) | en Lean 1/0 = 0 ; l'instance dégénérée aurait Opp = 0 avec I(V;Σ\|C) = 1 | 202 à 237 |
| `entN1` (version 3.5) | log 2 pour un bit recopié | 0 pour une loi de Dirac | 252 à 262 |
| `condMI` | log 2 quand G recopie A | 0 pour trois bits indépendants | 264 à 272 |
| `HS` | H(Σ\|C) = 1 pour `famModel` | — | 274 à 285 |
| `IVM`, `IVSM` | I(V;Σ\|M,C) = 1 pour `famModel`, où la preuve ne dit rien du message | I(V;M\|C) = 0 pour `famModel` | 287 à 312 |
| `constVerdict`, `detVerdict` | Opp = 1 et H(V\|C) = 1 pour le verdict V = Σ | Opp = 0 et H(V\|C) = 0 pour un verdict constant | 314 à 328 |
| `post`, `IVpost` | le post-traitement identité reproduit la loi et I(V;Σ\|C) | — | 330 à 351 |
| `gammaQ`, `QuantumAssumptions` (version 3.6) | γ_q = 1 et hypothèses satisfaites pour le témoin | γ_q = 1/2 < 1 ; instance où H(V\|C) = 0 exclue | 360 à 393 |
| `QuantumProtocolFamily` | famille à paramètres fixes, hypothèses satisfaites pour tout λ et théorème asymptotique appliqué | — | 394 à 415 |
| `bProd`, `QuantumSharpInstance`, `witModel` (version 3.7) | b = P pour `famModel` ; instance quantique de fiabilité nulle ; Opp = 5/19 et Conf = 1 pour (Δ, γ) = (5, 19) | Opp = 0 pour Δ = 0 | 428 à 455 |
| `deltaQ`, `etaQ` | Δ_q = 35 − 7 = 28 bits (ML-DSA-65) ; η_q = 0 pour le canal identité | — | 416 à 424 |
| `chiMax`, `DmaxDiag`, `diagInstance` (version 3.13) | χmax = 0 pour le protocole qui ne révèle rien (ρ = 0) ; Dmax ≥ 0 | χmax ≥ λ pour le protocole qui révèle M (ρ = 1) | 589 à 624 |
| `kRho`, `rhoOf`, `rhoModel`, `decRho`, `margTrait`, `borneAigue`, `produitTemoin` (version 3.12) | masse entière en m pour ρ = 1 ; fiabilité 1 pour ρ = 1 ; marginale uniforme 1/4 | loi uniforme 1/2 pour ρ = 0 ; fiabilité 1/2 pour ρ = 0 et λ = 1 ; trait toujours faux qui ne charge pas la valeur vrai ; borne et produit nuls pour κ = 0 | 547 à 587 |
| `maskLaw`, `pushLaw`, `entN` (version 3.10) | loi de m + K égale à 1/2 sur ZMod 2 ; entropie ln 2 de la composante identité d'un bit uniforme | entropie nulle d'une composante constante | 528 à 545 |
| `shannon`, `vonNeumann`, `traceDistDiag`, `ConfQdiag` (version 3.9) | S(ρ) = 1 bit pour un bit uniforme ; distance 1 entre \|0⟩⟨0\| et \|1⟩⟨1\| ; Conf^q = 1 pour `famModel` | S(ρ) = 0 pour un état pur ; distance 0 d'un état à lui-même ; Conf^q = 0 pour `copyModel` | 503 à 526 |
| `advDist`, `succIND`, `relver`, `winBindRel`, `binEntN`, `condEnt` (version 3.8) | test de Neyman-Pearson, avantage 1/2 et succès 1 ; Relver = 1 ; adversaire qui ouvre sur deux messages, gain 1 ; h(1/2) = ln 2 ; H(A\|B) = ln 2 pour un bit indépendant | test constant, avantage 0 ; Relver tronqué à 0 ; ouverture sur le même message, gain 0 ; h(0) = 0 ; H(A\|B) = 0 quand A = B | 455 à 501 |

## Carte de la preuve en langage simple

**Idée générale.** Toute la preuve exprime les trois métriques en fonction d'une seule quantité, x = I(M;Σ|C). Fano dit que Rel exige x grand. Les Hypothèses 2.1 et 2.2 disent que Opp est plafonné par (x + Δ)/γ. Le régime de l'Hypothèse 2.4 impose x ≤ κ/λ. Le produit est alors borné.

**Chaîne de réductions de la couche concrète** (lignes de `ConditionalCRO.lean`).

1. *Outil commun.* L'inégalité log x ≥ 1 − 1/x de Mathlib donne `term_ineq` (488), puis l'inégalité log-somme `log_sum_ineq` (504). Court.
2. *Fano.* `log_sum_ineq` et `binEnt_le_log_two` (529) donnent `fano_finite` (793). La preuve découpe les couples (message, preuve) selon le succès du décodeur. `fano_model` (1128) l'applique contexte par contexte et passe en bits. **C'est l'une des deux parties difficiles** (environ 100 et 45 lignes).
3. *Pinsker.* Une étude de dérivée sur [q, p] donne `pinsker_aux` (549) et `pinsker_aux_one` (603). Elles donnent `pinsker_binary` (645), puis `pinsker_finite` (673) par log-somme sur {P > Q} et son complémentaire. `pinsker_model` (1077) passe en bits avec c₀. **C'est l'autre partie difficile** (environ 170 lignes).
4. *Opposabilité.* `miN_le_entN2` (765) donne `IV_le_HV` (1027), donc Opp ≤ 1 sans hypothèse. Court.
5. *Produit.* `product_bound_explicit` (1202) et `product_bound_refined` (1240) sont de l'algèbre réelle. Conf ≤ 1, Rel ≤ (x + 1)/λ, Opp ≤ (x + Δ)/γ, monotonie en x puis x ≤ κ/λ. Court et lisible.
6. *Assemblage.* `trilemma_explicit_concrete` (1319) et `trilemma_refined_concrete` (1336) tiennent en deux lignes chacun. `asymptotic_of_explicit` (1266) et `negligible_eps0` (80) donnent `conditional_CRO_trilemma_concrete` (1367). Courts.
7. *Non-vacuité.* `famModel` (1401) et les calculs `fam_*` (1420 à 1507) donnent `concrete_assumptions_satisfiable` (1516) et `concrete_asymptotic_applies` (1535). Calculs directs.

**Modèle abstrait.** `trilemma_explicit` (195) refait l'étape 5 avec les champs d'une `ProtocolInstance`. `trilemma_instance` (244) utilise γ ≥ 1. `conditional_CRO_trilemma` (274) passe à l'asymptotique. `lemma4_confidentiality_guarantee` (172) enchaîne Pinsker et la régularité. Tout y est court parce que Fano et Pinsker y sont posés.

**Extension 3.5 (section 12).** `log_sum_ineq` donne aussi la DPI finie `dpi_finite` (1634), la positivité `condMI_nonneg` (2110) et la majoration `entN2_le_log_card`. La règle de chaîne `chain_rule` (2071) est un calcul terme à terme. Avec `miN_kernel_only_on_s`, elle donne `fondement_extraction` (2200), c'est-à-dire la Proposition 2.1. La DPI pour la variation totale `tv_pushforward_le` (1691) donne les règles de composition `conf_post` (1906) et `composition_parallele` (2008). Ce sont des preuves de longueur moyenne, sans difficulté comparable à Fano et Pinsker.

**Extension 3.6 (section 14).** Le noyau quantique réutilise sans changement `product_bound_explicit` (1202), `product_bound_refined` (1240) et `factor_lt_one_iff` (459) : la preuve du Théorème 2.5 est celle du cas classique, une fois Fano quantique et Holevo enchaînés en `fano_I`. Le Lemme 2.8 suit de Pinsker quantique et de l'Hypothèse 2.7. L'encadrement de η_q (`etaQ_bounds`) réutilise la DPI et le goulot contextuel de la section 12.

**Extension 3.7 (section 16).** La Proposition 2.2 garde la divergence binaire au lieu de majorer h(p) par 1. `I_nats` écrit I(M;Σ|C) comme une divergence entre la loi jointe de (C, M, Σ) et la loi produit `bProd`. `log_sum_two_blocks` réduit cette divergence aux deux issues « décodage réussi » et « décodage manqué » sur tout l'espace d'un coup, ce qui évite l'inégalité de Jensen. `fano_sharp_model` en tire I·ln 2 ≥ pλ ln 2 + p ln p − p, puis `rel_aigu_of_info` coupe à 2^(−λ/2). Le témoin `witModel` calcule exactement H(C) = γ + 1, H(V|C) = γ, I(V;Σ|C) = Δ et I(M;Σ|C) = 0.

**Extension 3.8 (section 18).** Le pont IND-CONF est la majoration terme à terme (P₀ − P₁)·a ≤ max(P₀ − P₁, 0), avec égalité pour le test de Neyman-Pearson. Le pont BIND-REL est de l'algèbre sur la définition (2.4) de Relver. La Remarque 2.2 vient de ce que Conf = 1 annule toutes les variations totales, donc la loi de Σ ne dépend pas de M. Le Lemme A.1 reprend la log-somme sur les deux blocs « estimation juste » et « estimation fausse », comme `fano_finite`. `IV_eq_HV_sub` décompose l'information mutuelle en entropie moins entropie résiduelle, ce qui fait d'Opp = 1 − H(V\|Σ,C)/H(V\|C) et ramène le pont EXT-OPP au Lemme A.1. Preuves de longueur moyenne, la plus longue étant Fano (environ 110 lignes).

**Extension 3.9 (section 20).** `eigenvalues_diag` (3882) identifie le multiensemble du spectre d'un état diagonal à celui de ses coefficients, par le polynôme caractéristique. `sum_eigenvalues_diag` (3896) en tire toute somme spectrale, donc la norme de trace (`traceNorm_diag_sub`, 3916) et l'entropie de von Neumann. La distance de trace devient la variation totale par |x| = 2 max(x, 0) − x. Courtes.

**Extension 3.10 (section 22).** `miN_le_ent_of_factor` (4097) construit le noyau inverse de T = h(Σ) vers Σ et applique `dpi_finite`, puis `miN_le_entN1`. `sotp_opp_le` (4165) l'applique contexte par contexte. Longueur moyenne.

**Ce qui porte la difficulté.** Mathématiquement, la difficulté est dans Fano et Pinsker sur lois finies. Le trilemme lui-même est court une fois ces deux inégalités acquises. Son contenu tient aux hypothèses institutionnelles, qui font apparaître Δ, γ = αH(C) − 1 et κ.

## Limites dites franchement

1. **Validité relative aux définitions.** La compilation prouve que les énoncés découlent des définitions. Elle ne prouve pas que ces définitions traduisent fidèlement le manuscrit. `Coherence.lean` écarte le risque d'une définition vide ou triviale. Il ne remplace pas une relecture par les pairs.
2. **Couche concrète sur lois finies.** Les théorèmes concrets portent sur des lois finies, avec M uniforme sur 2^λ valeurs et indépendant de C. Le verdict y suit un noyau qui ne dépend que de (Σ, C). La forme asymptotique garde fixes les ensembles des contextes et des verdicts. Les lois continues et les lois quelconques ne sont pas couvertes.
3. **Divergence hors supports communs.** Avec les conventions de Lean (log 0 = 0, x/0 = 0), `klN` sous-estime la vraie divergence quand les supports diffèrent. Elle n'est donc employée que sous `CommonSupport`.
4. **Hypothèses institutionnelles posées.** Les Hypothèses 2.1, 2.2 et 2.4 sont des prémisses, non des théorèmes. C'est leur statut dans la thèse. Leur fondement informationnel (Proposition 2.1, p. 55) est formalisé depuis la version 3.5 (`fondement_extraction`). Il montre que I(V;Σ|M,C) ≤ Δ entraîne l'Hypothèse 2.1, sans la démontrer pour une institution réelle.
5. **Prémisses muettes.** La condition `hcard` (|V| ≤ 2^(αH(C))) figure dans les théorèmes concrets sans servir aux preuves. Le décodeur `D` de `lemma4_concrete` ne sert qu'à construire l'instance. L'Hypothèse 2.3 est portée par `InstitutionalAssumptions` sans servir aux trilemmes. Ces prémisses ne rendent pas les énoncés faux. Elles les rendent un peu plus forts en apparence qu'en réalité.
6. **Témoin de cohérence abstrait.** `assumptions_consistent_and_bound_attained` est un point du modèle relâché (Rel = 1/λ avec I = 0). Une vraie loi donnerait Rel = 2^(−λ) (`fam_Rel`, ligne 156 de `Coherence.lean`). La famille `famModel` a Δ = γ = 1, si bien que le facteur institutionnel n'y est pas actif.
7. **Compilation locale à imports ciblés.** Voir la réserve plus haut. La version 3.4 avec `import Mathlib` a été compilée par le workflow GitHub le 26 novembre 2026. La version 3.5 l'a été le 27 novembre 2026 (exécution 45995428572) la version 3.6 aussi (exécution 45998003187) la version 3.7 de même (exécution 46001043885) la version 3.8 aussi (exécution 46004107163) et la version 3.9 de même (exécution 46009728045). La version 3.9 a aussi été vérifiée sur live.lean-lang.org le 27 novembre 2026. La version 3.10 a été compilée par GitHub (exécution 46013544278). La version 3.11 aussi (exécution 46020036841). La version 3.12 aussi (exécution 46058753895). La version 3.13 aussi (exécution 46059764129). Lean 4.35.0 y affiche un avertissement qui propose le mot-clé `module`, sans effet sur les preuves. Un essai sur live.lean-lang.org reste conseillé avant toute présentation.
8. **Énoncés écrits par copie.** Les énoncés de `Enonces.lean` ont été écrits à partir des théorèmes existants. La compilation garantit leur égalité avec les preuves. Leur fidélité au texte du manuscrit reste à juger par le lecteur, à l'aide du tableau ci-dessus.

## Reproductibilité

| Élément | Valeur |
|---|---|
| Lean | v4.35.0 ([`lean-toolchain`](lean-toolchain)) |
| Mathlib | v4.35.0, commit `56a005855ea17e0b0958f73ec801ae140b0a1679` ([`lake-manifest.json`](lake-manifest.json)) |
| Bibliothèques Lake | `ConditionalCRO` (cible par défaut) et `Verification` (fichiers `Verification/*.lean`) |
| SHA-256 de `ConditionalCRO.lean` | `41334290f3e98c26d0f8e0641c660cd5b9c8a1f5034117e2ddf91b277fd3e45f` (version 3.13) |
