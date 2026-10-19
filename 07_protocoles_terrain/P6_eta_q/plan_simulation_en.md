# Simulation plan (P6)

> **Status: PROPOSAL — hypothetical scenario, toy model** · Source: thesis, Chapter 4, §4.2.6.2 and §4.2.6.3 (table `tab:val_canaux_quantiques`)

[Version française](plan_simulation_fr.md) · [P6 protocol](protocole_en.md)

The plan fixes, before any run, the models, channels, noise levels and controls. The reference version is `plan-v0.1`, run by `cro_terrain.quantum.run_plan`. Its output is committed in [sortie_plan_reference_en.csv](sortie_plan_reference_en.csv). A test checks that it is reproduced exactly.

## 1. Model

| Element | Value in `plan-v0.1` | Role |
|---|---|---|
| Proof | $n$-bit string encoded on $n$ qubits | $\rho_\Sigma$ |
| Number of qubits $n$ | 2 and 3 | size of the medium |
| Encoding basis | “conjugate” (qubits alternately in Z and X basis) | makes the medium sensitive to all channels |
| Verdicts | 4, linked to the proof by a rule with error rate 0.1 | $V^q$, $|\mathcal{V}| = 4$ |
| Simulated contexts | 2, equiprobable | index $C$ of the conditional information |
| $H(C)$ in the denominator | 10.5 and 20 bits (case and domain values for ML-DSA, reference table of the thesis) | normalisation of $\hat\eta_q$ |
| Information | conditional Holevo quantity, exact computation | $I(V^q;\rho_\Sigma\mid C)$ |

$H(C)$ in the denominator is the institutional context entropy supplied by P2 or by the reference table. It is not the entropy of the two simulated contexts.

## 2. Channels and levels

| Channel | Levels in `plan-v0.1` | Thesis range |
|---|---|---|
| Depolarising, global on the $n$ qubits, $(1-p)\rho + p\,I_d/d$ | 0; 0.001; 0.002; 0.005; 0.01; 0.02; 0.05; 0.1 | $[0.001, 0.1]$ |
| Dephasing, on each qubit, $(1-p)\rho + p\,Z\rho Z$ | 0; 0.001; 0.002; 0.005; 0.01; 0.02; 0.05 | $[0.001, 0.05]$ |
| Amplitude damping, on each qubit | 0; 0.001; 0.002; 0.005; 0.01; 0.02 | $[0.001, 0.02]$ |
| Combined | scale factor 0; 0.25; 0.5; 1 applied to $(p_{\text{dep}}, p_{\text{deph}}, \gamma_{\text{AD}}) = (0.01; 0.01; 0.005)$, in the order amplitude damping, dephasing, depolarising | “typical NISQ” |

The combined-channel parameters and their composition order are provisional. They must be replaced by the values of the [parameter form](fiche_parametres_canaux_en.md) **[to be decided by the team]**.

## 3. Controls

| Control | Implementation | Expected |
|---|---|---|
| Negative (prediction 4) | same proof read and copied as a bit string, identity channel | $\hat\eta_q = 0$ exactly |
| Zero noise | level 0 of each channel | $\hat\eta_q = 0$ |
| Ceiling | $\hat\eta_q \leq I(V^q;\rho_\Sigma\mid C)/H(C)$ | always satisfied |
| AFW heuristic (prediction 2) | $\Delta I \leq 2\varepsilon\log_2|\mathcal{V}| + 2(1+\varepsilon)\,h(\varepsilon/(1+\varepsilon))$, with $\varepsilon$ the mean trace distance | indicative |

The AFW control uses the mean trace distance between encoded and degraded states. The Alicki–Fannes–Winter bound strictly applies to the joint state. The control therefore remains heuristic, as in the thesis.

## 4. Outputs

One row per run in the [template](gabarit_simulation_en.csv). The columns are `run_id`, `seed` (plan version), `channel`, `noise_param`, `proof_type`, `encoding` (`quantum` or `bitstring`), `n_qubits`, `H_C_bits`, `I_before_bits`, `I_after_bits`, `delta_I_bits`, `eta_hat`, `average_fidelity`, `trace_distance` and `notes`.

`plan-v0.1` produces 200 rows, i.e. 2 sizes × 2 values of $H(C)$ × 25 levels × 2 encodings.

## 5. Summary

`cro_terrain.p6.summarize` groups the runs by channel, encoding, number of qubits and $H(C)$. For each group it gives the maximum $\hat\eta_q$, the slope of $\hat\eta_q$ in the parameter, monotonicity, the ceiling and compliance with the AFW heuristic. `p6.check_predictions` reads the four predictions.

## 6. Changes to the plan

Any change (sourced parameters, new channels, more qubits) creates a new version `plan-vX.Y`. It is recorded here before running, with its date and reason.

| Version | Date | Change | Reason |
|---|---|---|---|
| plan-v0.1 | 12/10/2026 | initial plan | proposal |
| | | | |

Licence CC BY 4.0.
