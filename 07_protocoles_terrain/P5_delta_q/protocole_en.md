# Protocol for measuring $\Delta_q$, quantum extraction capacity

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.5 (algorithm `alg:estimation_delta_q`, table `tab:stratification_delta_q`)

[Version française](protocole_fr.md) · [Folder README](README_en.md)

## 1. Aim

Empirically measure the quantum institutional extraction capacity $\Delta_q$ (in bits), defined by

$$I(V^q;\Sigma\mid C)_\rho \leq I(M;\Sigma\mid C)_\rho + \Delta_q$$

(thesis, equation `eq:extraction_quantique_op`). The thesis decomposes it as $\Delta_q = \Delta + \delta_{\text{enh}} - \delta_{\text{degr}}$, where $\delta_{\text{enh}}$ is the gain from quantum resources and $\delta_{\text{degr}}$ the degradation from quantum noise (definition `def:capacite_extraction_quantique_op`).

## 2. Scope: what is measured and what is simulated

ML-DSA and SLH-DSA signatures are classical bit strings. For them the estimator

$$\hat\Delta_q = \hat I(V^q;\Sigma\mid M,C)$$

coincides with the classical P1 estimator. Moreover $\eta_q = 0$ (thesis, §4.2.5.1 and remark `rem:interpretation_physique_pq`). P5 therefore measures two distinct things.

| Part | What it measures | Status |
|---|---|---|
| Phase 1 | $\hat\Delta_q$ on real post-quantum signatures, with and without interpretation aid | measurement on a real object |
| Phase 2 | variation of $\hat\Delta_q$ and $\hat\eta_q$ when the verification result goes through a simulated, noisy quantum verifier | **hypothetical scenario** of a quantum medium or verifier |

The phase 2 results hold only for this scenario. They say nothing about a loss of interpretability of ML-DSA or SLH-DSA signatures as deployed.

## 3. Participants (table `tab:stratification_delta_q`)

$N \geq 80$ professionals trained in post-quantum systems.

| Category | Subgroup | Proposed code | $n$ | Predicted $\Delta_q$ |
|---|---|---|---|---|
| PQC regulators | Juniors (initial training) | RQJ | 20 | $\approx 28$ bits |
| PQC regulators | Seniors (advanced training) | RQS | 20 | $\approx 45$ bits |
| Crypto auditors | Classical (PQC transition) | ACL | 20 | $\approx 35$ bits |
| Crypto auditors | Certified PQC experts | AEX | 20 | $\approx 67$ bits |
| **Total** | | | **80** | |

Participant codes `P5-<stratum>-NNN`. The profile is collected with the [shared questionnaire](../00_commun/questionnaire_profil_participant_en.md), whose question D2 covers PQC training (prediction 5).

## 4. Material

| Element (thesis) | Proposed implementation |
|---|---|
| ML-DSA-65 (FIPS 204) and SLH-DSA (FIPS 205) | ML-DSA-65 and SLH-DSA-SHAKE-128f, signatures produced by reference implementations ([stimuli](stimuli/catalogue_stimuli_pqc_en.md)) |
| ML-KEM (FIPS 203) | excluded, since it is a key-encapsulation mechanism that produces no proof (thesis) |
| Quantum environment simulator, depolarising noise $p \in [0.001, 0.1]$ | built into the verification interface ([specification](specification_interface_verification_en.md)) |
| Post-quantum verification interface with performance metrics | [specification](specification_interface_verification_en.md) |
| Questionnaires adapted to the NIST PQC context | [PQC questionnaire](questionnaire_pqc_en.md) |

The thesis algorithm takes three proofs $\{\sigma_1, \sigma_2, \sigma_3\}$ as input, whereas the material list keeps only two schemes since ML-KEM was excluded. The proposal keeps the two schemes. A third family (for example FN-DSA, draft FIPS 206) could be added **[to be decided by the team]**.

## 5. Procedure (thesis, §4.2.5.3)

| Phase | Content | Duration | Instrument |
|---|---|---|---|
| 0 | PQC training (key structure, signing process, differences with RSA and ECDSA, institutional implications of the transition) | 3 h | [material](support_formation_pqc_en.md) |
| 1 | For each item: context, ML-DSA or SLH-DSA signature, verdict **without aid** then **with aid**, time and confidence | 4 h | [questionnaire](questionnaire_pqc_en.md), [stimuli](stimuli/catalogue_stimuli_pqc_en.md) |
| 2 | Quantum simulation, conditions A ($p = 0$), B ($0.001$), C ($0.01$), D ($0.1$) | 2 h | [conditions form](fiche_conditions_bruit_en.md), [interface](specification_interface_verification_en.md) |
| 3 | Test-retest after 2 weeks | 1 h | [test-retest form](fiche_test_retest_pqc_en.md) |
| 4 | PQC gold standard by experts | no participants | [grid](grille_gold_standard_pqc_en.md) |
| 5 | Debriefing | 30 min | [form](fiche_debriefing_pqc_en.md) |

### 5.1 Phase 1, with and without aid

For each item, the participant first gives a verdict from the file alone (`aid = 0`). They then receive an interpretation aid sheet specific to the scheme, and give a second verdict (`aid = 1`), which may be the same. This fixed order, without aid then with aid, keeps the aid from contaminating the first verdict. It does, however, confound the effect of the aid with that of a second look. This point is reported **[to be decided by the team]**.

Proposed design. 12 context–proof pairs (6 per scheme), each with 2 messages and 2 signature variants. Each participant handles 6 pairs, 3 per scheme, chosen by balanced rotation.

### 5.2 Phase 2, noise conditions

Each participant handles 12 items, 3 per condition. Conditions are presented in blocks, in a Williams order specific to the participant (`cro_terrain.p5.latin_square_order`). In conditions B to D, the verification result displayed comes from a simulated quantum verifier whose output qubit goes through a depolarising channel of parameter $p$. The displayed result is therefore flipped with probability $p/2$.

With the thesis values, this probability is at most 5 % (condition D). The expected effect on $\hat\Delta_q$ is small. The power to detect the decrease (prediction 4) must be assessed by simulation before data collection **[to be decided by the team]**.

## 6. Estimators (algorithm `alg:estimation_delta_q`)

1. Present $\sigma_i$ with its context $C$, in the simulated environment.
2. Record verdicts $V^q$, confidence, times and interpretation errors.
3. Match each verdict with the message $m$.
4. Test admissibility $V^q \perp M \mid (\Sigma, C)$.
5. Estimate $\hat\Delta_q = \hat I(V^q;\Sigma\mid M,C)$, per condition and per aid modality (`p5.delta_q_by_condition`).
6. Estimate $\hat\eta_q$ by regression on the noise levels (`p5.eta_q_regression`). For each condition, $\hat\eta_q(p) = [\hat I(V;\Sigma\mid C)_A - \hat I(V;\Sigma\mid C)_p]/H(C)$, from equation `eq:estimateur_eta_q`, with condition A as reference. The slope of $\hat\eta_q(p)$ in $p$ is reported.
7. Validate by test-retest and inter-rater agreement (thresholds ICC $\geq 0.8$ and $\kappa \geq 0.7$ of P4).

An **interpretation error** is a verdict different from the gold-standard reference verdict for the same stimulus, message and condition (`p5.interpretation_errors`).

The thesis notes that in the quantum regime low test-retest stability may reflect either the actors' inconsistency or an instability of the channel. The measurement is therefore first repeated at constant noise (condition A) before $p$ varies. The phase 3 test-retest covers condition A only.

## 7. Predictions (thesis, §4.2.5.5)

1. $\hat\Delta_q < \hat\Delta$ for untrained actors (adaptation penalty).
2. $\hat\Delta_q \to \hat\Delta$ for PQC experts (successful adaptation).
3. $\hat\Delta_q \in [28, 67]$ bits for well-prepared institutions.
4. Decrease of $\Delta_q$ with the quantum noise level.
5. Positive correlation between PQC training and $\Delta_q$.

Predictions 1 and 2 compare $\hat\Delta_q$ with a classical $\hat\Delta$. The latter is measured either on the same participants with classical P1 stimuli, or on a comparable P1 stratum **[to be decided by the team]**. The function `p5.check_predictions` gives a descriptive reading. The confirmatory test of each prediction is fixed in the [pre-registration](../00_commun/preenregistrement_en.md).

## 8. Analysis

The [cro_terrain](../analyse/README_en.md) package reads the [template](gabarit_sessions_pqc_en.csv) (schema `p5_sessions`). The columns `aid`, `noise_condition`, `p_noise`, `gold_verdict` and `interpretation_error` correspond to sections 5 and 6. The CI of $\hat\Delta_q$ is obtained by bootstrap over participants (`statistics.cluster_bootstrap`).

## 9. Duration, resources and timetable

The thesis plans 6 months, 80 PQC professionals and an estimated cost of 12,000,000 FCFA (table `tab:programme_experimental`), in window A13–A24 of the calendar (table `tab:calendrier_experimental`). The internal breakdown is **[to be decided by the team]**.

## 10. Prerequisites

☐ Agreements with the institutions ([template](../00_commun/convention_institution_partenaire_en.md))
☐ Favourable opinion of the ethics committee ([template](../00_commun/dossier_comite_ethique_en.md))
☐ 12 stimulus pairs written and their 48 signatures verified
☐ Verification interface developed and tested, noise-draw log enabled
☐ Power simulation for prediction 4
☐ Pre-registration filed ([template](../00_commun/preenregistrement_en.md))
☐ All [to be decided by the team] items resolved

Licence CC BY 4.0.
