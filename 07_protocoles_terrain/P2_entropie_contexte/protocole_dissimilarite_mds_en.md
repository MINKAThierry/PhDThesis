# Dissimilarity judgement protocol (P2, MDS approach)

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.2.3 (100 contexts, panel of 5 to 10 experts, pairwise similarity ratings, MDS, $V_{\text{eff}} = \det(\hat\Sigma)^{1/2}$)

[Version française](protocole_dissimilarite_mds_fr.md) · [P2 protocol](protocole_en.md) · [Corpus of the 100 contexts](corpus_contextes_en.md)

## 1. Administration plan

| Element | Proposal **[to be decided by the team]** |
|---|---|
| Experts | 5 to 10 (thesis), at least 2 per profile |
| Pairs judged | all pairs within a domain, i.e. 561 (`ELEC`), 528 (`FIN`) and 528 (`CONT`) |
| Sessions | three per expert, one per domain, of about 1 h 30, at least 48 h apart |
| Order of domains | permuted across experts (6 possible orders) |
| Order of pairs | drawn at random for each expert and each session, seed recorded |
| Order within a pair | drawn at random (context $i$ shown on the left or on the right) |
| Repeated pairs | 25 pairs per session, drawn at random, shown a second time at the end of the session to measure stability |
| Medium | offline electronic form recommended, paper booklet as fallback |

A judgement takes about 8 s once the instruction is understood. The 553 judgements of a session (528 pairs and 25 repetitions) therefore take about 75 min, plus welcome, practice and break.

## 2. Scale

Each pair is rated on a scale from 0 to 10.

| Value | Meaning |
|---|---|
| 0 | The competent institution would handle the two contexts in exactly the same way. |
| 5 | The two contexts have important points in common but call for different handling in several respects. |
| 10 | The two contexts have almost nothing in common in how they are handled, although they belong to the same domain. |

Dissimilarity concerns **how an institution would handle the case**, not the wording of the texts.

The unit used to compute $V_{\text{eff}}$ (for example one step of the scale) must be fixed before data collection. It directly determines the level of the estimate ([P2 protocol](protocole_en.md#8-caveats), point 1).

## 3. Session procedure

| Duration | Step |
|---|---|
| 5 min | Welcome, reminder of the right to withdraw, reading of the instructions (section 4) |
| 5 min | Six practice pairs drawn from another domain, not recorded |
| 35 to 40 min | First half of the pairs |
| 5 min | Break |
| 35 to 40 min | Second half of the pairs, then the 25 repeated pairs |
| 2 min | Closing question (section 5) |

The interviewer records the session in the [session log](../00_commun/journal_session_en.md) (protocol P2, MDS session).

## 4. Instructions read to the expert

> “Two short descriptions of situations will appear side by side. They all belong to the same domain. For each pair, indicate how differently the competent institution would handle the two situations, from 0 (exactly the same way) to 10 (almost nothing in common). Answer quickly, without trying to justify. There is no right answer. Some pairs will come back at the end of the session. Answer them as if you were seeing them for the first time.”

## 5. Closing question

“Which aspects of the situations guided your judgements most?” Free answer, recorded by the interviewer. It is used to interpret the MDS dimensions.

## 6. Fallback paper booklet (one page per series of 20 pairs)

| Expert code `P2-EX-__` | Session `S-____` | Domain ☐ ELEC ☐ FIN ☐ CONT | Page ___ / ___ |
|---|---|---|---|

| Rank | Left context | Right context | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ___ | `CTX-___` | `CTX-___` | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| ___ | `CTX-___` | `CTX-___` | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| ___ | `CTX-___` | `CTX-___` | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |

The booklet reproduces opposite each pair the full text of the two contexts, taken from the [corpus](corpus_contextes_fr.md).

## 7. Data entry

One row per judgement in [gabarit_dissimilarite_en.csv](gabarit_dissimilarite_en.csv). Repeated pairs are entered with their own presentation rank. They are used for the stability measure and are not averaged with the first answer **[to be decided by the team]**.

| Column | Content |
|---|---|
| `expert_id` | `P2-EX-NN` |
| `session_id` | `S-NNNN` |
| `domain` | `ELEC`, `FIN` or `CONT` |
| `ctx_i_id`, `ctx_j_id` | codes of the two contexts, in display order |
| `presentation_rank` | 1 to 553 (or 586 for `ELEC`), repetitions included |
| `dissimilarity_0_10` | rating from 0 to 10 |
| `notes` | incident, reported hesitation |

## 8. Quality checks

| Indicator | Computation | Proposed threshold **[to be decided by the team]** |
|---|---|---|
| Within-expert stability | Spearman correlation between the two answers to the 25 repeated pairs | ≥ 0.7 |
| Between-expert agreement | ICC(2,1), absolute agreement, on the common pairs | ≥ 0.8 (common threshold of the programme) |
| Mechanical answering | share of identical consecutive ratings beyond 20 | flag |

An expert whose stability is below the threshold is flagged. Their judgements are kept in the main analysis and removed in a sensitivity analysis.

## 9. Analysis

Mean matrix per domain (`cro_terrain.p2.dissimilarity_matrix`), choice of the number of dimensions using the registered stress threshold (`p2.choose_dimensions`), estimate $\log_2 V_{\text{eff}}$ (`p2.mds_entropy`) and interval by bootstrap over experts (`p2.mds_entropy_bootstrap`). The retained dimensions are compared with the levels of the grid elements, given for each context in [corpus_contextes.csv](corpus_contextes.csv).

Licence CC BY 4.0.
