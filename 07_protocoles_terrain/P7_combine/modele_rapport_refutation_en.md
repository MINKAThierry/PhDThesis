# Refutation report template (P7, programme synthesis)

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.7.3 (table `tab:criteres_refutation`) and §4.2.7.2, part D

[Version française](modele_rapport_refutation_fr.md) · [P7 protocol](protocole_en.md)

Final report of the experimental programme. For each pre-registered criterion, it gathers the inputs, the decision and the reliability mention. It then presents the cross-validation of the predictions. The function `cro_terrain.refutation.apply_criteria` produces the decisions on the criteria from a results dictionary.

## 1. Header

| Field | Value |
|---|---|
| Pre-registration | reference ______, filed on __/__/____ |
| Protocols whose data are used | ☐ P1 ☐ P2 ☐ P3 ☐ P4 ☐ P5 ☐ P6 |
| Analysis package version | ______ |
| Deviations from the pre-registration | ☐ none ☐ yes, forms `ECART-____` |

## 2. Decisions per criterion

| Parameter | Population or system | Inputs | Reliability | Decision |
|---|---|---|---|---|
| $\Delta$ | ______ | lower bound ____, capacity ____ | ☐ OK ☐ insufficient | ☐ not refuted ☐ refuted ☐ not probative |
| Admissibility | ______ | $p =$ ____, informative strata ____ | ☐ OK ☐ insufficient | ☐ not refuted ☐ refuted ☐ not testable |
| $\gamma$ or $\gamma_q$ | ______ | upper bound ____, threshold ____ | ☐ OK ☐ insufficient | ☐ not refuted ☐ refuted ☐ not probative |
| $\eta_q$ | simulated scenario | CI [____ ; ____], predicted interval [____ ; ____] | not applicable | ☐ not refuted ☐ refuted ☐ not probative |
| Helios $\mathsf{Opp}$ (P3) | ENSP | $\mathsf{Opp}_{\text{emp}} =$ ____, CI [____ ; ____] | | ☐ agreement ☐ disagreement ☐ agreement with significant gap ☐ inconclusive |
| Classical bound | ______ | see the comparison form | | ☐ not refuted ☐ refuted ☐ not probative |
| Post-quantum bound | ______ | see the comparison form | | ☐ not refuted ☐ refuted ☐ not probative |

If a reliability step does not meet its thresholds (ICC $\geq 0.8$, $\kappa \geq 0.7$), the corresponding decision is reported but marked “not applicable”.

## 3. Cross-validation (part D)

One row per standard and per parameter (`p7.cross_validation`). The predicted value is that of the illustrative calibration of the thesis or the one registered before the experiment.

| Standard | Parameter | Predicted value | Measured value | 95 % CI | Relative error | Predicted in CI |
|---|---|---|---|---|---|---|
| ML-DSA-65 | $\Delta_q$ | | | | | ☐ |
| SLH-DSA | $\Delta_q$ | | | | | ☐ |
| (simulated scenario) | $\eta_q$ | | | | | ☐ |
| | | | | | | ☐ |

The thesis algorithm speaks of “three PQC standards”. Since ML-KEM, which produces no proof, was excluded, two signature schemes remain. The report states the number of standards actually compared.

## 4. Reading

Write following these rules.

1. A non-probative comparison is neither a confirmation nor a refutation. It is reported together with the missing hypothesis.
2. A refutation concerns the hypothesis or value designated by the criterion. It does not extend to the framework of institutional cryptography as a whole.
3. The values of the illustrative calibration (ECDSA, Helios, zk-SNARK, ML-DSA) are not instances of the theorem. Their gap with the measurements is read as a revision of the calibration.
4. The results on $\eta_q$ hold only for the simulated scenario.

## 5. Independent review

Two validators of the panel who took no part in the analysis review the report and the [hypothesis checklist](liste_verification_hypotheses_en.md).

| Validator | Agrees with the decisions | Reservations |
|---|---|---|
| `P7-VA-__` | ☐ yes ☐ no | |
| `P7-VA-__` | ☐ yes ☐ no | |

Licence CC BY 4.0.
