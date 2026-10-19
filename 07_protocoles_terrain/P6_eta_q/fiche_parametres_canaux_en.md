# Channel parameter form (P6)

> **Status: PROPOSAL — hypothetical scenario** · Source: thesis, Chapter 4, §4.2.6.2 (“noise parameters calibrated on the specifications of current quantum hardware (IBM Quantum, IonQ, etc.)”)

[Version française](fiche_parametres_canaux_fr.md) · [P6 protocol](protocole_en.md) · [Simulation plan](plan_simulation_en.md)

The form records, for each platform retained, the error rates published by the provider, then their conversion into channel parameters. **No value is pre-filled.** Specifications change often and each value must carry its source and date of consultation.

## 1. Record per platform

| Platform | Processor or model | Source (URL or document) | Date consulted | 1-qubit error | 2-qubit error | $T_1$ | $T_2$ | Gate duration | Readout error |
|---|---|---|---|---|---|---|---|---|---|
| | | | __/__/____ | | | | | | |
| | | | __/__/____ | | | | | | |
| | | | __/__/____ | | | | | | |

Recorded by ______ and checked by ______.

## 2. Conversion into channel parameters

Usual conversions, to be checked by the team and cited in the pre-registration **[to be decided by the team]**.

| Model parameter | Proposed conversion | Value retained |
|---|---|---|
| $p_{\text{dep}}$ (global depolarising on $d = 2^n$ dimensions) | average gate error $r$ of the register, $p_{\text{dep}} = r\,d/(d-1)$ for the channel $(1-p)\rho + p\,I_d/d$ (i.e. $2r$ for one qubit) | ______ |
| $\gamma_{\text{AD}}$ (amplitude damping) | $\gamma = 1 - e^{-t/T_1}$ for a storage or processing time $t$ | ______ (with $t =$ ______) |
| $p_{\text{deph}}$ (dephasing) | pure dephasing $1/T_\phi = 1/T_2 - 1/(2T_1)$, $p = \tfrac12\bigl(1 - e^{-t/T_\phi}\bigr)$ | ______ |
| Duration $t$ of the scenario | assumed storage or verification time | ______ |

## 3. Combined-channel parameters

| Parameter | Provisional value in `plan-v0.1` | Sourced value retained | Source |
|---|---|---|---|
| $p_{\text{dep}}$ | 0.01 | | |
| $p_{\text{deph}}$ | 0.01 | | |
| $\gamma_{\text{AD}}$ | 0.005 | | |
| Composition order | amplitude damping, dephasing, depolarising | | |

## 4. Check by the experts

The retained parameters are submitted to the expert panel with the [elicitation form](fiche_elicitation_experts_en.md), part B.

Panel agreement on the parameters ☐ yes ☐ with changes, recorded below

______________________________________________________________________

Licence CC BY 4.0.
