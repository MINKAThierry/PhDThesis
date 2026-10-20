# Statistical analysis plan

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.1.1, §4.2.1.4, §4.2.2, §4.2.4 and §4.2.7.3

[Version française](plan_analyse_statistique_fr.md)

This plan fixes the computations before any data collection. It complements the [pre-registration](preenregistrement_en.md). Choices the thesis does not settle are flagged [to be decided by the team]. The corresponding code will be placed in the `analyse/` folder of the repository.

## 1. Notation

- $V$ participant's verdict. Two levels are distinguished. $V_{\text{glob}}$ is the overall verdict (item Q01, 4 categories). $V$ is the vector made of Q01 and the 22 dimension items (Q02 to Q25 excluding attention checks), each with 8 categories.
- $\Sigma$ proof variant presented, $M$ committed message (ground truth known only to the experimenter), $C$ context.
- $N$ number of observations in the cell considered, $\hat K$ number of non-empty cells.
- All entropies are in bits.

## 2. Data preparation

1. Double entry and reconciliation (see the [data management plan](plan_gestion_donnees_en.md)).
2. Computation of `attention_failures` (Q09 expected 3, Q18 expected 0, Q28 expected equal to the stimulus domain).
3. Application of the pre-registered exclusion rules (section 8 of the pre-registration). Exclusions are reported by stratum and by stimulus.
4. "Cannot be determined" is coded as a distinct verdict category (code 0). A non-response is not a category. Observations with more than ____ unanswered dimension items are set aside from the analysis of $V$ **[to be decided by the team]**.

## 3. Entropy estimators

**Plug-in.** $\hat H_{\text{PI}} = -\sum_k \hat p_k \log_2 \hat p_k$ with $\hat p_k = n_k / N$.

**Miller–Madow.** $\hat H_{\text{MM}} = \hat H_{\text{PI}} + \dfrac{\hat K - 1}{2N \ln 2}$.

**NSB.** Bayesian estimator of Nemenman, Shafee and Bialek, based on a mixture of Dirichlet priors chosen to make the prior on entropy nearly uniform. It is used for small samples (thesis, §4.2.1.1). The alphabet size passed to the estimator is the number of possible categories, not the number observed.

Conditional entropies are weighted averages over the conditioning cells, for example $\hat H(V\mid M,C=c) = \sum_m \hat p(m\mid c)\, \hat H(V\mid M=m, C=c)$.

## 4. Admissibility test $V \perp M \mid (\Sigma, C)$

Condition of the Definition of admissible institutional interpretation (Chapter 2, §2.3.1.2). Permutation test (thesis, algorithm `alg:estimation_delta`, line 6).

1. Statistic $T = \hat I_{\text{MM}}(V_{\text{glob}}; M \mid \Sigma, C)$, computed on all phase 1 observations of a stratum and a context.
2. Permutation of the $m$ labels within each cell $(\sigma, c)$, which preserves the joint law of $(V,\Sigma,C)$ and the marginal law of $M$ in each cell.
3. $B = 10{,}000$ permutations **[to be decided by the team]**. $p$-value $= (1 + \#\{T^{*} \geq T\}) / (B + 1)$.
4. Rejection at level $0.01$ (refutation criterion). The test is repeated on the vector $V$ restricted to the items with the most dispersed distribution **[to be decided by the team]**.

When the variant $\sigma$ fully determines $m$ (for example an ECDSA signature presented with the signed document, public by design), $I(V;M\mid\Sigma,C) = 0$ by construction and the test does not apply. This case is flagged in the stimulus sheet.

If admissibility is rejected for a context, the estimate of $\Delta$ for that context is reported but declared outside the framework (thesis, §4.2.1.4).

## 5. Estimation of $\Delta$

### 5.1 Main estimator

$$\hat\Delta = \hat I(V;\Sigma\mid M,C) = \hat H(V\mid M,C) - \hat H(V\mid \Sigma,M,C)$$

computed at fixed context $c$ (thesis, eq. `eq:estimateur_delta`), then aggregated over the contexts of the same proof type by averaging weighted by $\hat p(c)$. Results are presented by stratum, by proof type and overall.

### 5.2 Confidence interval

Non-parametric bootstrap over participants (thesis, §4.2.1.1). For each stratum, as many participants as the stratum contains are drawn with replacement, all their observations are taken, then $\hat\Delta$ is recomputed. $B = 2{,}000$ replicates **[to be decided by the team]**. 95% CI by the percentile method, with BCa as sensitivity analysis.

### 5.3 Caveat on cell size

A plug-in estimator of mutual information cannot exceed $\log_2 N$ in a cell of $N$ observations. With 120 participants and 10 contexts each, each of the 50 pairs receives on average 24 observations, about 4 per stratum. Direct estimation on the vector $V$ therefore cannot reach the values of 25 to 65 bits predicted by the thesis, whatever the true value. Two routes are proposed **[to be decided by the team]**, both to be reported.

- **Item decomposition.** By the chain rule, $I(V;\Sigma\mid M,C) = \sum_{k} I(V_k;\Sigma\mid M,C,V_{<k})$. The estimate truncates the conditioning on $V_{<k}$ at order ____ **[to be decided by the team]**. At order zero, the sum $\sum_k \hat I(V_k;\Sigma\mid M,C)$ upper-bounds the joint information when items are conditionally independent given $(\Sigma,M,C)$. This independence approximation is of the same kind as that of the structural approach to $H(\mathcal{C})$ (thesis, §4.2.2.2). Its direction of bias must be taken into account when applying the refutation criterion on $\Delta$, which concerns the lower bound of the CI.
- **Pooling contexts.** Pooling observations from contexts judged equivalent by the P2 panel, which increases $N$ per cell at the cost of a homogeneity assumption.

Stimulus design must also provide, for each pair $(m,c)$, at least two variants $\sigma$ shown to different participants. Without that variation, $\hat I(V;\Sigma\mid M,C)$ is zero by construction.

### 5.4 Derived hypotheses

- H1.1 to H1.3. Comparison of $\hat\Delta$ per stratum with the predicted values (25, 40 and 65 bits). The 95% CI is reported.
- H1.4. Difference $\hat\Delta_{\text{ECDSA}} - \hat\Delta_{\text{Helios}}$ within each stratum, CI by the same bootstrap over participants. Prediction confirmed in a stratum if the lower bound of the CI is positive.
- H1.5. Ratio $\hat\Delta / 20$ bits per stratum, compared with the interval 1.8 to 3.7.

## 6. Estimation of $\alpha$ and criterion on $\gamma$

- $\hat\alpha = \log_2|\mathcal{V}| / H(C)$, computed independently of $\hat\Delta$ (thesis, §4.2.4, step 5). $H(C)$ comes from P2 or, failing that, from the table of reference parameters (thesis, §4.1.3).
- The value of $|\mathcal{V}|$ depends on the verdict level adopted. For $V_{\text{glob}}$, $\log_2|\mathcal{V}| = 2$ bits. For the vector $V$, $\log_2|\mathcal{V}| = 2 + 22 \times 3 = 68$ bits, a value fixed by the instrument. The level used for $\hat\alpha$ is **[to be decided by the team]**. Both are reported.
- Criterion on $\gamma$. $\hat H(V\mid C)$ is estimated by NSB with bootstrap CI over participants. The efficient-verdict assumption is refuted if the upper bound of the 95% CI is below $\alpha H(\mathcal{C}) - 1$, at the same verdict level as used for $\alpha$.

## 7. Reliability

| Indicator | Data | Method | Threshold (thesis) |
|---|---|---|---|
| Test-retest | 3 contexts presented again at D+14 (phase 2) | ICC(2,1) absolute agreement on the mean score of the dimension items and on confidence | ICC $\geq 0.8$ |
| Test-retest of the overall verdict | same | Cohen's $\kappa$ between phase 1 and phase 2 on Q01 | $\kappa \geq 0.7$ |
| Inter-rater | Participants of the same stratum who saw the same stimulus | Mean pairwise Cohen's $\kappa$ on Q01. Fleiss's $\kappa$ given as a complement **[to be decided by the team]** | $\kappa \geq 0.7$ |
| Gold standard | Experts `GS-A` and `GS-B` | Percentage agreement and Cohen's $\kappa$ on Q01 and on the dimension items | agreement $\geq 90\%$ |

The thresholds ICC $\geq 0.8$ and $\kappa \geq 0.7$ come from algorithm `alg:estimation_conjointe` (thesis, §4.2.4). The 90% threshold comes from phase 3 of P1 (thesis, §4.2.1.3). If a threshold is not met, the estimates are reported with the note "insufficient reliability" and are not used to apply the refutation criteria.

## 8. P2 analyses

### 8.1 Structural decomposition

$H(C) = H(L) + H(T\mid L) + H(R\mid L,T)$ (thesis, list of notation). For each component, the entropy of an element with $k$ equiprobable categories is $\log_2 k$. Elements are summed under the approximate independence assumption (thesis, §4.2.2.2). Expert estimates are summarised by the median and interquartile range per domain.

### 8.2 MDS modelling

1. Dissimilarity matrix $D \in \mathbb{R}^{100\times 100}$, average of the experts' judgements (thesis, §4.2.2.3).
2. Classical MDS. The number of dimensions retained is the smallest that brings Kruskal's stress below ____ **[to be decided by the team]**.
3. Empirical covariance $\hat\Sigma$ of the coordinates, effective volume $V_{\text{eff}} = \det(\hat\Sigma)^{1/2}$, estimate $H(\mathcal{C}) \approx \log_2 V_{\text{eff}}$ (thesis, §4.2.2.3).
4. $V_{\text{eff}}$ depends on the unit of the dissimilarity scale. The unit (for example a just-noticeable difference set to one step of the 0 to 10 scale) is **[to be decided by the team]** before collection.
5. Uncertainty by bootstrap over experts.

### 8.3 Delphi

Median and interquartile range of $H(\mathcal{C})$ at each round. Stop when the interquartile range is below 5 bits (thesis, §4.2.2.4). The value retained is the median of the last round.

### 8.4 Comparison of the three approaches

The three estimates are compared with the ranges of table `tab:estimations_structurelles_HC`. Their discrepancy is reported without combining them into a single value **[to be decided by the team]**.

## 9. Multiplicity and reporting

- The refutation criteria are applied as pre-registered, without multiplicity correction, since each concerns a distinct hypothesis of the thesis.
- Secondary comparisons (H1.4 across six strata) come with a Holm correction **[to be decided by the team]**.
- Any analysis not planned here is published in an "exploratory" section.
- Random seeds for permutations and bootstrap are fixed and published with the code.

## 10. Software

Python 3 with numpy, scipy, pandas and scikit-learn for MDS. The NSB estimator will be implemented or taken from a reference library **[to be decided by the team]**. The code is versioned in `analyse/` under the MIT licence and tested on simulated data before the real data are opened.
