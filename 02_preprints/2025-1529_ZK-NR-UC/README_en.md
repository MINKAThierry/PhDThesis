# ePrint 2025/1529 — ZK-NR UC (v3)

> **Status: PREPRINT (not peer-reviewed)** · Source: Cryptology ePrint Archive, Report 2025/1529

[Version française](README_fr.md)

## Reference

| Field | Value |
|---|---|
| Title | UC-Security of the ZK-NR Protocol under Contextual Entropy Constraints: A Composable Zero-Knowledge Attestation Framework |
| Authors | T. E. Minka Mi Nguidjoï |
| Archive | Cryptology ePrint Archive, Report 2025/1529 |
| Link | <https://eprint.iacr.org/2025/1529> |
| Received / approved | 2025-08-26 / 2025-08-30 |
| ePrint category | Cryptographic protocols |
| Keywords | Universal Composability, ZK proofs, PQ cryptography, CRO trilemma, non-repudiation, contextual entropy |
| Licence shown on ePrint | CC BY 4.0 (checked on 2026-10-12) |
| BibTeX entry | [CITATION.bib](CITATION.bib) (key `MINKA2025ZKNR_UC`, taken from the thesis bibliography) |

This document is a preprint deposited on the IACR ePrint archive. It has not been peer-reviewed and its results must not be cited as validated.

## Abstract

Faithful paraphrase of the official abstract published on the ePrint page (accessed on 2026-10-12). The original text is authoritative and can be read at <https://eprint.iacr.org/2025/1529>.

The CRO Trilemma describes the conflict between confidentiality, reliability and legal opposability in proof systems. The paper gives a full Universal Composability (UC) security proof for the ZK-NR protocol, a layered design intended to approach the trilemma limit. Each of the three layers (Iron, Gold, Clay) is modelled as an ideal functionality with erasure semantics. The author proves that real and ideal executions are indistinguishable under post-quantum assumptions. He concludes that ZK-NR is composably secure and formally achieves a CRO index $\Gamma_\text{CRO} < 0.4 + \mathrm{negl}(\lambda)$ against adaptive contextual adversaries. The page states that the paper is theoretical, with no implementation details or performance metrics, and that it is the second of a series of four.

## Role in the thesis

Third stage of the ZK-NR series in Axis II of the perspectives ([chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). The thesis refers to it as ZK-NR v3. It establishes the complete UC proof for the three layers, modelled as ideal functionalities with erasure semantics, together with real/ideal indistinguishability under post-quantum assumptions. The short-term programme of Chapter 5 plans to exhibit the UC reduction between SOTP-High and ZK-NR v3, which would formally connect the abstract theory of SOTP to a composable instantiation. Limitation L3 ([chap5/discussions.tex](../../00_these/manuscrit/chap5/discussions.tex)) lists it among the preprints developing cryptographic games not yet published in a journal.

## Reservations stated in the thesis

The index $\Gamma_\text{CRO}$ is not defined within the framework of the thesis. The numerical values the preprint gives for it are therefore not adopted as results. Relating this index to the product $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}$ is an open question (Chapter 5, Perspectives, Axis II).

## PDF and licence

The PDF is not included in this folder. It is available on ePrint at <https://eprint.iacr.org/2025/1529>. The ePrint page displays the Creative Commons Attribution 4.0 licence (CC BY 4.0), which permits redistribution with attribution. The PDF may therefore be added later, together with the required attribution notice.
