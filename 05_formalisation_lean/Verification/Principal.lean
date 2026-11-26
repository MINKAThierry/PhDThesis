/-
  Dossier de vérification. Point d'entrée mince
  =============================================
  Une ligne par énoncé de `Enonces.lean`. Chaque ligne affirme que le théorème
  existant de `ConditionalCRO.lean` (version 3.4, non modifié) prouve exactement
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

end Principal
