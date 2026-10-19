# P4_delta_alpha — Standardised joint estimation of $\Delta$ and $\alpha$

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.4 (algorithm `alg:estimation_conjointe`)

[Version française](README_fr.md) · [Back to the field protocols](../README_en.md)

P4 is the reference protocol for estimating $(\hat\Delta, \hat\alpha)$ in an institution. It fixes three prerequisites, six steps and two validation thresholds. It reuses the P1 data or applies to any other institution with at least 30 participants. No data have been collected. Elements that do not appear in the thesis are marked **[to be decided by the team]**.

## Contents

| Document | Role | Step |
|---|---|---|
| [protocole_en.md](protocole_en.md) | Purpose, inputs and outputs, prerequisites, six steps, notes | all |
| [liste_controle_prerequis_en.md](liste_controle_prerequis_en.md) | Blocking prerequisites of the thesis and proposed validity conditions | `Require` |
| [fiche_denombrement_verdicts_en.md](fiche_denombrement_verdicts_en.md) | Counting $\mathcal{V}$ in the texts, by two independent authors | 5 |
| [grille_fiabilite_en.md](grille_fiabilite_en.md) | Test-retest ICC and inter-rater $\kappa$, decision | 6 |
| [rapport_estimation_en.md](rapport_estimation_en.md) | Report template, refutation criteria on $\Delta$, admissibility and $\gamma$ | output |
| [gabarit_verdicts_en.csv](gabarit_verdicts_en.csv) | Verdict data entry, one row per participant and per item (`session` column 1 or 2) | 1 and 2 |
| [gabarit_denombrement_verdicts_en.csv](gabarit_denombrement_verdicts_en.csv) | Data entry for the verdict count | 5 |

## Analysis

The module `cro_terrain.p4` implements the algorithm.

```python
from cro_terrain.templates import read_template
from cro_terrain import p4

d = read_template("gabarit_verdicts_en.csv", "p4_verdicts")
v = read_template("gabarit_denombrement_verdicts_en.csv", "p4_verdict_space")
rep = p4.estimation_conjointe(
    d, n_verdicts=p4.verdict_space_size(v, "INST-01"), h_c=8.0,  # H(C) from P2
    delta_prereg=25.0,                                            # registered capacity
    institutional_agreement=True, ethics_approval=True)
print("\n".join(rep.summary()))
```

To reuse the P1 data, `p4.p1_to_p4` converts a `p1_answers` table into the `p4_verdicts` format. The verdict used is then the overall verdict Q01, and the session is the P1 phase.

The `gabarit_verdicts` template must have a `proof_id` column that uniquely identifies an item per participant and per session. Without it, retest pairing would be ambiguous, and the function raises an error.

## What this folder does not contain

- An estimator of $\beta$. The thesis algorithm gives none.
- Stimuli of its own. P4 uses those of P1 or of the study to which it is applied.
- Any field data.

## Licence

CC BY 4.0.
