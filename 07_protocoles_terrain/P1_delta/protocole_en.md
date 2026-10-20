# P1: Protocol for measuring $\Delta$, the institutional extraction capacity

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.1 (and §4.2.4 for validation thresholds)

[Version française](protocole_fr.md) · [Folder README](README_en.md)

## 1. Objective

Measure empirically the institutional extraction capacity $\Delta$ (in bits), defined by the bounded-extraction assumption (thesis, §4.2.1.1, and Chapter 2, §2.3.1.2)

$$I(V;\Sigma\mid C) \leq I(M;\Sigma\mid C) + \Delta .$$

## 2. Operational definition

$\Delta$ is the amount of information about verdicts that an institutional actor can extract beyond the raw mutual information contained in the cryptographic proof. It captures prior knowledge not formalised in the context $C$, namely legal precedents, specialised training, institutional procedures and collective deliberation capacity (thesis, definition `def:capacite_extraction_op`).

By the proposition giving the informational foundation of the assumption (Chapter 2, §2.3.1.2), the quantity controlled is the conditional information $I(V;\Sigma\mid M,C)$. The assumption holds as soon as $I(V;\Sigma\mid M,C) \leq \Delta$.

## 3. Estimator

$$\hat\Delta = \hat I(V;\Sigma\mid M,C)$$

- Computed on the triplets $(v_i, \sigma_i, m_i)$ collected at fixed context $c$.
- Plug-in estimator with Miller–Madow correction, or NSB-type estimator for small samples.
- The message $m_i$ is known to the experimenter (ground truth) and not to participants.
- The estimator is positively biased in small samples. The confidence interval is obtained by non-parametric bootstrap over participants.
- The earlier estimator $I_{\text{emp}}(V;\Sigma\mid C) - I_{\text{true}}(M;\Sigma\mid C)$ is abandoned, since it is systematically negative for a reliable protocol and only yields a lower bound on $\Delta$ (remark in the thesis, §4.2.1.1).

Detailed computations and caveats are in the [statistical analysis plan](../00_commun/plan_analyse_statistique_en.md).

## 4. Experimental design

### 4.1 Participants (table `tab:stratification_delta`)

$N \geq 100$ professionals from the target institutions. The target is 120, stratified by level of expertise and type of institution.

| Category | Subgroup | Code | $n$ | Predicted $\Delta$ |
|---|---|---|---|---|
| Judges | Generalists (civil courts) | JG | 20 | $\approx 25$ bits |
| Judges | Specialised (contracts, PKI, digital) | JS | 20 | $\approx 40$ bits |
| Financial regulators | Juniors (< 5 years of experience) | RJ | 20 | $\approx 35$ bits |
| Financial regulators | Seniors (≥ 5 years, supervisors) | RS | 20 | $\approx 65$ bits |
| Auditors | Court of Audit (public sector) | AP | 20 | $\approx 45$ bits |
| Auditors | Private firms (Big 4 and equivalent) | AC | 20 | $\approx 55$ bits |
| **Total** | | | **120** | |

Institutional equivalences in Cameroon and quota tracking are in the [recruitment sheet](../00_commun/fiche_recrutement_stratification_en.md).

### 4.2 Experimental material

- 5 types of cryptographic proofs. ECDSA (`ECD`), Helios with ElGamal and ZK (`HEL`), Groth16 zk-SNARK (`G16`), RSA-PSS (`PSS`) and classical ElGamal (`EGC`).
- 10 standardised contexts per proof type (contractual, electoral, financial), i.e. 50 context–proof pairs, described in the [stimulus catalogue](stimuli/catalogue_stimuli_en.md).
- 30-item questionnaire per context ([verdict extraction questionnaire](questionnaire_extraction_verdict_en.md)). The thesis describes it as "validated". Its validation remains to be carried out through a pre-test **[to be decided by the team]**.

### 4.3 Variants within a pair

For $I(V;\Sigma\mid M,C)$ to be estimable, each pair $c$ includes several messages $m$ and, for each message, several proof variants $\sigma$. The proposal uses 2 messages and 2 proof variants per message, i.e. 4 variants per pair **[to be decided by the team]**. Each participant sees only one variant of a given pair.

### 4.4 Stimulus assignment (balanced rotation)

Each participant handles 10 contexts (thesis, §4.2.1.3). The proposed scheme **[to be decided by the team]** is as follows.

- The 10 contexts of each type are grouped into 5 blocks of 2 (C01–C02, C03–C04, C05–C06, C07–C08, C09–C10).
- Rotation list $r \in \{1,\dots,5\}$ assigns block $r$ for ECD, block $r+1$ for HEL, block $r+2$ for G16, block $r+3$ for PSS and block $r+4$ for EGC (indices modulo 5).
- Within each stratum, each list is assigned to 4 participants. Each pair is thus seen 4 times per stratum and 24 times overall. The 4 participants of a stratum who see the same pair each receive a different variant.
- The order of the 10 contexts in the session follows a balanced Latin square over proof types, to neutralise order and fatigue effects.

| List | ECD | HEL | G16 | PSS | EGC |
|---|---|---|---|---|---|
| 1 | C01–C02 | C03–C04 | C05–C06 | C07–C08 | C09–C10 |
| 2 | C03–C04 | C05–C06 | C07–C08 | C09–C10 | C01–C02 |
| 3 | C05–C06 | C07–C08 | C09–C10 | C01–C02 | C03–C04 |
| 4 | C07–C08 | C09–C10 | C01–C02 | C03–C04 | C05–C06 |
| 5 | C09–C10 | C01–C02 | C03–C04 | C05–C06 | C07–C08 |

## 5. Procedure

Each participant's session runs in five phases (thesis, §4.2.1.3).

| Phase | Content | Duration (thesis) | Instrument |
|---|---|---|---|
| 0 | Initial training in basic cryptographic concepts, without revealing internal mechanisms, to harmonise the minimum vocabulary | 2 h | [support_formation_phase0_en.md](support_formation_phase0_en.md) |
| 1 | Main session. For each of the 10 assigned contexts, (a) presentation of context $c$, (b) presentation of proof $\sigma$, (c) verdict extraction questionnaire, (d) measurement of response time and subjective confidence rating | 4 h | [questionnaire_extraction_verdict_en.md](questionnaire_extraction_verdict_en.md), [session log](../00_commun/journal_session_en.md) |
| 2 | Test-retest check. Presentation again of 3 contexts already seen after a 2-week interval | 1 h | [fiche_test_retest_en.md](fiche_test_retest_en.md) |
| 3 | Gold-standard computation. Two independent expert cryptographers give the correct verdicts (inter-rater agreement required ≥ 90%) | no participants | [grille_gold_standard_en.md](grille_gold_standard_en.md) |
| 4 | Debriefing and feedback | 30 min | [fiche_debriefing_en.md](fiche_debriefing_en.md) |

The gold standard (phase 3) does not involve participants. It can be set before phase 1, on the stimuli alone, so that experts do not know the participants' answers **[to be decided by the team]**.

The timed run of phase 1 is proposed in the [interviewer guide](guide_enqueteur_en.md). It allows about 20 min per context and two breaks.

## 6. Metrics (algorithm `alg:estimation_delta`)

1. Present $\sigma_i$ with $C$ to the institutional actors.
2. Record verdicts $V$, confidence scores and decision times.
3. Associate each answer with the message $m$ known to the experimenter.
4. Test admissibility $V \perp M \mid (\Sigma, C)$ with a permutation test.
5. Estimate $\hat\Delta = \hat I(V;\Sigma\mid M,C)$.
6. Estimate $\hat\alpha = \log_2|\mathcal{V}| / H(C)$.
7. Validate by test-retest reliability and inter-rater consistency. The numerical thresholds are those of the standardised protocol (thesis, §4.2.4), namely ICC $\geq 0.8$ and $\kappa \geq 0.7$.

Confidence scores and decision times are used to detect random answers, which would contaminate the mutual-information estimate (thesis, §4.2.1.4).

## 7. Testable predictions (thesis, §4.2.1.5)

1. $\hat\Delta_{\text{general judge}} \approx 25$ bits
2. $\hat\Delta_{\text{PKI judge}} \approx 40$ bits
3. $\hat\Delta_{\text{senior regulator}} \approx 65$ bits
4. $\hat\Delta_{\text{ECDSA}} > \hat\Delta_{\text{Helios}}$ for every subgroup
5. Institutional amplification factor of 1.8 to 3.7 relative to Miller's individual capacity (about 20 bits)

The thesis presents these figures as targets rather than bounds, which the measurement may contradict.

## 8. Refutation criteria

The criteria of table `tab:criteres_refutation` that concern P1 bear on $\Delta$, admissibility and $\gamma$. They are reproduced verbatim in the [pre-registration](../00_commun/preenregistrement_en.md#5-refutation-criteria).

## 9. Duration, resources and schedule

The thesis plans 6 months, 120 institutional actors and an estimated cost of 15,000,000 FCFA (table `tab:programme_experimental`), within window M1–M12 of the schedule (table `tab:calendrier_experimental`). The proposed internal breakdown is as follows **[to be decided by the team]**.

| Month | Activity |
|---|---|
| M1 | Writing of the 50 pairs and their variants, gold standard, pre-test of the questionnaire with ____ persons outside the sample |
| M2 to M5 | Phase 0, 1, 2 and 4 sessions in waves of ____ participants |
| M6 | Data entry, quality control, analysis according to the pre-registered plan, feedback |

## 10. Prerequisites (thesis, §4.2.4 and §4.2.8.3)

☐ Agreements signed with the institutions ([template](../00_commun/convention_institution_partenaire_en.md))
☐ Favourable opinion of the ethics committee ([template](../00_commun/dossier_comite_ethique_en.md))
☐ Funding obtained
☐ Pre-registration deposited ([template](../00_commun/preenregistrement_en.md))
☐ All [to be decided by the team] flags resolved
