# Measuring the quantum extraction capacity $\Delta_q$

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.5

[Version française](README_fr.md) · [Back to the field protocols](../README_en.md)

P5 measures $\hat\Delta_q = \hat I(V^q;\Sigma\mid M,C)$ with 80 professionals trained in post-quantum systems. The measurement covers real ML-DSA-65 and SLH-DSA signatures (phase 1), then a simulated, noisy quantum verifier (phase 2, hypothetical scenario). No data have been collected. Elements that do not appear in the thesis are marked **[to be decided by the team]**.

## Contents

| Document | Role | Phase |
|---|---|---|
| [protocole_en.md](protocole_en.md) | Aim, scope (real or simulated), stratification, material, procedure, estimators, predictions | all |
| [support_formation_pqc_en.md](support_formation_pqc_en.md) | 3-hour training on the NIST PQC standards | 0 |
| [stimuli/catalogue_stimuli_pqc_en.md](stimuli/catalogue_stimuli_pqc_en.md) | 12 pairs, 2 written in full, interpretation aid sheets | 1 |
| [stimuli/generer_signatures_pqc.py](stimuli/generer_signatures_pqc.py) and [exemples_signatures_pqc.json](stimuli/exemples_signatures_pqc.json) | Real, verifiable ML-DSA-65 and SLH-DSA signatures of the 2 written pairs | 1 |
| [questionnaire_pqc_en.md](questionnaire_pqc_en.md) | Verdict and confidence without then with aid, attention check, data entry rules | 1, 2, 3 |
| [specification_interface_verification_en.md](specification_interface_verification_en.md) | Interface requirements, noise model, log, acceptance tests | 1, 2, 3 |
| [fiche_conditions_bruit_en.md](fiche_conditions_bruit_en.md) | Conditions A to D, Williams order, participant form | 2 |
| [fiche_test_retest_pqc_en.md](fiche_test_retest_pqc_en.md) | Retest at constant noise, 4 items | 3 |
| [grille_gold_standard_pqc_en.md](grille_gold_standard_pqc_en.md) | Reference verdicts depending on the displayed result | 4 |
| [fiche_debriefing_pqc_en.md](fiche_debriefing_pqc_en.md) | Feedback text and questions specific to P5 | 5 |
| [gabarit_sessions_pqc_en.csv](gabarit_sessions_pqc_en.csv) | Data entry, one row per screen | data entry |

## Analysis

The module `cro_terrain.p5` computes $\hat\Delta_q$ per condition and per aid modality. It estimates $\hat\eta_q(p)$ relative to condition A, then the slope of $\hat\eta_q$ in $p$. It also computes interpretation errors and gives a descriptive reading of the five predictions. Finally, it provides the interface noise model and the Williams order.

```python
from cro_terrain.templates import read_template
from cro_terrain import p5

d = read_template("gabarit_sessions_pqc_en.csv", "p5_sessions")
print(p5.delta_q_by_condition(d, aid="0", alphabet_size=4))
print(p5.eta_q_regression(d, h_c=10.5, aid="0", alphabet_size=4))   # case-scale H(C) for ML-DSA
print(p5.error_rate_by_condition(d))
```

## Main points to decide

1. **Scope of phase 2.** For ML-DSA and SLH-DSA, $\eta_q = 0$, since they are bit strings. Phase 2 only measures a hypothetical scenario. The protocol and the debriefing say so.
2. **Expected noise effect.** With $p \leq 0.1$, the displayed result is flipped at most once in twenty. Prediction 4 requires a power simulation before data collection.
3. **Classical reference.** Predictions 1 and 2 compare $\hat\Delta_q$ with a classical $\hat\Delta$. Its source (same participants or a P1 stratum) is to be decided.
4. **Three proofs or two schemes.** The thesis algorithm takes three proofs as input, whereas the material now has only two schemes.

## Licence

CC BY 4.0 for the documents, MIT for the script. The libraries `dilithium-py` (MIT) and `slh-dsa` (LGPL-3.0) are dependencies. They are not included in the repository.
