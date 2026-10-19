# PQC training material (P5, phase 0)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.5.3, phase 0 (“introduction to the NIST PQC standards covering key structure, signing process and differences with RSA/ECDSA; training on the institutional implications of the post-quantum transition”, 3 h)

[Version française](support_formation_pqc_fr.md) · [P5 protocol](protocole_en.md) · [P1 training](../P1_delta/support_formation_phase0_en.md)

Outline of the training and storyline of the slides. The neutrality rules of the [P1 training](../P1_delta/support_formation_phase0_en.md#1-neutrality-principles) apply. The training uses no example from the stimuli, gives no decision rule and mentions neither $\Delta_q$ nor the predictions. It is delivered in French. This English version is a working translation.

The training follows the stratification of the thesis and is identical for all four strata. Differences in prior PQC training between strata are precisely what prediction 5 tests. Making them equal is not the aim.

## 1. Schedule (3 h)

| Duration | Module | Content |
|---|---|---|
| 10 min | Opening | aims, rules of the day, place of the training in the study |
| 25 min | M1. Why a transition | Shor's algorithm, threat to RSA and ECDSA, “harvest now, decrypt later”, transition timetable |
| 30 min | M2. The NIST standards | FIPS 203 (ML-KEM, key encapsulation, produces no proof), FIPS 204 (ML-DSA), FIPS 205 (SLH-DSA), security levels |
| 15 min | Break | |
| 35 min | M3. Structure of keys and signatures | compared sizes (ECDSA P-256 64 bytes, RSA-3072 384 bytes, ML-DSA-65 3,309 bytes, SLH-DSA-SHAKE-128f 17,088 bytes), public and private key, probabilistic signature |
| 25 min | M4. Signing and verification | what the verifier checks and what it does not, hybrid mode, certificate management |
| 25 min | M5. Institutional implications | long-term archiving, probative value of old signatures, migration of infrastructures, regulatory requirements |
| 15 min | M6. Reading a technical extract | common layout of the files, example outside the study (signature of fictitious board minutes) |

Module durations are proposals **[to be decided by the team]**. The total of 3 h is the one given in the thesis.

## 2. Key points

**M1.** A large enough quantum computer would break RSA and ECDSA. Signatures produced today with these schemes could then be forged, which raises the question of their future probative value. The exact timing of this threat is uncertain.

**M2.** In 2024 NIST published three post-quantum standards. Two are signature schemes, ML-DSA and SLH-DSA. The third, ML-KEM, is used to establish keys and produces no proof.

**M3.** Post-quantum signatures are bit strings, like classical signatures. They are only longer. As with ECDSA or RSA-PSS, two signatures of the same document differ.

**M4.** A successful verification establishes that the signature was produced with the matching private key, on the document whose digest is given. It says nothing about who held the key or when the signature was made.

**M5.** The transition raises institutional questions. They concern how long evidence is kept, the coexistence of classical and post-quantum signatures, and the burden of proof when an old signature is challenged. The module sets out these questions without answering them.

## 3. What the training does not present

- Phase 2 and the simulated quantum verifier. They are introduced at the start of phase 2, by the instruction of the [conditions form](fiche_conditions_bruit_en.md).
- The phase 1 interpretation aid sheets, whose effect is measured.
- Any value of $\Delta_q$, $\eta_q$ or of the decomposition $\Delta_q = \Delta + \delta_{\text{enh}} - \delta_{\text{degr}}$.

## 4. Fidelity check

☐ Identical slides for all strata (version ____)
☐ No example taken from the 12 pairs
☐ No presentation of phase 2 or of the aid sheets
☐ Actual duration recorded in the [session log](../00_commun/journal_session_en.md)

Licence CC BY 4.0.
