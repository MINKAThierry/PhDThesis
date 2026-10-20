# Plan de gestion des données

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.1, §4.2.2, §4.2.4 et §4.2.8.3

[English version](plan_gestion_donnees_en.md)

Ce plan couvre P1 et P2. Il s'applique aux autres protocoles moyennant l'ajout de leurs variables au [dictionnaire des variables](dictionnaire_variables_fr.md). Les durées et outils marqués [à arrêter par l'équipe] sont des propositions.

## 1. Données produites

| Catégorie | Contenu | Format | Identifiant | Volume estimé |
|---|---|---|---|---|
| D1 Correspondance | Table code–identité, moyens de contact | fichier chiffré | nominatif | 140 lignes environ |
| D2 Consentements | Formulaires signés | papier, puis numérisation chiffrée | nominatif | 140 formulaires environ |
| D3 Profil | Réponses au [questionnaire de profil](questionnaire_profil_participant_fr.md) | CSV | pseudonymisé | 140 lignes |
| D4 Réponses P1 | Verdicts, confiance, temps (gabarit [../P1_delta/gabarit_donnees_fr.csv](../P1_delta/gabarit_donnees_fr.csv)) | CSV | pseudonymisé | 120 × 10 contextes en phase 1, 120 × 3 en phase 2 |
| D5 Gold standard | Verdicts des experts `GS-A`, `GS-B`, `GS-ARB` | CSV | pseudonymisé | 50 stimuli |
| D6 Réponses P2 | Décomposition, jugements de dissimilarité, tours Delphi (gabarits du dossier [../P2_entropie_contexte/](../P2_entropie_contexte/README_fr.md)) | CSV | pseudonymisé | 20 experts |
| D7 Stimuli | Fiches de stimulus, catalogue, vérité terrain $m$ | Markdown, PDF, CSV | sans donnée personnelle | 50 paires |
| D8 Métadonnées de collecte | Journaux de séance, fiches d'écart | PDF, CSV | pseudonymisé | selon déroulement |
| D9 Résultats | Estimations, intervalles, code d'analyse | CSV, Python | anonyme | faible |

## 2. Collecte et saisie

- Saisie sur papier ou sur formulaire électronique hors ligne. Aucun service en nuage étranger n'est utilisé pour les données D1 à D6 **[à arrêter par l'équipe]**.
- Double saisie indépendante des questionnaires papier par deux opérateurs, puis comparaison automatique. Les divergences sont résolues sur pièce et consignées.
- Contrôle de cohérence à la saisie (codes valides, valeurs dans les plages du dictionnaire, champs obligatoires).

## 3. Pseudonymisation

- Le code participant est attribué au moment du consentement (format dans [fiche_recrutement_stratification_fr.md](fiche_recrutement_stratification_fr.md)).
- La table D1 est l'unique lien entre code et identité. Elle est chiffrée et conservée sur un support distinct des données D3 à D8, sous la seule responsabilité de l'investigateur principal.
- Le nom de l'institution n'apparaît pas dans D3 à D6. Seul le code `INST-__` y figure. La table des codes d'institutions est traitée comme D1.
- Les variables de profil sont recueillies en classes.

## 4. Stockage et sécurité

| Élément | Mesure proposée **[à arrêter par l'équipe]** |
|---|---|
| Support principal | Serveur ou poste du LIMSI dédié, disque chiffré (chiffrement intégral du volume), accès par compte nominatif |
| Sauvegardes | Deux copies chiffrées sur supports distincts, dont une hors du bâtiment, sauvegarde hebdomadaire pendant la collecte |
| Papier | Armoire fermée à clé au LIMSI. Consentements et questionnaires dans des armoires distinctes |
| Accès | D1 et D2 réservés à l'investigateur principal. D3 à D8 ouverts à l'équipe signataire de l'[engagement de confidentialité](engagement_confidentialite_fr.md) |
| Transfert | Supports chiffrés uniquement. Pas de transfert par messagerie non chiffrée |
| Journalisation | Registre des accès et des exports tenu par l'investigateur principal |

## 5. Durées de conservation

| Données | Durée proposée **[à arrêter par l'équipe]** | Sort final |
|---|---|---|
| D1 table de correspondance | Jusqu'à la date d'anonymisation, soit ____ mois après la dernière séance du participant | Destruction sécurisée, procès-verbal |
| D2 consentements | ____ ans après la fin de l'étude | Destruction sécurisée |
| D3 à D8 pseudonymisées | Jusqu'à la date d'anonymisation | Deviennent anonymes par destruction de D1 |
| Données anonymisées et D9 | Sans limite | Archivage ouvert |

## 6. Anonymisation et partage

1. Destruction de D1 à la date d'anonymisation.
2. Contrôle du risque de réidentification sur la combinaison des quasi-identifiants (strate, ancienneté, fonction de supervision, classe d'âge, sexe, code institution). Le seuil proposé veut que chaque combinaison publiée concerne au moins 5 personnes, faute de quoi les classes sont regroupées ou la variable supprimée **[à arrêter par l'équipe]**.
3. Suppression des codes `INST-__` et des champs de commentaire libre avant diffusion.
4. Dépôt des données anonymisées, du dictionnaire des variables et des stimuli sur un entrepôt ouvert (OSF ou Zenodo **[à arrêter par l'équipe]**) sous licence **CC BY 4.0**, avec un identifiant pérenne.
5. Le code d'analyse est déposé sous licence MIT dans le dossier `analyse/` du dépôt https://github.com/MINKAThierry/PhDThesis.

Les stimuli et la vérité terrain $m$ ne sont publiés qu'après la clôture de toute collecte utilisant le même jeu de stimuli.

## 7. Cadre juridique

Traitement conforme au cadre camerounais de protection des données à caractère personnel (loi n° 2024/017 du 23 décembre 2024 **[référence à vérifier par l'équipe]**), à la loi n° 2010/012 du 21 décembre 2010 relative à la cybersécurité et à la cybercriminalité et à l'avis du comité d'éthique. Le responsable de traitement est l'Université de Yaoundé I (LIMSI, ENSP), représentée par ____________________.

## 8. Responsabilités

| Rôle | Code ou fonction | Responsabilités |
|---|---|---|
| Investigateur principal | ____________________ | Tenue de D1 et D2, autorisation des accès, anonymisation, dépôt |
| Coordinateur de terrain | ____________________ | Suivi des quotas, collecte des journaux, transmission des questionnaires |
| Opérateurs de saisie | ____________________ | Double saisie, contrôle de cohérence |
| Analyste | ____________________ | Application du [plan d'analyse statistique](plan_analyse_statistique_fr.md) sur données pseudonymisées |

Date de la version : ___ / ___ / ______ Version : ____
