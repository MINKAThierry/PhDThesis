# Dictionnaire des variables

> **Statut : PROPOSITION: protocole non déployé** · Source : thèse, chapitre 4, §4.2.1.4 et §4.2.2

[English version](dictionnaire_variables_en.md)

Ce dictionnaire décrit les variables des jeux de données D3 à D6 définis dans le [plan de gestion des données](plan_gestion_donnees_fr.md). Il existe aussi au format CSV ([dictionnaire_variables_fr.csv](dictionnaire_variables_fr.csv)). Les noms de variables des gabarits CSV français et anglais diffèrent. La correspondance figure dans la colonne « Nom anglais ». Les numéros d'items renvoient au [questionnaire d'extraction de verdict](../P1_delta/questionnaire_extraction_verdict_fr.md) et au [questionnaire de profil](questionnaire_profil_participant_fr.md).

Convention pour les valeurs manquantes. Cellule vide pour une question sans réponse, `NA` pour une question sans objet.


## D3 profil

| Variable | Nom anglais | Libellé | Type | Valeurs ou unité | Obligatoire |
|---|---|---|---|---|---|
| `id_participant` | `participant_id` | Code pseudonymisé du participant | texte | P1-<strate>-NNN ou P2-EX-NN | oui |
| `strate` | `stratum` | Strate de recrutement | catégoriel | JG, JS, RJ, RS, AP, AC, EX | oui |
| `id_institution` | `institution_id` | Code d'institution (supprimé avant diffusion) | texte | INST-NN | oui |
| `a1_categorie` | `a1_category` | Catégorie professionnelle (A1) | catégoriel | 1 juge, 2 régulateur, 3 auditeur, 4 expert, 9 autre | oui |
| `a2_sous_groupe` | `a2_subgroup` | Sous-groupe (A2) | catégoriel | 1 à 6 dans l'ordre du questionnaire | oui |
| `a3_anciennete_categorie` | `a3_seniority_category` | Ancienneté dans la catégorie (A3) | ordinal | 1 <2 ans, 2 2–4, 3 5–9, 4 10–19, 5 ≥20 | oui |
| `a4_supervision` | `a4_supervision` | Fonctions de supervision (A4) | binaire | 1 oui, 0 non | oui |
| `a5_anciennete_totale` | `a5_total_seniority` | Ancienneté professionnelle totale (A5) | ordinal | 1 <5 ans, 2 5–9, 3 10–19, 4 ≥20 | non |
| `b1_diplome` | `b1_degree` | Diplôme le plus élevé (B1) | catégoriel | 1 licence, 2 master, 3 ingénieur, 4 doctorat, 9 autre | non |
| `b2_domaine` | `b2_field` | Domaines de formation (B2) | multiple | codes 1 à 6 séparés par ; | non |
| `b3_certifications` | `b3_certifications` | Certifications audit ou sécurité SI (B3) | ordinal | 0 aucune, 1 une, 2 deux ou plus | non |
| `c1_dossiers_signature` | `c1_files_signature` | Dossiers avec signature électronique sur 12 mois (C1) | ordinal | 0 aucun, 1 1–5, 2 6–20, 3 >20 | non |
| `c2_dossiers_vote` | `c2_files_voting` | Dossiers avec vote électronique sur 12 mois (C2) | ordinal | 0 aucun, 1 1–5, 2 6–20, 3 >20 | non |
| `c3_recours_expert` | `c3_expert_use` | Recours à un expert technique (C3) | ordinal | 0 jamais, 1 une fois, 2 plusieurs, 3 régulièrement | non |
| `d1_formation_crypto` | `d1_crypto_training` | Volume de formation en cryptographie (D1) | ordinal | 0 aucune, 1 <10 h, 2 10–40 h, 3 >40 h, 4 diplômante | oui |
| `d2_formation_pqc` | `d2_pqc_training` | Formation en cryptographie post-quantique (D2) | ordinal | 0 aucune, 1 sensibilisation, 2 initiale, 3 avancée, 4 certification | oui |
| `d3_familiarite_1 … d3_familiarite_8` | `d3_familiarity_1 … d3_familiarity_8` | Familiarité avec les 8 notions de D3, dans l'ordre du tableau | ordinal | 0 à 4 | non |
| `d4_aisance_0_10` | `d4_comfort_0_10` | Aisance auto-évaluée face à une preuve cryptographique (D4) | entier | 0 à 10 | non |
| `e1_classe_age` | `e1_age_class` | Classe d'âge (E1, facultatif) | ordinal | 1 <30, 2 30–39, 3 40–49, 4 ≥50, 9 sans réponse | non |
| `e2_sexe` | `e2_sex` | Sexe (E2, facultatif) | catégoriel | 1 femme, 2 homme, 9 sans réponse | non |

## D4 réponses P1

| Variable | Nom anglais | Libellé | Type | Valeurs ou unité | Obligatoire |
|---|---|---|---|---|---|
| `id_participant` | `participant_id` | Code pseudonymisé du participant | texte | P1-<strate>-NNN | oui |
| `strate` | `stratum` | Strate | catégoriel | JG, JS, RJ, RS, AP, AC | oui |
| `phase` | `phase` | Phase de collecte | catégoriel | 1 séance principale, 2 test-retest J+14 | oui |
| `id_session` | `session_id` | Numéro de séance | texte | S-NNNN | oui |
| `id_enqueteur` | `interviewer_id` | Code de l'enquêteur | texte | ENQ-NN | oui |
| `id_stimulus` | `stimulus_id` | Paire contexte–preuve présentée | texte | <TYPE>-C<NN>, par exemple ECD-C03 | oui |
| `type_preuve` | `proof_type` | Type de preuve | catégoriel | ECD ECDSA, HEL Helios, G16 Groth16, PSS RSA-PSS, EGC ElGamal classique | oui |
| `id_contexte_c` | `context_c_id` | Code du contexte $c$ | texte | identique à id_stimulus | oui |
| `id_preuve_sigma` | `proof_sigma_id` | Variante de preuve $\sigma$ présentée | texte | <id_stimulus>-S<N> | oui |
| `id_message_m` | `message_m_id` | Message engagé $m$ (vérité terrain, inconnue du participant) | texte | <id_stimulus>-M<N> | oui |
| `rang_presentation` | `presentation_rank` | Rang de présentation dans la séance | entier | 1 à 10 (phase 1), 1 à 3 (phase 2) | oui |
| `verdict_v` | `verdict_v` | Verdict global (Q01) | catégoriel | 1 à 4 selon l'espace de verdicts de la fiche stimulus | oui |
| `q02 … q25 (hors q09, q18)` | `q02 … q25 (except q09, q18)` | Items de verdict par dimension (22 items) | ordinal | 1 pas du tout établi à 7 tout à fait établi, 0 impossible à déterminer, vide non répondu | oui |
| `q09_attention` | `q09_attention` | Contrôle d'attention 1 (réponse attendue 3) | ordinal | 0 à 7 | oui |
| `q18_attention` | `q18_attention` | Contrôle d'attention 2 (réponse attendue 0) | ordinal | 0 à 7 | oui |
| `confiance_0_10` | `confidence_0_10` | Confiance subjective dans le verdict global (Q26) | entier | 0 à 10 | oui |
| `q27_apport_preuve` | `q27_proof_contribution` | Part de la décision attribuée à la preuve (Q27) | entier | 0 à 10 | oui |
| `q28_attention` | `q28_attention` | Contrôle d'attention 3, rappel du domaine du contexte | catégoriel | 1 contrat, 2 élection, 3 contrôle financier, 4 autre | oui |
| `q29_expertise` | `q29_expertise` | Expertise complémentaire souhaitée (Q29) | catégoriel | 0 non, 1 expertise technique, 2 expertise juridique, 3 les deux | oui |
| `q30_elements` | `q30_elements` | Éléments mobilisés (Q30) | multiple | codes 1 à 8 séparés par ; | non |
| `temps_s` | `time_s` | Temps de décision pour le contexte | entier | secondes | oui |
| `echecs_attention` | `attention_failures` | Nombre d'échecs aux contrôles d'attention (calculé) | entier | 0 à 3 | oui |
| `exclu` | `excluded` | Réponse exclue selon le pré-enregistrement (calculé) | binaire | 1 oui, 0 non | oui |
| `id_ecart` | `deviation_id` | Fiche d'écart associée | texte | ECART-NNNN ou vide | non |

## D5 gold standard P1

| Variable | Nom anglais | Libellé | Type | Valeurs ou unité | Obligatoire |
|---|---|---|---|---|---|
| `id_stimulus` | `stimulus_id` | Paire contexte–preuve | texte | <TYPE>-C<NN> | oui |
| `id_preuve_sigma` | `proof_sigma_id` | Variante de preuve | texte | <id_stimulus>-S<N> | oui |
| `id_message_m` | `message_m_id` | Message engagé | texte | <id_stimulus>-M<N> | oui |
| `id_expert_gs` | `gs_expert_id` | Expert du gold standard | catégoriel | GS-A, GS-B, GS-ARB, CONSENSUS | oui |
| `gs_verdict_v` | `gs_verdict_v` | Verdict global de référence | catégoriel | 1 à 4 | oui |
| `gs_q02 … gs_q25` | `gs_q02 … gs_q25` | Réponses de référence aux 22 items de dimension | ordinal | 0 à 7 | oui |

## D6a P2 décomposition

| Variable | Nom anglais | Libellé | Type | Valeurs ou unité | Obligatoire |
|---|---|---|---|---|---|
| `id_expert` | `expert_id` | Code de l'expert | texte | P2-EX-NN | oui |
| `domaine` | `domain` | Domaine institutionnel | catégoriel | ELEC électoral, FIN conformité financière, CONT contractuel | oui |
| `composante` | `component` | Composante de la décomposition | catégoriel | L juridique, T temporelle, R procédurale | oui |
| `element` | `element` | Élément de la grille | texte | C1 à F12 ou libellé ajouté | oui |
| `nb_modalites` | `n_categories` | Nombre de modalités distinguables | entier | ≥ 1 | oui |
| `entropie_bits` | `entropy_bits` | Entropie de l'élément | réel | bits | oui |
| `remarques` | `notes` | Remarques de l'expert ou de la saisie | texte | libre | non |

Gabarit : [../P2_entropie_contexte/gabarit_decomposition_fr.csv](../P2_entropie_contexte/gabarit_decomposition_fr.csv).

## D6b P2 dissimilarité

| Variable | Nom anglais | Libellé | Type | Valeurs ou unité | Obligatoire |
|---|---|---|---|---|---|
| `id_expert` | `expert_id` | Code de l'expert | texte | P2-EX-NN | oui |
| `id_session` | `session_id` | Numéro de séance | texte | S-NNNN | oui |
| `domaine` | `domain` | Domaine de la séance | catégoriel | ELEC, FIN, CONT | oui |
| `id_ctx_i, id_ctx_j` | `ctx_i_id, ctx_j_id` | Paire de contextes du corpus, dans l'ordre d'affichage | texte | CTX-NNN | oui |
| `rang_presentation` | `presentation_rank` | Rang de présentation dans la séance | entier | 1 à 553 (586 pour ELEC), répétitions comprises | oui |
| `dissimilarite_0_10` | `dissimilarity_0_10` | Dissimilarité jugée | entier | 0 identiques à 10 sans rapport | oui |
| `remarques` | `notes` | Incident ou hésitation signalée | texte | libre | non |

Gabarit : [../P2_entropie_contexte/gabarit_dissimilarite_fr.csv](../P2_entropie_contexte/gabarit_dissimilarite_fr.csv).

## D6c P2 Delphi

| Variable | Nom anglais | Libellé | Type | Valeurs ou unité | Obligatoire |
|---|---|---|---|---|---|
| `id_expert` | `expert_id` | Code de l'expert | texte | P2-EX-NN | oui |
| `tour` | `round` | Tour Delphi | entier | 1 à 4 | oui |
| `domaine` | `domain` | Domaine estimé | catégoriel | ELEC, FIN, CONT | oui |
| `h_estimee_bits` | `h_estimate_bits` | Estimation de $H(\mathcal{C})$ | réel | bits | oui |
| `borne_basse_bits, borne_haute_bits` | `lower_bound_bits, upper_bound_bits` | Intervalle plausible de l'expert | réel | bits | oui |
| `confiance_0_10` | `confidence_0_10` | Confiance de l'expert dans son estimation | entier | 0 à 10 | oui |
| `argument` | `argument` | Argument principal ou justification de la révision | texte | libre | non |
| `remarques` | `notes` | Remarques de saisie | texte | libre | non |

Gabarit : [../P2_entropie_contexte/gabarit_delphi_fr.csv](../P2_entropie_contexte/gabarit_delphi_fr.csv).
