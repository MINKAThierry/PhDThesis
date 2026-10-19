# ePrint 2025/1590 — AIIP

> **Status: PREPRINT (not peer-reviewed)** · Source: Cryptology ePrint Archive, Report 2025/1590

[Version française](README_fr.md)

## Reference

| Field | Value |
|---|---|
| Title | The AIIP Problem: Toward a Post-Quantum Hardness Assumption from Affine Iterated Inversion over Finite Fields |
| Authors | T. E. Minka Mi Nguidjoï |
| Archive | Cryptology ePrint Archive, Report 2025/1590 |
| Link | <https://eprint.iacr.org/2025/1590> |
| Received / approved | 2025-09-03 / 2025-09-05 |
| ePrint category | Foundations |
| Keywords | AIIP, post-quantum cryptography, multivariate quadratic, hyperelliptic curve, hardness assumption, iterative inversion |
| Licence shown on ePrint | CC BY 4.0 (checked on 2026-10-12) |
| BibTeX entry | [CITATION.bib](CITATION.bib) (key `MINKA2025AIIP`, taken from the thesis bibliography) |

This document is a preprint deposited on the IACR ePrint archive. It has not been peer-reviewed and its results must not be cited as validated.

## Abstract

Faithful paraphrase of the official abstract published on the ePrint page (accessed on 2026-10-12). The original text is authoritative and can be read at <https://eprint.iacr.org/2025/1590>.

The paper proposes the Affine Iterated Inversion Problem (AIIP) as a candidate hardness assumption for post-quantum cryptography. Given a polynomial $f \in \mathbb{F}_q[x]$ of degree $d \geq 2$, an iteration count $n$ and a target $y$, the task is to find $x$ such that $f^{(n)}(x) = y$. Hardness is argued along two independent lines. The first links AIIP to the discrete logarithm problem in the Jacobian of hyperelliptic curves of very large genus, in whose arithmetic an AIIP instance is embedded. The second is a polynomial-time reduction to structured systems of multivariate quadratic (MQ) equations, presented as establishing worst-case hardness relative to MQ, an NP-hard problem. For the quadratic case $f(x) = x^2 + \alpha$ (here $\alpha \in \mathbb{F}_q$ is a polynomial constant, unrelated to the verdict granularity $\alpha$ of the thesis), the author argues that the resulting MQ system behaves heuristically like a random system. He states a sufficient condition for pseudorandomness based on a standard cryptographic assumption. The paper also provides a security analysis against classical and quantum attacks, concrete parameters for standard security levels and a discussion of uses in digital signatures and public-key encryption.

## Role in the thesis

Foundation of Axis I of the perspectives (Chapter 5, "Computational foundations. AIIP and the CASH Toolkit", [chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). The classical and quantum CRO Trilemmas are proven in the information-theoretic sense, but their practical instantiations require primitives resistant to QPT adversaries. AIIP is presented there as a candidate assumption for that purpose. It is also the common basis of the three primitives of the CASH Toolkit (CEE 2025/1615, AOW 2025/1662, SH 2025/1708). The short-term programme of Chapter 5 puts first the writing of the argument ruling out successive inversion by root extraction, then the cryptanalysis of AIIP, both prerequisites for any applied use of the CASH Toolkit. The publications appendix ([annexes/publications.tex](../../00_these/manuscrit/annexes/publications.tex)) also refers to this axis.

## Reservations stated in the thesis

The thesis does not adopt AIIP as an established assumption. It notes that the two announced reductions and their scope remain to be established independently. Above all, it raises an objection that must be lifted before AIIP can be regarded as a candidate assumption. Unless argued otherwise, solving $f^{(n)}(x) = y$ reduces to $n$ successive root extractions of a degree-$d$ polynomial over $\mathbb{F}_q$, following the successive preimages. These extractions take time polynomial in $n$, $d$ and $\log q$ using the Cantor–Zassenhaus algorithm. An argument ruling out this attack, for instance a control of the branching of the preimage tree, is therefore a prerequisite. Cryptanalysis (Gröbner attacks, point-counting algorithms, quantum variants such as Grover or quantum MNFS) remains to be carried out.

## PDF and licence

The PDF is not included in this folder. It is available on ePrint at <https://eprint.iacr.org/2025/1590>. The ePrint page displays the Creative Commons Attribution 4.0 licence (CC BY 4.0), which permits redistribution with attribution. The PDF may therefore be added later, together with the required attribution notice.
