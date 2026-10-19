# P6_eta_q — Measuring the quantum interpretability loss $\eta_q$

> **Status: PROPOSAL — protocol not deployed, hypothetical scenario** · Source: thesis, Chapter 4, §4.2.6

[Version française](README_fr.md) · [Back to the field protocols](../README_en.md)

P6 estimates $\hat\eta_q = [I(V^q;\rho_\Sigma\mid C) - I(V^q;\Lambda(\rho_\Sigma)\mid C)]/H(C)$ by simulating quantum channels. It concerns the hypothetical scenario of a quantum medium or verifier. For current post-quantum signatures, which are bit strings, $\eta_q = 0$. Elements that do not appear in the thesis are marked **[to be decided by the team]**.

## Contents

| Document | Role |
|---|---|
| [protocole_en.md](protocole_en.md) | Definition, scope, two strands (simulation and experts), procedure, predictions, caveats |
| [plan_simulation_en.md](plan_simulation_en.md) | Versioned plan `plan-v0.1`: model, channels, levels, controls, outputs |
| [fiche_parametres_canaux_en.md](fiche_parametres_canaux_en.md) | Sourced record of hardware error rates and conversion into channel parameters |
| [fiche_elicitation_experts_en.md](fiche_elicitation_experts_en.md) | Predicted interval for $\eta_q$ set by 40 experts before the simulation |
| [sortie_plan_reference_en.csv](sortie_plan_reference_en.csv) | Output of `plan-v0.1` (200 runs), reproduced exactly by a test |
| [gabarit_simulation_en.csv](gabarit_simulation_en.csv) | Template for simulation outputs |

## Running and analysis

```sh
cd ../analyse
python3 -m cro_terrain.quantum --out ../P6_eta_q/sortie_plan_reference_en.csv --lang en
```

```python
from cro_terrain.templates import read_template
from cro_terrain import p6

s = p6.summarize(read_template("sortie_plan_reference_en.csv", "p6_simulation"))
print(p6.check_predictions(s))
```

## What the reference plan shows

These are properties of the toy model, not results.

- $\hat\eta_q$ increases with noise on all four channels and satisfies the Alicki–Fannes–Winter heuristic.
- The negative control (proof read as a bit string) gives exactly $\hat\eta_q = 0$.
- With $H(C) = 10.5$ bits, $\hat\eta_q$ does not exceed 0.030 and is at most 0.009 for the provisional combined channel. It therefore stays far below the interval of 0.05 to 0.15 expected in the thesis.
- A structural ceiling always applies, $\hat\eta_q \leq I(V^q;\rho_\Sigma\mid C)/H(C) \leq \log_2|\mathcal{V}|/H(C)$. It is about 0.14 in the model at $H(C) = 10.5$ bits, and 0.07 at $H(C) = 20$ bits.

## Licence

CC BY 4.0 for the documents and outputs. The code is in the analysis package (MIT).
