# P1: CLO framework (IEEE Access, 2026)

> **Status: PUBLISHED** · Source: *IEEE Access*, vol. 14, pp. 20427–20445, 2026, DOI [10.1109/ACCESS.2026.3660105](https://doi.org/10.1109/ACCESS.2026.3660105) · Thesis, Chapter 2, §2.2

[Version française](README_fr.md)

## Reference

T. E. MINKA MI NGUIDJOÏ, F. S. MANI ONANA, T. DJOTIO NDIÉ, "Cryptographic Legal Opposability (CLO) Framework: Confidentiality-Reliability-Opposability Trade-Offs in Institutional Cryptography", *IEEE Access*, vol. 14, pp. 20427–20445, 2026. Received 4 December 2025, accepted 21 January 2026, published 2 February 2026. BibTeX entry in [`CITATION.bib`](CITATION.bib).

## Files

| File | Contents |
|---|---|
| [`article.pdf`](article.pdf) | Version published by the publisher (19 pages) |
| [`source/Final_CLO_Framework.tex`](source/Final_CLO_Framework.tex) | LaTeX source of the final submitted version |
| [`CITATION.bib`](CITATION.bib) | Bibliographic reference |

## Licence

The article is published open access by IEEE under the Creative Commons Attribution 4.0 licence (CC BY 4.0), with the notice "© 2026 The Authors". Redistribution here is permitted provided the reference above is cited.

## Summary

The article starts from a tension observed in cryptographic evidence systems, where stronger security often comes with greater opacity for the institutions that must decide. It proposes the Cryptographic Legal Opposability (CLO) framework, which defines three information-theoretic measures. Confidentiality $\mathrm{Conf}$ and reliability $\mathrm{Rel}$ stand alongside opposability $\mathrm{Opp}$, a new measure of the share of the institutional verdict uncertainty that the proof resolves. The article establishes bounds on these measures and feasibility constraints, including a context bottleneck theorem in which the context entropy $H(C)$ appears as the limiting factor. It presents the Semantic One-Time Pad (S-OTP) construction with three layers (Gold, Iron, Clay) and composition rules. Theoretical case studies of deployed systems (Helios, zk-SNARKs, ECDSA) place their products $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}$ between 0.27 and 0.57. Establishing general impossibility bounds is left as an open problem.

## Role in the thesis

The article underpins contribution **C1** of the thesis (CLO framework, Chapter 2, §2.2 "Le cadre CLO : formalisation des mesures"). The open problem it states is addressed by P2 (contribution C2).

## What the thesis refines

The thesis does not rewrite the article. It takes up its framework and adds the following clarifications, flagged in the manuscript by explicit remarks. The statement-by-statement detail is in [`../../03_resultats_these/resultats_these_en.md`](../../03_resultats_these/resultats_these_en.md). No document of refined statements accompanies P1 in this repository.

| Item | In the article | In the thesis | Thesis reference |
|---|---|---|---|
| Reliability | Operational verification reliability | Distinction between $\mathrm{Rel}_{\mathrm{rec}}$ (reconstruction, controlled by Fano) and $\mathrm{Rel}_{\mathrm{ver}}$ (completeness and soundness of verification) | `def:fiabilite_clo`, `rem:rel_ver`, §2.2.2.2 |
| Context bottleneck | $I(V;\Sigma\mid C)\le\min\{H(\Sigma\mid C),H(V\mid C)\}$, extraction capped by $H(C)$ | Cap $\alpha H(C)$ set by the verdict granularity | `thm:goulot_contexte` (Theorem 2.2), §2.2.3 |
| Interpretation | Verdict as a deterministic function of $(\Sigma,C)$ | A deterministic verdict gives $\mathrm{Opp}=1$ for every protocol; the framework retains admissible interpretations | `rem:verdict_deterministe` (Remark 2.4), `def:interp_admissible`, §2.2.3 and §2.3.1.2 |
| Composition | Product lower bounds in sequence, $\mathrm{Opp}\ge\min$ in sequence and $\mathrm{Opp}\approx$ product in parallel | Rules rewritten for post-processing and joint publication; the article's opposability rules are treated as heuristics | `thm:composition_sequentielle` (Theorem 2.3), `rem:composition_opp`, §2.2.3 |
| Optimality of S-OTP | Optimality theorem within the OTP class | Heuristic argument, the optimality proof remaining open | `thm:optimalite_sotp` (Remark 3.3), §3.2 |
| Case studies | Products 0.27 to 0.57 related to CRO trade-offs | Values expressed on the operational scale ($\mathrm{Rel}_{\mathrm{ver}}$), used as illustrative calibration | `rem:portee_cas_etude` (Remark 2.19), §2.3.3 |
