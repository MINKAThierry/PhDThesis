# Variable dictionary

> **Status: PROPOSAL/ protocol not deployed** · Source: thesis, Chapter 4, §4.2.1.4 and §4.2.2

[Version française](dictionnaire_variables_fr.md)

This dictionary describes the variables of datasets D3 to D6 defined in the [data management plan](plan_gestion_donnees_en.md). It also exists as CSV ([dictionnaire_variables_en.csv](dictionnaire_variables_en.csv)). Variable names differ between the French and English CSV templates. The mapping is given in the column "French name". Item numbers refer to the [verdict extraction questionnaire](../P1_delta/questionnaire_extraction_verdict_en.md) and the [profile questionnaire](questionnaire_profil_participant_en.md).

Missing-value convention. Empty cell for an unanswered question, `NA` for a question that does not apply.


## D3 profile

| Variable | French name | Label | Type | Values or unit | Mandatory |
|---|---|---|---|---|---|
| `participant_id` | `id_participant` | Pseudonymised participant code | text | P1-<stratum>-NNN or P2-EX-NN | yes |
| `stratum` | `strate` | Recruitment stratum | categorical | JG, JS, RJ, RS, AP, AC, EX | yes |
| `institution_id` | `id_institution` | Institution code (removed before release) | text | INST-NN | yes |
| `a1_category` | `a1_categorie` | Professional category (A1) | categorical | 1 judge, 2 regulator, 3 auditor, 4 expert, 9 other | yes |
| `a2_subgroup` | `a2_sous_groupe` | Subgroup (A2) | categorical | 1 to 6 in questionnaire order | yes |
| `a3_seniority_category` | `a3_anciennete_categorie` | Seniority in category (A3) | ordinal | 1 <2 yrs, 2 2–4, 3 5–9, 4 10–19, 5 ≥20 | yes |
| `a4_supervision` | `a4_supervision` | Supervisory duties (A4) | binary | 1 yes, 0 no | yes |
| `a5_total_seniority` | `a5_anciennete_totale` | Total professional seniority (A5) | ordinal | 1 <5 yrs, 2 5–9, 3 10–19, 4 ≥20 | no |
| `b1_degree` | `b1_diplome` | Highest degree (B1) | categorical | 1 bachelor, 2 master, 3 engineering, 4 doctorate, 9 other | no |
| `b2_field` | `b2_domaine` | Fields of education (B2) | multiple | codes 1 to 6 separated by ; | no |
| `b3_certifications` | `b3_certifications` | IS audit or security certifications (B3) | ordinal | 0 none, 1 one, 2 two or more | no |
| `c1_files_signature` | `c1_dossiers_signature` | Files with electronic signature over 12 months (C1) | ordinal | 0 none, 1 1–5, 2 6–20, 3 >20 | no |
| `c2_files_voting` | `c2_dossiers_vote` | Files with electronic voting over 12 months (C2) | ordinal | 0 none, 1 1–5, 2 6–20, 3 >20 | no |
| `c3_expert_use` | `c3_recours_expert` | Use of a technical expert (C3) | ordinal | 0 never, 1 once, 2 several, 3 regularly | no |
| `d1_crypto_training` | `d1_formation_crypto` | Amount of cryptography training (D1) | ordinal | 0 none, 1 <10 h, 2 10–40 h, 3 >40 h, 4 degree | yes |
| `d2_pqc_training` | `d2_formation_pqc` | Post-quantum cryptography training (D2) | ordinal | 0 none, 1 awareness, 2 initial, 3 advanced, 4 certification | yes |
| `d3_familiarity_1 … d3_familiarity_8` | `d3_familiarite_1 … d3_familiarite_8` | Familiarity with the 8 notions of D3, in table order | ordinal | 0 to 4 | no |
| `d4_comfort_0_10` | `d4_aisance_0_10` | Self-assessed comfort with cryptographic evidence (D4) | integer | 0 to 10 | no |
| `e1_age_class` | `e1_classe_age` | Age class (E1, optional) | ordinal | 1 <30, 2 30–39, 3 40–49, 4 ≥50, 9 no answer | no |
| `e2_sex` | `e2_sexe` | Sex (E2, optional) | categorical | 1 female, 2 male, 9 no answer | no |

## D4 P1 answers

| Variable | French name | Label | Type | Values or unit | Mandatory |
|---|---|---|---|---|---|
| `participant_id` | `id_participant` | Pseudonymised participant code | text | P1-<stratum>-NNN | yes |
| `stratum` | `strate` | Stratum | categorical | JG, JS, RJ, RS, AP, AC | yes |
| `phase` | `phase` | Collection phase | categorical | 1 main session, 2 test-retest D+14 | yes |
| `session_id` | `id_session` | Session number | text | S-NNNN | yes |
| `interviewer_id` | `id_enqueteur` | Interviewer code | text | ENQ-NN | yes |
| `stimulus_id` | `id_stimulus` | Context–proof pair presented | text | <TYPE>-C<NN>, e.g. ECD-C03 | yes |
| `proof_type` | `type_preuve` | Proof type | categorical | ECD ECDSA, HEL Helios, G16 Groth16, PSS RSA-PSS, EGC classical ElGamal | yes |
| `context_c_id` | `id_contexte_c` | Code of context $c$ | text | same as stimulus_id | yes |
| `proof_sigma_id` | `id_preuve_sigma` | Proof variant $\sigma$ presented | text | <stimulus_id>-S<N> | yes |
| `message_m_id` | `id_message_m` | Committed message $m$ (ground truth, unknown to participant) | text | <stimulus_id>-M<N> | yes |
| `presentation_rank` | `rang_presentation` | Presentation rank in the session | integer | 1 to 10 (phase 1), 1 to 3 (phase 2) | yes |
| `verdict_v` | `verdict_v` | Overall verdict (Q01) | categorical | 1 to 4 according to the verdict space of the stimulus sheet | yes |
| `q02 … q25 (except q09, q18)` | `q02 … q25 (hors q09, q18)` | Dimension verdict items (22 items) | ordinal | 1 not at all established to 7 fully established, 0 cannot be determined, empty no answer | yes |
| `q09_attention` | `q09_attention` | Attention check 1 (expected answer 3) | ordinal | 0 to 7 | yes |
| `q18_attention` | `q18_attention` | Attention check 2 (expected answer 0) | ordinal | 0 to 7 | yes |
| `confidence_0_10` | `confiance_0_10` | Subjective confidence in the overall verdict (Q26) | integer | 0 to 10 | yes |
| `q27_proof_contribution` | `q27_apport_preuve` | Share of the decision attributed to the proof (Q27) | integer | 0 to 10 | yes |
| `q28_attention` | `q28_attention` | Attention check 3, recall of the context domain | categorical | 1 contract, 2 election, 3 financial control, 4 other | yes |
| `q29_expertise` | `q29_expertise` | Additional expertise wanted (Q29) | categorical | 0 no, 1 technical, 2 legal, 3 both | yes |
| `q30_elements` | `q30_elements` | Elements relied on (Q30) | multiple | codes 1 to 8 separated by ; | no |
| `time_s` | `temps_s` | Decision time for the context | integer | seconds | yes |
| `attention_failures` | `echecs_attention` | Number of attention-check failures (computed) | integer | 0 to 3 | yes |
| `excluded` | `exclu` | Answer excluded according to pre-registration (computed) | binary | 1 yes, 0 no | yes |
| `deviation_id` | `id_ecart` | Associated deviation form | text | ECART-NNNN or empty | no |

## D5 P1 gold standard

| Variable | French name | Label | Type | Values or unit | Mandatory |
|---|---|---|---|---|---|
| `stimulus_id` | `id_stimulus` | Context–proof pair | text | <TYPE>-C<NN> | yes |
| `proof_sigma_id` | `id_preuve_sigma` | Proof variant | text | <stimulus_id>-S<N> | yes |
| `message_m_id` | `id_message_m` | Committed message | text | <stimulus_id>-M<N> | yes |
| `gs_expert_id` | `id_expert_gs` | Gold-standard expert | categorical | GS-A, GS-B, GS-ARB, CONSENSUS | yes |
| `gs_verdict_v` | `gs_verdict_v` | Reference overall verdict | categorical | 1 to 4 | yes |
| `gs_q02 … gs_q25` | `gs_q02 … gs_q25` | Reference answers to the 22 dimension items | ordinal | 0 to 7 | yes |

## D6a P2 decomposition

| Variable | French name | Label | Type | Values or unit | Mandatory |
|---|---|---|---|---|---|
| `expert_id` | `id_expert` | Expert code | text | P2-EX-NN | yes |
| `domain` | `domaine` | Institutional domain | categorical | ELEC electoral, FIN financial compliance, CONT contractual | yes |
| `component` | `composante` | Decomposition component | categorical | L legal, T temporal, R procedural | yes |
| `element` | `element` | Grid element | text | C1 to F12 or added label | yes |
| `n_categories` | `nb_modalites` | Number of distinguishable categories | integer | ≥ 1 | yes |
| `entropy_bits` | `entropie_bits` | Entropy of the element | real | bits | yes |
| `notes` | `remarques` | Remarks of the expert or of data entry | text | free | no |

Template: [../P2_entropie_contexte/gabarit_decomposition_en.csv](../P2_entropie_contexte/gabarit_decomposition_en.csv).

## D6b P2 dissimilarity

| Variable | French name | Label | Type | Values or unit | Mandatory |
|---|---|---|---|---|---|
| `expert_id` | `id_expert` | Expert code | text | P2-EX-NN | yes |
| `session_id` | `id_session` | Session number | text | S-NNNN | yes |
| `domain` | `domaine` | Domain of the session | categorical | ELEC, FIN, CONT | yes |
| `ctx_i_id, ctx_j_id` | `id_ctx_i, id_ctx_j` | Pair of corpus contexts, in display order | text | CTX-NNN | yes |
| `presentation_rank` | `rang_presentation` | Presentation rank in the session | integer | 1 to 553 (586 for ELEC), repetitions included | yes |
| `dissimilarity_0_10` | `dissimilarite_0_10` | Judged dissimilarity | integer | 0 identical to 10 unrelated | yes |
| `notes` | `remarques` | Incident or reported hesitation | text | free | no |

Template: [../P2_entropie_contexte/gabarit_dissimilarite_en.csv](../P2_entropie_contexte/gabarit_dissimilarite_en.csv).

## D6c P2 Delphi

| Variable | French name | Label | Type | Values or unit | Mandatory |
|---|---|---|---|---|---|
| `expert_id` | `id_expert` | Expert code | text | P2-EX-NN | yes |
| `round` | `tour` | Delphi round | integer | 1 to 4 | yes |
| `domain` | `domaine` | Domain estimated | categorical | ELEC, FIN, CONT | yes |
| `h_estimate_bits` | `h_estimee_bits` | Estimate of $H(\mathcal{C})$ | real | bits | yes |
| `lower_bound_bits, upper_bound_bits` | `borne_basse_bits, borne_haute_bits` | Expert's plausible interval | real | bits | yes |
| `confidence_0_10` | `confiance_0_10` | Expert's confidence in the estimate | integer | 0 to 10 | yes |
| `argument` | `argument` | Main argument or justification of the revision | text | free | no |
| `notes` | `remarques` | Data entry remarks | text | free | no |

Template: [../P2_entropie_contexte/gabarit_delphi_en.csv](../P2_entropie_contexte/gabarit_delphi_en.csv).
