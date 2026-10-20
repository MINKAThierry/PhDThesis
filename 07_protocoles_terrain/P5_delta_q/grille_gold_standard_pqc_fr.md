# Grille du gold standard PQC (P5, phase 4)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.5.3, phase 4 (« experts en cryptographie post-quantique établissent les verdicts corrects »)

[English version](grille_gold_standard_pqc_en.md) · [Protocole P5](protocole_fr.md) · [Grille de P1](../P1_delta/grille_gold_standard_fr.md)

La procédure est celle de la [grille de P1](../P1_delta/grille_gold_standard_fr.md). Deux experts indépendants `GS-A` et `GS-B` répondent seuls, un arbitre `GS-ARB` tranche les désaccords et l'accord requis est d'au moins 90 %, le tout avant la collecte. Elle diffère sur deux points.

1. **Profil.** Les experts sont des spécialistes de la cryptographie post-quantique, indépendants des strates AEX et RQS **[à arrêter par l'équipe]**.
2. **Verdict de référence par condition.** En phase 2, le verdict de référence peut dépendre du résultat affiché par le vérificateur simulé. Les experts rendent donc deux verdicts de référence pour chaque variante, l'un si le résultat affiché est « réussie », l'autre s'il est « échec ». La colonne `verdict_reference` du gabarit reçoit celui qui correspond au résultat effectivement affiché, relevé dans le journal de l'interface.

## Feuille de réponse de l'expert (une par variante)

| Champ | Valeur |
|---|---|
| Expert | ☐ `GS-A` ☐ `GS-B` ☐ `GS-ARB` |
| Stimulus, variante, message | `___-C__`, `___-C__-S_`, `___-C__-M_` |
| Vérification refaite par l'expert | ☐ acceptée ☐ rejetée |
| Verdict de référence si le résultat affiché est « réussie » | ____ (1 à 4) |
| Verdict de référence si le résultat affiché est « échec » | ____ (1 à 4) |
| La réponse diffère-t-elle entre M1 et M2 à la seule lecture du dossier ? | ☐ non ☐ oui, préciser ______ |

Justification en trois lignes au plus

______________________________________________________________________
______________________________________________________________________

## Accord

| Indicateur | Seuil |
|---|---|
| Accord sur le verdict « réussie », 48 variantes | $\geq 90\,\%$ |
| Accord sur le verdict « échec », 48 variantes | $\geq 90\,\%$ |
| $\kappa$ de Cohen | rapporté |

Une paire dont l'accord reste inférieur à 90 % après arbitrage est exclue du calcul des erreurs d'interprétation. Elle reste utilisée pour $\hat\Delta_q$, qui ne dépend pas du gold standard.

Licence CC BY 4.0.
