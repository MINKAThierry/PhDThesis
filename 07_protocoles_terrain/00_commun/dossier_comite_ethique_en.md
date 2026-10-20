# Template application to the research ethics committee

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.4 (ethics prerequisite) and §4.2.8.3

[Version française](dossier_comite_ethique_fr.md)

The thesis makes approval by a research ethics committee a mandatory prerequisite of any data collection (algorithm `alg:estimation_conjointe`, §4.2.4) and one of the three non-technical prerequisites for deployment (§4.2.8.3). This template is written for P1 and P2. It can be adapted to the other protocols by replacing sections 3 to 5.

Committee addressed: ____________________________________________ **[to be decided by the team]** (institutional committee competent for engineering and social-science research at the University of Yaoundé I or, failing that, the designated national committee)

## 1. Identification

- Project title: Measuring the institutional parameters of institutional cryptography ($\Delta$, $H(\mathcal{C})$) among judges, regulators and auditors
- Principal investigator: ____________________ Position: ____________________
- Research supervisors: ____________________________________________
- Laboratory and institution: LIMSI, National Advanced School of Engineering (ENSP), University of Yaoundé I
- Correspondence address: ____________________________________________
- Telephone: ____________________ Email: ____________________
- Planned duration: P1 6 months, P2 3 months (thesis, table `tab:programme_experimental`)
- Funding: ____________________ Amount: ____________ FCFA (thesis order of magnitude: 15,000,000 FCFA for P1 and 5,000,000 FCFA for P2)
- Declared conflicts of interest: ☐ none ☐ yes, specify: ____________________

## 2. Rationale and objectives

The bounds of the conditional CRO trilemma established in the thesis depend on institutional parameters that have never been measured among real actors. The study aims to estimate them.

- Main objective of P1: estimate the institutional extraction capacity $\Delta$ (in bits) with the estimator $\hat\Delta = \hat I(V;\Sigma\mid M,C)$ in six subgroups of professionals (thesis, §4.2.1).
- Main objective of P2: estimate the contextual entropy $H(\mathcal{C})$ of three institutional domains (electoral litigation, financial compliance, contract signature) by structural decomposition, MDS and Delphi (thesis, §4.2.2).
- Secondary objectives: test-retest reliability, inter-rater agreement, test of the admissibility of interpretation.

The study concerns neither health nor sensitive data within the meaning of personal data legislation. It concerns professional judgements on fictitious cases.

## 3. Population and recruitment

| Protocol | Population | Size (thesis) | Inclusion criteria | Non-inclusion criteria |
|---|---|---|---|---|
| P1 | Judges (civil courts, specialised judges), financial regulators (junior and senior), auditors (financial jurisdiction and private firms) | 120, i.e. 6 strata of 20 | Current practice in the category, institution's agreement, written consent | Involvement in stimulus design, direct hierarchical link with the interviewer |
| P2 | Experts in law, regulation, audit or applied cryptography | 20 (Delphi), 5 to 10 (MDS) | At least ____ years of experience **[to be decided by the team]** | Participation in P1 in the same wave **[to be decided by the team]** |

Recruitment goes through the institutions that have signed an agreement ([convention_institution_partenaire_en.md](convention_institution_partenaire_en.md)). The institution circulates the invitation without naming participants. Participation is neither imposed nor known to management beyond the contact person. No participant is a minor.

## 4. Procedure

P1 has five phases per participant (thesis, §4.2.1.3), described in the following table.

| Phase | Content | Duration |
|---|---|---|
| 0 | Initial training in basic cryptographic notions | 2 h |
| 1 | Main session, 10 contexts with a 30-item questionnaire each | 4 h (breaks included) |
| 2 | Test-retest on 3 contexts at D+14 | 1 h |
| 3 | Gold standard set by two expert cryptographers (no participants) | not applicable |
| 4 | Debriefing and feedback | 30 min |

P2 consists of remote Delphi questionnaires (up to four rounds) and a context-similarity judgement session for the MDS panel. The indicative duration is ____ min per Delphi round and ____ h for the MDS session **[to be decided by the team]**.

The stimuli are fictitious cases. Some deliberately contain anomalies (invalid proof, revoked certificate, altered tally). Participants are told so in the information sheet without knowing which ones. The committed message $m$ is not disclosed during the session. It is revealed at debriefing. This is not deception, since no false information is given about the nature of the study.

## 5. Risks, burdens and benefits

| Risk | Level | Mitigation |
|---|---|---|
| Harm to professional reputation if individual performance became known | Minimal | Pseudonymisation at collection, no individual result passed to the institution, aggregated feedback per stratum of at least ____ persons **[to be decided by the team]** |
| Fatigue during the 4-hour session | Minimal | Breaks of at least 10 min every 60 min **[to be decided by the team]**, option to split into two half-days |
| Discomfort with technical notions | Minimal | Prior 2-hour training, no grading, reminder that no personal "right answer" is expected |
| Indirect re-identification through the combination of stratum and institution | Low | Profile variables in classes, no institution name in analysis data, dissemination threshold per cell |

The direct benefits are the 2-hour training in cryptographic notions and the collective feedback. The indirect benefit is new knowledge on the institutional admissibility of cryptographic evidence.

The overall level of risk is considered minimal.

## 6. Consent

Free and informed written consent, obtained before phase 0 using the [information sheet and consent form](notice_information_consentement_en.md). A reflection period of at least ____ days **[to be decided by the team]** separates handing over the sheet and signing. Consent is obtained by the interviewer without any hierarchical superior present.

## 7. Right to withdraw

Participants may stop at any time without justification and without consequence. They may request destruction of their data until the final anonymisation date, set at ____ months after their last session **[to be decided by the team]**. After that date the linking table is destroyed and the data can no longer be traced back to them.

## 8. Confidentiality and data management

- Pseudonymisation at collection with a code of the form `P1-JG-007` (see [fiche_recrutement_stratification_en.md](fiche_recrutement_stratification_en.md)).
- Code–identity linking table kept on an encrypted medium, separate from the data, accessible only to the principal investigator.
- Profile questionnaire without identifying data ([questionnaire_profil_participant_en.md](questionnaire_profil_participant_en.md)).
- Confidentiality undertaking signed by every interviewer and expert ([engagement_confidentialite_en.md](engagement_confidentialite_en.md)).
- Compliance with the Cameroonian framework for the protection of personal data (Law No. 2024/017 of 23 December 2024 **[reference to be checked by the team]**) and with Law No. 2010/012 of 21 December 2010 on cybersecurity and cybercrime.
- Sharing of anonymised data under CC BY 4.0 after anonymisation, according to the [data management plan](plan_gestion_donnees_en.md).

## 9. Compensation

The thesis sets no compensation. It is proposed **[to be decided by the team]** to reimburse travel costs on receipt, to provide refreshments during sessions and to pay a flat allowance of ____ FCFA to each participant who completes phase 1. The amount must remain modest enough not to be an undue inducement. A participant who withdraws keeps the share corresponding to the sessions attended.

## 10. Attachments

☐ Detailed protocol (P1: [../P1_delta/protocole_en.md](../P1_delta/protocole_en.md); P2: [../P2_entropie_contexte/protocole_en.md](../P2_entropie_contexte/protocole_en.md))
☐ Information sheet and consent form
☐ Questionnaires and collection forms
☐ Template institutional agreement
☐ Confidentiality undertaking
☐ Data management plan
☐ Principal investigator's CV
☐ Institutions' letters of agreement (to be attached once obtained)

Principal investigator's signature: ____________________ Date: ___ / ___ / ______

Supervisors' endorsement: ____________________ Date: ___ / ___ / ______
