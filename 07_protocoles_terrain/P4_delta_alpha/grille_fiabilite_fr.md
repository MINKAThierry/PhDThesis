# Grille de fiabilité (P4, étape 6)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.4, étape 6 (« validation, ICC $\geq 0{,}8$, $\kappa \geq 0{,}7$ »)

[English version](grille_fiabilite_en.md) · [Protocole P4](protocole_fr.md) · [Plan d'analyse, section 7](../00_commun/plan_analyse_statistique_fr.md#7-fiabilité)

Grille remplie par l'analyste à partir des sorties de `cro_terrain.p4.estimation_conjointe` (étape 6). Elle documente les données utilisées, les valeurs obtenues et la décision. Une grille par institution et par niveau de verdict.

## 1. Données utilisées

| Champ | Valeur |
|---|---|
| Institution | `INST-__` |
| Niveau de verdict | ☐ global ☐ vecteur d'items |
| Session principale / session de retest | `1` / `2` (délai effectif médian ____ jours) |
| Participants ayant au moins un item en retest | ____ |
| Paires d'items (session 1, session 2) | ____ |
| Variable de l'ICC | ☐ confiance 0 à 10 ☐ score moyen des items de dimension |
| Strates pour le $\kappa$ inter-évaluateurs | ______ |
| Paires de participants avec au moins 5 stimulus communs | ____ |

Un item du retest est identifié par (participant, contexte, preuve, variante $\sigma$) et doit apparaître une seule fois par session. Un stimulus commun pour le $\kappa$ inter-évaluateurs est identifié par (contexte, preuve), quelle que soit la variante présentée.

## 2. Résultats

| Statistique | Valeur | Seuil (thèse) | Atteint |
|---|---|---|---|
| ICC(2,1) test-retest, accord absolu | ______ | $\geq 0{,}8$ | ☐ oui ☐ non ☐ non calculable |
| $\kappa$ de Cohen inter-évaluateurs, moyenne des paires | ______ | $\geq 0{,}7$ | ☐ oui ☐ non ☐ non calculable |
| $\kappa$ de Cohen test-retest sur le verdict | ______ | rapporté | |
| $\kappa$ de Fleiss inter-évaluateurs (complément) | ______ | rapporté | |

## 3. Lecture par strate (descriptif)

| Strate | ICC | $\kappa$ inter | $\kappa$ retest | Remarque |
|---|---|---|---|---|
| | | | | |
| | | | | |
| | | | | |

## 4. Décision

☐ **Fiabilité satisfaisante.** Les deux seuils sont atteints. $\hat\Delta$ et $\hat\alpha$ peuvent servir à appliquer les critères de réfutation.
☐ **Fiabilité insuffisante.** Au moins un seuil n'est pas atteint. Les estimations sont rapportées avec cette mention et ne servent pas à appliquer les critères de réfutation.
☐ **Fiabilité non calculable.** Absence de retest ou de stimulus commun. Même conséquence que la fiabilité insuffisante. La cause est indiquée ci-dessous.

Cause ou commentaire ______________________________________________

## 5. Pistes d'interprétation à consigner

Ne pas corriger les données. Consigner seulement les éléments utiles à la lecture.

☐ Délai de retest hors tolérance pour certains participants (fiches d'écart `ECART-____`)
☐ Participants ayant reconnu les dossiers au retest (question de clôture de la fiche test-retest de P1)
☐ Stimulus jugés ambigus au débriefing
☐ Autre : ______________________

Analyste ______ le ___ / ___ / ______. Relu par ______.

Licence CC BY 4.0.
