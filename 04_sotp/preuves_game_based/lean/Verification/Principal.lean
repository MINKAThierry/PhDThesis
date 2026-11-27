/-
  Dossier de vérification. Point d'entrée mince
  =============================================
  Une ligne par énoncé de `Enonces.lean`. Chaque ligne affirme que le théorème
  existant de `GameBasedSOTP.lean` (version 1.1) prouve exactement l'énoncé écrit
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

end Principal
