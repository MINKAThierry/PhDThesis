# Catalogue of the 12 context–post-quantum signature pairs (P5)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.5.2 (ML-DSA, SLH-DSA, transaction, document and compliance contexts)

[Version française](catalogue_stimuli_pqc_fr.md) · [P5 protocol](../protocole_en.md) · [Stimulus sheet template (P1)](../../P1_delta/stimuli/gabarit_fiche_stimulus_en.md)

The P5 stimulus sheets follow the [P1 template](../../P1_delta/stimuli/gabarit_fiche_stimulus_en.md) and its six construction rules: two messages compatible with the file, two signatures per message, the same presentation for the four variants, no real name. Domain and verdict-space template use the same codes. The thesis cites three types of context (transaction, document, compliance). The proposal keeps two per scheme. The files are administered in French. This English version is a working translation.

## 1. List of pairs

Codes `MLD` for ML-DSA-65 (FIPS 204) and `SLH` for SLH-DSA-SHAKE-128f (FIPS 205).

| Code | Context type | Dom. | Sp. | Situation | M1 / M2 |
|---|---|---|---|---|---|
| MLD-C01 | transaction | 3 | C | Transfer order signed by an institution, beneficiary disputed (**written in full, §3.1**) | account 0042 / account 0917 |
| MLD-C02 | transaction | 3 | C | Securities sale order signed by an approved intermediary | 1,000 securities / 10,000 securities |
| MLD-C03 | document | 1 | A | Service contract signed by a public administration | 1-year term / 3-year term |
| MLD-C04 | document | 4 | A | Approval decision signed by a regulator | simple approval / approval with conditions |
| MLD-C05 | compliance | 3 | C | Internal control report signed and sent to the regulator | no anomaly / two anomalies |
| MLD-C06 | compliance | 3 | C | Timestamped and signed suspicious-transaction report | amount 5 M FCFA / 50 M FCFA |
| SLH-C01 | compliance | 3 | C | Signed annual AML/CFT compliance certificate (**written in full, §3.2**) | without reservation / reservation on two customers |
| SLH-C02 | compliance | 3 | C | Solvency certificate signed by a statutory auditor | compliant ratio / borderline ratio |
| SLH-C03 | document | 1 | A | Digital notarial deed archived for the long term | repurchase clause / no clause |
| SLH-C04 | document | 4 | A | Signed archive of a land register | plot A / plot B |
| SLH-C05 | transaction | 3 | C | Signed firmware update of a payment terminal | version 4.1 / version 4.2 |
| SLH-C06 | transaction | 1 | A | Signed delivery note of a public contract | full delivery / partial delivery |

SLH-DSA is often proposed for long-term archiving and firmware signing, hence the choice of contexts `SLH-C03` to `SLH-C05` **[to be decided by the team]**.

Proposed rotation in phase 1. Each participant sees 3 `MLD` pairs and 3 `SLH` pairs (blocks C01–C03 or C04–C06 for each scheme, crossed across participants). Each pair is seen by 40 participants, i.e. 10 per stratum, spread over the 4 variants.

## 2. Cryptographic values

[generer_signatures_pqc.py](generer_signatures_pqc.py) produces the keys and signatures of the two written pairs. The full values are in [exemples_signatures_pqc.json](exemples_signatures_pqc.json).

```sh
pip install dilithium-py==1.4.0 slh-dsa==0.2.5
python3 generer_signatures_pqc.py --check   # verifies the 8 signatures and that they differ
```

Both schemes are probabilistic. ML-DSA is used in “hedged” mode and SLH-DSA in randomised mode. The signatures therefore depend on fresh randomness, and the file is not reproducible bit for bit. The `--check` option verifies each signature with its public key and message. It also checks that no signature is accepted on the other message and that the four variants of a pair are distinct.

The libraries used are pedagogical Python implementations. They have not been audited. For the actual data collection, the signatures will be produced by a validated implementation **[to be decided by the team]**.

## 3. Pairs written in full

### 3.1 MLD-C01, transfer order

| Field | Value |
|---|---|
| Scheme | ML-DSA-65 (FIPS 204), public key 1,952 bytes, signature 3,309 bytes |
| Public key (shortened) | `6fd066757ef7d468…1727f168c48e1985` |
| M1 | transfer order of 12,500,000 FCFA to account 0042 |
| M2 | transfer order of 12,500,000 FCFA to account 0917 |

| Variant | Message | SHA-256 digest of the document | Start of the signature |
|---|---|---|---|
| MLD-C01-S1 | M1 | `cf2b67e22029c500…9f22372c3dad1fc1` | `5fd9bbcefe2ce7c159194e4055c39750…` |
| MLD-C01-S2 | M1 | `cf2b67e22029c500…9f22372c3dad1fc1` | `0492287a065d9efd013d9e7a41c21547…` |
| MLD-C01-S3 | M2 | `be566d3543e83cf5…9271bd2a72b43455` | `795dd3650d0cde11ad6f241cc54c22da…` |
| MLD-C01-S4 | M2 | `be566d3543e83cf5…9271bd2a72b43455` | `1e6043d70c0a57d3ec0a67ff80a0f116…` |

**File handed to the participant (version S1).**

> **Situation.** A fictitious payment institution executed a transfer of 12,500,000 FCFA ordered by a corporate customer. The customer maintains that the order it signed named a beneficiary account other than the one credited. The institution produces the technical extract below. Since last year its orders have been signed with a standardised post-quantum scheme. The regulator has received a complaint from the customer.
>
> | Element | Content |
> |---|---|
> | Nature | ML-DSA-65 digital signature (FIPS 204) |
> | Customer's public key | `6fd066757ef7d468…1727f168c48e1985` (1,952 bytes), registered when the account was opened |
> | SHA-256 digest of the signed order | `cf2b67e22029c500…9f22372c3dad1fc1` |
> | Signature | `5fd9bbcefe2ce7c1…` (3,309 bytes) |
> | Verification result | Verification successful with the stated public key |
>
> **Question.** What decision would you give on the customer's complaint?

Proposed verdicts (template C). 1 compliant, no further action. 2 compliant with reservations, request for information. 3 non-compliant, corrective measure requested. 4 non-compliant, sanction or report.

### 3.2 SLH-C01, compliance certificate

| Field | Value |
|---|---|
| Scheme | SLH-DSA-SHAKE-128f (FIPS 205), public key 32 bytes, signature 17,088 bytes |
| Public key | `f32fedadefa8b511…fdf71568855892e2` |
| M1 | AML/CFT compliance certificate for financial year 2025, without reservation |
| M2 | same certificate, with a reservation on two customers |

| Variant | Message | SHA-256 digest of the document | Start of the signature |
|---|---|---|---|
| SLH-C01-S1 | M1 | `cf2f5f89e8a510df…2eb8340b8088f257` | `0a0e888963b4055ff9ca8de21989fbac…` |
| SLH-C01-S2 | M1 | `cf2f5f89e8a510df…2eb8340b8088f257` | `67c02b1c357b964cd1508bba045055ed…` |
| SLH-C01-S3 | M2 | `b6003f8e7c6fe5c0…27db2815b973f4a1` | `fb9e64616e24aff01df7a2e5c6965d82…` |
| SLH-C01-S4 | M2 | `b6003f8e7c6fe5c0…27db2815b973f4a1` | `65f4356909527fdaf4e4d585d1b46d95…` |

The files show the **start** of the SLH-DSA signatures. Their end may coincide from one signature to another, because the upper layers of the hypertree are shared by all signatures under the same key. Showing the end would give participants a structural hint unrelated to the message.

**File handed to the participant (version S1).**

> **Situation.** A fictitious microfinance company must send the regulator every year an AML/CFT compliance certificate signed by its compliance officer. During an on-site inspection, the inspector finds that two high-risk customers were not subject to enhanced due diligence. The company states that the signed certificate already listed these two customers as a reservation. The paper copy kept by the regulator has been lost. Only the technical extract below is available.
>
> | Element | Content |
> |---|---|
> | Nature | SLH-DSA-SHAKE-128f digital signature (FIPS 205) |
> | Compliance officer's public key | `f32fedadefa8b511…fdf71568855892e2` (32 bytes) |
> | SHA-256 digest of the signed certificate | `cf2f5f89e8a510df…2eb8340b8088f257` |
> | Signature | `0a0e888963b4055f…` (17,088 bytes) |
> | Verification result | Verification successful with the stated public key |
>
> **Question.** What decision would you give regarding the company?

Proposed verdicts (template C), as in 3.1.

## 4. Interpretation aid sheet (handed out in phase 1, after the first verdict)

One page per scheme. It explains what a successful verification establishes, without saying what verdict to give.

**ML-DSA-65.** Lattice-based signature scheme (MLWE and MSIS problems), standardised by NIST in 2024 (FIPS 204). A successful verification establishes that the signature was produced with the private key associated with the public key, on the document whose digest is given. Two signatures of the same document differ, because randomness is used at each signature. Security targets NIST level 3 and resists known attacks by quantum computers.

**SLH-DSA.** Signature scheme based on hash functions only (FIPS 205). Signatures are long, about 17 kB for this parameter set. A successful verification establishes the same as for ML-DSA. Its security rests only on that of the hash function, hence its use for long-term archiving.

For both schemes, verification says nothing about who held the key, when the signature was made, or the content of a document of which only the digest is available.

Licence CC BY 4.0 for the texts, MIT for the script.
