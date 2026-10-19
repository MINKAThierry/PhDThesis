# Publication procedure for the repository

> **Status: PROPOSAL — repository documentation** · Source: author's decisions (repository private until the defence), [`../CITATION.cff`](../CITATION.cff), [`../.zenodo.json`](../.zenodo.json), discrepancies listed in the [correspondence](correspondance_these_depot_en.md)

[Version française](procedure_publication_fr.md) · [Back to docs](README_en.md)

The repository `MINKAThierry/PhDThesis` remains **private until the defence**. This document sets the order of the operations that make it public, archive it on Zenodo and carry the DOI into the thesis. Each step is ticked in the checklist of section 8.

## 1. Before the defence

1. Add by hand to `.github/workflows/ci.yml`, job `python`, any of the following lines that are not there yet. This file could not be modified remotely.

   ```yaml
   - run: pip install cryptography && cd 07_protocoles_terrain/P1_delta/stimuli && python generer_exemples.py --check
   - run: cd 07_protocoles_terrain/P3_opp_helios/formation && python generer_bulletins_exercice.py --check
   - run: pip install dilithium-py==1.4.0 slh-dsa==0.2.5 && cd 07_protocoles_terrain/P5_delta_q/stimuli && python generer_signatures_pqc.py --check
   ```

2. Push and check that the three jobs (`python`, `sotp-high`, `lean`) pass.
3. Check that no file refers to the former companion repository (command in section 8).

## 2. After the defence, status updates

| File | Change |
|---|---|
| [`../STATUS_fr.md`](../STATUS_fr.md), [`../STATUS_en.md`](../STATUS_en.md) | row “Thesis manuscript” changed to “thesis defended on __/__/____” |
| [`../00_these/README_en.md`](../00_these/README_en.md) and French version | same mention in the header and in the Reference section |
| [`../03_resultats_these/resultats_these_en.md`](../03_resultats_these/resultats_these_en.md) | sentence “Until the thesis is defended…” to revise |

The register knows only three statuses (PUBLISHED, PREPRINT, PROPOSAL). Author's decision (13 October 2026) for the thesis results after the defence. They keep the status PROPOSAL with the sub-label “result of the defended thesis”. The other sub-labels (construction, conjecture, formalisation, illustrative calibration, undeployed protocol, reference implementation) remain unchanged. The repository may keep evolving until then.

If submitted refined statements have been published in the meantime, their row moves from “PROPOSAL (submitted refined statements)” to PUBLISHED with their DOI, in the register and in the relevant [`formulations_precisees/`](../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/README_en.md) record. The same applies to SOTP (*IEEE TIT*) and to the Lean formalisation (*JAR*) if accepted.

## 3. Choosing how to obtain the DOI

Version 1.0.0 must contain the final thesis. The final thesis must cite the DOI of version 1.0.0. Two routes avoid this circularity.

| Route | Sequence | Advantage | Drawback |
|---|---|---|---|
| **A. Reserved DOI (recommended)** | Create a Zenodo record by hand, tick the DOI reservation, carry this DOI into the thesis, then upload the archive of tag `v1.0.0` and publish the record | the final thesis and version 1.0.0 carry the same DOI | archive uploaded by hand; later versions are not created automatically |
| B. Zenodo GitHub integration | Make the repository public, enable it in Zenodo, publish release `v1.0.0`. Zenodo assigns the DOI. Carry it over afterwards in a release `v1.0.1` | every release is archived automatically | version 1.0.0 still contains the placeholder DOI; the thesis must cite `v1.0.1` or the concept DOI |

The Zenodo GitHub integration only works with a public repository. Route A can be prepared while the repository is still private. The choice is left to the author, who will handle it after the defence.

## 4. Final version of the thesis

1. Replace `10.5281/zenodo.XXXXXXX` with the DOI obtained in [`../00_these/manuscrit/chap4/validation_retrospective.tex`](../00_these/manuscrit/chap4/validation_retrospective.tex) (§4.4.12, `subsec:depot`, discrepancy E1).
2. In [`../00_these/manuscrit/annexes/bibliographie.bib`](../00_these/manuscrit/annexes/bibliographie.bib), entry `CROTrilemmaDepot`, add the `doi` field.
3. Recompile the manuscript (`make` in `00_these/manuscrit/`) and add the PDF of the final version to [`../00_these/pdf/`](../00_these/pdf/), under the name `MaThèse.pdf`.
4. Update [`../00_these/README_en.md`](../00_these/README_en.md) and its French version (section “Version of the sources”).

Discrepancies E3 to E12 are resolved in the final version of the sources (see the [correspondence](correspondance_these_depot_en.md)).

## 5. Repository metadata

| File | Change |
|---|---|
| [`../CITATION.cff`](../CITATION.cff) | `version: "1.0.0"`, `date-released` set to the publication date, `doi:` added |
| [`../.zenodo.json`](../.zenodo.json) | `"version": "1.0.0-pre"` changed to `"1.0.0"`; complete `creators` if the supervisors should appear. The dual licence is already stated. The `license` field (single value only) gives MIT for the code and the `notes` field describes the MIT / CC BY 4.0 split |
| [`../README_fr.md`](../README_fr.md), [`../README_en.md`](../README_en.md) | DOI added in the Cite section |
| [`historique_fr.md`](historique_fr.md), [`historique_en.md`](historique_en.md) | dated row for the publication |

### GitHub account

The repository is published under the `MINKAThierry` account, which carries the author's full identity. The address `https://github.com/MINKAThierry/PhDThesis` appears in `CITATION.cff`, in the manuscript sources (`chap3/cro_lean4.tex`, `chap4/validation_retrospective.tex`, `annexes/code_lean4.tex`, `annexes/bibliographie.bib`), in the records of `00_these/` and in the shared documents of `07_protocoles_terrain/00_commun/`. The seed of the P1 stimuli, in [`../07_protocoles_terrain/P1_delta/stimuli/generer_exemples.py`](../07_protocoles_terrain/P1_delta/stimuli/generer_exemples.py), is `MINKAThierry/PhDThesis/P1/stimuli/v1`. The stimuli and the catalogue were regenerated with this seed on 19 October 2026, since no data had been collected.

## 6. Tag and publication

1. Merge all changes from sections 2 to 5 and check that continuous integration passes.
2. Set the annotated tag `v1.0.0` (`git tag -a v1.0.0 -m "Version 1.0.0"`, then `git push origin v1.0.0`).
3. Route A. Upload the archive of the tag (`git archive --format=zip v1.0.0`) to the reserved record, then publish the record.
4. Make the repository public in its GitHub settings.
5. Route B only. Enable the repository in Zenodo, publish release `v1.0.0`, then apply sections 4 and 5 with the DOI received, in a release `v1.0.1`.

## 7. After publication

- Check that the DOI resolves to the record and that the archive does contain the final thesis.
- Check that relative links render correctly on GitHub.
- Notify the journals handling pending submissions of the address and the DOI, if their policy requires it.

## 8. Checklist

| ☐ | Check | Command or method |
|---|---|---|
| ☐ | No reference to the former companion repository | search for its former GitHub address in all tracked files (`git grep -i "<former address>"`) |
| ☐ | Calculation, 17 tests | `cd 06_calcul && python3 -m pytest -q tests` |
| ☐ | SOTP-Low and SOTP-Base, 50 tests | `cd 04_sotp/reference_low_base && python3 -m pytest -q tests` |
| ☐ | SOTP-High, 15 checks | `cd 04_sotp/high && bash scripts/run_all.sh` |
| ☐ | Field analysis, 111 tests | `cd 07_protocoles_terrain/analyse && python3 -m pytest -q tests` |
| ☐ | Lean, compilation without `sorry`, ten standard `#print axioms` | `cd 05_formalisation_lean && lake exe cache get && lake build` |
| ☐ | Reproducible stimulus generators | the three `--check` commands of section 1 |
| ☐ | Hashes of the reference outputs | `sha256sum -c SHA256SUMS` in `06_calcul/results/` and `05_formalisation_lean/results/` |
| ☐ | Unversioned files absent (`node_modules/`, `04_sotp/high/build/`, `.lake/`, `__pycache__/`) | `git status --ignored` |
| ☐ | Every `_fr` file has its `_en` counterpart | inspection of the tree |
| ☐ | Valid relative links | Markdown link checker |
| ☐ | No personal data and no secrets | review of `07_protocoles_terrain/` (empty templates) and key search |
| ☐ | Same DOI in the thesis, `CITATION.cff`, the READMEs and Zenodo | manual comparison |

## Licence

CC BY 4.0.
