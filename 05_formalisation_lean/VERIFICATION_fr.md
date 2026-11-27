# Dossier de vérification de la formalisation Lean

[English version](VERIFICATION_en.md)

Ce dossier permet de juger ce que la formalisation prouve sans lire les 2 790 lignes de `ConditionalCRO.lean`. Il suit le modèle du dépôt de la preuve Lean de l'hypothèse de Riemann (novembre 2026). Les énoncés y sont isolés des preuves, un point d'entrée mince les relie aux théorèmes et un script audite les axiomes. Les limites y sont dites franchement.

Le dossier est **additif**. Les versions 3.5 et 3.6 de `ConditionalCRO.lean` (27 novembre 2026) prolongent la 3.4 par ajout des sections 12 à 15 en fin de fichier. Ses lignes 5 à 1575 restent identiques au listing B.1 de l'annexe B de la thèse, aux quatre lignes d'auteurs de l'en-tête près. Seule la ligne 4, qui porte le numéro de version, a changé. Les numéros de ligne cités pour la version 3.4 restent donc valables. Les fichiers de vérification importent `ConditionalCRO`.

## Ce qu'il faut lire et dans quel ordre

| Ordre | Fichier | Rôle |
|---|---|---|
| 1 | ce document | Carte, traçabilité et limites |
| 2 | [`Verification/Enonces.lean`](Verification/Enonces.lean) | Les 64 énoncés de la thèse, sans aucune preuve, chacun avec son renvoi au manuscrit v36 |
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

Cette dernière étape emploie deux outils fournis avec la chaîne Lean 4.35.0. `leanchecker` rejoue les déclarations dans le noyau de Lean. `nanoda_bin` est un second vérificateur, écrit en Rust, qui relit un export produit par `leanexport`. L'export porte sur les théorèmes de `Principal.lean` (29 en version 3.4, 47 en version 3.5, 64 en version 3.6) et sur toutes leurs dépendances, Mathlib comprise. Seuls les trois axiomes standard y sont admis.

Le workflow [`../.github/workflows/verification_lean.yml`](../.github/workflows/verification_lean.yml) exécute ce script sur GitHub à chaque modification du dossier. Il complète le job `lean` de `ci.yml` sans le remplacer.

## Ce qui a été compilé et ce qui ne l'a pas été

| Contrôle | Où | Résultat |
|---|---|---|
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

Les numéros et les pages sont ceux du manuscrit v36 (`index_labels_v36.tsv`), identiques à ceux de la v35 pour les énoncés de la version 3.4. « Fichier » désigne la ligne de `ConditionalCRO.lean` ; la ligne du listing B.1 vaut quatre de moins. `E` et `P` désignent les lignes de `Enonces.lean` et de `Principal.lean`. Les 64 théorèmes affichent tous `[propext, Classical.choice, Quot.sound]`. Les lignes à partir de 1634 sont celles des sections 12 (version 3.5) et 14 (version 3.6), absentes du listing B.1.

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

(a) Dans le modèle abstrait, Fano (I ≥ Rel·λ − 1) et Pinsker (TV² ≤ c₀·KL) sont des champs de `ProtocolInstance`. La couche concrète les démontre (lignes 1077 et 1128).
(b) Point du modèle abstrait, non réalisable par une loi (Remarque 3.10, p. 114).
(e) Noyau quantique (section 14). Comme Fano et Pinsker dans le modèle abstrait classique, Fano quantique (Lemme 2.6), la borne de Holevo (Lemme 2.7) et Pinsker quantique (Lemme 2.4) sont des champs de `QuantumProtocolInstance`. Ils ne sont pas démontrés dans ce dossier (lot L5c de la feuille de route).
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
| Conf ≥ 1 − √(c₀βκ/λ), dernière phrase du Théorème 2.4 | `thm:trilemme_cro_conditionnel` | Théorème 2.4, p. 58 | non énoncé tel quel en Lean ; il découle du Lemme 2.3 et de l'Hypothèse 2.4 par monotonie de la racine |
| Borne aiguë sur la fiabilité | `prop:borne_aigue` | Proposition 2.2, p. 62 | démontré sur papier, non formalisé |
| Témoin réalisable du facteur institutionnel | `rem:temoin_realisable` | Remarque 2.20, p. 63 | démontré sur papier, non formalisé |
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
| `deltaQ`, `etaQ` | Δ_q = 35 − 7 = 28 bits (ML-DSA-65) ; η_q = 0 pour le canal identité | — | 416 à 424 |

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

**Ce qui porte la difficulté.** Mathématiquement, la difficulté est dans Fano et Pinsker sur lois finies. Le trilemme lui-même est court une fois ces deux inégalités acquises. Son contenu tient aux hypothèses institutionnelles, qui font apparaître Δ, γ = αH(C) − 1 et κ.

## Limites dites franchement

1. **Validité relative aux définitions.** La compilation prouve que les énoncés découlent des définitions. Elle ne prouve pas que ces définitions traduisent fidèlement le manuscrit. `Coherence.lean` écarte le risque d'une définition vide ou triviale. Il ne remplace pas une relecture par les pairs.
2. **Couche concrète sur lois finies.** Les théorèmes concrets portent sur des lois finies, avec M uniforme sur 2^λ valeurs et indépendant de C. Le verdict y suit un noyau qui ne dépend que de (Σ, C). La forme asymptotique garde fixes les ensembles des contextes et des verdicts. Les lois continues et les lois quelconques ne sont pas couvertes.
3. **Divergence hors supports communs.** Avec les conventions de Lean (log 0 = 0, x/0 = 0), `klN` sous-estime la vraie divergence quand les supports diffèrent. Elle n'est donc employée que sous `CommonSupport`.
4. **Hypothèses institutionnelles posées.** Les Hypothèses 2.1, 2.2 et 2.4 sont des prémisses, non des théorèmes. C'est leur statut dans la thèse. Leur fondement informationnel (Proposition 2.1, p. 55) est formalisé depuis la version 3.5 (`fondement_extraction`). Il montre que I(V;Σ|M,C) ≤ Δ entraîne l'Hypothèse 2.1, sans la démontrer pour une institution réelle.
5. **Prémisses muettes.** La condition `hcard` (|V| ≤ 2^(αH(C))) figure dans les théorèmes concrets sans servir aux preuves. Le décodeur `D` de `lemma4_concrete` ne sert qu'à construire l'instance. L'Hypothèse 2.3 est portée par `InstitutionalAssumptions` sans servir aux trilemmes. Ces prémisses ne rendent pas les énoncés faux. Elles les rendent un peu plus forts en apparence qu'en réalité.
6. **Témoin de cohérence abstrait.** `assumptions_consistent_and_bound_attained` est un point du modèle relâché (Rel = 1/λ avec I = 0). Une vraie loi donnerait Rel = 2^(−λ) (`fam_Rel`, ligne 156 de `Coherence.lean`). La famille `famModel` a Δ = γ = 1, si bien que le facteur institutionnel n'y est pas actif.
7. **Compilation locale à imports ciblés.** Voir la réserve plus haut. La version 3.4 avec `import Mathlib` a été compilée par le workflow GitHub le 26 novembre 2026. La version 3.5 l'a été le 27 novembre 2026 (exécution 45995428572) et la version 3.6 aussi (exécution 45998003187). Lean 4.35.0 y affiche un avertissement qui propose le mot-clé `module`, sans effet sur les preuves. Un essai sur live.lean-lang.org reste conseillé avant toute présentation.
8. **Énoncés écrits par copie.** Les énoncés de `Enonces.lean` ont été écrits à partir des théorèmes existants. La compilation garantit leur égalité avec les preuves. Leur fidélité au texte du manuscrit reste à juger par le lecteur, à l'aide du tableau ci-dessus.

## Reproductibilité

| Élément | Valeur |
|---|---|
| Lean | v4.35.0 ([`lean-toolchain`](lean-toolchain)) |
| Mathlib | v4.35.0, commit `56a005855ea17e0b0958f73ec801ae140b0a1679` ([`lake-manifest.json`](lake-manifest.json)) |
| Bibliothèques Lake | `ConditionalCRO` (cible par défaut) et `Verification` (fichiers `Verification/*.lean`) |
| SHA-256 de `ConditionalCRO.lean` | `ed64c7a451f9c52a4ff36f4dbcb263441ac6b5d5955687b66f7ad484ee813288` (version 3.6) |
