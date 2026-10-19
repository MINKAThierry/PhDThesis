# Reliability grid (P4, step 6)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.4, step 6 (“validation, ICC $\geq 0.8$, $\kappa \geq 0.7$”)

[Version française](grille_fiabilite_fr.md) · [P4 protocol](protocole_en.md) · [Analysis plan, section 7](../00_commun/plan_analyse_statistique_en.md#7-reliability)

Grid filled in by the analyst from the outputs of `cro_terrain.p4.estimation_conjointe` (step 6). It documents the data used, the values obtained and the decision. One grid per institution and per verdict level.

## 1. Data used

| Field | Value |
|---|---|
| Institution | `INST-__` |
| Verdict level | ☐ overall ☐ item vector |
| Main session / retest session | `1` / `2` (median actual delay ____ days) |
| Participants with at least one retest item | ____ |
| Item pairs (session 1, session 2) | ____ |
| ICC variable | ☐ confidence 0 to 10 ☐ mean score of the dimension items |
| Strata for the inter-rater $\kappa$ | ______ |
| Pairs of participants with at least 5 common stimuli | ____ |

A retest item is identified by (participant, context, proof, variant $\sigma$) and must appear only once per session. A common stimulus for the inter-rater $\kappa$ is identified by (context, proof), whatever variant was shown.

## 2. Results

| Statistic | Value | Threshold (thesis) | Met |
|---|---|---|---|
| Test-retest ICC(2,1), absolute agreement | ______ | $\geq 0.8$ | ☐ yes ☐ no ☐ not computable |
| Inter-rater Cohen's $\kappa$, mean over pairs | ______ | $\geq 0.7$ | ☐ yes ☐ no ☐ not computable |
| Test-retest Cohen's $\kappa$ on the verdict | ______ | reported | |
| Inter-rater Fleiss' $\kappa$ (complement) | ______ | reported | |

## 3. Reading by stratum (descriptive)

| Stratum | ICC | Inter $\kappa$ | Retest $\kappa$ | Remark |
|---|---|---|---|---|
| | | | | |
| | | | | |
| | | | | |

## 4. Decision

☐ **Satisfactory reliability.** Both thresholds are met. $\hat\Delta$ and $\hat\alpha$ may be used to apply the refutation criteria.
☐ **Insufficient reliability.** At least one threshold is not met. The estimates are reported with this mention and are not used to apply the refutation criteria.
☐ **Reliability not computable.** No retest or no common stimulus. Same consequence as insufficient reliability. The cause is given below.

Cause or comment ______________________________________________

## 5. Interpretation leads to record

Do not correct the data. Record only what helps reading the results.

☐ Retest delay outside tolerance for some participants (deviation forms `ECART-____`)
☐ Participants who recognised the files at retest (closing question of the P1 test-retest form)
☐ Stimuli judged ambiguous at debriefing
☐ Other: ______________________

Analyst ______ on ___ / ___ / ______. Reviewed by ______.

Licence CC BY 4.0.
