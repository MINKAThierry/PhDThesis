# Combined post-quantum validation protocol

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.7 (algorithm `alg:protocole_combine`, table `tab:criteres_refutation`)

[Version française](protocole_fr.md) · [Folder README](README_en.md)

## 1. Aim

Validate the post-quantum parameters $(\Delta_q, \eta_q)$ jointly and compare the predictions of the post-quantum CRO trilemma with the measurements made on the NIST PQC standards (thesis, §4.2.7.1).

P7 involves no new collection of verdicts. It gathers the estimates of P5 ($\hat\Delta_q$) and P6 ($\hat\eta_q$), adds $\hat\beta_q$, checks the hypotheses of the theorem and only then compares the measurements with the bound. The 40 validators planned in the thesis (table `tab:programme_experimental`) independently review the hypothesis checklist and the refutation report **[role to be decided by the team]**.

## 2. The four parts of the algorithm

| Part | Content (thesis) | Data | Implementation |
|---|---|---|---|
| A | Measure extraction on ML-DSA and SLH-DSA without noise, compute $\hat\Delta_q$ by comparison with the PQC gold standard | P5, phase 1, condition A | `p5.delta_q_by_condition`, criterion on $\Delta$ |
| B | Apply quantum channels of increasing intensity, measure the decrease of mutual information, compute $\hat\eta_q$ by regression | P6 (simulation), P5 phase 2 | `p6.summarize`, `p5.eta_q_regression`, criterion on $\eta_q$ |
| C | Check the hypotheses of the theorem (including $H(V\mid C) \geq \gamma_q$). If they hold, compare $\mathsf{Conf}^q\cdot\mathsf{Rel}^q\cdot\mathsf{Opp}^q$ with the refined bound | P5, P6, protocol analysis | [checklist](liste_verification_hypotheses_en.md), [comparison form](fiche_confrontation_borne_en.md), `p7.Hypotheses`, bound criterion |
| D | Compare prediction and measurement for each PQC standard, compute relative error and confidence intervals | all of the above | `p7.cross_validation`, [report](modele_rapport_refutation_en.md) |

`cro_terrain.p7.protocole_combine` chains the four parts.

## 3. Bound compared

The refined quantum form reads (thesis, remark `rem:forme_raffinee_pq`, equation `eq:trilemme_pq_raffine`)

$$\mathsf{Conf}^q\cdot\mathsf{Rel}^q\cdot\mathsf{Opp}^q \;\leq\; \frac{1+\kappa/\lambda}{\lambda}\,\min\left\{1,\;\frac{\kappa/\lambda + \Delta_q}{\gamma_q}\right\},\qquad \gamma_q = \theta_q\,\alpha_q\,H(C).$$

$\eta_q$ does not appear in the refined form. It only appears in the weakened majorant $(\Delta_q + \eta_q H(C))/\lambda + O(\lambda^{-2})$ (`bounds.majorant_affaibli_pq`), which is reported for comparison.

## 4. On $\hat\beta_q$

The algorithm lists $\hat\beta_q$ among its outputs. Regularity (hypothesis `ass:regularite_quantique`) concerns the states $\rho_\Sigma^{m,c}$ produced by the protocol, not the participants' answers. $\hat\beta_q$ is therefore computed from the description of the protocol. For given states, the function `p7.beta_q_min` returns the smallest $\beta_q$ compatible with $\zeta_q = 0$.

For a signature, two distinct messages give states with disjoint supports. Then $D(\rho^{m_0,c}\,\|\,\rho^{m_1,c}) = +\infty$ and the protocol is not quantum-regular. A signature also reveals the committed message, so that $\chi_{\max} \gg \kappa/\lambda$ and the regime hypothesis `ass:regime_quantique` fails as well.

## 5. Expected outcome for ML-DSA and SLH-DSA

According to remark `rem:portee_cas_etude`, deployed systems are not instances of the theorem. Their values serve an illustrative calibration. For ML-DSA and SLH-DSA, part C will therefore almost certainly conclude **“comparison not probative”**, for lack of regularity and regime. This outcome is expected. It is neither a refutation nor a confirmation of the bound.

Parts A, B and D remain useful.

- A and B test the criteria on $\Delta$ and on $\eta_q$.
- D compares the values of the illustrative calibration with the measurements.

A probative comparison with the bound requires a controlled-leakage protocol, $I(M;\Sigma\mid C) \leq \kappa/\lambda$. Perfectly hiding commitments and zero-knowledge proofs are the canonical examples. For the post-quantum regime, their post-quantum versions would be needed, for example a variant of SOTP **[extension to be decided by the team]**.

## 6. Criteria (table `tab:criteres_refutation`)

| Parameter | Refuted if… | Part |
|---|---|---|
| $\Delta$ (here $\Delta_q$) | the lower bound of the 95 % CI of $\hat I(V;\Sigma\mid M,C)$ exceeds the capacity fixed before the experiment | A |
| Admissibility | a permutation test rejects $V \perp M \mid (\Sigma,C)$ at the 0.01 level | A |
| $\gamma$ (here $\gamma_q$) | the upper bound of the 95 % CI of $\hat H(V\mid C)$ is below $\gamma_q$ | C |
| $\eta_q$ | the 95 % CI of $\hat\eta_q$ excludes the interval predicted before the experiment | B |
| Bound | hypotheses verified, the measured product exceeds the refined form with 95 % confidence | C |

The thresholds are indicative and will be fixed at pre-registration. Their form is the methodological commitment (thesis, §4.2.7.3).

The thesis writes the classical $\gamma$ criterion with $\alpha H(\mathcal{C}) - 1$. For the quantum regime, the proposal uses $\gamma_q = \theta_q\alpha_q H(C)$ from hypothesis `ass:verdict_quantique` **[to be confirmed by the team]**.

## 7. Duration and resources

The thesis plans 3 months, 40 validators and an estimated cost of 6,000,000 FCFA (table `tab:programme_experimental`), in window A25–A36 (table `tab:calendrier_experimental`).

## 8. Prerequisites

☐ P5 and P6 completed, or at least the parts used
☐ Parameters $(\lambda, \kappa, \alpha_q, \theta_q, H(C))$ fixed and registered before the comparison
☐ Description of the protocol states available for $\hat\beta_q$ and $\chi_{\max}$
☐ Pre-registration filed ([template](../00_commun/preenregistrement_en.md))

Licence CC BY 4.0.
