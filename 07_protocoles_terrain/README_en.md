# Field protocols — measuring the institutional parameters

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.1.2, §4.2 and §4.2.8

[Version française](README_fr.md)

## Status

This folder gathers the operational instruments (forms, guides, data templates) that would allow the experimental programme specified in Chapter 4 of the thesis to be deployed. None of these protocols has been deployed. No data have been collected. The numerical values quoted (sample sizes, durations, thresholds, predictions) are taken from the thesis and keep the status the thesis gives them. The predictions are falsifiable bets and the reference parameters are an illustrative calibration (thesis, §4.1.3).

Whenever an instrument requires a detail that the thesis does not fix, the proposed value is flagged **[to be decided by the team]**. All such flags must be resolved before pre-registration.

## Overview of the seven protocols

| Code | Parameter measured | Thesis section | Folder | Participants (thesis) |
|---|---|---|---|---|
| P1 | $\Delta$, institutional extraction capacity | §4.2.1 | [P1_delta/](P1_delta/README_en.md) | 120 stratified institutional actors |
| P2 | $H(\mathcal{C})$, contextual entropy | §4.2.2 | [P2_entropie_contexte/](P2_entropie_contexte/README_en.md) | 20 experts (Delphi), 5 to 10 experts (MDS) |
| P3 | $\mathsf{Opp}$, opposability measured on Helios (ENSP) | §4.2.3 | [P3_opp_helios/](P3_opp_helios/README_en.md) | 10 trustees, about 500 voters |
| P4 | $\Delta$ and $\alpha$ estimated jointly | §4.2.4 | [P4_delta_alpha/](P4_delta_alpha/README_en.md) | $n \geq 30$ |
| P5 | $\Delta_q$, quantum extraction capacity | §4.2.5 | [P5_delta_q/](P5_delta_q/README_en.md) | 80 PQC professionals |
| P6 | $\eta_q$, quantum interpretability loss | §4.2.6 | [P6_eta_q/](P6_eta_q/README_en.md) | 40 experts and simulation |
| P7 | Combined post-quantum validation $(\Delta_q, \eta_q, \beta_q)$ | §4.2.7 | [P7_combine/](P7_combine/README_en.md) | 40 validators |

The folder [00_commun/](00_commun/README_en.md) contains the documents shared by all protocols (pre-registration, ethics file, consent, partnership agreement, confidentiality, quotas, participant profile, session log, deviations, data management, statistical analysis plan). The folder [analyse/](analyse/README_en.md) contains the Python package `cro_terrain`, which implements the estimators, the reliability checks and the refutation criteria.

## Recommended deployment order

The thesis designates the post-election Helios audit at ENSP as "the natural entry point of the programme", because it is the lightest in resources and the only one that can be run entirely within ENSP (§4.2.8.3). The recommended order follows from this.

1. **P3** (Helios audit at ENSP). It tests the whole chain (ethics, consent, collection, data management, analysis) on a small scale with 10 trustees.
2. **P2** (contextual entropy). It provides $H(\mathcal{C})$, on which $\hat\alpha$ and the refutation criterion on $\gamma$ depend.
3. **P1** ($\Delta$ capacity). It requires agreements with courts, regulators and audit firms as well as the gold standard.
4. **P4** (joint estimation of $\Delta$ and $\alpha$). It reuses the P1 data and the value of $H(\mathcal{C})$ from P2 with the validation thresholds ICC $\geq 0.8$ and $\kappa \geq 0.7$.
5. **P5**, **P6** then **P7** (post-quantum strand).

The thesis schedule (table below) starts P1 and P2 in months A1–A6 and P3 in A7–A12. The order recommended here brings P3 forward without changing durations or budgets. The final sequencing is **[to be decided by the team]** depending on when institutional agreements are obtained.

## Schedule (thesis, table `tab:calendrier_experimental`, §4.2.8.2)

| Activity | M1–M6 | M7–M12 | M13–M18 | M19–M24 | M25–M30 | M31–M36 |
|---|---|---|---|---|---|---|
| Measurement of $\Delta$ (§4.2.1) | ×× | ×× | | | | |
| Measurement of $H(\mathcal{C})$ (§4.2.2) | × | × | | | | |
| Measurement of $\mathsf{Opp}$ on Helios (§4.2.3) | | ×× | × | | | |
| Measurement of $\Delta_q$ (§4.2.5) | | | ×× | ×× | | |
| Measurement of $\eta_q$ (§4.2.6) | | | | ×× | × | |
| PQC validation (§4.2.7) | | | | | ×× | × |
| Longitudinal analysis | | | | | | ×× |

## Budget and resources (thesis, table `tab:programme_experimental`, §4.2.8.1)

| Protocol | Section | Duration | Participants | Estimated cost |
|---|---|---|---|---|
| Measurement of $\Delta$ | §4.2.1 | 6 months | 120 institutional actors | 15,000,000 FCFA |
| Measurement of $H(\mathcal{C})$ | §4.2.2 | 3 months | 20 experts | 5,000,000 FCFA |
| Measurement of $\mathsf{Opp}$ on Helios | §4.2.3 | 4 months | 10 trustees | 8,000,000 FCFA |
| Measurement of $\Delta_q$ | §4.2.5 | 6 months | 80 PQC professionals | 12,000,000 FCFA |
| Measurement of $\eta_q$ | §4.2.6 | 4 months | 40 experts and simulation | 8,000,000 FCFA |
| Combined PQC validation | §4.2.7 | 3 months | 40 validators | 6,000,000 FCFA |
| **Total** | | **26 months** | **310** | **54,000,000 FCFA** |

According to the thesis, these costs are indicative orders of magnitude that will be refined when each protocol is actually implemented. The 26 cumulative months of work are spread over a 36-month schedule. Protocol P4 has no line of its own in this table because it reuses the P1 data.

## Prerequisites for deployment (thesis, §4.2.8.3)

- Agreement of the courts and regulators approached (template in [00_commun/convention_institution_partenaire_en.md](00_commun/convention_institution_partenaire_en.md)).
- Approval by a research ethics committee (template in [00_commun/dossier_comite_ethique_en.md](00_commun/dossier_comite_ethique_en.md)).
- Funding of the order of magnitude given above.

## Refutation criteria

The refutation criteria are fixed before any data collection (thesis, table `tab:criteres_refutation`, §4.2.7.3). They are reproduced verbatim in the [pre-registration template](00_commun/preenregistrement_en.md#5-refutation-criteria). According to the thesis, the threshold values are indicative and will be fixed at pre-registration, their form being the methodological commitment.

## Licence

Texts, forms and data templates under CC BY 4.0.
