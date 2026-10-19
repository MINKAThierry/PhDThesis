# ePrint 2025/1662 — AOW

> **Status: PREPRINT (not peer-reviewed)** · Source: Cryptology ePrint Archive, Report 2025/1662

[Version française](README_fr.md)

## Reference

| Field | Value |
|---|---|
| Title | The Affine One-Wayness (AOW): A Transparent Post-Quantum Temporal Verification via Polynomial Iteration |
| Authors | T. E. Minka Mi Nguidjoï |
| Archive | Cryptology ePrint Archive, Report 2025/1662 |
| Link | <https://eprint.iacr.org/2025/1662> |
| Received / approved | 2025-09-13 / 2025-09-17 |
| ePrint category | Foundations |
| Keywords | AOW, The AIIP, Verifiable Delay Functions (VDF), Distributed Synchronization, STARK, Byzantine Fault Tolerance, ZK Proof |
| Licence shown on ePrint | CC BY 4.0 (checked on 2026-10-12) |
| BibTeX entry | [CITATION.bib](CITATION.bib) (key `MINKA2025AOW`, taken from the thesis bibliography) |

This document is a preprint deposited on the IACR ePrint archive. It has not been peer-reviewed and its results must not be cited as validated.

## Abstract

Faithful paraphrase of the official abstract published on the ePrint page (accessed on 2026-10-12). The original text is authoritative and can be read at <https://eprint.iacr.org/2025/1662>.

Distributed systems need transparent means of verifying the order of events without relying on trusted authorities or synchronised clocks. The paper introduces Affine One-Wayness (AOW), a cryptographic primitive for post-quantum temporal verification based on iterated evaluation of polynomials over finite fields. The security of AOW is tightly reduced to the hardness of the discrete logarithm problem on high-genus hyperelliptic curves (HCDLP). It is also reduced to the AIIP problem, which draws on multivariate quadratic algebra and high-genus hyperelliptic curve arithmetic. The construction uses a transparent setup. The author claims formal security against both classical and quantum adversaries. AOW integrates efficiently with STARK proof systems for zero-knowledge verification of sequential computation, with logarithmic scaling. AOW is the reliability component of the CASH (Chaotic Affine Secure Hash) framework. It targets Byzantine-resistant event ordering and distributed synchronisation under standard cryptographic assumptions.

## Role in the thesis

Reliability layer ($\mathrm{Rel}$) of the CASH Toolkit in Axis I of the perspectives ([chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). The thesis retains temporal verification by iterated polynomial evaluation and STARK integration with logarithmic scaling. The temporal traceability that AOW produces, anchoring verifiable sequences without a trusted authority, feeds directly into $\mathrm{Opp}$, since the institution can establish when a proof was generated.

## Reservations stated in the thesis

The thesis states no reservation specific to AOW. It recalls that its security is reduced in the preprint to HCDLP and to AIIP, "whose status is discussed". The security of this primitive is reduced to AIIP (ePrint 2025/1590). The reservations the thesis states about AIIP therefore apply by inheritance, in particular the objection of inversion by successive root extractions (see [2025-1590_AIIP](../2025-1590_AIIP/README_en.md)). The current proofs of the toolkit operate in the random oracle model.

## PDF and licence

The PDF is not included in this folder. It is available on ePrint at <https://eprint.iacr.org/2025/1662>. The ePrint page displays the Creative Commons Attribution 4.0 licence (CC BY 4.0), which permits redistribution with attribution. The PDF may therefore be added later, together with the required attribution notice.
