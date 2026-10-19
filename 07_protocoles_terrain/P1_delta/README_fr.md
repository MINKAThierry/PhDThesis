# P1_delta — Mesure de la capacité d'extraction institutionnelle $\Delta$

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.1 (et §4.2.4 pour les seuils de validation)

[English version](README_en.md) · [Retour aux protocoles de terrain](../README_fr.md)

Ce dossier rassemble le protocole P1 et tous les instruments nécessaires à sa conduite. Aucune donnée n'a été recueillie. Les éléments qui ne figurent pas dans la thèse sont signalés par la mention **[à arrêter par l'équipe]**.

## Contenu

| Document | Rôle | Phase |
|---|---|---|
| [protocole_fr.md](protocole_fr.md) | Objectif, estimateur $\hat\Delta = \hat I(V;\Sigma\mid M,C)$, design, rotation, phases, prédictions | toutes |
| [guide_enqueteur_fr.md](guide_enqueteur_fr.md) | Préparation et conduite des séances, consignes à lire, incidents | 0 à 4 |
| [support_formation_phase0_fr.md](support_formation_phase0_fr.md) | Canevas neutre de la formation de 2 h | 0 |
| [questionnaire_extraction_verdict_fr.md](questionnaire_extraction_verdict_fr.md) | Questionnaire de 30 items par contexte (Q01 à Q30), règles de saisie | 1 et 2 |
| [stimuli/gabarit_fiche_stimulus_fr.md](stimuli/gabarit_fiche_stimulus_fr.md) | Gabarit d'une paire contexte–preuve, règles de construction, espaces de verdicts A, B, C | préparation |
| [stimuli/catalogue_stimuli_fr.md](stimuli/catalogue_stimuli_fr.md) | Liste des 50 paires, dont 2 rédigées en entier | préparation |
| [stimuli/generer_exemples.py](stimuli/generer_exemples.py) et [exemples_stimuli.json](stimuli/exemples_stimuli.json) | Valeurs cryptographiques reproductibles des 2 paires rédigées (ECDSA P-256, bulletin de type Helios) | préparation |
| [fiche_test_retest_fr.md](fiche_test_retest_fr.md) | Choix des 3 contextes re-présentés à J+14, indicateurs ICC et $\kappa$ | 2 |
| [grille_gold_standard_fr.md](grille_gold_standard_fr.md) | Feuille de réponse des experts, calcul de l'accord (seuil 90 %) | 3 |
| [fiche_debriefing_fr.md](fiche_debriefing_fr.md) | Texte de restitution, relevé, questionnaire anonyme de retour | 4 |
| [gabarit_donnees_fr.csv](gabarit_donnees_fr.csv) | En-tête du jeu de données D4, une ligne par participant et par contexte | saisie |

Les pièces communes à tous les protocoles (consentement, profil, journal de séance, fiche d'écart, pré-enregistrement, plan d'analyse, dictionnaire des variables) sont dans [00_commun](../00_commun/README_fr.md).

## Chaîne de traitement

1. Les stimuli sont rédigés selon le gabarit, puis vérifiés par le gold standard (phase 3), avant toute séance.
2. Les réponses sont saisies dans `gabarit_donnees_fr.csv` ou `gabarit_donnees_en.csv`. Les noms de colonnes suivent le jeu D4 du [dictionnaire des variables](../00_commun/dictionnaire_variables_fr.md).
3. Le paquet d'analyse [cro_terrain](../analyse/README_fr.md) lit ce gabarit (schéma `p1_answers`). Le module `cro_terrain.p1` calcule `echecs_attention` et `exclu`, construit le vecteur de verdict et donne les listes de rotation. L'estimateur $\hat\Delta$ est `cro_terrain.delta_hat`.

```python
from cro_terrain.templates import read_template
from cro_terrain import p1, delta_hat

d = p1.add_computed_columns(read_template("gabarit_donnees_fr.csv", "p1_answers"))
keep = d["excluded"] == 0
est = delta_hat(d["verdict_v"][keep], d["sigma_id"][keep], d["message_id"][keep],
                d["stimulus_id"][keep], method="mm")
```

## Ce que ce dossier ne contient pas

- Les 48 paires contexte–preuve qui restent à rédiger, avec leurs 192 variantes.
- Les résultats d'un pré-test du questionnaire.
- Les diapositives de la formation, dont seul le canevas est fourni.
- Toute donnée de terrain.

## Licence

CC BY 4.0 pour les documents, MIT pour le script `stimuli/generer_exemples.py`.
