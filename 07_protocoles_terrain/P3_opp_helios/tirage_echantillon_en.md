# Sampling procedure (P3)

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.3.3, phase 3 (“random sample of 50 proofs (10 %)”)

[Version française](tirage_echantillon_fr.md) · [P3 protocol](protocole_en.md)

The draw must be reproducible by anyone holding the public data and impossible for the research team to steer. The procedure relies on SHA-256 only. It can be redone with any standard tool.

## 1. Sampling rule

1. **List of identifiers.** The list of the $N$ ballots of the bulletin board at close, each designated by its public fingerprint (or by its sequence number if the electoral body assigns one), one per line. This list is published.
2. **Seed.** The seed is the concatenation, separated by `|`, of two public elements, following a rule fixed before the election.
   - The published fingerprint of the bulletin board at close, which nobody knows before the close.
   - Five two-digit numbers drawn publicly after the close, in the presence of a representative of the electoral body (urn, ten-sided dice) **[method to be decided]**.
3. **Rank key.** For each identifier $x$, compute $\mathrm{SHA\text{-}256}(\text{seed} \,|\, x)$ in hexadecimal.
4. **Sample.** The 50 identifiers with the smallest rank keys, in lexicographic order, form the sample. They are then mixed with the control proofs and presented to each trustee in an order of their own ([control-proof procedure](preuves_temoins_en.md)).

The function `cro_terrain.sampling.draw_sample` applies this rule.

```sh
python3 -m cro_terrain.sampling --seed "<fingerprint>|<drawn numbers>" --ids identifiers.txt --k 50
```

## 2. Manual check (example)

Example with a fictitious seed and 10 identifiers `B001` to `B010`, sample of 3.

Seed: `EXEMPLE-empreinte-tableau|31 07 19 88 42`

```sh
printf '%s' 'EXEMPLE-empreinte-tableau|31 07 19 88 42|B009' | sha256sum
# 24ac8b891d5d5f812aa37a2e03fc2e45a68a33fd88ad03be89e56ba36cc0dfa0
```

| Rank | Identifier | Rank key (SHA-256) |
|---|---|---|
| 1 | B009 | `24ac8b891d5d5f812aa37a2e03fc2e45a68a33fd88ad03be89e56ba36cc0dfa0` |
| 2 | B002 | `3e3698ff37b26928cf64d118e9998d8fdd5c110ecdd4b41892f22d25be38e3a1` |
| 3 | B010 | `4dde9d0f0a9e481b2292ce781c7c42f046282cc1fdc8fa321759d7e794000b99` |

The other seven identifiers have larger keys. The separator `|` is included between seed and identifier, with no space or newline.

## 3. Sampling report

| Field | Value |
|---|---|
| Date and place | ___ / ___ / ______ , __________ |
| Present (team, electoral body, trustees) | ______________________ |
| Number of ballots $N$ on the bulletin board | ______ |
| Fingerprint of the published identifier list | `________________` |
| Fingerprint of the bulletin board at close | `________________` |
| Numbers drawn | __ __ __ __ __ |
| Full seed | `________________________________` |
| Sample size | 50 (10 % of 500 according to the thesis, or ____ if $N$ differs markedly) **[rule to be decided]** |
| Tool used and version | ______________________ |
| Independent check with a second tool | ☐ matching ☐ not matching |

List of the 50 identifiers drawn, with their rank keys, attached to the report.

Signatures

| Research team | Electoral body | Witness trustee |
|---|---|---|
| | | |

## 4. Checkpoints

☐ Sampling rule and seed rule communicated to the electoral body before the election
☐ Identifier list published before the numbers are drawn
☐ Sample recomputed by a second person with another tool
☐ No change to the sample after the draw

Licence CC BY 4.0.
