# Structural decomposition grid (P2, approach 1)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.2.2 (equation `eq:decomposition_HC`); glossary of notation, $H(C) = H(L) + H(T\mid L) + H(R\mid L,T)$

[Version française](grille_decomposition_structurelle_fr.md) · [P2 protocol](protocole_en.md)

One grid per expert. It takes about 45 to 60 min to complete, alone and without imposed documentation **[duration to be confirmed at pre-test]**. The form carries no name. The grid is administered in French. This English version is a working translation.

| Field | Value |
|---|---|
| Expert code | `P2-EX-__` |
| Profile | ☐ law and litigation ☐ regulation and audit ☐ applied cryptography |
| Date | ___ / ___ / ______ |

## Instructions

For each of the three domains, you are given a list of **elements** that distinguish one context from another. Each element is attached to a component.

- **L, legal component.** What relates to rules and statuses (type of act, applicable law, capacity of the parties).
- **T, temporal component.** What relates to dates, time limits and history.
- **R, procedural component.** What relates to forms, bodies and procedural routes.

For each element, give the **number of categories** your institution distinguishes in practice, i.e. the number of cases that would lead it to handle a file differently. For example, if a court distinguishes three evidence regimes for a contract, the element “evidence regime” has 3 categories.

- Write 1 if the element never changes how a file is handled.
- If some categories are much more frequent than others, you may give their approximate frequencies in the “Frequencies” column. The entropy is then computed from these frequencies.
- Do not count the same distinction twice. If two elements overlap, strike one out and say so under “Remarks”.
- Add at the end of the table any missing elements you consider important.

No reference value is given. The “Entropy (bits)” column is computed by the team and you do not fill it in.

## Domain CONT, contract signature

Elements derived from equation `eq:decomposition_HC` of the thesis (parties, clauses, jurisdiction, history) supplemented by procedural elements.

| No. | Component | Element | Example categories | No. of categories | Frequencies (optional) | Entropy (bits) | Remarks |
|---|---|---|---|---|---|---|---|
| C1 | L | Legal capacity of the parties (*parties*) | individual, trader, company, public body | ____ | | | |
| C2 | L | Type of contract | lease, sale, services, loan, employment | ____ | | | |
| C3 | L | Decisive clauses in dispute (*clauses*) | price, duration, termination, exclusivity | ____ | | | |
| C4 | L | Applicable law and jurisdiction (*jurisdiction*) | national law, OHADA, foreign law, arbitration | ____ | | | |
| C5 | T | History of the relationship (*history*) | first relationship, ongoing relationship, prior dispute | ____ | | | |
| C6 | T | Stage of performance | not started, in progress, completed, terminated | ____ | | | |
| C7 | T | Time since conclusion | less than a year, 1 to 5 years, more than 5 years | ____ | | | |
| C8 | R | Form of conclusion | paper, simple electronic, qualified electronic | ____ | | | |
| C9 | R | Type of evidence produced | original, copy, technical extract, testimony | ____ | | | |
| C10 | R | Procedural route | amicable, summary proceedings, merits, arbitration | ____ | | | |
| C11 | | | | ____ | | | |
| C12 | | | | ____ | | | |

## Domain ELEC, electoral disputes

The thesis cites the register, the rules and the history as dominant components.

| No. | Component | Element | Example categories | No. of categories | Frequencies (optional) | Entropy (bits) | Remarks |
|---|---|---|---|---|---|---|---|
| E1 | L | Type of election | presidential, parliamentary, local, professional, association | ____ | | | |
| E2 | L | Applicable rules | electoral code, statutes, internal rules | ____ | | | |
| E3 | L | Voter's status in the register (*register*) | registered, struck off, registered elsewhere, proxy | ____ | | | |
| E4 | L | Subject of the challenge | eligibility, regularity of the vote, count, announcement | ____ | | | |
| E5 | T | Stage of the process | registration, campaign, vote, count, announcement | ____ | | | |
| E6 | T | Litigation history (*history*) | none, prior dispute, prior annulment | ____ | | | |
| E7 | T | Compliance with time limits | within time, out of time, disputed date | ____ | | | |
| E8 | R | Body seised | electoral commission, administrative court, constitutional court | ____ | | | |
| E9 | R | Voting method | paper ballot, electronic on site, remote electronic | ____ | | | |
| E10 | R | Type of appeal | complaint, action for annulment, action for amendment | ____ | | | |
| E11 | | | | ____ | | | |
| E12 | | | | ____ | | | |

## Domain FIN, financial compliance

The thesis cites transactions, regulations and audit as dominant components.

| No. | Component | Element | Example categories | No. of categories | Frequencies (optional) | Entropy (bits) | Remarks |
|---|---|---|---|---|---|---|---|
| F1 | L | Applicable regulation (*regulations*) | prudential, AML/CFT, tax, accounting | ____ | | | |
| F2 | L | Status of the audited entity | bank, microfinance, insurance, state-owned company | ____ | | | |
| F3 | L | Type of transaction (*transactions*) | transfer, credit, foreign exchange, crypto-asset | ____ | | | |
| F4 | L | Customer risk level | low, standard, high, politically exposed person | ____ | | | |
| F5 | T | Period under review | current year, closed year, several years | ____ | | | |
| F6 | T | Entity's record | none, observations, prior sanctions | ____ | | | |
| F7 | T | Frequency of transactions | one-off, repeated, continuous | ____ | | | |
| F8 | R | Type of control (*audit*) | desk review, on-site, external audit, investigation | ____ | | | |
| F9 | R | Control framework | national standards, international standards, internal framework | ____ | | | |
| F10 | R | Possible procedural outcome | closure, injunction, sanction, referral to the prosecutor | ____ | | | |
| F11 | | | | ____ | | | |
| F12 | | | | ____ | | | |

## Closing question

For each domain, the sum of the entropies assumes independent elements. In your view, which elements are most closely linked?

- CONT: ______________________________________________
- ELEC: ______________________________________________
- FIN: ______________________________________________

## Computation (filled in by the team)

For an element with $k$ equiprobable categories, the entropy is $\log_2 k$ bits. If the expert gives frequencies $p_1, \dots, p_k$, it is $-\sum_i p_i \log_2 p_i$ bits. The sum per component gives $H(L)$, $H(T)$ and $H(R)$. Their total is the expert's estimate for the domain. The computation is done by `cro_terrain.p2.element_entropy` and `cro_terrain.p2.decomposition_totals`.

| Domain | $H(L)$ | $H(T)$ | $H(R)$ | Total (bits) |
|---|---|---|---|---|
| CONT | | | | |
| ELEC | | | | |
| FIN | | | | |

Data entry in [gabarit_decomposition_en.csv](gabarit_decomposition_en.csv), one row per element. The `element` column receives the number (C1, E4, F10, etc.) or, for an added element, its label.

Licence CC BY 4.0.
