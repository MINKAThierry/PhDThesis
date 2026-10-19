# 00_commun: pièces partagées par tous les protocoles

> **Statut : PROPOSITION: protocole non déployé** · Source : thèse, chapitre 4, §4.2.1 à §4.2.8

[English version](README_en.md) · [Retour au dossier parent](../README_fr.md)

Ces documents servent à tous les protocoles P1 à P7. Ils ont été rédigés en détail pour P1 et P2 et s'adaptent aux autres protocoles. Aucun n'a été utilisé sur le terrain. Les valeurs qui ne figurent pas dans la thèse sont signalées par la mention **[à arrêter par l'équipe]**.

| N° | Document | Objet | Renvoi à la thèse |
|---|---|---|---|
| 1 | [preenregistrement_fr.md](preenregistrement_fr.md) | Modèle de pré-enregistrement OSF, hypothèses, estimateurs, critères de réfutation, règle d'arrêt | §4.2.1.4, §4.2.1.5, §4.2.7.3 |
| 2 | [dossier_comite_ethique_fr.md](dossier_comite_ethique_fr.md) | Demande d'avis au comité d'éthique de la recherche | §4.2.4, §4.2.8.3 |
| 3 | [notice_information_consentement_fr.md](notice_information_consentement_fr.md) | Notice, consentement libre et éclairé, formulaire de retrait | §4.2.4 |
| 4 | [convention_institution_partenaire_fr.md](convention_institution_partenaire_fr.md) | Convention avec une juridiction, un régulateur, un cabinet ou l'ENSP | §4.2.4, §4.2.8.3 |
| 5 | [engagement_confidentialite_fr.md](engagement_confidentialite_fr.md) | Engagement des enquêteurs et des experts du gold standard | §4.2.1.3 |
| 6 | [fiche_recrutement_stratification_fr.md](fiche_recrutement_stratification_fr.md) | Codes pseudonymisés, quotas et suivi individuel | §4.2.1.2 (tableau `tab:stratification_delta`) |
| 7 | [questionnaire_profil_participant_fr.md](questionnaire_profil_participant_fr.md) | Profil, ancienneté, formation cryptographique et PQC, sans donnée identifiante | §4.2.1.2, §4.2.5.2 |
| 8 | [journal_session_fr.md](journal_session_fr.md) | Journal de séance de l'enquêteur, temps de réponse | §4.2.1.3 |
| 9 | [fiche_ecart_protocole_fr.md](fiche_ecart_protocole_fr.md) | Déclaration d'écart au protocole | §4.2.4, §4.2.7.3 |
| 10 | [plan_gestion_donnees_fr.md](plan_gestion_donnees_fr.md) | Stockage, pseudonymisation, conservation, partage CC BY 4.0 | §4.2.8.3 |
| 10 bis | [dictionnaire_variables_fr.md](dictionnaire_variables_fr.md) et [dictionnaire_variables_fr.csv](dictionnaire_variables_fr.csv) | Dictionnaire des variables | §4.2.1.4, §4.2.2 |
| 11 | [plan_analyse_statistique_fr.md](plan_analyse_statistique_fr.md) | Estimateurs, bootstrap par participant, test d'admissibilité, ICC et kappa | §4.2.1.1, §4.2.1.4, §4.2.4 |

## Ordre d'utilisation

1. Signature des conventions (4) puis dépôt du dossier éthique (2).
2. Levée des mentions [à arrêter par l'équipe] puis dépôt du pré-enregistrement (1) avec le plan d'analyse (11) et le plan de gestion des données (10).
3. Signature des engagements de confidentialité (5).
4. Recrutement et suivi des quotas (6), consentement (3), profil (7).
5. Séances avec journal (8) et, le cas échéant, fiches d'écart (9).

## Points de vigilance relevés lors de la rédaction

- **Taille des cellules.** Avec l'effectif de la thèse, une estimation plug-in directe de $\hat I(V;\Sigma\mid M,C)$ sur le vecteur de verdict est bornée par environ $\log_2 24$ bits par paire, bien en deçà des valeurs prédites. Le plan d'analyse (section 5.3) propose deux voies à arrêter.
- **Niveau de verdict pour $\hat\alpha$.** Le rapport $\log_2|\mathcal{V}|/H(C)$ dépend de la définition retenue pour $\mathcal{V}$ (verdict global ou vecteur d'items). Le plan d'analyse (section 6) demande de fixer ce niveau avant collecte.
- **Variation de $\sigma$ à $(m,c)$ fixé.** Le catalogue de stimuli doit prévoir au moins deux variantes de preuve par couple $(m,c)$.

## Licence

CC BY 4.0.
