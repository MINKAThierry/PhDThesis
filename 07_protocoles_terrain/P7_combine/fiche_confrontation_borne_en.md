# Bound comparison form (P7, part C)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 2, remark `rem:forme_raffinee_pq` (equation `eq:trilemme_pq_raffine`, threshold $H^\sharp_q$); Chapter 4, §4.2.7.2, part C; “bound” criterion of table `tab:criteres_refutation`

[Version française](fiche_confrontation_borne_fr.md) · [P7 protocol](protocole_en.md) · [Checklist](liste_verification_hypotheses_en.md)

This form is filled in only if the [checklist](liste_verification_hypotheses_en.md) concludes that all hypotheses are verified. Otherwise only section 4 is filled in, with the mention “not probative”.

## 1. Parameters (registered before the comparison)

| Parameter | Value | Source |
|---|---|---|
| $\lambda$ | | scheme |
| $\kappa$ | | protocol analysis |
| $\Delta_q$ (registered capacity) | bits | pre-registration |
| $\alpha_q$, $\theta_q$ | | P4, P5 |
| $H(C)$ | bits | P2 or reference table |
| $\gamma_q = \theta_q\alpha_q H(C)$ | | computed |
| $\eta_q$ (for the weakened majorant) | | P6 |

## 2. Computing the bound

| Quantity | Formula | Value |
|---|---|---|
| Fano factor | $(1+\kappa/\lambda)/\lambda$ | |
| Capacity term | $\min\{1, (\kappa/\lambda + \Delta_q)/\gamma_q\}$ | |
| **Refined bound** | product of the two previous rows (`bounds.borne_raffinee_pq`) | |
| Threshold $H^\sharp_q$ | $(\Delta_q + \kappa/\lambda)/(\theta_q\alpha_q)$ (`bounds.h_sharp_q`) | bits |
| Regime | ☐ capacity ($H(C) > H^\sharp_q$) ☐ Fano ($H(C) \leq H^\sharp_q$) | |
| Weakened majorant (comparison) | $(\Delta_q + \eta_q H(C))/\lambda$ (`bounds.majorant_affaibli_pq`) | |

`bounds.report_pq(lam, kappa, delta_q, theta_q, alpha_q, h_c)` fills in this table.

## 3. Measured product

| Factor | Estimate | 95 % CI | Source |
|---|---|---|---|
| $\mathsf{Conf}^q$ | | | |
| $\mathsf{Rel}^q$ (information-theoretic scale) | | | |
| $\mathsf{Opp}^q$ | | | |
| **Product** | | [____ ; ____] | joint bootstrap **[method to be decided]** |

The factors must be expressed on the information-theoretic scale of the definitions of Chapter 2. The operational scale of the CLO article ($\mathsf{Rel}_{\text{ver}}$) is not suitable. Mixing the two scales makes the comparison not probative (remark `rem:portee_cas_etude`).

## 4. Decision (`refutation.criterion_bound`)

| Situation | Decision |
|---|---|
| Hypotheses not all verified | ☐ **not probative** |
| Hypotheses verified, lower CI bound of the product > refined bound | ☐ **refuted**. One of the hypotheses is refuted according to table `tab:criteres_refutation`. An a posteriori readjustment of $\hat\Delta_q$ cannot absorb the gap. |
| Hypotheses verified, lower CI bound ≤ refined bound | ☐ **not refuted** |

Filled in by ______ on ___ / ___ / ______. Checked by ______.

Licence CC BY 4.0.
