# Guide de l'enquêteur (P1)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.1.3 (phases 0 à 4) et §4.2.1.4 (temps de décision et confiance)

[English version](guide_enqueteur_en.md) · [Protocole P1](protocole_fr.md) · [README du dossier](README_fr.md)

Ce guide décrit, pas à pas, la préparation et la conduite des séances de P1. Il complète le protocole sans le modifier. Les horaires et effectifs non fixés par la thèse sont des propositions **[à arrêter par l'équipe]**.

## 1. Rôle de l'enquêteur

L'enquêteur conduit les séances, remet les documents dans l'ordre prévu, relève les heures et consigne tout incident. Il ne donne jamais son avis sur un dossier. Il ne connaît pas les hypothèses chiffrées de l'étude (les valeurs de $\Delta$ prédites) **[à arrêter par l'équipe]**.

Avant la première séance, l'enquêteur a
☐ signé l'[engagement de confidentialité](../00_commun/engagement_confidentialite_fr.md)
☐ suivi une séance blanche complète (phases 0 et 1) avec le coordinateur
☐ lu ce guide, le [questionnaire](questionnaire_extraction_verdict_fr.md), le [support de formation](support_formation_phase0_fr.md) et le [journal de séance](../00_commun/journal_session_fr.md)

## 2. Préparation de la séance (la veille)

1. Récupérer auprès du coordinateur la liste des participants (codes seulement) et, pour chacun, sa liste de rotation (1 à 5) et l'ordre de présentation de ses 10 contextes.
2. Préparer, pour chaque participant, une enveloppe par contexte. Chaque enveloppe contient le dossier de la variante attribuée et un questionnaire dont la partie réservée est pré-remplie. L'enveloppe porte le code participant et le rang de présentation.
3. Vérifier que l'étiquette « message engagé » est bien détachée des questionnaires remis au participant et conservée à part.
4. Préparer les consentements (deux exemplaires par participant), les questionnaires de profil, le journal de séance, des fiches d'écart vierges, une horloge visible de l'enquêteur seul.
5. Vérifier la salle (une place par participant, espacement suffisant pour empêcher la lecture du voisin).

| Élément | Quantité par participant |
|---|---|
| Notice et consentement | 2 |
| Questionnaire de profil | 1 |
| Enveloppes de contexte (dossier et questionnaire) | 10 |
| Questionnaire d'essai de la formation | 1 |

## 3. Accueil et consentement

1. Accueillir les participants, rappeler la durée totale et le droit de retrait à tout moment.
2. Remettre la [notice](../00_commun/notice_information_consentement_fr.md), laisser le temps de lecture, répondre aux questions, recueillir le consentement signé. Aucun participant ne commence sans consentement signé.
3. Remettre le [questionnaire de profil](../00_commun/questionnaire_profil_participant_fr.md).
4. Reporter dans le journal, pour chaque participant, l'heure d'arrivée et le numéro de liste de rotation.

## 4. Phase 0, formation (2 h)

Suivre le [support de formation](support_formation_phase0_fr.md) mot pour mot. Noter l'heure de début et de fin. Les questions non prévues et leurs réponses sont consignées dans le journal.

La phase 0 a lieu le même jour que la phase 1 ou la veille **[à arrêter par l'équipe]**. Si elle a lieu le même jour, une pause d'au moins 30 min les sépare.

## 5. Phase 1, séance principale (4 h)

### 5.1 Déroulement minuté proposé

| Horaire relatif | Activité |
|---|---|
| 0:00 | Rappel des consignes (section 5.2) |
| 0:05 | Contextes de rang 1 à 4 (environ 20 min chacun) |
| 1:25 | Pause 1 (15 min) |
| 1:40 | Contextes de rang 5 à 7 |
| 2:40 | Pause 2 (15 min) |
| 2:55 | Contextes de rang 8 à 10 |
| 3:55 | Ramassage, remerciements, rendez-vous de phase 2 |

Le rythme de 20 min par contexte est indicatif. Chaque participant avance à son rythme, sans limite de temps par contexte. Un participant qui finit tôt attend en silence. L'enquêteur ne le presse jamais.

### 5.2 Consignes à lire

> « Vous allez examiner dix dossiers, un par enveloppe, dans l'ordre des numéros. Pour chaque dossier, lisez la situation et la pièce, puis remplissez le questionnaire. Lorsque vous avez fini un dossier, levez la main. Je reprendrai l'enveloppe et je vous remettrai la suivante. Vous ne pouvez pas revenir sur un dossier déjà rendu. Il n'y a pas de bonne ou de mauvaise réponse. Répondez comme vous le feriez dans vos fonctions. Merci de ne pas échanger entre vous pendant la séance. »

### 5.3 Pour chaque contexte

1. Remettre l'enveloppe de rang $k$ et noter l'heure de remise à la seconde (journal, section 4).
2. À la main levée, reprendre l'enveloppe, noter l'heure de restitution, vérifier sans le lire que le questionnaire est rempli (pas de page blanche). Ne pas commenter les réponses.
3. Remettre l'enveloppe suivante.

Le temps de décision `temps_s` est la différence entre les deux heures. Il inclut la lecture du dossier.

### 5.4 Incidents

| Incident | Conduite à tenir |
|---|---|
| Question sur le fond d'un dossier | « Répondez avec les éléments du dossier et votre pratique. » |
| Participant qui veut revenir sur un dossier | refuser poliment, noter dans le journal |
| Échange entre participants | rappeler la consigne, noter les codes et le rang concernés, fiche d'écart |
| Enveloppe erronée (mauvaise variante ou mauvais rang) | laisser terminer, noter, fiche d'écart, signaler au coordinateur le jour même |
| Malaise ou fatigue | proposer une pause, noter la durée. Le participant peut arrêter à tout moment. |
| Retrait du participant | accepter sans demander de motif, remettre le formulaire de retrait, noter l'heure |
| Interruption extérieure | noter la durée et les participants concernés |

Toute déviation au protocole donne lieu à une [fiche d'écart](../00_commun/fiche_ecart_protocole_fr.md), numérotée `ECART-NNNN`, reportée dans la variable `id_ecart`.

## 6. Phase 2, test-retest (1 h, à J+14)

Suivre la [fiche test-retest](fiche_test_retest_fr.md) préparée par le coordinateur. L'enquêteur ne consulte pas les réponses de phase 1 du participant. Le questionnaire porte `phase = 2`.

## 7. Phase 4, débriefing (30 min)

Suivre la [fiche de débriefing](fiche_debriefing_fr.md). Le débriefing a lieu à l'issue de la phase 2, jamais avant.

## 8. Après chaque séance

1. Compter les questionnaires et les rapprocher des enveloppes distribuées.
2. Placer consentements et questionnaires dans des enveloppes distinctes, scellées, remises le jour même au coordinateur ([plan de gestion des données](../00_commun/plan_gestion_donnees_fr.md)).
3. Remettre le journal de séance signé et les éventuelles fiches d'écart.
4. Ne conserver aucune copie, photographie ou note personnelle.

## 9. Saisie des données

La saisie est faite par deux opérateurs indépendants, dans le [gabarit de données](gabarit_donnees_fr.csv), puis les deux saisies sont comparées **[double saisie à arrêter par l'équipe]**. Les règles de saisie figurent à la fin du [questionnaire](questionnaire_extraction_verdict_fr.md#règles-de-saisie-et-de-contrôle). Les variables `echecs_attention` et `exclu` sont calculées par le script d'analyse et non saisies à la main.

Licence CC BY 4.0.
