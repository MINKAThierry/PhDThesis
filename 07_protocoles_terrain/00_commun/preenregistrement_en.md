# Pre-registration template (OSF)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.1, §4.2.2, §4.2.4 and §4.2.7.3 (table `tab:criteres_refutation`)

[Version française](preenregistrement_fr.md)

This template follows the structure of the "OSF Preregistration" form. It is to be completed once per protocol (P1 to P7) and deposited on OSF with a timestamp **before any data collection**. Fields "____" are to be filled in. All [to be decided by the team] flags must be resolved before deposit.

## 1. Administrative information

- Study title: ____________________________________________
- Protocol: ☐ P1 $\Delta$ ☐ P2 $H(\mathcal{C})$ ☐ P3 $\mathsf{Opp}$ Helios ☐ P4 $\Delta$ and $\alpha$ ☐ P5 $\Delta_q$ ☐ P6 $\eta_q$ ☐ P7 combined
- Principal investigator: ____________________ Institution: LIMSI / ENSP, University of Yaoundé I
- Team (initials and roles): ____________________________________________
- Ethics approval number: ____________ Date: ___ / ___ / ______
- Signed institutional agreements (references): ____________________________________________
- Protocol version: ______ OSF deposit date: ___ / ___ / ______ OSF link: ____________________
- Associated code repository: https://github.com/MINKAThierry/PhDThesis (folder `07_protocoles_terrain/`)

## 2. Hypotheses

The hypotheses are taken from the thesis. They are conditional on the framework of institutional cryptography, in which $\Delta$, $\alpha$, $\beta$, $H(\mathcal{C})$, $\Delta_q$ and $\eta_q$ are institutional parameters.

### 2.1 Hypotheses tested by P1 (thesis, §4.2.1.5)

| Code | Prediction (thesis) | Population |
|---|---|---|
| H1.1 | $\hat\Delta_{\text{general judge}} \approx 25$ bits | Generalist judges (civil courts) |
| H1.2 | $\hat\Delta_{\text{PKI judge}} \approx 40$ bits | Specialised judges (contracts, PKI, digital) |
| H1.3 | $\hat\Delta_{\text{senior regulator}} \approx 65$ bits | Senior financial regulators |
| H1.4 | $\hat\Delta_{\text{ECDSA}} > \hat\Delta_{\text{Helios}}$ for every subgroup | All six subgroups |
| H1.5 | Institutional amplification factor of 1.8 to 3.7 relative to Miller's individual capacity (about 20 bits) | Whole sample |

Table `tab:stratification_delta` further predicts $\approx 35$ bits for junior regulators, $\approx 45$ bits for Court of Audit auditors and $\approx 55$ bits for private-firm auditors.

### 2.2 Hypotheses tested by P2 (thesis, §4.2.2.2, table `tab:estimations_structurelles_HC`)

| Code | Domain | Estimated $H(\mathcal{C})$ (thesis) |
|---|---|---|
| H2.1 | Electoral litigation | 30 to 50 bits |
| H2.2 | Financial compliance | 40 to 70 bits |
| H2.3 | Contract signature | 20 to 40 bits |

These ranges concern the entropy of the distribution of contexts in a domain, not the case-specific context (thesis, §4.2.2.1 and §4.3.1).

### 2.3 Hypotheses of the other protocols (reminder)

- P3 (§4.2.3.5): $\mathsf{Opp}_{\text{predicted}} = 0.50$ for Helios. Agreement if $|\mathsf{Opp}_{\text{emp}} - 0.50| \leq 0.05$. Disagreement if 0.50 falls outside the 95% bootstrap CI of $\mathsf{Opp}_{\text{emp}}$.
- P4 (§4.2.4): validation if ICC $\geq 0.8$ and $\kappa \geq 0.7$.
- P5 (§4.2.5.5): $\hat\Delta_q < \hat\Delta$ for untrained actors, $\hat\Delta_q \to \hat\Delta$ for PQC experts, $\hat\Delta_q \in [28, 67]$ bits for well-prepared institutions, decrease of $\Delta_q$ with noise, positive correlation between PQC training and $\Delta_q$.
- P6 (§4.2.6.5): $\hat\eta_q \in [0.05, 0.15]$ for a simulated medium at current hardware error rates, $\hat\eta_q = 0$ up to sampling fluctuations when the proof is read as a bit string (negative control).

### 2.4 Values fixed before the experiment

| Quantity | Pre-registered value | Source |
|---|---|---|
| Reference capacity $\Delta$ per stratum | ____ bits (proposal: values of table `tab:stratification_delta`) | thesis, §4.2.1.2 |
| Reference $\alpha$ per domain | ____ (proposal: 1.0 ECDSA, 1.2 Helios, 1.5 zk-SNARK) | thesis, §4.1.3 |
| Reference $H(\mathcal{C})$ | ____ bits (from P2 if available, otherwise table `tab:parametres_reference`) | thesis, §4.1.3 and §4.2.2 |
| Predicted interval for $\eta_q$ | ____ (proposal: $[0.05, 0.15]$) | thesis, §4.2.6.5 |

## 3. Research design and sampling

- Study type: ☐ repeated-measures experiment (P1, P4, P5) ☐ expert elicitation (P2) ☐ audit of a deployed system (P3) ☐ simulation with participants (P6, P7)
- Population and strata: see [fiche_recrutement_stratification_en.md](fiche_recrutement_stratification_en.md).
- Target size (thesis): P1 120 (6 strata of 20); P2 20 Delphi experts and 5 to 10 MDS experts; P3 10 trustees; P5 80; P6 40; P7 40. Minimum size for validity (thesis, §4.2.4): $n \geq 30$.
- Stimulus assignment (P1): balanced rotation of 10 contexts per participant among the 50 context–proof pairs. Proposed scheme: 2 contexts per proof type, balanced Latin square within each stratum **[to be decided by the team]**.
- Blinding: the message $m$ (ground truth) is known to the experimenter and not to participants. Gold-standard experts do not know the participants' stratum.

## 4. Variables and estimators

### 4.1 Measured variables

Verdict $v$ (vector of answers to the verdict items), subjective confidence (0 to 10), decision time (seconds), attention-check items, pseudonymised identifiers of the stimulus, of the context $c$, of the proof $\sigma$ and of the message $m$. Details are in the [variable dictionary](dictionnaire_variables_en.md).

### 4.2 Main estimator of $\Delta$ (thesis, eq. `eq:estimateur_delta`)

$$\hat{\Delta} = \hat{I}(V;\Sigma \mid M, C)$$

computed on the triplets $(v_i, \sigma_i, m_i)$ collected at fixed context $c$. Two variants are pre-registered.

- Plug-in with Miller–Madow correction. For an entropy estimated on $N$ observations with $\hat K$ non-empty cells, $\hat H_{\mathrm{MM}} = \hat H_{\mathrm{plug\text{-}in}} + (\hat K - 1)/(2N \ln 2)$ in bits. The conditional information is obtained as $\hat I(V;\Sigma\mid M,C) = \hat H(V\mid M,C) - \hat H(V\mid \Sigma,M,C)$.
- Bayesian NSB-type estimator (Nemenman–Shafee–Bialek) for small samples.

The estimator is positively biased in small samples. The confidence interval is obtained by non-parametric bootstrap over participants (thesis, §4.2.1.1). The earlier estimator $I_{\mathrm{emp}}(V;\Sigma\mid C) - I_{\mathrm{true}}(M;\Sigma\mid C)$ is abandoned (remark in the thesis, §4.2.1.1).

### 4.3 Other estimators

- $\hat\alpha = \log_2|\mathcal{V}| / H(C)$, computed independently of $\hat\Delta$ (thesis, §4.2.1.4 and §4.2.4).
- $\hat H(V\mid C)$ for the criterion on $\gamma$.
- $\hat H(\mathcal{C})$ by the three P2 approaches (structural decomposition, MDS, Delphi).
- Reliability: test-retest ICC and inter-rater Cohen's $\kappa$.

Computational details are in the [statistical analysis plan](plan_analyse_statistique_en.md).

## 5. Refutation criteria

Faithful reproduction of table `tab:criteres_refutation` of the thesis (§4.2.7.3). The threshold values are indicative and will be fixed at pre-registration. Their form is the methodological commitment.

| Parameter | The hypothesis is refuted if… |
|---|---|
| $\Delta$ (Bounded-extraction assumption, Ch. 2, §2.3.1.2) | the lower bound of the 95% CI of $\hat{I}(V;\Sigma\mid M,C)$ exceeds the capacity fixed *before* the experiment for the population studied. |
| Admissibility (Definition of admissible institutional interpretation, Ch. 2, §2.3.1.2) | a permutation test rejects $V \perp M \mid (\Sigma,C)$ at level $0.01$. |
| $\gamma$ (Efficient-verdict assumption, Ch. 2, §2.3.1.2) | the upper bound of the 95% CI of $\hat{H}(V\mid C)$ is lower than $\alpha H(\mathcal{C}) - 1$. |
| $\eta_q$ (quantum scenario) | the 95% CI of $\hat{\eta}_q$ excludes the interval predicted before the experiment. |
| Bound (assumptions verified) | the measured product exceeds the refined form of the bound with 95% confidence. |

Thresholds fixed for the present study:

- Reference capacity per population: ____________________
- Admissibility test level: 0.01 (thesis)
- Values of $\alpha$ and $H(\mathcal{C})$ used for $\gamma$: $\alpha =$ ____ $H(\mathcal{C}) =$ ____ bits
- Predicted interval for $\eta_q$: ____________________

## 6. Stopping rule

The thesis fixes target sizes but states no stopping rule. The following rule is proposed **[to be decided by the team]**.

1. Fixed-size design. Collection stops when each stratum reaches its quota (20 participants per stratum for P1) or at the end of the collection window set by the thesis (6 months for P1, 3 months for P2), whichever comes first.
2. No interim analysis of $\hat\Delta$, $\hat\alpha$ or $\hat H(\mathcal{C})$ is performed before closure. Only quality indicators (completion rate, attention-check failures, protocol deviations) are monitored during collection.
3. If a stratum does not reach its quota at closure, the analysis uses the size obtained. Per-stratum estimates below ____ participants **[to be decided by the team]** are reported as descriptive.
4. For the whole sample, the minimum size for validity is $n \geq 30$ (thesis, §4.2.4). Below that, no refutation criterion is applied.
5. For the Delphi (P2), the process stops when the interquartile range falls below 5 bits (thesis, §4.2.2.4), at the latest after the fourth round.

## 7. Planned analyses

### 7.1 Confirmatory analyses

1. Admissibility test $V \perp M \mid (\Sigma,C)$ by permutation, per context then overall. If admissibility is rejected, the estimate of $\Delta$ for that context is declared outside the framework (thesis, §4.2.1.4).
2. Estimation of $\hat\Delta$ per stratum with 95% bootstrap CI over participants. Comparison with the pre-registered capacity ($\Delta$ criterion).
3. Comparison of $\hat\Delta_{\text{ECDSA}}$ against $\hat\Delta_{\text{Helios}}$ within each subgroup (H1.4) by paired difference over participants with bootstrap CI.
4. Ratio $\hat\Delta / 20$ bits for H1.5.
5. Criterion on $\gamma$ using $\hat H(V\mid C)$.

### 7.2 Reliability analyses

Test-retest ICC (threshold 0.8) on the 3 contexts presented again at D+14. Inter-rater Cohen's $\kappa$ (threshold 0.7). Gold-standard agreement (threshold 90%).

### 7.3 Exploratory analyses (reported as such)

Relations between $\hat\Delta$ and seniority, cryptographic training, confidence, decision time. Comparison of the three estimates of $H(\mathcal{C})$.

## 8. Data exclusions

Proposal **[to be decided by the team]**:

- Answers for a context excluded if the participant fails at least 2 of the 3 attention-check items of that context.
- Answers for a context flagged if completion time is below ____ seconds.
- All data of a participant removed if they exercise their right to withdraw before the anonymisation date.
- Contexts whose gold-standard agreement remains below 90% after arbitration excluded from accuracy analyses.

## 9. Deviations from the pre-registration

Every deviation is declared using the [protocol deviation form](fiche_ecart_protocole_en.md) and reported in the publication of results.

Principal investigator's signature: ____________________ Date: ___ / ___ / ______
