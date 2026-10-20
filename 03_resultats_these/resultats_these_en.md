# Contributions of the thesis with respect to the published articles

> **Status: PROPOSAL. thesis result** · Source: thesis, Chapters 2, 3 and 4 (sources in [`../00_these/manuscrit/`](../00_these/manuscrit/))

[Version française](resultats_these_fr.md)

This document lists, statement by statement, what the thesis adds or refines with respect to the three published articles P1 (CLO framework), P2 (Conditional CRO Trilemma) and P3 (post-quantum extension), described in [`../01_publie/`](../01_publie/). Each entry gives the LaTeX label of the statement in the thesis sources, its number and section in the submitted PDF, the article concerned and the exact formula. The published articles are not rewritten. Until the thesis is defended, every entry keeps the status of a proposal; some entries also carry a more specific sub-label (construction, conjecture, illustrative calibration, undeployed protocol), shown at the top of the entry.

Notation. $M$ is the message, $C$ the institutional context, $\Sigma$ the proof, $V$ the verdict, $\lambda$ the security parameter. The institutional parameters are the extraction capacity $\Delta$, the verdict granularity $\alpha$, the regularity $\beta$, the regime constant $\kappa$ and $\gamma=\alpha H(C)-1$; their quantum analogues are $\Delta_q$, $\alpha_q$, $\beta_q$, $\theta_q$, $\gamma_q=\theta_q\alpha_q H(C)$ and the interpretability loss $\eta_q$.

## Overview

| No. | Statement | Main label | Section | Article | Nature |
|---|---|---|---|---|---|
| R1 | Reliabilities $\mathrm{Rel}_{\mathrm{rec}}$ and $\mathrm{Rel}_{\mathrm{ver}}$ | `def:fiabilite_clo`, `rem:rel_ver` | §2.2.2.2 | P1, P2 | Clarification |
| R2 | Context bottleneck $\le\alpha H(C)$ | `thm:goulot_contexte` | §2.2.3 | P1 | Refined formulation |
| R3 | Deterministic verdict $\Rightarrow\mathrm{Opp}=1$ | `rem:verdict_deterministe` | §2.2.3 | P1 | Addition |
| R4 | Refined composition rules | `thm:composition_sequentielle` | §2.2.3 | P1 | Refined formulation |
| R5 | Admissible interpreter (option A) | `def:interp_admissible` | §2.3.1.2 | P1, P2 | Addition |
| R6 | Foundation proposition for Assumption 1 | `prop:fondement_extraction` | §2.3.1.2 | P2 | Addition |
| R7 | Classical trilemma under explicit assumptions | `thm:trilemme_cro_conditionnel` | §2.3.1.2, §2.3.2 | P2 | Refined formulation |
| R8 | Refined form, threshold $H^\sharp$, sparse and rich regimes | `eq:trilemme_cro_raffine`, `rem:activite_delta` | §2.3.2, §2.3.4 | P2 | Addition |
| R9 | Scope of the case studies | `rem:portee_cas_etude` | §2.3.3, §2.3.5 | P1, P2, P3 | Clarification |
| R10 | Single definition of $\eta_q$ | `def:perte_interp_quantique_pq` | §2.2.4.2, §2.4.2.3 | P3 | Refined formulation |
| R11 | Quantum trilemma under explicit assumptions | `thm:trilemme_pq` | §2.4.3, §2.4.4 | P3 | Refined formulation |
| R12 | Refined quantum form and threshold $H^\sharp_q$ | `rem:forme_raffinee_pq` | §2.4.4, §2.4.5 | P3 | Addition |
| R13 | Status of the SOTP results | `rem:statut_sotp`, `conj:optimalite_universelle` | §3.1 to §3.3 | P1 | Requalification |
| R14 | Single table of reference parameters | `tab:parametres_reference` | §4.1.3 | P1, P2, P3 | Addition |
| R15 | Estimator $\hat\Delta=\hat I(V;\Sigma\mid M,C)$ | `eq:estimateur_delta` | §4.2.1 | P2 | Addition |
| R16 | Pre-registered refutation criteria | `tab:criteres_refutation` | §4.2.7.3 | P2, P3 | Addition |

---

## R1. Reconstruction reliability and verification reliability

- **Labels**: `def:fiabilite_clo` (Definition 2.3, equation `eq:rel_clo`), `rem:rel_ver` (Remark 2.2, equation `eq:rel_ver`)
- **Section**: §2.2.2.2, file `chap2/clo.tex`
- **Articles**: P1 (operational reliability), P2 (reliability used in the Fano step)

The thesis distinguishes two notions that the articles conflated. Reconstruction reliability is the one of the trilemma,

$$\mathrm{Rel}(\mathcal P):=\mathrm{Rel}_{\mathrm{rec}}(\mathcal P)=1-\min_{\mathsf{Dec}}\Pr\bigl[\mathsf{Dec}(\Sigma,C)\neq M\bigr].$$

The operational reliability of P1 is the completeness of verification, together with its soundness,

$$\mathrm{Rel}_{\mathrm{ver}}(\mathcal P)=\min_{m,c}\Pr\bigl[\mathsf{Verify}(pk,\mathsf{Prove}(sk,m,c),c)=1\bigr].$$

For $M$ uniform on $\{0,1\}^\lambda$, $\mathrm{Conf}=1$ implies $\Sigma\perp M\mid C$ and hence $\mathrm{Rel}_{\mathrm{rec}}=2^{-\lambda}$, whereas $\mathrm{Rel}_{\mathrm{ver}}$ can equal 1 (perfectly hiding commitment). The trilemma concerns $\mathrm{Rel}_{\mathrm{rec}}$, the only notion to which Fano's inequality applies.

## R2. Context bottleneck capped by $\alpha H(C)$

- **Label**: `thm:goulot_contexte` (Theorem 2.2, equation `eq:goulot_contextuel`)
- **Section**: §2.2.3, file `chap2/clo.tex`
- **Article**: P1 (context bottleneck theorem, extraction capped by $H(C)$)

$$I(V;\Sigma\mid C)\le\min\bigl\{H(\Sigma\mid C),\,H(V\mid C)\bigr\}\le\log_2\lvert\mathcal V_\lambda\rvert\le\alpha\,H(C).$$

The cap on extractable information is set by the institutional verdict granularity $\alpha$, relative to the richness of the context. The P1 version capped extraction by $H(C)$ alone.

## R3. Deterministic verdict and trivial opposability

- **Label**: `rem:verdict_deterministe` (Remark 2.4)
- **Section**: §2.2.3, file `chap2/clo.tex`; Lean extension in §3.4.8
- **Article**: P1 (deterministic interpretation $V=\mathsf{Interpret}(\Sigma,C)$)

If $V$ is a deterministic function of $(\Sigma,C)$, then $H(V\mid\Sigma,C)=0$ and $I(V;\Sigma\mid C)=H(V\mid C)$, so that $\mathrm{Opp}=1$ as soon as $H(V\mid C)>0$, whatever the protocol. The measure $\mathrm{Opp}$ therefore discriminates between protocols only for admissible interpretations (R5). Under Assumptions 1 and 2′, a deterministic verdict also forces $\Delta\ge\gamma-I(M;\Sigma\mid C)$, which places the institution in the regime where the bound reduces to Fano's (R8). Both facts are certified in Lean (`opp_eq_one_of_deterministic`, `deterministic_forces_capacity`).

## R4. Refined composition rules

- **Labels**: `thm:composition_sequentielle` (Theorem 2.3, equations `eq:comp_seq_conf`, `eq:comp_seq_rel`, `eq:comp_par_conf`, `eq:comp_par_rel`), `rem:composition_opp` (Remark 2.5)
- **Section**: §2.2.3, file `chap2/clo.tex`
- **Article**: P1 (sequential and parallel composition theorems)

For the sequential composition $\mathcal P_1\circ\mathcal P_2$, which publishes a post-processing $\Sigma_2=\mathcal P_2(\Sigma_1)$ independent of $M$ given $(\Sigma_1,C)$,

$$\mathrm{Conf}(\mathcal P_1\circ\mathcal P_2)\ge\mathrm{Conf}(\mathcal P_1),\qquad \mathrm{Rel}_{\mathrm{rec}}(\mathcal P_1\circ\mathcal P_2)\le\mathrm{Rel}_{\mathrm{rec}}(\mathcal P_1).$$

For the parallel composition $\mathcal P_1\Vert\mathcal P_2$, which publishes $(\Sigma_1,\Sigma_2)$ produced independently given $(M,C)$,

$$\mathrm{Conf}(\mathcal P_1\Vert\mathcal P_2)\le\min\{\mathrm{Conf}(\mathcal P_1),\mathrm{Conf}(\mathcal P_2)\},\qquad \mathrm{Rel}_{\mathrm{rec}}(\mathcal P_1\Vert\mathcal P_2)\ge\max\{\mathrm{Rel}_{\mathrm{rec}}(\mathcal P_1),\mathrm{Rel}_{\mathrm{rec}}(\mathcal P_2)\}.$$

For opposability, the chain $V$–$(\Sigma_1,C)$–$(\Sigma_2,C)$ gives $\mathrm{Opp}(\mathcal P_1\circ\mathcal P_2)\le\mathrm{Opp}(\mathcal P_1)$ for a fixed verdict. No general rule holds in parallel. The P1 rules ($\mathrm{Opp}\ge\min$ in sequence, $\mathrm{Opp}\approx$ product in parallel) are treated as heuristics. The product lower bound, drawn from the Fréchet inequality, is set aside, since that inequality gives $ab\ge a+b-1$ in the other direction.

## R5. Admissible interpreter (option A)

- **Label**: `def:interp_admissible` (Definition 2.13, equation `eq:interp_admissible`)
- **Section**: §2.3.1.2, file `chap2/cro_classique.tex`
- **Articles**: P1 (deterministic verdict), P2 (Assumption 1 stated without a structural foundation)

An interpretation is admissible if the verdict can be written $V=\mathsf{Interpret}(\Sigma,C,K)$, where $K$ represents the institution's own resources (case law, expertise, deliberation, decision randomness) and satisfies

$$K\perp M\mid(\Sigma,C).$$

The institution accesses the message only through the proof, so that $M\to(\Sigma,C)\to V$ is a Markov chain. The verdict may be stochastic. This definition grounds Assumption 1 more directly than the initial derivation, which went through a less precise chain rule.

## R6. Foundation proposition for the bounded-extraction assumption

- **Label**: `prop:fondement_extraction` (Proposition 2.1, equations `eq:fondement_extraction`, `eq:extraction_bornee_forte`)
- **Section**: §2.3.1.2, file `chap2/cro_classique.tex`
- **Article**: P2 (Assumption 1, $I(V;\Sigma\mid C)\le I(M;\Sigma\mid C)+\Delta$)

For every admissible interpretation,

$$I(V;\Sigma\mid C)=I(V;M\mid C)+I(V;\Sigma\mid M,C)\le I(M;\Sigma\mid C)+I(V;\Sigma\mid M,C).$$

Assumption 1 therefore holds as soon as $I(V;\Sigma\mid M,C)\le\Delta$. The capacity $\Delta$ is read exactly as the information that the institution draws from the proof beyond the message. The proof applies the chain rule twice to $I(V;M,\Sigma\mid C)$, uses $I(V;M\mid\Sigma,C)=0$ (admissibility) and then the data-processing inequality on $M\to(\Sigma,C)\to V$.

## R7. Classical trilemma under explicit assumptions

- **Labels**: `ass:verdicts_efficace` (Assumption 2.2), `ass:regime` (Assumption 2.4), `lem:confidentiality_guarantee` (Lemma 2.3), `thm:trilemme_cro_conditionnel` (Theorem 2.4, equations `eq:trilemme_cro_conditionnel`, `eq:trilemme_cro_explicite`), `rem:scope_trilemme_classique` (Remark 2.17), `rem:constante_c0` (Remark 2.15)
- **Section**: §2.3.1.2 and §2.3.2, file `chap2/cro_classique.tex`; alternative formulations traced in §3.4.9
- **Article**: P2 (Lemma 4, Assumption 2, Theorem 1, Remark 10)

These formulations are also the content of the document submitted for P2 ([`../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/`](../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/)).

- The confidentiality lemma becomes a lower bound, $\mathrm{Conf}(\mathcal P)\ge 1-\sqrt{c_0\beta\, I(M;\Sigma\mid C)}$, with $c_0=1/(2\ln 2)$ valid but not tight.
- Verdict efficiency is stated explicitly, $\lvert\mathcal V_\lambda\rvert\le 2^{\alpha H(C)}$ and $H(V\mid C)\ge\alpha H(C)-1=:\gamma\ge 1$.
- The leakage regime is stated explicitly, $I(M;\Sigma\mid C)\le\kappa/\lambda$, because the alternative solution of the optimisation meant to produce it does not yield it.

Under Assumptions 1, 2′, 3 and 4, for $\lambda\ge 64$, $H(M)=\lambda$ and $M\perp C$,

$$\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}\le\frac{1}{\gamma}\left(\frac{\Delta}{\lambda}+\frac{\kappa(\Delta+1)}{\lambda^2}+\frac{\kappa^2}{\lambda^3}\right)\le\frac{\Delta}{\lambda}+O(\lambda^{-2})+\mathrm{negl}(\lambda).$$

Assumption 4 is necessary. The protocol that reveals $M$ with probability $1/2$ and otherwise outputs a uniform proof satisfies Assumptions 1 to 3 with $\beta\le 1.04$ and has $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}\approx 1/4$ for every $\lambda$ (see [`../05_formalisation_lean/cas_limite/`](../05_formalisation_lean/cas_limite/) and check V6 in [`../06_calcul/`](../06_calcul/)). The algebraic core is certified in Lean (`trilemma_explicit`, `conditional_CRO_trilemma`, `regime_assumption_necessary`).

## R8. Refined form of the trilemma, threshold $H^\sharp$ and regimes

- **Labels**: `eq:trilemme_cro_raffine` (Theorem 2.4), `rem:activite_delta` (Remark 2.16, equation `eq:seuil_activite`), `subsec:regimes_operationnels`, `tab:regimes_operationnels` (Table 2.1)
- **Section**: §2.3.2 and §2.3.4, file `chap2/cro_classique.tex`; Lean extension in §3.4.8
- **Article**: P2 (absent)

Under the same assumptions,

$$\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}\le\frac{1+\kappa/\lambda}{\lambda}\,\min\left\{1,\;\frac{\kappa/\lambda+\Delta}{\gamma}\right\}.$$

The factor $\min\{\cdot\}$ is strictly less than 1 if and only if

$$\Delta<\gamma-\frac{\kappa}{\lambda}\iff H(C)>H^\sharp:=\frac{\Delta+1+\kappa/\lambda}{\alpha}.$$

| Regime | Condition | Bound | Binding constraint |
|---|---|---|---|
| Sparse context | $H(C)\le H^\sharp$ | $(1+\kappa/\lambda)/\lambda$ (Fano) | reconstruction reliability |
| Rich context | $H(C)>H^\sharp$ | $\frac{1+\kappa/\lambda}{\lambda}\cdot\frac{\kappa/\lambda+\Delta}{\gamma}$ | institutional capacity $\Delta$ |

In the example of the thesis ($\Delta=5$, $\alpha=1$, $H(C)=20$, $\gamma=19$, $\kappa=1$, $\lambda=128$), the refined form gives about $2.1\cdot10^{-3}$ against $7.9\cdot10^{-3}$ for Fano alone. With $\Delta=35$ in the same context, $\Delta>\gamma$ and the bound falls back to Fano's. Certified in Lean (`trilemma_refined`, `refined_bound_is_fano_when_delta_ge_gamma`).

## R9. Scope of the case studies

> Sub-label: **illustrative calibration**

- **Labels**: `rem:portee_cas_etude` (Remark 2.19), `tab:validation_cro_classique` (Table 2.2), `subsec:analyse_coherence_pq` (tables `tab:validation_classiques_pq`, `tab:validation_pqc`)
- **Section**: §2.3.3, §2.3.5 and §2.4.6, files `chap2/cro_classique.tex` and `chap2/cro_pq.tex`
- **Articles**: P1 (case studies), P2 (Table 2, implied capacities 35 to 73 bits), P3 (Tables 8 to 10)

Under Assumption 4, the Fano step gives $\mathrm{Rel}_{\mathrm{rec}}\le(1+\kappa/\lambda)/\lambda\approx 0.008$ at $\lambda=128$. The deployed reference systems (Helios, zk-SNARKs, ECDSA, NIST PQC signatures), whose reliability $\mathrm{Rel}_{\mathrm{ver}}$ is close to 1, are therefore not instances of the theorem. Their CLO metrics are expressed on the operational scale of P1. The implied capacities, defined by $\Delta:=\lambda\cdot(\mathrm{Conf}\cdot\mathrm{Rel}_{\mathrm{ver}}\cdot\mathrm{Opp})$, are an illustrative calibration of orders of magnitude, circular by construction; they neither validate nor refute the bound. The theorem applies to controlled-leakage protocols, of which perfectly hiding commitments and zero-knowledge proofs are the canonical examples.

## R10. Single definition of $\eta_q$

- **Labels**: `def:perte_interp_quantique` (Definition 2.9, equation `eq:def_eta_q`), `def:perte_interp_quantique_pq` (Definition 2.27, equation `eq:eta_q_definition`), `rem:interpretation_physique_pq` (Remark 2.22), `ass:regularite_quantique` (Assumption 2.7)
- **Section**: §2.2.4.2 and §2.4.2.3, files `chap2/clo.tex` and `chap2/cro_pq.tex`
- **Article**: P3 ($\eta_q$ defined through a normalised trace distance and also used as a regularity constant)

Let $\Lambda$ be a CPTP map representing the effects of a quantum channel on the proof medium. The quantum interpretability loss $\eta_q\in[0,1]$ is the smallest real number such that

$$I(V;\Lambda(\Sigma)\mid C)\ge I(V;\Sigma\mid C)-\eta_q\,H(C).$$

This is the only definition of $\eta_q$ used in the thesis. By the data-processing inequality, a channel can only reduce opposability and $\eta_q$ measures the maximal size of this reduction. For a proof that is a classical bit string, including ML-DSA, SLH-DSA and Falcon signatures, $\Lambda$ is the identity and $\eta_q=0$; values $\eta_q>0$ describe a hypothetical scenario of quantum storage or a quantum verifier. The regularity constant of the quantum regularity assumption is renamed $\zeta_q$, distinct from $\eta_q$.

## R11. Quantum trilemma under explicit assumptions

- **Labels**: `rem:retrait_lemma6` (Remark 2.27), `lem:q_conf_mi_pq` (Lemma 2.8), `rem:interp_lemme7` (Remark 2.28), `ass:verdict_quantique` (Assumption 2.6), `ass:regime_quantique` (Assumption 2.8), `thm:trilemme_pq` (Theorem 2.5), `rem:scope_trilemme_pq` (Remark 2.29)
- **Section**: §2.4.3 and §2.4.4, file `chap2/cro_pq.tex`
- **Article**: P3 (Lemmas 6 and 7, Assumptions 4 and 5, Theorem 2, Remark 17)

Most of these formulations are also the content of the document submitted for P3 ([`../01_publie/P3_PQCRO_IEEEAccess2026/formulations_precisees/`](../01_publie/P3_PQCRO_IEEEAccess2026/formulations_precisees/)).

- The formulation dispenses with Lemma 6 (orthogonal-state limiting case) and with the upper bound (72) of Lemma 7.
- The quantum confidentiality lemma is stated with the Holevo information, $\mathrm{Conf}^q(\mathcal P)\ge 1-\tfrac12\sqrt{2\beta_q\chi_{\max}+2\zeta_q D_{\max}}$.
- Verdict efficiency is stated explicitly, $H(V\mid C)\ge\theta_q\alpha_q H(C)=:\gamma_q\ge 1$.
- The leakage regime is stated explicitly as well, $\chi_{\max}\le\kappa/\lambda$.

Under these assumptions, for $\lambda\ge 64$, $H(M)=\lambda$ and $M\perp C$,

$$\mathrm{Conf}^q\cdot\mathrm{Rel}^q\cdot\mathrm{Opp}^q\le\frac{1}{\gamma_q}\left(\frac{\Delta_q}{\lambda}+\frac{\kappa(\Delta_q+1)}{\lambda^2}+\frac{\kappa^2}{\lambda^3}\right)\le\frac{\Delta_q+\eta_q H(C)}{\lambda}+O(\lambda^{-2})+\mathrm{negl}(\lambda).$$

The term $\eta_q H(C)$ appears only in the weakened upper bound. The thesis goes further than the submitted document on one point. For a classical proof of $n$ bits, $D_{\max}=n-H(\Sigma\mid C=c)$ amounts to several thousand bits for NIST PQC signatures (more than $2.6\cdot10^4$ bits for ML-DSA-65, whose signature is 3,309 bytes long); their confidentiality must therefore be established by the classical lemma applied to the classical outcome. The submitted document still sets $D_{\max}=\mathrm{negl}(\lambda)$ for these schemes.

## R12. Refined quantum form and threshold $H^\sharp_q$

- **Labels**: `rem:forme_raffinee_pq` (Remark 2.31, equation `eq:trilemme_pq_raffine`), `subsec:regimes_quantiques`, `tab:regimes_quantiques_comp` (Table 2.4)
- **Section**: §2.4.4 and §2.4.5, file `chap2/cro_pq.tex`
- **Article**: P3 (absent)

$$\mathrm{Conf}^q\cdot\mathrm{Rel}^q\cdot\mathrm{Opp}^q\le\frac{1+\kappa/\lambda}{\lambda}\,\min\left\{1,\;\frac{\kappa/\lambda+\Delta_q}{\gamma_q}\right\}.$$

The quantum capacity is binding if and only if $\Delta_q<\gamma_q-\kappa/\lambda$, that is

$$H(C)>H^\sharp_q:=\frac{\Delta_q+\kappa/\lambda}{\theta_q\alpha_q}.$$

The coefficient $\eta_q$ appears neither in this form nor in the distinction between regimes. The migration profiles (early migration, trained institutions, expert institutions) describe capacity levels and remain illustrative.

## R13. Status of the SOTP results

> Sub-labels: **construction** (S-OTP and SOTP families) and **conjecture** (universal optimality)

- **Labels**: `rem:statut_sotp` (Remark 3.1), `thm:proprietes_sotp` (Theorem 3.1), `thm:optimalite_sotp` (Remark 3.3), `thm:saturation_sotp_low`, `thm:saturation_sotp_base`, `thm:saturation_sotp_high` (Propositions 3.1 to 3.3), `rem:facteur_limitant_low`, `rem:heuristique_sotp_base`, `rem:heuristique_sotp_high` (Remarks 3.4 to 3.6), `conj:optimalite_universelle` (Conjecture 3.1), `rem:statut_optimalite` (Remark 3.7)
- **Section**: §3.1, §3.2, §3.3.2.3, §3.3.3.3, §3.3.4.3 and §3.3.6, files `chap3/introduction_chap3.tex`, `chap3/sotp_base.tex`, `chap3/sotp_construction.tex`
- **Article**: P1 (optimality of S-OTP within the OTP class); the SOTP family itself belongs to a separate submission (see [`../04_sotp/`](../04_sotp/))

| Statement | Status in the thesis |
|---|---|
| Cryptographic properties of S-OTP, SOTP-Low, SOTP-Base, SOTP-High (confidentiality, $\mathrm{Rel}_{\mathrm{ver}}=1-\mathrm{negl}(\lambda)$, JL distance preservation) | Propositions proved under PRG, DLog, q-SDH and q-PKE |
| Opposability lower bounds $0.75\,\Delta/\lambda$, $0.5\min\{\Delta/d,\Delta/(\beta\log_2 d)\}$, $0.45\,\beta\log_2\lambda/\lambda$ | Design heuristics, not proved |
| Optimality of S-OTP within the OTP class | Heuristic argument; a proof requires a formal definition of the class |
| Universal optimality of the SOTP family | Conjecture |

The SOTP metrics are expressed on the operational scale ($\mathrm{Rel}_{\mathrm{ver}}$) and are not compared with the bound. Proof components that depend only on the public context $C$ carry no conditional information, since $I(V;g(C)\mid C)=0$; the Clay layer is analysed as a presentation format. The conjecture reads as follows. Under Assumptions 1 to 4, for each regime, there exist an SOTP variant and a constant $C_R\ge 1$ independent of $\lambda$ such that, for every CLO protocol $\mathcal P'$ of the same regime,

$$\mathrm{Conf}(\mathcal P')\,\mathrm{Rel}_{\mathrm{rec}}(\mathcal P')\,\mathrm{Opp}(\mathcal P')\le C_R\cdot\mathrm{Conf}(\mathrm{SOTP})\,\mathrm{Rel}_{\mathrm{rec}}(\mathrm{SOTP})\,\mathrm{Opp}(\mathrm{SOTP}).$$

## R14. Single table of reference parameters

> Sub-label: **illustrative calibration**

- **Labels**: `subsec:parametres_reference`, `tab:parametres_reference` (Table 4.2)
- **Section**: §4.1.3, file `chap4/introduction_chap4.tex`; data in [`../06_calcul/data/parametres_reference.csv`](../06_calcul/data/parametres_reference.csv) and [`../06_calcul/data/calibration_pq.csv`](../06_calcul/data/calibration_pq.csv)
- **Articles**: P1, P2, P3 (incompatible sets of values for $H(C)$ and $\Delta_q$ in the initial formulations)

| System | $H(C)$ domain | $H(C)$ case | $\alpha$ | $\Delta$ | $\Delta_q$ / $\eta_q$ |
|---|---|---|---|---|---|
| ECDSA (contract) | 20 | 20 | 1.0 | 35 | — |
| Helios (ballot) | 40 | 8 | 1.2 | 56 | — |
| zk-SNARKs (AML) | 70 | 11 | 1.5 | 73 | — |
| ML-DSA-65 (contract) | 20 | 10.5 | 1.0 | — | 28 (hyp.) / 0 |

Entropies in bits. The "domain" context is the richness of the general institutional context; the "case" context is that of a particular decision (§4.3). For ML-DSA-65, $\eta_q=0$ because the signature is a classical bit string. The value $\Delta_q=28$ bits is a working hypothesis to be estimated with the protocol of §4.2.5. Every value used elsewhere in the thesis refers to this table.

## R15. Estimator of the extraction capacity

> Sub-label: **undeployed protocol**

- **Labels**: `eq:estimateur_delta` (equation 4.2), `def:capacite_extraction_op` (Definition 4.1); quantum analogue `eq:estimateur_delta_q` (equation 4.7)
- **Section**: §4.2.1 and §4.2.5, file `chap4/protocoles.tex`
- **Article**: P2 (validation pathway based on a difference of informations)

By the foundation proposition (R6), the quantity controlled by Assumption 1 is $I(V;\Sigma\mid M,C)$. The chosen estimator is

$$\hat\Delta=\hat I(V;\Sigma\mid M,C),$$

computed on the triples $(v_i,\sigma_i,m_i)$ collected at fixed context $c$, with a plug-in estimator with Miller–Madow correction or an NSB-type estimator for small samples. The message $m_i$ is known to the experimenter but not to the participants. The confidence interval is obtained by a non-parametric bootstrap over participants. The estimator of the initial formulation, $I_{\mathrm{emp}}(V;\Sigma\mid C)-I_{\mathrm{vrai}}(M;\Sigma\mid C)$, is replaced, because it is systematically negative for a reliable protocol. The quantum analogue is $\hat\Delta_q=\hat I(V^q;\Sigma\mid M,C)$. No measurement has been carried out.

## R16. Pre-registered refutation criteria

> Sub-label: **undeployed protocol**

- **Label**: `tab:criteres_refutation` (Table 4.7)
- **Section**: §4.2.7.3, file `chap4/protocoles.tex`
- **Articles**: P2, P3 (validation pathways without refutation criteria)

| Parameter | The hypothesis is refuted if… |
|---|---|
| $\Delta$ (Assumption 1) | the lower end of the 95% CI of $\hat I(V;\Sigma\mid M,C)$ exceeds the capacity fixed before the experiment for the population studied |
| Admissibility (Definition `def:interp_admissible`) | a permutation test rejects $V\perp M\mid(\Sigma,C)$ at level 0.01 |
| $\gamma$ (Assumption 2′) | the upper end of the 95% CI of $\hat H(V\mid C)$ is below $\alpha H(C)-1$ |
| $\eta_q$ (quantum scenario) | the 95% CI of $\hat\eta_q$ excludes the interval predicted before the experiment |
| Bound (assumptions verified) | the measured product exceeds the refined form of the bound with 95% confidence |

The threshold values are indicative and will be fixed at pre-registration; their form is the methodological commitment. The corresponding measurement protocols are described in [`../07_protocoles_terrain/`](../07_protocoles_terrain/).
