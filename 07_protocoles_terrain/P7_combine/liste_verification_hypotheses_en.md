# Checklist of the hypotheses of the CRO$^q$ theorem (P7, part C)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 2, hypotheses `ass:extraction_quantique`, `ass:verdict_quantique`, `ass:regularite_quantique`, `ass:regime_quantique`, definition of the admissible interpreter; remark `rem:portee_cas_etude`; Chapter 4, §4.2.7.2, part C

[Version française](liste_verification_hypotheses_fr.md) · [P7 protocol](protocole_en.md)

One checklist per protocol compared (for example ML-DSA-65 in context $C$ of institution $I$). It is filled in **before** any comparison with the bound. A single hypothesis not verified makes the comparison not probative, and it can then be neither refuted nor confirmed. The function `cro_terrain.p7.Hypotheses.evaluate` applies the same checks.

| Field | Value |
|---|---|
| Protocol (scheme, parameters) | ______ |
| Institution, context | `INST-__`, ______ |
| Registered parameters | $\lambda =$ ____, $\kappa =$ ____, $\alpha_q =$ ____, $\theta_q =$ ____, $H(C) =$ ____ bits |
| Sources of the estimates | P5 ______, P6 ______, protocol analysis ______ |

## Checks

| No. | Hypothesis (thesis) | Check | Data | Result |
|---|---|---|---|---|
| 0 | Domain of the theorems | $\lambda \geq 64$ | scheme parameter | ☐ verified ☐ no |
| 1 | Bounded quantum extraction, $I(V;\Sigma\mid C) \leq I(M;\Sigma\mid C) + \Delta_q$ | criterion on $\Delta$ not refuted: lower bound of the 95 % CI of $\hat I(V;\Sigma\mid M,C)$ ≤ registered capacity | P5, part A | ☐ verified ☐ no ☐ not testable |
| 1 bis | Admissible interpreter, $V \perp M \mid (\Sigma, C)$ | permutation test not rejected at 0.01, with at least one informative stratum | P5, part A | ☐ verified ☐ no ☐ not testable |
| 2a | Efficient quantum verdict, verdict space | $\log_2 k_\lambda \leq \alpha_q H(C)$ | count of $\mathcal{V}$ (P4) | ☐ verified ☐ no |
| 2b | Efficient quantum verdict, non-degeneracy | $\gamma_q = \theta_q\alpha_q H(C) \geq 1$ | registered parameters | ☐ verified ☐ no |
| 2c | Efficient quantum verdict, $H(V\mid C) \geq \gamma_q$ | upper bound of the 95 % CI of $\hat H(V\mid C)$ (NSB) ≥ $\gamma_q$ | P5 | ☐ verified ☐ no |
| 3 | Quantum regularity, $D(\rho_\Sigma^{m_0,c}\|\rho_\Sigma^{m_1,c}) \leq \beta_q\,\chi(\mathcal{E}_{m,c}) + \zeta_q\,D(\bar\rho_\Sigma^c\|\mathbb{I}/d_\Sigma)$ | finite $\hat\beta_q$ (with $\zeta_q = 0$, `p7.beta_q_min`) or analytical proof | protocol description | ☐ verified ☐ no |
| 4 | Quantum confidentiality regime, $\chi_{\max} \leq \kappa/\lambda$ | $\chi_{\max}$ computed or bounded | protocol description | ☐ verified ☐ no |

## Guidance for post-quantum signatures

For an ML-DSA or SLH-DSA signature, the committed message is bound to the signature by its digest. The following results are therefore expected **[to be confirmed protocol by protocol]**.

- Check 3. Disjoint supports between messages, $D = +\infty$, hence $\hat\beta_q = +\infty$ and regularity not verified.
- Check 4. $\chi_{\max}$ of the order of $H(M\mid C)$, far above $\kappa/\lambda$, hence regime not verified.
- Conclusion. Comparison with the bound not probative (remark `rem:portee_cas_etude`).

## Decision

☐ All hypotheses are verified. The comparison with the bound is probative ([comparison form](fiche_confrontation_borne_en.md)).
☐ Hypothesis(es) not verified: ______. The comparison is not probative. The report says so without concluding on the bound.

Filled in by ______ on ___ / ___ / ______. Independently reviewed by two validators ______ and ______.

Licence CC BY 4.0.
