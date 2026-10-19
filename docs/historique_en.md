# History of the work and of the repository

> **Status: PROPOSAL: repository documentation** · Source: records in [`../01_publie/`](../01_publie/README_en.md) and [`../02_preprints/`](../02_preprints/README_en.md), header of [`../05_formalisation_lean/ConditionalCRO.lean`](../05_formalisation_lean/ConditionalCRO.lean)

[Version française](historique_fr.md) · [Back to docs](README_en.md)

This document traces the order in which the results were produced, published and then refined. It serves to place a given version of a statement. Dates are those of the documents kept in the repository. When a date does not appear there, only the year is given.

## 1. Preprints (2025)

Nine preprints were posted on the IACR ePrint archive in 2025. They have not been peer reviewed.

| Period | Preprints | Later role |
|---|---|---|
| 2025 | [2025/1138](../02_preprints/2025-1138_ZK-NR/README_en.md) ZK-NR, [2025/1422](../02_preprints/2025-1422_ZK-NR-Design/README_en.md) ZK-NR Design, [2025/1529](../02_preprints/2025-1529_ZK-NR-UC/README_en.md) ZK-NR UC | Axis II of the perspectives (protocol track) |
| 2025 | [2025/1348](../02_preprints/2025-1348_CRO-Trilemma/README_en.md) CRO Trilemma | First form of the CRO bound, taken up and developed by article P2 |
| 2025 | [2025/1380](../02_preprints/2025-1380_Q2CSI/README_en.md) Q2CSI | Axis II (meta-architecture) |
| 2025 | [2025/1590](../02_preprints/2025-1590_AIIP/README_en.md) AIIP, [2025/1615](../02_preprints/2025-1615_CEE/README_en.md) CEE, [2025/1662](../02_preprints/2025-1662_AOW/README_en.md) AOW, [2025/1708](../02_preprints/2025-1708_SH/README_en.md) SH | Axis I of the perspectives (AIIP and CASH Toolkit) |

## 2. Published articles (2026)

| Article | Received | Accepted | Published | Reference |
|---|---|---|---|---|
| [P1](../01_publie/P1_CLO_IEEEAccess2026/README_en.md), CLO framework | 4 December 2025 | 21 January 2026 | 2 February 2026 | *IEEE Access* 14, pp. 20427–20445, DOI 10.1109/ACCESS.2026.3660105 |
| [P2](../01_publie/P2_CRO_IEEEAccess2026/README_en.md), conditional CRO trilemma | 6 February 2026 | 22 February 2026 | 27 February 2026 | *IEEE Access* 14, pp. 33263–33274, DOI 10.1109/ACCESS.2026.3669065 |
| [P3](../01_publie/P3_PQCRO_IEEEAccess2026/README_en.md), post-quantum extension | 19 June 2026 | 2 August 2026 | 12 August 2026 | *IEEE Access* 14, pp. 125130–125155, DOI 10.1109/ACCESS.2026.3722742 |

## 3. Lean 4 formalisation

Formalising the classical conditional CRO trilemma led to alternative, more precise formulations of several published statements of P2 and P3 (thesis, §3.4.9). These formulations are described in section 4.

| Version | Content | Where to find it |
|---|---|---|
| before 2.1 | working versions | not kept in this repository |
| 2.1 | full Mathlib import; same statements as version 2.2 except section 9 | working version, not kept in this repository |
| 2.2 (October 2026) | `import Mathlib`; section 9 added (`opp_eq_one_of_deterministic`, `deterministic_forces_capacity`, `trilemma_refined`, `refined_bound_is_fano_when_delta_ge_gamma`); verified on <https://live.lean-lang.org> | [`../05_formalisation_lean/ConditionalCRO.lean`](../05_formalisation_lean/ConditionalCRO.lean), Listing B.1 of the thesis |

The statements of version 2.1 are carried over unchanged into version 2.2 (thesis, Appendix B). The Lean and Mathlib versions are pinned at v4.34.0. An article presenting the formalisation is submitted to the *Journal of Automated Reasoning*.


## 4. Refined statements and versions of the thesis

| Date | Event | Location |
|---|---|---|
| 2026 | Refined statements submitted to *IEEE Access* for P2 (proof of the classical trilemma) | [`../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/`](../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/README_en.md) |
| 2026 | Refined statements submitted to *IEEE Access* for P3, parallel to those of P2 | [`../01_publie/P3_PQCRO_IEEEAccess2026/formulations_precisees/`](../01_publie/P3_PQCRO_IEEEAccess2026/formulations_precisees/README_en.md) |
| 28 September 2026 | Deposit of the thesis (262 pages), after incorporating the feedback from the academic expert review | [`../00_these/pdf/`](../00_these/pdf/README_en.md) |
| October 2026 | Final version of the manuscript (Lean formalisation 2.2 verified online, repository address) | [`../00_these/manuscrit/`](../00_these/manuscrit/README_en.md) |

The submitted refined statements are not published at the time the repository was built. They keep the status PROPOSAL (submitted refined statements). The statements refined by the thesis are listed in [`../03_resultats_these/`](../03_resultats_these/README_en.md).

## 5. Pending submissions

| Work | Journal | Folder |
|---|---|---|
| SOTP family | *IEEE Transactions on Information Theory* | [`../04_sotp/`](../04_sotp/README_en.md) |
| Lean 4 formalisation v2.2 | *Journal of Automated Reasoning* | [`../05_formalisation_lean/`](../05_formalisation_lean/README_en.md) |

## 6. Construction of this repository (October 2026)

Before this repository, the Lean formalisation and the calibration scripts were distributed in a separate companion repository. That earlier repository has been deleted. Its useful content was taken over here and reorganised. No link points to it.

| Date | Step |
|---|---|
| 12 October 2026 | Structure, status registers, records of the articles and preprints, `03_resultats_these/`, `04_sotp/` (including executable SOTP-High), `05_formalisation_lean/` and `06_calcul/` (17 tests passed); `CITATION.cff` at version `1.0.0-pre` |
| 12 and 13 October 2026 | Field instruments of protocols P1 to P7 and shared documents in `07_protocoles_terrain/` |
| 13 October 2026 | Analysis package `07_protocoles_terrain/analyse/` (111 tests passed) |
| 13 October 2026 | `docs/` folder |
| 19 October 2026 | Final version of the manuscript in `00_these/manuscrit/`, Lean file replaced by version 2.2 verified online, address `MINKAThierry/PhDThesis`, new seed for the P1 stimuli |

The manuscript sources in `00_these/manuscrit/` are those of the final version (see [`../00_these/README_en.md`](../00_these/README_en.md)).

The repository remains private until the defence. The steps planned afterwards are described in the [publication procedure](procedure_publication_en.md).

## Licence

CC BY 4.0.
