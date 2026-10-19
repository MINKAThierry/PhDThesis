# Catalogue of the 50 context–proof pairs (P1)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.1.2 (“5 proof types, 10 standardised contexts per type, i.e. 50 context–proof pairs”)

[Version française](catalogue_stimuli_fr.md) · [Stimulus sheet template](gabarit_fiche_stimulus_en.md) · [P1 protocol](../protocole_en.md)

The thesis fixes the number of proof types, the number of contexts and their domains (contractual, electoral, financial). The 50 situations below are proposals. Two of them are written out in full (section 3), with real and reproducible cryptographic values. The other 48 remain to be written following the [template](gabarit_fiche_stimulus_en.md) **[to be decided by the team]**.

All situations are fictitious. They name no real person, institution or case. The files are administered in French. The English wording below is a working translation.

## 1. Breakdown

| Type | Scheme | Contract (1) | Election (2) | Financial control (3) | Other (4) |
|---|---|---|---|---|---|
| ECD | ECDSA P-256 | 6 | 1 | 3 | 0 |
| HEL | Helios (exponential ElGamal and zero-knowledge proofs) | 0 | 10 | 0 | 0 |
| G16 | Groth16 on BN254 | 2 | 1 | 7 | 0 |
| PSS | RSA-PSS 3072 bits | 5 | 0 | 3 | 2 |
| EGC | Classical ElGamal, no validity proof | 3 | 3 | 3 | 1 |
| **Total** | | **16** | **15** | **16** | **3** |

The domain determines the verdict space template (A for domains 1 and 4, B for domain 2, C for domain 3) and the expected answer to the check item Q28.

The breakdown is not balanced across types, because each scheme has its own institutional uses (Helios is a voting system). The effects of domain and of proof type are therefore partly confounded. The analysis plan treats proof type as the main factor and reports domain descriptively **[to be decided by the team]**.

## 2. List of pairs

Columns. **Dom.** domain code. **Sp.** verdict space template. **M1 / M2** the two committed messages, known to the experimenter only.

### 2.1 ECDSA (`ECD`)

| Code | Dom. | Sp. | Situation | M1 / M2 |
|---|---|---|---|---|
| ECD-C01 | 1 | A | Commercial lease signed electronically, the tenant disputes the rent review clause (**written in full, §3.1**) | version A (3 % review) / version B (8 % review) |
| ECD-C02 | 1 | A | Amendment to a supply contract, effective date disputed | effective 1 March / effective 1 June |
| ECD-C03 | 1 | A | Acknowledgement of debt signed from a mobile application | amount 2 M FCFA / amount 5 M FCFA |
| ECD-C04 | 1 | A | Purchase order signed by the authorising officer of a public body | quantity 200 / quantity 2,000 |
| ECD-C05 | 1 | A | Power of representation signed remotely | special power / general power |
| ECD-C06 | 3 | C | Transfer order signed by a bank customer, alleged fraud | usual beneficiary / new beneficiary |
| ECD-C07 | 3 | C | Compliance certificate signed by a compliance officer | no reservation / reservation on one customer |
| ECD-C08 | 3 | C | Signed internal audit report, filed version disputed | unqualified opinion / qualified opinion |
| ECD-C09 | 2 | B | Polling station report signed by the presiding officer | 312 voters / 321 voters |
| ECD-C10 | 1 | A | Crypto-asset transfer order signed from a wallet | partial transfer / full transfer |

### 2.2 Helios (`HEL`)

| Code | Dom. | Sp. | Situation | M1 / M2 |
|---|---|---|---|---|
| HEL-C01 | 2 | B | Pilot election of the representatives of a professional order, one ballot disputed at the count (**written in full, §3.2**) | list 1 / list 2 |
| HEL-C02 | 2 | B | Election of staff delegates in a company | candidate A / candidate B |
| HEL-C03 | 2 | B | Election of the board of a chamber of commerce | list 1 / list 2 |
| HEL-C04 | 2 | B | Vote on a resolution at a shareholders' general meeting | for / against |
| HEL-C05 | 2 | B | Local pilot consultation | yes / no |
| HEL-C06 | 2 | B | Election to a university council | college A / college B |
| HEL-C07 | 2 | B | Ballot cast under a disputed proxy | list 1 / list 2 |
| HEL-C08 | 2 | B | Ballot timestamped after the announced close of the poll | for / against |
| HEL-C09 | 2 | B | Vote of the board of a cooperative | candidate A / candidate B |
| HEL-C10 | 2 | B | Election of the council of a co-ownership | list 1 / list 2 |

### 2.3 Groth16 (`G16`)

| Code | Dom. | Sp. | Situation | M1 / M2 |
|---|---|---|---|---|
| G16-C01 | 3 | C | Proof that a transaction stays below the AML/CFT reporting threshold without revealing its amount | 4.2 M FCFA / 4.9 M FCFA |
| G16-C02 | 3 | C | Solvency proof of a microfinance institution (assets ≥ liabilities) | 2 % margin / 15 % margin |
| G16-C03 | 3 | C | Proof of reserves of a crypto-asset platform | 101 % coverage / 140 % coverage |
| G16-C04 | 3 | C | Proof that a declared income lies in a tax bracket | bottom of bracket / top of bracket |
| G16-C05 | 2 | B | Proof of voter eligibility without revealing identity | registered at station 12 / at station 47 |
| G16-C06 | 1 | A | Proof that a contracting party is of legal age | 19 years / 43 years |
| G16-C07 | 3 | C | Proof that a prudential ratio is met | ratio 8.1 % / ratio 12.4 % |
| G16-C08 | 3 | C | Proof of non-membership of a sanctions list | long-standing customer / recent customer |
| G16-C09 | 1 | A | Proof of financial capacity of a bidder in a public tender | 1.1 times the threshold / 3 times the threshold |
| G16-C10 | 3 | C | Proof of correctness of a statistical aggregate sent to the regulator | aggregate of 40 entities / of 400 entities |

### 2.4 RSA-PSS (`PSS`)

| Code | Dom. | Sp. | Situation | M1 / M2 |
|---|---|---|---|---|
| PSS-C01 | 1 | A | Employment contract signed with a qualified certificate, non-compete clause disputed | without clause / with clause |
| PSS-C02 | 1 | A | Deed of transfer of company shares | 30 % of shares / 51 % of shares |
| PSS-C03 | 1 | A | Signed electronic invoice, amount disputed | 1.8 M FCFA / 8.1 M FCFA |
| PSS-C04 | 3 | C | Periodic regulatory return sent to the regulator | original return / corrective return |
| PSS-C05 | 3 | C | Account statement signed by the bank, produced as evidence | credit balance / debit balance |
| PSS-C06 | 1 | A | Signed bid in a public tender | base bid / bid with variant |
| PSS-C07 | 4 | A | Individual administrative decision signed by an authority | authorisation / refusal |
| PSS-C08 | 3 | C | Certified financial statements signed by a statutory auditor | clean certification / certification with observation |
| PSS-C09 | 1 | A | Signed bank power of attorney | limited power / general power |
| PSS-C10 | 4 | A | Digital civil status record signed by a registrar | original record / corrected record |

### 2.5 Classical ElGamal (`EGC`)

| Code | Dom. | Sp. | Situation | M1 / M2 |
|---|---|---|---|---|
| EGC-C01 | 1 | A | Sealed price offer in a call for tenders | 96 M FCFA / 104 M FCFA |
| EGC-C02 | 1 | A | Sealed bid for the sale of an asset | 12 M FCFA / 15 M FCFA |
| EGC-C03 | 2 | B | Encrypted ballot without validity proof in an association election | candidate A / candidate B |
| EGC-C04 | 2 | B | Secret vote of a selection panel | admitted / deferred |
| EGC-C05 | 3 | C | Encrypted asset declaration filed with a supervisory authority | stable assets / 40 % increase |
| EGC-C06 | 3 | C | Encrypted amount of a transaction reported by an institution | 9 M FCFA / 90 M FCFA |
| EGC-C07 | 1 | A | Encrypted price clause of a framework contract | fixed price / revisable price |
| EGC-C08 | 2 | B | Encrypted vote of a trade union meeting | strike / no strike |
| EGC-C09 | 3 | C | Encrypted declaration of the beneficial owner of a company | resident owner / non-resident owner |
| EGC-C10 | 4 | A | Encrypted item placed in escrow by court order | complete item / partial item |

## 3. Pairs written in full

The values were produced by [generer_exemples.py](generer_exemples.py), which recomputes them bit for bit from public labels. The full values are in [exemples_stimuli.json](exemples_stimuli.json). The script verifies every signature and every proof. The ECDSA signatures are also verified with the `cryptography` package.

```sh
python3 generer_exemples.py --check   # regenerates and compares with the committed file
```

Deriving randomness from public labels is acceptable for stimulus material only. A real signer must never draw its randomness this way.

### 3.1 ECD-C01, commercial lease

**Internal part (stimulus sheet, parts 1 to 4).**

| Field | Value |
|---|---|
| Type, domain, template | ECD, 1 contract, A |
| Rotation block | C01–C02 |
| M1 | Version A of the lease, annual rent review of 3 % |
| M2 | Version B of the lease, annual rent review of 8 % |
| Public key (P-256, compressed) | `021a26a752f445f9…c8024d59f80cef31` |

| Variant | Message | Signed SHA-256 digest | Signature $r\Vert s$ (64 bytes, shortened) |
|---|---|---|---|
| ECD-C01-S1 | M1 | `762129ae8337ec2c…5cf294973b9b066a` | `b233296db8a50f5c…8a092129c759739b` |
| ECD-C01-S2 | M1 | `762129ae8337ec2c…5cf294973b9b066a` | `01b44f2ecd89a24e…15a5405844cdd282` |
| ECD-C01-S3 | M2 | `0aa3d6973e53eb14…d139efce4b542838` | `fe8c70a679a764bb…493a01257d0492d6` |
| ECD-C01-S4 | M2 | `0aa3d6973e53eb14…d139efce4b542838` | `b065d819d8d316f3…4a41d82fcfac9a3a` |

Both messages are compatible with the file. The file does not reproduce the signed text, only its digest, and each party produces a different printed version. Neither printed version is linked to the digest in the file.

**File handed to the participant (part 5), version S1.**

> **Situation.** SARL FICTIVE (the tenant) has occupied for two years commercial premises owned by SCI FICTIVE (the landlord). The lease was concluded remotely. The tenant's manager signed it with an electronic signature application supplied by the landlord. Since January the landlord has applied an annual rent review of 8 %. The tenant maintains that it signed a version providing for a 3 % review and produces a printed copy to that effect. The landlord produces a printed copy stating 8 %. Neither printed copy bears a handwritten signature. The landlord submits the technical extract below, taken from the signature application. The tenant does not dispute having used the application on the stated date.
>
> **Cryptographic item.**
>
> | Element | Content |
> |---|---|
> | Nature | ECDSA electronic signature, curve P-256, SHA-256 hash |
> | Signer's public key | `021a26a752f445f9…c8024d59f80cef31`, linked to the tenant's manager by the application |
> | Digest of the signed document | `762129ae8337ec2c…5cf294973b9b066a` |
> | Signature (64 bytes) | `b233296db8a50f5c…8a092129c759739b` |
> | Verification result | Verification successful with the stated public key |
> | Timestamp | 14 March, 10:42, declared by the landlord's application |
>
> **Question.** On the basis of this file, what decision would you give on whether the review clause applied by the landlord is enforceable against the tenant?

Verdicts proposed in Q01 (template A). 1 the clause is established and enforceable against the tenant. 2 the clause is established but its enforceability requires further evidence. 3 the clause is not established. 4 the item is set aside as irregular or suspicious.

Variants S2, S3 and S4 differ from S1 only in the “Digest” and “Signature” rows.

### 3.2 HEL-C01, disputed ballot

**Internal part (stimulus sheet, parts 1 to 4).**

| Field | Value |
|---|---|
| Type, domain, template | HEL, 2 election, B |
| Rotation block | C01–C02 |
| M1 | Choice of list 1, encrypted vector $(1, 0)$ |
| M2 | Choice of list 2, encrypted vector $(0, 1)$ |
| Group | 2048-bit MODP, RFC 3526 group 14, $g = 2$ |
| Election public key | `1ae02c3ee997a986…c3be34dfea8ced10` |
| Attached proofs | one disjunctive “0 or 1” proof per ciphertext and one “sum equals 1” proof |

| Variant | Message | Ballot fingerprint (SHA-256) | First ciphertext, component $\alpha$ (shortened) |
|---|---|---|---|
| HEL-C01-S1 | M1 | `79f2c21343aef9a7…cb9a65fbe9fc2aed` | `2c99e85399b9fa96…7b3c14e96345000c` |
| HEL-C01-S2 | M1 | `31cca81374aac1cd…7db60c15ff257fe6` | `2d36ecfef5332147…6feef0a54fb17e40` |
| HEL-C01-S3 | M2 | `0378e343a5fad53e…68a0596ab1800bdc` | `3fc38671671fbf7f…2c1aec99b7723b06` |
| HEL-C01-S4 | M2 | `d74634a8b3ab9fe1…c20f44e092464c20` | `ab4acdfcd6172cfd…6723efd1d3e4f613` |

Both messages are compatible with the file. The ciphertexts are semantically secure under the DDH assumption and the proofs reveal nothing about the choice. Only the homomorphic tally, after joint decryption, gives information on the sum of the choices.

**File handed to the participant (part 5), version S1.**

> **Situation.** A fictitious professional order elects its representatives through a pilot Helios-type electronic ballot. Two lists are standing. After the close, list 2 disputes a ballot cast from the workstation of a member who states that he did not vote. The election committee has the ballot published on the public bulletin board of the election and its fingerprint. The member acknowledges having received his voting credentials but states that he gave them to a colleague for a technical check. The final result depends on this ballot, since the lists are separated by one vote.
>
> **Cryptographic item.**
>
> | Element | Content |
> |---|---|
> | Nature | Encrypted ballot (exponential ElGamal, 2048-bit group) with zero-knowledge validity proofs |
> | Election public key | `1ae02c3ee997a986…c3be34dfea8ced10` |
> | Ballot fingerprint | `79f2c21343aef9a7…cb9a65fbe9fc2aed` |
> | Ciphertexts | two pairs $(\alpha, \beta)$ of 2048 bits each, one per list |
> | Verification result | The three validity proofs are accepted. The ballot contains exactly one choice. |
> | Timestamp | cast 2 h 15 min before the close, according to the bulletin board |
>
> **Question.** What decision would you give on this ballot?

Verdicts proposed in Q01 (template B). 1 the ballot is included in the count. 2 the ballot is included subject to a check. 3 the ballot is set aside. 4 the ballot is challenged for presumed fraud and referred.

This stimulus illustrates prediction 4 of the protocol ($\hat\Delta_{\text{ECDSA}} > \hat\Delta_{\text{Helios}}$). By construction, the Helios item carries no information on the choice, whereas the ECDSA item is bound to the signed content by its digest.

## 4. Checks before data collection

☐ The remaining 48 sheets written following the template
☐ Legal and cryptographic review of each sheet
☐ Values of the 200 variants produced and verified by a versioned script
☐ Gold standard established on the 50 pairs ([grid](../grille_gold_standard_en.md))
☐ Pre-test of the file and of the questionnaire outside the sample

Licence CC BY 4.0 for the texts, MIT for the script.
