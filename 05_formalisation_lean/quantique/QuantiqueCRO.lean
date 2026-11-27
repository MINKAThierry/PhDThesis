/-
  Couche quantique de la cryptographie institutionnelle, version 1.1 (27 novembre 2026)
  =====================================================================================
  Auteurs : Thierry Emmanuel Minka Mi Nguidjoï,
            Flavien Serge Mani Onana,
            Thomas Djotio Ndié
  LIMSI - École Nationale Supérieure Polytechnique, Université de Yaoundé I

  OBJET
  Lot L5c de la feuille de route. Le noyau quantique de `ConditionalCRO.lean`
  (section 14) pose Pinsker quantique, Fano quantique et la borne de Holevo comme
  champs d'une instance abstraite. Ce fichier commence à fonder cette couche sur de
  vrais états quantiques (matrices densité), avec la bibliothèque Physlib (partie
  QuantumInfo, ex-Lean-QuantumInfo). Il donne les définitions quantiques du chapitre 2
  et démontre, à partir des théorèmes de Physlib, la DPI quantique de l'entropie
  relative, la positivité de l'information mutuelle conditionnelle (sous-additivité
  forte), la sous-additivité et les bornes de l'entropie de von Neumann. La version 1.1
  ajoute le canal dépolarisant (Définition 2.18).

  DÉPÔT SEULEMENT
  Physlib n'est pas chargée par live.lean-lang.org et fixe Lean et Mathlib en v4.36.0.
  Ce fichier forme donc un projet Lake distinct, vérifié par le workflow GitHub
  `verification_lean_quantique.yml`. Il ne s'importe pas dans `ConditionalCRO.lean`.

  CE QUI N'EST PAS ENCORE DANS CE FICHIER
  Pinsker quantique (Lemmes 1.4 et 2.4), mesure douce (Lemmes 1.5 et 2.5), Fano
  quantique (Lemmes 1.6 et 2.6) et borne de Holevo avec mesure de Helstrom (Lemme 2.7).
  Physlib ne les contient pas sous cette forme. Ils restent posés dans le noyau
  quantique de `ConditionalCRO.lean`.
-/

import QuantumInfo.Entropy.SSA
import QuantumInfo.Entropy.DPI
import QuantumInfo.States.Mixed.TraceDistance

noncomputable section

namespace QuantiqueCRO

/-! ## 1. Confidentialité quantique (Définitions 2.8 et 2.24)

Les lemmes de Physlib sur la distance de trace (`TrDistance.ge_zero`, `TrDistance.le_one`)
sont énoncés avec l'égalité décidable classique. Cette section ouvre donc `Classical`
et ne demande pas d'instance `DecidableEq` sur l'espace de la preuve. -/

section Confidentialite

open Classical

/-- Conf^q = 1 − max_{c, m₀, m₁} ½‖ρ^{m₀,c} − ρ^{m₁,c}‖₁, pour une famille d'états de la
    preuve indexée par le contexte et le message. -/
def confQ {C M S : Type*} [Fintype C] [Fintype M] [Nonempty C] [Nonempty M] [Fintype S]
    (ρ : C → M → MState S) : ℝ :=
  1 - (Finset.univ : Finset (C × M × M)).sup' Finset.univ_nonempty
    (fun x => TrDistance (ρ x.1 x.2.1) (ρ x.1 x.2.2))

/-- **Définitions 2.8 et 2.24.** Conf^q prend ses valeurs dans [0, 1]. -/
theorem confQ_bornes {C M S : Type*} [Fintype C] [Fintype M] [Nonempty C] [Nonempty M]
    [Fintype S] (ρ : C → M → MState S) : 0 ≤ confQ ρ ∧ confQ ρ ≤ 1 := by
  unfold confQ
  obtain ⟨x, -, hx⟩ := Finset.exists_mem_eq_sup' (Finset.univ_nonempty (α := C × M × M))
    (fun x => TrDistance (ρ x.1 x.2.1) (ρ x.1 x.2.2))
  rw [hx]
  have h0 := TrDistance.ge_zero (ρ x.1 x.2.1) (ρ x.1 x.2.2)
  have h1 := TrDistance.le_one (ρ x.1 x.2.1) (ρ x.1 x.2.2)
  constructor <;> linarith

/-- La distance de trace d'un état à lui-même est nulle. -/
theorem trDistance_self {S : Type*} [Fintype S] (σ : MState S) :
    TrDistance σ σ = 0 := by
  unfold TrDistance
  rw [sub_self, Matrix.traceNorm_zero, mul_zero]

/-- **Définition 2.8.** Une famille d'états qui ne dépend pas du message a Conf^q = 1. -/
theorem confQ_eq_one_of_indep {C M S : Type*} [Fintype C] [Fintype M] [Nonempty C]
    [Nonempty M] [Fintype S] (σ : C → MState S) :
    confQ (fun c (_ : M) => σ c) = 1 := by
  unfold confQ
  obtain ⟨x, -, hx⟩ := Finset.exists_mem_eq_sup' (Finset.univ_nonempty (α := C × M × M))
    (fun x => TrDistance (σ x.1) (σ x.1))
  have h : (Finset.univ : Finset (C × M × M)).sup' Finset.univ_nonempty
      (fun x => TrDistance (σ x.1) (σ x.1)) = 0 := by
    rw [hx]; exact trDistance_self _
  rw [h, sub_zero]

end Confidentialite

/-! ## 2. Entropies quantiques (Définitions 2.14 et 2.15) -/

variable {d d₁ d₂ d₃ : Type*} [Fintype d] [DecidableEq d] [Fintype d₁] [DecidableEq d₁]
  [Fintype d₂] [DecidableEq d₂] [Fintype d₃] [DecidableEq d₃]

/-- **Définition 2.14.** S(A|B) = S(AB) − S(B). -/
theorem entropie_conditionnelle_def (ρ : MState (d₁ × d₂)) :
    qConditionalEnt ρ = Sᵥₙ ρ - Sᵥₙ ρ.traceLeft := rfl

/-- **Définition 2.15.** I(A;B) = S(A) + S(B) − S(AB). -/
theorem information_mutuelle_def (ρ : MState (d₁ × d₂)) :
    qMutualInfo ρ = Sᵥₙ ρ.traceLeft + Sᵥₙ ρ.traceRight - Sᵥₙ ρ := rfl

/-- Bornes de l'entropie de von Neumann : 0 ≤ S(ρ) ≤ log d (nats). -/
theorem vonNeumann_bornes (ρ : MState d) :
    0 ≤ Sᵥₙ ρ ∧ Sᵥₙ ρ ≤ Real.log (Fintype.card d) := by
  refine ⟨Sᵥₙ_nonneg ρ, ?_⟩
  have h := Sᵥₙ_le_log_d ρ
  rwa [Finset.card_univ] at h

/-- **Lemme 2.8, D_max.** D(ρ̄‖I/d) = log d − S(ρ̄) est positive. -/
theorem Dmax_nonneg (ρ : MState d) : 0 ≤ Real.log (Fintype.card d) - Sᵥₙ ρ := by
  linarith [(vonNeumann_bornes ρ).2]

/-- Sous-additivité : S(AB) ≤ S(A) + S(B). -/
theorem sous_additivite (ρ : MState (d₁ × d₂)) :
    Sᵥₙ ρ ≤ Sᵥₙ ρ.traceRight + Sᵥₙ ρ.traceLeft :=
  Sᵥₙ_subadditivity ρ

/-- **Définition 2.15.** L'information mutuelle quantique est positive. -/
theorem information_mutuelle_nonneg (ρ : MState (d₁ × d₂)) : 0 ≤ qMutualInfo ρ := by
  unfold qMutualInfo
  linarith [Sᵥₙ_subadditivity ρ]

/-- Sous-additivité forte (Lieb et Ruskai) : I(A;B|C) ≥ 0. -/
theorem cmi_quantique_nonneg (ρ : MState (d₁ × d₂ × d₃)) : 0 ≤ qcmi ρ :=
  qcmi_nonneg ρ

/-- Monotonie de l'information mutuelle par oubli d'un sous-système :
    I(A;BC) ≥ I(A;B). C'est la forme de la DPI quantique, issue de la sous-additivité
    forte, sur laquelle repose la borne de Holevo (Lemme 2.7) quand la mesure est réalisée
    par une isométrie suivie d'un oubli. -/
theorem info_mutuelle_oubli (ρ : MState (d₁ × d₂ × d₃)) :
    qMutualInfo ρ.assoc'.traceRight ≤ qMutualInfo ρ :=
  qMutualInfo_strong_subadditivity ρ

/-! ## 3. DPI quantique (équation (1.14)) -/

/-- **Équation (1.14).** Pour tout canal Φ (application complètement positive qui préserve
    la trace), 𝐃(Φ(ρ)‖Φ(σ)) ≤ 𝐃(ρ‖σ). C'est l'outil de la preuve du Lemme 2.4. -/
theorem dpi_quantique (Φ : CPTPMap d₁ d₂) (ρ σ : MState d₁) : 𝐃(Φ ρ‖Φ σ) ≤ 𝐃(ρ‖σ) :=
  sandwichedRenyiEntropy_DPI le_rfl ρ σ Φ

/-! ## 4. Canal dépolarisant (Définition 2.18)

Le canal dépolarisant est le mélange convexe Δ_p = p·R + (1 − p)·id, où R est le canal de
remplacement par l'état maximalement mélangé I/d. Les mélanges de canaux sont ceux de la
structure `Mixable` de Physlib. Comme en section 1, l'égalité décidable est classique. -/

section Canaux

open Classical

variable {d : Type*} [Fintype d] [Nonempty d]

/-- **Définition 2.18.** Canal dépolarisant Δ_p(ρ) = p·I/d + (1 − p)·ρ. -/
def depolarisant (p : Prob) : CPTPMap d d :=
  p [CPTPMap.replacement MState.uniform ↔ CPTPMap.id]

/-- Valeurs extrêmes : Δ_1 remplace tout état par I/d, Δ_0 est l'identité. -/
theorem depolarisant_extremes :
    depolarisant (d := d) 1 = CPTPMap.replacement MState.uniform ∧
      depolarisant (d := d) 0 = CPTPMap.id :=
  ⟨Mixable.mix_one _ _, Mixable.mix_zero _ _⟩

/-- **Définition 2.18.** Après une dépolarisation totale, la sortie ne dépend plus de la
    preuve et Conf^q = 1. -/
theorem conf_depolarisation_totale {C M : Type*} [Fintype C] [Fintype M] [Nonempty C]
    [Nonempty M] (ρ : C → M → MState d) :
    confQ (fun c m => depolarisant (d := d) 1 (ρ c m)) = 1 := by
  rw [depolarisant_extremes.1]
  simp only [CPTPMap.replacement_apply]
  exact confQ_eq_one_of_indep (M := M) (fun _ => MState.uniform)

end Canaux

/-! ## 5. Canaux définis par opérateurs de Kraus (Définitions 2.19 à 2.21)

Chaque canal est construit par `CPTPMap.of_kraus_CPTPMap` de Physlib, qui demande la
normalisation Σ_k K_kᴴ K_k = I. Cette normalisation est démontrée pour chaque canal. -/

section Kraus

/-- Opérateurs de Kraus du canal d'amortissement d'amplitude (Définition 2.19). -/
def krausAD (g : ℝ) : Fin 2 → Matrix (Fin 2) (Fin 2) ℂ :=
  ![!![1, 0; 0, ((Real.sqrt (1 - g) : ℝ) : ℂ)], !![0, ((Real.sqrt g : ℝ) : ℂ); 0, 0]]

/-- **Définition 2.19.** Normalisation des opérateurs d'amortissement, E₀ᴴE₀ + E₁ᴴE₁ = I. -/
theorem krausAD_normalise (g : ℝ) (h0 : 0 ≤ g) (h1 : g ≤ 1) :
    ∑ k, (krausAD g k).conjTranspose * krausAD g k = 1 := by
  have hs : ((Real.sqrt (1 - g) : ℝ) : ℂ) * ((Real.sqrt (1 - g) : ℝ) : ℂ) = ((1 - g : ℝ) : ℂ) := by
    rw [← Complex.ofReal_mul, Real.mul_self_sqrt (by linarith)]
  have hg : ((Real.sqrt g : ℝ) : ℂ) * ((Real.sqrt g : ℝ) : ℂ) = ((g : ℝ) : ℂ) := by
    rw [← Complex.ofReal_mul, Real.mul_self_sqrt h0]
  rw [Fin.sum_univ_two]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [krausAD, Matrix.mul_apply, Fin.sum_univ_two, Matrix.conjTranspose_apply, hs, hg]

/-- **Définition 2.19.** Canal d'amortissement d'amplitude de paramètre g ∈ [0, 1]. -/
def amortissement (g : ℝ) (h0 : 0 ≤ g) (h1 : g ≤ 1) : CPTPMap (Fin 2) (Fin 2) :=
  CPTPMap.of_kraus_CPTPMap (krausAD g) (krausAD_normalise g h0 h1)

/-- Matrice de Pauli Z. -/
def pauliZ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- Opérateurs de Kraus du canal de déphasage (Définition 2.20) : √(1 − p)·I et √p·Z. -/
def krausPh (p : ℝ) : Fin 2 → Matrix (Fin 2) (Fin 2) ℂ :=
  ![((Real.sqrt (1 - p) : ℝ) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ),
    ((Real.sqrt p : ℝ) : ℂ) • pauliZ]

/-- **Définition 2.20.** Normalisation des opérateurs de déphasage, (1 − p)·I + p·ZᴴZ = I. -/
theorem krausPh_normalise (p : ℝ) (h0 : 0 ≤ p) (h1 : p ≤ 1) :
    ∑ k, (krausPh p k).conjTranspose * krausPh p k = 1 := by
  have hs : ((Real.sqrt (1 - p) : ℝ) : ℂ) * ((Real.sqrt (1 - p) : ℝ) : ℂ) = ((1 - p : ℝ) : ℂ) := by
    rw [← Complex.ofReal_mul, Real.mul_self_sqrt (by linarith)]
  have hp : ((Real.sqrt p : ℝ) : ℂ) * ((Real.sqrt p : ℝ) : ℂ) = ((p : ℝ) : ℂ) := by
    rw [← Complex.ofReal_mul, Real.mul_self_sqrt h0]
  rw [Fin.sum_univ_two]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [krausPh, pauliZ, Matrix.mul_apply, Fin.sum_univ_two, Matrix.conjTranspose_apply,
      Matrix.smul_apply, hs, hp]

/-- **Définition 2.20.** Canal de déphasage de paramètre p ∈ [0, 1]. -/
def dephasage (p : ℝ) (h0 : 0 ≤ p) (h1 : p ≤ 1) : CPTPMap (Fin 2) (Fin 2) :=
  CPTPMap.of_kraus_CPTPMap (krausPh p) (krausPh_normalise p h0 h1)

variable {d : Type*} [Fintype d] [DecidableEq d]

/-- Opérateurs de Kraus du canal d'effacement (Définition 2.21), de d vers d ⊕ {⊥}
    (codé `Option d`, `none` = ⊥) : K_⊥ = √(1 − e)·(plongement) et K_k = √e·|⊥⟩⟨k|. -/
def krausEr (e : ℝ) : Option d → Matrix (Option d) d ℂ
  | none => Matrix.of fun o j => if o = some j then ((Real.sqrt (1 - e) : ℝ) : ℂ) else 0
  | some k => Matrix.of fun o j => if o = none ∧ j = k then ((Real.sqrt e : ℝ) : ℂ) else 0

/-- **Définition 2.21.** Normalisation des opérateurs d'effacement, Σ_κ K_κᴴ K_κ = I. -/
theorem krausEr_normalise (e : ℝ) (h0 : 0 ≤ e) (h1 : e ≤ 1) :
    ∑ k, (krausEr (d := d) e k).conjTranspose * krausEr e k = 1 := by
  have hs : ((Real.sqrt (1 - e) : ℝ) : ℂ) * ((Real.sqrt (1 - e) : ℝ) : ℂ) = ((1 - e : ℝ) : ℂ) := by
    rw [← Complex.ofReal_mul, Real.mul_self_sqrt (by linarith)]
  have he : ((Real.sqrt e : ℝ) : ℂ) * ((Real.sqrt e : ℝ) : ℂ) = ((e : ℝ) : ℂ) := by
    rw [← Complex.ofReal_mul, Real.mul_self_sqrt h0]
  ext a b
  rw [Matrix.sum_apply, Fintype.sum_option]
  by_cases hab : a = b
  · subst hab
    simp [krausEr, Matrix.mul_apply, Matrix.conjTranspose_apply, Matrix.of_apply, Fintype.sum_option,
      hs, he]
  · simp [krausEr, Matrix.mul_apply, Matrix.conjTranspose_apply, Matrix.of_apply, Fintype.sum_option,
      hab]

/-- **Définition 2.21.** Canal d'effacement de paramètre e ∈ [0, 1]. -/
def effacement (e : ℝ) (h0 : 0 ≤ e) (h1 : e ≤ 1) : CPTPMap d (Option d) :=
  CPTPMap.of_kraus_CPTPMap (krausEr e) (krausEr_normalise e h0 h1)

end Kraus

end QuantiqueCRO

/-! ## Bloc de vérification -/

#print axioms QuantiqueCRO.confQ_bornes
#print axioms QuantiqueCRO.trDistance_self
#print axioms QuantiqueCRO.confQ_eq_one_of_indep
#print axioms QuantiqueCRO.entropie_conditionnelle_def
#print axioms QuantiqueCRO.information_mutuelle_def
#print axioms QuantiqueCRO.vonNeumann_bornes
#print axioms QuantiqueCRO.Dmax_nonneg
#print axioms QuantiqueCRO.sous_additivite
#print axioms QuantiqueCRO.information_mutuelle_nonneg
#print axioms QuantiqueCRO.cmi_quantique_nonneg
#print axioms QuantiqueCRO.info_mutuelle_oubli
#print axioms QuantiqueCRO.dpi_quantique
#print axioms QuantiqueCRO.depolarisant_extremes
#print axioms QuantiqueCRO.conf_depolarisation_totale
#print axioms QuantiqueCRO.krausAD_normalise
#print axioms QuantiqueCRO.krausPh_normalise
#print axioms QuantiqueCRO.krausEr_normalise
