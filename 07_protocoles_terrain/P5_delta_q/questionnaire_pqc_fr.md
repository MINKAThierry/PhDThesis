# Questionnaire d'extraction de verdict, contexte PQC (P5)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.5.2 (« questionnaires adaptés au contexte NIST PQC ») et §4.2.5.3, phases 1 et 2

[English version](questionnaire_pqc_en.md) · [Protocole P5](protocole_fr.md) · [Questionnaire de P1](../P1_delta/questionnaire_extraction_verdict_fr.md)

Le questionnaire est plus court que celui de P1. Il ne recueille que les variables du [gabarit de P5](gabarit_sessions_pqc_fr.csv), à savoir le verdict, la confiance et le temps, pour chaque item, chaque modalité d'aide et chaque condition de bruit. Les items de dimension de P1 ne sont pas repris **[à arrêter par l'équipe]**. Il est passé sur l'interface de vérification ([spécification](specification_interface_verification_fr.md)) ou, à défaut, sur papier.

## Partie réservée à l'enquêteur (pré-remplie par l'interface)

| Champ | Variable du gabarit |
|---|---|
| Code participant `P5-___-___` et strate | `id_participant`, `strate` |
| Schéma ☐ ML-DSA-65 ☐ SLH-DSA | `schema` |
| Stimulus `___-C__`, contexte | `id_stimulus`, `id_contexte` |
| Variante de signature `___-C__-S_` | `id_preuve`, `code_sigma` |
| Message engagé `___-C__-M_` (**ne pas montrer**) | `message_m` |
| Phase et condition ☐ 1 ☐ 2, condition ☐ A ☐ B ☐ C ☐ D, $p =$ ____ | `session`, `condition_bruit`, `p_bruit` |
| Heure d'affichage et de validation | `temps_s` |

## Phase 1. Un item = deux écrans

### Écran 1, sans aide (`aide = 0`)

Le participant lit le dossier (situation et extrait technique de la signature).

**Q1.** Si ce dossier vous était soumis dans vos fonctions, quelle décision prendriez-vous ? Une seule réponse. Les quatre libellés proviennent de la fiche stimulus (gabarits A, B ou C de P1).

☐ 1 ______ ☐ 2 ______ ☐ 3 ______ ☐ 4 ______

**Q2.** Votre confiance dans cette décision (0 aucune, 10 certitude complète).

0 — 1 — 2 — 3 — 4 — 5 — 6 — 7 — 8 — 9 — 10

### Écran 2, avec aide (`aide = 1`)

L'interface affiche la fiche d'aide à l'interprétation du schéma ([catalogue, section 4](stimuli/catalogue_stimuli_pqc_fr.md#4-fiche-daide-à-linterprétation-remise-en-phase-1-après-le-premier-verdict)). Le dossier reste visible. Le premier verdict n'est plus modifiable.

**Q1'.** Après lecture de la fiche, quelle décision prendriez-vous ? Vous pouvez reprendre la même.

☐ 1 ______ ☐ 2 ______ ☐ 3 ______ ☐ 4 ______

**Q2'.** Votre confiance dans cette décision.

0 — 1 — 2 — 3 — 4 — 5 — 6 — 7 — 8 — 9 — 10

### Contrôle d'attention (un item sur trois, tiré au hasard)

**QA.** Sans revenir au dossier, de quel type de situation s'agissait-il ? ☐ transaction ☐ document ☐ conformité ☐ autre

Un échec est saisi dans `remarques` sous la forme `ATT:0`. Une réponse juste est saisie `ATT:1`.

## Phase 2. Un item = un écran par condition

Le dossier est présenté avec le résultat de vérification affiché par le vérificateur quantique simulé. L'écran indique la condition en clair, par exemple « vérificateur simulé, taux d'erreur du canal 0,5 % » **[affichage du taux à arrêter par l'équipe]**.

**Q1.** Quelle décision prendriez-vous ? ☐ 1 ☐ 2 ☐ 3 ☐ 4
**Q2.** Votre confiance dans cette décision. 0 à 10
**Q3.** Le résultat de vérification affiché vous paraît-il fiable ? 0 (pas du tout) à 10 (tout à fait). Saisi dans `remarques` sous la forme `FIA:n`.

## Règles de saisie

| Colonne | Contenu |
|---|---|
| `aide` | `0` écran sans aide, `1` écran avec aide, `NA` en phase 2 |
| `condition_bruit`, `p_bruit` | `A` et `0` en phase 1 ; condition et valeur de $p$ en phase 2 |
| `verdict` | code 1 à 4 |
| `verdict_reference` | verdict du gold standard pour le même stimulus, le même message et la même condition |
| `erreur_interpretation` | `1` si `verdict` ≠ `verdict_reference`, `0` sinon, calculé à l'analyse (`p5.interpretation_errors`) |
| `confiance_0_10`, `temps_s` | réponses Q2 et temps de l'écran |
| `session` | `1` phase 1, `2` phase 2, `3` test-retest |
| `remarques` | codes `ATT:`, `FIA:`, résultat affiché `AFF:ok` ou `AFF:echec` en phase 2, incidents |

Une ligne par écran. Un item de phase 1 donne donc deux lignes.

Licence CC BY 4.0.
