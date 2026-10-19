# P3 — Post-quantum extension of the Conditional CRO Trilemma (IEEE Access, 2026)

> **Status: PUBLISHED** · Source: *IEEE Access*, vol. 14, pp. 125130–125155, 2026, DOI [10.1109/ACCESS.2026.3722742](https://doi.org/10.1109/ACCESS.2026.3722742) · Thesis, Chapter 2, §2.4

[Version française](README_fr.md)

## Reference

T. E. MINKA MI NGUIDJOÏ, F. S. MANI ONANA, T. DJOTIO NDIÉ, "Post-Quantum Extension of the Conditional CRO Trilemma: Impossibility Bounds on Confidentiality, Reliability, and Opposability Under Quantum Institutional Extraction Limits", *IEEE Access*, vol. 14, pp. 125130–125155, 2026. Received 19 June 2026, accepted 2 August 2026, published 12 August 2026. BibTeX entry in [`CITATION.bib`](CITATION.bib).

## Files

| File | Contents |
|---|---|
| [`article.pdf`](article.pdf) | Version published by the publisher (26 pages) |
| [`source/Final_PQ_Extension_CRO_Trilemma.tex`](source/Final_PQ_Extension_CRO_Trilemma.tex) | LaTeX source of the final submitted version |
| [`CITATION.bib`](CITATION.bib) | Bibliographic reference |
| [`formulations_precisees/`](formulations_precisees/) | Refined statements submitted to the publisher, not published (status PROPOSAL) |

## Licence

The article is published open access by IEEE under the Creative Commons Attribution 4.0 licence (CC BY 4.0), with the notice "© 2026 The Authors". Redistribution here is permitted provided the reference above is cited.

## Summary

The article asks whether quantum adversaries and quantum channel effects modify the bounds of the Conditional CRO Trilemma. It extends the institutional capacity model to the quantum setting with two parameters, the quantum extraction capacity $\Delta_q$ and the quantum interpretability loss coefficient $\eta_q$. Under explicit assumptions, it states the bound $\mathrm{Conf}^q\cdot\mathrm{Rel}^q\cdot\mathrm{Opp}^q\le(\Delta_q+\eta_q H(C))/\lambda+O(\lambda^{-2})+\mathrm{negl}(\lambda)$. The proofs use the quantum Pinsker inequality, the gentle measurement lemma and the quantum Fano inequality. An internal coherence analysis associates implied capacities $\Delta_q\in[28,67]$ bits with the NIST PQC finalists (Dilithium, Kyber, SPHINCS+). The article revisits the systems studied earlier (Helios, zk-SNARKs, ECDSA) and proposes a framework for matching post-quantum protocols to institutional capacities.

## Role in the thesis

The article underpins contribution **C3** of the thesis (quantum extension of the Conditional CRO Trilemma, Chapter 2, §2.4). The thesis presents a version of the proof that differs from the published one (`rem:version_preuve_pq`, §2.4.3). The Lean formalisation led to these alternative formulations (§3.4.9).

## What the thesis refines

The thesis keeps the quantum institutional model, the parameters $(\Delta_q,\alpha_q,\beta_q,\eta_q)$ and the form of the main bound within the regime in which it is established. The statement-by-statement detail is in [`../../03_resultats_these/resultats_these_en.md`](../../03_resultats_these/resultats_these_en.md).

### Points shared with the submitted refined statements ([`formulations_precisees/`](formulations_precisees/))

| Item | In the article | In the thesis | Thesis reference |
|---|---|---|---|
| Lemma 6 | Inequality (68) over independent draws | The formulation dispenses with it (orthogonal-state limiting case), together with the upper bound (72) of Lemma 7 | `rem:retrait_lemma6`, §2.4.4 |
| Lemma 7 | Lower bound stated with the accessible information | Lower bound with the Holevo information, $\mathrm{Conf}^q\ge 1-\tfrac12\sqrt{2\beta_q\chi_{\max}+2\zeta_q D_{\max}}$ | `lem:q_conf_mi_pq`, §2.4.4 |
| Assumption 4 | Lower bound on $H(V\mid C)$ derived from an upper bound | Explicit Assumption 4′, $H(V\mid C)\ge\theta_q\alpha_q H(C)=\gamma_q\ge 1$ | `ass:verdict_quantique`, `rem:statut_verdict_quantique`, §2.4.3 |
| Leakage regime | Remark 17, validity claimed for $I\in[0,\lambda]$ | Explicit Assumption 6, $\chi_{\max}\le\kappa/\lambda$, necessary (limiting case) | `ass:regime_quantique`, `rem:scope_trilemme_pq`, §2.4.3 and §2.4.4 |
| Theorem 2 | Assumption 5 and constant $C(\beta_q,\alpha_q)$ | Complete proof with explicit constants, Assumption 5 dropped | `thm:trilemme_pq`, §2.4.4 |
| Tables 8 to 10, Dilithium-3 study | Implied capacities read as consequences of the theorem | Illustrative calibration on the CLO scale | `subsec:analyse_coherence_pq`, §2.4.6 |

### Contributions specific to the thesis, not in the submitted document

| Item | In the thesis | Thesis reference |
|---|---|---|
| Definition of $\eta_q$ | A single definition, as a loss, $I(V;\Lambda(\Sigma)\mid C)\ge I(V;\Sigma\mid C)-\eta_q H(C)$; $\eta_q=0$ for every proof that is a bit string (ML-DSA, SLH-DSA, Falcon) | `def:perte_interp_quantique_pq`, `rem:interpretation_physique_pq`, §2.4.2.3 |
| Regularity constant | Renamed $\zeta_q$, distinct from $\eta_q$ | `ass:regularite_quantique`, §2.4.3 |
| $D_{\max}$ | Not negligible for NIST PQC signatures (more than $2.6\cdot10^4$ bits for ML-DSA-65); confidentiality of these schemes follows from the classical lemma | `rem:interp_lemme7`, §2.4.4 |
| Refined quantum form and threshold $H^\sharp_q$ | $\frac{1+\kappa/\lambda}{\lambda}\min\{1,\frac{\kappa/\lambda+\Delta_q}{\gamma_q}\}$, $H^\sharp_q=(\Delta_q+\kappa/\lambda)/(\theta_q\alpha_q)$, in which $\eta_q$ does not appear | `rem:forme_raffinee_pq`, §2.4.4 and §2.4.5 |
| Reference parameters | ML-DSA-65 in a contractual context, $\Delta_q=28$ bits as a working hypothesis, $\eta_q=0$ | `tab:parametres_reference`, §4.1.3 |

The remark on $D_{\max}$ goes further than the submitted document, which still sets $D_{\max}=\mathrm{negl}(\lambda)$ for these schemes and writes $\eta_q$ for the regularity constant of Lemma 7.
