# Joint estimation report template (P4)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.4 (algorithm `alg:estimation_conjointe`) and §4.2.7.3 (table `tab:criteres_refutation`)

[Version française](rapport_estimation_fr.md) · [P4 protocol](protocole_en.md)

One report per institution. Values are taken from the report produced by `cro_terrain.p4.estimation_conjointe` (method `summary()`). The mentions “insufficient reliability” or “exploratory” are carried at the top when they apply.

## 0. Header

| Field | Value |
|---|---|
| Institution, type | `INST-__`, ______ |
| Context(s) $C$ | ______ |
| Data | ☐ P1 (converted by `p4.p1_to_p4`) ☐ own collection |
| Pre-registration | reference ______ |
| Version of the analysis package and script | ______ |
| Mentions | ☐ none ☐ insufficient reliability ☐ reliability not computable ☐ exploratory ($n < 30$) |

## 1. Prerequisites

| Prerequisite | State |
|---|---|
| Institutional agreement | ☐ yes ☐ no |
| Ethics opinion | ☐ yes ☐ no |
| $n \geq 30$ participants analysed | ☐ yes ☐ no ($n =$ ____) |

## 2. Course of the six steps

| Step | Status | Detail |
|---|---|---|
| 1 Collection | | answers ____, participants ____, missing verdicts ____ |
| 2 Matching with $m$ | | answers without ground truth ____ |
| 3 Admissibility | | $\hat I(V;M\mid\Sigma,C) =$ ____, $p =$ ____, informative strata ____ |
| 4 $\hat\Delta$ | | ____ bits, 95 % CI [____ ; ____], participants ____ |
| 5 $\hat\alpha$ | | $|\mathcal{V}| =$ ____, $H(C) =$ ____ bits, $\hat\alpha =$ ____ ; $\hat H(V\mid C) =$ ____ bits, CI [____ ; ____] |
| 6 Reliability | | ICC ____, inter $\kappa$ ____, retest $\kappa$ ____ |

## 3. Refutation criteria concerned

| Parameter | Rule (table `tab:criteres_refutation`) | Inputs | Decision |
|---|---|---|---|
| $\Delta$ | refuted if the lower bound of the 95 % CI of $\hat I(V;\Sigma\mid M,C)$ exceeds the capacity fixed before the experiment | lower bound ____, capacity ____ | ☐ not refuted ☐ refuted ☐ not probative |
| Admissibility | refuted if the permutation test rejects $V \perp M \mid (\Sigma,C)$ at the 0.01 level | $p =$ ____ | ☐ not refuted ☐ refuted ☐ not testable |
| $\gamma$ | refuted if the upper bound of the 95 % CI of $\hat H(V\mid C)$ is below $\alpha H(\mathcal{C}) - 1$ | bound ____, $\gamma =$ ____ | ☐ not refuted ☐ refuted ☐ not probative |

If reliability is insufficient or not computable, the “Decision” column is filled in for information only and marked “not applicable”.

## 4. Reading

Write a few paragraphs, following these rules.

1. $\hat\Delta$ and $\hat\alpha$ are discussed separately. An error on one does not carry over to the other (thesis, §4.2.4).
2. If admissibility is rejected, $\hat\Delta$ is not presented as an extraction capacity.
3. The predictions of the thesis (for example $\approx 25$ bits for general judges) are targets, not bounds. A gap is reported without concluding beyond the pre-registered criterion.
4. $\beta$ is not estimated by this protocol.

## 5. Appendices

☐ Full output of `estimation_conjointe(...).summary()`
☐ [Reliability grid](grille_fiabilite_en.md)
☐ Consolidated [counting form](fiche_denombrement_verdicts_en.md)
☐ Signed [prerequisite checklist](liste_controle_prerequis_en.md)
☐ Deviation forms

Written by ______ on ___ / ___ / ______. Reviewed by ______.

Licence CC BY 4.0.
