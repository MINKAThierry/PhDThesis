# Data schema

> **Status: PROPOSAL — illustrative calibration** · Source: thesis, Chapter 4, `tab:parametres_reference` (§4.1.3), `sec:donnees_brutes` and `tab:structure_csv` (§4.4.10)

[Version française](SCHEMA_fr.md)

Licence CC BY 4.0. UTF-8 encoding, comma separator, decimal point.

All values are **illustrative calibration parameters**, not measurements (see [`../../03_resultats_these/resultats_these_en.md`](../../03_resultats_these/resultats_these_en.md), entries R9 and R14).

## `parametres_reference.csv`

This is the single reference table (`tab:parametres_reference` in the thesis). Every value of $H(C)$, $\Delta$ or $\alpha$ quoted in the manuscript must come from it. The file contains the three classical systems; the ML-DSA-65 row of the thesis table is in `calibration_pq.csv`.

| Column | Type | Description |
|---|---|---|
| `system` | text | System identifier |
| `usage` | text | Institutional context |
| `H_C_domaine` | real (bits) | Entropy of the general institutional context, "domain" (Chapter 2) |
| `H_C_espece` | real (bits) | Entropy of the context of a particular decision, "case" (`sec:derivation_opposabilite`) |
| `H_V_C_espece` | real (bits) | $H(V\mid C)$ derived from the case-level verdict space |
| `alpha` | real | Verdict granularity $\alpha$ |
| `beta` | real | Regularity $\beta$ (used by the SOTP heuristics) |
| `Delta` | real (bits) | Institutional extraction capacity $\Delta$ (calibration) |
| `lambda` | integer | Security parameter of the calibration |
| `Conf_clo`, `Rel_ver_clo`, `Opp_clo` | reals | CLO metrics from the CLO article (operational scale, verification reliability) |
| `product_clo` | real | Product $\mathrm{Conf}\cdot\mathrm{Rel}_{\mathrm{ver}}\cdot\mathrm{Opp}$ |
| `sotp_variant` | text | Reference SOTP variant |
| `sotp_d` | integer | Projection dimension (SOTP-Base only) |

## `calibration_pq.csv`

It reproduces `tab:decomposition_borne_pq` and the quantum sample of `sec:donnees_brutes`. A value $\eta_q>0$ corresponds to the **hypothetical scenario** of quantum storage or a quantum verifier. ML-DSA, SLH-DSA and ML-KEM produce classical bit strings, for which $\eta_q=0$.

| Column | Type | Description |
|---|---|---|
| `system` | text | Identifier (NIST submission name) |
| `nature` | text | Nature and FIPS name. ML-KEM is an encapsulation mechanism and **not** a proof |
| `Delta_q` | real (bits) | Quantum extraction capacity $\Delta_q$ |
| `alpha_q`, `beta_q` | reals | Granularity and regularity |
| `eta_q` | real | Interpretability loss coefficient (scenario) |
| `H_C` | real (bits) | Context entropy |
| `lambda` | integer | Security parameter |
| `product_clo` | real | CLO product (illustrative) |
| `borne_these` | real | Value printed in the thesis, equal to $(\Delta_q+\eta_q H(C))/\lambda$ |

## Mapping to `tab:structure_csv` (initial formulation)

| Former column | New | Reason |
|---|---|---|
| `product_meas` | `product_clo` | No measurement was carried out |
| `product_pred` | `product_clo` | The "prediction" was the CLO product itself ($\Delta:=\lambda\cdot$ product) |
| `borne` | `borne_these` (+ `borne_serree` computed by `validate_sotp.py`) | Distinguish the weakened form from the tight bound |
