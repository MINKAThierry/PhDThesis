# Test-retest form (P5, phase 3)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.5.3, phase 3 (“re-presentation of scenarios after 2 weeks”, 1 h); §4.2.5.4 (repeat the measurement at constant noise before varying $p$)

[Version française](fiche_test_retest_pqc_fr.md) · [P5 protocol](protocole_en.md) · [P1 test-retest form](../P1_delta/fiche_test_retest_en.md)

The form follows the P1 one, with three differences.

1. **Constant noise.** The retest covers **phase 1** items (condition A, no noise). The thesis notes that low stability under noise would mix the actors' inconsistency with the instability of the channel. Stability without noise is therefore measured first.
2. **Without aid then with aid.** Each item is presented again with the two phase 1 screens, in the same order. Stability is computed separately for `aid = 0` and for `aid = 1`.
3. **Number of items.** 4 items, 2 per scheme, with the same variant as in phase 1 **[to be decided by the team]**.

## 1. Identification

| Field | Value |
|---|---|
| Participant code | `P5-___-___` |
| Phase 1 session / phase 3 session | `S-____` of __/__/____ / `S-____` of __/__/____ |
| Actual delay (days) | ____ (target 14) |
| Interviewer | `ENQ-__` |

## 2. Items presented again

| Rank | Stimulus | Variant | Phase 1 verdict without aid (filled in after the session) | Phase 1 verdict with aid (idem) |
|---|---|---|---|---|
| 1 | `MLD-C__` | `MLD-C__-S_` | ____ | ____ |
| 2 | `MLD-C__` | `MLD-C__-S_` | ____ | ____ |
| 3 | `SLH-C__` | `SLH-C__-S_` | ____ | ____ |
| 4 | `SLH-C__` | `SLH-C__-S_` | ____ | ____ |

Random draw among the participant's phase 1 items, one scheme after the other. Seed or method: ______

## 3. Indicators

| Indicator | Data | Threshold (P4) |
|---|---|---|
| ICC(2,1), absolute agreement | confidence, phase 1 versus phase 3, per aid modality | $\geq 0.8$ |
| Cohen's $\kappa$ | verdict, phase 1 versus phase 3, per aid modality | $\geq 0.7$ |

Data entry with `session = 3` in the [template](gabarit_sessions_pqc_en.csv). The function `cro_terrain.p4.retest_pairs` applies with `first = "1"` and `second = "3"`, after filtering on the `aid` column.

The closing question of the [P1 form](../P1_delta/fiche_test_retest_en.md#4-closing-question) is reused unchanged.

Licence CC BY 4.0.
