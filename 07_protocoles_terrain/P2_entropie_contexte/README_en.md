# Measuring contextual entropy $H(\mathcal{C})$

> **Status: PROPOSAL. protocol not deployed** · Source: thesis, Chapter 4, §4.2.2

[Version française](README_fr.md) · [Back to the field protocols](../README_en.md)

This folder gathers protocol P2 and its instruments. P2 estimates $H(\mathcal{C})$ at the level of the institutional domain through three independent approaches. No data have been collected. Elements that do not appear in the thesis are marked **[to be decided by the team]**.

## Contents

| Document | Role | Approach |
|---|---|---|
| [protocole_en.md](protocole_en.md) | Aim, scales of $H(\mathcal{C})$, hypotheses H2.1 to H2.3, design, timetable, caveats | all |
| [grille_decomposition_structurelle_en.md](grille_decomposition_structurelle_en.md) | Grid of elements per component L, T, R for the three domains | 1 |
| [corpus_contextes_en.md](corpus_contextes_en.md) and [corpus_contextes.csv](corpus_contextes.csv) | The 100 contexts (34 ELEC, 33 FIN, 33 CONT) with the levels of the grid elements | 2 |
| [generer_corpus.py](generer_corpus.py) | Reproducible generation of the corpus (fixed seed, `--check` option) | 2 |
| [protocole_dissimilarite_mds_en.md](protocole_dissimilarite_mds_en.md) | Administration of pairwise judgements, 0 to 10 scale, fallback booklet, quality checks | 2 |
| [delphi_questionnaire_tour1_en.md](delphi_questionnaire_tour1_en.md) | Individual round 1 questionnaire | 3 |
| [delphi_retour_tours_2_4_en.md](delphi_retour_tours_2_4_en.md) | Rule of conduct between rounds and revision form | 3 |
| [delphi_synthese_en.md](delphi_synthese_en.md) | Final report and comparison of the three approaches | all |
| [gabarit_decomposition_en.csv](gabarit_decomposition_en.csv) | Grid data entry, one row per element (dataset D6a) | 1 |
| [gabarit_dissimilarite_en.csv](gabarit_dissimilarite_en.csv) | Judgement data entry, one row per pair presented (dataset D6b) | 2 |
| [gabarit_delphi_en.csv](gabarit_delphi_en.csv) | Round data entry, one row per expert, round and domain (dataset D6c) | 3 |

The shared documents (consent, confidentiality undertaking, recruitment form, session log, deviation form, pre-registration, analysis plan, variable dictionary) are in [00_commun](../00_commun/README_en.md). The information sheet mentions one context-comparison session. The present proposal has three, one per domain. The information sheet must be updated accordingly before submission to the ethics committee.

## Analysis

The templates are read by the [cro_terrain](../analyse/README_en.md) package (schemas `p2_decomposition`, `p2_dissimilarity`, `p2_delphi`). The module `cro_terrain.p2` computes the three estimates.

```python
from cro_terrain.templates import read_template
from cro_terrain import p2

dec = read_template("gabarit_decomposition_en.csv", "p2_decomposition")
tot = p2.decomposition_totals(dec["expert_id"], dec["domain"], dec["component"], dec["entropy_bits"])
print(p2.summarize_by_domain(tot))

dis = read_template("gabarit_dissimilarite_en.csv", "p2_dissimilarity")
ids, D, n = p2.dissimilarity_matrix(dis["ctx_i"], dis["ctx_j"], dis["dissimilarity"])
k = p2.choose_dimensions(D, stress_max=0.15)        # threshold to register before collection
print(p2.mds_entropy(D, k, unit=1.0))               # unit to register before collection
```

For the MDS, the matrix is built domain by domain, by filtering rows on the `domain` column.

## What this folder does not contain

- A pre-test of the instruments.
- The electronic form for the dissimilarity judgements, of which only the specification is given.
- Any field data.

## Licence

CC BY 4.0 for the documents and the corpus, MIT for `generer_corpus.py`.
