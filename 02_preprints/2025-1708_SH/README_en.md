# ePrint 2025/1708 - SH

> **Status: PREPRINT (not peer-reviewed)** · Source: Cryptology ePrint Archive, Report 2025/1708

[Version française](README_fr.md)

## Reference

| Field | Value |
|---|---|
| Title | The Semantic Holder (SH): Algebraic Extraction for Legal Opposability |
| Authors | T. E. Minka Mi Nguidjoï |
| Archive | Cryptology ePrint Archive, Report 2025/1708 |
| Link | <https://eprint.iacr.org/2025/1708> |
| Received / approved | 2025-09-20 / 2025-09-21 |
| ePrint category | Foundations |
| Keywords | Semantic Holder, CASH framework, legal opposability, AIIP problem, STARK proofs, verifiable computation, PQ cryptography |
| Licence shown on ePrint | CC BY 4.0 (checked on 2026-10-12) |
| BibTeX entry | [CITATION.bib](CITATION.bib) (key `MINKA2025SH`, taken from the thesis bibliography) |

This document is a preprint deposited on the IACR ePrint archive. It has not been peer-reviewed and its results must not be cited as validated.

## Abstract

Faithful paraphrase of the official abstract published on the ePrint page (accessed on 2026-10-12). The original text is authoritative and can be read at <https://eprint.iacr.org/2025/1708>.

The paper introduces the Semantic Holder (SH), the opposability component of the CASH (Chaotic Affine Secure Hash) toolkit, which completes the framework's implementation of the Q2CSI approach. SH produces legally opposable interpretations by algebraic extraction of information from polynomial iteration traces. It works alongside CEE (confidentiality) and AOW (reliability). Built on the AIIP problem, SH yields mathematically verifiable legal interpretations with guaranteed minimum opposability bounds. The author establishes an opposability score $\Omega \geq 0.60$, supported by guarantees of entropy preservation, institutional explainability and legal contestability. SH supports efficient STARK-based verifiable computation and cross-jurisdictional compatibility. Its quantum resistance follows from its reduction to AIIP hardness. Applications covered are legal smart contracts, regulatory compliance auditing and digital evidence authentication, with parameter recommendations for standard security levels. The work targets cryptographic systems operating under legal constraints, providing transparent and verifiable opposability without sacrificing security or performance.

## Role in the thesis

Opposability layer ($\mathrm{Opp}$) of the CASH Toolkit in Axis I of the perspectives ([chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). The thesis retains algebraic extraction from iterated-polynomial traces to produce legally opposable interpretations, together with the three targeted properties (entropy preservation, institutional explainability, STARK-verifiable legal contestability). It raises as an open question the definition of an opposability score for SH that is related to $\mathrm{Opp}$.

## Reservations stated in the thesis

The aggregate score $\Omega$ and the value $\Omega \geq 0.60$ put forward in the preprint are not defined within the framework of the thesis. They are not adopted there as results. The security of this primitive is reduced to AIIP (ePrint 2025/1590). The reservations the thesis states about AIIP therefore apply by inheritance, in particular the objection of inversion by successive root extractions (see [2025-1590_AIIP](../2025-1590_AIIP/README_en.md)).

## PDF and licence

The PDF is not included in this folder. It is available on ePrint at <https://eprint.iacr.org/2025/1708>. The ePrint page displays the Creative Commons Attribution 4.0 licence (CC BY 4.0), which permits redistribution with attribution. The PDF may therefore be added later, together with the required attribution notice.
