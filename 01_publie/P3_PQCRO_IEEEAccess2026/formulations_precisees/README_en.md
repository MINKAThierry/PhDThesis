# Proposed refined statements for P3

> **Status: PROPOSAL — submitted refined statements (not published)** · Source: document submitted to *IEEE Access* for the article DOI [10.1109/ACCESS.2026.3722742](https://doi.org/10.1109/ACCESS.2026.3722742) · Thesis, Chapter 2, §2.4 and Chapter 3, §3.4.9

[Version française](README_fr.md)

This folder contains the document that the authors submitted to the publisher for the article "Post-Quantum Extension of the Conditional CRO Trilemma". It presents more precise formulations of several statements. It has not been published to date. Until the publisher accepts it, the published version of the article remains the bibliographic reference and the text below only has the standing of a proposal by the authors.

| File | Contents |
|---|---|
| [`Correction_PQ_CRO_Trilemma.tex`](Correction_PQ_CRO_Trilemma.tex) | LaTeX source (standard `article` class, compiles anywhere; to be pasted into the publisher's template for submission) |
| [`Correction_PQ_CRO_Trilemma.pdf`](Correction_PQ_CRO_Trilemma.pdf) | PDF built with pdfLaTeX (4 pages) |

The text is in English, the language of the article. It is not translated.

## Contents of the document

The proof of Theorem 2 takes up the points refined for the classical trilemma (see [`../../P2_CRO_IEEEAccess2026/formulations_precisees/`](../../P2_CRO_IEEEAccess2026/formulations_precisees/)). The document, parallel to that of P2, has four parts.

1. The formulation dispenses with Lemma 6, since two messages encoded in orthogonal states are a limiting case for inequality (68). It also dispenses with the upper bound (72) of Lemma 7, which depends on it. The lower bound (71) is restated with the Holevo information $\chi_{\max}$ instead of the accessible information.
2. The verdict-efficiency condition becomes the explicit Assumption 4′, $H(V\mid C)\ge\theta_q\alpha_q H(C)=:\gamma_q\ge 1$.
3. The leakage regime $\chi_{\max}\le\kappa/\lambda$ becomes Assumption 6. Theorem 2 receives a complete proof with explicit constants,
$$\mathrm{Conf}^q\cdot\mathrm{Rel}^q\cdot\mathrm{Opp}^q\le\frac{1}{\gamma_q}\left(\frac{\Delta_q}{\lambda}+\frac{\kappa(\Delta_q+1)}{\lambda^2}+\frac{\kappa^2}{\lambda^3}\right)\le\frac{\Delta_q+\eta_q H(C)}{\lambda}+O(\lambda^{-2})+\mathrm{negl}(\lambda).$$
Assumption 5 and the constant $C(\beta_q,\alpha_q)$ are no longer needed. Remark 17 is reformulated, since the regime $I=\Theta(\lambda)$ departs from the one in which the bound is established.
4. The implied capacities of Tables 8 to 10, the Dilithium-3 case study and item 2 of Remark 10 are to be read as an empirical calibration of $\Delta_q$ on the CLO scale, independent of Theorem 2.

The quantum institutional model (Assumptions 1 to 3), the parameters $(\Delta_q,\alpha_q,\beta_q,\eta_q)$, the quantum Fano step and the form of the main bound are preserved within the stated regime.

## Link with the thesis

The thesis incorporates these formulations in §2.4 and traces them in §3.4.9. On two points it goes further than the submitted document.

- It gives $\eta_q$ a single definition, as an interpretability loss, and renames $\zeta_q$ the regularity constant that the submitted document still writes $\eta_q$ in Lemma 7.
- It establishes that $D_{\max}$ is not negligible for NIST PQC signatures (more than $2.6\cdot10^4$ bits for ML-DSA-65), whereas the submitted document sets $D_{\max}=\mathrm{negl}(\lambda)$ for these schemes.

These differences are listed in [`../README_en.md`](../README_en.md) and [`../../../03_resultats_these/resultats_these_en.md`](../../../03_resultats_these/resultats_these_en.md).

## Rebuilding

```bash
pdflatex Correction_PQ_CRO_Trilemma.tex
pdflatex Correction_PQ_CRO_Trilemma.tex
```
