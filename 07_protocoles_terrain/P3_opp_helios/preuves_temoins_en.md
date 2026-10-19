# Control-proof procedure (P3)

> **Status: PROPOSAL — addition to the thesis protocol, not deployed** · Source: thesis, Chapter 4, §4.2.3.5 (measuring $H_{\text{emp}}(V\mid C)$ instead of postulating it)

[Version française](preuves_temoins_fr.md) · [P3 protocol](protocole_en.md)

The thesis does not provide for control proofs. This procedure is a proposal. It aims to avoid the case where all verdicts are identical, which would leave $\mathsf{Opp}_{\text{emp}}$ undefined ([protocol](protocole_en.md#53-audited-proofs)). Its adoption is **[to be decided by the team]**.

## 1. Principle

The coordinator prepares 10 control proofs, copies of public ballots of the election to which a known alteration has been applied. They are mixed blind with the 50 sampled proofs. The trustees know neither how many controls there are nor which ones. They only know that the audit set may contain some.

Controls are never cast on the Helios instance. They exist only in the research audit set (agreement, article 4).

## 2. Types of alteration

| Code | Alteration | Expected effect on verification |
|---|---|---|
| T1 | One byte changed in a response of a “0 or 1” proof | validity proof rejected |
| T2 | One byte changed in the “sum equals 1” proof | overall proof rejected |
| T3 | Ciphertext of one option replaced by that of another ballot, proofs unchanged | proofs rejected |
| T4 | Replayed ballot, exact copy of a ballot already in the sample | proofs accepted, duplicate detectable by fingerprint |
| T5 | Casting timestamp changed and placed after the close | proofs accepted, context anomaly |

The proposed breakdown has 2 controls of each type **[to be decided]**.

Types T4 and T5 carry valid proofs. They measure whether trustees look beyond the verification result, which corresponds to the part of the verdict that does not come from the proof.

## 3. Preparation

1. After the draw, the coordinator chooses the source ballots at random with a distinct seed recorded in the control register. Sources for types T1, T2, T3 and T5 are taken outside the sample. Those for type T4 are taken from the sample, since a replayed ballot must appear twice in it.
2. The coordinator applies the alterations to a copy, in the format of the Helios instance, then checks with that instance's verification tool that the effect obtained is the expected one.
3. Each control receives an audit identifier of the same form as the others (`P-01` to `P-60`). The 60 proofs are then shuffled in a random order specific to each trustee.
4. The correspondence between audit identifier, source ballot, alteration type and status (`authentique` or `temoin`) is recorded in the control register, kept out of the trustees' sight until the end of the audit.

## 4. Control register (confidential until the audit is closed)

| Audit identifier | Source ballot (fingerprint) | Type | Effect checked | Status |
|---|---|---|---|---|
| `P-__` | `________` | T_ | ☐ as expected | temoin |
| `P-__` | `________` | T_ | ☐ as expected | temoin |
| `P-__` | `________` | T_ | ☐ as expected | temoin |

Prepared by ______ on ___ / ___ / ______. Checked by ______.

## 5. Data entry and analysis

The `reference_status` column of the [template](gabarit_audit_preuves_en.csv) receives `authentique` or `temoin` (the same codes in both language versions). The analysis reports $\mathsf{Opp}_{\text{emp}}$ on the 60 proofs and on the 50 sampled proofs alone, together with the detection rate for each control type.

Licence CC BY 4.0.
