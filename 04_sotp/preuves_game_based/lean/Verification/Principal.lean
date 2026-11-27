/-
  Dossier de vérification. Point d'entrée mince
  =============================================
  Une ligne par énoncé de `Enonces.lean`. Chaque ligne affirme que le théorème
  existant de `GameBasedSOTP.lean` (version 1.2) prouve exactement l'énoncé écrit
  séparément. Si un énoncé et sa preuve divergent, ce fichier ne compile pas.
  Le script `verifier.sh` exécute `#print axioms` sur chaque théorème ci-dessous.
-/

import Verification.Enonces

namespace Principal

open GameBasedSOTP

-- 1. Confidentialité de la couche Gold
theorem principal_masque_jetable : Enonces.MasqueJetable := otp_uniform
theorem principal_reduction_prg : Enonces.ReductionPRG := ind_conf_eq_prg
theorem principal_masque_parfait : Enonces.MasqueParfait := ind_conf_perfect_otp

-- 2. Fiabilité de vérification
theorem principal_extraction_pedersen : Enonces.ExtractionPedersen := pedersen_extract
theorem principal_reduction_dlog : Enonces.ReductionDLOG := bind_rel_gives_dlog
theorem principal_gain_bind_rel : Enonces.GainBINDRel := win_bind_le_dlog


-- 3. Bornes complètes et masque par troncature (version 1.2)
theorem principal_conf_sotp_low_complete : Enonces.ConfSOTPLowComplete := ind_conf_complet
theorem principal_rel_sotp_low_complete : Enonces.RelSOTPLowComplete := win_bind_complet
theorem principal_loi_troncature : Enonces.LoiTroncature := card_mod_eq
theorem principal_distance_troncature : Enonces.DistanceTroncature := trunc_dist
theorem principal_borne_troncature : Enonces.BorneTroncature := trunc_bound
theorem principal_troncature_ecdsa : Enonces.TroncatureECDSA := trunc_ecdsa

end Principal
