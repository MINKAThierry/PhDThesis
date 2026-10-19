# P3_opp_helios — Mesure de l'opposabilité sur Helios (ENSP)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.3

[English version](README_en.md) · [Retour aux protocoles de terrain](../README_fr.md)

Ce dossier rassemble le protocole P3 et ses instruments. P3 mesure $\mathsf{Opp}_{\text{emp}} = I_{\text{emp}}(V;\Sigma\mid C)/H_{\text{emp}}(V\mid C)$ sur les preuves d'un scrutin Helios réel et la compare à la valeur prédite de 0,50. Aucune donnée n'a été recueillie. Les éléments qui ne figurent pas dans la thèse sont signalés par la mention **[à arrêter par l'équipe]**.

## Contenu

| Document | Rôle | Moment |
|---|---|---|
| [protocole_fr.md](protocole_fr.md) | Objectif, grandeur mesurée, critère de validation, design, procédure, analyse | toutes |
| [modele_convention_scrutin_fr.md](modele_convention_scrutin_fr.md) | Convention avec l'instance électorale, séparation des rôles, données, anomalie réelle | avant l'élection |
| [support_formation_trustees_fr.md](support_formation_trustees_fr.md) | Formation de 4 h, règles de neutralité, exercices et corrigé | phase 1 |
| [formation/generer_bulletins_exercice.py](formation/generer_bulletins_exercice.py) et [bulletins_exercice.json](formation/bulletins_exercice.json) | Six bulletins d'exercice reproductibles (format pédagogique, non Helios) | phase 1 |
| [tirage_echantillon_fr.md](tirage_echantillon_fr.md) | Règle de tirage par SHA-256, exemple vérifiable, procès-verbal de tirage | après la proclamation |
| [preuves_temoins_fr.md](preuves_temoins_fr.md) | Ajout proposé de 10 preuves témoins, types d'altération, registre | après le tirage |
| [fiche_audit_preuve_fr.md](fiche_audit_preuve_fr.md) | Fiche remplie par chaque trustee pour chaque preuve | phase 3 |
| [proces_verbal_audit_fr.md](proces_verbal_audit_fr.md) | Procès-verbal de la session d'audit | phase 3 |
| [gabarit_audit_preuves_fr.csv](gabarit_audit_preuves_fr.csv) | Saisie, une ligne par trustee et par preuve | saisie |

Les pièces communes (consentement, engagement de confidentialité, journal de séance, fiche d'écart, pré-enregistrement, plan d'analyse) sont dans [00_commun](../00_commun/README_fr.md).

## Analyse

Le paquet [cro_terrain](../analyse/README_fr.md) contient déjà tout le nécessaire. Il lit le gabarit (schéma `p3_audit`), tire l'échantillon (`sampling.draw_sample`), calcule $\mathsf{Opp}_{\text{emp}}$ (`information.opp_emp`, `information.opp_emp_shuffle`), produit les intervalles bootstrap (`statistics.cluster_bootstrap`) et applique le critère (`refutation.criterion_opp_helios`). La section P3 de l'[exemple d'analyse](../analyse/exemple_analyse.py) déroule la chaîne sur des données simulées.

La colonne `statut_reference` reçoit `authentique` ou `temoin`.

## Point principal à trancher

Dans un scrutin régulier, toutes les preuves tirées sont valides. Si tous les trustees les déclarent valides, $H_{\text{emp}}(V\mid C) = 0$ et $\mathsf{Opp}_{\text{emp}}$ n'est pas défini. Les preuves témoins évitent ce cas. Elles ne figurent pas dans la thèse. Leur adoption doit être arrêtée avant le dépôt du pré-enregistrement.

## Ce que ce dossier ne contient pas

- Un vérificateur au format Helios. L'audit utilise l'outil de l'instance déployée.
- Les diapositives de la formation, dont seul le canevas est fourni.
- Toute donnée de terrain.

## Licence

CC BY 4.0 pour les documents, MIT pour le script de la formation.
