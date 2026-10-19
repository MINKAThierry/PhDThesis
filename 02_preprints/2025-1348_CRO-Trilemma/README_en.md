# ePrint 2025/1348 - CRO Trilemma (earlier form)

> **Status: PREPRINT (not peer-reviewed)** · Source: Cryptology ePrint Archive, Report 2025/1348

[Version française](README_fr.md)

## Reference

| Field | Value |
|---|---|
| Title | The CRO Trilemma: A Formal Incompatibility between Confidentiality, Reliability and Legal Opposability in Post-Quantum Proof Systems |
| Authors | T. E. Minka Mi Nguidjoï, F. S. Mani Onana, T. Djotio Ndié |
| Archive | Cryptology ePrint Archive, Report 2025/1348 |
| Link | <https://eprint.iacr.org/2025/1348> |
| Received / approved | 2025-07-24 / 2025-07-25 |
| ePrint category | Foundations |
| Keywords | Confidentiality, reliability, legal opposability, explainability, post-quantum proofs, contextual entropy, leakage |
| Licence shown on ePrint | CC BY 4.0 (checked on 2026-10-12) |
| BibTeX entry | [CITATION.bib](CITATION.bib) (key `MINKA2025CRO`, taken from the thesis bibliography) |

This document is a preprint deposited on the IACR ePrint archive. It has not been peer-reviewed and its results must not be cited as validated.

## Abstract

Faithful paraphrase of the official abstract published on the ePrint page (accessed on 2026-10-12). The original text is authoritative and can be read at <https://eprint.iacr.org/2025/1348>.

The paper states the "CRO Trilemma", which holds that no post-quantum proof system can simultaneously satisfy three properties beyond negligible failure probability. These are confidentiality ($\mathrm{Priv} > 1 - \mathrm{negl}(\lambda)$), reliability ($\mathrm{Rel} > 1 - \mathrm{negl}(\lambda)$) and legal opposability, measured by a contextual entropy $H_{\mathrm{Opp}} \approx \log |V_J|$ where $V_J$ is the validation space of a polynomial-time institutional verifier $J$. The authors formalise an "Invisible Authenticity Paradox" using contextual entropy $H(C)$ and a quantum interpretability loss $\eta_q(C)$. Under standard quantum assumptions, they prove against QPT adversaries the impossibility bound

$$H_{\mathrm{Opp}} \leq \frac{\mathrm{Priv}\cdot\mathrm{Rel}}{\varepsilon_{\mathrm{eff}}\cdot 2^{H(C)}} + \eta_q(C) + \mathrm{negl}(\lambda).$$

They introduce a composable framework comprising a model with verifier $J$ (Algorithm 1) and an optimal entropy decomposition theorem (Theorem 2.3). The abstract reports empirical evidence that the bound is consistently violated, with $\Gamma_\text{CRO} > 0.8$, for NIST PQC finalists (e.g. Dilithium) and structured zero-knowledge proofs (STARKs, Groth16). The note on the ePrint page states that ZK-NR (2025/1138) operates within the feasible space this trilemma defines.

## Role in the thesis

Direct antecedent of the classical Conditional CRO Trilemma. Chapter 2 ([chap2/cro_classique.tex](../../00_these/manuscrit/chap2/cro_classique.tex)) cites it together with the published article P2 ([01_publie/P2_CRO_IEEEAccess2026](../../01_publie/P2_CRO_IEEEAccess2026/)) in support of the classical Conditional CRO Trilemma. In the thesis, the bound applies to the product $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}$ and is expressed in terms of the institutional extraction capacity $\Delta$, the verdict granularity $\alpha$ and the security parameter $\lambda$. The discussion of limitations in Chapter 5 (limitation L3, [chap5/discussions.tex](../../00_these/manuscrit/chap5/discussions.tex)) also lists this preprint among the preprints in which the cryptographic games (IND-CONF, BIND-REL, EXT-OPP) are developed without yet having appeared in a peer-reviewed journal.

## Reservations stated in the thesis

This preprint contains an earlier form of the bound, stated on $H_{\mathrm{Opp}}$ with $\varepsilon_{\mathrm{eff}}$ and $\eta_q(C)$. It is superseded by the form published in article P2 (IEEE Access 2026, [01_publie/P2_CRO_IEEEAccess2026](../../01_publie/P2_CRO_IEEEAccess2026/)), which is the only one the thesis retains. The preprint should therefore not be cited as the source of the current bound. The original code that accompanied this version has not been preserved and the empirical evidence announced in the abstract cannot be reproduced from this repository. The index $\Gamma_\text{CRO}$ mentioned in the abstract is not defined within the framework of the thesis.

## PDF and licence

The PDF is not included in this folder. It is available on ePrint at <https://eprint.iacr.org/2025/1348>. The ePrint page displays the Creative Commons Attribution 4.0 licence (CC BY 4.0), which permits redistribution with attribution. The PDF may therefore be added later, together with the required attribution notice.
