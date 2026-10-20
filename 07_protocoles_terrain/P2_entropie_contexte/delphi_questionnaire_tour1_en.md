# Delphi questionnaire, round 1 (P2, approach 3)

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.2.4 (“20 experts estimate $H(\mathcal{C})$ independently, then revise after anonymised feedback”, stop when the IQR is below 5 bits)

[Version française](delphi_questionnaire_tour1_fr.md) · [P2 protocol](protocole_en.md) · [Rounds 2 to 4](delphi_retour_tours_2_4_en.md)

Individual questionnaire, completed alone, without contact with the other experts. Estimated duration 30 to 40 min **[to be confirmed at pre-test]**. The form carries no name. The questionnaire is administered in French. This English version is a working translation.

| Field | Value |
|---|---|
| Expert code | `P2-EX-__` |
| Profile | ☐ law and litigation ☐ regulation and audit ☐ applied cryptography |
| Date sent / returned | ___ / ___ / ______ → ___ / ___ / ______ |

## 1. What you are asked

An institution (a court, a regulator, an electoral commission) handles files that arise in varied contexts. Two files have the same **context** when the institution would handle them in the same way, given the same evidence. You are asked to estimate **how many truly distinct contexts** an institution encounters in each of the three domains below, taking into account that some contexts are frequent and others rare.

This quantity is expressed in **bits**. A domain with $N$ distinct contexts, all equally frequent, has an entropy of $\log_2 N$ bits. When some contexts are much more frequent than others, the entropy is lower than $\log_2 N$.

| Number of distinct equiprobable contexts | Bits |
|---|---|
| 2 | 1 |
| 1,000 | ≈ 10 |
| 1 million | ≈ 20 |
| 1 billion | ≈ 30 |
| $10^{12}$ | ≈ 40 |
| $10^{15}$ | ≈ 50 |
| $10^{18}$ | ≈ 60 |
| $10^{21}$ | ≈ 70 |

You may answer in bits or in number of contexts. The team does the conversion.

One possible method is to list the elements that change how a file is handled (applicable rules, capacity of the parties, time limits, procedures) and to count their plausible combinations. You are free to use another.

## 2. Your estimates

For each domain, give your best estimate, an interval within which you believe the true value lies with a probability of 9 in 10, your confidence (0 none, 10 complete) and, in a few lines, the main argument for your estimate. The arguments will be passed on anonymously to the other experts.

### Domain ELEC, electoral disputes

Challenges concerning elections (political, professional, association) brought before an electoral commission or a court.

| Best estimate | Lower bound | Upper bound | Confidence 0–10 |
|---|---|---|---|
| ______ ☐ bits ☐ contexts | ______ | ______ | ____ |

Main argument

______________________________________________________________________
______________________________________________________________________

### Domain FIN, financial compliance

Compliance controls (prudential, AML/CFT, tax, accounting) of financial or public entities.

| Best estimate | Lower bound | Upper bound | Confidence 0–10 |
|---|---|---|---|
| ______ ☐ bits ☐ contexts | ______ | ______ | ____ |

Main argument

______________________________________________________________________
______________________________________________________________________

### Domain CONT, contract signature

Disputes concerning signed contracts, on paper or electronically.

| Best estimate | Lower bound | Upper bound | Confidence 0–10 |
|---|---|---|---|
| ______ ☐ bits ☐ contexts | ______ | ______ | ____ |

Main argument

______________________________________________________________________
______________________________________________________________________

## 3. Additional question

Rank the three domains from the richest to the least rich in distinct contexts.

1. ________ 2. ________ 3. ________

Return this questionnaire to the address or in the envelope indicated, by ___ / ___ / ______ at the latest.

---

## Team section

- Conversion into bits: $\log_2$ of the number of contexts given.
- Data entry in [gabarit_delphi_en.csv](gabarit_delphi_en.csv), one row per domain, with `round = 1`.
- No value from the thesis is communicated to the experts, at any round ([P2 protocol](protocole_en.md#8-caveats), point 4).

Licence CC BY 4.0.
