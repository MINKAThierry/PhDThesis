# 00_commun: documents shared by all protocols

> **Status: PROPOSAL: protocol not deployed** · Source: thesis, Chapter 4, §4.2.1 to §4.2.8

[Version française](README_fr.md) · [Back to parent folder](../README_en.md)

These documents serve all protocols P1 to P7. They are written in detail for P1 and P2 and can be adapted to the other protocols. None has been used in the field. Values not found in the thesis are flagged **[to be decided by the team]**.

| No. | Document | Purpose | Thesis reference |
|---|---|---|---|
| 1 | [preenregistrement_en.md](preenregistrement_en.md) | OSF pre-registration template, hypotheses, estimators, refutation criteria, stopping rule | §4.2.1.4, §4.2.1.5, §4.2.7.3 |
| 2 | [dossier_comite_ethique_en.md](dossier_comite_ethique_en.md) | Application to the research ethics committee | §4.2.4, §4.2.8.3 |
| 3 | [notice_information_consentement_en.md](notice_information_consentement_en.md) | Information sheet, free and informed consent, withdrawal form | §4.2.4 |
| 4 | [convention_institution_partenaire_en.md](convention_institution_partenaire_en.md) | Agreement with a court, a regulator, a firm or ENSP | §4.2.4, §4.2.8.3 |
| 5 | [engagement_confidentialite_en.md](engagement_confidentialite_en.md) | Undertaking by interviewers and gold-standard experts | §4.2.1.3 |
| 6 | [fiche_recrutement_stratification_en.md](fiche_recrutement_stratification_en.md) | Pseudonymised codes, quotas and individual tracking | §4.2.1.2 (table `tab:stratification_delta`) |
| 7 | [questionnaire_profil_participant_en.md](questionnaire_profil_participant_en.md) | Profile, seniority, cryptographic and PQC training, no identifying data | §4.2.1.2, §4.2.5.2 |
| 8 | [journal_session_en.md](journal_session_en.md) | Interviewer session log, response times | §4.2.1.3 |
| 9 | [fiche_ecart_protocole_en.md](fiche_ecart_protocole_en.md) | Protocol deviation report | §4.2.4, §4.2.7.3 |
| 10 | [plan_gestion_donnees_en.md](plan_gestion_donnees_en.md) | Storage, pseudonymisation, retention, CC BY 4.0 sharing | §4.2.8.3 |
| 10a | [dictionnaire_variables_en.md](dictionnaire_variables_en.md) and [dictionnaire_variables_en.csv](dictionnaire_variables_en.csv) | Variable dictionary | §4.2.1.4, §4.2.2 |
| 11 | [plan_analyse_statistique_en.md](plan_analyse_statistique_en.md) | Estimators, bootstrap over participants, admissibility test, ICC and kappa | §4.2.1.1, §4.2.1.4, §4.2.4 |

## Order of use

1. Signature of agreements (4) then submission of the ethics file (2).
2. Resolution of the [to be decided by the team] flags then deposit of the pre-registration (1) together with the analysis plan (11) and the data management plan (10).
3. Signature of confidentiality undertakings (5).
4. Recruitment and quota tracking (6), consent (3), profile (7).
5. Sessions with log (8) and, where needed, deviation forms (9).

## Caveats identified while drafting

- **Cell size.** With the thesis sample size, a direct plug-in estimate of $\hat I(V;\Sigma\mid M,C)$ on the verdict vector is bounded by about $\log_2 24$ bits per pair, far below the predicted values. The analysis plan (section 5.3) proposes two routes to be decided.
- **Verdict level for $\hat\alpha$.** The ratio $\log_2|\mathcal{V}|/H(C)$ depends on the definition adopted for $\mathcal{V}$ (overall verdict or item vector). The analysis plan (section 6) requires this level to be fixed before collection.
- **Variation of $\sigma$ at fixed $(m,c)$.** The stimulus catalogue must provide at least two proof variants per pair $(m,c)$.

## Licence

CC BY 4.0.
