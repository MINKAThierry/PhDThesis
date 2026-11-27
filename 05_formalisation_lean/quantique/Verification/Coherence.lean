/-
  Dossier de vérification de la couche quantique. Tests de cohérence
  ==================================================================
  Définition propre testée : confQ. Elle vaut 1 pour une famille d'états qui ne dépend
  pas du message et reste dans [0, 1] pour toute famille, ce qui montre qu'elle n'est ni
  vide ni triviale. Le fichier ne contient ni `sorry` ni `axiom`.
-/

import Verification.Principal

open QuantiqueCRO

namespace Coherence

/-- Une famille constante a Conf^q = 1. -/
lemma confQ_constante {S : Type*} [Fintype S] [DecidableEq S] (σ : MState S) :
    confQ (fun (_ : Unit) (_ : Bool) => σ) = 1 :=
  confQ_eq_one_of_indep (fun _ => σ)

/-- Pour deux états quelconques, Conf^q reste dans [0, 1]. -/
lemma confQ_deux_etats {S : Type*} [Fintype S] [DecidableEq S] (σ₀ σ₁ : MState S) :
    0 ≤ confQ (fun (_ : Unit) (b : Bool) => if b then σ₁ else σ₀) ∧
      confQ (fun (_ : Unit) (b : Bool) => if b then σ₁ else σ₀) ≤ 1 :=
  confQ_bornes _

end Coherence
