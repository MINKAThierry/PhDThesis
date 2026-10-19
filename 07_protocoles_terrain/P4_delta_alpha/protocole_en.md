# P4 — Standardised protocol for the joint estimation of $\Delta$ and $\alpha$

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.4 (algorithm `alg:estimation_conjointe`)

[Version française](protocole_fr.md) · [Folder README](README_en.md)

## 1. Purpose

The thesis requires the institutional parameters to be measured **independently** and **jointly** before any CRO prediction is computed (§4.2.4). P4 fixes the sequence, prerequisites and thresholds of this measurement, so that two teams applying the same steps to the same inputs obtain compatible estimates.

P4 is not a new field campaign. It applies:

- to the P1 data, of which it is the most complete implementation;
- to any other institution studied, with at least 30 participants.

## 2. Inputs and outputs

| | Content |
|---|---|
| Inputs | institution $I$, proof types, context $C$ |
| Outputs | $\hat\Delta$ in bits, $\hat\alpha$ dimensionless |
| Not covered | $\beta$. The thesis algorithm gives no estimator of $\beta$, and P4 does not compute it. |

## 3. Prerequisites (`Require` line of the algorithm)

The three prerequisites are entry conditions. They must be met **before** any data collection.

1. Prior institutional agreement.
2. Favourable opinion of a research ethics committee.
3. At least 30 participants. Below that, mutual-information estimators become unstable (thesis, §4.2.4).

Instrument: [prerequisite checklist](liste_controle_prerequis_en.md). The function `cro_terrain.p4.Prerequisites` applies the same check and reports it at the top of the analysis report.

## 4. The six steps

| Step | Content (thesis) | Proposed implementation | Instrument |
|---|---|---|---|
| 1 | Collection of verdicts, confidence scores and decision times | as in P1, one row per participant and per context–proof pair | [gabarit_verdicts_en.csv](gabarit_verdicts_en.csv), or the P1 data converted by `p4.p1_to_p4` |
| 2 | Matching each verdict with the message $m$, known to the experimenter only | `message_m` column filled at data entry from the ground truth | stimulus sheets |
| 3 | Admissibility test $V \perp M \mid (\Sigma, C)$ | conditional permutation test, threshold 0.01 | `statistics.admissibility_permutation_test` |
| 4 | $\hat\Delta \leftarrow \hat I(V;\Sigma\mid M,C)$ | Miller–Madow, 95 % CI by bootstrap over participants | `information.delta_hat` |
| 5 | $\hat\alpha \leftarrow \log_2|\mathcal{V}|/H(C)$, independently of $\hat\Delta$ | $|\mathcal{V}|$ counted in the institution's texts, $H(C)$ from P2 | [counting form](fiche_denombrement_verdicts_en.md), `information.alpha_hat` |
| 6 | Validation, ICC $\geq 0.8$ and $\kappa \geq 0.7$ | test-retest ICC on confidence, inter-rater $\kappa$ on the verdict | [reliability grid](grille_fiabilite_en.md), `reliability` |

The function `cro_terrain.p4.estimation_conjointe` chains the six steps and returns a report in which each step keeps its own status. A failing step remains visible and does not silently contaminate the following ones.

## 5. Notes on the steps

### 5.1 Step 3, admissibility

The test has power only in the strata $(\Sigma, C)$ in which $M$ takes at least two values. The number of informative strata is reported. If no stratum is informative, the result is “not testable with this coding of $\Sigma$”. This case is no evidence of admissibility.

When admissibility is rejected at the 0.01 level, $\hat\Delta$ is still computed but reported as not interpretable as an extraction capacity (criterion of `tab:criteres_refutation`).

### 5.2 Step 5, counting $|\mathcal{V}|$

The thesis computes $\hat\alpha$ from $\log_2|\mathcal{V}|$. P4 proposes to count $\mathcal{V}$ in the texts governing the institution (code of procedure, regulation, control framework). The observed verdicts are not used, since they depend on the sample. The [counting form](fiche_denombrement_verdicts_en.md) is filled in by two independent people, one a lawyer and the other a member of the institution.

The verdict level must match that of step 4. With the overall verdict of P1, $|\mathcal{V}| = 4$ and $\log_2|\mathcal{V}| = 2$ bits. The choice between overall verdict and item vector is registered before data collection ([analysis plan](../00_commun/plan_analyse_statistique_en.md), section 6).

### 5.3 Step 5, criterion on $\gamma$

$\hat H(V\mid C)$ is estimated by NSB, with a CI by bootstrap over participants. The effective-verdict hypothesis is refuted if the upper bound of the 95 % CI is below $\alpha H(\mathcal{C}) - 1$ (table `tab:criteres_refutation`).

### 5.4 Step 6, reliability

| Statistic | Data | Threshold |
|---|---|---|
| ICC(2,1), absolute agreement | confidence (or mean item score) in session 1 and session 2 on the same items | $\geq 0.8$ |
| Inter-rater Cohen's $\kappa$ | mean over pairs of participants of the same stratum, on the stimuli both have seen | $\geq 0.7$ |
| Test-retest Cohen's $\kappa$ | verdict in session 1 and session 2 | reported, no threshold of its own in the algorithm |

If a threshold is not met, the estimates are reported with the mention “insufficient reliability” and are not used to apply the refutation criteria. If a statistic cannot be computed (no session 2, no common stimulus), the mention is “reliability not computable”.

For step 6, an item is a stimulus, i.e. a (context, proof) pair, whatever proof variant $\sigma$ was shown. In P1, participants of the same stratum who see the same pair receive different variants by design.

## 6. Report

The report follows the [estimation report template](rapport_estimation_en.md). It gives one row per step, with its status, then $\hat\Delta$ and $\hat\alpha$ with their uncertainties. It also gives the decision on each refutation criterion concerned ($\Delta$, admissibility, $\gamma$).

## 7. Timetable and resources

The thesis gives P4 no budget line of its own, since it reuses the P1 data (table `tab:programme_experimental`). For an institution outside P1, duration and cost follow those of P1 scaled to the number of participants **[to be decided by the team]**.

Licence CC BY 4.0.
