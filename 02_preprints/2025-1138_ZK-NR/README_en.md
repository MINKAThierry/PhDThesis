# ePrint 2025/1138 - ZK-NR

> **Status: PREPRINT (not peer-reviewed)** · Source: Cryptology ePrint Archive, Report 2025/1138

[Version française](README_fr.md)

## Reference

| Field | Value |
|---|---|
| Title | ZK-NR: A Layered Cryptographic Architecture for Explainable Non-Repudiation |
| Authors | T. E. Minka Mi Nguidjoï, F. S. Mani Onana, T. Djotio Ndié |
| Archive | Cryptology ePrint Archive, Report 2025/1138 |
| Link | <https://eprint.iacr.org/2025/1138> |
| Received / approved | 2025-06-16 / 2025-06-17 |
| ePrint category | Cryptographic protocols |
| Keywords | Non-Repudiation, Post-Quantum Crypto, Merkle, STARKs, Signatures, Tamarin |
| Licence shown on ePrint | CC BY 4.0 (checked on 2026-10-12) |
| BibTeX entry | [CITATION.bib](CITATION.bib) (key `MINKA2025ZKNR_Exploration`, taken from the thesis bibliography) |

This document is a preprint deposited on the IACR ePrint archive. It has not been peer-reviewed and its results must not be cited as validated.

## Abstract

Faithful paraphrase of the official abstract published on the ePrint page (accessed on 2026-10-12). The original text is authoritative and can be read at <https://eprint.iacr.org/2025/1138>.

The paper presents ZK-NR, a modular cryptographic protocol for privacy-preserving non-repudiation in the co-production of digital public services. It combines Merkle commitments, zero-knowledge proofs (STARKs), threshold BLS signatures and post-quantum Dilithium authentication. The protocol lets parties produce secure, verifiable and auditable evidence across decentralised infrastructures. Unlike conventional digital signatures or blockchain-based logs, it yields formally verifiable attestations without revealing sensitive content. The authors target public finance, e-government and regulated digital ecosystems.

The protocol is modelled in Tamarin and implemented as a proof of concept with open cryptographic tools. It is presented as a reproducible basis for systems that require long-term trust, data minimisation and legal admissibility, especially where citizens and institutions share responsibility for digital evidence. It addresses the tension between confidentiality and accountability. The work is stated to be preliminary. It focuses on architectural composition and implementation feasibility and includes no formal security proofs.

The ePrint page lists supplementary material (`zk-nr_sup_mat.zip`) containing the implementation scripts, execution logs and replication instructions. It announces UC proofs and a symbolic Tamarin verification to be submitted separately.

## Role in the thesis

First stage of the ZK-NR series, cited in Axis II of the perspectives (Chapter 5, "Protocol track. Q2CSI, ZK-NR and the instantiation of the SOTP spirit", [chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). The thesis refers to it as ZK-NR v1. It composes Merkle commitments, STARKs, threshold BLS signatures and Dilithium authentication into a non-disclosing non-repudiation protocol. It establishes conceptual feasibility, formal proofs being left to later versions (2025/1422, then 2025/1529).

## Reservations stated in the thesis

The thesis states no reservation specific to this preprint. It presents it as a feasibility step without formal proof. The index $\Gamma_\text{CRO}$ is not defined within the framework of the thesis. The numerical values Q2CSI and ZK-NR v3 give for it are therefore not adopted as results. Relating this index to the product $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}$ is an open question (Chapter 5, Perspectives, Axis II).

## PDF and licence

The PDF is not included in this folder. It is available on ePrint at <https://eprint.iacr.org/2025/1138>. The ePrint page displays the Creative Commons Attribution 4.0 licence (CC BY 4.0), which permits redistribution with attribution. The PDF may therefore be added later, together with the required attribution notice.
