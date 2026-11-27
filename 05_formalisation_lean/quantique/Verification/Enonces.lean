/-
  Dossier de vérification de la couche quantique. Fichier des énoncés seuls
  ========================================================================
  Ce fichier ne contient AUCUNE preuve. Chaque énoncé démontré dans
  `QuantiqueCRO.lean` (version 1.1) y est écrit sous la forme `def X : Prop := ...`,
  avec son renvoi au manuscrit v36. `Principal.lean` relie chaque énoncé au théorème.
  Il importe le module `QuantiqueCRO`, qui importe Physlib (QuantumInfo).
-/

import QuantiqueCRO

open Classical

universe u₁ u₂ u₃

namespace Enonces

/-- Définitions 2.8 (p. 52) et 2.24 (p. 73) : Conf^q ∈ [0, 1]. -/
def ConfQuantiqueBornes : Prop :=
  ∀ {C : Type u₁} {M : Type u₂} {S : Type u₃} [Fintype C] [Fintype M] [Nonempty C]
    [Nonempty M] [Fintype S] (ρ : C → M → MState S),
    0 ≤ QuantiqueCRO.confQ ρ ∧ QuantiqueCRO.confQ ρ ≤ 1

/-- Définition 2.8 (p. 52) : une famille d'états indépendante du message a Conf^q = 1. -/
def ConfQuantiqueIndependante : Prop :=
  ∀ {C : Type u₁} {M : Type u₂} {S : Type u₃} [Fintype C] [Fintype M] [Nonempty C]
    [Nonempty M] [Fintype S] (σ : C → MState S),
    QuantiqueCRO.confQ (fun c (_ : M) => σ c) = 1

/-- Définition 2.14 (p. 69) : S(A|B) = S(AB) − S(B). -/
def EntropieConditionnelle : Prop :=
  ∀ {d₁ : Type u₁} {d₂ : Type u₂} [Fintype d₁] [DecidableEq d₁] [Fintype d₂] [DecidableEq d₂]
    (ρ : MState (d₁ × d₂)), qConditionalEnt ρ = Sᵥₙ ρ - Sᵥₙ ρ.traceLeft

/-- Définition 2.15 (p. 69) : I(A;B) = S(A) + S(B) − S(AB). -/
def InformationMutuelle : Prop :=
  ∀ {d₁ : Type u₁} {d₂ : Type u₂} [Fintype d₁] [DecidableEq d₁] [Fintype d₂] [DecidableEq d₂]
    (ρ : MState (d₁ × d₂)), qMutualInfo ρ = Sᵥₙ ρ.traceLeft + Sᵥₙ ρ.traceRight - Sᵥₙ ρ

/-- Chapitre 1, section 1.3.2.1 (p. 18) : 0 ≤ S(ρ) ≤ log d. -/
def VonNeumannBornes : Prop :=
  ∀ {d : Type u₁} [Fintype d] [DecidableEq d] (ρ : MState d),
    0 ≤ Sᵥₙ ρ ∧ Sᵥₙ ρ ≤ Real.log (Fintype.card d)

/-- Lemme 2.8 (p. 77) : D_max = log d − S(ρ̄) ≥ 0. -/
def DmaxPositif : Prop :=
  ∀ {d : Type u₁} [Fintype d] [DecidableEq d] (ρ : MState d),
    0 ≤ Real.log (Fintype.card d) - Sᵥₙ ρ

/-- Sous-additivité de l'entropie de von Neumann. -/
def SousAdditivite : Prop :=
  ∀ {d₁ : Type u₁} {d₂ : Type u₂} [Fintype d₁] [DecidableEq d₁] [Fintype d₂] [DecidableEq d₂]
    (ρ : MState (d₁ × d₂)), Sᵥₙ ρ ≤ Sᵥₙ ρ.traceRight + Sᵥₙ ρ.traceLeft

/-- Définition 2.15 (p. 69) : I(A;B) ≥ 0. -/
def InformationMutuellePositive : Prop :=
  ∀ {d₁ : Type u₁} {d₂ : Type u₂} [Fintype d₁] [DecidableEq d₁] [Fintype d₂] [DecidableEq d₂]
    (ρ : MState (d₁ × d₂)), 0 ≤ qMutualInfo ρ

/-- Sous-additivité forte : I(A;B|C) ≥ 0. -/
def CMIQuantiquePositive : Prop :=
  ∀ {d₁ : Type u₁} {d₂ : Type u₂} {d₃ : Type u₃} [Fintype d₁] [DecidableEq d₁] [Fintype d₂]
    [DecidableEq d₂] [Fintype d₃] [DecidableEq d₃] (ρ : MState (d₁ × d₂ × d₃)), 0 ≤ qcmi ρ

/-- Chapitre 1, section 1.3.2.3 (p. 19) et Lemme 2.7 (p. 71), étape : I(A;BC) ≥ I(A;B). -/
def InfoMutuelleOubli : Prop :=
  ∀ {d₁ : Type u₁} {d₂ : Type u₂} {d₃ : Type u₃} [Fintype d₁] [DecidableEq d₁] [Fintype d₂]
    [DecidableEq d₂] [Fintype d₃] [DecidableEq d₃] (ρ : MState (d₁ × d₂ × d₃)),
    qMutualInfo ρ.assoc'.traceRight ≤ qMutualInfo ρ

/-- Équation (1.14) (p. 18) : DPI quantique de l'entropie relative. -/
def DPIQuantique : Prop :=
  ∀ {d₁ : Type u₁} {d₂ : Type u₂} [Fintype d₁] [DecidableEq d₁] [Fintype d₂] [DecidableEq d₂]
    (Φ : CPTPMap d₁ d₂) (ρ σ : MState d₁), 𝐃(Φ ρ‖Φ σ) ≤ 𝐃(ρ‖σ)


/-- Définition 2.18 (p. 72) : Δ_1 est le remplacement par I/d et Δ_0 l'identité. -/
def DepolarisantExtremes : Prop :=
  ∀ {d : Type u₁} [Fintype d] [Nonempty d],
    QuantiqueCRO.depolarisant (d := d) 1 = CPTPMap.replacement MState.uniform ∧
      QuantiqueCRO.depolarisant (d := d) 0 = CPTPMap.id

/-- Définition 2.18 (p. 72) : après une dépolarisation totale, Conf^q = 1. -/
def ConfDepolarisationTotale : Prop :=
  ∀ {d : Type u₁} {C : Type u₂} {M : Type u₃} [Fintype d] [Nonempty d] [Fintype C] [Fintype M]
    [Nonempty C] [Nonempty M] (ρ : C → M → MState d),
    QuantiqueCRO.confQ (fun c m => QuantiqueCRO.depolarisant (d := d) 1 (ρ c m)) = 1

end Enonces
