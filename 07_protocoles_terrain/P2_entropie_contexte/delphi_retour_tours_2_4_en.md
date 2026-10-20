# Anonymised feedback and revision, rounds 2 to 4 (P2, approach 3)

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.2.4 (revision after anonymised feedback, four-round procedure, stop when the IQR is below 5 bits)

[Version française](delphi_retour_tours_2_4_fr.md) · [P2 protocol](protocole_en.md) · [Round 1](delphi_questionnaire_tour1_en.md) · [Synthesis](delphi_synthese_en.md)

This document has two parts. Part A is the rule the team follows between two rounds. Part B is the form sent to each expert from round 2 onwards.

## Part A. Rule of conduct between two rounds

1. **Computation.** For each domain, the team computes on the answers of the round just closed the count, median, first and third quartiles, interquartile range (IQR), minimum and maximum (`cro_terrain.p2.delphi_round_summary`).
2. **Stopping per domain.** A domain is closed as soon as its IQR is below 5 bits. It is no longer submitted in later rounds. Open domains continue up to round 4 at most (`p2.delphi_should_stop`).
3. **Arguments.** The team groups the arguments by theme, rephrases them so that no expert can be identified, and keeps for each domain at most five arguments for a higher value and five for a lower value **[to be decided by the team]**.
4. **Neutrality.** The feedback contains no value from the thesis, no opinion of the team and no hint about the “right” value.
5. **Deadlines.** Two weeks per round at most. An expert who does not answer a round receives one reminder. They remain invited to later rounds and their last answer is kept for the computation **[to be decided by the team]**.
6. **Traceability.** Each feedback sent is archived with its date. The list of domains closed at each round is given in the [synthesis](delphi_synthese_en.md).

## Part B. Form for round ___ (2, 3 or 4)

| Field | Value |
|---|---|
| Expert code | `P2-EX-__` |
| Round | ☐ 2 ☐ 3 ☐ 4 |
| Date sent / returned | ___ / ___ / ______ → ___ / ___ / ______ |

### B.1 What the group answered in the previous round

Filled in by the team for each domain still open. Your own answers from the previous round are recalled in the last column. Only you and the team know them.

| Domain | Answers | Median | 1st quartile | 3rd quartile | IQR | Min – max | Your previous answer |
|---|---|---|---|---|---|---|---|
| ELEC | ____ | ____ bits | ____ | ____ | ____ | ____ – ____ | ____ bits [____ ; ____] |
| FIN | ____ | ____ bits | ____ | ____ | ____ | ____ – ____ | ____ bits [____ ; ____] |
| CONT | ____ | ____ bits | ____ | ____ | ____ | ____ – ____ | ____ bits [____ ; ____] |

Domains closed in the previous round (IQR below 5 bits), no longer to be estimated: ______

### B.2 Arguments of the group (anonymised)

| Domain | Arguments for a higher value | Arguments for a lower value |
|---|---|---|
| ELEC | 1. … | 1. … |
| FIN | 1. … | 1. … |
| CONT | 1. … | 1. … |

### B.3 Your revised estimate

You may keep or change your estimate. If your new estimate lies outside the interval between the group's 1st and 3rd quartiles, briefly say why.

| Domain | Best estimate (bits) | Lower bound | Upper bound | Confidence 0–10 | Unchanged |
|---|---|---|---|---|---|
| ELEC | ______ | ______ | ______ | ____ | ☐ |
| FIN | ______ | ______ | ______ | ____ | ☐ |
| CONT | ______ | ______ | ______ | ____ | ☐ |

Justification (mandatory if outside the group's interquartile interval)

______________________________________________________________________
______________________________________________________________________

Return by ___ / ___ / ______ at the latest.

---

Data entry in [gabarit_delphi_en.csv](gabarit_delphi_en.csv), one row per domain still open, with the round number. The justification goes in the `argument` column.

Licence CC BY 4.0.
