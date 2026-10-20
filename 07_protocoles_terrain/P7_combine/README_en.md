# Combined post-quantum validation protocol

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.7 (algorithm `alg:protocole_combine`)

[Version française](README_fr.md) · [Back to the field protocols](../README_en.md)

P7 gathers the results of P5 ($\hat\Delta_q$) and P6 ($\hat\eta_q$), computes $\hat\beta_q$, checks the hypotheses of the CRO$^q$ theorem, and compares the measurements with the refined bound only if these hypotheses hold. It ends with the cross-validation and the refutation report for the whole programme. Elements that do not appear in the thesis are marked **[to be decided by the team]**.

## Contents

| Document | Role | Part |
|---|---|---|
| [protocole_en.md](protocole_en.md) | Aim, four parts, bound compared, $\hat\beta_q$, expected outcome for signatures, criteria | all |
| [liste_verification_hypotheses_en.md](liste_verification_hypotheses_en.md) | Check of hypotheses 1 to 4 and of admissibility before any comparison | C |
| [fiche_confrontation_borne_en.md](fiche_confrontation_borne_en.md) | Computation of the refined bound, of the threshold $H^\sharp_q$, and decision | C |
| [modele_rapport_refutation_en.md](modele_rapport_refutation_en.md) | Decisions on all criteria of table `tab:criteres_refutation`, cross-validation, independent review | D |

## Analysis

```python
from cro_terrain import p7

hyp = p7.Hypotheses(lam=128, kappa=2.0, delta_q_ci_low=20.0, delta_q_prereg=28.0,
                    admissibility_p=0.4, admissibility_informative_strata=12,
                    log2_verdicts=2.0, alpha_q=0.2, theta_q=0.5, h_c=20.0,
                    h_v_c_ci=(1.8, 2.0), beta_q=1.04, chi_max=0.01)   # illustrative values
rep = p7.protocole_combine(hyp=hyp, eta_ci=(0.0, 0.01), eta_predicted=(0.05, 0.15),
                           product_ci_low=0.001)
print(rep["C_bound"])
```

The values above only illustrate how the function is called.

## Main point

For ML-DSA and SLH-DSA, regularity and the confidentiality regime almost certainly fail. The signature reveals the committed message, so that $\hat\beta_q = +\infty$ and $\chi_{\max} \gg \kappa/\lambda$. The comparison with the bound will therefore be **not probative**, in line with remark `rem:portee_cas_etude`. A probative comparison requires a post-quantum controlled-leakage protocol.

## Licence

CC BY 4.0.
