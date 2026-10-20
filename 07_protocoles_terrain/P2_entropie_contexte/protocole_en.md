# Protocol for measuring $H(\mathcal{C})$, contextual entropy

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.2 (table `tab:estimations_structurelles_HC`)

[Version française](protocole_fr.md) · [Folder README](README_en.md)

## 1. Aim

Empirically quantify the contextual entropy $H(\mathcal{C})$, that is, the informational richness of the institutional context in which cryptographic proofs are interpreted (thesis, §4.2.2.1).

## 2. What P2 measures, and what it does not

$H(\mathcal{C})$ characterises the **distribution** of possible contexts in an institutional domain, not one particular context. The thesis distinguishes two scales that share the same symbol (§4.2.2.1 and §4.3.1).

| Scale | Values in the thesis | Measured by P2 |
|---|---|---|
| Domain (distribution of contexts) | 20 to 70 bits depending on the domain (table `tab:estimations_structurelles_HC`) | **yes** |
| Case-level context (derivations of §4.3) | 8, 11 and 20 bits | no |

The three P2 estimates are therefore compared with the domain ranges, never with the case-level values.

$H(\mathcal{C})$ enters $\hat\alpha = \log_2|\mathcal{V}|/H(C)$ (P1 and P4) and the refutation criterion on $\gamma$ ([pre-registration](../00_commun/preenregistrement_en.md#5-refutation-criteria)).

## 3. Hypotheses tested (thesis, §4.2.2.2)

| Code | Domain | Domain code | $H(\mathcal{C})$ estimated in the thesis |
|---|---|---|---|
| H2.1 | Electoral disputes | `ELEC` | 30 to 50 bits |
| H2.2 | Financial compliance | `FIN` | 40 to 70 bits |
| H2.3 | Contract signature | `CONT` | 20 to 40 bits |

The dominant components cited in the thesis are the register, the rules and the history for `ELEC`; transactions, regulations and audit for `FIN`; parties, clauses and jurisdiction for `CONT`.

## 4. Three independent approaches

The thesis proposes three approaches (§4.2.2.2 to §4.2.2.4). They rest on different assumptions. Their agreement, or their divergence, is a result in itself.

### 4.1 Approach 1, structural decomposition

**Principle.** Identify the independent dimensions of the context and add up their entropies under approximate independence.

The thesis gives two forms. The glossary states $H(C) = H(L) + H(T\mid L) + H(R\mid L,T)$, with a legal component $L$, a temporal component $T$ and a procedural component $R$. For the contractual domain, equation `eq:decomposition_HC` writes

$$H(C) = H(C_{\text{parties}}) + H(C_{\text{clauses}}) + H(C_{\text{jurisdiction}}) + H(C_{\text{history}}).$$

The proposed grid reconciles the two forms. Each concrete element (parties, clauses, jurisdiction, history, etc.) is attached to one of the components $L$, $T$ or $R$, and its entropy is estimated by the expert. Under independence, $H(T\mid L) \approx H(T)$ and $H(R\mid L,T) \approx H(R)$.

**Instrument.** [Structural decomposition grid](grille_decomposition_structurelle_en.md).

**Participants.** The experts of the Delphi panel, before round 1 **[to be decided by the team]**.

### 4.2 Approach 2, probabilistic modelling by MDS

**Design (thesis, §4.2.2.3).** Present $n_{\text{ctx}} = 100$ varied contexts to a panel of 5 to 10 experts, who judge their pairwise dissimilarity.

**Analysis.** Dissimilarity matrix $D \in \mathbb{R}^{100\times 100}$, MDS reduction, effective volume $V_{\text{eff}} = \det(\hat\Sigma)^{1/2}$, estimate $H(\mathcal{C}) \approx \log_2 V_{\text{eff}}$.

**Proposed adaptation.** Judging all $\binom{100}{2} = 4{,}950$ pairs would take about 11 h per expert at 8 s per judgement. The proposal uses a corpus of 100 contexts split into three domains (34 `ELEC`, 33 `FIN`, 33 `CONT`) and has only the pairs **within each domain** judged, i.e. $561 + 528 + 528 = 1{,}617$ pairs per expert, spread over three sessions of about 1 h 30. This yields one estimate per domain, as hypotheses H2.1 to H2.3 require **[to be decided by the team]**.

**Instruments.** [Corpus of the 100 contexts](corpus_contextes_en.md) and [dissimilarity judgement protocol](protocole_dissimilarite_mds_en.md).

### 4.3 Approach 3, expert consensus by the Delphi method

**Procedure (thesis, §4.2.2.4).** 20 experts estimate $H(\mathcal{C})$ independently, then revise after anonymised feedback. The process has at most four rounds and stops when the interquartile range (IQR) falls below 5 bits.

**Instruments.** [Round 1 questionnaire](delphi_questionnaire_tour1_en.md), [feedback and revision for rounds 2 to 4](delphi_retour_tours_2_4_en.md), [final synthesis](delphi_synthese_en.md).

## 5. Participants

| Panel | Size (thesis) | Proposed breakdown **[to be decided by the team]** |
|---|---|---|
| Delphi (and decomposition) | 20 experts | 7 law and litigation, 7 regulation and audit, 6 applied cryptography |
| MDS | 5 to 10 experts | at least 2 per profile |

The `P2-EX-NN` codes and quota tracking are in the [recruitment form](../00_commun/fiche_recrutement_stratification_en.md). An expert may belong to both panels. The experts do not take part in P1.

## 6. Timetable

The thesis plans 3 months, 20 experts and an estimated cost of 5,000,000 FCFA (table `tab:programme_experimental`). The proposed internal breakdown is as follows **[to be decided by the team]**.

| Week | Activity |
|---|---|
| W1–W2 | Recruitment, consent, finalisation of the 100-context corpus |
| W3 | Decomposition grid (approach 1) |
| W4–W9 | Delphi rounds 1 to 4, at most one round every two weeks |
| W4–W8 | MDS sessions, three per expert, in parallel with the Delphi |
| W10–W12 | Analysis and comparison of the three approaches |

The recommended order places the decomposition before Delphi round 1, and round 1 before any MDS session. An expert who belongs to both panels is thus not influenced by the MDS corpus when giving direct estimates.

## 7. Analysis

The computations follow the [statistical analysis plan](../00_commun/plan_analyse_statistique_en.md), section 8. The module `cro_terrain.p2` of the [analysis package](../analyse/README_en.md) implements them.

| Approach | Estimate per domain | Function |
|---|---|---|
| Decomposition | median and IQR of the experts' sums | `p2.decomposition_totals`, `p2.summarize_by_domain` |
| MDS | $\log_2 V_{\text{eff}}$, interval by bootstrap over experts | `p2.dissimilarity_matrix`, `p2.choose_dimensions`, `p2.mds_entropy`, `p2.mds_entropy_bootstrap` |
| Delphi | median of the last round | `p2.delphi_round_summary`, `p2.delphi_should_stop` |

The three estimates are reported side by side with the thesis range. They are not combined into a single value **[to be decided by the team]**.

## 8. Caveats

1. **Unit of the MDS scale.** Dividing the dissimilarity unit by $s$ raises the estimate $\log_2 V_{\text{eff}}$ by $k\log_2 s$ bits for $k$ retained dimensions. The test `test_mds_entropy_matches_covariance_and_unit_shift` checks this. The unit and the rule for choosing $k$ must be fixed and registered before data collection.
2. **Order of magnitude of the MDS approach.** With a 0 to 10 scale and a unit of one step, each retained dimension contributes roughly $\log_2$ of the standard deviation of the coordinates, i.e. a few bits. Reaching 20 to 70 bits would require dozens of dimensions, whereas a domain has only 33 or 34 contexts. A large gap between the MDS approach and the other two is therefore foreseeable. It must be interpreted as a limitation of the method before being read as a refutation.
3. **Independence of the components.** The sum of the entropies is an upper bound on the joint entropy. Approach 1 therefore tends to overestimate $H(\mathcal{C})$ when elements are correlated (for example jurisdiction and clause type).
4. **Anchoring in the Delphi.** The thesis ranges are not communicated to the experts. The feedback of each round only gives the anonymised distribution of the previous round's answers.
5. **Link with $\hat\alpha$.** $\hat\alpha$ depends on the value of $H(\mathcal{C})$ retained. The choice of the reference approach for $\hat\alpha$ must be registered before P1 data collection **[to be decided by the team]**.

## 9. Place of P2 in the refutation criteria

Table `tab:criteres_refutation` of the thesis contains no criterion on $H(\mathcal{C})$ itself. P2 supplies the value of $H(\mathcal{C})$ used by the criterion on $\gamma$, which is refuted if the upper bound of the 95 % CI of $\hat H(V\mid C)$ is below $\alpha H(\mathcal{C}) - 1$ ([pre-registration](../00_commun/preenregistrement_en.md#5-refutation-criteria)).

The comparison of the estimates with ranges H2.1 to H2.3 is reported as a side-by-side reading. An estimate outside the range does not refute the trilemma. It indicates that the ranges of table `tab:estimations_structurelles_HC` must be revised.

## 10. Prerequisites

☐ Favourable opinion of the ethics committee ([template](../00_commun/dossier_comite_ethique_en.md))
☐ Confidentiality undertakings of the experts signed ([template](../00_commun/engagement_confidentialite_en.md))
☐ Corpus of the 100 contexts reviewed and frozen
☐ Unit of the MDS scale and dimension-selection rule registered
☐ Pre-registration filed ([template](../00_commun/preenregistrement_en.md))
☐ All [to be decided by the team] items resolved

Licence CC BY 4.0.
