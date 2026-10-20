# Phase 0 training material (P1)

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.1.3, phase 0 (“introduction to basic cryptographic concepts without revealing internal mechanisms, in order to harmonise the minimum vocabulary”, 2 h)

[Version française](support_formation_phase0_fr.md) · [P1 protocol](protocole_en.md) · [Interviewer guide](guide_enqueteur_en.md)

This document is the outline of the training and the storyline of the slides. It fixes what is said and, above all, what is not. The same training is given, word for word, to every stratum. The interviewer reads the “to say” boxes and adds no comment beyond the standard answers of section 9. The training is delivered in French. This English version is a working translation.

## 1. Neutrality principles

Phase 0 provides a shared vocabulary. It must not change what the study measures, namely each institution's own capacity to draw a verdict from a proof. The following rules follow from this.

1. **No example taken from the stimuli.** The training examples concern situations unrelated to the 50 pairs (a parcel, a diploma, a lottery).
2. **No decision rule.** The training explains what a successful verification is. It never says what legal or regulatory decision to draw from it.
3. **No internal mechanism.** No formula, no elliptic curve, no RSA modulus. Schemes are presented by their function (sign, encrypt, prove) and by their verification result.
4. **Same limits for every scheme.** Each scheme gets the same presentation time and the same structure, so that no proof type is favoured.
5. **No mention of $\Delta$, of the predictions or of the hypotheses.** The precise purpose of the study is explained at the debriefing.

## 2. Schedule (2 h)

| Duration | Module | Slides |
|---|---|---|
| 10 min | Welcome, aims of the training, rules of the day | 1–3 |
| 15 min | Module 1. Digital fingerprint (hash function) | 4–6 |
| 20 min | Module 2. Electronic signature, public key, certificate, timestamp | 7–11 |
| 15 min | Module 3. Encryption | 12–14 |
| 15 min | Module 4. Zero-knowledge proof | 15–17 |
| 10 min | Break | |
| 15 min | Module 5. Verifiable electronic voting | 18–20 |
| 10 min | Module 6. Reading a cryptographic item in a file | 21–23 |
| 10 min | Familiarisation exercise on a fictitious file outside the study | 24–25 |
| 0 to 10 min | Questions (standard answers, section 9) | 26 |

Module durations are proposals **[to be decided by the team]**. The total of 2 h is the one given in the thesis.

## 3. Module 1. Digital fingerprint

> **To say.** A hash function turns a document of any size into a short string of fixed length, called a fingerprint or digest. Two properties matter here. If the document changes, even by a comma, the fingerprint changes. Recovering the document from the fingerprint alone is impossible in practice.

Example slide. The SHA-256 fingerprint of “Parcel 4521 was delivered on 3 May” compared with that of “Parcel 4521 was delivered on 4 May”. The two strings have nothing in common.

Key point. The fingerprint makes it possible to check that a given document is the one that was processed. It says nothing about the content of a document one does not have.

## 4. Module 2. Electronic signature

> **To say.** An electronic signature is produced with a private key, held only by the signer, and verified with the matching public key, which anyone may know. It applies to the fingerprint of a document. A successful verification establishes two things. The signature was produced with the private key matching the public key used for verification. The document whose fingerprint is given has not been modified since. Linking a public key to a person relies on a certificate issued by a certification authority. The time of a signature is established by a timestamp, whose reliability depends on its source.

Two families are named, without detail. ECDSA and RSA-PSS. Signing the same document twice gives two different signatures, both valid.

Key point. Verification concerns the key, the fingerprint and the signature. Who held the key, and when, is a matter for the file.

## 5. Module 3. Encryption

> **To say.** Encrypting a content makes it unreadable for anyone without the decryption key. With public-key encryption, anyone can encrypt and only the holder of the private key can decrypt. Encrypting the same content twice gives two different ciphertexts. From a ciphertext alone, nothing can be said about its content.

One scheme is named, without detail. ElGamal.

Key point. A ciphertext alone proves nothing about what it contains, unless it comes with a proof (module 4).

## 6. Module 4. Zero-knowledge proof

> **To say.** A zero-knowledge proof makes it possible to convince someone that a statement is true without revealing the information that makes it true. For example “this amount is below the threshold” without revealing the amount. A successful verification establishes that the statement is true for the stated public data, under the assumptions of the system. It does not reveal the secret data.

Example slide. A fictitious lottery proves that a winning ticket belongs to the tickets sold without revealing its number.

One system is named, without detail. Groth16, which produces very short proofs.

## 7. Module 5. Verifiable electronic voting

> **To say.** In verifiable electronic voting, each ballot is encrypted. An attached proof establishes that the ballot is well formed (for example, that it contains exactly one choice) without revealing that choice. Ballots are published on a public bulletin board. The tally is obtained by combining the ciphertexts and then decrypting only the total, under the control of several key holders.

One system is named, without detail. Helios.

Key point. Verifying a ballot establishes that it is well formed. It does not say who it was cast for.

## 8. Module 6. Reading a cryptographic item in a file

The layout shared by all the files of the study is presented on an example outside the study (a signed diploma certificate).

| Heading | What it contains |
|---|---|
| Nature | the type of item (signature, ciphertext, proof) |
| Public data | public key, certificate, fingerprint, public inputs |
| Proof value | a string of hexadecimal characters, shortened |
| Verification result | always stated in one sentence |
| Timestamp | date, time and declared source |

> **To say.** In every file of the study, the technical verification has been done for you and its result is stated. You have no computation to make. You are asked for the decision you would take in your duties.

**Familiarisation exercise.** Participants read the signed diploma certificate and fill in a 5-item trial questionnaire, modelled on the study questionnaire. The answers are neither collected nor discussed. The exercise only serves to get used to the 0 to 7 scale.

## 9. Standard answers to frequent questions

| Question | Standard answer |
|---|---|
| “What should be decided in such a case?” | “No particular answer is expected. Answer as you would in your duties.” |
| “Does a valid signature prove that the person signed?” | “It proves that the matching key was used. The rest depends on the file.” |
| “Can these systems be broken?” | “For the study, you may assume that the schemes are used correctly.” |
| “Why these check questions?” | “They are used to check the quality of the answers. They do not assess you.” |
| Detailed technical question | “That goes beyond the training. We can discuss it at the debriefing.” |

Any unforeseen question and its answer are recorded in the [session log](../00_commun/journal_session_en.md).

## 10. Fidelity check

☐ Identical slides for all sessions (version number: ____)
☐ “To say” boxes read without additions
☐ No example taken from the 50 pairs
☐ Actual duration recorded in the session log

Licence CC BY 4.0.
