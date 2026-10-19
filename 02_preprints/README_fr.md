# Préprints IACR ePrint cités par la thèse

> **Statut : PRÉPRINT (non évalué par les pairs)** · Source : Cryptology ePrint Archive, 2025

[English version](README_en.md)

Ce dossier rassemble les fiches des neuf préprints déposés en 2025 sur l'archive ePrint de l'IACR et cités par la thèse. Le statut PRÉPRINT signifie que ces documents n'ont pas été évalués par les pairs. Leurs résultats ne sont donc pas présentés comme validés. Seuls les articles P1, P2 et P3 parus dans IEEE Access en 2026 ont le statut PUBLIÉ (voir [01_publie](../01_publie/)).

Chaque sous-dossier contient une fiche bilingue (référence, résumé, rôle dans la thèse, réserves formulées dans la thèse) et une entrée BibTeX `CITATION.bib` reprise de la bibliographie de la thèse. Les PDF ne sont pas joints. Ils sont disponibles sur ePrint, où les neuf dépôts affichent la licence CC BY 4.0 (relevée le 2026-10-12).

## Tableau des préprints

| N° ePrint | Titre | Thème | Lien avec la thèse | Fiche |
|---|---|---|---|---|
| [2025/1138](https://eprint.iacr.org/2025/1138) | ZK-NR: A Layered Cryptographic Architecture for Explainable Non-Repudiation | Protocole de non-répudiation à couches (exploration) | Axe II (ZK-NR v1) | [2025-1138_ZK-NR](2025-1138_ZK-NR/README_fr.md) |
| [2025/1348](https://eprint.iacr.org/2025/1348) | The CRO Trilemma: A Formal Incompatibility between Confidentiality, Reliability and Legal Opposability in Post-Quantum Proof Systems | Borne d'impossibilité CRO (forme antérieure) | Antécédent du Trilemme (remplacé par P2) | [2025-1348_CRO-Trilemma](2025-1348_CRO-Trilemma/README_fr.md) |
| [2025/1380](https://eprint.iacr.org/2025/1380) | Quantum Composable and Contextual Security Infrastructure (Q2CSI): A Modular Architecture for Legally Explainable Cryptographic Signatures | Méta-architecture à couches Iron/Gold/Clay (UC) | Axe II (Q2CSI) | [2025-1380_Q2CSI](2025-1380_Q2CSI/README_fr.md) |
| [2025/1422](https://eprint.iacr.org/2025/1422) | Design ZK-NR: A Post-Quantum Layered Protocol for Legally Explainable Zero-Knowledge Non-Repudiation Attestation | Conception du protocole ZK-NR | Axe II (ZK-NR v2) | [2025-1422_ZK-NR-Design](2025-1422_ZK-NR-Design/README_fr.md) |
| [2025/1529](https://eprint.iacr.org/2025/1529) | UC-Security of the ZK-NR Protocol under Contextual Entropy Constraints: A Composable Zero-Knowledge Attestation Framework | Preuve de sécurité UC de ZK-NR | Axe II (ZK-NR v3) | [2025-1529_ZK-NR-UC](2025-1529_ZK-NR-UC/README_fr.md) |
| [2025/1590](https://eprint.iacr.org/2025/1590) | The AIIP Problem: Toward a Post-Quantum Hardness Assumption from Affine Iterated Inversion over Finite Fields | Hypothèse de difficulté post-quantique (itération polynomiale) | Axe I (AIIP, base du CASH Toolkit) | [2025-1590_AIIP](2025-1590_AIIP/README_fr.md) |
| [2025/1615](https://eprint.iacr.org/2025/1615) | The Chaotic Entropic Expansion (CEE): A Transparent Post-Quantum Data Confidentiality Primitive via Entropic Chaotic Maps | Primitive de confidentialité (CASH, couche Gold) | Axe I (CASH, $\mathrm{Conf}$) | [2025-1615_CEE](2025-1615_CEE/README_fr.md) |
| [2025/1662](https://eprint.iacr.org/2025/1662) | The Affine One-Wayness (AOW): A Transparent Post-Quantum Temporal Verification via Polynomial Iteration | Primitive de vérification temporelle (CASH, couche Iron) | Axe I (CASH, $\mathrm{Rel}$) | [2025-1662_AOW](2025-1662_AOW/README_fr.md) |
| [2025/1708](https://eprint.iacr.org/2025/1708) | The Semantic Holder (SH): Algebraic Extraction for Legal Opposability | Primitive d'opposabilité (CASH, couche Clay) | Axe I (CASH, $\mathrm{Opp}$) | [2025-1708_SH](2025-1708_SH/README_fr.md) |

## Lecture par rapport à la thèse

- **Antécédent du Trilemme.** Le préprint 2025/1348 contient une forme antérieure de la borne CRO. Elle est remplacée par l'article publié P2 (Trilemme CRO conditionnel), seule forme retenue par la thèse.
- **Axe I des perspectives (fondations computationnelles).** Le problème AIIP (2025/1590) et les trois primitives du CASH Toolkit, CEE (2025/1615), AOW (2025/1662) et SH (2025/1708), alignées respectivement sur $\mathrm{Conf}$, $\mathrm{Rel}$ et $\mathrm{Opp}$.
- **Axe II des perspectives (voie protocolaire).** Le méta-protocole Q2CSI (2025/1380) et la série ZK-NR en trois stades, exploration (2025/1138), conception (2025/1422) puis sécurité UC (2025/1529).

La thèse formule des réserves explicites sur plusieurs de ces préprints. Elles concernent l'objection de l'inversion par extractions de racines successives pour AIIP, la borne de distance statistique vide de CEE, le score $\Omega$ de SH et l'indice $\Gamma_\text{CRO}$ de Q2CSI et ZK-NR, tous deux non définis dans la thèse. Chaque fiche les détaille.
