# Protocole de jugement de dissimilarité (P2, approche MDS)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.2.3 (100 contextes, panel de 5 à 10 experts, évaluation de similarité par paires, MDS, $V_{\text{eff}} = \det(\hat\Sigma)^{1/2}$)

[English version](protocole_dissimilarite_mds_en.md) · [Protocole P2](protocole_fr.md) · [Corpus des 100 contextes](corpus_contextes_fr.md)

## 1. Plan de passation

| Élément | Proposition **[à arrêter par l'équipe]** |
|---|---|
| Experts | 5 à 10 (thèse), au moins 2 par profil |
| Paires jugées | toutes les paires internes à un domaine, soit 561 (`ELEC`), 528 (`FIN`) et 528 (`CONT`) |
| Séances | trois par expert, une par domaine, d'environ 1 h 30, à au moins 48 h d'intervalle |
| Ordre des domaines | permuté entre experts (6 ordres possibles) |
| Ordre des paires | tiré au hasard pour chaque expert et chaque séance, graine consignée |
| Ordre à l'intérieur d'une paire | tiré au hasard (le contexte $i$ s'affiche à gauche ou à droite) |
| Paires répétées | 25 paires par séance, tirées au hasard, présentées une seconde fois en fin de séance pour mesurer la stabilité |
| Support | formulaire électronique hors ligne recommandé, livret papier en secours |

Un jugement prend environ 8 s une fois la consigne assimilée. Les 553 jugements d'une séance (528 paires et 25 répétitions) demandent donc environ 75 min, auxquelles s'ajoutent l'accueil, l'entraînement et la pause.

## 2. Échelle

Chaque paire est jugée sur une échelle de 0 à 10.

| Valeur | Signification |
|---|---|
| 0 | Les deux contextes seraient traités exactement de la même manière par l'institution compétente. |
| 5 | Les deux contextes ont des points communs importants mais appellent des traitements différents sur plusieurs aspects. |
| 10 | Les deux contextes n'ont presque rien en commun dans leur traitement, bien qu'ils relèvent du même domaine. |

La dissimilarité porte sur la **manière dont une institution traiterait le cas**, non sur la rédaction des textes.

L'unité retenue pour le calcul de $V_{\text{eff}}$ (par exemple une graduation de l'échelle) doit être fixée avant la collecte. Elle détermine directement le niveau de l'estimation ([protocole P2](protocole_fr.md#8-points-de-vigilance), point 1).

## 3. Déroulement d'une séance

| Durée | Étape |
|---|---|
| 5 min | Accueil, rappel du droit de retrait, lecture des consignes (section 4) |
| 5 min | Six paires d'entraînement tirées d'un autre domaine, non enregistrées |
| 35 à 40 min | Première moitié des paires |
| 5 min | Pause |
| 35 à 40 min | Seconde moitié des paires, puis 25 paires répétées |
| 2 min | Question de clôture (section 5) |

L'enquêteur consigne la séance dans le [journal de séance](../00_commun/journal_session_fr.md) (protocole P2, séance MDS).

## 4. Consignes lues à l'expert

> « Deux courtes descriptions de situations vont s'afficher côte à côte. Elles relèvent toutes du même domaine. Pour chaque paire, indiquez à quel point l'institution compétente traiterait ces deux situations différemment, de 0 (exactement de la même manière) à 10 (presque rien en commun). Répondez vite, sans chercher à justifier. Il n'y a pas de bonne réponse. Certaines paires reviendront en fin de séance. Répondez-y comme si vous les voyiez pour la première fois. »

## 5. Question de clôture

« Quels aspects des situations ont le plus guidé vos jugements ? » Réponse libre, notée par l'enquêteur. Elle sert à interpréter les dimensions de la MDS.

## 6. Livret papier de secours (une page par série de 20 paires)

| Code expert `P2-EX-__` | Séance `S-____` | Domaine ☐ ELEC ☐ FIN ☐ CONT | Page ___ / ___ |
|---|---|---|---|

| Rang | Contexte de gauche | Contexte de droite | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ___ | `CTX-___` | `CTX-___` | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| ___ | `CTX-___` | `CTX-___` | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| ___ | `CTX-___` | `CTX-___` | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |

Le livret reproduit en regard le texte complet des deux contextes de chaque paire, tiré du [corpus](corpus_contextes_fr.md).

## 7. Saisie

Une ligne par jugement dans [gabarit_dissimilarite_fr.csv](gabarit_dissimilarite_fr.csv). Les paires répétées sont saisies avec leur rang de présentation propre. Elles servent à la mesure de stabilité et ne sont pas moyennées avec la première réponse **[à arrêter par l'équipe]**.

| Colonne | Contenu |
|---|---|
| `id_expert` | `P2-EX-NN` |
| `id_session` | `S-NNNN` |
| `domaine` | `ELEC`, `FIN` ou `CONT` |
| `id_ctx_i`, `id_ctx_j` | codes des deux contextes, dans l'ordre d'affichage |
| `rang_presentation` | 1 à 553 (ou 586 pour `ELEC`), répétitions comprises |
| `dissimilarite_0_10` | jugement de 0 à 10 |
| `remarques` | incident, hésitation signalée |

## 8. Contrôles de qualité

| Indicateur | Calcul | Seuil proposé **[à arrêter par l'équipe]** |
|---|---|---|
| Stabilité intra-expert | corrélation de Spearman entre les deux réponses aux 25 paires répétées | ≥ 0,7 |
| Accord inter-experts | ICC(2,1) en accord absolu sur les paires communes | ≥ 0,8 (seuil commun du programme) |
| Réponses mécaniques | part des jugements identiques consécutifs au-delà de 20 | signalement |

Un expert dont la stabilité est inférieure au seuil est signalé. Ses jugements sont conservés dans l'analyse principale et retirés dans une analyse de sensibilité.

## 9. Analyse

Matrice moyenne par domaine (`cro_terrain.p2.dissimilarity_matrix`), choix du nombre de dimensions selon le seuil de stress déposé (`p2.choose_dimensions`), estimation $\log_2 V_{\text{eff}}$ (`p2.mds_entropy`) et intervalle par bootstrap sur les experts (`p2.mds_entropy_bootstrap`). Les dimensions retenues sont mises en regard des niveaux des éléments de la grille, donnés pour chaque contexte dans [corpus_contextes.csv](corpus_contextes.csv).

Licence CC BY 4.0.
