# Thèse de Doctorat PhD: Aux Fondements de la Cryptographie Institutionnelle

*English version: [README_en.md](README_en.md)*

Ce dépôt réunit l'ensemble des travaux de la thèse de doctorat de Thierry Emmanuel MINKA MI NGUIDJOÏ, préparée au LIMSI (École Nationale Supérieure Polytechnique, Université de Yaoundé I) sous la direction du Pr Thomas DJOTIO NDIÉ et du Dr Flavien Serge MANI ONANA. Chaque élément est présenté pour ce qu'il est. Le registre [STATUS_fr.md](STATUS_fr.md) en donne la liste complète.

## Statuts

| Statut | Signification |
|---|---|
| **PUBLIÉ** | Article évalué par les pairs et publié (IEEE Access 2026) |
| **PRÉPRINT** | Dépôt IACR ePrint, non évalué par les pairs |
| **PROPOSITION** | Tout le reste, précisé par une sous-étiquette (formulations précisées soumises, résultat de thèse, construction, formalisation, conjecture, calibration illustrative, protocole non déployé, implémentation de référence) |

## Organisation

| Dossier | Contenu | Statut |
|---|---|---|
| [00_these/](00_these/README_fr.md) | Manuscrit LaTeX (version finale), PDF de dépôt | PROPOSITION |
| [01_publie/](01_publie/README_fr.md) | Articles P1 (CLO), P2 (Trilemme CRO), P3 (extension post-quantique) et formulations précisées soumises | PUBLIÉ (formulations précisées : PROPOSITION) |
| [02_preprints/](02_preprints/README_fr.md) | Fiches des neuf préprints IACR ePrint | PRÉPRINT |
| [03_resultats_these/](03_resultats_these/README_fr.md) | Ce que la thèse ajoute ou précise par rapport aux articles | PROPOSITION |
| [04_sotp/](04_sotp/README_fr.md) | Famille SOTP, spécification, preuves game-based, implémentations de référence (Low, Base, High exécutable Circom/Groth16) | PROPOSITION |
| [05_formalisation_lean/](05_formalisation_lean/README_fr.md) | Formalisation Lean 4 du Trilemme conditionnel (v2.2) | PROPOSITION |
| [06_calcul/](06_calcul/README_fr.md) | Scripts, données et résultats de la calibration illustrative | PROPOSITION |
| [07_protocoles_terrain/](07_protocoles_terrain/README_fr.md) | Protocoles de mesure, formulaires de terrain et scripts d'analyse | PROPOSITION |
| [docs/](docs/README_fr.md) | Correspondance entre la thèse et le dépôt, historique, procédure de publication | PROPOSITION |

## Reproduire

- Lean 4 : `cd 05_formalisation_lean && lake exe cache get && lake build`
- Calcul : `cd 06_calcul && python3 -m pytest -q tests`
- SOTP-Low et SOTP-Base : `cd 04_sotp/reference_low_base && python3 -m pytest -q tests`
- SOTP-High : `cd 04_sotp/high && bash scripts/run_all.sh` (Node 18 ou plus)
- Analyse de terrain : `cd 07_protocoles_terrain/analyse && python3 -m pytest -q tests`

## Licences

Le code est sous licence MIT ([LICENSE](LICENSE)). Les textes, formulaires et données sont sous licence CC BY 4.0 ([LICENSE-CC-BY-4.0](LICENSE-CC-BY-4.0)). Les articles publiés conservent la licence CC BY 4.0 de l'éditeur.

## Citer

Voir [CITATION.cff](CITATION.cff).
