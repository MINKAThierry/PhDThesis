# PQC gold-standard grid (P5, phase 4)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.5.3, phase 4 (“post-quantum cryptography experts establish the correct verdicts”)

[Version française](grille_gold_standard_pqc_fr.md) · [P5 protocol](protocole_en.md) · [P1 grid](../P1_delta/grille_gold_standard_en.md)

The procedure is that of the [P1 grid](../P1_delta/grille_gold_standard_en.md). Two independent experts `GS-A` and `GS-B` answer alone, an arbiter `GS-ARB` settles disagreements and the required agreement is at least 90 %, all before data collection. It differs on two points.

1. **Profile.** The experts are post-quantum cryptography specialists, independent of strata AEX and RQS **[to be decided by the team]**.
2. **Reference verdict per condition.** In phase 2, the reference verdict may depend on the result displayed by the simulated verifier. The experts therefore give two reference verdicts for each variant, one for a displayed “success” and one for a displayed “failure”. The `gold_verdict` column of the template receives the one that matches the result actually displayed, read from the interface log.

## Expert answer sheet (one per variant)

| Field | Value |
|---|---|
| Expert | ☐ `GS-A` ☐ `GS-B` ☐ `GS-ARB` |
| Stimulus, variant, message | `___-C__`, `___-C__-S_`, `___-C__-M_` |
| Verification redone by the expert | ☐ accepted ☐ rejected |
| Reference verdict if the displayed result is “success” | ____ (1 to 4) |
| Reference verdict if the displayed result is “failure” | ____ (1 to 4) |
| Does the answer differ between M1 and M2 from reading the file alone? | ☐ no ☐ yes, specify ______ |

Justification in three lines at most

______________________________________________________________________
______________________________________________________________________

## Agreement

| Indicator | Threshold |
|---|---|
| Agreement on the “success” verdict, 48 variants | $\geq 90\,\%$ |
| Agreement on the “failure” verdict, 48 variants | $\geq 90\,\%$ |
| Cohen's $\kappa$ | reported |

A pair whose agreement stays below 90 % after arbitration is excluded from the computation of interpretation errors. It is still used for $\hat\Delta_q$, which does not depend on the gold standard.

Licence CC BY 4.0.
