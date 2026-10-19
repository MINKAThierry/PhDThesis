# ePrint 2025/1615 - CEE

> **Status: PREPRINT (not peer-reviewed)** · Source: Cryptology ePrint Archive, Report 2025/1615

[Version française](README_fr.md)

## Reference

| Field | Value |
|---|---|
| Title | The Chaotic Entropic Expansion (CEE): A Transparent Post-Quantum Data Confidentiality Primitive via Entropic Chaotic Maps |
| Authors | T. E. Minka Mi Nguidjoï |
| Archive | Cryptology ePrint Archive, Report 2025/1615 |
| Link | <https://eprint.iacr.org/2025/1615> |
| Received / approved | 2025-09-08 / 2025-09-11 |
| ePrint category | Foundations |
| Keywords | finite fields, polynomial iteration, entropy bounds, post-quantum cryptography, one-way functions, CASH framework |
| Licence shown on ePrint | CC BY 4.0 (checked on 2026-10-12) |
| BibTeX entry | [CITATION.bib](CITATION.bib) (key `MINKA2025CEE`, taken from the thesis bibliography) |

This document is a preprint deposited on the IACR ePrint archive. It has not been peer-reviewed and its results must not be cited as validated.

## Abstract

Faithful paraphrase of the official abstract published on the ePrint page (accessed on 2026-10-12). The original text is authoritative and can be read at <https://eprint.iacr.org/2025/1615>.

The paper introduces the Chaotic Entropic Expansion (CEE), a one-way function built from iterated polynomial maps over finite fields. For polynomials in a specifically defined class, the author proves that after $N$ iterations the output retains a min-entropy of at least $\log_2 q - N\log_2 d$ bits. The statistical distance of the output from the uniform distribution is bounded by $(q-1)(d^N-1)/(2\sqrt{q})$. Security is formalised through the AIIP problem, with reductions relating its hardness to solving multivariate quadratic (MQ) equations and to computing discrete logarithms. Against quantum adversaries, CEE is claimed to reach $O(2^{\lambda/2})$ security for a classical security level of $\lambda$ bits. The paper includes cryptanalysis and parameter recommendations. CEE is acknowledged to be slower than AES. Its algebraic structure is presented as enabling applications in verifiable computation and post-quantum cryptography within the CASH framework. The note on the page describes it as the first component of the CASH framework (CEE, AOW, SH), a theoretical contribution without implementation or benchmarks.

## Role in the thesis

Confidentiality layer ($\mathrm{Conf}$) of the CASH Toolkit in Axis I of the perspectives ([chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). From CEE the thesis retains the lower bound on residual min-entropy and the distinctive feature of the construction, whose deliberately preserved algebraic transparency lets $\mathrm{Conf}$ coexist with $\mathrm{Opp}$ without structural conflict. An open question is whether the assembly $(CEE \,\|\, AOW \,\|\, SH)$ in a Gold-Iron-Clay architecture preserves the CRO bounds up to a constant factor.

## Reservations stated in the thesis

The statistical-distance-to-uniform bound announced in the preprint, $(q-1)(d^N-1)/(2\sqrt{q})$, exceeds $1$ as soon as $d^N > 2\sqrt{q}/(q-1) + 1$, that is for every useful $N$. It is then vacuous, since a statistical distance is always at most $1$. A non-trivial bound remains to be established. The thesis also notes that the current proofs of the toolkit operate in the random oracle model and that standard-model proofs would strengthen its foundation. The security of this primitive is reduced to AIIP (ePrint 2025/1590). The reservations the thesis states about AIIP therefore apply by inheritance, in particular the objection of inversion by successive root extractions (see [2025-1590_AIIP](../2025-1590_AIIP/README_en.md)).

## PDF and licence

The PDF is not included in this folder. It is available on ePrint at <https://eprint.iacr.org/2025/1615>. The ePrint page displays the Creative Commons Attribution 4.0 licence (CC BY 4.0), which permits redistribution with attribution. The PDF may therefore be added later, together with the required attribution notice.
