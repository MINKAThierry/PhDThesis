/-
  Dossier de vérification de la couche quantique. Tests de cohérence
  ==================================================================
  Définitions propres testées : confQ, puis (version 1.2) krausAD et krausEr. Elle vaut 1 pour une famille d'états qui ne dépend
  pas du message et reste dans [0, 1] pour toute famille, ce qui montre qu'elle n'est ni
  vide ni triviale. Le fichier ne contient ni `sorry` ni `axiom`.
-/

import Verification.Principal

open QuantiqueCRO Classical

namespace Coherence

/-- Une famille constante a Conf^q = 1. -/
lemma confQ_constante {S : Type*} [Fintype S] (σ : MState S) :
    confQ (fun (_ : Unit) (_ : Bool) => σ) = 1 :=
  confQ_eq_one_of_indep (fun _ => σ)

/-- Pour deux états quelconques, Conf^q reste dans [0, 1]. -/
lemma confQ_deux_etats {S : Type*} [Fintype S] (σ₀ σ₁ : MState S) :
    0 ≤ confQ (fun (_ : Unit) (b : Bool) => if b then σ₁ else σ₀) ∧
      confQ (fun (_ : Unit) (b : Bool) => if b then σ₁ else σ₀) ≤ 1 :=
  confQ_bornes _


/-- `krausAD` : pour g = 0, le second opérateur est nul (pas d'amortissement). -/
lemma krausAD_sans_amortissement : krausAD 0 1 = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [krausAD]

/-- `krausEr` : pour e = 1, l'opérateur qui conserve l'état est nul (effacement certain). -/
lemma krausEr_effacement_certain {d : Type*} [Fintype d] [DecidableEq d] :
    krausEr (d := d) 1 none = 0 := by
  ext o j
  simp [krausEr]

end Coherence
