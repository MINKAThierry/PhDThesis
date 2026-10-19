# ePrint 2025/1380 — Q2CSI

> **Status: PREPRINT (not peer-reviewed)** · Source: Cryptology ePrint Archive, Report 2025/1380

[Version française](README_fr.md)

## Reference

| Field | Value |
|---|---|
| Title | Quantum Composable and Contextual Security Infrastructure (Q2CSI): A Modular Architecture for Legally Explainable Cryptographic Signatures |
| Authors | T. E. Minka Mi Nguidjoï, F. S. Mani Onana, T. Djotio Ndié, T. Bouetou Bouetou |
| Archive | Cryptology ePrint Archive, Report 2025/1380 |
| Link | <https://eprint.iacr.org/2025/1380> |
| Received / approved | 2025-07-29 / 2025-07-30 |
| ePrint category | Cryptographic protocols |
| Keywords | CRO Trilemma, Post-Quantum, UC Security, Contextual Signatures, Composable Protocols, Legal Opposability |
| Licence shown on ePrint | CC BY 4.0 (checked on 2026-10-12) |
| BibTeX entry | [CITATION.bib](CITATION.bib) (key `MINKA2025Q2CSI`, taken from the thesis bibliography) |

This document is a preprint deposited on the IACR ePrint archive. It has not been peer-reviewed and its results must not be cited as validated.

## Abstract

Faithful paraphrase of the official abstract published on the ePrint page (accessed on 2026-10-12). The original text is authoritative and can be read at <https://eprint.iacr.org/2025/1380>.

The authors start from the conflict between confidentiality, reliability and legal opposability, formalised as the CRO Trilemma, which sets an entropic bound $\Gamma_\text{CRO}$ on cryptographic security in contextual adversarial settings. They propose Q2CSI, a layered framework that addresses the trilemma by separation of concerns. Security is split into three isolated but composable layers, Iron (reliability, temporal and logging integrity), Gold (confidentiality, semantic entropy preservation) and Clay (opposability, institutional interpretability). The framework embeds entropic constraints into an extended Universal Composability (UC) model. It reports $\Gamma_\text{CRO} < 0.4$, presented as an improvement over monolithic designs, together with resilience to post-quantum threats. The architecture is instantiated abstractly with minimal primitives (IND-CCA2 encryption, EUF-CMA signatures) and validated in a symbolic UC framework. The proofs claim strict layer isolation, bounded contextual leakage and compatibility with quantum adversaries. The authors see it as groundwork for legally verifiable post-quantum protocols (zero-knowledge attestations, regulatory-compliant signatures). The note on the page states that the work builds on 2025/1348, that a concrete instantiation appears in 2025/1138 and that the paper contains no implementation artefacts and makes no performance claims.

## Role in the thesis

Central piece of Axis II of the perspectives ([chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). The thesis presents Q2CSI as the architectural translation of the SOTP spirit. The Iron ($\mathrm{Rel}$), Gold ($\mathrm{Conf}$), Clay ($\mathrm{Opp}$) decomposition transposes the Gold-Iron-Clay paradigm into Canetti's model. Q2CSI embodies the SOTP spirit as an architectural pattern rather than an abstract construction. An open question concerns its completeness, namely whether every institutional protocol that separates the three layers is UC-equivalent to a Q2CSI instantiation. Limitation L3 of Chapter 5 ([chap5/discussions.tex](../../00_these/manuscrit/chap5/discussions.tex)) also lists it among the preprints developing cryptographic games not yet published in a journal.

## Reservations stated in the thesis

The index $\Gamma_\text{CRO}$ is not defined within the framework of the thesis. The numerical values the preprint gives for it are therefore not adopted as results. Relating this index to the product $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}$ is an open question (Chapter 5, Perspectives, Axis II).

## PDF and licence

The PDF is not included in this folder. It is available on ePrint at <https://eprint.iacr.org/2025/1380>. The ePrint page displays the Creative Commons Attribution 4.0 licence (CC BY 4.0), which permits redistribution with attribution. The PDF may therefore be added later, together with the required attribution notice.
