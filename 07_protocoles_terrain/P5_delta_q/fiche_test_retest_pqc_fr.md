# Fiche test-retest (P5, phase 3)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.5.3, phase 3 (« re-présentation de scénarios après 2 semaines », 1 h) ; §4.2.5.4 (répéter la mesure à bruit constant avant de faire varier $p$)

[English version](fiche_test_retest_pqc_en.md) · [Protocole P5](protocole_fr.md) · [Fiche test-retest de P1](../P1_delta/fiche_test_retest_fr.md)

La fiche suit celle de P1, avec trois différences.

1. **Bruit constant.** Le retest porte sur des items de la **phase 1** (condition A, sans bruit). La thèse note qu'une faible stabilité en régime bruité mêlerait l'incohérence des acteurs et l'instabilité du canal. On commence donc par mesurer la stabilité sans bruit.
2. **Sans aide puis avec aide.** Chaque item est re-présenté avec les deux écrans de la phase 1, dans le même ordre. La stabilité est calculée séparément pour `aide = 0` et pour `aide = 1`.
3. **Nombre d'items.** 4 items, 2 par schéma, avec la même variante qu'en phase 1 **[à arrêter par l'équipe]**.

## 1. Identification

| Champ | Valeur |
|---|---|
| Code participant | `P5-___-___` |
| Séance de phase 1 / de phase 3 | `S-____` du __/__/____ / `S-____` du __/__/____ |
| Délai effectif (jours) | ____ (cible 14) |
| Enquêteur | `ENQ-__` |

## 2. Items re-présentés

| Rang | Stimulus | Variante | Verdict phase 1 sans aide (rempli après la séance) | Verdict phase 1 avec aide (idem) |
|---|---|---|---|---|
| 1 | `MLD-C__` | `MLD-C__-S_` | ____ | ____ |
| 2 | `MLD-C__` | `MLD-C__-S_` | ____ | ____ |
| 3 | `SLH-C__` | `SLH-C__-S_` | ____ | ____ |
| 4 | `SLH-C__` | `SLH-C__-S_` | ____ | ____ |

Tirage au sort parmi les items de phase 1 du participant, un schéma après l'autre. Graine ou méthode : ______

## 3. Indicateurs

| Indicateur | Données | Seuil (P4) |
|---|---|---|
| ICC(2,1), accord absolu | confiance, phase 1 contre phase 3, par modalité d'aide | $\geq 0{,}8$ |
| $\kappa$ de Cohen | verdict, phase 1 contre phase 3, par modalité d'aide | $\geq 0{,}7$ |

Saisie avec `session = 3` dans le [gabarit](gabarit_sessions_pqc_fr.csv). La fonction `cro_terrain.p4.retest_pairs` s'applique en prenant `first = "1"` et `second = "3"`, après filtrage sur la colonne `aid`.

La question de clôture de la [fiche de P1](../P1_delta/fiche_test_retest_fr.md#4-question-de-clôture) est reprise à l'identique.

Licence CC BY 4.0.
