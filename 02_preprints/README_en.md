# IACR ePrint preprints cited in the thesis

> **Status: PREPRINT (not peer-reviewed)** · Source: Cryptology ePrint Archive, 2025

[Version française](README_fr.md)

This folder gathers the records of the nine preprints deposited in 2025 on the IACR ePrint archive and cited in the thesis. PREPRINT status means that these documents have not been peer-reviewed. Their results are therefore not presented as validated. Only articles P1, P2 and P3, published in IEEE Access in 2026, have PUBLISHED status (see [01_publie](../01_publie/)).

Each subfolder contains a bilingual record (reference, abstract, role in the thesis, reservations stated in the thesis) and a BibTeX entry `CITATION.bib` taken from the thesis bibliography. The PDFs are not included. They are available on ePrint, where all nine deposits display the CC BY 4.0 licence (checked on 2026-10-12).

## Table of preprints

| ePrint no. | Title | Topic | Link with the thesis | Record |
|---|---|---|---|---|
| [2025/1138](https://eprint.iacr.org/2025/1138) | ZK-NR: A Layered Cryptographic Architecture for Explainable Non-Repudiation | Layered non-repudiation protocol (exploration) | Axis II (ZK-NR v1) | [2025-1138_ZK-NR](2025-1138_ZK-NR/README_en.md) |
| [2025/1348](https://eprint.iacr.org/2025/1348) | The CRO Trilemma: A Formal Incompatibility between Confidentiality, Reliability and Legal Opposability in Post-Quantum Proof Systems | CRO impossibility bound (earlier form) | Antecedent of the Trilemma (superseded by P2) | [2025-1348_CRO-Trilemma](2025-1348_CRO-Trilemma/README_en.md) |
| [2025/1380](https://eprint.iacr.org/2025/1380) | Quantum Composable and Contextual Security Infrastructure (Q2CSI): A Modular Architecture for Legally Explainable Cryptographic Signatures | Iron/Gold/Clay layered meta-architecture (UC) | Axis II (Q2CSI) | [2025-1380_Q2CSI](2025-1380_Q2CSI/README_en.md) |
| [2025/1422](https://eprint.iacr.org/2025/1422) | Design ZK-NR: A Post-Quantum Layered Protocol for Legally Explainable Zero-Knowledge Non-Repudiation Attestation | ZK-NR protocol design | Axis II (ZK-NR v2) | [2025-1422_ZK-NR-Design](2025-1422_ZK-NR-Design/README_en.md) |
| [2025/1529](https://eprint.iacr.org/2025/1529) | UC-Security of the ZK-NR Protocol under Contextual Entropy Constraints: A Composable Zero-Knowledge Attestation Framework | UC security proof of ZK-NR | Axis II (ZK-NR v3) | [2025-1529_ZK-NR-UC](2025-1529_ZK-NR-UC/README_en.md) |
| [2025/1590](https://eprint.iacr.org/2025/1590) | The AIIP Problem: Toward a Post-Quantum Hardness Assumption from Affine Iterated Inversion over Finite Fields | Post-quantum hardness assumption (polynomial iteration) | Axis I (AIIP, basis of the CASH Toolkit) | [2025-1590_AIIP](2025-1590_AIIP/README_en.md) |
| [2025/1615](https://eprint.iacr.org/2025/1615) | The Chaotic Entropic Expansion (CEE): A Transparent Post-Quantum Data Confidentiality Primitive via Entropic Chaotic Maps | Confidentiality primitive (CASH, Gold layer) | Axis I (CASH, $\mathrm{Conf}$) | [2025-1615_CEE](2025-1615_CEE/README_en.md) |
| [2025/1662](https://eprint.iacr.org/2025/1662) | The Affine One-Wayness (AOW): A Transparent Post-Quantum Temporal Verification via Polynomial Iteration | Temporal verification primitive (CASH, Iron layer) | Axis I (CASH, $\mathrm{Rel}$) | [2025-1662_AOW](2025-1662_AOW/README_en.md) |
| [2025/1708](https://eprint.iacr.org/2025/1708) | The Semantic Holder (SH): Algebraic Extraction for Legal Opposability | Opposability primitive (CASH, Clay layer) | Axis I (CASH, $\mathrm{Opp}$) | [2025-1708_SH](2025-1708_SH/README_en.md) |

## Reading against the thesis

- **Antecedent of the Trilemma.** Preprint 2025/1348 contains an earlier form of the CRO bound. It is superseded by the published article P2 (Conditional CRO Trilemma), the only form retained in the thesis.
- **Axis I of the perspectives (computational foundations).** The AIIP problem (2025/1590) and the three primitives of the CASH Toolkit, CEE (2025/1615), AOW (2025/1662) and SH (2025/1708), aligned with $\mathrm{Conf}$, $\mathrm{Rel}$ and $\mathrm{Opp}$ respectively.
- **Axis II of the perspectives (protocol track).** The Q2CSI meta-protocol (2025/1380) and the three-stage ZK-NR series, exploration (2025/1138), design (2025/1422), then UC security (2025/1529).

The thesis states explicit reservations about several of these preprints. They concern the objection of inversion by successive root extractions for AIIP, the vacuous statistical-distance bound of CEE, the score $\Omega$ of SH and the index $\Gamma_\text{CRO}$ of Q2CSI and ZK-NR, neither of which is defined in the thesis. Each record gives the details.
