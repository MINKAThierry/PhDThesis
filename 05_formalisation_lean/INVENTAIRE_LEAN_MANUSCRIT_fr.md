# Inventaire Lean versus manuscrit (v36)

Ce document met en regard les 170 énoncés numérotés du manuscrit v36 et la formalisation Lean du dépôt. Mise à jour du 27 novembre 2026, après les lots L1, L5a, L2, L3 et L5b (ConditionalCRO.lean v3.9). Les numéros et les pages sont ceux du PDF v36.

## Synthèse

| Statut | Nombre |
|---|---|
| démontré | 72 |
| démontré, une inégalité posée dans le modèle abstrait | 10 |
| mécanisé en situation réduite | 4 |
| hypothèse formalisée | 18 |
| non formalisé | 41 |
| hors champ formel | 25 |
| **Total** | **170** |

Sur 145 énoncés relevant d'une formalisation, 104 sont aujourd'hui couverts, soit 72 %. Avant le chantier, la couverture était de 42 énoncés (29 %) ; elle était de 57 (40 %) après le lot L1, de 79 (55 %) après le lot L5a de 85 (59 %) après le lot L2 et de 100 (69 %) après le lot L3. La Remarque 2.2 (`rem:rel_ver`), classée hors champ jusqu'ici, est devenue un énoncé formalisé avec le lot L3. Les 25 énoncés hors champ sont des remarques de statut, d'historique ou d'interprétation. Cinq d'entre eux sont des heuristiques de conception que le manuscrit déclare lui-même non prouvées. Ils ne portent aucune affirmation à démontrer.

## Couverture par type d'énoncé

| Type | Démontré | Posé ou réduit | Non formalisé | Hors champ |
|---|---|---|---|---|
| Théorème | 12 | 2 | 4 | 0 |
| Lemme | 9 | 3 | 5 | 0 |
| Proposition | 2 | 0 | 4 | 0 |
| Corollaire | 3 | 0 | 1 | 0 |
| Conjecture | 0 | 0 | 1 | 0 |
| Hypothèse | 0 | 12 | 0 | 0 |
| Définition | 19 | 5 | 21 | 0 |
| Remarque | 37 | 0 | 5 | 25 |

## Détail par chapitre

Colonne Lot, lot de la feuille de route qui couvre ou couvrira l'énoncé (« — » si rien n'est à faire).

### Chapitre 1

| N° | Page | Énoncé | Label | Statut | Nom Lean | Lot |
|---|---|---|---|---|---|---|
| Lemme 1.1 | 17 | Inégalité de Pinsker | `lem:pinsker` | démontré | pinsker_finite, CLOModel.pinsker_model | L1 |
| Lemme 1.2 | 17 | Lemme de Fano | `lem:fano` | démontré | fano_finite, CLOModel.fano_model, fano_general | L1, L3 |
| Lemme 1.3 | 17 | Data Processing Inequality (DPI) | `lem:dpi` | démontré | dpi_finite | L1 |
| Lemme 1.4 | 19 | Inégalité de Pinsker quantique | `lem:pinsker_quantique_etat_art` | non formalisé |  | L5c |
| Lemme 1.5 | 19 | Gentle measurement | `lem:mesure_douce_etat_art` | non formalisé |  | L5c |
| Lemme 1.6 | 20 | Lemme de Fano quantique | `lem:fano_quantique_etat_art` | non formalisé |  | L5c |
| Remarque 1.1 | 23 | Coexistence de deux notations de l'opposabilité | `rem:deux_notations` | hors champ formel |  | — |

### Chapitre 2

| N° | Page | Énoncé | Label | Statut | Nom Lean | Lot |
|---|---|---|---|---|---|---|
| Définition 2.1 | 42 | Protocole CLO | `def:protocole_clo` | démontré | CLOModel (noyau ker ne dépendant que de (Σ, C)) | L1 |
| Remarque 2.1 | 42 | Double couche de vérification | `rem:double_couche` | hors champ formel |  | — |
| Définition 2.2 | 44 | Confidentialité | `def:confidentialite_clo` | démontré | CLOModel.Conf, CLOModel.Rel, CLOModel.Opp | L1 |
| Définition 2.3 | 45 | Fiabilité de reconstruction | `def:fiabilite_clo` | démontré | CLOModel.Conf, CLOModel.Rel, CLOModel.Opp | L1 |
| Remarque 2.2 | 45 | Fiabilité de vérification | `rem:rel_ver` | démontré | relver, rel_of_conf_one | L3 |
| Définition 2.4 | 45 | Opposabilité | `def:opposabilite_clo` | démontré | CLOModel.Conf, CLOModel.Rel, CLOModel.Opp | L1 |
| Théorème 2.1 | 46 | Bornes élémentaires des métriques CLO | `thm:bornes_mesures` | démontré | CLOModel.bornes_mesures | L1 |
| Lemme 2.1 | 46 | Tension confidentialité--information mutuelle | `lem:compromis_conf_mi` | démontré | lemma4_concrete | L1 |
| Remarque 2.3 | 47 | Interprétation du lemme | `rem:interpretation_lemme` | démontré | conf_guarantee_antitone | L1 |
| Lemme 2.2 | 47 | Lemme de Johnson-Lindenstrauss | `lem:johnson_lindenstrauss` | non formalisé |  | L4 |
| Théorème 2.2 | 48 | Goulot d'étranglement contextuel | `thm:goulot_contexte` | démontré | CLOModel.goulot_contexte | L1 |
| Remarque 2.4 | 48 | Verdict déterministe | `rem:verdict_deterministe` | démontré | opp_eq_one_of_deterministic, CLOModel.opp_eq_one_of_det_concrete | L1 |
| Théorème 2.3 | 49 | Règles de composition | `thm:composition_sequentielle` | démontré | conf_post, rel_post, composition_parallele | L1 |
| Remarque 2.5 | 49 | Opposabilité composée | `rem:composition_opp` | démontré | opp_post, frechet, xor_not_subadditive, copy_not_superadditive | L1 |
| Définition 2.5 | 50 | Jeu IND-CONF | `def:jeu_ind_conf` | démontré | succIND, advDist, succIND_eq | L3 |
| Remarque 2.6 | 50 | Pont IND-CONF ↔ Conf | `rem:jeu_ind_conf_link` | démontré | advDist_le_tv, neyman_pearson, ind_conf_le_conf, tv_disjoint | L3 |
| Définition 2.6 | 51 | Jeu BIND-REL | `def:jeu_bind_rel` | démontré | winBindRel, winBindRel_bounds | L3 |
| Remarque 2.7 | 51 | Pont BIND-REL ↔ Relver | `rem:jeu_bind_rel_link` | démontré | relver, relver_ge, relver_of_liant, rel_of_conf_one | L3 |
| Définition 2.7 | 51 | Jeu EXT-OPP | `def:jeu_ext_opp` | démontré | extErr, HVSC | L3 |
| Remarque 2.8 | 52 | Pont EXT-OPP ↔ Opp | `rem:jeu_ext_opp_link` | démontré | CLOModel.IV_eq_HV_sub, CLOModel.ext_opp_bridge, ext_opp_bridge_K | L3 |
| Définition 2.8 | 52 | Confidentialité quantique | `def:conf_quantique_clo` | non formalisé |  | L5c |
| Remarque 2.9 | 53 | Compatibilité avec la confidentialité classique | `rem:compatibilite_conf` | démontré | traceDist_eq_tv, CLOModel.confQ_diag_eq | L5b |
| Définition 2.9 | 53 | Perte d'interprétabilité quantique | `def:perte_interp_quantique` | non formalisé |  | L5c |
| Remarque 2.10 | 53 | Interprétation physique | `rem:interpretation_physique` | hors champ formel |  | — |
| Définition 2.10 | 55 | Capacité d'extraction institutionnelle | `def:delta_extraction` | hypothèse formalisée | InstitutionalParams | — |
| Définition 2.11 | 55 | Granularité des verdicts | `def:alpha_granularite` | hypothèse formalisée | InstitutionalParams | — |
| Définition 2.12 | 55 | Régularité du protocole | `def:beta_regularite` | hypothèse formalisée | InstitutionalParams | — |
| Définition 2.13 | 55 | Interprétation institutionnelle admissible | `def:interp_admissible` | démontré | CLOModel (noyau ker ne dépendant que de (Σ, C)) | L1 |
| Hypothèse 2.1 | 55 | Extraction bornée | `ass:extraction_bornee` | hypothèse formalisée | InstitutionalAssumptions, prémisses des théorèmes _concrete | — |
| Proposition 2.1 | 55 | Fondement informationnel de l'Hypothèse ass:extraction_bornee | `prop:fondement_extraction` | démontré | CLOModel.fondement_extraction | L1 |
| Remarque 2.11 | 56 | Δ est une capacité de l'institution | `rem:delta_capacite` | démontré | CLOModel.capacite_le_gamma_add_one | L1 |
| Hypothèse 2.2 | 56 | Verdict efficace | `ass:verdicts_efficace` | hypothèse formalisée | InstitutionalAssumptions, prémisses des théorèmes _concrete | — |
| Remarque 2.12 | 56 | Statut de l'Hypothèse ass:verdicts_efficace | `rem:statut_verdict_efficace` | démontré | verdict_card_not_efficient | L1 |
| Hypothèse 2.3 | 56 | Régularité | `ass:regularite` | hypothèse formalisée | InstitutionalAssumptions, prémisses des théorèmes _concrete | — |
| Hypothèse 2.4 | 57 | Régime de préservation de la confidentialité | `ass:regime` | hypothèse formalisée | InstitutionalAssumptions, prémisses des théorèmes _concrete | — |
| Remarque 2.13 | 57 | Statut et rôle de l'Hypothèse ass:regime | `rem:statut_regime` | hors champ formel |  | — |
| Remarque 2.14 | 57 | Version de la preuve | `rem:version_preuve_classique` | hors champ formel |  | — |
| Lemme 2.3 | 57 | Garantie de confidentialité pour les protocoles réguliers | `lem:confidentiality_guarantee` | démontré, une inégalité posée dans le modèle abstrait | lemma4_confidentiality_guarantee, lemma4_concrete | L1 |
| Remarque 2.15 | 58 | Interprétation du Lemme lem:confidentiality_guarantee | `rem:interp_lemme4` | démontré | conf_guarantee_antitone | L1 |
| Remarque 2.16 | 58 | Constante c_0 | `rem:constante_c0` | démontré | c0, c0_gt_half, pinsker_model | L1 |
| Théorème 2.4 | 58 | Trilemme CRO conditionnel classique | `thm:trilemme_cro_conditionnel` | démontré | trilemma_explicit, trilemma_refined, conditional_CRO_trilemma (+ _concrete), conf_regime_concrete | L2 |
| Remarque 2.17 | 61 | La forme publiée comme corollaire | `rem:corollaire_publie` | démontré, une inégalité posée dans le modèle abstrait | trilemma_instance | — |
| Remarque 2.18 | 61 | Quand la capacité institutionnelle est-elle contraignante ? | `rem:activite_delta` | démontré | refined_bound_is_fano_when_delta_ge_gamma, factor_lt_one_iff, seuil_Hsharp | — |
| Proposition 2.2 | 62 | Borne aiguë sur la fiabilité de reconstruction | `prop:borne_aigue` | démontré | fano_sharp_model, rel_aigu, trilemma_aigu_concrete | L2 |
| Remarque 2.19 | 62 | Portée de la borne aiguë | `rem:borne_aigue_portee` | non formalisé | borne_forte_statut (majoration en λ⁻² seulement) | L2 |
| Remarque 2.20 | 63 | Un témoin réalisable du facteur institutionnel | `rem:temoin_realisable` | démontré | witModel, temoin_realisable | L2 |
| Remarque 2.21 | 63 | Témoin combiné o`u le facteur institutionnel est actif | `rem:temoin_combine` | non formalisé |  | L2 |
| Remarque 2.22 | 64 | Portée du Théorème thm:trilemme_cro_conditionnel | `rem:scope_trilemme_classique` | démontré | regime_assumption_necessary | L2 |
| Remarque 2.23 | 64 | Statut de vérification | `rem:statut_verification_classique` | hors champ formel |  | — |
| Corollaire 2.1 | 64 | Forme simplifiée | `cor:forme_simplifiee` | démontré | forme_simplifiee | L2 |
| Remarque 2.24 | 65 | Portée des études de cas | `rem:portee_cas_etude` | démontré | portee_cas_etude | L2 |
| Définition 2.14 | 69 | Entropie de von Neumann | `def:entropie_conditionnelle_quantique` | non formalisé |  | L5c |
| Définition 2.15 | 69 | Information mutuelle quantique | `def:information_mutuelle_quantique` | non formalisé |  | L5c |
| Définition 2.16 | 69 | Information quantique accessible | `def:info_accessible` | non formalisé |  | L5c |
| Définition 2.17 | 69 | Entropie min-max lissée | `def:entropie_min_max_lissee` | non formalisé |  | L5c |
| Remarque 2.25 | 70 | Relation avec l'entropie de Shannon | `rem:relation_shannon` | démontré | vonNeumann_diag | L5b |
| Lemme 2.4 | 70 | Inégalité de Pinsker quantique | `lem:pinsker_quantique` | hypothèse formalisée | champs pinsker_q, fano_q, holevo de QuantumProtocolInstance | L5c |
| Lemme 2.5 | 70 | Mesure douce (gentle measurement) | `lem:mesure_douce` | non formalisé |  | L5c |
| Lemme 2.6 | 71 | Inégalité de Fano quantique | `lem:fano_quantique` | hypothèse formalisée | champs pinsker_q, fano_q, holevo de QuantumProtocolInstance | L5c |
| Lemme 2.7 | 71 | Borne de Holevo-Helstrom | `lem:holevo_helstrom` | hypothèse formalisée | champs pinsker_q, fano_q, holevo de QuantumProtocolInstance | L5c |
| Définition 2.18 | 72 | Canal dépolarisant | `def:canal_depolarisant` | non formalisé |  | L5c |
| Définition 2.19 | 72 | Canal d'amortissement | `def:canal_amortissement` | non formalisé |  | L5c |
| Définition 2.20 | 72 | Canal de déphasage | `def:canal_dephasage` | non formalisé |  | L5c |
| Définition 2.21 | 72 | Canal d'effacement | `def:canal_effacement` | non formalisé |  | L5c |
| Définition 2.22 | 72 | Norme diamant | `def:norme_diamant` | non formalisé |  | L5c |
| Définition 2.23 | 73 | Protocole de preuve quantique | `def:protocole_pq` | non formalisé |  | L5c |
| Définition 2.24 | 73 | Confidentialité quantique | `def:conf_quantique` | non formalisé |  | L5c |
| Définition 2.25 | 73 | Fiabilité quantique | `def:fiabilite_quantique` | non formalisé |  | L5c |
| Définition 2.26 | 73 | Opposabilité quantique | `def:opposabilite_quantique` | non formalisé |  | L5c |
| Remarque 2.26 | 73 | Compatibilité avec la confidentialité classique | `rem:compatibilite_classique` | démontré | traceDist_eq_tv, CLOModel.confQ_diag_eq | L5b |
| Définition 2.27 | 74 | Perte d'interprétabilité quantique | `def:perte_interp_quantique_pq` | démontré | CLOModel.etaQ, etaQ_bounds | L5a |
| Remarque 2.27 | 74 | Encadrement de η_q | `rem:encadrement_eta_q` | démontré | CLOModel.etaQ, etaQ_bounds | L5a |
| Remarque 2.28 | 74 | Interprétation physique | `rem:interpretation_physique_pq` | hors champ formel |  | — |
| Définition 2.28 | 74 | Vérificateur institutionnel quantique | `def:verificateur_institutionnel_quantique` | non formalisé |  | L5c |
| Définition 2.29 | 74 | Protocole d'interaction quantique | `def:protocole_interaction_quantique` | non formalisé |  | L5c |
| Remarque 2.29 | 74 | Capacité institutionnelle quantique | `rem:capacite_institutionnelle_quantique` | démontré | capacite_q_non_dpi | L5a |
| Remarque 2.30 | 75 | Version de la preuve | `rem:version_preuve_pq` | hors champ formel |  | — |
| Hypothèse 2.5 | 75 | Extraction institutionnelle bornée quantique | `ass:extraction_quantique` | hypothèse formalisée | QuantumAssumptions, prémisse χmax ≤ κ/λ | L5a |
| Définition 2.30 | 75 | Décomposition de Δ_q | `def:decomposition_delta_q` | démontré | deltaQ, deltaQ_le | L5a |
| Hypothèse 2.6 | 75 | Verdict efficace quantique | `ass:verdict_quantique` | hypothèse formalisée | QuantumAssumptions, prémisse χmax ≤ κ/λ | L5a |
| Remarque 2.31 | 76 | Statut de l'Hypothèse ass:verdict_quantique | `rem:statut_verdict_quantique` | démontré | verdict_q_card_not_efficient | L5a |
| Remarque 2.32 | 76 | Raccord avec l'Hypothèse ass:verdicts_efficace | `rem:raccord_gamma_q` | démontré | raccord_gamma_q | L5a |
| Hypothèse 2.7 | 76 | Régularité de protocole quantique | `ass:regularite_quantique` | hypothèse formalisée | QuantumAssumptions, prémisse χmax ≤ κ/λ | L5a |
| Hypothèse 2.8 | 76 | Régime de préservation de la confidentialité quantique | `ass:regime_quantique` | hypothèse formalisée | QuantumAssumptions, prémisse χmax ≤ κ/λ | L5a |
| Remarque 2.33 | 76 | Statut de l'Hypothèse ass:regime_quantique | `rem:statut_regime_quantique` | démontré, une inégalité posée dans le modèle abstrait | statut_regime_q | L5a |
| Remarque 2.34 | 76 | Lemme 6 de la version publiée | `rem:retrait_lemma6` | démontré | cas_limite_lemme6 | L5b |
| Lemme 2.8 | 77 | Garantie de confidentialité quantique | `lem:q_conf_mi_pq` | démontré, une inégalité posée dans le modèle abstrait | QuantumProtocolInstance.conf_guarantee | L5a |
| Remarque 2.35 | 77 | Constantes de Pinsker classique et quantique | `rem:raccord_pinsker` | démontré | constantes_pinsker | L5a |
| Remarque 2.36 | 77 | Interprétation du Lemme lem:q_conf_mi_pq | `rem:interp_lemme7` | démontré | dilithium_Dmax | L5a |
| Théorème 2.5 | 77 | Trilemme CRO conditionnel quantique | `thm:trilemme_pq` | démontré, une inégalité posée dans le modèle abstrait | trilemma_pq_explicit, conditional_CRO_trilemma_pq | L5a |
| Remarque 2.37 | 79 | Portée du Théorème thm:trilemme_pq | `rem:scope_trilemme_pq` | démontré | regime_q_necessary | L5a |
| Remarque 2.38 | 79 | Statut de vérification | `rem:statut_verification_pq` | hors champ formel |  | — |
| Remarque 2.39 | 79 | Forme raffinée quantique | `rem:forme_raffinee_pq` | démontré, une inégalité posée dans le modèle abstrait | trilemma_pq_refined, seuil_Hsharp_q | L5a |
| Remarque 2.40 | 80 | Borne aiguë dans le cadre quantique | `rem:borne_aigue_pq` | démontré, une inégalité posée dans le modèle abstrait | trilemma_aigu_q | L2 |
| Remarque 2.41 | 80 | La majoration publiée comme corollaire | `rem:corollaire_publie_pq` | démontré, une inégalité posée dans le modèle abstrait | trilemma_pq_published | L5a |
| Corollaire 2.2 | 80 | Forme simplifiée quantique | `cor:forme_simplifiee_pq` | démontré | forme_simplifiee_pq | L5a |

### Chapitre 3

| N° | Page | Énoncé | Label | Statut | Nom Lean | Lot |
|---|---|---|---|---|---|---|
| Remarque 3.1 | 87 | Statut des résultats de ce chapitre | `rem:statut_sotp` | hors champ formel |  | — |
| Théorème 3.1 | 89 | Propriétés de sécurité S-OTP | `thm:proprietes_sotp` | non formalisé |  | L4 |
| Remarque 3.2 | 89 | Portée du Théorème thm:proprietes_sotp | `rem:portee_sotp` | non formalisé |  | L4 |
| Remarque 3.3 | 90 | Argument heuristique d'optimalité de S-OTP dans la classe OTP | `thm:optimalite_sotp` | hors champ formel |  | L4 |
| Proposition 3.1 | 95 | Propriétés cryptographiques de SOTP-Low | `thm:saturation_sotp_low` | non formalisé |  | L4 |
| Remarque 3.4 | 95 | Heuristique de conception de SOTP-Low (non prouvée) | `rem:facteur_limitant_low` | hors champ formel |  | L4 |
| Remarque 3.5 | 96 | Masque par troncature | `rem:masque_troncature` | non formalisé |  | L4 |
| Proposition 3.2 | 98 | Propriétés cryptographiques de SOTP-Base | `thm:saturation_sotp_base` | non formalisé |  | L4 |
| Remarque 3.6 | 98 | Heuristique de conception de SOTP-Base (non prouvée) | `rem:heuristique_sotp_base` | hors champ formel |  | L4 |
| Proposition 3.3 | 100 | Propriétés cryptographiques de SOTP-High | `thm:saturation_sotp_high` | non formalisé |  | L4 |
| Remarque 3.7 | 101 | Heuristique de conception de SOTP-High (non prouvée) | `rem:heuristique_sotp_high` | hors champ formel |  | L4 |
| Conjecture 3.1 | 104 | Optimalité universelle SOTP | `conj:optimalite_universelle` | non formalisé |  | L4 |
| Remarque 3.8 | 104 | Statut et argument heuristique | `rem:statut_optimalite` | hors champ formel |  | L4 |
| Définition 3.1 | 107 | Confidentialité | `def:conf_lean4` | démontré | CLOModel.Conf, CLOModel.Rel, CLOModel.Opp | L1 |
| Définition 3.2 | 108 | Fiabilité | `def:rel_lean4` | démontré | CLOModel.Conf, CLOModel.Rel, CLOModel.Opp | L1 |
| Définition 3.3 | 108 | Opposabilité | `def:opp_lean4` | démontré | CLOModel.Conf, CLOModel.Rel, CLOModel.Opp | L1 |
| Remarque 3.9 | 108 | Verdict admissible et formalisation | `rem:opp_lean4_admissible` | démontré | CLOModel.opp_eq_one_of_det_concrete | L1 |
| Hypothèse 3.1 | 108 | Extraction bornée | `ass:fano_axiom` | hypothèse formalisée | InstitutionalAssumptions, prémisses des théorèmes _concrete | — |
| Hypothèse 3.2 | 108 | Verdict efficace | `ass:pinsker_axiom` | hypothèse formalisée | InstitutionalAssumptions, prémisses des théorèmes _concrete | — |
| Hypothèse 3.3 | 109 | Régularité | `ass:extraction_axiom` | hypothèse formalisée | InstitutionalAssumptions, prémisses des théorèmes _concrete | — |
| Hypothèse 3.4 | 109 | Fiabilité-information | `ass:reliability_axiom` | hypothèse formalisée | InstitutionalAssumptions, prémisses des théorèmes _concrete | — |
| Théorème 3.2 | 109 | Trilemme CRO conditionnel, énoncé publié réécrit dans les no | `thm:original_lean4` | démontré, une inégalité posée dans le modèle abstrait | trilemma_instance | — |
| Lemme 3.1 | 113 | Négligeabilité de varepsilon_0 | `lem:negligeabilite_eps0` | démontré | negligible_eps0 | — |
| Théorème 3.3 | 113 | Version vérifiée du Trilemme CRO conditionnel | `thm:conditional_CRO_trilemma` | démontré, une inégalité posée dans le modèle abstrait | conditional_CRO_trilemma, conditional_CRO_trilemma_concrete | — |
| Théorème 3.4 | 114 | Cohérence du modèle abstrait | `thm:witness_consistency` | démontré | assumptions_consistent_and_bound_attained, concrete_assumptions_satisfiable | — |
| Remarque 3.10 | 114 | Portée du témoin de cohérence | `rem:portee_temoin` | hors champ formel |  | — |
| Théorème 3.5 | 115 | Nécessité du régime de confidentialité | `thm:scope_necessity` | démontré | regime_assumption_necessary | — |
| Remarque 3.11 | 115 | Statut de vérification | `rem:statut_verification_lean4` | hors champ formel |  | — |
| Théorème 3.6 | 120 | Régime Helios | `thm:regime_helios` | démontré | Helios_regime_at_128 | — |
| Théorème 3.7 | 120 | Régime zk-SNARKs | `thm:regime_snarks` | démontré | zkSNARK_regime_at_256 | — |
| Théorème 3.8 | 121 | Régime audit traditionnel | `thm:regime_audit` | démontré | TraditionalAudit_regime_at_128 | — |

### Chapitre 4

| N° | Page | Énoncé | Label | Statut | Nom Lean | Lot |
|---|---|---|---|---|---|---|
| Définition 4.1 | 127 | Capacité d'extraction institutionnelle Δ | `def:capacite_extraction_op` | non formalisé |  | L6 |
| Remarque 4.2 | 129 | Estimateur et capacité pour une preuve masquante | `rem:estimateur_masquant` | non formalisé |  | L6 |
| Proposition 4.1 | 129 | Minorant par traits | `prop:minorant_traits` | non formalisé |  | L6 |
| Définition 4.2 | 133 | Capacité d'extraction quantique Δ_q | `def:capacite_extraction_quantique_op` | non formalisé |  | L6 |
| Remarque 4.3 | 152 | Intervalles de la formulation initiale | `rem:ic_anterieurs` | hors champ formel |  | — |

### Chapitre 5

| N° | Page | Énoncé | Label | Statut | Nom Lean | Lot |
|---|---|---|---|---|---|---|
| Remarque 5.1 | 163 | Portée de la borne | `rem:portee_borne_precisee` | hors champ formel |  | — |
| Remarque 5.2 | 163 | Portée de la borne post-quantique | `rem:portee_borne_pq_precisee` | hors champ formel |  | — |
| Remarque 5.3 | 165 | Périmètre de la couverture Lean4 | `rem:perimetre_lean4` | hors champ formel |  | — |
| Remarque 5.4 | 166 | Clarification sur les valeurs numériques des tableaux | `rem:clarification_section_VI_B` | hors champ formel |  | — |
| Définition 5.1 | 173 | Régime de basse capacité | `def:regime_low` | démontré | capacity_regime | — |
| Définition 5.2 | 173 | Régime de capacité moyenne | `def:regime_mid` | démontré | capacity_regime | — |
| Définition 5.3 | 173 | Régime de haute capacité | `def:regime_high` | démontré | capacity_regime | — |
| Remarque 5.5 | 185 | Statut d'une borne forte en O(λ^-2) | `rem:borne_forte_statut` | démontré | borne_forte_statut | L2 |

### Annexe A

| N° | Page | Énoncé | Label | Statut | Nom Lean | Lot |
|---|---|---|---|---|---|---|
| Définition A.1 | 219 | Sécurité PRG | `def:ann_prg` | mécanisé en situation réduite | com, pedersen_extract, advPRG (GameBasedSOTP) | L4 |
| Définition A.2 | 220 | Engagement de Pedersen | `def:ann_pedersen` | mécanisé en situation réduite | com, pedersen_extract, advPRG (GameBasedSOTP) | L4 |
| Définition A.3 | 220 | zk-SNARK Groth16 | `def:ann_groth16` | non formalisé |  | L4 |
| Définition A.4 | 221 | Transformation JL | `def:ann_jl` | non formalisé |  | L4 |
| Lemme A.1 | 221 | Inégalité de Fano | `lem:ann_g_fano` | démontré | fano_finite, CLOModel.fano_model, fano_general | L1, L3 |
| Lemme A.2 | 221 | Traitement de l'Information (DPI) | `lem:ann_dpi` | démontré | dpi_finite | L1 |
| Définition A.5 | 222 | Jeu IND-CONF (section sec:sotp_construction) | `def:ann_ind_conf` | démontré | succIND, advDist, succIND_eq | L3 |
| Remarque A.1 | 222 | Pont IND-CONF ↔ Conf | `rem:ann_ind_conf_link` | démontré | advDist_le_tv, neyman_pearson, ind_conf_le_conf, tv_disjoint | L3 |
| Définition A.6 | 223 | Jeu BIND-REL (section sec:sotp_construction) | `def:ann_bind_rel` | démontré | winBindRel, winBindRel_bounds | L3 |
| Remarque A.2 | 223 | Pont BIND-REL ↔ Relver | `rem:ann_bind_rel_link` | démontré | relver, relver_ge, relver_of_liant, rel_of_conf_one | L3 |
| Définition A.7 | 224 | Jeu EXT-OPP (section sec:sotp_construction) | `def:ann_ext_opp` | démontré | extErr, HVSC | L3 |
| Remarque A.3 | 224 | Pont EXT-OPP ↔ Opp | `rem:ann_ext_opp_link` | démontré | CLOModel.IV_eq_HV_sub, CLOModel.ext_opp_bridge, ext_opp_bridge_K | L3 |
| Théorème A.1 | 225 | Réduction de SOTP-Low au PRG (section sec:sotp_construction) | `thm:ann_sotp_low_conf` | mécanisé en situation réduite | ind_conf_eq_prg, ind_conf_perfect_otp (GameBasedSOTP) | L4 |
| Théorème A.2 | 226 | Réduction de SOTP-Low au logarithme discret (section sec:sotp_construc | `thm:ann_sotp_low_rel` | mécanisé en situation réduite | bind_rel_gives_dlog, win_bind_le_dlog (GameBasedSOTP) | L4 |
| Théorème A.3 | 227 | Dimensionnement JL de SOTP-Base (section sec:sotp_construction) | `thm:ann_sotp_base_opp` | non formalisé |  | L4 |
| Corollaire A.1 | 227 | Réductions pour SOTP-Base | `cor:ann_sotp_base_reductions` | non formalisé |  | L4 |
| Théorème A.4 | 227 | Sécurité de SOTP-High héritée de Groth16 (section sec:sotp_constructio | `thm:ann_sotp_high` | non formalisé |  | L4 |
| Théorème A.5 | 228 | Bornes game-based complètes de SOTP-Low (section sec:sotp_construction | `thm:ann_sotp_low_games` | non formalisé |  | L4 |
| Remarque A.5 | 229 | Absence de borne game-based pour l'opposabilité de SOTP-Low | `rem:ann_sotp_low_opp_statut` | hors champ formel |  | — |
| Corollaire A.2 | 229 | Produit CLO depuis les jeux (section sec:sotp_construction) | `cor:ann_cro_from_games` | démontré | product_from_games | L3 |
| Remarque A.6 | 230 | Pourquoi ce corollaire ne contredit pas le Trilemme | `rem:ann_pas_de_contradiction` | démontré | echelles_distinctes | L3 |

### Sans numéro

| N° | Page | Énoncé | Label | Statut | Nom Lean | Lot |
|---|---|---|---|---|---|---|
| Remarque  |  | La ZK parfaite | `` | hors champ formel |  | — |
| Remarque  |  | Formulation initiale de l'estimateur | `` | hors champ formel |  | — |
