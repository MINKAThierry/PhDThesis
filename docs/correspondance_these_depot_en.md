# Correspondence between the thesis and the repository

> **Status: PROPOSAL: repository documentation** · Source: thesis, PDF of the deposited version ([`../00_these/pdf/these_version_depot.pdf`](../00_these/pdf/these_version_depot.pdf)) and sources of the final version ([`../00_these/manuscrit/`](../00_these/manuscrit/))

[Version française](correspondance_these_depot_fr.md) · [Back to docs](README_en.md)

For every part of the thesis that relies on an artefact, this document gives the place in the repository where that artefact is found. The second part lists the discrepancies between the way the thesis describes the repository and its actual layout.

Section, table and listing numbers are those of the deposited PDF. LaTeX labels are those of the sources in `00_these/manuscrit/`. The thesis is written in French; section titles are translated here. The status of each item is given in [`../STATUS_en.md`](../STATUS_en.md). The statements added or refined by the thesis (R1 to R16) are detailed in [`../03_resultats_these/resultats_these_en.md`](../03_resultats_these/resultats_these_en.md).

## 1. Correspondence by chapter

### General introduction and Chapter 1

| Thesis | Source file | Repository |
|---|---|---|
| Table of contributions, row “Validation programme” | `intro_conclu_gen/introduction_generale.tex` | [`../07_protocoles_terrain/`](../07_protocoles_terrain/README_en.md) |
| Reference to the Lean formalisation | `intro_conclu_gen/introduction_generale.tex` | [`../05_formalisation_lean/`](../05_formalisation_lean/README_en.md) |
| §1.3.7 Formal verification (listing to paste into the online editor) | `chap1/etat_art.tex` | [`../05_formalisation_lean/ConditionalCRO.lean`](../05_formalisation_lean/ConditionalCRO.lean) |
| §1.4.3 Scientific objectives and programme, reference to the repository | `chap1/problematique.tex` | this repository (home page [`../README_en.md`](../README_en.md)) |

### Chapter 2. formal framework and impossibility bounds

| Thesis | Source file | Repository |
|---|---|---|
| §2.2 CLO framework | `chap2/clo.tex` | article P1 [`../01_publie/P1_CLO_IEEEAccess2026/`](../01_publie/P1_CLO_IEEEAccess2026/README_en.md); contributions R1 to R5 |
| §2.2.4 Quantum metrics, `def:perte_interp_quantique_pq` | `chap2/clo.tex`, `chap2/cro_pq.tex` | contribution R10 |
| §2.3 Classical conditional CRO trilemma, `thm:trilemme_cro_conditionnel` | `chap2/cro_classique.tex` | article P2 [`../01_publie/P2_CRO_IEEEAccess2026/`](../01_publie/P2_CRO_IEEEAccess2026/README_en.md) and its [refined statements](../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/README_en.md); contributions R6 to R9 |
| §2.3.2 and §2.3.4 Refined form `eq:trilemme_cro_raffine`, threshold $H^\sharp$ | `chap2/cro_classique.tex` | section 9 of [`ConditionalCRO.lean`](../05_formalisation_lean/ConditionalCRO.lean); check V14 of [`../06_calcul/python/verifications.py`](../06_calcul/python/verifications.py) |
| §2.3.5 Illustrative calibration of the classical parameters | `chap2/cro_classique.tex` | [`../06_calcul/data/parametres_reference.csv`](../06_calcul/data/parametres_reference.csv) |
| §2.4 Quantum extension, `thm:trilemme_pq` | `chap2/cro_pq.tex` | article P3 [`../01_publie/P3_PQCRO_IEEEAccess2026/`](../01_publie/P3_PQCRO_IEEEAccess2026/README_en.md) and its [refined statements](../01_publie/P3_PQCRO_IEEEAccess2026/formulations_precisees/README_en.md); contributions R11 and R12 |
| §2.4.6 Illustrative calibration of the quantum parameters | `chap2/cro_pq.tex` | [`../06_calcul/data/calibration_pq.csv`](../06_calcul/data/calibration_pq.csv) |

### Chapter 3. constructions and certification

| Thesis | Source file | Repository |
|---|---|---|
| §3.1 Status of the SOTP results, `rem:statut_sotp` | `chap3/introduction_chap3.tex` | [`../04_sotp/`](../04_sotp/README_en.md); contribution R13 |
| §3.2 Semantic One-Time Pad, basic construction | `chap3/sotp_base.tex` | [`../04_sotp/specification/`](../04_sotp/specification/README_en.md) |
| §3.3.2 SOTP-Low, `alg:sotp_low` | `chap3/sotp_construction.tex` | [`../04_sotp/reference_low_base/sotp_low.py`](../04_sotp/reference_low_base/sotp_low.py) |
| §3.3.3 SOTP-Base, `alg:sotp_base` | `chap3/sotp_construction.tex` | [`../04_sotp/reference_low_base/sotp_base.py`](../04_sotp/reference_low_base/sotp_base.py) |
| §3.3.4 SOTP-High | `chap3/sotp_construction.tex` | [`../04_sotp/high/`](../04_sotp/high/README_en.md) (Circom circuit, Groth16 proof) |
| §3.3.6 Universal optimality, `conj:optimalite_universelle` | `chap3/sotp_construction.tex` | [`../04_sotp/specification/`](../04_sotp/specification/README_en.md) (conjecture) |
| §3.4 Lean 4 formalisation | `chap3/cro_lean4.tex` | [`../05_formalisation_lean/`](../05_formalisation_lean/README_en.md) |
| §3.4.8 v2.2 extensions, `lst:lean4_extensions` | `chap3/cro_lean4.tex` | section 9 of [`ConditionalCRO.lean`](../05_formalisation_lean/ConditionalCRO.lean) |
| §3.4.9 What the formalisation revealed | `chap3/cro_lean4.tex` | refined statements for [P2](../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/README_en.md) and [P3](../01_publie/P3_PQCRO_IEEEAccess2026/formulations_precisees/README_en.md) |
| Scope witness `regime_assumption_necessary` | `chap3/cro_lean4.tex` | [`../05_formalisation_lean/cas_limite/`](../05_formalisation_lean/cas_limite/README_en.md); check V6 |

### Chapter 4. experimentation and validation

| Thesis | Source file | Repository |
|---|---|---|
| §4.1.3 Table 4.2, `tab:parametres_reference` | `chap4/introduction_chap4.tex` | [`../06_calcul/data/parametres_reference.csv`](../06_calcul/data/parametres_reference.csv); contribution R14 |
| §4.2.1 Measurement of $\Delta$, `eq:estimateur_delta` | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P1_delta/`](../07_protocoles_terrain/P1_delta/README_en.md); module `p1` of the analysis; contribution R15 |
| §4.2.2 Measurement of $H(\mathcal{C})$ | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P2_entropie_contexte/`](../07_protocoles_terrain/P2_entropie_contexte/README_en.md) |
| §4.2.3 Measurement of $\mathsf{Opp}$ on Helios | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P3_opp_helios/`](../07_protocoles_terrain/P3_opp_helios/README_en.md) |
| §4.2.4 Joint estimation of $\Delta$ and $\alpha$ | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P4_delta_alpha/`](../07_protocoles_terrain/P4_delta_alpha/README_en.md) |
| §4.2.5 Measurement of $\Delta_q$ | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P5_delta_q/`](../07_protocoles_terrain/P5_delta_q/README_en.md) |
| §4.2.6 Measurement of $\eta_q$ | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P6_eta_q/`](../07_protocoles_terrain/P6_eta_q/README_en.md) |
| §4.2.7 Combined protocol, `alg:protocole_combine` | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P7_combine/`](../07_protocoles_terrain/P7_combine/README_en.md) |
| §4.2.7.3 Table 4.7, `tab:criteres_refutation` | `chap4/protocoles.tex` | module `refutation` of [`../07_protocoles_terrain/analyse/`](../07_protocoles_terrain/analyse/README_en.md); contribution R16 |
| §4.2.8 Tables 4.8 and 4.9, schedule and resources | `chap4/protocoles.tex` | [`../07_protocoles_terrain/README_en.md`](../07_protocoles_terrain/README_en.md) and [`00_commun/`](../07_protocoles_terrain/00_commun/README_en.md) |
| §4.3 Derivation of the opposability values (Helios, Groth16, ECDSA, ML-DSA-65) | `chap4/derivation_opposabilite.tex` | [`../06_calcul/data/`](../06_calcul/data/SCHEMA_en.md); script [`validate_sotp.py`](../06_calcul/python/validate_sotp.py) |
| §4.4.1 to §4.4.4 Classical and quantum parameters, main comparison table | `chap4/validation_retrospective.tex` | [`validate_sotp.py`](../06_calcul/python/validate_sotp.py); outputs `calibration_classique_l128` and `calibration_pq_l128` in [`../06_calcul/results/`](../06_calcul/results/) |
| §4.4.2 Table 4.15, $\eta_q$ per channel type | `chap4/validation_retrospective.tex` | [`sensitivity_eta_q.py`](../06_calcul/python/sensitivity_eta_q.py); output `sensibilite_eta_q` |
| §4.4.5, §4.4.8 and §4.4.9 Uncertainty, dependence on $\lambda$, significance test | `chap4/validation_retrospective.tex` | checks V8, V9 and V10 of [`verifications.py`](../06_calcul/python/verifications.py) |
| §4.4.10 Table 4.21, CSV format | `chap4/validation_retrospective.tex` | [`../06_calcul/data/SCHEMA_en.md`](../06_calcul/data/SCHEMA_en.md) |
| §4.4.12 Reproducibility, `sec:reproductibilite` | `chap4/validation_retrospective.tex` | [`../06_calcul/reproduire.sh`](../06_calcul/reproduire.sh), [`../06_calcul/tests/`](../06_calcul/tests/); see also part 2 |
| §4.4.12 Table 4.23, `tab:environnement_calcul` | `chap4/validation_retrospective.tex` | [`../06_calcul/python/requirements.txt`](../06_calcul/python/requirements.txt), [`requirements-lock.txt`](../06_calcul/python/requirements-lock.txt), [`../05_formalisation_lean/lean-toolchain`](../05_formalisation_lean/lean-toolchain) |

### Chapter 5. conclusion and appendices

| Thesis | Source file | Repository |
|---|---|---|
| §5.2.1 Retrospective calibration | `chap5/resultats.tex` | [`../06_calcul/`](../06_calcul/README_en.md) |
| §5.2.2 Formal results, Table 5.5 | `chap5/resultats.tex` | [`../05_formalisation_lean/`](../05_formalisation_lean/README_en.md) |
| §5.3.11 Status of the experimental protocols | `chap5/discussions.tex` | [`../07_protocoles_terrain/`](../07_protocoles_terrain/README_en.md) |
| §5.4.2 Axis I (AIIP, CASH Toolkit) and §5.4.3 Axis II (Q2CSI, ZK-NR) | `chap5/perspectives.tex` | [`../02_preprints/`](../02_preprints/README_en.md) |
| Appendix A, game-based security of the SOTP family | `annexes/gamebased.tex` | [`../04_sotp/preuves_game_based/`](../04_sotp/preuves_game_based/README_en.md) |
| Appendix B, Listing B.1 `lst:lean4_complet` | `annexes/code_lean4.tex` | [`../05_formalisation_lean/ConditionalCRO.lean`](../05_formalisation_lean/ConditionalCRO.lean) |
| Appendix B, procedure `sec:lean4_reproduction` | `annexes/code_lean4.tex` | [`../05_formalisation_lean/README_en.md`](../05_formalisation_lean/README_en.md) |
| Appendix C, publications arising from the thesis | `annexes/publications.tex` | [`../01_publie/`](../01_publie/README_en.md) and [`../02_preprints/`](../02_preprints/README_en.md) |
| Bibliography entry `CROTrilemmaDepot` | `annexes/bibliographie.bib` | this repository; [`../CITATION.cff`](../CITATION.cff) |

## 2. Discrepancies between the thesis text and the repository

The final version of the manuscript, whose sources are in `00_these/manuscrit/`, describes the repository as it is organised. It cites the directories `05_formalisation_lean/` and `06_calcul/{python,data,results,tests}`, the command `./reproduire.sh` run from `06_calcul/` and the Lean file in version 2.2 verified online. The discrepancies noted on the deposited version on these points (E3 to E12) are therefore resolved. The following remain.

| No. | Place in the thesis | What the thesis says | Actual repository | Planned handling |
|---|---|---|---|---|
| E1 | `subsec:depot` (`chap4/validation_retrospective.tex`) | DOI `10.5281/zenodo.XXXXXXX` | No Zenodo DOI exists yet | DOI created at publication then carried over (procedure, steps 3 and 4) |
| E2 | same place; note of the entry `CROTrilemmaDepot` | version 1.0.0 | `CITATION.cff` carries version `1.0.0-pre` | tag `v1.0.0` set at publication |

None of these discrepancies affects a statement, a formula or a numerical value.

## Licence

CC BY 4.0.
