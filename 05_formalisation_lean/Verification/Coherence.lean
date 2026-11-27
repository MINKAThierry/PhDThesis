/-
  Dossier de vérification. Tests de cohérence des définitions propres
  ===================================================================
  Une définition propre peut être vide ou triviale, ce qui rendrait sans portée
  un théorème qui l'emploie. Ce fichier montre, pour chaque définition propre de
  `ConditionalCRO.lean` (version 3.9), un cas qui la satisfait et
  un cas qui ne la satisfait pas, ou deux valeurs extrêmes calculées sur des lois
  explicites. Il ne contient ni `sorry` ni `axiom`.

  Définitions testées : γ = αH(C) − 1, InstitutionalParams,
  InstitutionalAssumptions, tv, klN, miN, CLOModel, Conf, Rel et Opp, puis
  (section 6, version 3.5) entN1, condMI, HS, IVM, IVSM, IVpost, post,
  constVerdict et detVerdict, puis (section 7, version 3.6) gammaQ,
  QuantumProtocolInstance, QuantumAssumptions, QuantumProtocolFamily, deltaQ
  et etaQ, puis (section 8, version 3.7) bProd, QuantumSharpInstance et
  witModel, puis (section 9, version 3.8) advDist, succIND, relver,
  winBindRel, binEntN et condEnt, enfin (section 10, version 3.9) shannon,
  vonNeumann, traceDistDiag et ConfQdiag.
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

/-! ## 6. Définitions de l'extension v3.5 (lot L1)

Chaque définition nouvelle reçoit un cas qui donne une valeur non triviale et un
cas extrême, calculés sur des lois explicites. -/

/-- `entN1` : un bit recopié a une entropie de log 2 ; une loi de Dirac, 0. -/
lemma entN1_copie : entN1 (fun (a b : Fin 2) => if a = b then (1 / 2 : ℝ) else 0) = Real.log 2 := by
  simp only [entN1, Fin.sum_univ_two]
  norm_num
  simp only [one_div, Real.log_inv]
  ring

lemma entN1_dirac : entN1 (fun (a b : Fin 2) => if a = 0 ∧ b = 0 then (1 : ℝ) else 0) = 0 := by
  simp only [entN1, Fin.sum_univ_two]
  norm_num

/-- `condMI` : nulle pour une loi uniforme sur trois bits indépendants, égale à log 2
    quand G recopie A. -/
lemma condMI_independants : condMI (fun (_ _ _ : Fin 2) => (1 / 8 : ℝ)) = 0 := by
  simp only [condMI, Fin.sum_univ_two]
  norm_num

lemma condMI_copie : condMI (fun (a _ g : Fin 2) => if a = g then (1 / 4 : ℝ) else 0) = Real.log 2 := by
  simp only [condMI, Fin.sum_univ_two]
  norm_num
  ring

/-- `HS` : dans la famille témoin, la preuve est un bit uniforme sachant C, H(Σ|C) = 1. -/
lemma fam_HS (l : ℕ) : (famModel l).HS = 1 := by
  have hl2 : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  have h : ∀ c, entN1 ((famModel l).qSV c) = Real.log 2 := by
    intro c
    simp only [entN1, fam_qSV, Fin.sum_univ_two]
    norm_num
    simp only [one_div, Real.log_inv]
    ring
  simp only [HS, h, fam_pC, Fin.sum_univ_two]
  field_simp
  ring

/-- `IVM` est positive (masse totale au plus 1). -/
lemma IVM_nonneg {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C] [Fintype S] [Fintype V]
    (X : CLOModel lam M C S V) : 0 ≤ X.IVM := by
  unfold IVM
  refine div_nonneg (sum_nonneg fun c _ => mul_nonneg (X.pC_nonneg c) (miN_nonneg _
    (fun v m => sum_nonneg fun s _ => mul_nonneg (X.qMS_nonneg c m s) (X.ker_nonneg c s v)) ?_))
    (Real.log_pos (by norm_num)).le
  have e : ∑ v, ∑ m, ∑ s, X.qMS c m s * X.ker c s v = ∑ m, ∑ s, X.qMS c m s := by
    rw [Finset.sum_comm]
    refine sum_congr rfl fun m _ => ?_
    rw [Finset.sum_comm]
    exact sum_congr rfl fun s _ => by rw [← mul_sum, X.ker_sum, mul_one]
  rw [e]
  exact X.qMS_sum_le c

/-- `IVM` et `IVSM` : dans la famille témoin, la preuve ne dit rien du message
    (I(V;M|C) = 0) et l'institution en tire un bit au-delà du message
    (I(V;Σ|M,C) = 1). La Proposition 2.1 y est donc non triviale. -/
lemma fam_IVM_IVSM (l : ℕ) : (famModel l).IVM = 0 ∧ (famModel l).IVSM = 1 := by
  obtain ⟨heq, hle, -, -⟩ := (famModel l).fondement_extraction
  have h0 : (famModel l).IVM = 0 :=
    le_antisymm (by rw [fam_I] at hle; exact hle) (IVM_nonneg _)
  refine ⟨h0, ?_⟩
  rw [fam_IV, h0, zero_add] at heq
  exact heq.symm

/-- `constVerdict` : un verdict constant a H(V|C) = 0, donc Opp = 0 (convention
    x/0 = 0), alors que `detVerdict` avec V = Σ donne H(V|C) = 1 et Opp = 1. -/
lemma constVerdict_Opp (l : ℕ) : (famModel l).constVerdict.Opp = 0 := by
  have h := CLOModel.HV_eq_zero_of_card_one (famModel l).constVerdict (Fintype.card_fin 1)
  simp [Opp, h]

lemma detVerdict_copie (l : ℕ) :
    ((famModel l).detVerdict (fun _ s => s)).HV = 1 ∧
      ((famModel l).detVerdict (fun _ s => s)).Opp = 1 := by
  have e : (famModel l).detVerdict (fun _ s => s) = famModel l := by
    unfold detVerdict famModel
    congr
    funext c s v
    split_ifs with h1 h2 h2 <;> simp_all [eq_comm]
  rw [e]
  exact ⟨fam_HV l, by simp [Opp, fam_IV, fam_HV]⟩

/-- `post` : le post-traitement identité reproduit la loi du protocole. -/
lemma post_identite {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C] [Fintype S]
    [Fintype V] [DecidableEq S] (X : CLOModel lam M C S V) :
    (X.post (fun _ s t => if s = t then 1 else 0) (fun _ _ _ => by split_ifs <;> norm_num)
      (fun _ _ => by simp) X.ker X.ker_nonneg X.ker_sum).P = X.P := by
  funext c m t
  simp only [post, mul_ite, mul_one, mul_zero]
  rw [Finset.sum_ite_eq']
  simp

/-- `IVpost` : le post-traitement identité conserve I(V;Σ|C). -/
lemma IVpost_identite {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C] [Fintype S]
    [Fintype V] [DecidableEq S] (X : CLOModel lam M C S V) :
    X.IVpost (fun _ s t => if s = t then 1 else 0) = X.IV := by
  unfold IVpost IV
  congr 1
  refine sum_congr rfl fun c _ => ?_
  congr 1
  rw [miN_symm (X.qSV c)]
  congr 1
  funext v t
  simp only [mul_ite, mul_one, mul_zero]
  rw [Finset.sum_ite_eq']
  simp

/-! ## 7. Définitions du noyau quantique (version 3.6, lot L5a) -/

/-- `gammaQ` : γ_q = 1 pour le témoin (θ_q = 1/2, α_q = 1, H(C) = 2) ; γ_q = 1/2 < 1
    pour H(C) = 1, cas exclu par l'Hypothèse 2.6. -/
lemma gammaQ_temoin : gammaQ WitnessParamsQ = 1 := by
  simp [gammaQ, WitnessParamsQ]

noncomputable def ParamsQPetits : QuantumParams :=
  { H := 1, Δq := 0, αq := 1, θq := 1 / 2, βq := 1, ζq := 0, ηq := 0,
    hH := by norm_num, hΔq := le_refl _, hαq := by norm_num, hθq := by norm_num,
    hβq := le_refl _, hζq := le_refl _, hηq := le_refl _ }

lemma gammaQ_petit : gammaQ ParamsQPetits < 1 := by
  simp [gammaQ, ParamsQPetits]; norm_num

/-- `QuantumAssumptions` : instance dégénérée où H(V|C) = 0, exclue par l'Hypothèse 2.6. -/
noncomputable def degenerateInstanceQ (lam : ℕ) : QuantumProtocolInstance lam :=
  { params := WitnessParamsQ, Conf := 1, Rel := 0, Opp := 0, I := 0, χmax := 0, Iacc := 0,
    IV := 1, HV := 0, TDmax := 0, Dmsg := 0, Dmax := 0,
    hConf := by norm_num, hOpp := by norm_num, hTD := by norm_num, hRel := by norm_num,
    hI := le_refl _, hIV := by norm_num, hDmax := le_refl _,
    fano_q := by norm_num, holevo := le_refl _, moyenne_le_max := le_refl _,
    pinsker_q := by norm_num }

lemma degenereQ_exclu (lam : ℕ) : ¬ QuantumAssumptions (degenerateInstanceQ lam) := by
  intro hA
  have h1 := hA.A6γ
  have h2 := hA.A6
  simp [degenerateInstanceQ, gammaQ_temoin] at h2
  linarith

/-- Le cas qui satisfait QuantumAssumptions, rappelé de la section 14. -/
lemma temoinQ_satisfait (lam : ℕ) (hlam : 1 ≤ lam) :
    QuantumAssumptions (witnessInstanceQ lam hlam) :=
  (assumptions_q_consistent lam hlam).1

/-- `QuantumProtocolFamily` : une famille à paramètres fixes satisfait les Hypothèses
    2.5 à 2.8 pour tout λ, et le théorème asymptotique s'y applique. -/
noncomputable def familleQ : QuantumProtocolFamily :=
  { params := WitnessParamsQ,
    inst := fun lam =>
      { params := WitnessParamsQ, Conf := 1, Rel := 0, Opp := 1, I := 0, χmax := 0, Iacc := 0,
        IV := 1, HV := 1, TDmax := 0, Dmsg := 0, Dmax := 0,
        hConf := by norm_num, hOpp := by norm_num, hTD := by norm_num, hRel := by norm_num,
        hI := le_refl _, hIV := by norm_num, hDmax := le_refl _,
        fano_q := by norm_num, holevo := le_refl _, moyenne_le_max := le_refl _,
        pinsker_q := by norm_num },
    hparams := fun _ => rfl }

lemma familleQ_hypotheses (lam : ℕ) : QuantumAssumptions (familleQ.inst lam) := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> simp [familleQ, WitnessParamsQ, gammaQ]

lemma familleQ_asymptotique :
    ∃ K : ℝ, ∃ ε : ℕ → ℝ, Negligible ε ∧ ∀ lam : ℕ, 64 ≤ lam →
      (familleQ.inst lam).Conf * (familleQ.inst lam).Rel * (familleQ.inst lam).Opp ≤
        (familleQ.params.Δq + familleQ.params.ηq * familleQ.params.H) / lam + K / (lam : ℝ) ^ 2 + ε lam :=
  conditional_CRO_trilemma_pq familleQ 0 le_rfl (fun lam _ => familleQ_hypotheses lam)
    (fun lam _ => by simp [familleQ])

/-- `deltaQ` : hypothèse de travail de ML-DSA-65, Δ_q = 35 + 0 − 7 = 28 bits. -/
lemma deltaQ_mldsa : deltaQ 35 0 7 = 28 := by norm_num [deltaQ]

/-- `etaQ` : le canal identité ne fait rien perdre, η_q = 0. -/
lemma etaQ_identite (l : ℕ) :
    (famModel l).etaQ (fun _ s t => if s = t then (1 : ℝ) else 0) = 0 := by
  simp [CLOModel.etaQ, IVpost_identite]

/-! ## 8. Définitions des bornes avancées (version 3.7, lot L2) -/

/-- `bProd` : dans la famille témoin, M et Σ sont indépendants sachant C ; la loi
    produit b coïncide donc avec la loi jointe. -/
lemma fam_bProd (l : ℕ) (c : Fin 2) (m : Fin (2 ^ l)) (s : Fin 2) :
    (famModel l).bProd c m s = (famModel l).P c m s := by
  simp only [bProd, fam_P, fam_pC, sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
  push_cast
  field_simp
  ring

/-- `QuantumSharpInstance` : une instance de la famille quantique, de fiabilité nulle,
    satisfait la minoration fine. -/
noncomputable def sharpQ (lam : ℕ) : QuantumSharpInstance lam :=
  { familleQ.inst lam with fano_sharp_q := by simp [familleQ] }

lemma sharpQ_hypotheses (lam : ℕ) : QuantumAssumptions (sharpQ lam).toQuantumProtocolInstance :=
  familleQ_hypotheses lam

/-- `witModel` : Opp = 0 pour Δ = 0 et Opp = 1 pour Δ = γ ; Opp = 5/19 pour
    (Δ, γ) = (5, 19). Conf = 1 dans tous les cas. -/
lemma witModel_extremes (l : ℕ) :
    (witModel l 0 1).Opp = 0 ∧ (witModel l 1 1).Opp = 1 ∧ (witModel l 5 19).Opp = 5 / 19 ∧
      (witModel l 5 19).Conf = 1 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · have := (temoin_realisable l 0 1 (by norm_num) le_rfl).2.2.2.2.2.2.2; simpa using this
  · have := (temoin_realisable l 1 1 le_rfl le_rfl).2.2.2.2.2.2.2; simpa using this
  · have := (temoin_realisable l 5 19 (by norm_num) (by norm_num)).2.2.2.2.2.2.2; simpa using this
  · exact (temoin_realisable l 5 19 (by norm_num) (by norm_num)).2.2.2.2.2.2.1

/-! ## 9. Définitions des jeux et ponts (version 3.8, lot L3) -/

/-- `advDist`, `succIND` : pour deux lois de Dirac distinctes sur Bool, le test de
    Neyman-Pearson gagne toujours (avantage 1/2, succès 1) et un test constant ne gagne
    qu'une fois sur deux (avantage 0). -/
lemma ind_extremes :
    advDist (fun b : Bool => if b then (1 : ℝ) else 0) (fun b => if b then 0 else 1)
        (fun b => if b then 1 else 0) = 1 / 2 ∧
      succIND (fun b : Bool => if b then (1 : ℝ) else 0) (fun b => if b then 0 else 1)
        (fun b => if b then 1 else 0) = 1 ∧
      advDist (fun b : Bool => if b then (1 : ℝ) else 0) (fun b => if b then 0 else 1)
        (fun _ => 1) = 0 := by
  refine ⟨?_, ?_, ?_⟩ <;> norm_num [advDist, succIND]

/-- `relver` : valeurs extrêmes 1 et 0, et troncature à 0. -/
lemma relver_extremes : relver 1 0 = 1 ∧ relver 0 1 = 0 ∧ relver (1 / 2) 1 = 0 := by
  refine ⟨?_, ?_, ?_⟩ <;> norm_num [relver]

/-- `winBindRel` : un adversaire qui ouvre toujours une preuve acceptée sur deux messages
    distincts gagne avec probabilité 1 ; s'il ouvre sur le même message, il perd. -/
lemma bind_extremes :
    winBindRel (fun _ : Unit => (1 : ℝ)) (fun _ => true) (fun _ => some false)
        (fun _ => some true) = 1 ∧
      winBindRel (fun _ : Unit => (1 : ℝ)) (fun _ => true) (fun _ => some false)
        (fun _ => some false) = 0 := by
  constructor <;> simp [winBindRel]

/-- `binEntN` : h(0) = 0 et h(1/2) = ln 2. -/
lemma binEntN_valeurs : binEntN 0 = 0 ∧ binEntN (1 / 2) = Real.log 2 := by
  constructor
  · simp [binEntN]
  · simp only [binEntN]
    rw [show (1 : ℝ) - 1 / 2 = 1 / 2 by norm_num, one_div, Real.log_inv]
    ring

/-- `condEnt` : nulle quand A est fonction de B, égale à ln 2 quand A est un bit uniforme
    indépendant de B. -/
lemma condEnt_extremes :
    condEnt (fun a b : Bool => if a = b then (1 / 2 : ℝ) else 0) = 0 ∧
      condEnt (fun _ _ : Bool => (1 / 4 : ℝ)) = Real.log 2 := by
  constructor
  · simp [condEnt]
  · simp only [condEnt, Fintype.sum_bool]
    norm_num
    rw [show (1 : ℝ) / 2 = 2⁻¹ by norm_num, Real.log_inv]
    ring

/-! ## 10. Définitions de l'encodage diagonal (version 3.9, lot L5b) -/

/-- `shannon` et `vonNeumann` : 1 bit pour un bit uniforme, 0 pour une loi de Dirac. -/
lemma entropies_extremes :
    vonNeumann (diagState (fun _ : Bool => (1 / 2 : ℝ))) (diagState_isHermitian _) = 1 ∧
      vonNeumann (diagState (ketBit true)) (diagState_isHermitian _) = 0 := by
  rw [vonNeumann_diag, vonNeumann_diag]
  have hl : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  constructor
  · simp only [shannon, Fintype.sum_bool]
    rw [div_eq_one_iff_eq hl, show (1 : ℝ) / 2 = 2⁻¹ by norm_num, Real.log_inv]
    ring
  · simp [shannon, ketBit]

/-- `traceDistDiag` : 0 entre un état et lui-même, 1 entre |0⟩⟨0| et |1⟩⟨1|. -/
lemma traceDist_extremes :
    traceDistDiag (ketBit true) (ketBit true) = 0 ∧
      traceDistDiag (ketBit true) (ketBit false) = 1 := by
  constructor <;> simp only [traceDistDiag, traceNorm_diag_sub, ketBit, Fintype.sum_bool] <;> norm_num

/-- `ConfQdiag` : Conf^q = 1 pour `famModel`, Conf^q = 0 pour `copyModel`. -/
lemma confQ_extremes (l : ℕ) : (famModel l).ConfQdiag = 1 ∧ copyModel.ConfQdiag = 0 := by
  rw [confQ_diag_eq, confQ_diag_eq]; exact ⟨fam_Conf l, copy_Conf⟩

end Coherence
