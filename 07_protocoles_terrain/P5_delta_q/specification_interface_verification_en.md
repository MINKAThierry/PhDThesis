# Specification of the post-quantum verification interface (P5)

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.5.2 (“post-quantum verification interface with performance metrics”, “quantum environment simulator with adjustable depolarising noise $p \in [0.001, 0.1]$”)

[Version française](specification_interface_verification_fr.md) · [P5 protocol](protocole_en.md)

Requirements for the application used in phases 1 to 3. No implementation is provided in the repository. The reference functions for the noise model and the order of conditions are in `cro_terrain.p5`.

## 1. Principles

1. **Offline.** The application runs without network, on workstations prepared by the team.
2. **No identifying data.** It only knows participant codes.
3. **Real verification in phase 1.** ML-DSA or SLH-DSA verification is actually run with a validated implementation. The displayed result is the result obtained.
4. **Simulated verification in phase 2.** The displayed result comes from a simulated quantum verifier. The screen says so in plain words. This is a hypothetical scenario, since no such verifier is deployed.
5. **Complete logging.** Every display, answer and random draw is recorded with its timestamp.

## 2. Screens

| Screen | Content | Phase |
|---|---|---|
| Home | participant code entered by the interviewer, choice of phase, check of the rotation list | all |
| File | situation, technical extract of the signature in the common P1 layout | 1, 2, 3 |
| Verification | “verify” button, then result and performance metrics | 1, 2, 3 |
| Answer | questions Q1 and Q2 (and Q3 in phase 2) of the [questionnaire](questionnaire_pqc_en.md) | 1, 2, 3 |
| Aid | aid sheet for the scheme, then Q1' and Q2' | 1 |
| Break | mandatory every 50 min, lasting 10 min | 1, 2 |

## 3. Performance metrics displayed

| Metric | Phase 1 | Phase 2 |
|---|---|---|
| Scheme and parameter set | yes | yes |
| Size of public key and signature (bytes) | yes | yes |
| Measured verification time (ms) | yes | yes |
| Verification result | real | simulated, with the mention “simulated verifier” |
| Error rate of the simulated channel ($p/2$) | no | **[to be decided]**, shown or not |

## 4. Noise model (phase 2)

The simulated verifier first computes the true verification result $r \in \{\text{success}, \text{failure}\}$. It encodes it on one qubit, $|0\rangle$ for success and $|1\rangle$ for failure. It then applies a depolarising channel $\rho \mapsto (1-p)\rho + p\,I/2$ and measures the qubit. The displayed result is therefore flipped with probability $p/2$ (`cro_terrain.p5.depolarizing_flip_probability`).

| Condition | $p$ (thesis) | Flip probability $p/2$ |
|---|---|---|
| A | 0 | 0 |
| B | 0.001 | 0.0005 |
| C | 0.01 | 0.005 |
| D | 0.1 | 0.05 |

The draw uses a pseudo-random generator seeded per session, with the seed recorded in the log. The function `p5.noisy_verification_result(true_result, p, rng)` gives the reference behaviour.

This model is a minimal proposal. The P6 simulator (`cro_terrain.quantum`) makes it possible to replace this channel with another (dephasing, amplitude damping) or to encode the result on several qubits **[to be decided by the team]**.

## 5. Presentation order

- Phase 1. The participant's rotation list (catalogue, section 1). The order of items is randomised within each scheme block.
- Phase 2. Four blocks of 3 items, one per condition, in the participant's Williams order (`p5.latin_square_order`). Each of the 4 conditions takes each position once over 4 consecutive participants. Each condition precedes each of the others once.

## 6. Exported log

One CSV file per session, in the [template](gabarit_sessions_pqc_en.csv) format, plus a trace file.

| Trace | Content |
|---|---|
| `seed` | generator seed of the session |
| `displays` | timestamp, item, condition, true result, displayed result |
| `answers` | timestamp of each answer, value, screen |
| `incidents` | interruptions, refused attempts to go back, software errors |

## 7. Acceptance tests before data collection

☐ The 48 signatures of the stimulus set are accepted in phase 1. None is accepted on the other message
☐ Over 100,000 simulated draws, the observed flip frequency is compatible with $p/2$ for each condition
☐ The order of conditions follows the Williams design
☐ The exported CSV is read without error by `cro_terrain.templates.read_template(..., "p5_sessions")`
☐ The first verdict can no longer be changed once the aid is displayed

Licence CC BY 4.0.
