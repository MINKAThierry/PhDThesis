/-
  Dossier de vérification. Point d'entrée mince
  =============================================
  Une ligne par énoncé de `Enonces.lean`. Chaque ligne affirme que le théorème
  existant de `ConditionalCRO.lean` (version 3.12) prouve exactement
  l'énoncé écrit séparément. Si un énoncé et sa preuve divergent, ce fichier ne
  compile pas. C'est le seul fichier qu'un relecteur doit ouvrir, avec
  `Enonces.lean`. Le script `verifier.sh` exécute `#print axioms` sur chaque
  théorème ci-dessous.
-/

import Verification.Enonces

namespace Principal

open ConditionalCRO

-- 1. Négligeabilité
theorem principal_negligeabilite_eps0 : Enonces.NegligeabiliteEps0 := negligible_eps0

-- 2. Noyau algébrique
theorem principal_lemme4 : Enonces.Lemme4 := lemma4_confidentiality_guarantee
theorem principal_trilemme_explicite : Enonces.TrilemmeExplicite := trilemma_explicit
theorem principal_trilemme_publie : Enonces.TrilemmePublie := trilemma_instance
theorem principal_trilemme_asymptotique : Enonces.TrilemmeAsymptotique := conditional_CRO_trilemma
theorem principal_trilemme_raffine : Enonces.TrilemmeRaffine := trilemma_refined
theorem principal_temoin_coherence : Enonces.TemoinCoherence := assumptions_consistent_and_bound_attained
theorem principal_temoin_portee : Enonces.TemoinPortee := regime_assumption_necessary
theorem principal_regime_helios : Enonces.RegimeHelios := Helios_regime_at_128
theorem principal_regime_zksnark : Enonces.RegimeZkSNARK := zkSNARK_regime_at_256
theorem principal_regime_audit : Enonces.RegimeAuditTraditionnel := TraditionalAudit_regime_at_128
theorem principal_verdict_deterministe : Enonces.VerdictDeterministe := opp_eq_one_of_deterministic
theorem principal_verdict_deterministe_capacite : Enonces.VerdictDeterministeCapacite := deterministic_forces_capacity
theorem principal_facteur_un : Enonces.FacteurUnSiDeltaGrand := refined_bound_is_fano_when_delta_ge_gamma
theorem principal_facteur_inferieur_un : Enonces.FacteurInferieurUnSsi := factor_lt_one_iff
theorem principal_seuil_hdiese : Enonces.SeuilHdiese := seuil_Hsharp

-- 3. Couche concrète, inégalités sur lois finies
theorem principal_pinsker_fini : Enonces.PinskerFini := pinsker_finite
theorem principal_info_mutuelle_positive : Enonces.InfoMutuellePositive := miN_nonneg
theorem principal_info_mutuelle_majoree : Enonces.InfoMutuelleMajoree := miN_le_entN2
theorem principal_fano_fini : Enonces.FanoFini := fano_finite

-- 4. Couche concrète, modèle CLOModel
theorem principal_modele_iv_hv : Enonces.ModeleIVinfHV := CLOModel.IV_le_HV
theorem principal_modele_pinsker : Enonces.ModelePinsker := CLOModel.pinsker_model
theorem principal_modele_fano : Enonces.ModeleFano := CLOModel.fano_model
theorem principal_trilemme_explicite_concret : Enonces.TrilemmeExpliciteConcret := trilemma_explicit_concrete
theorem principal_trilemme_raffine_concret : Enonces.TrilemmeRaffineConcret := trilemma_refined_concrete
theorem principal_lemme4_concret : Enonces.Lemme4Concret := lemma4_concrete
theorem principal_trilemme_asymptotique_concret : Enonces.TrilemmeAsymptotiqueConcret := conditional_CRO_trilemma_concrete

-- 5. Couche concrète, famille témoin
theorem principal_famille_temoin_hypotheses : Enonces.FamilleTemoinHypotheses := concrete_assumptions_satisfiable
theorem principal_famille_temoin_asymptotique : Enonces.FamilleTemoinAsymptotique := concrete_asymptotic_applies

-- 6. Extension v3.5, lot L1 (information classique finie et cadre CLO)
theorem principal_dpi_finie : Enonces.DPIFinie := dpi_finite
theorem principal_dpi_variation_totale : Enonces.DPIVariationTotale := tv_pushforward_le
theorem principal_bornes_elementaires : Enonces.BornesElementaires := CLOModel.bornes_mesures
theorem principal_goulot_contextuel : Enonces.GoulotContextuel := CLOModel.goulot_contexte
theorem principal_capacite_majoree : Enonces.CapaciteMajoree := CLOModel.capacite_le_gamma_add_one
theorem principal_cardinal_sans_efficacite : Enonces.CardinalSansEfficacite := verdict_card_not_efficient
theorem principal_composition_seq_conf : Enonces.CompositionSequentielleConf := CLOModel.conf_post
theorem principal_composition_seq_rel : Enonces.CompositionSequentielleRel := CLOModel.rel_post
theorem principal_opposabilite_composee : Enonces.OpposabiliteComposee := CLOModel.opp_post
theorem principal_composition_parallele : Enonces.CompositionParallele := CLOModel.composition_parallele
theorem principal_frechet : Enonces.Frechet := frechet
theorem principal_xor_non_sous_additif : Enonces.XorNonSousAdditif := xor_not_subadditive
theorem principal_copie_non_sur_additive : Enonces.CopieNonSurAdditive := copy_not_superadditive
theorem principal_regle_de_chaine : Enonces.RegleDeChaine := chain_rule
theorem principal_info_conditionnelle_positive : Enonces.InfoConditionnellePositive := condMI_nonneg
theorem principal_fondement_extraction : Enonces.FondementExtraction := CLOModel.fondement_extraction
theorem principal_verdict_deterministe_concret : Enonces.VerdictDeterministeConcret := CLOModel.opp_eq_one_of_det_concrete
theorem principal_garantie_conf_decroissante : Enonces.GarantieConfDecroissante := conf_guarantee_antitone

-- 7. Extension v3.6, lot L5a (noyau algébrique quantique)
theorem principal_garantie_conf_quantique : Enonces.GarantieConfQuantique := QuantumProtocolInstance.conf_guarantee
theorem principal_trilemme_quantique_explicite : Enonces.TrilemmeQuantiqueExplicite := trilemma_pq_explicit
theorem principal_trilemme_quantique_publie : Enonces.TrilemmeQuantiquePublie := trilemma_pq_published
theorem principal_trilemme_quantique_asymptotique : Enonces.TrilemmeQuantiqueAsymptotique := conditional_CRO_trilemma_pq
theorem principal_trilemme_quantique_raffine : Enonces.TrilemmeQuantiqueRaffine := trilemma_pq_refined
theorem principal_seuil_hdiese_quantique : Enonces.SeuilHdieseQuantique := seuil_Hsharp_q
theorem principal_forme_simplifiee_quantique : Enonces.FormeSimplifieeQuantique := forme_simplifiee_pq
theorem principal_cardinal_sans_efficacite_quantique : Enonces.CardinalSansEfficaciteQuantique := verdict_q_card_not_efficient
theorem principal_raccord_gamma_quantique : Enonces.RaccordGammaQuantique := raccord_gamma_q
theorem principal_statut_regime_quantique : Enonces.StatutRegimeQuantique := statut_regime_q
theorem principal_constantes_pinsker : Enonces.ConstantesPinsker := constantes_pinsker
theorem principal_decomposition_delta_q : Enonces.DecompositionDeltaQ := deltaQ_le
theorem principal_encadrement_eta_q : Enonces.EncadrementEtaQ := etaQ_bounds
theorem principal_capacite_quantique_hors_dpi : Enonces.CapaciteQuantiqueHorsDPI := capacite_q_non_dpi
theorem principal_temoin_portee_quantique : Enonces.TemoinPorteeQuantique := regime_q_necessary
theorem principal_temoin_coherence_quantique : Enonces.TemoinCoherenceQuantique := assumptions_q_consistent
theorem principal_dmax_mldsa : Enonces.DmaxMLDSA := dilithium_Dmax

-- 8. Extension v3.7, lot L2 (bornes avancées)
theorem principal_fano_aigu : Enonces.FanoAigu := CLOModel.fano_sharp_model
theorem principal_borne_aigue : Enonces.BorneAigue := CLOModel.rel_aigu
theorem principal_trilemme_aigu : Enonces.TrilemmeAigu := CLOModel.trilemma_aigu_concrete
theorem principal_conf_regime_concret : Enonces.ConfRegimeConcret := CLOModel.conf_regime_concrete
theorem principal_conf_regime : Enonces.ConfRegime := conf_regime
theorem principal_forme_simplifiee : Enonces.FormeSimplifiee := forme_simplifiee
theorem principal_portee_cas_etude : Enonces.PorteeCasEtude := portee_cas_etude
theorem principal_borne_forte_statut : Enonces.BorneForteStatut := borne_forte_statut
theorem principal_trilemme_aigu_quantique : Enonces.TrilemmeAiguQuantique := trilemma_aigu_q
theorem principal_temoin_realisable : Enonces.TemoinRealisable := temoin_realisable


-- 9. Extension v3.8, lot L3 (jeux et ponts vers les métriques)
theorem principal_jeu_ind_conf : Enonces.JeuINDConf := succIND_eq
theorem principal_avantage_test : Enonces.AvantageTest := advDist_le_tv
theorem principal_neyman_pearson : Enonces.NeymanPearson := neyman_pearson
theorem principal_pont_ind_conf : Enonces.PontINDConf := ind_conf_le_conf
theorem principal_reciproque_ind_conf : Enonces.ReciproqueINDConf := tv_disjoint
theorem principal_jeu_bind_rel : Enonces.JeuBINDRel := winBindRel_bounds
theorem principal_pont_bind_rel : Enonces.PontBINDRel := relver_ge
theorem principal_ouverture_liante : Enonces.OuvertureLiante := relver_of_liant
theorem principal_relrec_conf_un : Enonces.RelrecConfUn := rel_of_conf_one
theorem principal_fano_general : Enonces.FanoGeneral := fano_general
theorem principal_info_verdict_residu : Enonces.InfoVerdictResidu := CLOModel.IV_eq_HV_sub
theorem principal_pont_ext_opp : Enonces.PontEXTOpp := CLOModel.ext_opp_bridge
theorem principal_pont_ext_opp_ressources : Enonces.PontEXTOppRessources := ext_opp_bridge_K
theorem principal_produit_jeux : Enonces.ProduitJeux := product_from_games
theorem principal_echelles_distinctes : Enonces.EchellesDistinctes := echelles_distinctes


-- 10. Extension v3.9, lot L5b (encodage classique diagonal)
theorem principal_distance_trace_tv : Enonces.DistanceTraceTV := traceDist_eq_tv
theorem principal_conf_quantique_diagonale : Enonces.ConfQuantiqueDiagonale := CLOModel.confQ_diag_eq
theorem principal_von_neumann_shannon : Enonces.VonNeumannShannon := vonNeumann_diag
theorem principal_cas_limite_lemme6 : Enonces.CasLimiteLemme6 := cas_limite_lemme6


-- 11. Extension v3.10, lot L4 (construction S-OTP)
theorem principal_masque_uniforme : Enonces.MasqueUniforme := sotp_mask_tv
theorem principal_conf_sotp : Enonces.ConfSOTP := CLOModel.conf_eq_one_of_indep
theorem principal_opp_sotp : Enonces.OppSOTP := CLOModel.sotp_opp_le
theorem principal_opp_sotp_public : Enonces.OppSOTPPublic := CLOModel.sotp_opp_zero_of_public


-- 12. Extension v3.11, lot L6 (protocoles de mesure et tableaux)
theorem principal_traits_superadditif : Enonces.TraitsSuperadditif := traits_superadditif
theorem principal_trait_statistique : Enonces.TraitStatistique := trait_stat_le
theorem principal_trait_fonction_preuve : Enonces.TraitFonctionPreuve := trait_fonction_preuve
theorem principal_trait_binaire : Enonces.TraitBinaire := trait_binaire_le
theorem principal_estimateur_masquant : Enonces.EstimateurMasquant := CLOModel.estimateur_masquant
theorem principal_estimateur_initial : Enonces.EstimateurInitial := estimateur_initial
theorem principal_estimateur_initial_exemple : Enonces.EstimateurInitialExemple := estimateur_initial_exemple
theorem principal_calibration_delta : Enonces.CalibrationDelta := calibration_delta
theorem principal_decomposition_delta : Enonces.DecompositionDelta := decomposition_delta
theorem principal_parametres_reference : Enonces.ParametresReference := parametres_reference

-- 13. Extension v3.12, lot L7 (atteinte de la borne aiguë, k traits)
theorem principal_borne_aigue_atteinte : Enonces.BorneAigueAtteinte := borne_aigue_atteinte
theorem principal_rapports_borne_aigue : Enonces.RapportsBorneAigue := rapports_borne_aigue
theorem principal_regularite_temoin : Enonces.RegulariteTemoin := regularite_temoin
theorem principal_traits_superadditif_k : Enonces.TraitsSuperadditifK := traits_superadditif_k
theorem principal_minorant_traits : Enonces.MinorantTraits := minorant_traits
theorem principal_minorant_k_bits : Enonces.MinorantKBits := minorant_k_bits

end Principal
