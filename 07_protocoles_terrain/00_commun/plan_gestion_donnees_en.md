# Data management plan

> **Status: PROPOSAL: protocol not deployed** · Source: thesis, Chapter 4, §4.2.1, §4.2.2, §4.2.4 and §4.2.8.3

[Version française](plan_gestion_donnees_fr.md)

This plan covers P1 and P2. It applies to the other protocols once their variables are added to the [variable dictionary](dictionnaire_variables_en.md). Durations and tools flagged [to be decided by the team] are proposals.

## 1. Data produced

| Category | Content | Format | Identifiability | Estimated volume |
|---|---|---|---|---|
| D1 Linking | Code–identity table, contact details | encrypted file | named | about 140 rows |
| D2 Consents | Signed forms | paper, then encrypted scan | named | about 140 forms |
| D3 Profile | Answers to the [profile questionnaire](questionnaire_profil_participant_en.md) | CSV | pseudonymised | 140 rows |
| D4 P1 answers | Verdicts, confidence, times (template [../P1_delta/gabarit_donnees_en.csv](../P1_delta/gabarit_donnees_en.csv)) | CSV | pseudonymised | 120 × 10 contexts in phase 1, 120 × 3 in phase 2 |
| D5 Gold standard | Verdicts of experts `GS-A`, `GS-B`, `GS-ARB` | CSV | pseudonymised | 50 stimuli |
| D6 P2 answers | Decomposition, dissimilarity judgements, Delphi rounds (templates in [../P2_entropie_contexte/](../P2_entropie_contexte/README_en.md)) | CSV | pseudonymised | 20 experts |
| D7 Stimuli | Stimulus sheets, catalogue, ground truth $m$ | Markdown, PDF, CSV | no personal data | 50 pairs |
| D8 Collection metadata | Session logs, deviation forms | PDF, CSV | pseudonymised | as needed |
| D9 Results | Estimates, intervals, analysis code | CSV, Python | anonymous | small |

## 2. Collection and data entry

- Entry on paper or on an offline electronic form. No foreign cloud service is used for data D1 to D6 **[to be decided by the team]**.
- Independent double entry of paper questionnaires by two operators, followed by automatic comparison. Discrepancies are resolved against the original and recorded.
- Consistency checks at entry (valid codes, values within dictionary ranges, mandatory fields).

## 3. Pseudonymisation

- The participant code is assigned at consent (format in [fiche_recrutement_stratification_en.md](fiche_recrutement_stratification_en.md)).
- Table D1 is the only link between code and identity. It is encrypted and stored on a medium separate from data D3 to D8, under the sole responsibility of the principal investigator.
- The institution's name does not appear in D3 to D6. Only the code `INST-__` does. The table of institution codes is handled like D1.
- Profile variables are collected in classes.

## 4. Storage and security

| Item | Proposed measure **[to be decided by the team]** |
|---|---|
| Main storage | Dedicated LIMSI server or workstation, encrypted disk (full-volume encryption), access through named accounts |
| Backups | Two encrypted copies on separate media, one outside the building, weekly backup during collection |
| Paper | Locked cabinet at LIMSI. Consent forms and questionnaires in separate cabinets |
| Access | D1 and D2 restricted to the principal investigator. D3 to D8 open to team members who signed the [confidentiality undertaking](engagement_confidentialite_en.md) |
| Transfer | Encrypted media only. No transfer by unencrypted email |
| Logging | Register of accesses and exports kept by the principal investigator |

## 5. Retention periods

| Data | Proposed period **[to be decided by the team]** | Final outcome |
|---|---|---|
| D1 linking table | Until the anonymisation date, i.e. ____ months after the participant's last session | Secure destruction, written record |
| D2 consents | ____ years after the end of the study | Secure destruction |
| D3 to D8 pseudonymised | Until the anonymisation date | Become anonymous through destruction of D1 |
| Anonymised data and D9 | Unlimited | Open archiving |

## 6. Anonymisation and sharing

1. Destruction of D1 at the anonymisation date.
2. Check of the re-identification risk on the combination of quasi-identifiers (stratum, seniority, supervisory duties, age class, sex, institution code). Proposed threshold: each published combination concerns at least 5 persons, otherwise classes are merged or the variable dropped **[to be decided by the team]**.
3. Removal of `INST-__` codes and free-text comment fields before release.
4. Deposit of the anonymised data, the variable dictionary and the stimuli in an open repository (OSF or Zenodo **[to be decided by the team]**) under **CC BY 4.0**, with a persistent identifier.
5. The analysis code is deposited under the MIT licence in the `analyse/` folder of the repository https://github.com/MINKAThierry/PhDThesis.

Stimuli and ground truth $m$ are published only after the closure of any collection using the same stimulus set.

## 7. Legal framework

Processing complies with the Cameroonian framework for the protection of personal data (Law No. 2024/017 of 23 December 2024 **[reference to be checked by the team]**), with Law No. 2010/012 of 21 December 2010 on cybersecurity and cybercrime and with the ethics committee's opinion. The data controller is the University of Yaoundé I (LIMSI, ENSP), represented by ____________________.

## 8. Responsibilities

| Role | Code or position | Responsibilities |
|---|---|---|
| Principal investigator | ____________________ | Custody of D1 and D2, access authorisation, anonymisation, deposit |
| Field coordinator | ____________________ | Quota tracking, collection of logs, transmission of questionnaires |
| Data-entry operators | ____________________ | Double entry, consistency checks |
| Analyst | ____________________ | Application of the [statistical analysis plan](plan_analyse_statistique_en.md) on pseudonymised data |

Version date: ___ / ___ / ______ Version: ____
