# Agreement template with the electoral body (P3)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.3 (target system and procedure) and §4.2.8.3 (prior institutional agreement)

[Version française](modele_convention_scrutin_fr.md) · [P3 protocol](protocole_en.md) · [General institutional agreement](../00_commun/convention_institution_partenaire_en.md)

This template supplements the general institutional agreement. It covers the points specific to a real election. It must be reviewed by the electoral body, by the ENSP management and by the ethics committee **[to be decided by the team]**. The signed version is in French. This English version is a working translation.

---

**Between**

The electoral body in charge of the election of ENSP student delegates, represented by ______________________, hereinafter “the electoral body”,

**and**

The LIMSI research team (ENSP, University of Yaoundé I), represented by ______________________, hereinafter “the research team”.

## Article 1. Purpose

This agreement organises the audit, for research purposes, of the cryptographic proofs produced during the election of ENSP student delegates of ___ / ___ / ______ conducted with the Helios system. The audit aims to measure the empirical opposability of these proofs (thesis, §4.2.3).

## Article 2. Separation of roles

1. The electoral body organises the election, chooses and configures the Helios instance, appoints the key holders and announces the results according to its own rules.
2. The research team takes no part in organising the election, in the count or in the announcement. It receives no decryption key share.
3. The research audit starts after the announcement of the results. Its verdicts are research data. They constitute neither a complaint, nor an appeal, nor an opinion on the regularity of the election.

## Article 3. Data provided to the research team

| Data | Provided | Remark |
|---|---|---|
| Public bulletin board (encrypted ballots, proofs, fingerprints) | yes | data already public in Helios |
| Published fingerprint of the bulletin board at close | yes | used for the sampling seed |
| Announced results | yes | public |
| Electoral roll, identity or alias of voters | **no** | |
| Key shares, individually decrypted choices | **no** | |
| Server technical logs | ☐ yes ☐ no | **[to be decided]**, without IP address or voter identifier |

Where the bulletin board associates a voter alias with a ballot, the electoral body replaces the alias with a sequence number before transmission, or the team deletes it on receipt **[to be decided]**.

## Article 4. Control proofs

The electoral body is informed that the team adds 10 control proofs to the audited sample, altered copies of public ballots of the same election ([procedure](preuves_temoins_en.md)). These copies exist only in the research audit set. They are never cast on the Helios instance nor passed on to anyone as ballots.

## Article 5. Sampling

The draw of the 50 proofs is public. It takes place in the presence of at least one representative of the electoral body, according to the [sampling procedure](tirage_echantillon_en.md). The procedure and the seed rule are communicated to the electoral body before the election.

## Article 6. Real anomaly found

If a trustee finds, on a proof drawn from the bulletin board and not on a control proof, an anomaly they consider real, the research team informs the electoral body in writing within ____ working days. The notice identifies the proof concerned and the technical finding, without any assessment of the regularity of the election. Any follow-up is for the electoral body alone.

## Article 7. Trustees

The trustees who take part in the research audit give individual consent. They may withdraw at any time without consequence ([information sheet](../00_commun/notice_information_consentement_en.md)). Their participation or withdrawal has no bearing on any role they hold in the election.

## Article 8. Publication

Results are published in aggregate form. They do not allow identification of any voter, trustee or ballot other than by its public fingerprint. The electoral body receives the draft publication ____ days before submission and may point out any factual error. It has no veto over the scientific conclusions.

## Article 9. Duration

The agreement takes effect on signature and ends on publication of the results, at the latest ____ months after the election.

Done at Yaoundé, on ___ / ___ / ______, in two copies.

| For the electoral body | For the research team |
|---|---|
| Name, position, signature | Name, position, signature |
| | |

Licence CC BY 4.0.
