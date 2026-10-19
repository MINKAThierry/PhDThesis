# Trustee training material (P3, phase 1)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.3.3, phase 1 (“structured training on Helios and zero-knowledge proofs”, 4 h); Helios derivation, §4.3

[Version française](support_formation_trustees_fr.md) · [P3 protocol](protocole_en.md) · [Exercise ballots](formation/bulletins_exercice.json)

Outline of the training and storyline of the slides. Unlike the P1 training, this one goes into the internal mechanisms. The trustees are PhD students and academic staff, and they must be able to verify a proof themselves. The training is delivered in French. This English version is a working translation.

## 1. Neutrality rules

1. The training teaches **how to verify**. It never says **what verdict to give** from a verification result.
2. It mentions neither the predicted value $\mathsf{Opp} = 0.50$, nor the validation criterion, nor the proportion or types of control proofs.
3. It announces that the audit series “may contain ballots modified by the team”, as does the information sheet.
4. The exercises use a teaching format distinct from the Helios format. No ballot from the real election is shown during the training.

## 2. Schedule (4 h)

| Duration | Module | Content |
|---|---|---|
| 15 min | Opening | aims, role of the trustee in the research audit, separation from the real election |
| 35 min | M1. Helios architecture | registration, casting, public bulletin board, ballot fingerprint, cast verification, voter challenge (“cast or audit”), homomorphic tally, decryption shared among key holders |
| 35 min | M2. Exponential ElGamal encryption | prime-order group, election public key, ciphertext $(g^r, g^v y^r)$, additive homomorphism, why two ciphertexts of the same choice differ |
| 15 min | Break | |
| 45 min | M3. Zero-knowledge proofs | Chaum-Pedersen proof, disjunctive “0 or 1” proof, “sum equals 1” proof, Fiat-Shamir transform, what verification establishes and what it does not |
| 20 min | M4. Documented incidents | cases where expert trustees met operational difficulties (IACR 2025 and UCL 2009 incidents cited in §4.3 of the thesis), management of key shares |
| 50 min | M5. Exercises | verification of the six exercise ballots EX-1 to EX-6, filling in a blank audit form |
| 25 min | M6. Audit procedure | audit form, instructions, confidentiality, timetable, questions |

## 3. Key points per module

**M1.** The bulletin board publishes all encrypted ballots and their proofs. Each voter can find the fingerprint of their ballot. The result is obtained only after homomorphic combination of the ciphertexts and shared decryption. No individual ballot is decrypted.

**M2.** An exponential ElGamal ciphertext of a choice $v \in \{0,1\}$ is the pair $(\alpha, \beta) = (g^r, g^v y^r)$, with fresh randomness $r$. The product of two ciphertexts encrypts the sum of the choices. Encrypting the same choice twice gives two different ciphertexts, hence the need for a validity proof.

**M3.** For a ciphertext, the disjunctive proof establishes that $v = 0$ or $v = 1$ without saying which. The overall proof establishes that the choices of a ballot add up to 1. A successful verification establishes that the ballot is well formed under the discrete-logarithm assumption and in the random-oracle model. It establishes neither the identity of the voter, nor the uniqueness of the cast, nor compliance with the voting hours.

**M4.** The documented difficulties stem from operations (loss or mismanagement of key shares, procedures) more than from the mathematics. This module situates the trustee's role without giving any decision rule.

## 4. Exercises (M5)

The six ballots are produced by [generer_bulletins_exercice.py](formation/generer_bulletins_exercice.py), which reuses the Helios-style construction of the [P1 stimuli](../P1_delta/stimuli/generer_exemples.py). Their full values are in [bulletins_exercice.json](formation/bulletins_exercice.json). This teaching format is **not** the Helios format and must not be fed to a Helios verifier.

```sh
cd formation
python3 generer_bulletins_exercice.py --check   # regenerates and compares with the committed file
python3 generer_bulletins_exercice.py --verifier EX-3   # verifies one exercise ballot
```

Participants receive the six ballots and the exercise public key. They verify each ballot with the script's `--verifier` option, which recomputes the fingerprint and checks each proof. They then fill in a blank audit form for each. The correction concerns the verification results, not the verdict.

### Answer key for the verifications (handed out after the exercise)

| Ballot | Fingerprint (first 16 characters) | “0 or 1” proofs | “Sum equals 1” proof | What is at stake |
|---|---|---|---|---|
| EX-1 | `0ce4f30f9905fc19` | accepted | accepted | nothing, well-formed ballot (list 1) |
| EX-2 | `2f75d017f2aaa88b` | accepted | accepted | nothing, well-formed ballot (list 2) |
| EX-3 | `884666c85fff87e6` | 1st rejected | accepted | a proof modified after its creation |
| EX-4 | `3ddb28c0964ffda8` | accepted | rejected | two choices expressed, each ciphertext is indeed 0 or 1 |
| EX-5 | `346ae1ca7fde60be` | 1st rejected | rejected | value 2 encrypted for list 1 |
| EX-6 | `0ce4f30f9905fc19` | accepted | accepted | same fingerprint as EX-1, replayed ballot |

Discussion after correction. EX-4 shows that every local proof can succeed while the ballot is malformed. EX-6 shows that a successful cryptographic verification says nothing about the uniqueness of the cast. The trainer does not say what verdict they would have given.

## 5. Evaluation of the training

At the end of module M6, each trustee answers three questions, with no mark and no individual feedback.

1. I can verify the proofs of a Helios ballot on my own. ☐ not at all ☐ rather not ☐ rather yes ☐ completely
2. I know what a successful verification does not establish. ☐ not at all ☐ rather not ☐ rather yes ☐ completely
3. The time spent on exercises was ☐ insufficient ☐ sufficient ☐ excessive

The answers are recorded separately, with no link to the audit verdicts **[to be decided by the team]**.

## 6. Fidelity check

☐ Identical slides for all trustees (version ____)
☐ No mention of the predicted value or of the control types
☐ Exercises done on the teaching format only
☐ Actual duration recorded in the [session log](../00_commun/journal_session_en.md)

Licence CC BY 4.0 for the material, MIT for the script.
