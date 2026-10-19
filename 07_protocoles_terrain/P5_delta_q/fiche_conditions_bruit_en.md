# Noise conditions form (P5, phase 2)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.5.3, phase 2 (conditions A to D, 2 h)

[Version française](fiche_conditions_bruit_fr.md) · [P5 protocol](protocole_en.md) · [Interface](specification_interface_verification_en.md)

One form per participant for phase 2. The coordinator prepares it and the interviewer checks it during the session. It recalls that phase 2 belongs to the hypothetical scenario of a quantum verifier.

## 1. Conditions (thesis)

| Condition | $p$ | Description in the thesis | Flip of the displayed result |
|---|---|---|---|
| A | 0 | no noise, classical reference | 0 % |
| B | 0.001 | low noise, typical of corrected systems | 0.05 % |
| C | 0.01 | moderate noise, typical NISQ | 0.5 % |
| D | 0.1 | high noise, robustness test | 5 % |

## 2. Williams order (4 consecutive participants)

| Participant rank modulo 4 | Block 1 | Block 2 | Block 3 | Block 4 |
|---|---|---|---|---|
| 0 | A | B | D | C |
| 1 | B | C | A | D |
| 2 | C | D | B | A |
| 3 | D | A | C | B |

Each condition takes each position once. It also precedes each of the others once. Order produced by `cro_terrain.p5.latin_square_order`.

## 3. Participant form

| Field | Value |
|---|---|
| Participant code | `P5-___-___` |
| Rank in the series of participants | ____ (modulo 4 = ____) |
| Session | `S-____` of ___ / ___ / ______ |
| Interviewer | `ENQ-__` |
| Noise generator seed | `________________` |

| Block | Planned condition | Condition shown by the interface | Items (stimulus and variant) | Start | End |
|---|---|---|---|---|---|
| 1 | | ☐ as planned | `___-C__-S_` ; `___-C__-S_` ; `___-C__-S_` | __:__ | __:__ |
| 2 | | ☐ as planned | `___-C__-S_` ; `___-C__-S_` ; `___-C__-S_` | __:__ | __:__ |
| 3 | | ☐ as planned | `___-C__-S_` ; `___-C__-S_` ; `___-C__-S_` | __:__ | __:__ |
| 4 | | ☐ as planned | `___-C__-S_` ; `___-C__-S_` ; `___-C__-S_` | __:__ | __:__ |

Flips actually produced by the interface, read from the log after the session. Block 1 ____, block 2 ____, block 3 ____, block 4 ____.

## 4. Instruction read at the start of phase 2

> “In this part, the verification result does not come from classical software. It is produced by a simulated quantum verifier, whose operation may be disturbed by noise. The noise level changes from one block to the next and is shown on screen. Answer as you would if such a verifier were used in your institution.”

## 5. Checks

☐ Block order matches the table of section 2
☐ Seed recorded before the start
☐ No phase 2 item is an item already seen in phase 1 by this participant **[to be decided: new or reused items]**
☐ Any deviation declared on a [deviation form](../00_commun/fiche_ecart_protocole_en.md)

Licence CC BY 4.0.
