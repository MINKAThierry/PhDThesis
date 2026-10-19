# Modèle de demande d'avis au comité d'éthique de la recherche

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.4 (prérequis éthique) et §4.2.8.3

[English version](dossier_comite_ethique_en.md)

La thèse pose l'approbation d'un comité d'éthique de la recherche comme prérequis obligatoire de toute collecte (algorithme `alg:estimation_conjointe`, §4.2.4) et comme l'un des trois préalables non techniques au déploiement (§4.2.8.3). Ce modèle est rédigé pour P1 et P2. Il s'adapte aux autres protocoles en remplaçant les sections 3 à 5.

Comité saisi : ____________________________________________ **[à arrêter par l'équipe]** (comité institutionnel compétent pour la recherche en sciences de l'ingénieur et en sciences sociales à l'Université de Yaoundé I, ou à défaut comité national désigné)

## 1. Identification

- Titre du projet : Mesure des paramètres institutionnels de la cryptographie institutionnelle ($\Delta$, $H(\mathcal{C})$) auprès de juges, de régulateurs et d'auditeurs
- Investigateur principal : ____________________ Fonction : ____________________
- Directeurs de recherche : ____________________________________________
- Laboratoire et établissement : LIMSI, École Nationale Supérieure Polytechnique, Université de Yaoundé I
- Adresse de correspondance : ____________________________________________
- Téléphone : ____________________ Courriel : ____________________
- Durée prévue de l'étude : P1 6 mois, P2 3 mois (thèse, tableau `tab:programme_experimental`)
- Financement : ____________________ Montant : ____________ FCFA (ordre de grandeur de la thèse : 15 000 000 FCFA pour P1 et 5 000 000 FCFA pour P2)
- Conflits d'intérêts déclarés : ☐ aucun ☐ oui, préciser : ____________________

## 2. Justification et objectifs

Les bornes du trilemme CRO conditionnel établies dans la thèse dépendent de paramètres institutionnels qui n'ont jamais été mesurés auprès d'acteurs réels. L'étude vise à les estimer.

- Objectif principal de P1 : estimer la capacité d'extraction institutionnelle $\Delta$ (en bits) par l'estimateur $\hat\Delta = \hat I(V;\Sigma\mid M,C)$ auprès de six sous-groupes de professionnels (thèse, §4.2.1).
- Objectif principal de P2 : estimer l'entropie contextuelle $H(\mathcal{C})$ de trois domaines institutionnels (contentieux électoral, conformité financière, signature contractuelle) par décomposition structurelle, MDS et Delphi (thèse, §4.2.2).
- Objectifs secondaires : fiabilité test-retest, accord inter-évaluateurs, test de l'admissibilité de l'interprétation.

L'étude ne porte ni sur la santé ni sur des données sensibles au sens de la législation sur les données personnelles. Elle porte sur des jugements professionnels rendus sur des cas fictifs.

## 3. Population et recrutement

| Protocole | Population | Effectif (thèse) | Critères d'inclusion | Critères de non-inclusion |
|---|---|---|---|---|
| P1 | Juges (juridictions civiles, juges spécialisés), régulateurs financiers (juniors et seniors), auditeurs (juridiction financière et cabinets privés) | 120, soit 6 strates de 20 | Exercice actuel dans la catégorie, accord de l'institution, consentement écrit | Participation à la conception des stimuli, lien hiérarchique direct avec l'enquêteur |
| P2 | Experts en droit, en régulation, en audit ou en cryptographie appliquée | 20 (Delphi), 5 à 10 (MDS) | Au moins ____ ans d'expérience **[à arrêter par l'équipe]** | Participation à P1 dans la même vague **[à arrêter par l'équipe]** |

Recrutement par l'intermédiaire des institutions signataires d'une convention ([convention_institution_partenaire_fr.md](convention_institution_partenaire_fr.md)). L'institution diffuse l'invitation sans désigner nommément les participants. La participation n'est ni imposée ni connue de la hiérarchie au-delà du point de contact. Aucun participant n'est mineur.

## 4. Déroulement

P1 comporte cinq phases par participant (thèse, §4.2.1.3), décrites dans le tableau suivant.

| Phase | Contenu | Durée |
|---|---|---|
| 0 | Formation initiale aux notions cryptographiques de base | 2 h |
| 1 | Session principale, 10 contextes avec questionnaire de 30 items chacun | 4 h (pauses incluses) |
| 2 | Test-retest sur 3 contextes à J+14 | 1 h |
| 3 | Gold standard établi par deux cryptographes experts (sans participants) | sans objet |
| 4 | Débriefing et restitution | 30 min |

P2 comporte des questionnaires Delphi à distance (jusqu'à quatre tours) et une séance de jugement de similarité de contextes pour le panel MDS. La durée indicative est de ____ min par tour Delphi et de ____ h pour la séance MDS **[à arrêter par l'équipe]**.

Les stimuli sont des cas fictifs. Certains contiennent volontairement des anomalies (preuve invalide, certificat révoqué, décompte altéré). Les participants en sont avertis dans la notice d'information sans savoir lesquels. Le message engagé $m$ n'est pas communiqué pendant la séance. Il est révélé au débriefing. Il ne s'agit pas d'une tromperie, car aucune information fausse n'est donnée sur la nature de l'étude.

## 5. Risques, contraintes et bénéfices

| Risque | Niveau | Mesure d'atténuation |
|---|---|---|
| Atteinte à la réputation professionnelle si les performances individuelles étaient connues | Minime | Pseudonymisation dès la collecte, aucun résultat individuel transmis à l'institution, restitution agrégée par strate d'au moins ____ personnes **[à arrêter par l'équipe]** |
| Fatigue liée à la séance de 4 h | Minime | Pauses de 10 min au moins toutes les 60 min **[à arrêter par l'équipe]**, possibilité de fractionner en deux demi-journées |
| Gêne face à des notions techniques | Minime | Formation préalable de 2 h, absence de notation, rappel qu'il n'y a pas de bonne réponse attendue sur le plan personnel |
| Réidentification indirecte par la combinaison strate et institution | Faible | Variables de profil en classes, pas de nom d'institution dans les données d'analyse, seuil de diffusion par cellule |

Les bénéfices directs sont la formation de 2 h aux notions cryptographiques et la restitution collective. Le bénéfice indirect est un savoir nouveau sur la recevabilité institutionnelle des preuves cryptographiques.

Le niveau de risque global est jugé minime.

## 6. Consentement

Consentement libre et éclairé, écrit, recueilli avant la phase 0 au moyen de la [notice d'information et du formulaire de consentement](notice_information_consentement_fr.md). Un délai de réflexion d'au moins ____ jours **[à arrêter par l'équipe]** sépare la remise de la notice et la signature. Le consentement est recueilli par l'enquêteur hors de la présence d'un supérieur hiérarchique.

## 7. Droit de retrait

Le participant peut interrompre sa participation à tout moment sans justification et sans conséquence. Il peut demander la destruction de ses données jusqu'à la date d'anonymisation définitive, fixée à ____ mois après sa dernière séance **[à arrêter par l'équipe]**. Après cette date, la table de correspondance est détruite et les données ne peuvent plus lui être rattachées.

## 8. Confidentialité et gestion des données

- Pseudonymisation dès la collecte par un code de la forme `P1-JG-007` (voir [fiche_recrutement_stratification_fr.md](fiche_recrutement_stratification_fr.md)).
- Table de correspondance code–identité conservée sur un support chiffré, séparé des données, accessible au seul investigateur principal.
- Questionnaire de profil sans données identifiantes ([questionnaire_profil_participant_fr.md](questionnaire_profil_participant_fr.md)).
- Engagement de confidentialité signé par chaque enquêteur et chaque expert ([engagement_confidentialite_fr.md](engagement_confidentialite_fr.md)).
- Conformité au cadre camerounais de protection des données à caractère personnel (loi n° 2024/017 du 23 décembre 2024 **[référence à vérifier par l'équipe]**) et à la loi n° 2010/012 du 21 décembre 2010 relative à la cybersécurité et à la cybercriminalité.
- Partage des données anonymisées sous licence CC BY 4.0 après anonymisation, selon le [plan de gestion des données](plan_gestion_donnees_fr.md).

## 9. Compensation

La thèse ne fixe pas de compensation. Il est proposé **[à arrêter par l'équipe]** de rembourser les frais de transport sur justificatif, d'offrir une collation pendant les séances et de verser une indemnité forfaitaire de ____ FCFA à chaque participant ayant terminé la phase 1. Le montant doit rester assez modeste pour ne pas constituer une incitation indue. Un participant qui se retire conserve la part correspondant aux séances effectuées.

## 10. Pièces jointes

☐ Protocole détaillé (P1 : [../P1_delta/protocole_fr.md](../P1_delta/protocole_fr.md) ; P2 : [../P2_entropie_contexte/protocole_fr.md](../P2_entropie_contexte/protocole_fr.md))
☐ Notice d'information et formulaire de consentement
☐ Questionnaires et formulaires de collecte
☐ Modèle de convention avec les institutions
☐ Engagement de confidentialité
☐ Plan de gestion des données
☐ Curriculum vitae de l'investigateur principal
☐ Lettres d'accord des institutions (à joindre lorsqu'elles sont obtenues)

Signature de l'investigateur principal : ____________________ Date : ___ / ___ / ______

Visa des directeurs de recherche : ____________________ Date : ___ / ___ / ______
