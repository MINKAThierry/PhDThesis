# Stimulus sheet template (P1)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.1.2 (experimental material) and §4.2.1.3, phase 1, steps (a) and (b)

[Version française](gabarit_fiche_stimulus_fr.md) · [Stimulus catalogue](catalogue_stimuli_en.md) · [P1 protocol](../protocole_en.md)

One sheet per context–proof pair, i.e. 50 sheets. Each sheet describes the context $c$, the two committed messages $m$, the four proof variants $\sigma$ and the verdict space. It is used to print the files handed to participants and to record the ground truth. Parts 1 to 4 are internal. Only part 5 is handed to the participant.

## Construction principle

For $\hat I(V;\Sigma\mid M,C)$ to be estimable, a pair $c$ must offer several proofs for the same message. The five schemes chosen in the thesis are probabilistic. ECDSA and RSA-PSS draw fresh randomness at each signature (nonce $k$, PSS salt). ElGamal and Helios draw encryption randomness. Groth16 proofs can be re-randomised. Two executions on the same $(m, c)$ therefore produce two distinct proofs, both valid.

The following rules apply to every sheet.

1. The two messages $m_1$ and $m_2$ of a pair are **both compatible** with the context and with the verification result. No element of the file handed out allows an honest reader to tell them apart.
2. The message $m$ never appears in clear in the file handed out. For a signature, the file shows the signed digest and not the text. For a ciphertext or a zero-knowledge proof, it shows the ciphertext or the proof and the public inputs.
3. The four variants have the same presentation (layout, length, verification result). They differ only in the cryptographic values.
4. The values are produced by a reference implementation documented in part 3. Keys, seeds and randomness are kept outside the file handed out, together with the ground truth (dataset D7 of the [data management plan](../../00_commun/plan_gestion_donnees_en.md)). They are published only after the end of any data collection that uses the same set of stimuli.
5. The context names no real person, institution or case. Names are fictitious and say so.
6. A deliberate anomaly, when there is one, appears in the description of the situation (for example a timestamp after the close of a ballot) and never in the cryptographic item. Proof verification always succeeds. The information sheet announces these anomalies and the debriefing explains them.

---

## 1. Identification

| Field | Value |
|---|---|
| Pair code (`stimulus_id`) | `___-C__` |
| Proof type (`proof_type`) | ☐ ECD ☐ HEL ☐ G16 ☐ PSS ☐ EGC |
| Domain (Q28 check) | ☐ 1 contract ☐ 2 election ☐ 3 financial control ☐ 4 other |
| Verdict space template | ☐ A act ☐ B vote ☐ C financial control |
| Rotation block | ☐ C01–C02 ☐ C03–C04 ☐ C05–C06 ☐ C07–C08 ☐ C09–C10 |
| Sheet version | `v__` of ___ / ___ / ______ |
| Author, legal reviewer, cryptographic reviewer | `____` / `____` / `____` |

## 2. Committed messages (ground truth, do not circulate)

| Code (`message_m_id`) | Content of $m$ | What distinguishes $m_1$ from $m_2$ |
|---|---|---|
| `___-C__-M1` | | |
| `___-C__-M2` | | |

Justify in two sentences that the context and the verification result are compatible with each of the two messages.

______________________________________________________________________

## 3. Proof variants

| Code (`proof_sigma_id`) | Message | Value of $\sigma$ (short form) | Seed or randomness (D7 reference) | Verification |
|---|---|---|---|---|
| `___-C__-S1` | M1 | | `D7-____` | ☐ accepted |
| `___-C__-S2` | M1 | | `D7-____` | ☐ accepted |
| `___-C__-S3` | M2 | | `D7-____` | ☐ accepted |
| `___-C__-S4` | M2 | | `D7-____` | ☐ accepted |

Implementation and parameters: ______________________________ (library, version, curve or modulus, hash function).

Assignment of the variants to the participants of a stratum who see the pair (a different variant each):

| Participant of the stratum who received the pair | 1st | 2nd | 3rd | 4th |
|---|---|---|---|---|
| Variant | S__ | S__ | S__ | S__ |

## 4. Verdict space

Copy into Q01 of the questionnaire the four labels of the template ticked in part 1. They may be adapted to the case without changing their order or meaning **[labels to be decided by the team]**.

| Code | Template A (act between parties, domains 1 and 4) | Template B (election or vote, domain 2) | Template C (financial control, domain 3) |
|---|---|---|---|
| 1 | The act is established and enforceable against the named party. | The ballot is included in the count. | Compliant, no further action. |
| 2 | The act is established but its enforceability requires further evidence. | The ballot is included subject to a check. | Compliant with reservations, request for information. |
| 3 | The act is not established. | The ballot is set aside. | Non-compliant, corrective measure requested. |
| 4 | The item is set aside as irregular or suspicious. | The ballot is challenged for presumed fraud and referred. | Non-compliant, sanction or report. |

In all three templates, $|\mathcal{V}_{\text{glob}}| = 4$.

Expected reference verdicts for each message (filled in by the gold standard, [grid](../grille_gold_standard_en.md)): M1 → ____ ; M2 → ____.

## 5. File handed to the participant

The file is at most two pages long. It contains the following elements, in this order.

**5.1 Situation.** Factual description in 150 to 250 words. The parties, the chronology, the subject of the dispute or control, the question put to the institution.

**5.2 Cryptographic item.** Uniform presentation across the 50 pairs.

| Element | Content |
|---|---|
| Nature of the item | for example “ECDSA P-256 electronic signature” |
| Public data | public key or certificate, public inputs, signed digest, ballot identifier |
| Proof value | shortened hexadecimal value (first 16 and last 16 characters), length in bytes |
| Verification result | “Verification successful with the stated public key” or equivalent wording |
| Timestamp, if any | declared date and time, with their source |

**5.3 Question.** One sentence pointing to the questionnaire, for example “What decision would you give on the basis of this file?”.

## 6. Checks before printing

☐ The two messages are compatible with the file (legal review)
☐ The four variants are accepted by the reference implementation (cryptographic review)
☐ The four printed files are identical apart from the proof value
☐ No real name, institution or case
☐ Pre-test carried out with ____ people outside the sample **[to be decided by the team]**

Licence CC BY 4.0.
