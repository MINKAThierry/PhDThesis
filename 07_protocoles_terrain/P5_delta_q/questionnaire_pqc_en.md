# Verdict extraction questionnaire, PQC context (P5)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.5.2 (“questionnaires adapted to the NIST PQC context”) and §4.2.5.3, phases 1 and 2

[Version française](questionnaire_pqc_fr.md) · [P5 protocol](protocole_en.md) · [P1 questionnaire](../P1_delta/questionnaire_extraction_verdict_en.md)

The questionnaire is shorter than the P1 one. It only collects the variables of the [P5 template](gabarit_sessions_pqc_en.csv), namely verdict, confidence and time, for each item, aid modality and noise condition. The P1 dimension items are not reused **[to be decided by the team]**. It is administered on the verification interface ([specification](specification_interface_verification_en.md)) or, failing that, on paper. The language of administration is French. This English version is a working translation.

## Interviewer section (pre-filled by the interface)

| Field | Template variable |
|---|---|
| Participant code `P5-___-___` and stratum | `participant_id`, `stratum` |
| Scheme ☐ ML-DSA-65 ☐ SLH-DSA | `scheme` |
| Stimulus `___-C__`, context | `stimulus_id`, `context_id` |
| Signature variant `___-C__-S_` | `proof_id`, `sigma_code` |
| Committed message `___-C__-M_` (**do not show**) | `message_m` |
| Phase and condition ☐ 1 ☐ 2, condition ☐ A ☐ B ☐ C ☐ D, $p =$ ____ | `session`, `noise_condition`, `p_noise` |
| Display and validation times | `time_s` |

## Phase 1. One item = two screens

### Screen 1, without aid (`aid = 0`)

The participant reads the file (situation and technical extract of the signature).

**Q1.** If this file were submitted to you in your duties, what decision would you take? One answer only. The four labels come from the stimulus sheet (templates A, B or C of P1).

☐ 1 ______ ☐ 2 ______ ☐ 3 ______ ☐ 4 ______

**Q2.** Your confidence in this decision (0 none, 10 complete certainty).

0 — 1 — 2 — 3 — 4 — 5 — 6 — 7 — 8 — 9 — 10

### Screen 2, with aid (`aid = 1`)

The interface shows the interpretation aid sheet for the scheme ([catalogue, section 4](stimuli/catalogue_stimuli_pqc_en.md#4-interpretation-aid-sheet-handed-out-in-phase-1-after-the-first-verdict)). The file remains visible. The first verdict can no longer be changed.

**Q1'.** After reading the sheet, what decision would you take? You may keep the same one.

☐ 1 ______ ☐ 2 ______ ☐ 3 ______ ☐ 4 ______

**Q2'.** Your confidence in this decision.

0 — 1 — 2 — 3 — 4 — 5 — 6 — 7 — 8 — 9 — 10

### Attention check (one item in three, drawn at random)

**QA.** Without going back to the file, what type of situation was it? ☐ transaction ☐ document ☐ compliance ☐ other

A failure is entered in `notes` as `ATT:0`. A correct answer is entered as `ATT:1`.

## Phase 2. One item = one screen per condition

The file is presented with the verification result displayed by the simulated quantum verifier. The screen states the condition in plain words, for example “simulated verifier, channel error rate 0.5 %” **[display of the rate to be decided by the team]**.

**Q1.** What decision would you take? ☐ 1 ☐ 2 ☐ 3 ☐ 4
**Q2.** Your confidence in this decision. 0 to 10
**Q3.** Does the displayed verification result seem reliable to you? 0 (not at all) to 10 (completely). Entered in `notes` as `FIA:n`.

## Data entry rules

| Column | Content |
|---|---|
| `aid` | `0` screen without aid, `1` screen with aid, `NA` in phase 2 |
| `noise_condition`, `p_noise` | `A` and `0` in phase 1; condition and value of $p$ in phase 2 |
| `verdict` | code 1 to 4 |
| `gold_verdict` | gold-standard verdict for the same stimulus, message and condition |
| `interpretation_error` | `1` if `verdict` ≠ `gold_verdict`, `0` otherwise, computed at analysis (`p5.interpretation_errors`) |
| `confidence_0_10`, `time_s` | answer Q2 and screen time |
| `session` | `1` phase 1, `2` phase 2, `3` test-retest |
| `notes` | codes `ATT:`, `FIA:`, displayed result `AFF:ok` or `AFF:echec` in phase 2, incidents |

One row per screen. A phase 1 item therefore gives two rows.

Licence CC BY 4.0.
