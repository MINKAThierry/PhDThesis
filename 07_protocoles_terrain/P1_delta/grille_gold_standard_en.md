# Gold standard grid (P1, phase 3)

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.1.3, phase 3 (“two independent expert cryptographers give the correct verdicts, inter-rater agreement required ≥ 90 %”)

[Version française](grille_gold_standard_fr.md) · [P1 protocol](protocole_en.md) · [Stimulus catalogue](stimuli/catalogue_stimuli_en.md)

The gold standard provides, for each of the 200 variants (50 pairs × 4 variants), the reference verdict and the reference answers to the 22 dimension items. It is used for accuracy analyses and for checking the stimuli. It plays no part in the computation of $\hat\Delta = \hat I(V;\Sigma\mid M,C)$, which relies on the participants' answers and on the ground truth $m$.

## 1. Experts

| Role | Code | Required profile | Confidentiality undertaking signed |
|---|---|---|---|
| Expert A | `GS-A` | cryptographer, PhD or equivalent experience **[to be decided by the team]** | ☐ |
| Expert B | `GS-B` | cryptographer, independent of expert A (no recent joint publication, no line-management link) | ☐ |
| Arbiter | `GS-ARB` | cryptographer or digital-law specialist, called on only in case of disagreement | ☐ |

The experts take part neither in writing the stimuli nor in the sessions. They sign the [confidentiality undertaking](../00_commun/engagement_confidentialite_en.md).

## 2. Procedure

1. The experts receive the complete stimulus sheets (parts 1 to 5), including the message $m$ and the full proof values.
2. Each expert fills in, alone and without contact with the other, one answer sheet per variant (section 3). The reference implementation is available to check the proofs.
3. The coordinator computes agreement on Q01 and on the dimension items (section 4).
4. Disagreements go to the arbiter, who decides after reading both justifications. The consensus is recorded with the code `CONSENSUS`.
5. A pair whose agreement stays below 90 % after arbitration is excluded from accuracy analyses (pre-registration, section 8).

The gold standard is established before phase 1, on the stimuli alone. The experts thus have no access to the participants' answers **[to be decided by the team]**.

## 3. Expert answer sheet (one per variant)

| Field | Value | Variable |
|---|---|---|
| Expert | ☐ `GS-A` ☐ `GS-B` ☐ `GS-ARB` | `gs_expert_id` |
| Pair | `___-C__` | `stimulus_id` |
| Proof variant | `___-C__-S_` | `proof_sigma_id` |
| Committed message | `___-C__-M_` | `message_m_id` |
| Proof verification redone by the expert | ☐ accepted ☐ rejected | check |
| Reference verdict (Q01, 1 to 4) | ____ | `gs_verdict_v` |

Reference answers to the dimension items (0 to 7, same scale as the questionnaire)

| Q02 | Q03 | Q04 | Q05 | Q06 | Q07 | Q08 | Q10 | Q11 | Q12 | Q13 |
|---|---|---|---|---|---|---|---|---|---|---|
| __ | __ | __ | __ | __ | __ | __ | __ | __ | __ | __ |

| Q14 | Q15 | Q16 | Q17 | Q19 | Q20 | Q21 | Q22 | Q23 | Q24 | Q25 |
|---|---|---|---|---|---|---|---|---|---|---|
| __ | __ | __ | __ | __ | __ | __ | __ | __ | __ | __ |

Variables `gs_q02` to `gs_q25` (without Q09 and Q18).

**Answering rule.** The expert answers what the file handed to the participant allows one to establish. The expert does not answer from knowledge of the message $m$. The expert also states below whether the answer would have differed with knowledge of $m$.

☐ My answer is the same for M1 and M2 ☐ It differs on the following items: ____________

Justification in three lines at most

______________________________________________________________________
______________________________________________________________________
______________________________________________________________________

Date ___ / ___ / ______ Initials ______

## 4. Agreement computation

| Indicator | Definition | Threshold |
|---|---|---|
| Agreement on Q01 | share of the 200 variants where `GS-A` and `GS-B` give the same verdict | $\geq 90\,\%$ (thesis) |
| Agreement on items | share of identical (variant, item) pairs, over 200 × 22 answers | $\geq 90\,\%$ **[threshold to be confirmed for items]** |
| Cohen's $\kappa$ on Q01 | reported as a complement | no threshold |

Agreement is computed before arbitration. The following table summarises the result by proof type.

| Type | Variants | Agreements Q01 | % | Variants arbitrated | Pairs excluded |
|---|---|---|---|---|---|
| ECD | 40 | | | | |
| HEL | 40 | | | | |
| G16 | 40 | | | | |
| PSS | 40 | | | | |
| EGC | 40 | | | | |
| **Total** | **200** | | | | |

## 5. Check of the stimulus construction rule

The template requires the two messages of a pair to be compatible with the file. If an expert states, for a pair, that the answer differs between M1 and M2 **from reading the file alone**, the pair is reported to the coordinator. It is then revised before data collection, or declared in a [deviation form](../00_commun/fiche_ecart_protocole_en.md).

Licence CC BY 4.0.
