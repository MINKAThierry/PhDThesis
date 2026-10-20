# Grille du gold standard (P1, phase 3)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.1.3, phase 3 (« deux cryptographes experts indépendants rendent les verdicts corrects, accord inter-juge requis ≥ 90 % »)

[English version](grille_gold_standard_en.md) · [Protocole P1](protocole_fr.md) · [Catalogue des stimuli](stimuli/catalogue_stimuli_fr.md)

Le gold standard fournit, pour chacune des 200 variantes (50 paires × 4 variantes), le verdict de référence et les réponses de référence aux 22 items de dimension. Il sert aux analyses d'exactitude et au contrôle des stimuli. Il n'intervient pas dans le calcul de $\hat\Delta = \hat I(V;\Sigma\mid M,C)$, qui repose sur les réponses des participants et sur la vérité terrain $m$.

## 1. Experts

| Rôle | Code | Profil requis | Engagement de confidentialité signé |
|---|---|---|---|
| Expert A | `GS-A` | cryptographe, doctorat ou expérience équivalente **[à arrêter par l'équipe]** | ☐ |
| Expert B | `GS-B` | cryptographe, indépendant de l'expert A (pas de co-publication récente, pas de lien hiérarchique) | ☐ |
| Arbitre | `GS-ARB` | cryptographe ou juriste du numérique, sollicité seulement en cas de désaccord | ☐ |

Les experts ne participent ni à la rédaction des stimuli ni aux séances. Ils signent l'[engagement de confidentialité](../00_commun/engagement_confidentialite_fr.md).

## 2. Déroulement

1. Les experts reçoivent les fiches stimulus complètes (parties 1 à 5), y compris le message $m$ et les valeurs complètes de la preuve.
2. Chaque expert remplit, seul et sans échange avec l'autre, une feuille de réponse par variante (section 3). Il dispose de l'implémentation de référence pour vérifier les preuves.
3. Le coordinateur calcule l'accord sur Q01 et sur les items de dimension (section 4).
4. Les désaccords sont soumis à l'arbitre, qui statue après lecture des deux justifications. Le consensus est saisi avec le code `CONSENSUS`.
5. Une paire dont l'accord reste inférieur à 90 % après arbitrage est exclue des analyses d'exactitude (pré-enregistrement, section 8).

Le gold standard est établi avant la phase 1, sur les stimuli seuls. Les experts n'ont ainsi aucun accès aux réponses des participants **[à arrêter par l'équipe]**.

## 3. Feuille de réponse de l'expert (une par variante)

| Champ | Valeur | Variable |
|---|---|---|
| Expert | ☐ `GS-A` ☐ `GS-B` ☐ `GS-ARB` | `id_expert_gs` |
| Paire | `___-C__` | `id_stimulus` |
| Variante de preuve | `___-C__-S_` | `id_preuve_sigma` |
| Message engagé | `___-C__-M_` | `id_message_m` |
| Vérification de la preuve refaite par l'expert | ☐ acceptée ☐ rejetée | contrôle |
| Verdict de référence (Q01, 1 à 4) | ____ | `gs_verdict_v` |

Réponses de référence aux items de dimension (0 à 7, même échelle que le questionnaire)

| Q02 | Q03 | Q04 | Q05 | Q06 | Q07 | Q08 | Q10 | Q11 | Q12 | Q13 |
|---|---|---|---|---|---|---|---|---|---|---|
| __ | __ | __ | __ | __ | __ | __ | __ | __ | __ | __ |

| Q14 | Q15 | Q16 | Q17 | Q19 | Q20 | Q21 | Q22 | Q23 | Q24 | Q25 |
|---|---|---|---|---|---|---|---|---|---|---|
| __ | __ | __ | __ | __ | __ | __ | __ | __ | __ | __ |

Variables `gs_q02` à `gs_q25` (hors Q09 et Q18).

**Consigne de réponse.** L'expert répond à ce que le dossier remis au participant permet d'établir. Il ne répond pas à partir de sa connaissance du message $m$. Il indique en outre, ci-dessous, si sa réponse aurait différé avec la connaissance de $m$.

☐ Ma réponse est identique pour M1 et M2 ☐ Elle diffère sur les items suivants : ____________

Justification en trois lignes au plus

______________________________________________________________________
______________________________________________________________________
______________________________________________________________________

Date ___ / ___ / ______ Visa ______

## 4. Calcul de l'accord

| Indicateur | Définition | Seuil |
|---|---|---|
| Accord sur Q01 | part des 200 variantes où `GS-A` et `GS-B` donnent le même verdict | $\geq 90\,\%$ (thèse) |
| Accord sur les items | part des couples (variante, item) identiques, sur 200 × 22 réponses | $\geq 90\,\%$ **[seuil à confirmer pour les items]** |
| $\kappa$ de Cohen sur Q01 | rapporté à titre complémentaire | aucun seuil |

L'accord est calculé avant arbitrage. Le tableau suivant récapitule le résultat par type de preuve.

| Type | Variantes | Accords Q01 | % | Variantes arbitrées | Paires exclues |
|---|---|---|---|---|---|
| ECD | 40 | | | | |
| HEL | 40 | | | | |
| G16 | 40 | | | | |
| PSS | 40 | | | | |
| EGC | 40 | | | | |
| **Total** | **200** | | | | |

## 5. Contrôle de la règle de construction des stimuli

Le gabarit impose que les deux messages d'une paire soient compatibles avec le dossier. Si un expert déclare, pour une paire, que sa réponse diffère entre M1 et M2 **à la seule lecture du dossier**, la paire est signalée au coordinateur. Elle est alors révisée avant la collecte, ou bien déclarée par une [fiche d'écart](../00_commun/fiche_ecart_protocole_fr.md).

Licence CC BY 4.0.
