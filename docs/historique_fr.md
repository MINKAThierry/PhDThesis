# Historique des travaux et du dépôt

> **Statut : PROPOSITION: documentation du dépôt** · Source : fiches de [`../01_publie/`](../01_publie/README_fr.md) et [`../02_preprints/`](../02_preprints/README_fr.md), en-tête de [`../05_formalisation_lean/ConditionalCRO.lean`](../05_formalisation_lean/ConditionalCRO.lean)

[English version](historique_en.md) · [Retour à docs](README_fr.md)

Ce document retrace l'ordre dans lequel les résultats ont été produits, publiés puis précisés. Il sert à situer une version donnée d'un énoncé. Les dates sont celles des documents conservés dans le dépôt. Lorsqu'une date n'y figure pas, seule l'année est indiquée.

## 1. Préprints (2025)

Neuf préprints ont été déposés sur l'archive IACR ePrint en 2025. Ils n'ont pas été évalués par les pairs.

| Période | Préprints | Rôle ultérieur |
|---|---|---|
| 2025 | [2025/1138](../02_preprints/2025-1138_ZK-NR/README_fr.md) ZK-NR, [2025/1422](../02_preprints/2025-1422_ZK-NR-Design/README_fr.md) ZK-NR Design, [2025/1529](../02_preprints/2025-1529_ZK-NR-UC/README_fr.md) ZK-NR UC | Axe II des perspectives (voie protocolaire) |
| 2025 | [2025/1348](../02_preprints/2025-1348_CRO-Trilemma/README_fr.md) CRO Trilemma | Première forme de la borne CRO, reprise et développée par l'article P2 |
| 2025 | [2025/1380](../02_preprints/2025-1380_Q2CSI/README_fr.md) Q2CSI | Axe II (méta-architecture) |
| 2025 | [2025/1590](../02_preprints/2025-1590_AIIP/README_fr.md) AIIP, [2025/1615](../02_preprints/2025-1615_CEE/README_fr.md) CEE, [2025/1662](../02_preprints/2025-1662_AOW/README_fr.md) AOW, [2025/1708](../02_preprints/2025-1708_SH/README_fr.md) SH | Axe I des perspectives (AIIP et CASH Toolkit) |

## 2. Articles publiés (2026)

| Article | Reçu | Accepté | Publié | Référence |
|---|---|---|---|---|
| [P1](../01_publie/P1_CLO_IEEEAccess2026/README_fr.md), cadre CLO | 4 décembre 2025 | 21 janvier 2026 | 2 février 2026 | *IEEE Access* 14, pp. 20427–20445, DOI 10.1109/ACCESS.2026.3660105 |
| [P2](../01_publie/P2_CRO_IEEEAccess2026/README_fr.md), Trilemme CRO conditionnel | 6 février 2026 | 22 février 2026 | 27 février 2026 | *IEEE Access* 14, pp. 33263–33274, DOI 10.1109/ACCESS.2026.3669065 |
| [P3](../01_publie/P3_PQCRO_IEEEAccess2026/README_fr.md), extension post-quantique | 19 juin 2026 | 2 août 2026 | 12 août 2026 | *IEEE Access* 14, pp. 125130–125155, DOI 10.1109/ACCESS.2026.3722742 |

## 3. Formalisation Lean 4

La formalisation du Trilemme CRO conditionnel classique a conduit à des formulations alternatives, plus précises, de plusieurs énoncés publiés de P2 et de P3 (thèse, §3.4.9). Ces formulations sont décrites à la section 4.

| Version | Contenu | Où la trouver |
|---|---|---|
| antérieures à 2.1 | versions de travail | non conservées dans ce dépôt |
| 2.1 | import complet de Mathlib ; mêmes énoncés que la version 2.2 hors section 9 | version de travail, non conservée dans ce dépôt |
| 2.2 (octobre 2026) | `import Mathlib` ; ajout de la section 9 (`opp_eq_one_of_deterministic`, `deterministic_forces_capacity`, `trilemma_refined`, `refined_bound_is_fano_when_delta_ge_gamma`) ; vérifiée sur <https://live.lean-lang.org> | [`../05_formalisation_lean/ConditionalCRO.lean`](../05_formalisation_lean/ConditionalCRO.lean), listing B.1 de la thèse |

Les énoncés de la version 2.1 sont repris à l'identique dans la version 2.2 (thèse, annexe B). Les versions de Lean et de Mathlib sont figées à v4.34.0. Un article qui présente la formalisation est soumis au *Journal of Automated Reasoning*.


## 4. Formulations précisées et versions de la thèse

| Date | Événement | Emplacement |
|---|---|---|
| 2026 | Formulations précisées soumises à *IEEE Access* pour P2 (preuve du trilemme classique) | [`../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/`](../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/README_fr.md) |
| 2026 | Formulations précisées soumises à *IEEE Access* pour P3, parallèles à celles de P2 | [`../01_publie/P3_PQCRO_IEEEAccess2026/formulations_precisees/`](../01_publie/P3_PQCRO_IEEEAccess2026/formulations_precisees/README_fr.md) |
| 28 septembre 2026 | Dépôt de la thèse (262 pages), après intégration des retours de l'expertise académique | [`../00_these/pdf/`](../00_these/pdf/README_fr.md) |
| octobre 2026 | Version finale du manuscrit (formalisation Lean 2.2 vérifiée en ligne, adresse du dépôt) | [`../00_these/manuscrit/`](../00_these/manuscrit/README_fr.md) |

Les formulations précisées soumises ne sont pas publiées à la date de construction du dépôt. Elles gardent le statut PROPOSITION (formulations précisées soumises). Les énoncés précisés par la thèse sont recensés dans [`../03_resultats_these/`](../03_resultats_these/README_fr.md).

## 5. Soumissions en cours

| Travail | Revue | Dossier |
|---|---|---|
| Famille SOTP | *IEEE Transactions on Information Theory* | [`../04_sotp/`](../04_sotp/README_fr.md) |
| Formalisation Lean 4 v2.2 | *Journal of Automated Reasoning* | [`../05_formalisation_lean/`](../05_formalisation_lean/README_fr.md) |

## 6. Construction de ce dépôt (octobre 2026)

Avant ce dépôt, la formalisation Lean et les scripts de calibration étaient diffusés dans un dépôt compagnon distinct. Ce dépôt antérieur a été supprimé. Son contenu utile a été repris ici et réorganisé. Aucun lien n'y renvoie.

| Date | Étape |
|---|---|
| 12 octobre 2026 | Création de la structure, des registres de statut, des fiches des articles et des préprints, de `03_resultats_these/`, de `04_sotp/` (dont SOTP-High exécutable), de `05_formalisation_lean/` et de `06_calcul/` (17 tests passés) ; `CITATION.cff` en version `1.0.0-pre` |
| 12 et 13 octobre 2026 | Instruments de terrain des protocoles P1 à P7 et pièces communes dans `07_protocoles_terrain/` |
| 13 octobre 2026 | Paquet d'analyse `07_protocoles_terrain/analyse/` (111 tests passés) |
| 13 octobre 2026 | Dossier `docs/` |
| 19 octobre 2026 | Version finale du manuscrit dans `00_these/manuscrit/`, fichier Lean remplacé par la version 2.2 vérifiée en ligne, adresse `MINKAThierry/PhDThesis`, nouvelle graine des stimuli de P1 |

Les sources du manuscrit dans `00_these/manuscrit/` sont celles de la version finale (voir [`../00_these/README_fr.md`](../00_these/README_fr.md)).

Le dépôt reste privé jusqu'à la soutenance. Les étapes prévues ensuite sont décrites dans la [procédure de publication](procedure_publication_fr.md).

## Licence

CC BY 4.0.
