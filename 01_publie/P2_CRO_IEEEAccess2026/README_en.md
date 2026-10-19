# P2: Conditional CRO trilemma (IEEE Access, 2026)

> **Status: PUBLISHED** · Source: *IEEE Access*, vol. 14, pp. 33263–33274, 2026, DOI [10.1109/ACCESS.2026.3669065](https://doi.org/10.1109/ACCESS.2026.3669065) · Thesis, Chapter 2, §2.3

[Version française](README_fr.md)

## Reference

T. E. MINKA MI NGUIDJOÏ, F. S. MANI ONANA, T. DJOTIO NDIÉ, "The Conditional CRO Trilemma: Impossibility Bounds on Confidentiality, Reliability, and Opposability Under Institutional Extraction Limits", *IEEE Access*, vol. 14, pp. 33263–33274, 2026. Received 6 February 2026, accepted 22 February 2026, published 27 February 2026. BibTeX entry in [`CITATION.bib`](CITATION.bib).

## Files

| File | Contents |
|---|---|
| [`article.pdf`](article.pdf) | Version published by the publisher (12 pages) |
| [`source/Final_Conditional_CRO_Trilemma.tex`](source/Final_Conditional_CRO_Trilemma.tex) | LaTeX source of the final submitted version |
| [`CITATION.bib`](CITATION.bib) | Bibliographic reference |
| [`formulations_precisees/`](formulations_precisees/) | Refined statements submitted to the publisher, not published (status PROPOSAL) |

## Licence

The article is published open access by IEEE under the Creative Commons Attribution 4.0 licence (CC BY 4.0), with the notice "© 2026 The Authors". Redistribution here is permitted provided the reference above is cited.

## Summary

The article addresses the open problem left by the CLO framework, namely a theoretical explanation of the observed trade-offs between confidentiality, reliability and opposability. It introduces a formal model with institutional parameters, the extraction capacity $\Delta$, the verdict granularity $\alpha$ and the regularity $\beta$. Under explicit assumptions on the cognitive limits of institutions, it states the Conditional CRO Trilemma, $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}\le\Delta/\lambda+O(\lambda^{-2})+\mathrm{negl}(\lambda)$, where $\lambda$ is the security parameter. The proof combines Pinsker's and Fano's inequalities. The article then infers, from deployed systems, implied capacities of 35 to 73 bits, which it relates to bounded rationality. Finally, it proposes a framework for matching protocols to institutional capacities, together with validation pathways.

## Role in the thesis

The article underpins contribution **C2** of the thesis (classical Conditional CRO Trilemma, Chapter 2, §2.3). The thesis presents a version of the proof that differs from the published one (`rem:version_preuve_classique`, §2.3.2). The Lean formalisation led to these alternative formulations (§3.4.9, `subsec:lean4_erreurs`).

## What the thesis refines

The thesis keeps the institutional model, the role of $(\Delta,\alpha,\beta)$ and the form of the main bound within the regime in which it is established. The statement-by-statement detail is in [`../../03_resultats_these/resultats_these_en.md`](../../03_resultats_these/resultats_these_en.md).

### Points shared with the submitted refined statements ([`formulations_precisees/`](formulations_precisees/))

| Item | In the article | In the thesis | Thesis reference |
|---|---|---|---|
| Lemma 4 | Upper bound on $\mathrm{Conf}$, normalised by $\lambda$ | Lower bound $\mathrm{Conf}\ge 1-\sqrt{c_0\beta\, I(M;\Sigma\mid C)}$ | `lem:confidentiality_guarantee`, §2.3.2 |
| Assumption 2 | Upper bound on the verdict space used as a lower bound on $H(V\mid C)$ | Efficient-verdict Assumption 2′, $H(V\mid C)\ge\gamma=\alpha H(C)-1\ge 1$, stated explicitly | `ass:verdicts_efficace`, `rem:statut_verdict_efficace`, §2.3.1.2 |
| Regime $I=O(1/\lambda)$ | Derived from an optimisation whose alternative solution does not yield this regime | Explicit Assumption 4, $I(M;\Sigma\mid C)\le\kappa/\lambda$ | `ass:regime`, `rem:statut_regime`, §2.3.1.2 |
| Theorem 1 | Six-step proof | Complete proof with explicit constants, $\frac{1}{\gamma}\bigl(\frac{\Delta}{\lambda}+\frac{\kappa(\Delta+1)}{\lambda^2}+\frac{\kappa^2}{\lambda^3}\bigr)$ | `thm:trilemme_cro_conditionnel`, §2.3.2 |
| Remark 10 | Bound valid with no restriction on leakage | Assumption 4 necessary, shown by a limiting case | `rem:scope_trilemme_classique`, §2.3.2 |
| Constant $c_0$ | Described as tight | Valid but not tight | `rem:constante_c0`, §2.3.2 |
| Table 2 | Implied capacities read as consequences of the theorem | Illustrative calibration on the CLO scale | `rem:portee_cas_etude`, `tab:validation_cro_classique`, §2.3.3 and §2.3.5 |

### Contributions specific to the thesis, not in the submitted document

| Item | In the thesis | Thesis reference |
|---|---|---|
| Admissible interpreter and foundation of Assumption 1 | $I(V;\Sigma\mid C)=I(V;M\mid C)+I(V;\Sigma\mid M,C)$; $\Delta$ bounds the information drawn from the proof beyond the message | `def:interp_admissible`, `prop:fondement_extraction`, §2.3.1.2 |
| Refined form and threshold $H^\sharp$ | $\frac{1+\kappa/\lambda}{\lambda}\min\{1,\frac{\kappa/\lambda+\Delta}{\gamma}\}$, sparse-context and rich-context regimes | `eq:trilemme_cro_raffine`, `rem:activite_delta`, §2.3.2 and §2.3.4 |
| Reliability | The theorem concerns $\mathrm{Rel}_{\mathrm{rec}}$ | `rem:rel_ver`, §2.2.2.2 |
| Certification | Algebraic core certified in Lean 4 | §3.4, [`../../05_formalisation_lean/`](../../05_formalisation_lean/) |
