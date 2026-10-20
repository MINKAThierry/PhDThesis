# Verdict extraction questionnaire (P1)

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.1.2 (“30-item questionnaires per context”) and §4.2.1.3, phase 1, steps (c) and (d)

[Version française](questionnaire_extraction_verdict_fr.md) · [P1 protocol](protocole_en.md) · [Variable dictionary](../00_commun/dictionnaire_variables_en.md)

One copy per participant and per context presented, i.e. 10 copies in phase 1 and 3 in phase 2. The form carries no name. Item codes (Q01 to Q30) are those of the variable dictionary, dataset D4.

The thesis calls this questionnaire “validated”. The present version has not yet been pre-tested. The wording of the items, their number per section and the order of the sections are proposals **[to be decided by the team after pre-test]**.

The language of administration is French. This English version is a working translation for readers of the repository.

---

## Interviewer section

The interviewer fills in these fields before handing out the form. The participant does not see them, except the stimulus code printed in the header.

| Field | Value | Variable |
|---|---|---|
| Participant code | `P1-____-___` | `participant_id` |
| Phase | ☐ 1 main session ☐ 2 test-retest D+14 | `phase` |
| Session | `S-____` | `session_id` |
| Interviewer | `ENQ-__` | `interviewer_id` |
| Stimulus (context–proof pair) | `___-C__` | `stimulus_id` |
| Proof variant presented | `___-C__-S_` | `proof_sigma_id` |
| Committed message (ground truth, **do not show**) | `___-C__-M_` | `message_m_id` |
| Presentation rank in the session | ____ | `presentation_rank` |
| Stimulus domain (for Q28) | ☐ 1 contract ☐ 2 election ☐ 3 financial control ☐ 4 other | check of `q28_attention` |
| Time the context was handed out | __:__:__ | computation of `time_s` |
| Time the completed form was returned | __:__:__ | computation of `time_s` |

The committed message appears here for data entry. It is printed on a detachable label that the interviewer removes before handing the form to the participant **[procedure to be decided by the team]**.

---

## Instructions to the participant

You have just read a file made of a description of a situation (the context) and a cryptographic item (the proof). Answer as you would in the exercise of your duties, relying only on the file and on your professional practice. There is no right or wrong answer, and your answers will never be reported to your institution.

For items Q02 to Q25, tick one box per line.

- **1** means “not at all established” and **7** “fully established”.
- **0** means “cannot be determined from the file”.

Do not go back to a previous context. When you have finished, turn the sheet over and raise your hand.

---

## Section A. Overall verdict

**Q01.** If this file were submitted to you in your duties, what decision would you take? Tick one answer only. The four possible decisions are copied from the stimulus sheet and depend on the domain (template A, B or C of the [stimulus sheet](stimuli/gabarit_fiche_stimulus_en.md#4-verdict-space)).

☐ 1 ______________________________________________
☐ 2 ______________________________________________
☐ 3 ______________________________________________
☐ 4 ______________________________________________

Variable `verdict_v`.

## Section B. What the proof establishes

| Code | Item | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|---|---|
| Q02 | The item comes from the person or body named in the file. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q03 | The content covered by the item has not been modified since the item was produced. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q04 | The item does relate to the act or operation described in the context. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q05 | The time at which the act was performed is established. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q06 | The named author could not credibly deny being the origin of the item. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q07 | The author of the item was authorised to perform the act. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q08 | The item alone, without any other element of the file, establishes the facts it concerns. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q09 | Reading check. On this line, tick box 3. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |

## Section C. What the file allows one to infer

| Code | Item | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|---|---|
| Q10 | The will or consent of the author at the time of the act is established. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q11 | The act complies with the applicable rule (contract clause, electoral code, regulation). | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q12 | No substitution of identity or key took place. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q13 | The value at stake (amount, choice, quantity) is correct. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q14 | The information the item was meant to keep secret has remained secret. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q15 | The act was not performed twice (double vote, double payment, double commitment). | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q16 | The internal procedures of the issuing institution were followed. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q17 | The content committed by the item, which does not appear in clear in the file, can be inferred. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q18 | Reading check. On this line, tick box 0. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |

## Section D. Institutional scope

| Code | Item | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|---|---|
| Q19 | The item would be admissible before your institution. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q20 | The item has sufficient probative value to ground a decision. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q21 | The burden of proving the contrary would lie with the party challenging the item. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q22 | A precedent or an established practice of your institution applies to this case. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q23 | The item would withstand a technical challenge before your institution. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q24 | The item changed the decision you would have taken without it. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q25 | A colleague from your institution would reach the same decision as you. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |

All items Q02 to Q25 point in the same direction. No recoding is needed for the mean score used by the test-retest ICC ([analysis plan](../00_commun/plan_analyse_statistique_en.md), section 7).

## Section E. Confidence and elements relied on

**Q26.** How confident are you in the decision given in Q01? Circle a number (0 no confidence, 10 complete certainty).

0 — 1 — 2 — 3 — 4 — 5 — 6 — 7 — 8 — 9 — 10

Variable `confidence_0_10`.

**Q27.** In your decision, what share is due to the cryptographic item rather than to the rest of the file? (0 none, 10 decision entirely based on the item)

0 — 1 — 2 — 3 — 4 — 5 — 6 — 7 — 8 — 9 — 10

Variable `q27_proof_contribution`.

**Q28.** Without looking back at the file, what domain did the situation concern?

☐ 1 a contract or an act between parties ☐ 2 an election or a vote ☐ 3 a financial control ☐ 4 another domain

Variable `q28_attention`. The expected answer is the domain recorded on the stimulus sheet.

**Q29.** To give a final decision, would you request additional expertise?

☐ 0 no ☐ 1 technical expertise ☐ 2 legal expertise ☐ 3 both

Variable `q29_expertise`.

**Q30.** Which elements did you mainly rely on? Several answers possible.

☐ 1 the description of the situation
☐ 2 the cryptographic item itself (values, formats)
☐ 3 the verification result stated in the file
☐ 4 your legal or regulatory knowledge
☐ 5 the practice of your institution
☐ 6 notions seen during the training (phase 0)
☐ 7 your intuition or general experience
☐ 8 other: ______________________

Variable `q30_elements` (codes separated by `;`).

---

## Data entry and checking rules

| Situation | Entry |
|---|---|
| One box ticked | code of the box |
| No box ticked | empty cell (no answer) |
| Several boxes ticked on Q01 to Q29 | empty cell and note in the `remarks` of the session log |
| Q09 other than 3, Q18 other than 0, Q28 other than the domain | one failure each, summed in `attention_failures` |
| At least 2 failures out of 3 for this context | `excluded = 1` (pre-registration, section 8) |

The time `time_s` is the difference, in seconds, between the time the completed form was returned and the time the context was handed out. It includes reading the file, in line with step (d) of phase 1.

## Link with the quantities of the thesis

- $V_{\text{glob}}$ is the answer to Q01. $V$ is the vector (Q01, Q02 to Q25 without Q09 and Q18), i.e. 23 components ([analysis plan](../00_commun/plan_analyse_statistique_en.md), section 1).
- $|\mathcal{V}_{\text{glob}}| = 4$, which gives $\log_2|\mathcal{V}_{\text{glob}}| = 2$ bits in $\hat\alpha = \log_2|\mathcal{V}|/H(C)$. The verdict level used for $\hat\alpha$ must be fixed before data collection.
- Q17 directly targets the extraction of information on the committed message $m$. It does not replace the estimator $\hat\Delta = \hat I(V;\Sigma\mid M,C)$, which is computed from the answers and the ground truth.
- Q26 and `time_s` are used to detect random answers (thesis, §4.2.1.4).

Licence CC BY 4.0.
