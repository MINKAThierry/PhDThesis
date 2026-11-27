/-
  Dossier de vérification de la couche quantique. Point d'entrée mince
  ====================================================================
  Une ligne par énoncé de `Enonces.lean`. Chaque ligne affirme que le théorème de
  `QuantiqueCRO.lean` (version 1.1) prouve exactement l'énoncé écrit séparément.
-/

import Verification.Enonces

namespace Principal

open QuantiqueCRO

theorem principal_conf_quantique_bornes : Enonces.ConfQuantiqueBornes := confQ_bornes
theorem principal_conf_quantique_independante : Enonces.ConfQuantiqueIndependante := confQ_eq_one_of_indep
theorem principal_entropie_conditionnelle : Enonces.EntropieConditionnelle := entropie_conditionnelle_def
theorem principal_information_mutuelle : Enonces.InformationMutuelle := information_mutuelle_def
theorem principal_von_neumann_bornes : Enonces.VonNeumannBornes := vonNeumann_bornes
theorem principal_dmax_positif : Enonces.DmaxPositif := Dmax_nonneg
theorem principal_sous_additivite : Enonces.SousAdditivite := sous_additivite
theorem principal_information_mutuelle_positive : Enonces.InformationMutuellePositive := information_mutuelle_nonneg
theorem principal_cmi_quantique_positive : Enonces.CMIQuantiquePositive := cmi_quantique_nonneg
theorem principal_info_mutuelle_oubli : Enonces.InfoMutuelleOubli := info_mutuelle_oubli
theorem principal_dpi_quantique : Enonces.DPIQuantique := dpi_quantique

theorem principal_depolarisant_extremes : Enonces.DepolarisantExtremes := depolarisant_extremes
theorem principal_conf_depolarisation_totale : Enonces.ConfDepolarisationTotale := conf_depolarisation_totale

end Principal
