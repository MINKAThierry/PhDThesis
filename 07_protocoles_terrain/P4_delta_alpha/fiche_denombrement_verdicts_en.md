# Form for counting the verdict space $\mathcal{V}$ (P4, step 5)

> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.4, step 5 ($\hat\alpha \leftarrow \log_2|\mathcal{V}|/H(C)$); derivations of §4.3 ($|\mathcal{V}| = 4$ for Helios, 8 for the financial regulator)

[Version française](fiche_denombrement_verdicts_fr.md) · [P4 protocol](protocole_en.md) · [Template](gabarit_denombrement_verdicts_en.csv)

## 1. Why count

$\hat\alpha$ depends on $|\mathcal{V}|$, the number of distinct decisions the institution can give in the context studied. The derivations of the thesis set this value from documented practice (four decisions for an electoral dispute, eight for a financial regulator). P4 proposes to establish it from the texts, before data collection, so that it does not depend on the observed verdicts.

## 2. Procedure

1. Two independent people fill in the form, one a lawyer (`D-A`), the other a member of the institution (`D-B`).
2. Each lists all decisions provided for by the texts applicable to context $C$, with their legal basis.
3. For each decision, each states whether it is **retained** as a distinct verdict. A decision is retained if its legal effects differ from those of the others. Two wordings with the same effects count as one.
4. The two lists are compared. Disagreements are settled by the coordinator after discussion, and the rule applied is recorded.
5. $|\mathcal{V}|$ is the number of codes retained in the consolidated list (`cro_terrain.p4.verdict_space_size`).

## 3. Form (one per institution and per context)

| Field | Value |
|---|---|
| Institution | `INST-__` |
| Context $C$ | `______` |
| Author | ☐ `D-A` lawyer ☐ `D-B` member of the institution ☐ consolidated list |
| Texts consulted (references and versions) | ______________________ |

| Code | Decision (label) | Legal basis (text, article) | Retained as a distinct verdict | Reason if not retained |
|---|---|---|---|---|
| 1 | | | ☐ yes ☐ no | |
| 2 | | | ☐ yes ☐ no | |
| 3 | | | ☐ yes ☐ no | |
| 4 | | | ☐ yes ☐ no | |
| 5 | | | ☐ yes ☐ no | |
| 6 | | | ☐ yes ☐ no | |
| 7 | | | ☐ yes ☐ no | |
| 8 | | | ☐ yes ☐ no | |
| 9 | | | ☐ yes ☐ no | |
| 10 | | | ☐ yes ☐ no | |

$|\mathcal{V}| =$ ____ and $\log_2|\mathcal{V}| =$ ____ bits.

## 4. Example (electoral dispute, after the Helios derivation of the thesis)

Illustrative example taken from §4.3. It does not replace counting in the actual texts.

| Code | Decision | Basis | Retained |
|---|---|---|---|
| 1 | Validation of the election | to be completed from the applicable electoral code | yes |
| 2 | Annulment of the election | idem | yes |
| 3 | Recount ordered | idem | yes |
| 4 | Investigation requested | idem | yes |

$|\mathcal{V}| = 4$, hence $\log_2|\mathcal{V}| = 2$ bits (thesis, equation `eq:hvc_helios`).

## 5. Consistency with the questionnaire

If the questionnaire offers participants a number of decisions different from $|\mathcal{V}|$ (for example the four verdicts of the P1 questionnaire), the discrepancy is recorded here and in the report.

Discrepancy found ☐ no ☐ yes: ______________________

## 6. Data entry

One row per decision and per author in [gabarit_denombrement_verdicts_en.csv](gabarit_denombrement_verdicts_en.csv). The `retained_yes_no` column receives `yes` or `no` (`oui` or `non` in the French template). The `notes` column starts with the author's code (`D-A`, `D-B`) or with `consolidee` for the consolidated list. When `consolidee` rows exist, `verdict_space_size` counts only those.

Licence CC BY 4.0.
