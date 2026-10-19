# Correspondance entre la thèse et le dépôt

> **Statut : PROPOSITION — documentation du dépôt** · Source : thèse, PDF de la version de dépôt ([`../00_these/pdf/these_version_depot.pdf`](../00_these/pdf/these_version_depot.pdf)) et sources de la version finale ([`../00_these/manuscrit/`](../00_these/manuscrit/))

[English version](correspondance_these_depot_en.md) · [Retour à docs](README_fr.md)

Ce document indique, pour chaque partie de la thèse qui s'appuie sur un artefact, l'endroit du dépôt où cet artefact se trouve. La seconde partie recense les écarts entre la façon dont la thèse décrit le dépôt et son organisation réelle.

Les numéros de section, de tableau et de listing sont ceux du PDF de dépôt. Les labels LaTeX sont ceux des sources de `00_these/manuscrit/`. Le statut de chaque élément est donné dans [`../STATUS_fr.md`](../STATUS_fr.md). Les énoncés ajoutés ou précisés par la thèse (R1 à R16) sont détaillés dans [`../03_resultats_these/resultats_these_fr.md`](../03_resultats_these/resultats_these_fr.md).

## 1. Correspondance par chapitre

### Introduction générale et chapitre 1

| Thèse | Fichier source | Dépôt |
|---|---|---|
| Tableau des contributions, ligne « Programme de validation » | `intro_conclu_gen/introduction_generale.tex` | [`../07_protocoles_terrain/`](../07_protocoles_terrain/README_fr.md) |
| Renvoi à la formalisation Lean | `intro_conclu_gen/introduction_generale.tex` | [`../05_formalisation_lean/`](../05_formalisation_lean/README_fr.md) |
| §1.3.7 Vérification formelle (listing à coller dans l'éditeur en ligne) | `chap1/etat_art.tex` | [`../05_formalisation_lean/ConditionalCRO.lean`](../05_formalisation_lean/ConditionalCRO.lean) |
| §1.4.3 Objectifs scientifiques et programme, renvoi au dépôt | `chap1/problematique.tex` | ce dépôt (accueil [`../README_fr.md`](../README_fr.md)) |

### Chapitre 2 — cadre formel et bornes d'impossibilité

| Thèse | Fichier source | Dépôt |
|---|---|---|
| §2.2 Cadre CLO | `chap2/clo.tex` | article P1 [`../01_publie/P1_CLO_IEEEAccess2026/`](../01_publie/P1_CLO_IEEEAccess2026/README_fr.md) ; apports R1 à R5 |
| §2.2.4 Métriques quantiques, `def:perte_interp_quantique_pq` | `chap2/clo.tex`, `chap2/cro_pq.tex` | apport R10 |
| §2.3 Trilemme CRO conditionnel classique, `thm:trilemme_cro_conditionnel` | `chap2/cro_classique.tex` | article P2 [`../01_publie/P2_CRO_IEEEAccess2026/`](../01_publie/P2_CRO_IEEEAccess2026/README_fr.md) et ses [formulations précisées](../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/README_fr.md) ; apports R6 à R9 |
| §2.3.2 et §2.3.4 Forme raffinée `eq:trilemme_cro_raffine`, seuil $H^\sharp$ | `chap2/cro_classique.tex` | section 9 de [`ConditionalCRO.lean`](../05_formalisation_lean/ConditionalCRO.lean) ; contrôle V14 de [`../06_calcul/python/verifications.py`](../06_calcul/python/verifications.py) |
| §2.3.5 Calibration illustrative des paramètres classiques | `chap2/cro_classique.tex` | [`../06_calcul/data/parametres_reference.csv`](../06_calcul/data/parametres_reference.csv) |
| §2.4 Extension quantique, `thm:trilemme_pq` | `chap2/cro_pq.tex` | article P3 [`../01_publie/P3_PQCRO_IEEEAccess2026/`](../01_publie/P3_PQCRO_IEEEAccess2026/README_fr.md) et ses [formulations précisées](../01_publie/P3_PQCRO_IEEEAccess2026/formulations_precisees/README_fr.md) ; apports R11 et R12 |
| §2.4.6 Calibration illustrative des paramètres quantiques | `chap2/cro_pq.tex` | [`../06_calcul/data/calibration_pq.csv`](../06_calcul/data/calibration_pq.csv) |

### Chapitre 3 — constructions et certification

| Thèse | Fichier source | Dépôt |
|---|---|---|
| §3.1 Statut des résultats SOTP, `rem:statut_sotp` | `chap3/introduction_chap3.tex` | [`../04_sotp/`](../04_sotp/README_fr.md) ; apport R13 |
| §3.2 Semantic One-Time Pad, construction de base | `chap3/sotp_base.tex` | [`../04_sotp/specification/`](../04_sotp/specification/README_fr.md) |
| §3.3.2 SOTP-Low, `alg:sotp_low` | `chap3/sotp_construction.tex` | [`../04_sotp/reference_low_base/sotp_low.py`](../04_sotp/reference_low_base/sotp_low.py) |
| §3.3.3 SOTP-Base, `alg:sotp_base` | `chap3/sotp_construction.tex` | [`../04_sotp/reference_low_base/sotp_base.py`](../04_sotp/reference_low_base/sotp_base.py) |
| §3.3.4 SOTP-High | `chap3/sotp_construction.tex` | [`../04_sotp/high/`](../04_sotp/high/README_fr.md) (circuit Circom, preuve Groth16) |
| §3.3.6 Optimalité universelle, `conj:optimalite_universelle` | `chap3/sotp_construction.tex` | [`../04_sotp/specification/`](../04_sotp/specification/README_fr.md) (conjecture) |
| §3.4 Formalisation Lean 4 | `chap3/cro_lean4.tex` | [`../05_formalisation_lean/`](../05_formalisation_lean/README_fr.md) |
| §3.4.8 Extensions v2.2, `lst:lean4_extensions` | `chap3/cro_lean4.tex` | section 9 de [`ConditionalCRO.lean`](../05_formalisation_lean/ConditionalCRO.lean) |
| §3.4.9 Ce que la formalisation a révélé | `chap3/cro_lean4.tex` | formulations précisées de [P2](../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/README_fr.md) et de [P3](../01_publie/P3_PQCRO_IEEEAccess2026/formulations_precisees/README_fr.md) |
| Témoin de portée `regime_assumption_necessary` | `chap3/cro_lean4.tex` | [`../05_formalisation_lean/cas_limite/`](../05_formalisation_lean/cas_limite/README_fr.md) ; contrôle V6 |

### Chapitre 4 — expérimentation et validation

| Thèse | Fichier source | Dépôt |
|---|---|---|
| §4.1.3 Tableau 4.2, `tab:parametres_reference` | `chap4/introduction_chap4.tex` | [`../06_calcul/data/parametres_reference.csv`](../06_calcul/data/parametres_reference.csv) ; apport R14 |
| §4.2.1 Mesure de $\Delta$, `eq:estimateur_delta` | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P1_delta/`](../07_protocoles_terrain/P1_delta/README_fr.md) ; module `p1` de l'analyse ; apport R15 |
| §4.2.2 Mesure de $H(\mathcal{C})$ | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P2_entropie_contexte/`](../07_protocoles_terrain/P2_entropie_contexte/README_fr.md) |
| §4.2.3 Mesure de $\mathsf{Opp}$ sur Helios | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P3_opp_helios/`](../07_protocoles_terrain/P3_opp_helios/README_fr.md) |
| §4.2.4 Estimation conjointe de $\Delta$ et $\alpha$ | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P4_delta_alpha/`](../07_protocoles_terrain/P4_delta_alpha/README_fr.md) |
| §4.2.5 Mesure de $\Delta_q$ | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P5_delta_q/`](../07_protocoles_terrain/P5_delta_q/README_fr.md) |
| §4.2.6 Mesure de $\eta_q$ | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P6_eta_q/`](../07_protocoles_terrain/P6_eta_q/README_fr.md) |
| §4.2.7 Protocole combiné, `alg:protocole_combine` | `chap4/protocoles.tex` | [`../07_protocoles_terrain/P7_combine/`](../07_protocoles_terrain/P7_combine/README_fr.md) |
| §4.2.7.3 Tableau 4.7, `tab:criteres_refutation` | `chap4/protocoles.tex` | module `refutation` de [`../07_protocoles_terrain/analyse/`](../07_protocoles_terrain/analyse/README_fr.md) ; apport R16 |
| §4.2.8 Tableaux 4.8 et 4.9, calendrier et ressources | `chap4/protocoles.tex` | [`../07_protocoles_terrain/README_fr.md`](../07_protocoles_terrain/README_fr.md) et [`00_commun/`](../07_protocoles_terrain/00_commun/README_fr.md) |
| §4.3 Dérivation des valeurs d'opposabilité (Helios, Groth16, ECDSA, ML-DSA-65) | `chap4/derivation_opposabilite.tex` | [`../06_calcul/data/`](../06_calcul/data/SCHEMA_fr.md) ; script [`validate_sotp.py`](../06_calcul/python/validate_sotp.py) |
| §4.4.1 à §4.4.4 Paramètres classiques et quantiques, tableau comparatif | `chap4/validation_retrospective.tex` | [`validate_sotp.py`](../06_calcul/python/validate_sotp.py) ; sorties `calibration_classique_l128` et `calibration_pq_l128` de [`../06_calcul/results/`](../06_calcul/results/) |
| §4.4.2 Tableau 4.15, $\eta_q$ par type de canal | `chap4/validation_retrospective.tex` | [`sensitivity_eta_q.py`](../06_calcul/python/sensitivity_eta_q.py) ; sortie `sensibilite_eta_q` |
| §4.4.5, §4.4.8 et §4.4.9 Incertitude, dépendance en $\lambda$, test de significativité | `chap4/validation_retrospective.tex` | contrôles V8, V9 et V10 de [`verifications.py`](../06_calcul/python/verifications.py) |
| §4.4.10 Tableau 4.21, format CSV | `chap4/validation_retrospective.tex` | [`../06_calcul/data/SCHEMA_fr.md`](../06_calcul/data/SCHEMA_fr.md) |
| §4.4.12 Reproductibilité, `sec:reproductibilite` | `chap4/validation_retrospective.tex` | [`../06_calcul/reproduire.sh`](../06_calcul/reproduire.sh), [`../06_calcul/tests/`](../06_calcul/tests/) ; voir aussi la partie 2 |
| §4.4.12 Tableau 4.23, `tab:environnement_calcul` | `chap4/validation_retrospective.tex` | [`../06_calcul/python/requirements.txt`](../06_calcul/python/requirements.txt), [`requirements-lock.txt`](../06_calcul/python/requirements-lock.txt), [`../05_formalisation_lean/lean-toolchain`](../05_formalisation_lean/lean-toolchain) |

### Chapitre 5, conclusion et annexes

| Thèse | Fichier source | Dépôt |
|---|---|---|
| §5.2.1 Calibration rétrospective | `chap5/resultats.tex` | [`../06_calcul/`](../06_calcul/README_fr.md) |
| §5.2.2 Résultats formels, tableau 5.5 | `chap5/resultats.tex` | [`../05_formalisation_lean/`](../05_formalisation_lean/README_fr.md) |
| §5.3.11 Statut des protocoles expérimentaux | `chap5/discussions.tex` | [`../07_protocoles_terrain/`](../07_protocoles_terrain/README_fr.md) |
| §5.4.2 Axe I (AIIP, CASH Toolkit) et §5.4.3 Axe II (Q2CSI, ZK-NR) | `chap5/perspectives.tex` | [`../02_preprints/`](../02_preprints/README_fr.md) |
| Annexe A, sécurité game-based de la famille SOTP | `annexes/gamebased.tex` | [`../04_sotp/preuves_game_based/`](../04_sotp/preuves_game_based/README_fr.md) |
| Annexe B, listing B.1 `lst:lean4_complet` | `annexes/code_lean4.tex` | [`../05_formalisation_lean/ConditionalCRO.lean`](../05_formalisation_lean/ConditionalCRO.lean) |
| Annexe B, procédure `sec:lean4_reproduction` | `annexes/code_lean4.tex` | [`../05_formalisation_lean/README_fr.md`](../05_formalisation_lean/README_fr.md) |
| Annexe C, publications issues de la thèse | `annexes/publications.tex` | [`../01_publie/`](../01_publie/README_fr.md) et [`../02_preprints/`](../02_preprints/README_fr.md) |
| Entrée bibliographique `CROTrilemmaDepot` | `annexes/bibliographie.bib` | ce dépôt ; [`../CITATION.cff`](../CITATION.cff) |

## 2. Écarts entre le texte de la thèse et le dépôt

La version finale du manuscrit, dont les sources figurent dans `00_these/manuscrit/`, décrit le dépôt tel qu'il est organisé. Elle cite les répertoires `05_formalisation_lean/` et `06_calcul/{python,data,results,tests}`, la commande `./reproduire.sh` lancée dans `06_calcul/` et le fichier Lean en version 2.2 vérifiée en ligne. Les écarts relevés sur la version de dépôt à ces sujets (E3 à E12) sont donc résolus. Restent les écarts suivants.

| N° | Emplacement dans la thèse | Ce que dit la thèse | Réalité du dépôt | Traitement prévu |
|---|---|---|---|---|
| E1 | `subsec:depot` (`chap4/validation_retrospective.tex`) | DOI `10.5281/zenodo.XXXXXXX` | Aucun DOI Zenodo n'existe encore | DOI créé à la publication puis reporté (procédure, étapes 3 et 4) |
| E2 | même endroit ; note de l'entrée `CROTrilemmaDepot` | version 1.0.0 | `CITATION.cff` porte la version `1.0.0-pre` | étiquette `v1.0.0` posée à la publication |

Aucun de ces écarts ne touche un énoncé, une formule ou une valeur numérique.

## Licence

CC BY 4.0.
