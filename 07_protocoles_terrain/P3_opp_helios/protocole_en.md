# P3 — Protocol for measuring $\mathsf{Opp}$ on a deployed system (Helios, ENSP)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.3; Helios derivation, §4.3 (`sec:derivation_helios`)

[Version française](protocole_fr.md) · [Folder README](README_en.md)

## 1. Aim

Empirically measure opposability $\mathsf{Opp}$ on a cryptographic system that is actually deployed, then compare the measured value with the predicted value (thesis, §4.2.3.1).

## 2. Target system

Helios voting system deployed for an election of student delegates at the École nationale supérieure polytechnique (ENSP) of the University of Yaoundé I (thesis, §4.2.3.1). The election is organised by the competent ENSP electoral body. The research team does not organise the election and has no bearing on its result ([agreement template](modele_convention_scrutin_en.md)).

## 3. Quantity measured and predicted value

$$\mathsf{Opp}_{\text{emp}} = \frac{I_{\text{emp}}(V;\Sigma\mid C)}{H_{\text{emp}}(V\mid C)}$$

(thesis, equation `eq:opp_empirique`).

| Element | Coding in P3 |
|---|---|
| $\Sigma$ | the audited proof, coded by its identifier (`proof_id`) |
| $V$ | the trustee's verdict on that proof, among 4 decisions (section 5.4) |
| $C$ | the audited election, a single value (`context_id = ENSP-<year>`) |

**Predicted value.** $\mathsf{Opp}_{\text{predicted}} = 0.50$, derived in §4.3 for a court of general jurisdiction with a space of four verdicts ($H(V\mid C) = 2$ bits) and a binary expert signal ($I(V;\Sigma\mid C) \approx 1$ bit). The illustrative calibration of the CLO article gives $\mathsf{Conf}\cdot\mathsf{Rel}_{\text{ver}}\cdot\mathsf{Opp} \approx 0.437$ (equation `eq:prediction_sotp_opp`).

The protocol tests the verdict-uniformity assumption behind the value 0.50 by measuring the empirical distribution $H_{\text{emp}}(V\mid C)$ instead of postulating it (thesis, §4.2.3.5).

## 4. Validation criterion (thesis, §4.2.3.5)

- **Agreement** if $|\mathsf{Opp}_{\text{emp}} - \mathsf{Opp}_{\text{predicted}}| \leq 0.05$.
- **Disagreement** if $\mathsf{Opp}_{\text{predicted}}$ falls outside the 95 % bootstrap CI of $\mathsf{Opp}_{\text{emp}}$. The value 0.50 and the uniformity assumption behind it are then refuted.

The two conditions are not mutually exclusive. The function `cro_terrain.refutation.criterion_opp_helios` reports both flags. The priority rule when both hold is **[to be decided by the team]**.

The predicted value concerns a court of general jurisdiction. The P3 trustees are trained cryptographers. This difference in population must be recalled whenever the result is set against the prediction.

## 5. Design

### 5.1 Participants

Committee of $n = 10$ trustees, PhD students and academic staff (thesis, §4.2.3.2). Codes `TR-01` to `TR-10`. The trustees of the real election (key-share holders) and the P3 auditors may be the same people **[to be decided by the team with the electoral body]**.

### 5.2 Size of the election

About 500 voters, hence about 500 ballots with proofs (thesis, §4.2.3.2).

### 5.3 Audited proofs

**According to the thesis.** A random sample of 50 proofs (10 %), drawn after the close following the [sampling procedure](tirage_echantillon_en.md).

**Proposed addition, control proofs.** In a regular election all proofs are valid. If the 10 trustees all give the verdict “valid ballot”, then $H_{\text{emp}}(V\mid C) = 0$ and $\mathsf{Opp}_{\text{emp}}$ is undefined. To avoid this degenerate case, the proposal adds 10 control proofs, altered copies of ballots from the same election, prepared by the coordinator and mixed blind with the 50 sampled proofs ([procedure](preuves_temoins_en.md)). The audited set then has 60 proofs **[to be decided by the team]**.

$\mathsf{Opp}_{\text{emp}}$ is reported on two sets.

| Set | Content | Role |
|---|---|---|
| Main | 60 proofs (50 sampled, 10 controls) | test of the criterion of section 4 |
| Restricted | the 50 sampled proofs only | value on the real system, possibly undefined |

The simulated example of the analysis package uses 50 proofs including 20 % controls. It only illustrates the computation chain.

### 5.4 Verdict space

The four decisions of the Helios derivation (§4.3) are transposed to the level of the ballot.

| Code | Verdict on the proof | Decision in the derivation |
|---|---|---|
| 1 | Valid ballot, counted | valid election |
| 2 | Invalid ballot, set aside | invalid election |
| 3 | Further check or recount requested | recount ordered |
| 4 | Investigation requested | investigation requested |

$|\mathcal{V}| = 4$, so $\log_2|\mathcal{V}| = 2$ bits, as in the derivation.

## 6. Procedure (thesis, §4.2.3.3)

| Phase | Content | Duration | Instrument |
|---|---|---|---|
| Prior | Agreement with the electoral body, ethics opinion, trustee consent, pre-registration filed | | [agreement template](modele_convention_scrutin_en.md) |
| 1 | Trustee training on Helios and zero-knowledge proofs | 4 h | [training material](support_formation_trustees_en.md) |
| 2 | Real election, standard Helios deployment | according to the electoral calendar | none, the team does not intervene |
| — | After the announcement of results, public sampling then preparation of the control proofs | 1 h | [sampling](tirage_echantillon_en.md), [control proofs](preuves_temoins_en.md) |
| 3 | Audit session. Each trustee examines each proof alone, gives a verdict and rates confidence out of 10 | 3 h | [audit form](fiche_audit_preuve_en.md) |
| Closing | Signed report, data entry, analysis | | [report](proces_verbal_audit_en.md), [template](gabarit_audit_preuves_en.csv) |

The audit starts **after the results have been announced**. Its verdicts are research data. They have no effect on the result of the election. A real anomaly found during the audit is reported to the electoral body according to the procedure of the agreement.

With 60 proofs in 3 h, each trustee has about 3 min per proof, breaks included.

## 7. Analysis

The [cro_terrain](../analyse/README_en.md) package reads the [template](gabarit_audit_preuves_en.csv) (schema `p3_audit`). The [analysis example](../analyse/exemple_analyse.py) runs the full chain on simulated data.

1. **Proposed main estimator.** `information.opp_emp_shuffle`, with a permutation-corrected numerator. With 60 proofs seen 10 times each, the Miller–Madow estimator alone remains strongly biased upwards **[to be decided by the team]**.
2. **Confidence interval.** Bootstrap over trustees, required by the thesis, and bootstrap over proofs, reported side by side (`statistics.cluster_bootstrap`). With 10 trustees, the trustee interval is coarse, and resampling trustees inflates the apparent dependence between $V$ and $\Sigma$. The number of clusters is given next to each interval.
3. **Robustness.** $\Sigma$ coded by the reference status (`reference_status`, authentic or control) instead of the identifier. This gives a lower bound.
4. **Decision.** `refutation.criterion_opp_helios`.
5. **Descriptive.** Distribution of verdicts, inter-trustee agreement (Fleiss' $\kappa$), detection rate of the controls, confidence and time by status.

## 8. Prediction and refutation

The criterion of section 4 appears in the [pre-registration](../00_commun/preenregistrement_en.md), section 2.3. A disagreement refutes the value 0.50 and the verdict-uniformity assumption. It does not refute the trilemma, of which $\mathsf{Opp}$ is only one factor.

## 9. Duration, resources and timetable

The thesis plans 4 months and 10 trustees (table `tab:programme_experimental`), in window A7–A12 of the calendar. The README of the protocols recommends bringing P3 forward to test the full chain on a small scale, without changing its duration or budget **[to be decided by the team]**.

| Month | Activity |
|---|---|
| M1 | Agreement, ethics opinion, pre-registration, recruitment of trustees |
| M2 | Training (phase 1), preparation of the sampling and control-proof procedure |
| M3 | Election (phase 2), public sampling, audit (phase 3) |
| M4 | Data entry, analysis, feedback to the electoral body and to the trustees |

## 10. Prerequisites

☐ Agreement signed with the ENSP electoral body ([template](modele_convention_scrutin_en.md)) and institutional agreement ([template](../00_commun/convention_institution_partenaire_en.md))
☐ Favourable opinion of the ethics committee ([template](../00_commun/dossier_comite_ethique_en.md))
☐ Consent of the 10 trustees ([information sheet](../00_commun/notice_information_consentement_en.md))
☐ Sampling seed rule and control-proof procedure registered before the election
☐ Pre-registration filed ([template](../00_commun/preenregistrement_en.md))
☐ All [to be decided by the team] items resolved

Licence CC BY 4.0.
