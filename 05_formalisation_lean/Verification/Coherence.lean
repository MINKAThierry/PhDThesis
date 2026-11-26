/-
  Dossier de vérification. Tests de cohérence des définitions propres
  ===================================================================
  Une définition propre peut être vide ou triviale, ce qui rendrait sans portée
  un théorème qui l'emploie. Ce fichier montre, pour chaque définition propre de
  `ConditionalCRO.lean` (version 3.4, non modifié), un cas qui la satisfait et
  un cas qui ne la satisfait pas, ou deux valeurs extrêmes calculées sur des lois
  explicites. Il ne contient ni `sorry` ni `axiom`.

  Définitions testées : γ = αH(C) − 1, InstitutionalParams,
  InstitutionalAssumptions, tv, klN, miN, CLOModel, Conf, Rel et Opp.
  La section 5 montre que les hypothèses imposent H(V|C) ≥ 1, ce qui exclut la
  division par zéro dans Opp (en Lean, x/0 = 0).
-/

import ConditionalCRO

open Real Finset
open ConditionalCRO ConditionalCRO.CLOModel

namespace Coherence

/-! ## 1. γ = αH(C) − 1 et InstitutionalParams (Hypothèse 2.2, p. 56) -/

/-- γ est bien αH(C) − 1, par définition. -/
lemma gamma_eq (p : InstitutionalParams) : gamma p = p.α * p.H - 1 := rfl

/-- Cas qui satisfait γ ≥ 1 : Helios, γ = 1,2 × 40 − 1 = 47. -/
lemma gamma_helios : gamma HeliosParams = 47 := by
  simp only [gamma, HeliosParams]; norm_num

/-- Paramètres admissibles dont γ = 0 : H(C) = 1 et α = 1. -/
noncomputable def ParamsGammaNul : InstitutionalParams :=
  { H := 1, Δ := 0, α := 1, β := 1,
    hH_nonneg := by norm_num, hΔ_nonneg := le_refl _,
    hα_pos := by norm_num, hβ_ge_one := le_refl _ }

/-- Cas qui ne satisfait pas γ ≥ 1 (condition de l'Hypothèse 2.2). -/
lemma gamma_nul_ne_satisfait_pas : gamma ParamsGammaNul = 0 ∧ ¬ (1 ≤ gamma ParamsGammaNul) := by
  simp only [gamma, ParamsGammaNul]; norm_num

/-- InstitutionalParams n'est pas vide (Helios). -/
lemma params_non_vide : ∃ p : InstitutionalParams, p.Δ = 56 ∧ p.β = 1.4 :=
  ⟨HeliosParams, rfl, rfl⟩

/-- InstitutionalParams exclut α = 0, β < 1 et Δ < 0. -/
lemma params_exclus :
    (¬ ∃ p : InstitutionalParams, p.α = 0) ∧
    (¬ ∃ p : InstitutionalParams, p.β < 1) ∧
    (¬ ∃ p : InstitutionalParams, p.Δ < 0) := by
  refine ⟨?_, ?_, ?_⟩
  · rintro ⟨p, h⟩; linarith [p.hα_pos]
  · rintro ⟨p, h⟩; linarith [p.hβ_ge_one]
  · rintro ⟨p, h⟩; linarith [p.hΔ_nonneg]

/-! ## 2. Variation totale, divergence et information mutuelle sur lois finies -/

/-- Deux lois identiques : tv = 0. -/
lemma tv_self {α : Type*} [Fintype α] (P : α → ℝ) : tv P P = 0 := by
  simp [tv]

/-- Deux masses de Dirac disjointes : tv = 1, la valeur maximale. -/
lemma tv_dirac :
    tv (fun i : Fin 2 => if i = 0 then (1 : ℝ) else 0)
       (fun i : Fin 2 => if i = 1 then (1 : ℝ) else 0) = 1 := by
  simp [tv, Fin.sum_univ_two]

/-- Divergence d'une loi à elle-même : 0. -/
lemma klN_self {α : Type*} [Fintype α] (P : α → ℝ) : klN P P = 0 := by
  unfold klN
  apply sum_eq_zero
  intro a _
  by_cases h : P a = 0
  · simp [h]
  · rw [div_self h, Real.log_one, mul_zero]

/-- Deux bits indépendants uniformes : information mutuelle nulle. -/
lemma miN_independants : miN (fun _ _ : Fin 2 => (1 / 4 : ℝ)) = 0 := by
  simp only [miN, Fin.sum_univ_two]
  norm_num

/-- Un bit uniforme recopié : information mutuelle log 2 (un bit). -/
lemma miN_copie :
    miN (fun a b : Fin 2 => if a = b then (1 / 2 : ℝ) else 0) = Real.log 2 := by
  simp only [miN, Fin.sum_univ_two]
  norm_num
  ring

/-! ## 3. CLOModel : une loi qui satisfait, deux lois qui ne satisfont pas -/

/-- Loi à un contexte où la preuve recopie le message (λ = 1) et le verdict
    recopie la preuve. C'est une loi admissible qui révèle tout. -/
noncomputable def copyModel : CLOModel 1 (Fin 2) (Fin 1) (Fin 2) (Fin 2) where
  P := fun _ m s => if s = m then 1 / 2 else 0
  P_nonneg := fun _ _ _ => by split_ifs <;> norm_num
  P_sum := by simp
  card_M := by simp
  unif := fun _ m => by fin_cases m <;> simp
  ker := fun _ s v => if v = s then 1 else 0
  ker_nonneg := fun _ _ _ => by split_ifs <;> norm_num
  ker_sum := fun _ s => by simp

/-- Une loi où M n'est pas uniforme (M = 0 presque sûrement) n'est pas un
    CLOModel : l'hypothèse d'uniformité est effective. -/
lemma pas_de_modele_non_uniforme :
    ¬ ∃ X : CLOModel 1 (Fin 2) (Fin 1) (Fin 2) (Fin 2),
      ∀ c m s, X.P c m s = if m = 0 then 1 / 2 else 0 := by
  rintro ⟨X, hX⟩
  have h := X.unif 0 1
  simp only [hX, Fin.sum_univ_two, Fintype.card_fin] at h
  norm_num at h

/-- Un message à 2 valeurs ne peut pas porter λ = 2 bits : card_M est effective. -/
lemma pas_de_modele_mauvais_cardinal :
    IsEmpty (CLOModel 2 (Fin 2) (Fin 1) (Fin 2) (Fin 2)) :=
  ⟨fun X => by have h := X.card_M; simp at h⟩

/-! ## 4. Conf, Rel et Opp prennent leurs valeurs extrêmes sur des lois explicites -/

lemma copy_qS (c : Fin 1) (m s : Fin 2) :
    copyModel.qS c m s = if s = m then 1 else 0 := by
  fin_cases m <;> fin_cases s <;> simp [qS, copyModel]

/-- Conf = 0 quand la preuve révèle le message (cas qui ne satisfait pas la
    confidentialité). -/
lemma copy_Conf : copyModel.Conf = 0 := by
  have hTV : copyModel.TV (0, 0, 1) = 1 := by
    simp [TV, tv, copy_qS, Fin.sum_univ_two]
  have hmax : copyModel.TVmax = 1 := by
    apply le_antisymm copyModel.TVmax_le_one
    rw [← hTV]
    exact le_sup' copyModel.TV (mem_univ _)
  simp [Conf, hmax]

/-- Rel = 1 pour le décodeur qui lit la preuve. -/
lemma copy_Rel : copyModel.Rel (fun _ s => s) = 1 := by
  simp [CLOModel.Rel, copyModel]

lemma fam_qS (l : ℕ) (c : Fin 2) (m : Fin (2 ^ l)) (s : Fin 2) :
    (famModel l).qS c m s = 1 / 2 := by
  simp only [qS, fam_P, Fin.sum_univ_two]
  field_simp
  ring

/-- Conf = 1 quand la preuve est indépendante du message (cas qui satisfait). -/
lemma fam_Conf (l : ℕ) : (famModel l).Conf = 1 := by
  have h0 : (famModel l).TVmax ≤ 0 := by
    apply sup'_le
    intro x _
    simp [TV, tv, fam_qS]
  have h1 := (famModel l).TVmax_nonneg
  simp [Conf, le_antisymm h0 h1]

/-- Rel = 2^(−λ) pour un décodeur constant quand I(M;Σ|C) = 0
    (Remarque 3.10, p. 114). -/
lemma fam_Rel (l : ℕ) :
    (famModel l).Rel (fun _ _ => ⟨0, Nat.two_pow_pos l⟩) = 1 / 2 ^ l := by
  simp only [CLOModel.Rel, fam_P, Fin.sum_univ_two, sum_add_distrib, sum_ite_eq, mem_univ,
    ite_true]
  field_simp
  ring

/-- Opp = 1 pour le verdict qui recopie la preuve (verdict déterministe). -/
lemma fam_Opp (l : ℕ) : (famModel l).Opp = 1 := by
  simp [Opp, fam_IV, fam_HV]

/-- Même loi que famModel, mais le verdict est tiré au hasard sans lire la
    preuve : interprétation admissible sans contenu (Remarque 3.9, p. 108). -/
noncomputable def blindModel (l : ℕ) : CLOModel l (Fin (2 ^ l)) (Fin 2) (Fin 2) (Fin 2) :=
  { famModel l with
    ker := fun _ _ _ => 1 / 2
    ker_nonneg := fun _ _ _ => by norm_num
    ker_sum := fun _ _ => by simp }

lemma blind_qSV (l : ℕ) (c s v : Fin 2) : (blindModel l).qSV c s v = 1 / 4 := by
  show (∑ m, (famModel l).qMS c m s) * (1 / 2) = 1 / 4
  rw [fam_colS]; norm_num

lemma blind_pC (l : ℕ) (c : Fin 2) : (blindModel l).pC c = 1 / 2 := fam_pC l c

lemma blind_IV (l : ℕ) : (blindModel l).IV = 0 := by
  simp only [IV, miN, blind_qSV, Fin.sum_univ_two]
  norm_num

/-- H(V|C) = 1 bit : l'opposabilité nulle ne vient pas d'une division par zéro. -/
lemma blind_HV (l : ℕ) : (blindModel l).HV = 1 := by
  have hl2 : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  simp only [HV, entN2, blind_qSV, blind_pC, Fin.sum_univ_two]
  norm_num
  simp only [one_div, Real.log_inv]
  field_simp
  ring

/-- Opp = 0 pour le verdict qui n'utilise pas la preuve (cas qui ne satisfait
    pas l'opposabilité). -/
lemma blind_Opp (l : ℕ) : (blindModel l).Opp = 0 := by
  simp [Opp, blind_IV]

/-! ## 5. Les hypothèses imposent H(V|C) ≥ 1, donc pas de division par zéro -/

/-- En Lean, x/0 = 0. Sans hypothèse, Opp = IV/HV vaudrait 0 pour HV = 0. -/
lemma division_par_zero : (1 : ℝ) / 0 = 0 := div_zero 1

/-- Modèle abstrait : les Hypothèses 2.2 (γ ≤ H(V|C)) et γ ≥ 1 donnent
    H(V|C) ≥ 1, puis Opp·H(V|C) = I(V;Σ|C). -/
lemma HV_ge_one {lam : ℕ} (P : ProtocolInstance lam) (hA : InstitutionalAssumptions P) :
    1 ≤ P.HV ∧ P.Opp * P.HV = P.IV := by
  have h : 1 ≤ P.HV := hA.A2γ.trans hA.A2
  refine ⟨h, ?_⟩
  rw [P.hOpp]
  exact div_mul_cancel₀ _ (by linarith)

/-- Couche concrète : même conclusion avec γ = α·H(C) − 1 tiré de la loi. -/
lemma HV_ge_one_concret {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C] [Fintype S]
    [Fintype V] (X : CLOModel lam M C S V) (α : ℝ)
    (A2 : α * X.HC - 1 ≤ X.HV) (A2γ : 1 ≤ α * X.HC - 1) :
    1 ≤ X.HV ∧ X.Opp * X.HV = X.IV := by
  have h : 1 ≤ X.HV := A2γ.trans A2
  refine ⟨h, ?_⟩
  unfold Opp
  exact div_mul_cancel₀ _ (by linarith)

/-- Instance dégénérée : H(V|C) = 0 et I(V;Σ|C) = 1, d'où Opp = 1/0 = 0. -/
noncomputable def degenerateInstance (lam : ℕ) : ProtocolInstance lam :=
  { params := WitnessParams, Conf := 1, Rel := 0, Opp := 0, I := 0,
    IV := 1, HV := 0, TVmax := 0, KLmax := 0,
    hConf := by norm_num, hOpp := by norm_num, hTV := by norm_num,
    hRel := by norm_num, hI := le_refl _, hIV := by norm_num,
    pinsker := by norm_num, fano := by norm_num }

/-- L'instance dégénérée est exclue par les hypothèses (cas qui ne satisfait
    pas InstitutionalAssumptions). Le témoin de cohérence du code B.1
    (ligne 322) fournit le cas qui les satisfait. -/
lemma degenere_exclu (lam : ℕ) : ¬ InstitutionalAssumptions (degenerateInstance lam) := by
  intro hA
  have := (HV_ge_one _ hA).1
  norm_num [degenerateInstance] at this

/-- Le cas qui satisfait InstitutionalAssumptions, rappelé du code B.1. -/
lemma temoin_satisfait (lam : ℕ) (hlam : 1 ≤ lam) :
    InstitutionalAssumptions (witnessInstance lam hlam) :=
  (assumptions_consistent_and_bound_attained lam hlam).1

end Coherence
