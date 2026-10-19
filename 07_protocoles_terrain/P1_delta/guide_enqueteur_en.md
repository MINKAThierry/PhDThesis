# Interviewer guide (P1)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.1.3 (phases 0 to 4) and §4.2.1.4 (decision times and confidence)

[Version française](guide_enqueteur_fr.md) · [P1 protocol](protocole_en.md) · [Folder README](README_en.md)

This guide describes, step by step, how to prepare and run the P1 sessions. It supplements the protocol without changing it. Times and numbers not fixed by the thesis are proposals **[to be decided by the team]**.

## 1. Role of the interviewer

The interviewer runs the sessions, hands out the documents in the planned order, records times and logs every incident. The interviewer never gives an opinion on a file. The interviewer does not know the quantitative hypotheses of the study (the predicted values of $\Delta$) **[to be decided by the team]**.

Before the first session, the interviewer has
☐ signed the [confidentiality undertaking](../00_commun/engagement_confidentialite_en.md)
☐ run a complete dry session (phases 0 and 1) with the coordinator
☐ read this guide, the [questionnaire](questionnaire_extraction_verdict_en.md), the [training material](support_formation_phase0_en.md) and the [session log](../00_commun/journal_session_en.md)

## 2. Preparing the session (the day before)

1. Obtain from the coordinator the list of participants (codes only) and, for each, the rotation list (1 to 5) and the presentation order of the 10 contexts.
2. Prepare, for each participant, one envelope per context. Each envelope holds the file of the assigned variant and a questionnaire whose interviewer section is filled in. The envelope bears the participant code and the presentation rank.
3. Check that the “committed message” label has been detached from the questionnaires handed to the participant and kept separately.
4. Prepare the consent forms (two copies per participant), the profile questionnaires, the session log, blank deviation forms and a clock visible to the interviewer only.
5. Check the room (one seat per participant, enough spacing to prevent reading a neighbour's file).

| Item | Quantity per participant |
|---|---|
| Information sheet and consent form | 2 |
| Profile questionnaire | 1 |
| Context envelopes (file and questionnaire) | 10 |
| Training trial questionnaire | 1 |

## 3. Welcome and consent

1. Welcome the participants, recall the total duration and the right to withdraw at any time.
2. Hand out the [information sheet](../00_commun/notice_information_consentement_en.md), allow time to read it, answer questions, collect the signed consent. No participant starts without a signed consent.
3. Hand out the [profile questionnaire](../00_commun/questionnaire_profil_participant_en.md).
4. Record in the log, for each participant, the arrival time and the rotation list number.

## 4. Phase 0, training (2 h)

Follow the [training material](support_formation_phase0_en.md) word for word. Record the start and end times. Unforeseen questions and their answers are recorded in the log.

Phase 0 takes place on the same day as phase 1 or the day before **[to be decided by the team]**. If on the same day, a break of at least 30 min separates them.

## 5. Phase 1, main session (4 h)

### 5.1 Proposed timetable

| Relative time | Activity |
|---|---|
| 0:00 | Reading of the instructions (section 5.2) |
| 0:05 | Contexts of rank 1 to 4 (about 20 min each) |
| 1:25 | Break 1 (15 min) |
| 1:40 | Contexts of rank 5 to 7 |
| 2:40 | Break 2 (15 min) |
| 2:55 | Contexts of rank 8 to 10 |
| 3:55 | Collection, thanks, phase 2 appointment |

The pace of 20 min per context is indicative. Each participant works at their own pace, with no time limit per context. A participant who finishes early waits in silence. The interviewer never hurries anyone.

### 5.2 Instructions to read

> “You will examine ten files, one per envelope, in the order of the numbers. For each file, read the situation and the item, then fill in the questionnaire. When you have finished a file, raise your hand. I will take back the envelope and give you the next one. You cannot go back to a file already returned. There is no right or wrong answer. Answer as you would in your duties. Please do not talk to each other during the session.”

### 5.3 For each context

1. Hand out the envelope of rank $k$ and record the time to the second (log, section 4).
2. When the hand is raised, take back the envelope, record the return time, check without reading it that the questionnaire is filled in (no blank page). Do not comment on the answers.
3. Hand out the next envelope.

The decision time `time_s` is the difference between the two times. It includes reading the file.

### 5.4 Incidents

| Incident | What to do |
|---|---|
| Question on the substance of a file | “Answer with the elements of the file and your practice.” |
| Participant wants to go back to a file | decline politely, record in the log |
| Exchange between participants | recall the instruction, record the codes and the rank concerned, deviation form |
| Wrong envelope (wrong variant or wrong rank) | let the participant finish, record, deviation form, report to the coordinator the same day |
| Discomfort or fatigue | offer a break, record its duration. The participant may stop at any time. |
| Participant withdraws | accept without asking for a reason, hand out the withdrawal form, record the time |
| External interruption | record the duration and the participants concerned |

Any deviation from the protocol gives rise to a [deviation form](../00_commun/fiche_ecart_protocole_en.md), numbered `ECART-NNNN`, recorded in the variable `deviation_id`.

## 6. Phase 2, test-retest (1 h, at D+14)

Follow the [test-retest form](fiche_test_retest_en.md) prepared by the coordinator. The interviewer does not look at the participant's phase 1 answers. The questionnaire carries `phase = 2`.

## 7. Phase 4, debriefing (30 min)

Follow the [debriefing form](fiche_debriefing_en.md). The debriefing takes place at the end of phase 2, never before.

## 8. After each session

1. Count the questionnaires and match them with the envelopes handed out.
2. Put consent forms and questionnaires in separate sealed envelopes, handed to the coordinator the same day ([data management plan](../00_commun/plan_gestion_donnees_en.md)).
3. Hand in the signed session log and any deviation forms.
4. Keep no copy, photograph or personal note.

## 9. Data entry

Data are entered by two independent operators in the [data template](gabarit_donnees_en.csv), then the two entries are compared **[double entry to be decided by the team]**. The entry rules are given at the end of the [questionnaire](questionnaire_extraction_verdict_en.md#data-entry-and-checking-rules). The variables `attention_failures` and `excluded` are computed by the analysis script and not entered by hand.

Licence CC BY 4.0.
