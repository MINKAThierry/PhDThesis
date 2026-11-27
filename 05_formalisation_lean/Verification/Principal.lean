/-
  Dossier de vérification. Point d'entrée mince
  =============================================
  Une ligne par énoncé de `Enonces.lean`. Chaque ligne affirme que le théorème
  existant de `ConditionalCRO.lean` (version 3.5) prouve exactement
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

end Principal
