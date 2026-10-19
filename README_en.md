# PhDThesis — Foundations of Institutional Cryptography

*Version française : [README_fr.md](README_fr.md)*

This repository gathers all the work of the doctoral thesis of Thierry Emmanuel MINKA MI NGUIDJOÏ, prepared at LIMSI (National Advanced School of Engineering, University of Yaoundé I) under the supervision of Prof. Thomas DJOTIO NDIÉ and Dr Flavien Serge MANI ONANA. Each item is presented for what it is. The register [STATUS_en.md](STATUS_en.md) lists them all.

## Statuses

| Status | Meaning |
|---|---|
| **PUBLISHED** | Peer-reviewed and published article (IEEE Access 2026) |
| **PREPRINT** | IACR ePrint deposit, not peer reviewed |
| **PROPOSAL** | Everything else, refined by a sub-label (submitted refined statements, thesis result, construction, formalisation, conjecture, illustrative calibration, protocol not deployed, reference implementation) |

## Layout

| Folder | Contents | Status |
|---|---|---|
| [00_these/](00_these/README_en.md) | LaTeX manuscript (final version), submitted PDF | PROPOSAL |
| [01_publie/](01_publie/README_en.md) | Articles P1 (CLO), P2 (CRO Trilemma), P3 (post-quantum extension) and submitted refined statements | PUBLISHED (refined statements: PROPOSAL) |
| [02_preprints/](02_preprints/README_en.md) | Records of the nine IACR ePrint preprints | PREPRINT |
| [03_resultats_these/](03_resultats_these/README_en.md) | What the thesis adds to or refines in the articles | PROPOSAL |
| [04_sotp/](04_sotp/README_en.md) | SOTP family, specification, game-based proofs, reference implementations (Low, Base, executable High in Circom/Groth16) | PROPOSAL |
| [05_formalisation_lean/](05_formalisation_lean/README_en.md) | Lean 4 formalisation of the conditional Trilemma (v2.2) | PROPOSAL |
| [06_calcul/](06_calcul/README_en.md) | Scripts, data and results of the illustrative calibration | PROPOSAL |
| [07_protocoles_terrain/](07_protocoles_terrain/README_en.md) | Measurement protocols, field forms and analysis scripts | PROPOSAL |
| [docs/](docs/README_en.md) | Thesis-to-repository correspondence, history, publication procedure | PROPOSAL |

## Reproducing

- Lean 4: `cd 05_formalisation_lean && lake exe cache get && lake build`
- Calculations: `cd 06_calcul && python3 -m pytest -q tests`
- SOTP-Low and SOTP-Base: `cd 04_sotp/reference_low_base && python3 -m pytest -q tests`
- SOTP-High: `cd 04_sotp/high && bash scripts/run_all.sh` (Node 18 or later)
- Field analysis: `cd 07_protocoles_terrain/analyse && python3 -m pytest -q tests`

## Licences

Code is MIT-licensed ([LICENSE](LICENSE)). Texts, forms and data are CC BY 4.0 ([LICENSE-CC-BY-4.0](LICENSE-CC-BY-4.0)). Published articles keep the publisher's CC BY 4.0 licence.

## Citing

See [CITATION.cff](CITATION.cff).
