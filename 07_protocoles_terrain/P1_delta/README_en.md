# Measuring the institutional extraction capacity $\Delta$

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.1 (and §4.2.4 for the validation thresholds)

[Version française](README_fr.md) · [Back to the field protocols](../README_en.md)

This folder gathers protocol P1 and all the instruments needed to run it. No data have been collected. Elements that do not appear in the thesis are marked **[to be decided by the team]**.

## Contents

| Document | Role | Phase |
|---|---|---|
| [protocole_en.md](protocole_en.md) | Aim, estimator $\hat\Delta = \hat I(V;\Sigma\mid M,C)$, design, rotation, phases, predictions | all |
| [guide_enqueteur_en.md](guide_enqueteur_en.md) | Preparing and running the sessions, instructions to read, incidents | 0 to 4 |
| [support_formation_phase0_en.md](support_formation_phase0_en.md) | Neutral outline of the 2-hour training | 0 |
| [questionnaire_extraction_verdict_en.md](questionnaire_extraction_verdict_en.md) | 30-item questionnaire per context (Q01 to Q30), data entry rules | 1 and 2 |
| [stimuli/gabarit_fiche_stimulus_en.md](stimuli/gabarit_fiche_stimulus_en.md) | Template of a context–proof pair, construction rules, verdict spaces A, B, C | preparation |
| [stimuli/catalogue_stimuli_en.md](stimuli/catalogue_stimuli_en.md) | List of the 50 pairs, 2 of them written in full | preparation |
| [stimuli/generer_exemples.py](stimuli/generer_exemples.py) and [exemples_stimuli.json](stimuli/exemples_stimuli.json) | Reproducible cryptographic values of the 2 written pairs (ECDSA P-256, Helios-type ballot) | preparation |
| [fiche_test_retest_en.md](fiche_test_retest_en.md) | Choice of the 3 contexts presented again at D+14, ICC and $\kappa$ indicators | 2 |
| [grille_gold_standard_en.md](grille_gold_standard_en.md) | Expert answer sheet, agreement computation (90 % threshold) | 3 |
| [fiche_debriefing_en.md](fiche_debriefing_en.md) | Feedback text, record, anonymous feedback questionnaire | 4 |
| [gabarit_donnees_en.csv](gabarit_donnees_en.csv) | Header of dataset D4, one row per participant and per context | data entry |

The documents shared by all protocols (consent, profile, session log, deviation form, pre-registration, analysis plan, variable dictionary) are in [00_commun](../00_commun/README_en.md).

## Processing chain

1. Stimuli are written following the template, then checked by the gold standard (phase 3), before any session.
2. Answers are entered in `gabarit_donnees_fr.csv` or `gabarit_donnees_en.csv`. Column names follow dataset D4 of the [variable dictionary](../00_commun/dictionnaire_variables_en.md).
3. The analysis package [cro_terrain](../analyse/README_en.md) reads this template (schema `p1_answers`). The module `cro_terrain.p1` computes `attention_failures` and `excluded`, builds the verdict vector and gives the rotation lists. The estimator $\hat\Delta$ is `cro_terrain.delta_hat`.

```python
from cro_terrain.templates import read_template
from cro_terrain import p1, delta_hat

d = p1.add_computed_columns(read_template("gabarit_donnees_en.csv", "p1_answers"))
keep = d["excluded"] == 0
est = delta_hat(d["verdict_v"][keep], d["sigma_id"][keep], d["message_id"][keep],
                d["stimulus_id"][keep], method="mm")
```

## What this folder does not contain

- The 48 context–proof pairs still to be written, with their 192 variants.
- The results of a pre-test of the questionnaire.
- The training slides, of which only the outline is provided.
- Any field data.

## Licence

CC BY 4.0 for the documents, MIT for the script `stimuli/generer_exemples.py`.
