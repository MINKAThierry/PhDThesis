# Final Delphi synthesis and comparison of the three approaches (P2)

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.2.2 to §4.2.2.4; table `tab:estimations_structurelles_HC`

[Version française](delphi_synthese_fr.md) · [P2 protocol](protocole_en.md) · [Analysis plan, section 8](../00_commun/plan_analyse_statistique_en.md#8-p2-analyses)

Template of the final P2 report. The team fills it in after the last Delphi round and the MDS sessions. An anonymised copy is sent to the experts.

## 1. Course of the Delphi

| Round | Sent | Closed | Experts invited | Answers | Domains still open |
|---|---|---|---|---|---|
| 1 | __/__/____ | __/__/____ | ____ | ____ | ELEC, FIN, CONT |
| 2 | __/__/____ | __/__/____ | ____ | ____ | ______ |
| 3 | __/__/____ | __/__/____ | ____ | ____ | ______ |
| 4 | __/__/____ | __/__/____ | ____ | ____ | ______ |

## 2. Evolution per domain

| Domain | Round | Median (bits) | IQR (bits) | Min – max | Closed at this round |
|---|---|---|---|---|---|
| ELEC | 1 | | | | ☐ |
| ELEC | 2 | | | | ☐ |
| ELEC | 3 | | | | ☐ |
| ELEC | 4 | | | | ☐ |
| FIN | 1 | | | | ☐ |
| FIN | 2 | | | | ☐ |
| FIN | 3 | | | | ☐ |
| FIN | 4 | | | | ☐ |
| CONT | 1 | | | | ☐ |
| CONT | 2 | | | | ☐ |
| CONT | 3 | | | | ☐ |
| CONT | 4 | | | | ☐ |

Reason for stopping per domain: ☐ consensus (IQR below 5 bits) ☐ four rounds reached without consensus.

A domain stopped without consensus is reported with its final median and IQR and the mention “consensus not reached”.

## 3. Decisive arguments

For each domain, summarise in three to five lines the arguments that moved the estimates.

- ELEC: ______________________________________________
- FIN: ______________________________________________
- CONT: ______________________________________________

## 4. Comparison of the three approaches

| Domain | Thesis range | Decomposition (median [IQR]) | MDS (estimate [95 % CI], $k$ dimensions) | Delphi (median of last round [IQR]) |
|---|---|---|---|---|
| ELEC | 30 to 50 bits | | | |
| FIN | 40 to 70 bits | | | |
| CONT | 20 to 40 bits | | | |

Parameters registered before data collection and applied to the MDS: unit ____ step(s), stress threshold ____, $k$ retained ELEC ____ FIN ____ CONT ____.

Order of the domains (from richest to least rich) according to each approach, and order given in answer to the additional question of round 1.

| Source | 1st | 2nd | 3rd |
|---|---|---|---|
| Thesis (upper bounds) | FIN | ELEC | CONT |
| Decomposition | | | |
| MDS | | | |
| Delphi | | | |
| Additional question, majority answer | | | |

## 5. Reading

Write following these rules.

1. An estimate outside the thesis range is reported as such. It leads to revising the range, not to refuting the trilemma ([P2 protocol](protocole_en.md#9-place-of-p2-in-the-refutation-criteria)).
2. A gap between the MDS approach and the other two is first related to the dependence of the MDS on the unit and on the number of dimensions ([P2 protocol](protocole_en.md#8-caveats)).
3. The three estimates are not combined into a single value unless the opposite was registered before data collection.
4. The value of $H(\mathcal{C})$ passed on to P1 and P4 for $\hat\alpha$ and for the criterion on $\gamma$ is that of the registered reference approach: ☐ decomposition ☐ MDS ☐ Delphi.

## 6. Value passed on to the other protocols

| Domain | $H(\mathcal{C})$ retained (bits) | Approach | Uncertainty |
|---|---|---|---|
| ELEC | | | |
| FIN | | | |
| CONT | | | |

Written by ______ on ___ / ___ / ______. Reviewed by ______.

Licence CC BY 4.0.
