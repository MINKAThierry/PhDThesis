# ePrint 2025/1422 - Design ZK-NR

> **Status: PREPRINT (not peer-reviewed)** · Source: Cryptology ePrint Archive, Report 2025/1422

[Version française](README_fr.md)

## Reference

| Field | Value |
|---|---|
| Title | Design ZK-NR: A Post-Quantum Layered Protocol for Legally Explainable Zero-Knowledge Non-Repudiation Attestation |
| Authors | T. E. Minka Mi Nguidjoï, F. S. Mani Onana, T. Djotio Ndié, R. Atsa Etoundi |
| Archive | Cryptology ePrint Archive, Report 2025/1422 |
| Link | <https://eprint.iacr.org/2025/1422> |
| Received / approved | 2025-08-05 / 2025-08-07 |
| ePrint category | Cryptographic protocols |
| Keywords | ZK-NR, Q2CSI, CRO Trilemma, P-Q Cryptography, UC, Contextual Attestation, Legal Explainability, Dialectical Layering |
| Licence shown on ePrint | CC BY 4.0 (checked on 2026-10-12) |
| BibTeX entry | [CITATION.bib](CITATION.bib) (key `MINKA2025ZKNR_Design`, taken from the thesis bibliography) |

This document is a preprint deposited on the IACR ePrint archive. It has not been peer-reviewed and its results must not be cited as validated.

## Abstract

Faithful paraphrase of the official abstract published on the ePrint page (accessed on 2026-10-12). The original text is authoritative and can be read at <https://eprint.iacr.org/2025/1422>.

The paper presents the architectural design of ZK-NR, a layered cryptographic protocol for attestations that are post-quantum secure, legally interpretable and verifiably non-repudiable. It relies on three components, STARK-based zero-knowledge proofs, hybrid post-quantum signatures and entropy-accumulating ledger anchoring. ZK-NR meets the structural requirements of two existing models, the Q2CSI framework and the NIZK-E model. Semantic interpretability is achieved by keeping contextual proofs structurally separate from bounded explanations. Cryptographic soundness is targeted within the Universal Composability (UC) framework, formal UC proofs being deferred to a later article of the series (A.2). This article, the first of the series, covers architecture and functionality only. Later ones will address mathematical foundations, implementation strategies and operational validation with formal verification tools. The manuscript belongs to a research programme on the legal explainability of post-quantum protocols. It instantiates the generic Q2CSI framework (2025/1380), itself based on the CRO Trilemma (2025/1348). ZK-NR distributes the three guarantees across semantically separate layers (Iron, Gold, Clay) within a modular, UC-conformant architecture. The work is purely theoretical, with no implementation artefacts, benchmarks or experimental claims.

## Role in the thesis

Second stage of the ZK-NR series in Axis II of the perspectives ([chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). The thesis refers to it as ZK-NR v2. It builds the complete architecture satisfying the Q2CSI properties and the NIZK-E model, with structural separation between contextual proofs and bounded explanations.

## Reservations stated in the thesis

The thesis states no reservation specific to this preprint. A difference in wording is nevertheless worth noting. The thesis says that UC compatibility is "symbolically proven" there, whereas the ePrint abstract states that formal UC proofs are deferred to a later article of the series (2025/1529). The index $\Gamma_\text{CRO}$ used in the series (Q2CSI, ZK-NR v3) is not defined within the framework of the thesis.

## PDF and licence

The PDF is not included in this folder. It is available on ePrint at <https://eprint.iacr.org/2025/1422>. The ePrint page displays the Creative Commons Attribution 4.0 licence (CC BY 4.0), which permits redistribution with attribution. The PDF may therefore be added later, together with the required attribution notice.
