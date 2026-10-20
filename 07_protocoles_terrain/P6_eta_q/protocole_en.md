# Protocol for measuring $\eta_q$, quantum interpretability loss

> **Status: PROPOSAL. protocol not deployed, hypothetical scenario** · Source: thesis, Chapter 4, §4.2.6 (table `tab:val_canaux_quantiques`)

[Version française](protocole_fr.md) · [Folder README](README_en.md)

## 1. Aim and definition

Measure the quantum interpretability-loss coefficient $\eta_q$, the smallest coefficient such that

$$I(V^q;\Lambda(\rho_\Sigma)\mid C)_\rho \;\geq\; I(V^q;\rho_\Sigma\mid C)_\rho - \eta_q\,H(C)$$

(thesis, equation `eq:perte_interpretabilite_op`). The estimator is

$$\hat\eta_q = \frac{I(V^q;\rho_\Sigma\mid C)_\rho - I(V^q;\Lambda(\rho_\Sigma)\mid C)_\rho}{H(C)}$$

(equation `eq:estimateur_eta_q`).

## 2. Scope

ML-DSA, SLH-DSA and Falcon signatures are classical bit strings, for which $\eta_q = 0$. The protocol applies only to a scenario of quantum storage or verification, **hypothetical to date** (thesis, §4.2.6.1). Any value produced by P6 is a property of a model of this scenario, not a measurement on a deployed system.

## 3. Two strands

The thesis plans “40 experts and simulation” (table `tab:programme_experimental`). The proposal distinguishes two strands.

| Strand | Content | Instrument |
|---|---|---|
| Simulation | toy classical-quantum model, depolarising, dephasing and amplitude-damping channels, exact computation of $\hat\eta_q$ | `cro_terrain.quantum`, [simulation plan](plan_simulation_en.md), [parameter form](fiche_parametres_canaux_en.md) |
| Experts | 40 experts set, **before** the simulation, the predicted interval for $\eta_q$ used by the refutation criterion. They also check the calibration of the noise parameters against current quantum hardware. | [elicitation form](fiche_elicitation_experts_en.md) |

The thesis does not specify the role of the 40 experts. The proposal gives them the predicted interval, which the thesis requires to be fixed before the experiment (criterion on $\eta_q$ in table `tab:criteres_refutation`) **[to be decided by the team]**. A variant would have the experts judge degraded proofs, as in phase 2 of P5.

## 4. Material (thesis, §4.2.6.2)

| Element (thesis) | Proposed implementation |
|---|---|
| Quantum channel simulator (depolarising, dephasing, amplitude damping) | `cro_terrain.quantum.make_channel`: global depolarising (equation `eq:canal_depolarisant_op`), dephasing and amplitude damping applied qubit by qubit, plus a combined channel |
| Noise parameters calibrated on current hardware (IBM Quantum, IonQ, etc.) | [parameter form](fiche_parametres_canaux_en.md), values to be recorded with their source and date |
| PQC protocols with and without quantum assistance | toy model where the proof is encoded on $n$ qubits (“conjugate” basis, alternating Z and X), with as negative control the same proof read as a bit string |

Ranges tested (table `tab:val_canaux_quantiques`).

| Channel | Parameter | Range tested | Expected $\eta_q$ (thesis) |
|---|---|---|---|
| Depolarising | $p_{\text{dep}}$ | $[0.001, 0.1]$ | 0.02 to 0.20 |
| Dephasing | $p_{\text{deph}}$ | $[0.001, 0.05]$ | 0.01 to 0.10 |
| Amplitude damping | $\gamma_{\text{AD}}$ | $[0.001, 0.02]$ | 0.005 to 0.05 |
| Combined (typical NISQ) | — | — | 0.05 to 0.15 |

## 5. Procedure (thesis, §4.2.6.3)

1. **Calibration.** Noise-free baseline, $I(V^q;\rho_\Sigma\mid C)$ for each proof type.
2. **Controlled degradation.** Channels applied with increasing parameters, for example $\Lambda_{\text{dep}}(\rho) = (1-p)\rho + p\,I_d/d$ (equation `eq:canal_depolarisant_op`). $I(V^q;\Lambda(\rho_\Sigma)\mid C)$ is measured at each level.
3. **Regression.** Fit $\Delta I = \eta_q\,H(C)$ to extract $\hat\eta_q$.

Three complementary metrics are computed (thesis, §4.2.6.4): average fidelity $F_{\text{avg}}$, trace distance and information loss per contextual bit $\Delta I/H(C)$. All are written to the [template](gabarit_simulation_en.csv).

```sh
cd ../analyse
python3 -m cro_terrain.quantum --out ../P6_eta_q/sortie_plan_reference_en.csv --lang en
```

## 6. Predictions (thesis, §4.2.6.5)

1. $\hat\eta_q \in [0.05, 0.15]$ for a medium simulated at the error rates of current hardware (a priori values, to be pre-registered).
2. Order of magnitude of $\hat\eta_q\,H(C)$ compatible with the Alicki–Fannes–Winter continuity bound, expressed through the trace distance (heuristic).
3. Increasing relation, approximately linear at low noise, between $p_{\text{dep}}$ and $\hat\eta_q$.
4. $\hat\eta_q = 0$, up to sampling fluctuations, when the proof is read as a bit string (negative control).

The function `cro_terrain.p6.check_predictions` gives a descriptive reading. The refutation criterion uses the predicted interval set by the experts (section 3).

## 7. Caveats

1. **Structural ceiling.** Since $0 \leq I(V^q;\Lambda(\rho_\Sigma)\mid C) \leq I(V^q;\rho_\Sigma\mid C) \leq \log_2|\mathcal{V}|$, one always has $\hat\eta_q \leq I(V^q;\rho_\Sigma\mid C)/H(C) \leq \log_2|\mathcal{V}|/H(C)$ (`p6.eta_ceiling`). With four verdicts and $H(C) = 10.5$ bits, $\hat\eta_q \leq 0.19$. With $H(C) = 20$ bits, $\hat\eta_q \leq 0.10$. Reaching the predicted interval of 0.05 to 0.15 requires losing a large part of the extracted information.
2. **What the toy model gives.** On the [reference plan](sortie_plan_reference_en.csv), $\hat\eta_q$ increases with noise, satisfies the Alicki–Fannes–Winter heuristic and is exactly 0 for the negative control. With $H(C) = 10.5$ bits it reaches at most 0.030 (depolarising at $p = 0.1$) and 0.009 for the default combined channel. The toy model therefore stays far below the values expected in table `tab:val_canaux_quantiques`. This gap is a property of the model, with 2 or 3 qubits and provisional combined parameters. It is not a result about the quantum scenario.
3. **Combined-channel parameters.** They are provisional ($p_{\text{dep}} = 0.01$, $p_{\text{deph}} = 0.01$, $\gamma_{\text{AD}} = 0.005$, then multiplied by a scale factor). They must be replaced by sourced values ([parameter form](fiche_parametres_canaux_en.md)) before any pre-registration.
4. **No confidence interval in exact simulation.** The model is deterministic. The interval for $\hat\eta_q$ comes from the variation of uncertain parameters (calibration), not from sampling. The refutation criterion applies to this interval **[to be decided by the team]**.

## 8. Duration and resources

The thesis plans 4 months, 40 experts and the simulation, at an estimated cost of 8,000,000 FCFA (table `tab:programme_experimental`), in window A19–A30 (table `tab:calendrier_experimental`).

## 9. Prerequisites

☐ Channel parameters recorded and sourced ([form](fiche_parametres_canaux_en.md))
☐ Predicted interval set by the experts and registered ([form](fiche_elicitation_experts_en.md))
☐ Simulation plan frozen (version, $H(C)$, number of qubits, bases)
☐ Pre-registration filed ([template](../00_commun/preenregistrement_en.md))

Licence CC BY 4.0.
