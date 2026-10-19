# Expert elicitation form (P6)

> **Status: PROPOSAL — role of the experts to be decided** · Source: thesis, Chapter 4, §4.2.6 (“40 experts and simulation”); criterion on $\eta_q$ in table `tab:criteres_refutation` (“the 95 % CI of $\hat\eta_q$ excludes the interval predicted before the experiment”)

[Version française](fiche_elicitation_experts_fr.md) · [P6 protocol](protocole_en.md)

The refutation criterion on $\eta_q$ requires an interval predicted **before** the experiment. The thesis gives a priori values, 0.05 to 0.15 for a typical NISQ medium, and asks for them to be pre-registered. This form proposes that the interval be set by the panel of 40 experts planned in the thesis, in two rounds, before any run of the simulation plan. The experts see no output of the toy model. The form is administered in French. This English version is a working translation.

## 1. Panel

| Proposed profile | Number |
|---|---|
| Quantum information (theory) | 10 |
| Quantum hardware (experimentalists) | 10 |
| Post-quantum cryptography | 10 |
| Digital law and institutions | 10 |

Codes `P6-EX-NN` **[breakdown to be decided by the team]**.

## 2. Part A. Predicted interval for $\eta_q$ (round 1, then round 2 after anonymised feedback)

> **Scenario presented.** A cryptographic proof is stored or verified on a quantum medium. The medium undergoes noise comparable to that of current hardware, with the parameters of the [parameter form](fiche_parametres_canaux_en.md). The coefficient $\eta_q$ measures the share of the information useful to an institution that is lost, relative to the context entropy $H(C)$. It is 0 if nothing is lost.
>
> Recall that $\eta_q \leq \log_2|\mathcal{V}|/H(C)$, i.e. at most 0.19 with 4 verdicts and $H(C) = 10.5$ bits.

| Channel | Your best estimate of $\eta_q$ | Lower bound (5 %) | Upper bound (95 %) | Confidence 0–10 |
|---|---|---|---|---|
| Depolarising, $p = 0.01$ | | | | |
| Dephasing, $p = 0.01$ | | | | |
| Amplitude damping, $\gamma = 0.01$ | | | | |
| Combined (sourced parameters) | | | | |

Main argument (three lines at most)

______________________________________________________________________

The structural ceiling is given to the experts, since it follows from the definition. The thesis values are not given to them **[to be decided by the team]**.

## 3. Part B. Check of the parameters

For each parameter of the parameter form, the expert states whether it is representative of current hardware.

| Parameter | Proposed value | Representative ☐ yes ☐ no | Value proposed instead, with source |
|---|---|---|---|
| $p_{\text{dep}}$ | | ☐ ☐ | |
| $p_{\text{deph}}$ | | ☐ ☐ | |
| $\gamma_{\text{AD}}$ | | ☐ ☐ | |
| Duration $t$ of the scenario | | ☐ ☐ | |

## 4. Aggregation

| Element | Proposed rule **[to be decided by the team]** |
|---|---|
| Predicted interval per channel | median of the lower bounds and median of the upper bounds of round 2 |
| Stopping | two rounds. A third round only if the interquartile range of the best estimates exceeds half the median |
| Registration | interval and rule registered in the pre-registration before the plan is run |

The summary of each round may reuse `cro_terrain.p2.delphi_round_summary`.

## 5. Registered interval

| Channel | Predicted interval | Date registered | Pre-registration reference |
|---|---|---|---|
| Depolarising | [____ ; ____] | __/__/____ | |
| Dephasing | [____ ; ____] | __/__/____ | |
| Amplitude damping | [____ ; ____] | __/__/____ | |
| Combined | [____ ; ____] | __/__/____ | |

Licence CC BY 4.0.
