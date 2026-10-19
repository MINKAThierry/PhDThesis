/-
  Formalisation du Trilemme CRO Conditionnel — Annexe de thèse
  =============================================================
  Version 2.2 (octobre 2026) — fichier unique, autonome.

  Auteurs : Thierry Emmanuel MINKA Mi Nguidjoï,
            Flavien Serge Mani Onana,
            Thomas Djotio Ndié
  LIMSI — École Nationale Supérieure Polytechnique, Université de Yaoundé I

  MODE D'EMPLOI POUR L'ÉVALUATEUR
  1. Ouvrir https://live.lean-lang.org (projet Mathlib, choix par défaut).
  2. Coller l'intégralité de ce fichier et attendre la fin de la vérification.
  3. Résultat attendu : aucune erreur, aucun `sorry`. Le bloc final
     (`#print axioms`) n'affiche que propext, Classical.choice, Quot.sound.

  ARCHITECTURE
  • Couche « théorie de l'information » : Pinsker (Lemme 1) et Fano
    (Lemme 2, étape 1) sont des résultats classiques [Cover & Thomas] ; ils
    sont intégrés comme propriétés de toute instance de protocole.
  • Couche « cryptographie institutionnelle » : les Hypothèses 1 (extraction
    bornée par Δ), 2′ (verdict efficace, γ = αH(C) − 1), 3 (β-régularité)
    et 4 (régime de préservation de la confidentialité, I ≤ κ/λ) sont des
    hypothèses explicites des théorèmes.
  • Aucun `axiom` n'est déclaré. Le paramètre λ est noté `lam` (en Lean 4,
    `λ` est un mot réservé).
-/

import Mathlib

open Real Filter

namespace ConditionalCRO

/-! ## 1. Constante de Pinsker c₀ = 1/(2 ln 2) -/

noncomputable def c0 : ℝ := 1 / (2 * Real.log 2)

lemma c0_pos : 0 < c0 := by
  unfold c0
  have h : 0 < Real.log 2 := Real.log_pos (by norm_num)
  positivity

/-- c₀ > 1/2, car ln 2 < 1. -/
lemma c0_gt_half : 1 / 2 < c0 := by
  unfold c0
  have h1 := Real.log_two_lt_d9
  have h2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  rw [lt_div_iff₀ (by positivity)]
  nlinarith

/-! ## 2. Négligeabilité de ε₀(λ) = 2^(−λ) -/

/-- f est négligeable : ∀ c > 0, |f(n)| ≤ n^(−c) à partir d'un certain rang. -/
def Negligible (f : ℕ → ℝ) : Prop :=
  ∀ c : ℝ, 0 < c → ∀ᶠ n : ℕ in atTop, |f n| ≤ (n : ℝ) ^ (-c)

noncomputable def ε₀ (lam : ℕ) : ℝ := (1 / 2 : ℝ) ^ lam

lemma ε₀_nonneg (lam : ℕ) : 0 ≤ ε₀ lam := by
  unfold ε₀; positivity

theorem negligible_eps0 : Negligible ε₀ := by
  intro c hc
  have hlim : Tendsto (fun n : ℕ => (n : ℝ) ^ (⌈c⌉₊) / (2 : ℝ) ^ n) atTop (nhds 0) :=
    tendsto_pow_const_div_const_pow_of_one_lt ⌈c⌉₊ (by norm_num)
  have hev : ∀ᶠ n : ℕ in atTop, (n : ℝ) ^ (⌈c⌉₊) / (2 : ℝ) ^ n < 1 :=
    hlim.eventually (gt_mem_nhds one_pos)
  filter_upwards [hev, eventually_ge_atTop 1] with n hn hn1
  have hn1' : (1 : ℝ) ≤ n := by exact_mod_cast hn1
  have hnpos : (0 : ℝ) < n := by linarith
  have h2pos : (0 : ℝ) < 2 ^ n := by positivity
  have hck : (n : ℝ) ^ c ≤ (n : ℝ) ^ (⌈c⌉₊) := by
    rw [← Real.rpow_natCast]
    exact Real.rpow_le_rpow_of_exponent_le hn1' (Nat.le_ceil c)
  have hk : (n : ℝ) ^ (⌈c⌉₊) ≤ 2 ^ n := by
    rw [div_lt_one h2pos] at hn
    exact hn.le
  have hcpos : (0 : ℝ) < (n : ℝ) ^ c := Real.rpow_pos_of_pos hnpos c
  unfold ε₀
  rw [abs_of_nonneg (by positivity), Real.rpow_neg hnpos.le, one_div, inv_pow]
  exact inv_anti₀ hcpos (hck.trans hk)

/-! ## 3. Paramètres institutionnels -/

structure InstitutionalParams where
  H : ℝ      -- H(C) : entropie du contexte institutionnel (bits)
  Δ : ℝ      -- capacité d'extraction institutionnelle (bits)
  α : ℝ      -- granularité des verdicts
  β : ℝ      -- constante de régularité du protocole
  hH_nonneg : 0 ≤ H
  hΔ_nonneg : 0 ≤ Δ
  hα_pos    : 0 < α
  hβ_ge_one : 1 ≤ β

/-- γ = αH(C) − 1 : borne inférieure de H(V|C) (Hypothèse 2′). -/
def gamma (p : InstitutionalParams) : ℝ := p.α * p.H - 1

-- Familles canoniques (valeurs empiriques de l'article CLO)
noncomputable def HeliosParams : InstitutionalParams :=
  { H := 50, Δ := 56, α := 1.2, β := 1.4,
    hH_nonneg := by norm_num, hΔ_nonneg := by norm_num,
    hα_pos    := by norm_num, hβ_ge_one := by norm_num }

noncomputable def zkSNARKParams : InstitutionalParams :=
  { H := 70, Δ := 73, α := 1.5, β := 1.5,
    hH_nonneg := by norm_num, hΔ_nonneg := by norm_num,
    hα_pos    := by norm_num, hβ_ge_one := by norm_num }

noncomputable def TraditionalAuditParams : InstitutionalParams :=
  { H := 20, Δ := 35, α := 1.0, β := 1.0,
    hH_nonneg := by norm_num, hΔ_nonneg := by norm_num,
    hα_pos    := by norm_num, hβ_ge_one := by norm_num }

/-! ## 4. Instance de protocole

Grandeurs d'une instance au paramètre de sécurité `lam` (M uniforme,
H(M) = λ, M ⊥ C) :
  Conf = 1 − max TV (Déf. 7), Rel (Déf. 8), Opp = I(V;Σ|C)/H(V|C) (Déf. 9).
Les champs `pinsker` et `fano` encodent les Lemmes 1 et 2 de l'article
(étape 1 de la preuve : I(M;Σ|C) ≥ Rel·λ − 1, valable pour tout Rel). -/
structure ProtocolInstance (lam : ℕ) where
  params : InstitutionalParams
  Conf   : ℝ   -- confidentialité
  Rel    : ℝ   -- fiabilité
  Opp    : ℝ   -- opposabilité
  I      : ℝ   -- I(M;Σ|C)
  IV     : ℝ   -- I(V;Σ|C)
  HV     : ℝ   -- H(V|C)
  TVmax  : ℝ   -- max_{m₀,m₁,c} TV(P_{Σ|m₀,c}, P_{Σ|m₁,c})
  KLmax  : ℝ   -- max_{m₀,m₁,c} D_KL(P_{Σ|m₀,c} ‖ P_{Σ|m₁,c})
  hConf  : Conf = 1 - TVmax
  hOpp   : Opp = IV / HV
  hTV    : 0 ≤ TVmax ∧ TVmax ≤ 1
  hRel   : 0 ≤ Rel ∧ Rel ≤ 1
  hI     : 0 ≤ I
  hIV    : 0 ≤ IV
  pinsker : TVmax ^ 2 ≤ c0 * KLmax             -- Lemme 1 (Pinsker)
  fano    : I ≥ Rel * lam - 1                   -- Lemme 2 (Fano), étape 1

/-- Hypothèses institutionnelles 1, 2′ et 3. -/
structure InstitutionalAssumptions {lam : ℕ} (P : ProtocolInstance lam) : Prop where
  /-- Hypothèse 1 (extraction bornée) : I(V;Σ|C) ≤ I(M;Σ|C) + Δ. -/
  A1 : P.IV ≤ P.I + P.params.Δ
  /-- Hypothèse 2′ (verdict efficace) : H(V|C) ≥ γ = αH(C) − 1 … -/
  A2 : gamma P.params ≤ P.HV
  /-- … avec γ ≥ 1. -/
  A2γ : 1 ≤ gamma P.params
  /-- Hypothèse 3 (β-régularité) : D_KL ≤ β·I(M;Σ|C). -/
  A3 : P.KLmax ≤ P.params.β * P.I

/-! ## 5. Lemme 4 : garantie de confidentialité -/

/-- **Lemme 4.** Pour tout protocole β-régulier : Conf ≥ 1 − √(c₀·β·I(M;Σ|C)). -/
theorem lemma4_confidentiality_guarantee {lam : ℕ} (P : ProtocolInstance lam)
    (hA3 : P.KLmax ≤ P.params.β * P.I) :
    1 - Real.sqrt (c0 * P.params.β * P.I) ≤ P.Conf := by
  have hTV0 := P.hTV.1
  -- TV ≤ √(c₀·KL) (Pinsker)
  have h1 : P.TVmax ≤ Real.sqrt (c0 * P.KLmax) := by
    have := Real.abs_le_sqrt P.pinsker
    rwa [abs_of_nonneg hTV0] at this
  -- √(c₀·KL) ≤ √(c₀·β·I) (régularité)
  have h2 : Real.sqrt (c0 * P.KLmax) ≤ Real.sqrt (c0 * P.params.β * P.I) := by
    apply Real.sqrt_le_sqrt
    rw [mul_assoc]
    exact mul_le_mul_of_nonneg_left hA3 c0_pos.le
  rw [P.hConf]
  linarith

/-! ## 6. Théorème 1 : Trilemme CRO conditionnel -/

/-- **Théorème 1, forme explicite.** Sous les Hypothèses 1, 2′, 3 et 4
    (I(M;Σ|C) ≤ κ/λ), pour λ ≥ 1 :
    Conf·Rel·Opp ≤ (1/γ)·(Δ/λ + κ(Δ+1)/λ² + κ²/λ³). -/
theorem trilemma_explicit {lam : ℕ} (P : ProtocolInstance lam)
    (hA : InstitutionalAssumptions P) (κ : ℝ) (hκ : 0 ≤ κ)
    (hlam : 1 ≤ lam) (hA4 : P.I ≤ κ / lam) :
    P.Conf * P.Rel * P.Opp ≤
      (1 / gamma P.params) * (P.params.Δ / lam + κ * (P.params.Δ + 1) / (lam : ℝ) ^ 2
        + κ ^ 2 / (lam : ℝ) ^ 3) := by
  have hl : (1 : ℝ) ≤ lam := by exact_mod_cast hlam
  have hl0 : (0 : ℝ) < lam := by linarith
  have hγ1 := hA.A2γ
  have hγ0 : 0 < gamma P.params := by linarith
  have hHV : 0 < P.HV := by linarith [hA.A2]
  have hx0 := P.hI
  have hΔ := P.params.hΔ_nonneg
  have hκl : 0 ≤ κ / lam := div_nonneg hκ hl0.le
  -- Conf ∈ [0, 1]
  have hC1 : P.Conf ≤ 1 := by rw [P.hConf]; linarith [P.hTV.1]
  -- Étape 1 : Rel ≤ (I + 1)/λ (Fano)
  have hR0 := P.hRel.1
  have hR : P.Rel ≤ (P.I + 1) / lam := by
    rw [le_div_iff₀ hl0]; linarith [P.fano]
  -- Étape 2 : Opp ≤ (I + Δ)/γ (Hypothèses 1 et 2′)
  have hO0 : 0 ≤ P.Opp := by rw [P.hOpp]; exact div_nonneg P.hIV hHV.le
  have hO : P.Opp ≤ (P.I + P.params.Δ) / gamma P.params := by
    rw [P.hOpp, div_le_div_iff₀ hHV hγ0]
    have e1 := mul_le_mul_of_nonneg_right hA.A1 hγ0.le
    have e2 := mul_le_mul_of_nonneg_left hA.A2 (by linarith : (0 : ℝ) ≤ P.I + P.params.Δ)
    linarith
  -- Étape 3 : monotonie en I et Hypothèse 4
  have hRx : (P.I + 1) / lam ≤ (κ / lam + 1) / lam := by
    rw [div_le_div_iff_of_pos_right hl0]; linarith
  have hOx : (P.I + P.params.Δ) / gamma P.params ≤ (κ / lam + P.params.Δ) / gamma P.params := by
    rw [div_le_div_iff_of_pos_right hγ0]; linarith
  have hb0 : 0 ≤ (P.I + 1) / lam := div_nonneg (by linarith) hl0.le
  have hb0' : 0 ≤ (κ / lam + 1) / lam := div_nonneg (by linarith) hl0.le
  have hl0' : (lam : ℝ) ≠ 0 := hl0.ne'
  have hγ' : gamma P.params ≠ 0 := hγ0.ne'
  calc P.Conf * P.Rel * P.Opp
      ≤ 1 * ((P.I + 1) / lam) * ((P.I + P.params.Δ) / gamma P.params) :=
        mul_le_mul (mul_le_mul hC1 hR hR0 zero_le_one) hO hO0 (by rw [one_mul]; exact hb0)
    _ ≤ 1 * ((κ / lam + 1) / lam) * ((κ / lam + P.params.Δ) / gamma P.params) :=
        mul_le_mul (by rw [one_mul, one_mul]; exact hRx) hOx
          (div_nonneg (by linarith) hγ0.le) (by rw [one_mul]; exact hb0')
    _ = (1 / gamma P.params) * (P.params.Δ / lam + κ * (P.params.Δ + 1) / (lam : ℝ) ^ 2
          + κ ^ 2 / (lam : ℝ) ^ 3) := by
        field_simp
        ring

/-- **Théorème 1, forme publiée.** Comme γ ≥ 1 :
    Conf·Rel·Opp ≤ Δ/λ + κ(Δ+1)/λ² + κ²/λ³. -/
theorem trilemma_instance {lam : ℕ} (P : ProtocolInstance lam)
    (hA : InstitutionalAssumptions P) (κ : ℝ) (hκ : 0 ≤ κ)
    (hlam : 1 ≤ lam) (hA4 : P.I ≤ κ / lam) :
    P.Conf * P.Rel * P.Opp ≤
      P.params.Δ / lam + κ * (P.params.Δ + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 3 := by
  have h := trilemma_explicit P hA κ hκ hlam hA4
  have hl0 : (0 : ℝ) < lam := by exact_mod_cast hlam
  have hB : 0 ≤ P.params.Δ / lam + κ * (P.params.Δ + 1) / (lam : ℝ) ^ 2
      + κ ^ 2 / (lam : ℝ) ^ 3 := by
    have hΔ := P.params.hΔ_nonneg
    have hl2 : (0 : ℝ) < (lam : ℝ) ^ 2 := by positivity
    have hl3 : (0 : ℝ) < (lam : ℝ) ^ 3 := by positivity
    exact add_nonneg (add_nonneg (div_nonneg hΔ hl0.le)
      (div_nonneg (mul_nonneg hκ (by linarith)) hl2.le)) (div_nonneg (sq_nonneg κ) hl3.le)
  have hγ : 1 / gamma P.params ≤ 1 := by
    rw [div_le_one (by linarith [hA.A2γ])]; exact hA.A2γ
  exact h.trans (mul_le_of_le_one_left hB hγ)

/-- Famille de protocoles : paramètres institutionnels communs à toutes les instances. -/
structure ProtocolFamily where
  params  : InstitutionalParams
  inst    : (lam : ℕ) → ProtocolInstance lam
  hparams : ∀ lam, (inst lam).params = params

/-- **Théorème 1 (Trilemme CRO conditionnel), forme asymptotique.**
    Sous les Hypothèses 1, 2′, 3 et 4, il existe K et ε négligeable tels que,
    pour tout λ ≥ 64 : Conf·Rel·Opp ≤ Δ/λ + K/λ² + ε(λ). -/
theorem conditional_CRO_trilemma (F : ProtocolFamily) (κ : ℝ) (hκ : 0 ≤ κ)
    (hA : ∀ lam, InstitutionalAssumptions (F.inst lam))
    (hA4 : ∀ lam, (F.inst lam).I ≤ κ / lam) :
    ∃ K : ℝ, ∃ ε : ℕ → ℝ, Negligible ε ∧ ∀ lam : ℕ, 64 ≤ lam →
      (F.inst lam).Conf * (F.inst lam).Rel * (F.inst lam).Opp ≤
        F.params.Δ / lam + K / (lam : ℝ) ^ 2 + ε lam := by
  refine ⟨κ * (F.params.Δ + 1) + κ ^ 2, ε₀, negligible_eps0, fun lam hlam => ?_⟩
  have h := trilemma_instance (F.inst lam) (hA lam) κ hκ (by omega) (hA4 lam)
  rw [F.hparams lam] at h
  have hl : (1 : ℝ) ≤ lam := by exact_mod_cast (by omega : 1 ≤ lam)
  have hl0 : (0 : ℝ) < lam := by linarith
  have hε := ε₀_nonneg lam
  have h3 : κ ^ 2 / (lam : ℝ) ^ 3 ≤ κ ^ 2 / (lam : ℝ) ^ 2 := by
    have e : κ ^ 2 / (lam : ℝ) ^ 3 = κ ^ 2 / (lam : ℝ) ^ 2 * (1 / lam) := by
      field_simp
    rw [e]
    exact mul_le_of_le_one_right (by positivity) (by rw [div_le_one hl0]; exact hl)
  have hK : (κ * (F.params.Δ + 1) + κ ^ 2) / (lam : ℝ) ^ 2 =
      κ * (F.params.Δ + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 2 := add_div _ _ _
  linarith

/-! ## 7. Cohérence et portée des hypothèses -/

/-- Paramètres du témoin de cohérence : H(C) = 2, Δ = 1, α = 1, β = 1 (γ = 1). -/
noncomputable def WitnessParams : InstitutionalParams :=
  { H := 2, Δ := 1, α := 1, β := 1,
    hH_nonneg := by norm_num, hΔ_nonneg := by norm_num,
    hα_pos    := by norm_num, hβ_ge_one := by norm_num }

/-- Instance vérifiant toutes les hypothèses : I = 0, Rel = 1/λ, Conf = Opp = 1. -/
noncomputable def witnessInstance (lam : ℕ) (hlam : 1 ≤ lam) : ProtocolInstance lam :=
  { params := WitnessParams, Conf := 1, Rel := 1 / lam, Opp := 1, I := 0,
    IV := 1, HV := 1, TVmax := 0, KLmax := 0,
    hConf := by norm_num, hOpp := by norm_num, hTV := by norm_num,
    hRel := by
      have hl : (1 : ℝ) ≤ lam := by exact_mod_cast hlam
      exact ⟨by positivity, by rw [div_le_one (by linarith)]; exact hl⟩,
    hI := le_refl _, hIV := by norm_num,
    pinsker := by norm_num,
    fano := by
      have hl : (1 : ℝ) ≤ lam := by exact_mod_cast hlam
      rw [one_div_mul_cancel (ne_of_gt (by linarith))]
      norm_num }

/-- **Cohérence (non-vacuité).** Les Hypothèses 1, 2′, 3 et 4 sont
    simultanément satisfiables dans le modèle abstrait, et la borne du
    Théorème 1 y est atteinte : Conf·Rel·Opp = Δ/(γλ) = 1/λ. Le témoin est
    un point du modèle relâché ; il ne construit pas une loi de probabilité. -/
theorem assumptions_consistent_and_bound_attained (lam : ℕ) (hlam : 1 ≤ lam) :
    InstitutionalAssumptions (witnessInstance lam hlam) ∧
    (witnessInstance lam hlam).I ≤ 0 / lam ∧
    (witnessInstance lam hlam).Conf * (witnessInstance lam hlam).Rel *
      (witnessInstance lam hlam).Opp =
      (witnessInstance lam hlam).params.Δ / (gamma (witnessInstance lam hlam).params * lam) := by
  refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_, ?_⟩ <;>
    simp [witnessInstance, WitnessParams, gamma] <;> norm_num

/-- Paramètres du témoin de portée : H(C) = 2, Δ = 0, α = 1, β = 2 (γ = 1). -/
noncomputable def ScopeParams : InstitutionalParams :=
  { H := 2, Δ := 0, α := 1, β := 2,
    hH_nonneg := by norm_num, hΔ_nonneg := le_refl _,
    hα_pos    := by norm_num, hβ_ge_one := by norm_num }

/-- Instance hors régime : I = λ/2 − 1 (révélation partielle du message). -/
noncomputable def scopeInstance (lam : ℕ) (hlam : 64 ≤ lam) : ProtocolInstance lam :=
  { params := ScopeParams, Conf := 1 / 2, Rel := 1 / 2, Opp := 1, I := lam / 2 - 1,
    IV := 1, HV := 1, TVmax := 1 / 2, KLmax := lam / 2,
    hConf := by norm_num, hOpp := by norm_num, hTV := by norm_num,
    hRel := by norm_num,
    hI := by
      have hl : (64 : ℝ) ≤ lam := by exact_mod_cast hlam
      linarith,
    hIV := by norm_num,
    pinsker := by
      have hl : (64 : ℝ) ≤ lam := by exact_mod_cast hlam
      have hc := c0_gt_half
      nlinarith,
    fano := by linarith }

/-- **Portée : l'Hypothèse 4 est nécessaire.** Pour tout λ ≥ 64, une instance
    satisfait les Hypothèses 1, 2′ et 3 (même avec Δ = 0) avec
    Conf·Rel·Opp = 1/4 ; elle viole l'Hypothèse 4 (I = λ/2 − 1). -/
theorem regime_assumption_necessary (lam : ℕ) (hlam : 64 ≤ lam) :
    InstitutionalAssumptions (scopeInstance lam hlam) ∧
    (scopeInstance lam hlam).params.Δ = 0 ∧
    (scopeInstance lam hlam).Conf * (scopeInstance lam hlam).Rel *
      (scopeInstance lam hlam).Opp = 1 / 4 ∧
    (scopeInstance lam hlam).I = lam / 2 - 1 := by
  have hl : (64 : ℝ) ≤ lam := by exact_mod_cast hlam
  refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_, ?_, ?_⟩ <;>
    simp [scopeInstance, ScopeParams, gamma] <;> linarith

/-! ## 8. Régimes de capacité institutionnelle (Définition 10) -/

inductive InstitutionalRegime where
  | LowCapacity | MidCapacity | HighCapacity
  deriving DecidableEq, Repr

/-- Low si Δ < 0,1·λ ; Mid si 0,1·λ ≤ Δ ≤ 0,5·λ ; High sinon. -/
noncomputable def capacity_regime (Δ lam : ℝ) : InstitutionalRegime :=
  if Δ < 0.1 * lam then .LowCapacity
  else if Δ ≤ 0.5 * lam then .MidCapacity
  else .HighCapacity

-- Helios (Δ = 56) à λ = 128 : 12,8 ≤ 56 ≤ 64  →  Mid
theorem Helios_regime_at_128 :
    capacity_regime HeliosParams.Δ 128 = .MidCapacity := by
  show capacity_regime 56 128 = _
  unfold capacity_regime
  norm_num

-- zk-SNARKs (Δ = 73) à λ = 256 : 25,6 ≤ 73 ≤ 128  →  Mid
theorem zkSNARK_regime_at_256 :
    capacity_regime zkSNARKParams.Δ 256 = .MidCapacity := by
  show capacity_regime 73 256 = _
  unfold capacity_regime
  norm_num

-- Audit traditionnel ECDSA (Δ = 35) à λ = 128 : 12,8 ≤ 35 ≤ 64  →  Mid
theorem TraditionalAudit_regime_at_128 :
    capacity_regime TraditionalAuditParams.Δ 128 = .MidCapacity := by
  show capacity_regime 35 128 = _
  unfold capacity_regime
  norm_num

/-! ## 9. Verdict déterministe et forme raffinée -/

/-- **T1.** Verdict déterministe : I(V;Σ|C) = H(V|C) ⇒ Opp = 1. -/
theorem opp_eq_one_of_deterministic {lam : ℕ} (P : ProtocolInstance lam)
    (hdet : P.IV = P.HV) (hHV : 0 < P.HV) : P.Opp = 1 := by
  rw [P.hOpp, hdet]; exact div_self hHV.ne'

/-- **T1 bis.** Verdict déterministe + Hyp. 1 et 2′ ⇒ γ − I(M;Σ|C) ≤ Δ :
    la contrainte institutionnelle ne peut pas être active. -/
theorem deterministic_forces_capacity {lam : ℕ} (P : ProtocolInstance lam)
    (hA : InstitutionalAssumptions P) (hdet : P.IV = P.HV) :
    gamma P.params - P.I ≤ P.params.Δ := by
  have := hA.A1; have := hA.A2; linarith

/-- **T2 (forme raffinée).** Avec I(V;Σ|C) ≤ H(V|C) (toujours vrai) :
    Conf·Rel·Opp ≤ ((κ/λ+1)/λ) · min 1 ((κ/λ+Δ)/γ). -/
theorem trilemma_refined {lam : ℕ} (P : ProtocolInstance lam)
    (hA : InstitutionalAssumptions P) (κ : ℝ) (hκ : 0 ≤ κ)
    (hlam : 1 ≤ lam) (hA4 : P.I ≤ κ / lam) (hIVHV : P.IV ≤ P.HV) :
    P.Conf * P.Rel * P.Opp ≤
      ((κ / lam + 1) / lam) * min 1 ((κ / lam + P.params.Δ) / gamma P.params) := by
  have hl0 : (0 : ℝ) < lam := by exact_mod_cast hlam
  have hγ0 : 0 < gamma P.params := by linarith [hA.A2γ]
  have hHV : 0 < P.HV := by linarith [hA.A2, hA.A2γ]
  have hκl : 0 ≤ κ / lam := div_nonneg hκ hl0.le
  have hC1 : P.Conf ≤ 1 := by rw [P.hConf]; linarith [P.hTV.1]
  have hC0 : 0 ≤ P.Conf := by rw [P.hConf]; linarith [P.hTV.2]
  have hR0 := P.hRel.1
  have hR : P.Rel ≤ (κ / lam + 1) / lam := by
    rw [le_div_iff₀ hl0]; linarith [P.fano]
  have hO0 : 0 ≤ P.Opp := by rw [P.hOpp]; exact div_nonneg P.hIV hHV.le
  have hO1 : P.Opp ≤ 1 := by
    rw [P.hOpp, div_le_one hHV]; exact hIVHV
  have hO2 : P.Opp ≤ (κ / lam + P.params.Δ) / gamma P.params := by
    rw [P.hOpp, div_le_div_iff₀ hHV hγ0]
    have e1 := mul_le_mul_of_nonneg_right hA.A1 hγ0.le
    have e2 := mul_le_mul_of_nonneg_left hA.A2
      (by linarith [P.params.hΔ_nonneg] : (0 : ℝ) ≤ κ / lam + P.params.Δ)
    have e3 : P.I * gamma P.params ≤ κ / lam * gamma P.params :=
      mul_le_mul_of_nonneg_right hA4 hγ0.le
    nlinarith
  have hOm : P.Opp ≤ min 1 ((κ / lam + P.params.Δ) / gamma P.params) := le_min hO1 hO2
  calc P.Conf * P.Rel * P.Opp ≤ 1 * ((κ / lam + 1) / lam) * min 1 ((κ / lam + P.params.Δ) / gamma P.params) :=
        mul_le_mul (mul_le_mul hC1 hR hR0 zero_le_one) hOm hO0
          (by rw [one_mul]; exact div_nonneg (by linarith) hl0.le)
    _ = _ := by ring

/-- **T2 bis.** Si Δ ≥ γ, la borne raffinée coïncide avec la seule borne de Fano. -/
theorem refined_bound_is_fano_when_delta_ge_gamma {lam : ℕ} (P : ProtocolInstance lam)
    (hA : InstitutionalAssumptions P) (κ : ℝ) (hκ : 0 ≤ κ) (hlam : 1 ≤ lam)
    (hΔγ : gamma P.params ≤ P.params.Δ) :
    min 1 ((κ / lam + P.params.Δ) / gamma P.params) = 1 := by
  have hl0 : (0 : ℝ) < lam := by exact_mod_cast hlam
  have hγ0 : 0 < gamma P.params := by linarith [hA.A2γ]
  have hκl : 0 ≤ κ / lam := div_nonneg hκ hl0.le
  apply min_eq_left
  rw [le_div_iff₀ hγ0]; linarith


end ConditionalCRO

/-! ## 10. Bloc de vérification pour l'évaluateur

Chaque `#print axioms` doit afficher uniquement
`[propext, Classical.choice, Quot.sound]` : ni `sorryAx`, ni axiome ad hoc. -/

#check @ConditionalCRO.lemma4_confidentiality_guarantee
#check @ConditionalCRO.conditional_CRO_trilemma
#print axioms ConditionalCRO.lemma4_confidentiality_guarantee
#print axioms ConditionalCRO.trilemma_explicit
#print axioms ConditionalCRO.conditional_CRO_trilemma
#print axioms ConditionalCRO.assumptions_consistent_and_bound_attained
#print axioms ConditionalCRO.regime_assumption_necessary
#print axioms ConditionalCRO.zkSNARK_regime_at_256
#print axioms ConditionalCRO.opp_eq_one_of_deterministic
#print axioms ConditionalCRO.deterministic_forces_capacity
#print axioms ConditionalCRO.trilemma_refined
#print axioms ConditionalCRO.refined_bound_is_fano_when_delta_ge_gamma
