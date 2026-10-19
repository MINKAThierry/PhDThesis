# Proposed refined statements for P2

> **Status: PROPOSAL — submitted refined statements (not published)** · Source: document submitted to *IEEE Access* for the article DOI [10.1109/ACCESS.2026.3669065](https://doi.org/10.1109/ACCESS.2026.3669065) · Thesis, Chapter 2, §2.3 and Chapter 3, §3.4.9

[Version française](README_fr.md)

This folder contains the document that the authors submitted to the publisher for the article "The Conditional CRO Trilemma". It presents more precise formulations of several statements. It has not been published to date. Until the publisher accepts it, the published version of the article remains the bibliographic reference and the text below only has the standing of a proposal by the authors.

| File | Contents |
|---|---|
| [`Correction_CRO_Trilemma.tex`](Correction_CRO_Trilemma.tex) | LaTeX source (standard `article` class, compiles anywhere; to be pasted into the publisher's template for submission) |
| [`Correction_CRO_Trilemma.pdf`](Correction_CRO_Trilemma.pdf) | PDF built with pdfLaTeX (4 pages) |

The text is in English, the language of the article. It is not translated.

## Contents of the document

The formalisation of the results in Lean 4 brought out the points that this document refines. It has four parts.

1. Lemma 4 is restated in the form that its proof establishes, a lower bound $\mathrm{Conf}\ge 1-\sqrt{c_0\beta\, I(M;\Sigma\mid C)}$ instead of an upper bound. The constant $c_0=1/(2\ln 2)$ remains valid without being tight.
2. The verdict-efficiency condition used in Step 3 becomes the explicit Assumption 2′, $H(V\mid C)\ge\alpha H(C)-1=:\gamma\ge 1$.
3. The leakage regime $I(M;\Sigma\mid C)\le\kappa/\lambda$, which the initial formulation derived from an optimisation, becomes Assumption 4, since the alternative solution of that optimisation does not yield this regime. Theorem 1 receives a complete proof with explicit constants,
$$\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}\le\frac{1}{\gamma}\left(\frac{\Delta}{\lambda}+\frac{\kappa(\Delta+1)}{\lambda^2}+\frac{\kappa^2}{\lambda^3}\right)\le\frac{\Delta}{\lambda}+O(\lambda^{-2}).$$
A limiting case shows that Assumption 4 is necessary.
4. Remark 10 and Section VI-B are made more precise. The implied capacities of Table 2 are to be read as an empirical calibration of $\Delta$ on the CLO scale, independent of Theorem 1.

The institutional model (Assumptions 1 to 3), the role of the parameters $(\Delta,\alpha,\beta)$ and the form of the main bound are preserved within the stated regime.

## Link with the thesis

The thesis incorporates these formulations in §2.3 and traces them in §3.4.9 ("Ce que la formalisation a révélé"). It goes beyond this document on several points (admissible interpreter, foundation proposition for Assumption 1, refined form and threshold $H^\sharp$), listed in [`../README_en.md`](../README_en.md) and [`../../../03_resultats_these/resultats_these_en.md`](../../../03_resultats_these/resultats_these_en.md). The script that establishes numerically the limiting case of Theorem 1 in its initial formulation is in [`../../../05_formalisation_lean/cas_limite/`](../../../05_formalisation_lean/cas_limite/).

## Rebuilding

```bash
pdflatex Correction_CRO_Trilemma.tex
pdflatex Correction_CRO_Trilemma.tex
```
