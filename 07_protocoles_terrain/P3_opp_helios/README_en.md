# P3_opp_helios — Measuring opposability on Helios (ENSP)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.3

[Version française](README_fr.md) · [Back to the field protocols](../README_en.md)

This folder gathers protocol P3 and its instruments. P3 measures $\mathsf{Opp}_{\text{emp}} = I_{\text{emp}}(V;\Sigma\mid C)/H_{\text{emp}}(V\mid C)$ on the proofs of a real Helios election and compares it with the predicted value of 0.50. No data have been collected. Elements that do not appear in the thesis are marked **[to be decided by the team]**.

## Contents

| Document | Role | When |
|---|---|---|
| [protocole_en.md](protocole_en.md) | Aim, quantity measured, validation criterion, design, procedure, analysis | all |
| [modele_convention_scrutin_en.md](modele_convention_scrutin_en.md) | Agreement with the electoral body, separation of roles, data, real anomaly | before the election |
| [support_formation_trustees_en.md](support_formation_trustees_en.md) | 4-hour training, neutrality rules, exercises and answer key | phase 1 |
| [formation/generer_bulletins_exercice.py](formation/generer_bulletins_exercice.py) and [bulletins_exercice.json](formation/bulletins_exercice.json) | Six reproducible exercise ballots (teaching format, not Helios) | phase 1 |
| [tirage_echantillon_en.md](tirage_echantillon_en.md) | SHA-256 sampling rule, verifiable example, sampling report | after the announcement |
| [preuves_temoins_en.md](preuves_temoins_en.md) | Proposed addition of 10 control proofs, alteration types, register | after the draw |
| [fiche_audit_preuve_en.md](fiche_audit_preuve_en.md) | Form filled in by each trustee for each proof | phase 3 |
| [proces_verbal_audit_en.md](proces_verbal_audit_en.md) | Report of the audit session | phase 3 |
| [gabarit_audit_preuves_en.csv](gabarit_audit_preuves_en.csv) | Data entry, one row per trustee and per proof | data entry |

The shared documents (consent, confidentiality undertaking, session log, deviation form, pre-registration, analysis plan) are in [00_commun](../00_commun/README_en.md).

## Analysis

The [cro_terrain](../analyse/README_en.md) package already contains everything needed. It reads the template (schema `p3_audit`), draws the sample (`sampling.draw_sample`), computes $\mathsf{Opp}_{\text{emp}}$ (`information.opp_emp`, `information.opp_emp_shuffle`), produces the bootstrap intervals (`statistics.cluster_bootstrap`) and applies the criterion (`refutation.criterion_opp_helios`). The P3 section of the [analysis example](../analyse/exemple_analyse.py) runs the chain on simulated data.

The `reference_status` column receives `authentique` or `temoin`.

## Main point to decide

In a regular election all sampled proofs are valid. If all trustees declare them valid, $H_{\text{emp}}(V\mid C) = 0$ and $\mathsf{Opp}_{\text{emp}}$ is undefined. Control proofs avoid this case. They do not appear in the thesis, and their adoption must be decided before the pre-registration is filed.

## What this folder does not contain

- A verifier for the Helios format. The audit uses the tool of the deployed instance.
- The training slides, of which only the outline is provided.
- Any field data.

## Licence

CC BY 4.0 for the documents, MIT for the training script.
