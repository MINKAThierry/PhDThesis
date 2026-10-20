# Proof audit form (P3, phase 3)

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.3.3, phase 3 (“each trustee independently examines the proof, gives a verdict $v \in \mathcal{V}$, rates confidence out of 10”)

[Version française](fiche_audit_preuve_fr.md) · [P3 protocol](protocole_en.md)

One form per trustee and per proof, i.e. 60 forms per trustee. A trustee's forms are bound in the presentation order assigned to that trustee. The trustee fills in the form alone, without contact with the other trustees. The form is administered in French. This English version is a working translation.

## Instructions to the trustee (read at the start of the session)

> “You will examine a series of ballots published during the election. For each one, you have its content (ciphertexts, proofs, fingerprint, timestamp) and the verification tool of the Helios instance. You may run the verification, compare fingerprints and consult the bulletin board. Then indicate the decision you would recommend to the electoral body for this ballot, together with your confidence. The series may contain ballots modified by the team. Do not communicate with the other trustees during the session. There is no time limit per ballot, but the session lasts 3 h.”

---

| Field | Value | Template variable |
|---|---|---|
| Session | `S-____` | `session_id` |
| Trustee | `TR-__` | `trustee_id` |
| Proof (audit identifier) | `P-__` | `proof_id` |
| Proof type | Helios, encrypted ballot with validity proofs | `proof_type = HEL` |
| Election | `ENSP-______` | `context_id` |
| Rank in the trustee's series | ____ / 60 | |
| Start time | __:__:__ | computation of `time_s` |

### 1. Checks performed

Tick what you did.

☐ Verification of the “0 or 1” proofs of each ciphertext ☐ accepted ☐ rejected ☐ inconclusive
☐ Verification of the overall proof (the ballot contains exactly one choice) ☐ accepted ☐ rejected ☐ inconclusive
☐ Recomputation of the ballot fingerprint and comparison with the bulletin board ☐ matching ☐ not matching
☐ Search for duplicate fingerprints on the bulletin board ☐ none ☐ duplicate found
☐ Check of the timestamp against opening and closing times ☐ compliant ☐ outside the period
☐ Other: ______________________

### 2. Verdict

What decision would you recommend to the electoral body for this ballot? One answer only.

| Code | Verdict | |
|---|---|---|
| 1 | Valid ballot, counted | ☐ |
| 2 | Invalid ballot, set aside | ☐ |
| 3 | Further check or recount requested | ☐ |
| 4 | Investigation requested | ☐ |

Variable `verdict`.

### 3. Confidence

How confident are you in this verdict? (0 none, 10 complete certainty)

0 — 1 — 2 — 3 — 4 — 5 — 6 — 7 — 8 — 9 — 10

Variable `confidence_0_10`.

### 4. Main reason (optional, one line)

______________________________________________________________________

End time __:__:__

---

## Coordinator section (after the audit)

| Field | Value | Variable |
|---|---|---|
| Status of the proof according to the register | ☐ authentic ☐ control, type T_ | `reference_status` |
| Duration (s) | ______ | `time_s` |
| Incident or remark | ______________________ | `notes` |

## Data entry rules

One row per form in [gabarit_audit_preuves_en.csv](gabarit_audit_preuves_en.csv). Several boxes ticked in section 2 give an empty cell and a mention in `notes`. The checks ticked in section 1 and the reason are entered in `notes`, coded by their line number (for example `C1:acc;C3:conc`) **[coding to be decided]**.

Licence CC BY 4.0.
