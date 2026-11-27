/-
  Formalisation du Trilemme CRO Conditionnel — Annexe de thèse
  =============================================================
  Version 3.7 (27 novembre 2026), qui prolonge la 3.4 sans la modifier.

  Auteurs : Thierry Emmanuel Minka Mi Nguidjoï,
            Flavien Serge Mani Onana,
            Thomas Djotio Ndié
  LIMSI - École Nationale Supérieure Polytechnique, Université de Yaoundé I

  MODE D'EMPLOI POUR L'ÉVALUATEUR
  1. Ouvrir https://live.lean-lang.org (projet Mathlib, choix par défaut).
  2. Coller l'intégralité de ce fichier et attendre la fin de la vérification.
  3. Résultat attendu : aucune erreur, aucun `sorry`. Le bloc final
     (`#print axioms`) n'affiche que propext, Classical.choice, Quot.sound.
  La version 3.2 a été vérifiée le 22 novembre 2026 sur live.lean-lang.org avec
  `import Mathlib` complet (dix-huit `#print axioms` standards). La version 3.3
  (précisions sur c₀, hypothèses du noyau abstrait, minoration de H(C)) a été
  vérifiée localement avec Lean 4.35.0 et Mathlib v4.35.0, sans erreur ni
  avertissement. La version 3.4 ajoute deux théorèmes qui certifient le seuil
  H♯ dans les deux sens (`factor_lt_one_iff`, `seuil_Hsharp`) ; elle a été
  vérifiée localement de la même manière (vingt `#print axioms` standards).

  ARCHITECTURE
  • Noyau algébrique (sections 1 à 9) : les grandeurs d'un protocole sont des
    réels liés par Pinsker (Lemme 1) et Fano (Lemme 2, étape 1), posés comme
    propriétés d'une instance abstraite (`ProtocolInstance`).
  • Couche concrète (section 10) : Pinsker et Fano y sont DÉMONTRÉS pour de
    vraies lois de probabilité finies sur (C, M, Σ, V), avec M uniforme sur 2^λ
    valeurs et indépendant de C et une interprétation admissible (noyau de
    verdict ne dépendant que de (Σ, C)). H(C) est l'entropie de la loi et
    γ = α·H(C) − 1. Le trilemme (formes explicite, raffinée, asymptotique)
    n'utilise ni Pinsker ni l'Hypothèse 3 ni les supports communs, qui ne servent
    qu'au Lemme 4. L'inégalité I(V;Σ|C) ≤ H(V|C) y est démontrée. Une famille de
    lois concrètes (`famModel`) satisfait toutes les hypothèses pour tout λ et le
    théorème asymptotique s'y applique.
  • Bloc de vérification (section 11).
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

-- Familles canoniques (valeurs illustratives de la calibration)
noncomputable def HeliosParams : InstitutionalParams :=
  { H := 40, Δ := 56, α := 1.2, β := 1.4,
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

/-- **Théorème 1, forme explicite.** Sous les Hypothèses 1, 2′ et 4
    (I(M;Σ|C) ≤ κ/λ), pour λ ≥ 1 :
    Conf·Rel·Opp ≤ (1/γ)·(Δ/λ + κ(Δ+1)/λ² + κ²/λ³).
    La structure `InstitutionalAssumptions` contient aussi l'Hypothèse 3 (A3), que
    cette preuve n'utilise pas ; A3 ne sert qu'au Lemme 4. -/
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

/-- **Théorème 1, forme publiée.** Comme γ ≥ 1 (Hypothèse 3 non utilisée) :
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
    Sous les Hypothèses 1, 2′ et 4, demandées pour λ ≥ 64, il existe K et ε
    négligeable tels que, pour tout λ ≥ 64 : Conf·Rel·Opp ≤ Δ/λ + K/λ² + ε(λ).
    L'Hypothèse 3, portée par `InstitutionalAssumptions`, n'est pas utilisée.
    Le terme ε = 2^(−λ) garde la forme publiée ; la borne tient aussi sans lui.
    Le seuil 64 reprend celui de la thèse ; la preuve n'utilise que λ ≥ 1. -/
theorem conditional_CRO_trilemma (F : ProtocolFamily) (κ : ℝ) (hκ : 0 ≤ κ)
    (hA : ∀ lam, 64 ≤ lam → InstitutionalAssumptions (F.inst lam))
    (hA4 : ∀ lam, 64 ≤ lam → (F.inst lam).I ≤ κ / lam) :
    ∃ K : ℝ, ∃ ε : ℕ → ℝ, Negligible ε ∧ ∀ lam : ℕ, 64 ≤ lam →
      (F.inst lam).Conf * (F.inst lam).Rel * (F.inst lam).Opp ≤
        F.params.Δ / lam + K / (lam : ℝ) ^ 2 + ε lam := by
  refine ⟨κ * (F.params.Δ + 1) + κ ^ 2, ε₀, negligible_eps0, fun lam hlam => ?_⟩
  have h := trilemma_instance (F.inst lam) (hA lam hlam) κ hκ (by omega) (hA4 lam hlam)
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
    simultanément satisfiables dans le modèle abstrait et la borne du
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

/-- **T2 ter.** Le facteur institutionnel est strictement inférieur à 1 si et
    seulement si Δ < γ − κ/λ : réciproque de T2 bis. -/
theorem factor_lt_one_iff (Δ γ κ lam : ℝ) (hγ : 0 < γ) :
    min 1 ((κ / lam + Δ) / γ) < 1 ↔ Δ < γ - κ / lam := by
  rw [min_lt_iff]
  constructor
  · rintro (h | h)
    · exact absurd h (lt_irrefl _)
    · rw [div_lt_one hγ] at h; linarith
  · intro h; right; rw [div_lt_one hγ]; linarith

/-- **T2 quater.** Avec γ = αH(C) − 1, la condition Δ < γ − κ/λ s'écrit
    H(C) > H♯ = (Δ + 1 + κ/λ)/α (Remarque activite_delta). -/
theorem seuil_Hsharp (Δ α H κ lam : ℝ) (hα : 0 < α) :
    Δ < (α * H - 1) - κ / lam ↔ (Δ + 1 + κ / lam) / α < H := by
  rw [div_lt_iff₀ hα]
  constructor <;> intro h <;> linarith


/-! ## 10. Couche concrète : lois de probabilité finies

Cette section supprime l'axiomatisation des inégalités de Pinsker et de Fano.
Les champs `pinsker` et `fano` d'une `ProtocolInstance` y deviennent des
théorèmes, démontrés pour de vraies lois finies sur (C, M, Σ, V). Les seules
hypothèses restantes sont les hypothèses institutionnelles de la thèse. -/

open Finset

/-! ### 10.1 Inégalité élémentaire et inégalité log-somme -/

/-- Pour a ≥ 0, b ≥ 0 (a > 0 ⇒ b > 0) et t > 0 : a·log t + a − b·t ≤ a·log(a/b). -/
lemma term_ineq {a b t : ℝ} (ha : 0 ≤ a) (hb : 0 ≤ b) (hab : 0 < a → 0 < b) (ht : 0 < t) :
    a * Real.log t + a - b * t ≤ a * Real.log (a / b) := by
  rcases ha.lt_or_eq with ha' | ha'
  · have hb' := hab ha'
    have hx : 0 < a / (b * t) := by positivity
    have h1 := Real.one_sub_inv_le_log_of_pos hx
    have e : Real.log (a / (b * t)) = Real.log (a / b) - Real.log t := by
      rw [← div_div, Real.log_div (by positivity) ht.ne']
    rw [e, inv_div] at h1
    have h3 := mul_le_mul_of_nonneg_left h1 ha
    have h4 : a * (1 - b * t / a) = a - b * t := by field_simp
    nlinarith [h3, h4]
  · subst ha'
    nlinarith [mul_nonneg hb ht.le]

/-- **Inégalité log-somme.** (Σa)·log(Σa/Σb) ≤ Σ a·log(a/b). -/
lemma log_sum_ineq {ι : Type*} (s : Finset ι) (a b : ι → ℝ) (ha : ∀ i ∈ s, 0 ≤ a i)
    (hb : ∀ i ∈ s, 0 ≤ b i) (hab : ∀ i ∈ s, 0 < a i → 0 < b i) :
    (∑ i ∈ s, a i) * Real.log ((∑ i ∈ s, a i) / ∑ i ∈ s, b i)
      ≤ ∑ i ∈ s, a i * Real.log (a i / b i) := by
  have hA : 0 ≤ ∑ i ∈ s, a i := sum_nonneg ha
  rcases hA.lt_or_eq with hA' | hA'
  · have hB : 0 < ∑ i ∈ s, b i := by
      obtain ⟨i, hi, hai⟩ : ∃ i ∈ s, 0 < a i := by
        by_contra h
        push Not at h
        have : ∑ i ∈ s, a i ≤ 0 := sum_nonpos h
        linarith
      exact lt_of_lt_of_le (hab i hi hai) (single_le_sum hb hi)
    have ht : 0 < (∑ i ∈ s, a i) / ∑ i ∈ s, b i := div_pos hA' hB
    have key := sum_le_sum (fun i hi => term_ineq (ha i hi) (hb i hi) (hab i hi) ht)
    simp only [sum_sub_distrib, sum_add_distrib, ← sum_mul] at key
    have e : (∑ i ∈ s, b i) * ((∑ i ∈ s, a i) / ∑ i ∈ s, b i) = ∑ i ∈ s, a i := by
      field_simp
    linarith
  · rw [← hA']
    simp only [zero_mul]
    have : ∀ i ∈ s, a i = 0 := (sum_eq_zero_iff_of_nonneg ha).1 hA'.symm
    rw [sum_eq_zero (fun i hi => by rw [this i hi, zero_mul])]

/-- Entropie binaire (en nats) au plus log 2 : p·log p + (1−p)·log(1−p) ≥ −log 2. -/
lemma binEnt_le_log_two {p : ℝ} (hp0 : 0 ≤ p) (hp1 : p ≤ 1) :
    -Real.log 2 ≤ p * Real.log p + (1 - p) * Real.log (1 - p) := by
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  -- a·log(2a) ≥ a − 1/2 pour a ≥ 0
  have aux : ∀ a : ℝ, 0 ≤ a → a - 1 / 2 ≤ a * Real.log 2 + a * Real.log a := by
    intro a ha
    rcases ha.lt_or_eq with ha' | ha'
    · have h := Real.one_sub_inv_le_log_of_pos (by positivity : 0 < 2 * a)
      rw [Real.log_mul (by norm_num) ha'.ne'] at h
      have h2 := mul_le_mul_of_nonneg_left h ha
      have h3 : a * (1 - (2 * a)⁻¹) = a - 1 / 2 := by field_simp
      nlinarith [h2, h3]
    · subst ha'; norm_num
  have e1 := aux p hp0
  have e2 := aux (1 - p) (by linarith)
  nlinarith [e1, e2]

/-! ### 10.2 Pinsker binaire puis Pinsker fini -/

/-- φ(t) = −p log t − (1−p) log(1−t) − 2(p−t)² décroît sur [q, p] (0 < q, p < 1). -/
lemma pinsker_aux {p q : ℝ} (hq : 0 < q) (hqp : q ≤ p) (hp1 : p < 1) :
    -p * Real.log p - (1 - p) * Real.log (1 - p) - 2 * (p - p) ^ 2
      ≤ -p * Real.log q - (1 - p) * Real.log (1 - q) - 2 * (p - q) ^ 2 := by
  let φ : ℝ → ℝ := fun t => -p * Real.log t - (1 - p) * Real.log (1 - t) - 2 * (p - t) ^ 2
  have hanti : AntitoneOn φ (Set.Icc q p) := by
    apply antitoneOn_of_hasDerivWithinAt_nonpos (convex_Icc q p)
      (f' := fun t => -p / t + (1 - p) / (1 - t) + 4 * (p - t))
    · intro t ht
      have ht0 : t ≠ 0 := by linarith [ht.1]
      have ht1 : 1 - t ≠ 0 := by linarith [ht.2]
      apply ContinuousAt.continuousWithinAt
      have c1 : ContinuousAt Real.log t := Real.continuousAt_log ht0
      have c2 : ContinuousAt (fun x => Real.log (1 - x)) t :=
        (Real.continuousAt_log ht1).comp (continuousAt_const.sub continuousAt_id)
      exact ((continuousAt_const.mul c1).sub (continuousAt_const.mul c2)).sub
        (continuousAt_const.mul ((continuousAt_const.sub continuousAt_id).pow 2))
    · intro t ht
      rw [interior_Icc] at ht
      have ht0 : 0 < t := by linarith [ht.1]
      have ht1 : 0 < 1 - t := by linarith [ht.2]
      have d1 : HasDerivAt Real.log t⁻¹ t := Real.hasDerivAt_log ht0.ne'
      have d2 : HasDerivAt (fun x => Real.log (1 - x)) ((-1) / (1 - t)) t :=
        ((hasDerivAt_id t).const_sub 1).log ht1.ne'
      have hA : HasDerivAt (fun x => p - x) (-1) t := by
        simpa using (hasDerivAt_id t).const_sub p
      have d3 : HasDerivAt (fun x => (p - x) ^ 2) (2 * (p - t) * (-1)) t := by
        have := hA.mul hA
        convert this using 1
        · funext x; simp only [Pi.mul_apply]; ring
        · ring
      have d := ((d1.const_mul (-p)).sub (d2.const_mul (1 - p))).sub (d3.const_mul 2)
      apply HasDerivAt.hasDerivWithinAt
      convert d using 1
      field_simp
      ring
    · intro t ht
      rw [interior_Icc] at ht
      have ht0 : 0 < t := by linarith [ht.1]
      have ht1 : 0 < 1 - t := by linarith [ht.2]
      have hpt : 0 ≤ p - t := by linarith [ht.2]
      have key : (-p / t + (1 - p) / (1 - t) + 4 * (p - t)) * (t * (1 - t))
          = (p - t) * (4 * t * (1 - t) - 1) := by field_simp; ring
      have hneg : (p - t) * (4 * t * (1 - t) - 1) ≤ 0 :=
        mul_nonpos_of_nonneg_of_nonpos hpt (by nlinarith [sq_nonneg (2 * t - 1)])
      have hpos : 0 < t * (1 - t) := mul_pos ht0 ht1
      by_contra hc
      push Not at hc
      have : 0 < (-p / t + (1 - p) / (1 - t) + 4 * (p - t)) * (t * (1 - t)) :=
        mul_pos hc hpos
      linarith
  have := hanti ⟨le_refl q, hqp⟩ ⟨hqp, le_refl p⟩ hqp
  simpa [φ] using this

/-- Même résultat pour p = 1 : φ₁(t) = −log t − 2(1−t)² décroît sur [q, 1]. -/
lemma pinsker_aux_one {q : ℝ} (hq : 0 < q) (hq1 : q ≤ 1) :
    2 * (1 - q) ^ 2 ≤ -Real.log q := by
  let φ : ℝ → ℝ := fun t => -Real.log t - 2 * (1 - t) ^ 2
  have hanti : AntitoneOn φ (Set.Icc q 1) := by
    apply antitoneOn_of_hasDerivWithinAt_nonpos (convex_Icc q 1)
      (f' := fun t => -1 / t + 4 * (1 - t))
    · intro t ht
      have ht0 : t ≠ 0 := by linarith [ht.1]
      apply ContinuousAt.continuousWithinAt
      exact ((Real.continuousAt_log ht0).neg).sub
        (continuousAt_const.mul ((continuousAt_const.sub continuousAt_id).pow 2))
    · intro t ht
      rw [interior_Icc] at ht
      have ht0 : 0 < t := by linarith [ht.1]
      have d1 : HasDerivAt Real.log t⁻¹ t := Real.hasDerivAt_log ht0.ne'
      have hA : HasDerivAt (fun x => 1 - x) (-1) t := by
        simpa using (hasDerivAt_id t).const_sub (1 : ℝ)
      have d3 : HasDerivAt (fun x => (1 - x) ^ 2) (2 * (1 - t) * (-1)) t := by
        have := hA.mul hA
        convert this using 1
        · funext x; simp only [Pi.mul_apply]; ring
        · ring
      have d := d1.neg.sub (d3.const_mul 2)
      apply HasDerivAt.hasDerivWithinAt
      convert d using 1
      field_simp
      ring
    · intro t ht
      rw [interior_Icc] at ht
      have ht0 : 0 < t := by linarith [ht.1]
      have ht1 : 0 < 1 - t := by linarith [ht.2]
      have key : (-1 / t + 4 * (1 - t)) * t = 4 * t * (1 - t) - 1 := by field_simp; ring
      have hneg : 4 * t * (1 - t) - 1 ≤ 0 := by nlinarith [sq_nonneg (2 * t - 1)]
      by_contra hc
      push Not at hc
      have : 0 < (-1 / t + 4 * (1 - t)) * t := mul_pos hc ht0
      linarith
  have := hanti ⟨le_refl q, hq1⟩ ⟨hq1, le_refl 1⟩ hq1
  simpa [φ] using this

/-- **Pinsker binaire (nats).** Pour 0 ≤ q ≤ p ≤ 1, avec q = 0 ⇒ p = 0 :
    2(p − q)² ≤ p·log(p/q) + (1−p)·log((1−p)/(1−q)). -/
lemma pinsker_binary {p q : ℝ} (hq0 : 0 ≤ q) (hqp : q ≤ p) (hp1 : p ≤ 1)
    (hz : q = 0 → p = 0) :
    2 * (p - q) ^ 2 ≤ p * Real.log (p / q) + (1 - p) * Real.log ((1 - p) / (1 - q)) := by
  rcases hq0.lt_or_eq with hq | hq
  · rcases hp1.lt_or_eq with hp | hp
    · have h := pinsker_aux hq hqp hp
      have hp0 : 0 < p := lt_of_lt_of_le hq hqp
      rw [Real.log_div hp0.ne' hq.ne', Real.log_div (by linarith) (by linarith)]
      nlinarith [h]
    · subst hp
      have h := pinsker_aux_one hq (by linarith)
      simp only [sub_self, zero_mul, add_zero, one_mul, div_eq_mul_inv, one_mul]
      rw [Real.log_inv]
      linarith
  · subst hq
    have hp := hz rfl
    subst hp
    simp

/-- Variation totale (forme partie positive) et divergence de Kullback-Leibler (nats). -/
noncomputable def tv {α : Type*} [Fintype α] (P Q : α → ℝ) : ℝ := ∑ a, max (P a - Q a) 0

/-- Divergence de Kullback-Leibler (nats). Elle n'est la vraie divergence que si
    P ≪ Q ; sinon les conventions log 0 = 0 et x/0 = 0 la sous-estiment. -/
noncomputable def klN {α : Type*} [Fintype α] (P Q : α → ℝ) : ℝ :=
  ∑ a, P a * Real.log (P a / Q a)

/-- **Pinsker fini (nats).** tv² ≤ ½·KL, pour deux lois avec P ≪ Q. -/
theorem pinsker_finite {α : Type*} [Fintype α] (P Q : α → ℝ)
    (hP : ∀ a, 0 ≤ P a) (hQ : ∀ a, 0 ≤ Q a) (hP1 : ∑ a, P a = 1) (hQ1 : ∑ a, Q a = 1)
    (hac : ∀ a, 0 < P a → 0 < Q a) :
    tv P Q ^ 2 ≤ klN P Q / 2 := by
  classical
  set A := (univ : Finset α).filter (fun a => Q a < P a) with hAdef
  set p := ∑ a ∈ A, P a with hp
  set q := ∑ a ∈ A, Q a with hq
  have htv : tv P Q = p - q := by
    unfold tv
    rw [hp, hq, ← sum_sub_distrib, sum_filter]
    apply sum_congr rfl
    intro a _
    split_ifs with h
    · exact max_eq_left (by linarith)
    · exact max_eq_right (by linarith [not_lt.mp h])
  have hpc : ∑ a ∈ univ.filter (fun a => ¬ (Q a < P a)), P a = 1 - p := by
    rw [← hP1, ← sum_filter_add_sum_filter_not univ (fun a => Q a < P a) P]; ring
  have hqc : ∑ a ∈ univ.filter (fun a => ¬ (Q a < P a)), Q a = 1 - q := by
    rw [← hQ1, ← sum_filter_add_sum_filter_not univ (fun a => Q a < P a) Q]; ring
  have l1 := log_sum_ineq A P Q (fun a _ => hP a) (fun a _ => hQ a) (fun a _ => hac a)
  have l2 := log_sum_ineq (univ.filter (fun a => ¬ (Q a < P a))) P Q (fun a _ => hP a)
    (fun a _ => hQ a) (fun a _ => hac a)
  rw [hpc, hqc] at l2
  have hsplit : klN P Q = ∑ a ∈ A, P a * Real.log (P a / Q a) +
      ∑ a ∈ univ.filter (fun a => ¬ (Q a < P a)), P a * Real.log (P a / Q a) := by
    unfold klN; rw [sum_filter_add_sum_filter_not]
  have hqp : q ≤ p := sum_le_sum (fun a ha => (mem_filter.1 ha).2.le)
  have hq0 : 0 ≤ q := sum_nonneg (fun a _ => hQ a)
  have hp1 : p ≤ 1 := by
    rw [← hP1]; exact sum_le_sum_of_subset_of_nonneg (filter_subset _ _) (fun a _ _ => hP a)
  have hz : q = 0 → p = 0 := by
    intro hq0'
    have hQA : ∀ a ∈ A, Q a = 0 := (sum_eq_zero_iff_of_nonneg (fun a _ => hQ a)).1 hq0'
    apply sum_eq_zero
    intro a ha
    by_contra hne
    have hpos : 0 < P a := lt_of_le_of_ne (hP a) (Ne.symm hne)
    have := hac a hpos
    rw [hQA a ha] at this
    exact lt_irrefl _ this
  have hb := pinsker_binary hq0 hqp hp1 hz
  rw [htv]
  linarith

/-! ### 10.3 Information mutuelle : positivité, majoration par l'entropie, Fano -/

/-- Information mutuelle (nats) d'une loi jointe w sur α × β. -/
noncomputable def miN {α β : Type*} [Fintype α] [Fintype β] (w : α → β → ℝ) : ℝ :=
  ∑ a, ∑ b, w a b * Real.log (w a b / ((∑ b', w a b') * (∑ a', w a' b)))

/-- Entropie (nats) de la seconde marginale de w. -/
noncomputable def entN2 {α β : Type*} [Fintype α] [Fintype β] (w : α → β → ℝ) : ℝ :=
  -∑ b, (∑ a, w a b) * Real.log (∑ a, w a b)

/-- Positivité de l'information mutuelle, pour une masse totale entre 0 et 1. -/
theorem miN_nonneg {α β : Type*} [Fintype α] [Fintype β] (w : α → β → ℝ)
    (hw : ∀ a b, 0 ≤ w a b) (hS1 : ∑ a, ∑ b, w a b ≤ 1) : 0 ≤ miN w := by
  classical
  -- log-somme sur α × β
  let a2 : α × β → ℝ := fun x => w x.1 x.2
  let b2 : α × β → ℝ := fun x => (∑ b', w x.1 b') * (∑ a', w a' x.2)
  have hb2 : ∀ x ∈ (univ : Finset (α × β)), 0 ≤ b2 x := fun x _ =>
    mul_nonneg (sum_nonneg fun _ _ => hw _ _) (sum_nonneg fun _ _ => hw _ _)
  have hab : ∀ x ∈ (univ : Finset (α × β)), 0 < a2 x → 0 < b2 x := by
    intro x _ hx
    have h1 : w x.1 x.2 ≤ ∑ b', w x.1 b' :=
      single_le_sum (f := fun b' => w x.1 b') (fun _ _ => hw _ _) (mem_univ x.2)
    have h2 : w x.1 x.2 ≤ ∑ a', w a' x.2 :=
      single_le_sum (f := fun a' => w a' x.2) (fun _ _ => hw _ _) (mem_univ x.1)
    exact mul_pos (lt_of_lt_of_le hx h1) (lt_of_lt_of_le hx h2)
  have l := log_sum_ineq univ a2 b2 (fun x _ => hw _ _) hb2 hab
  have eA : ∑ x, a2 x = ∑ a, ∑ b, w a b := Fintype.sum_prod_type _
  have eB : ∑ x, b2 x = (∑ a, ∑ b, w a b) * (∑ a, ∑ b, w a b) := by
    rw [Fintype.sum_prod_type]
    simp only [b2]
    rw [← sum_mul_sum]
    congr 1
    exact Finset.sum_comm
  have eM : ∑ x, a2 x * Real.log (a2 x / b2 x) = miN w := by
    unfold miN; rw [Fintype.sum_prod_type]
  rw [eA, eB, eM] at l
  set S := ∑ a, ∑ b, w a b with hS
  have hS0 : 0 ≤ S := sum_nonneg fun _ _ => sum_nonneg fun _ _ => hw _ _
  rcases hS0.lt_or_eq with hS' | hS'
  · have e : S / (S * S) = S⁻¹ := by field_simp
    rw [e, Real.log_inv] at l
    have : Real.log S ≤ 0 := Real.log_nonpos hS0 hS1
    nlinarith
  · rw [← hS'] at l; simpa using l

/-- L'information mutuelle est majorée par l'entropie de la seconde variable. -/
theorem miN_le_entN2 {α β : Type*} [Fintype α] [Fintype β] (w : α → β → ℝ)
    (hw : ∀ a b, 0 ≤ w a b) : miN w ≤ entN2 w := by
  classical
  have key : ∀ a b, w a b * Real.log (w a b / ((∑ b', w a b') * (∑ a', w a' b)))
      ≤ w a b * (-Real.log (∑ a', w a' b)) := by
    intro a b
    rcases (hw a b).lt_or_eq with h | h
    · have h1 : w a b ≤ ∑ b', w a b' :=
        single_le_sum (f := fun b' => w a b') (fun _ _ => hw _ _) (mem_univ b)
      have h2 : w a b ≤ ∑ a', w a' b :=
        single_le_sum (f := fun a' => w a' b) (fun _ _ => hw _ _) (mem_univ a)
      have hA : 0 < ∑ b', w a b' := lt_of_lt_of_le h h1
      have hB : 0 < ∑ a', w a' b := lt_of_lt_of_le h h2
      apply mul_le_mul_of_nonneg_left _ h.le
      rw [Real.log_div h.ne' (by positivity), Real.log_mul hA.ne' hB.ne']
      have : Real.log (w a b) ≤ Real.log (∑ b', w a b') := Real.log_le_log h h1
      linarith
    · rw [← h]; simp
  calc miN w ≤ ∑ a, ∑ b, w a b * (-Real.log (∑ a', w a' b)) :=
        sum_le_sum fun a _ => sum_le_sum fun b _ => key a b
    _ = entN2 w := by
        unfold entN2
        rw [Finset.sum_comm]
        simp only [← sum_mul, mul_neg, sum_neg_distrib]

/-- **Fano fini (nats).** Si la loi jointe w de (M, Σ) a une première marginale
    uniforme sur N valeurs, tout décodeur d de probabilité de succès p vérifie
    p·log N − log 2 ≤ I(M;Σ). -/
theorem fano_finite {α β : Type*} [Fintype α] [Fintype β] [DecidableEq α]
    (w : α → β → ℝ) (hw : ∀ a b, 0 ≤ w a b) (hS1 : ∑ a, ∑ b, w a b = 1)
    (hunif : ∀ a, ∑ b, w a b = 1 / (Fintype.card α : ℝ)) (d : β → α) :
    (∑ b, w (d b) b) * Real.log (Fintype.card α) - Real.log 2 ≤ miN w := by
  classical
  set N : ℝ := (Fintype.card α : ℝ) with hN
  have hN1 : (1 : ℝ) ≤ N := by
    have : 0 < Fintype.card α := by
      by_contra h
      push Not at h
      have h0 : Fintype.card α = 0 := by omega
      have := Fintype.card_eq_zero_iff.1 h0
      simp at hS1
    have h' : 1 ≤ Fintype.card α := this
    rw [hN]
    exact_mod_cast h'
  have hN0 : 0 < N := by linarith
  set p := ∑ b, w (d b) b with hp
  -- passage aux couples
  let a2 : α × β → ℝ := fun x => w x.1 x.2
  let b2 : α × β → ℝ := fun x => (∑ b', w x.1 b') * (∑ a', w a' x.2)
  have hb2 : ∀ x : α × β, b2 x = (1 / N) * (∑ a', w a' x.2) := by
    intro x; simp only [b2, hunif x.1]
  have hb2n : ∀ x ∈ (univ : Finset (α × β)), 0 ≤ b2 x := fun x _ =>
    mul_nonneg (sum_nonneg fun _ _ => hw _ _) (sum_nonneg fun _ _ => hw _ _)
  have hab : ∀ x ∈ (univ : Finset (α × β)), 0 < a2 x → 0 < b2 x := by
    intro x _ hx
    have h1 : w x.1 x.2 ≤ ∑ b', w x.1 b' :=
      single_le_sum (f := fun b' => w x.1 b') (fun _ _ => hw _ _) (mem_univ x.2)
    have h2 : w x.1 x.2 ≤ ∑ a', w a' x.2 :=
      single_le_sum (f := fun a' => w a' x.2) (fun _ _ => hw _ _) (mem_univ x.1)
    exact mul_pos (lt_of_lt_of_le hx h1) (lt_of_lt_of_le hx h2)
  set A := (univ : Finset (α × β)).filter (fun x => x.1 = d x.2) with hA
  set Ac := (univ : Finset (α × β)).filter (fun x => ¬ (x.1 = d x.2)) with hAc
  -- masses de A
  have hpA : ∑ x ∈ A, a2 x = p := by
    rw [hA, sum_filter, Fintype.sum_prod_type, Finset.sum_comm]
    apply sum_congr rfl
    intro b _
    simp only [a2]
    rw [sum_ite_eq']
    simp
  have hqB : ∑ b, ∑ a', w a' b = 1 := by rw [Finset.sum_comm]; exact hS1
  have hrA : ∑ x ∈ A, b2 x = 1 / N := by
    rw [hA, sum_filter, Fintype.sum_prod_type, Finset.sum_comm]
    simp only [hb2]
    have : ∀ b : β, (∑ a : α, if a = d b then 1 / N * ∑ a', w a' b else 0)
        = 1 / N * ∑ a', w a' b := by
      intro b; rw [sum_ite_eq']; simp
    simp only [this]
    rw [← mul_sum, hqB, mul_one]
  have htot_a : ∑ x : α × β, a2 x = 1 := by rw [Fintype.sum_prod_type]; exact hS1
  have htot_b : ∑ x : α × β, b2 x = 1 := by
    rw [Fintype.sum_prod_type]
    simp only [hb2]
    rw [sum_const, card_univ, nsmul_eq_mul, ← mul_sum, hqB, ← hN]
    field_simp
  have hpAc : ∑ x ∈ Ac, a2 x = 1 - p := by
    have h := sum_filter_add_sum_filter_not (univ : Finset (α × β)) (fun x => x.1 = d x.2) a2
    rw [← hA, ← hAc, hpA, htot_a] at h
    linarith
  have hrAc : ∑ x ∈ Ac, b2 x = 1 - 1 / N := by
    have h := sum_filter_add_sum_filter_not (univ : Finset (α × β)) (fun x => x.1 = d x.2) b2
    rw [← hA, ← hAc, hrA, htot_b] at h
    linarith
  have l1 := log_sum_ineq A a2 b2 (fun x _ => hw _ _) (fun x hx => hb2n x (mem_univ x))
    (fun x hx => hab x (mem_univ x))
  have l2 := log_sum_ineq Ac a2 b2 (fun x _ => hw _ _) (fun x hx => hb2n x (mem_univ x))
    (fun x hx => hab x (mem_univ x))
  rw [hpA, hrA] at l1
  rw [hpAc, hrAc] at l2
  have hsplit : miN w = ∑ x ∈ A, a2 x * Real.log (a2 x / b2 x) +
      ∑ x ∈ Ac, a2 x * Real.log (a2 x / b2 x) := by
    rw [hA, hAc, sum_filter_add_sum_filter_not]
    unfold miN; rw [Fintype.sum_prod_type]
  have hp0 : 0 ≤ p := sum_nonneg fun _ _ => hw _ _
  have hp1 : p ≤ 1 := by
    rw [← hpA, ← htot_a]
    exact sum_le_sum_of_subset_of_nonneg (filter_subset _ _) (fun x _ _ => hw _ _)
  -- minoration du premier bloc : p log(p/(1/N)) = p log N + p log p
  have e1 : p * Real.log N + p * Real.log p ≤ p * Real.log (p / (1 / N)) := by
    rcases hp0.lt_or_eq with h | h
    · rw [div_div_eq_mul_div, div_one, Real.log_mul h.ne' hN0.ne']; linarith
    · rw [← h]; simp
  -- minoration du second bloc : (1−p) log((1−p)/(1−1/N)) ≥ (1−p) log(1−p)
  have e2 : (1 - p) * Real.log (1 - p) ≤ (1 - p) * Real.log ((1 - p) / (1 - 1 / N)) := by
    rcases (sub_nonneg.2 hp1).lt_or_eq with h | h
    · apply mul_le_mul_of_nonneg_left _ h.le
      rcases (sub_nonneg.2 (div_le_one_of_le₀ hN1 hN0.le : 1 / N ≤ 1)).lt_or_eq with h' | h'
      · apply Real.log_le_log h
        rw [le_div_iff₀ h']
        nlinarith [div_pos one_pos hN0]
      · rw [← h', div_zero, Real.log_zero]
        exact Real.log_nonpos h.le (by linarith)
    · rw [← h]; simp
  have hb := binEnt_le_log_two hp0 hp1
  rw [hsplit]
  linarith

/-! ### 10.4 Modèle CLO concret

Loi jointe finie de (C, M, Σ) et interprétation admissible : le verdict est tiré
selon un noyau `ker c s` qui ne dépend que de (Σ, C), ce qui encode
K ⊥ M | (Σ, C) (Définition de l'interprétation admissible). -/

structure CLOModel (lam : ℕ) (M C S V : Type*) [Fintype M] [Fintype C] [Fintype S]
    [Fintype V] where
  P : C → M → S → ℝ
  P_nonneg : ∀ c m s, 0 ≤ P c m s
  P_sum : ∑ c, ∑ m, ∑ s, P c m s = 1
  /-- M a 2^λ valeurs, donc H(M) = λ bits. -/
  card_M : Fintype.card M = 2 ^ lam
  /-- M est uniforme et indépendant de C. -/
  unif : ∀ c m, ∑ s, P c m s = (∑ m', ∑ s, P c m' s) / (Fintype.card M : ℝ)
  ker : C → S → V → ℝ
  ker_nonneg : ∀ c s v, 0 ≤ ker c s v
  ker_sum : ∀ c s, ∑ v, ker c s v = 1

namespace CLOModel

variable {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C] [Fintype S] [Fintype V]
  [DecidableEq M] [Nonempty M] [Nonempty C] (X : CLOModel lam M C S V)

/-- Supports communs : les lois de Σ pour deux messages ont le même support, ce qui
    équivaut à la finitude des divergences de l'Hypothèse 3. Elle ne sert qu'à Pinsker
    et au Lemme 4, pas au trilemme. -/
abbrev CommonSupport : Prop := ∀ c m₀ m₁ s, 0 < X.P c m₀ s → 0 < X.P c m₁ s

/-- Loi de C. -/
noncomputable def pC (c : C) : ℝ := ∑ m, ∑ s, X.P c m s

/-- H(C) en bits, calculée à partir de la loi. -/
noncomputable def HC : ℝ := (-∑ c, X.pC c * Real.log (X.pC c)) / Real.log 2

/-- Loi de (M, Σ) sachant C = c. -/
noncomputable def qMS (c : C) (m : M) (s : S) : ℝ := X.P c m s / X.pC c

/-- Loi de Σ sachant (M, C) = (m, c). -/
noncomputable def qS (c : C) (m : M) (s : S) : ℝ := X.P c m s / ∑ s', X.P c m s'

/-- Loi de (Σ, V) sachant C = c. -/
noncomputable def qSV (c : C) (s : S) (v : V) : ℝ := (∑ m, X.qMS c m s) * X.ker c s v

/-- I(M;Σ|C) en bits. -/
noncomputable def I : ℝ := (∑ c, X.pC c * miN (X.qMS c)) / Real.log 2

/-- I(V;Σ|C) en bits. -/
noncomputable def IV : ℝ := (∑ c, X.pC c * miN (X.qSV c)) / Real.log 2

/-- H(V|C) en bits. -/
noncomputable def HV : ℝ := (∑ c, X.pC c * entN2 (X.qSV c)) / Real.log 2

/-- Variation totale et divergence (bits) entre les lois de Σ pour deux messages. -/
noncomputable def TV (x : C × M × M) : ℝ := tv (X.qS x.1 x.2.1) (X.qS x.1 x.2.2)

/-- Divergence (bits). Avec les conventions de Lean (log 0 = 0, x/0 = 0), elle
    sous-estime la vraie divergence, qui vaut +∞, lorsque les supports diffèrent.
    Elle n'est donc utilisée que sous `CommonSupport` (Pinsker, Lemme 4). -/
noncomputable def KL (x : C × M × M) : ℝ := klN (X.qS x.1 x.2.1) (X.qS x.1 x.2.2) / Real.log 2

noncomputable def TVmax : ℝ := (univ : Finset (C × M × M)).sup' univ_nonempty X.TV

noncomputable def KLmax : ℝ := (univ : Finset (C × M × M)).sup' univ_nonempty X.KL

/-- Conf = 1 − max TV. -/
noncomputable def Conf : ℝ := 1 - X.TVmax

/-- Fiabilité d'un décodeur D(c, σ) : probabilité de retrouver M. -/
noncomputable def Rel (D : C → S → M) : ℝ := ∑ c, ∑ m, ∑ s, if D c s = m then X.P c m s else 0

/-- Opp = I(V;Σ|C)/H(V|C). -/
noncomputable def Opp : ℝ := X.IV / X.HV

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma pC_nonneg (c : C) : 0 ≤ X.pC c :=
  sum_nonneg fun _ _ => sum_nonneg fun _ _ => X.P_nonneg _ _ _

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma sum_pC : ∑ c, X.pC c = 1 := X.P_sum

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma P_le_pC (c : C) (m : M) (s : S) : X.P c m s ≤ X.pC c := by
  unfold pC
  calc X.P c m s ≤ ∑ s', X.P c m s' :=
        single_le_sum (f := fun s' => X.P c m s') (fun _ _ => X.P_nonneg _ _ _) (mem_univ s)
    _ ≤ ∑ m', ∑ s', X.P c m' s' :=
        single_le_sum (f := fun m' => ∑ s', X.P c m' s')
          (fun _ _ => sum_nonneg fun _ _ => X.P_nonneg _ _ _) (mem_univ m)

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma P_eq_zero_of_pC (c : C) (h : X.pC c = 0) (m : M) (s : S) : X.P c m s = 0 :=
  le_antisymm (h ▸ X.P_le_pC c m s) (X.P_nonneg c m s)

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma qMS_nonneg (c : C) (m : M) (s : S) : 0 ≤ X.qMS c m s :=
  div_nonneg (X.P_nonneg _ _ _) (X.pC_nonneg c)

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma qMS_sum (c : C) (hc : 0 < X.pC c) : ∑ m, ∑ s, X.qMS c m s = 1 := by
  unfold qMS
  simp only [← sum_div]
  exact div_self hc.ne'

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma qMS_sum_le (c : C) : ∑ m, ∑ s, X.qMS c m s ≤ 1 := by
  rcases (X.pC_nonneg c).lt_or_eq with h | h
  · exact (X.qMS_sum c h).le
  · unfold qMS; rw [← h]; simp

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma qSV_nonneg (c : C) (s : S) (v : V) : 0 ≤ X.qSV c s v :=
  mul_nonneg (sum_nonneg fun _ _ => X.qMS_nonneg _ _ _) (X.ker_nonneg _ _ _)

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma qSV_sum_le (c : C) : ∑ s, ∑ v, X.qSV c s v ≤ 1 := by
  unfold qSV
  simp only [← mul_sum, X.ker_sum, mul_one]
  rw [Finset.sum_comm]
  exact X.qMS_sum_le c

lemma log_two_pos' : 0 < Real.log 2 := Real.log_pos (by norm_num)

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma I_nonneg : 0 ≤ X.I :=
  div_nonneg (sum_nonneg fun c _ => mul_nonneg (X.pC_nonneg c)
    (miN_nonneg _ (X.qMS_nonneg c) (X.qMS_sum_le c))) log_two_pos'.le

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma IV_nonneg : 0 ≤ X.IV :=
  div_nonneg (sum_nonneg fun c _ => mul_nonneg (X.pC_nonneg c)
    (miN_nonneg _ (X.qSV_nonneg c) (X.qSV_sum_le c))) log_two_pos'.le

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
/-- I(V;Σ|C) ≤ H(V|C), démontré (et non supposé). -/
lemma IV_le_HV : X.IV ≤ X.HV := by
  unfold IV HV
  apply div_le_div_of_nonneg_right _ log_two_pos'.le
  exact sum_le_sum fun c _ => mul_le_mul_of_nonneg_left
    (miN_le_entN2 _ (X.qSV_nonneg c)) (X.pC_nonneg c)

lemma tv_nonneg {α : Type*} [Fintype α] (P Q : α → ℝ) : 0 ≤ tv P Q :=
  sum_nonneg fun _ _ => le_max_right _ _

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma TV_nonneg (x : C × M × M) : 0 ≤ X.TV x := tv_nonneg _ _

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma qS_nonneg (c : C) (m : M) (s : S) : 0 ≤ X.qS c m s :=
  div_nonneg (X.P_nonneg _ _ _) (sum_nonneg fun _ _ => X.P_nonneg _ _ _)

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma qS_sum_le (c : C) (m : M) : ∑ s, X.qS c m s ≤ 1 := by
  unfold qS
  rw [← sum_div]
  rcases (sum_nonneg fun s _ => X.P_nonneg c m s : 0 ≤ ∑ s, X.P c m s).lt_or_eq with h | h
  · rw [div_self h.ne']
  · rw [← h]; simp

omit [DecidableEq M] [Nonempty M] [Nonempty C] in
lemma TV_le_one (x : C × M × M) : X.TV x ≤ 1 := by
  unfold TV tv
  calc ∑ s, max (X.qS x.1 x.2.1 s - X.qS x.1 x.2.2 s) 0 ≤ ∑ s, X.qS x.1 x.2.1 s :=
        sum_le_sum fun s _ => max_le (by linarith [X.qS_nonneg x.1 x.2.2 s]) (X.qS_nonneg _ _ _)
    _ ≤ 1 := X.qS_sum_le _ _

omit [DecidableEq M] in
lemma TVmax_mem : ∃ x, X.TVmax = X.TV x := by
  obtain ⟨x, _, hx⟩ := exists_mem_eq_sup' (univ_nonempty (α := C × M × M)) X.TV
  exact ⟨x, hx⟩

omit [DecidableEq M] in
lemma TVmax_nonneg : 0 ≤ X.TVmax := by
  obtain ⟨x, hx⟩ := X.TVmax_mem; rw [hx]; exact X.TV_nonneg x

omit [DecidableEq M] in
lemma TVmax_le_one : X.TVmax ≤ 1 := by
  obtain ⟨x, hx⟩ := X.TVmax_mem; rw [hx]; exact X.TV_le_one x

omit [DecidableEq M] in
/-- **Pinsker démontré** pour les lois conditionnelles du modèle (bits).
    La preuve établit d'abord TV² ≤ ½·KL en nats (`pinsker_finite`), soit
    TV² ≤ (ln 2/2)·KL en bits, qui est la forme la plus fine. Elle en déduit la
    forme avec c₀ = 1/(2 ln 2), plus faible d'un facteur 1/(ln 2)² ≈ 2,08, car
    (ln 2)² < 1. Le Lemme 4 énoncé avec c₀ reste donc vrai. -/
lemma pinsker_model (hsupp : X.CommonSupport) : X.TVmax ^ 2 ≤ c0 * X.KLmax := by
  obtain ⟨x, hx⟩ := X.TVmax_mem
  rw [hx]
  have hKL : X.KL x ≤ X.KLmax := le_sup' X.KL (mem_univ x)
  obtain ⟨c, m₀, m₁⟩ := x
  have hl2 := log_two_pos'
  -- cas d'une masse nulle : les deux lois conditionnelles sont nulles
  have hsum : ∀ m, (∑ s, X.P c m s) = X.pC c / (Fintype.card M : ℝ) := fun m => X.unif c m
  have hcard : (0 : ℝ) < Fintype.card M := by exact_mod_cast Fintype.card_pos
  rcases (X.pC_nonneg c).lt_or_eq with hc | hc
  · have hden : ∀ m, 0 < ∑ s, X.P c m s := fun m => by rw [hsum m]; positivity
    have h1 : ∀ m, ∑ s, X.qS c m s = 1 := fun m => by
      unfold qS; rw [← sum_div, div_self (hden m).ne']
    have hac : ∀ s, 0 < X.qS c m₀ s → 0 < X.qS c m₁ s := by
      intro s hs
      have : 0 < X.P c m₀ s := by
        unfold qS at hs
        rcases (X.P_nonneg c m₀ s).lt_or_eq with h | h
        · exact h
        · rw [← h, zero_div] at hs; exact absurd hs (lt_irrefl 0)
      exact div_pos (hsupp c m₀ m₁ s this) (hden m₁)
    have hp := pinsker_finite (X.qS c m₀) (X.qS c m₁) (X.qS_nonneg c m₀) (X.qS_nonneg c m₁)
      (h1 m₀) (h1 m₁) hac
    have hKLn : 0 ≤ klN (X.qS c m₀) (X.qS c m₁) := by
      have := sq_nonneg (tv (X.qS c m₀) (X.qS c m₁)); linarith
    -- ½·KL_nats ≤ c₀·KL_bits car (log 2)² < 1
    have hlt : Real.log 2 < 1 := by
      have := Real.log_lt_sub_one_of_pos (by norm_num : (0 : ℝ) < 2) (by norm_num)
      linarith
    have hconv : klN (X.qS c m₀) (X.qS c m₁) / 2 ≤ c0 * X.KL (c, m₀, m₁) := by
      unfold KL c0
      rw [show (1 / (2 * Real.log 2)) * (klN (X.qS c m₀) (X.qS c m₁) / Real.log 2)
          = klN (X.qS c m₀) (X.qS c m₁) / (2 * Real.log 2 ^ 2) by field_simp]
      apply div_le_div_of_nonneg_left hKLn (by positivity)
      nlinarith
    have hc0 := c0_pos
    calc X.TV (c, m₀, m₁) ^ 2 ≤ klN (X.qS c m₀) (X.qS c m₁) / 2 := hp
      _ ≤ c0 * X.KL (c, m₀, m₁) := hconv
      _ ≤ c0 * X.KLmax := mul_le_mul_of_nonneg_left hKL hc0.le
  · -- masse nulle : TV = 0 et KL = 0
    have hz : ∀ m s, X.qS c m s = 0 := by
      intro m s; unfold qS; rw [X.P_eq_zero_of_pC c hc.symm m s, zero_div]
    have hTV0 : X.TV (c, m₀, m₁) = 0 := by unfold TV tv; simp [hz]
    have hKL0 : X.KL (c, m₀, m₁) = 0 := by unfold KL klN; simp [hz]
    rw [hTV0]
    have : 0 ≤ X.KLmax := hKL0 ▸ hKL
    have hc0 := c0_pos
    nlinarith

omit [Nonempty C] in
/-- **Fano démontré** : I(M;Σ|C) ≥ Rel(D)·λ − 1, pour tout décodeur D. -/
lemma fano_model (D : C → S → M) : X.Rel D * lam - 1 ≤ X.I := by
  have hl2 := log_two_pos'
  have hcard : (Fintype.card M : ℝ) = 2 ^ lam := by exact_mod_cast X.card_M
  have hlogN : Real.log (Fintype.card M : ℝ) = lam * Real.log 2 := by
    rw [hcard, Real.log_pow]
  -- contribution de chaque contexte
  have hc : ∀ c, X.pC c * (∑ s, X.qMS c (D c s) s) * (lam * Real.log 2) - X.pC c * Real.log 2
      ≤ X.pC c * miN (X.qMS c) := by
    intro c
    rcases (X.pC_nonneg c).lt_or_eq with h | h
    · have hu : ∀ m, ∑ s, X.qMS c m s = 1 / (Fintype.card M : ℝ) := by
        intro m
        unfold qMS
        rw [← sum_div, X.unif c m]
        have hpos : X.pC c ≠ 0 := h.ne'
        unfold pC at hpos ⊢
        field_simp
      have hf := fano_finite (X.qMS c) (X.qMS_nonneg c) (X.qMS_sum c h) hu (D c)
      rw [hlogN] at hf
      have := mul_le_mul_of_nonneg_left hf h.le
      nlinarith
    · rw [← h]; simp
  have hsum := sum_le_sum fun c (_ : c ∈ (univ : Finset C)) => hc c
  rw [sum_sub_distrib, ← sum_mul, ← sum_mul, X.sum_pC, one_mul] at hsum
  -- Σ_c pC·Σ_s qMS(D c s) = Rel
  have hrel : ∑ c, X.pC c * (∑ s, X.qMS c (D c s) s) = X.Rel D := by
    unfold Rel
    apply sum_congr rfl
    intro c _
    rw [Finset.sum_comm]
    have : ∀ s, (∑ m, if D c s = m then X.P c m s else 0) = X.P c (D c s) s := by
      intro s; rw [sum_ite_eq]; simp
    simp only [this]
    unfold qMS
    rcases (X.pC_nonneg c).lt_or_eq with h | h
    · rw [mul_sum]; apply sum_congr rfl; intro s _; field_simp
    · simp [← h, X.P_eq_zero_of_pC c h.symm]
  have e : (∑ c, X.pC c * (∑ s, X.qMS c (D c s) s)) * (lam * Real.log 2)
      = X.Rel D * lam * Real.log 2 := by
    rw [hrel]; ring
  rw [e] at hsum
  unfold I
  rw [le_div_iff₀ hl2]
  nlinarith

omit [Nonempty M] [Nonempty C] in
/-- Rel(D) ∈ [0, 1]. -/
lemma Rel_mem (D : C → S → M) : 0 ≤ X.Rel D ∧ X.Rel D ≤ 1 := by
  constructor
  · exact sum_nonneg fun _ _ => sum_nonneg fun _ _ => sum_nonneg fun _ _ => by
      split_ifs <;> simp [X.P_nonneg]
  · rw [← X.P_sum]
    exact sum_le_sum fun _ _ => sum_le_sum fun _ _ => sum_le_sum fun _ _ => by
      split_ifs <;> simp [X.P_nonneg]

/-- Le modèle concret fournit une `ProtocolInstance` : Pinsker et Fano y sont
    des théorèmes et non des champs supposés. -/
noncomputable def toInstance (prm : InstitutionalParams) (D : C → S → M)
    (hs : X.CommonSupport) : ProtocolInstance lam :=
  { params := prm, Conf := X.Conf, Rel := X.Rel D, Opp := X.Opp, I := X.I,
    IV := X.IV, HV := X.HV, TVmax := X.TVmax, KLmax := X.KLmax,
    hConf := rfl, hOpp := rfl, hTV := ⟨X.TVmax_nonneg, X.TVmax_le_one⟩,
    hRel := X.Rel_mem D, hI := X.I_nonneg, hIV := X.IV_nonneg,
    pinsker := X.pinsker_model hs,
    fano := X.fano_model D }

end CLOModel

/-! ### 10.5 Noyau du produit sans Pinsker ni Hypothèse 3

Le produit Conf·Rel·Opp n'utilise que Conf ≤ 1, Fano, les Hypothèses 1 et 2′ et le
régime. Pinsker et l'Hypothèse 3 ne servent qu'au Lemme 4. -/

/-- Forme explicite, pour des réels quelconques satisfaisant les seules relations utiles. -/
theorem product_bound_explicit {Conf Rel Opp I IV HV Δ γ κ : ℝ} {lam : ℕ}
    (hC1 : Conf ≤ 1) (hR0 : 0 ≤ Rel) (hfano : Rel * lam - 1 ≤ I) (hI : 0 ≤ I)
    (hIV : 0 ≤ IV) (hOpp : Opp = IV / HV)
    (A1 : IV ≤ I + Δ) (A2 : γ ≤ HV) (A2γ : 1 ≤ γ) (hκ : 0 ≤ κ) (hlam : 1 ≤ lam)
    (A4 : I ≤ κ / lam) :
    Conf * Rel * Opp ≤
      (1 / γ) * (Δ / lam + κ * (Δ + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 3) := by
  have hl : (1 : ℝ) ≤ lam := by exact_mod_cast hlam
  have hl0 : (0 : ℝ) < lam := by linarith
  have hγ0 : 0 < γ := by linarith
  have hHV : 0 < HV := by linarith
  have hκl : 0 ≤ κ / lam := div_nonneg hκ hl0.le
  have hR : Rel ≤ (I + 1) / lam := by rw [le_div_iff₀ hl0]; linarith
  have hO0 : 0 ≤ Opp := by rw [hOpp]; exact div_nonneg hIV hHV.le
  have hO : Opp ≤ (I + Δ) / γ := by
    rw [hOpp, div_le_div_iff₀ hHV hγ0]
    have e1 := mul_le_mul_of_nonneg_right A1 hγ0.le
    have e2 := mul_le_mul_of_nonneg_left A2 (by linarith : (0 : ℝ) ≤ I + Δ)
    linarith
  have hRx : (I + 1) / lam ≤ (κ / lam + 1) / lam := by
    rw [div_le_div_iff_of_pos_right hl0]; linarith
  have hOx : (I + Δ) / γ ≤ (κ / lam + Δ) / γ := by
    rw [div_le_div_iff_of_pos_right hγ0]; linarith
  have hb0 : 0 ≤ (I + 1) / lam := div_nonneg (by linarith) hl0.le
  have hb0' : 0 ≤ (κ / lam + 1) / lam := div_nonneg (by linarith) hl0.le
  have hl0' : (lam : ℝ) ≠ 0 := hl0.ne'
  have hγ' : γ ≠ 0 := hγ0.ne'
  calc Conf * Rel * Opp
      ≤ 1 * ((I + 1) / lam) * ((I + Δ) / γ) :=
        mul_le_mul (mul_le_mul hC1 hR hR0 zero_le_one) hO hO0 (by rw [one_mul]; exact hb0)
    _ ≤ 1 * ((κ / lam + 1) / lam) * ((κ / lam + Δ) / γ) :=
        mul_le_mul (by rw [one_mul, one_mul]; exact hRx) hOx
          (div_nonneg (by linarith) hγ0.le) (by rw [one_mul]; exact hb0')
    _ = (1 / γ) * (Δ / lam + κ * (Δ + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 3) := by
        field_simp
        ring

/-- Forme raffinée, pour des réels quelconques. -/
theorem product_bound_refined {Conf Rel Opp I IV HV Δ γ κ : ℝ} {lam : ℕ}
    (hC1 : Conf ≤ 1) (hR0 : 0 ≤ Rel) (hfano : Rel * lam - 1 ≤ I)
    (hIV : 0 ≤ IV) (hOpp : Opp = IV / HV)
    (A1 : IV ≤ I + Δ) (A2 : γ ≤ HV) (A2γ : 1 ≤ γ) (hκ : 0 ≤ κ) (hlam : 1 ≤ lam)
    (A4 : I ≤ κ / lam) (hIVHV : IV ≤ HV) :
    Conf * Rel * Opp ≤ ((κ / lam + 1) / lam) * min 1 ((κ / lam + Δ) / γ) := by
  have hl0 : (0 : ℝ) < lam := by exact_mod_cast hlam
  have hγ0 : 0 < γ := by linarith
  have hHV : 0 < HV := by linarith
  have hκl : 0 ≤ κ / lam := div_nonneg hκ hl0.le
  have hR : Rel ≤ (κ / lam + 1) / lam := by rw [le_div_iff₀ hl0]; linarith
  have hO0 : 0 ≤ Opp := by rw [hOpp]; exact div_nonneg hIV hHV.le
  have hO1 : Opp ≤ 1 := by rw [hOpp, div_le_one hHV]; exact hIVHV
  have hO2 : Opp ≤ (κ / lam + Δ) / γ := by
    rw [hOpp, div_le_div_iff₀ hHV hγ0]
    have e1 := mul_le_mul_of_nonneg_right A1 hγ0.le
    have e2 := mul_le_mul_of_nonneg_left A2 (by linarith : (0 : ℝ) ≤ κ / lam + Δ)
    have e3 : I * γ ≤ κ / lam * γ := mul_le_mul_of_nonneg_right A4 hγ0.le
    nlinarith
  have hOm : Opp ≤ min 1 ((κ / lam + Δ) / γ) := le_min hO1 hO2
  calc Conf * Rel * Opp ≤ 1 * ((κ / lam + 1) / lam) * min 1 ((κ / lam + Δ) / γ) :=
        mul_le_mul (mul_le_mul hC1 hR hR0 zero_le_one) hOm hO0
          (by rw [one_mul]; exact div_nonneg (by linarith) hl0.le)
    _ = _ := by ring

/-- Passage de la forme explicite à la forme asymptotique, pour une suite quelconque. -/
theorem asymptotic_of_explicit (f : ℕ → ℝ) {Δ γ κ : ℝ} (hΔ : 0 ≤ Δ) (hγ : 1 ≤ γ)
    (hκ : 0 ≤ κ) (hf : ∀ lam : ℕ, 64 ≤ lam →
      f lam ≤ (1 / γ) * (Δ / lam + κ * (Δ + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 3)) :
    ∃ K : ℝ, ∃ ε : ℕ → ℝ, Negligible ε ∧ ∀ lam : ℕ, 64 ≤ lam →
      f lam ≤ Δ / lam + K / (lam : ℝ) ^ 2 + ε lam := by
  refine ⟨κ * (Δ + 1) + κ ^ 2, ε₀, negligible_eps0, fun lam hlam => ?_⟩
  have hl : (1 : ℝ) ≤ lam := by exact_mod_cast (by omega : 1 ≤ lam)
  have hl0 : (0 : ℝ) < lam := by linarith
  have h := hf lam hlam
  have hB : 0 ≤ Δ / lam + κ * (Δ + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 3 := by
    have hl2 : (0 : ℝ) < (lam : ℝ) ^ 2 := by positivity
    have hl3 : (0 : ℝ) < (lam : ℝ) ^ 3 := by positivity
    exact add_nonneg (add_nonneg (div_nonneg hΔ hl0.le)
      (div_nonneg (mul_nonneg hκ (by linarith)) hl2.le)) (div_nonneg (sq_nonneg κ) hl3.le)
  have hγ1 : 1 / γ ≤ 1 := by rw [div_le_one (by linarith)]; exact hγ
  have h1 := h.trans (mul_le_of_le_one_left hB hγ1)
  have hε := ε₀_nonneg lam
  have h3 : κ ^ 2 / (lam : ℝ) ^ 3 ≤ κ ^ 2 / (lam : ℝ) ^ 2 := by
    have e : κ ^ 2 / (lam : ℝ) ^ 3 = κ ^ 2 / (lam : ℝ) ^ 2 * (1 / lam) := by field_simp
    rw [e]
    exact mul_le_of_le_one_right (by positivity) (by rw [div_le_one hl0]; exact hl)
  have hK : (κ * (Δ + 1) + κ ^ 2) / (lam : ℝ) ^ 2 =
      κ * (Δ + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 2 := add_div _ _ _
  linarith

/-! ### 10.6 Trilemme CRO sur de vraies lois

Dans cette couche, H(C) est l'entropie de la loi de C et γ = α·H(C) − 1. -/

/-- Entropie de C positive. -/
lemma CLOModel.HC_nonneg {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C] [Fintype S]
    [Fintype V] (X : CLOModel lam M C S V) : 0 ≤ X.HC := by
  unfold CLOModel.HC
  apply div_nonneg _ (Real.log_pos (by norm_num)).le
  rw [neg_nonneg]
  apply sum_nonpos
  intro c _
  have h0 := X.pC_nonneg c
  have h1 : X.pC c ≤ 1 := by
    rw [← X.sum_pC]
    exact single_le_sum (f := X.pC) (fun c _ => X.pC_nonneg c) (mem_univ c)
  exact mul_nonpos_of_nonneg_of_nonpos h0 (Real.log_nonpos h0 h1)

open CLOModel in
set_option linter.unusedVariables false in
/-- **Théorème 1 (forme explicite), sans axiomatisation de Fano ni de Pinsker.**
    Pour toute loi finie (C, M, Σ, V) avec M uniforme sur 2^λ valeurs et indépendant
    de C, toute interprétation admissible et tout décodeur D, avec γ = α·H(C) − 1,
    sous les Hypothèses 1, 2′ et 4 :
    Conf·Rel(D)·Opp ≤ (1/γ)·(Δ/λ + κ(Δ+1)/λ² + κ²/λ³).
    L'hypothèse `hcard` (taille de l'espace des verdicts, Hypothèse 2′) figure par
    fidélité ; la preuve ne l'utilise pas. L'Hypothèse 3 et les supports communs
    n'interviennent pas. -/
theorem trilemma_explicit_concrete {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C]
    [Fintype S] [Fintype V] [DecidableEq M] [Nonempty M] [Nonempty C]
    (X : CLOModel lam M C S V) (D : C → S → M) (Δ α : ℝ)
    (hcard : Real.log (Fintype.card V) / Real.log 2 ≤ α * X.HC)
    (A1 : X.IV ≤ X.I + Δ) (A2 : α * X.HC - 1 ≤ X.HV) (A2γ : 1 ≤ α * X.HC - 1)
    (κ : ℝ) (hκ : 0 ≤ κ) (hlam : 1 ≤ lam) (A4 : X.I ≤ κ / lam) :
    X.Conf * X.Rel D * X.Opp ≤
      (1 / (α * X.HC - 1)) * (Δ / lam + κ * (Δ + 1) / (lam : ℝ) ^ 2
        + κ ^ 2 / (lam : ℝ) ^ 3) :=
  product_bound_explicit (by unfold Conf; linarith [X.TVmax_nonneg]) (X.Rel_mem D).1
    (X.fano_model D) X.I_nonneg X.IV_nonneg rfl A1 A2 A2γ hκ hlam A4

open CLOModel in
set_option linter.unusedVariables false in
/-- **Forme raffinée concrète.** L'inégalité I(V;Σ|C) ≤ H(V|C) y est démontrée.
    L'hypothèse `hcard` figure par fidélité à l'Hypothèse 2′ ; la preuve ne l'utilise
    pas. -/
theorem trilemma_refined_concrete {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C]
    [Fintype S] [Fintype V] [DecidableEq M] [Nonempty M] [Nonempty C]
    (X : CLOModel lam M C S V) (D : C → S → M) (Δ α : ℝ)
    (hcard : Real.log (Fintype.card V) / Real.log 2 ≤ α * X.HC)
    (A1 : X.IV ≤ X.I + Δ) (A2 : α * X.HC - 1 ≤ X.HV) (A2γ : 1 ≤ α * X.HC - 1)
    (κ : ℝ) (hκ : 0 ≤ κ) (hlam : 1 ≤ lam) (A4 : X.I ≤ κ / lam) :
    X.Conf * X.Rel D * X.Opp ≤
      ((κ / lam + 1) / lam) * min 1 ((κ / lam + Δ) / (α * X.HC - 1)) :=
  product_bound_refined (by unfold Conf; linarith [X.TVmax_nonneg]) (X.Rel_mem D).1
    (X.fano_model D) X.IV_nonneg rfl A1 A2 A2γ hκ hlam A4 X.IV_le_HV

open CLOModel in
/-- **Lemme 4 concret** : Conf ≥ 1 − √(c₀·β·I(M;Σ|C)). Il utilise Pinsker, donc les
    supports communs et l'Hypothèse 3 avec la constante β ≥ 1. Les paramètres de
    l'instance sont H = H(C) tirée de la loi et β ; Δ et α n'interviennent pas. -/
theorem lemma4_concrete {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C]
    [Fintype S] [Fintype V] [DecidableEq M] [Nonempty M] [Nonempty C]
    (X : CLOModel lam M C S V) (β : ℝ) (hβ : 1 ≤ β) (D : C → S → M)
    (hs : X.CommonSupport) (A3 : X.KLmax ≤ β * X.I) :
    1 - Real.sqrt (c0 * β * X.I) ≤ X.Conf :=
  lemma4_confidentiality_guarantee
    (X.toInstance ⟨X.HC, 0, 1, β, X.HC_nonneg, le_rfl, one_pos, hβ⟩ D hs) A3

open CLOModel in
/-- **Théorème 1 (forme asymptotique), sur de vraies lois.** Famille de modèles indexée
    par λ, avec C et V fixes et une entropie H(C) minorée par H₀, d'où
    γ = α·H(C) − 1 ≥ α·H₀ − 1. Sous les hypothèses pour λ ≥ 64, il existe K et ε
    négligeable tels que Conf·Rel·Opp ≤ Δ/λ + K/λ² + ε(λ) pour λ ≥ 64.
    L'hypothèse `hcard` figure par fidélité à l'Hypothèse 2′ ; la preuve ne s'en sert
    que pour la transmettre à la forme explicite, qui ne l'utilise pas. Le terme ε
    garde la forme publiée et le seuil 64 celui de la thèse. -/
theorem conditional_CRO_trilemma_concrete {M S : ℕ → Type} {C V : Type}
    [∀ l, Fintype (M l)] [∀ l, DecidableEq (M l)] [∀ l, Nonempty (M l)]
    [∀ l, Fintype (S l)] [Fintype C] [Fintype V] [Nonempty C]
    (X : ∀ lam, CLOModel lam (M lam) C (S lam) V) (D : ∀ lam, C → S lam → M lam)
    (Δ α H₀ κ : ℝ) (hα : 0 < α) (hΔ : 0 ≤ Δ) (hκ : 0 ≤ κ) (A2γ : 1 ≤ α * H₀ - 1)
    (hHC : ∀ lam, 64 ≤ lam → H₀ ≤ (X lam).HC)
    (hcard : ∀ lam, 64 ≤ lam → Real.log (Fintype.card V) / Real.log 2 ≤ α * (X lam).HC)
    (A1 : ∀ lam, 64 ≤ lam → (X lam).IV ≤ (X lam).I + Δ)
    (A2 : ∀ lam, 64 ≤ lam → α * (X lam).HC - 1 ≤ (X lam).HV)
    (A4 : ∀ lam, 64 ≤ lam → (X lam).I ≤ κ / lam) :
    ∃ K : ℝ, ∃ ε : ℕ → ℝ, Negligible ε ∧ ∀ lam : ℕ, 64 ≤ lam →
      (X lam).Conf * (X lam).Rel (D lam) * (X lam).Opp ≤
        Δ / lam + K / (lam : ℝ) ^ 2 + ε lam := by
  apply asymptotic_of_explicit _ hΔ A2γ hκ
  intro lam hlam
  have hγ : α * H₀ - 1 ≤ α * (X lam).HC - 1 := by
    have := mul_le_mul_of_nonneg_left (hHC lam hlam) hα.le; linarith
  have h := trilemma_explicit_concrete (X lam) (D lam) Δ α (hcard lam hlam)
    (A1 lam hlam) (A2 lam hlam) (A2γ.trans hγ) κ hκ (by omega) (A4 lam hlam)
  have hl : (1 : ℝ) ≤ lam := by exact_mod_cast (by omega : 1 ≤ lam)
  have hl0 : (0 : ℝ) < lam := by linarith
  have hB : 0 ≤ Δ / lam + κ * (Δ + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 3 := by positivity
  have hinv : 1 / (α * (X lam).HC - 1) ≤ 1 / (α * H₀ - 1) :=
    one_div_le_one_div_of_le (by linarith) hγ
  exact h.trans (mul_le_mul_of_nonneg_right hinv hB)

/-! ### 10.7 Une famille de lois concrètes satisfait toutes les hypothèses

Témoin de non-vacuité pour tout λ : M uniforme sur 2^λ valeurs, C et Σ deux bits
uniformes, les trois indépendants et un verdict qui recopie la preuve. Toutes les
hypothèses des théorèmes concrets, y compris les supports communs et l'Hypothèse 3,
sont satisfaites et le théorème asymptotique s'applique à cette famille. -/

/-- Loi uniforme sur (C, M, Σ) ∈ {0,1} × {0,1}^λ × {0,1} et verdict V = Σ. -/
noncomputable def famModel (l : ℕ) : CLOModel l (Fin (2 ^ l)) (Fin 2) (Fin 2) (Fin 2) where
  P := fun _ _ _ => 1 / (4 * 2 ^ l)
  P_nonneg := fun _ _ _ => by positivity
  P_sum := by
    simp only [sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
    push_cast
    field_simp
    norm_num
  card_M := by simp
  unif := fun _ _ => by
    simp only [sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
    push_cast
    field_simp
  ker := fun _ s v => if v = s then 1 else 0
  ker_nonneg := fun _ _ _ => by split_ifs <;> norm_num
  ker_sum := fun _ s => by simp

namespace CLOModel

lemma fam_P (l : ℕ) (c : Fin 2) (m : Fin (2 ^ l)) (s : Fin 2) :
    (famModel l).P c m s = 1 / (4 * 2 ^ l) := rfl

lemma fam_ker (l : ℕ) (c s v : Fin 2) :
    (famModel l).ker c s v = if v = s then 1 else 0 := rfl

lemma fam_pC (l : ℕ) (c : Fin 2) : (famModel l).pC c = 1 / 2 := by
  simp only [pC, fam_P, sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
  push_cast
  field_simp
  norm_num

lemma fam_rowM (l : ℕ) (c : Fin 2) (m : Fin (2 ^ l)) :
    ∑ s, (famModel l).qMS c m s = 1 / 2 ^ l := by
  simp only [qMS, fam_P, fam_pC, sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
  field_simp
  norm_num

lemma fam_colS (l : ℕ) (c : Fin 2) (s : Fin 2) :
    ∑ m, (famModel l).qMS c m s = 1 / 2 := by
  simp only [qMS, fam_P, fam_pC, sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
  push_cast
  field_simp
  norm_num

lemma fam_I (l : ℕ) : (famModel l).I = 0 := by
  have h : ∀ c, miN ((famModel l).qMS c) = 0 := by
    intro c
    unfold miN
    apply sum_eq_zero
    intro m _
    apply sum_eq_zero
    intro s _
    rw [fam_rowM, fam_colS]
    have e : (famModel l).qMS c m s / (1 / 2 ^ l * (1 / 2)) = 1 := by
      simp only [qMS, fam_P, fam_pC]
      field_simp
      ring
    rw [e, Real.log_one, mul_zero]
  simp [I, h]

lemma fam_qSV (l : ℕ) (c s v : Fin 2) :
    (famModel l).qSV c s v = if v = s then 1 / 2 else 0 := by
  simp only [qSV, fam_colS, fam_ker]
  split_ifs <;> norm_num

lemma fam_IV (l : ℕ) : (famModel l).IV = 1 := by
  have hl2 : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  have h : ∀ c, miN ((famModel l).qSV c) = Real.log 2 := by
    intro c
    simp only [miN, fam_qSV, Fin.sum_univ_two]
    norm_num
    ring
  simp only [IV, h, fam_pC, Fin.sum_univ_two]
  field_simp
  ring

lemma fam_HV (l : ℕ) : (famModel l).HV = 1 := by
  have hl2 : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  have h : ∀ c, entN2 ((famModel l).qSV c) = Real.log 2 := by
    intro c
    simp only [entN2, fam_qSV, Fin.sum_univ_two]
    norm_num
    simp only [one_div, Real.log_inv]
    ring
  simp only [HV, h, fam_pC, Fin.sum_univ_two]
  field_simp
  ring

lemma fam_HC (l : ℕ) : (famModel l).HC = 1 := by
  have hl2 : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  simp only [HC, fam_pC, Fin.sum_univ_two]
  simp only [one_div, Real.log_inv]
  field_simp
  ring

lemma fam_support (l : ℕ) : (famModel l).CommonSupport := fun c _ m₁ s _ => by
  rw [fam_P]; positivity

lemma fam_KLmax (l : ℕ) : (famModel l).KLmax ≤ 0 := by
  apply Finset.sup'_le
  intro x _
  have e : ∀ m s, (famModel l).qS x.1 m s = 1 / 2 := by
    intro m s
    simp only [qS, fam_P, Fin.sum_univ_two]
    field_simp
    ring
  simp [KL, klN, e]

end CLOModel

open CLOModel in
/-- **Non-vacuité sur de vraies lois.** Pour tout λ, le modèle `famModel λ` satisfait
    toutes les hypothèses des théorèmes concrets avec Δ = 1, α = 2, β = 1 et κ = 0
    (contexte d'un bit uniforme, donc H(C) = 1 et γ = 1) : taille de l'espace des verdicts, Hypothèses 1, 2′, 3
    et 4, supports communs. -/
theorem concrete_assumptions_satisfiable (l : ℕ) :
    Real.log (Fintype.card (Fin 2)) / Real.log 2 ≤ 2 * (famModel l).HC ∧
    (famModel l).IV ≤ (famModel l).I + 1 ∧
    2 * (famModel l).HC - 1 ≤ (famModel l).HV ∧
    1 ≤ 2 * (famModel l).HC - 1 ∧
    (famModel l).KLmax ≤ 1 * (famModel l).I ∧
    (famModel l).I ≤ 0 / l ∧
    (famModel l).CommonSupport := by
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, fam_support l⟩
  · rw [fam_HC]; simp [div_self hl2.ne']
  · rw [fam_IV, fam_I]; norm_num
  · rw [fam_HC, fam_HV]; norm_num
  · rw [fam_HC]; norm_num
  · rw [fam_I, mul_zero]; exact fam_KLmax l
  · rw [fam_I]; simp

open CLOModel in
/-- Le théorème asymptotique concret s'applique effectivement à la famille témoin. -/
theorem concrete_asymptotic_applies :
    ∃ K : ℝ, ∃ ε : ℕ → ℝ, Negligible ε ∧ ∀ lam : ℕ, 64 ≤ lam →
      (famModel lam).Conf * (famModel lam).Rel (fun _ _ => ⟨0, by positivity⟩) *
        (famModel lam).Opp ≤ 1 / lam + K / (lam : ℝ) ^ 2 + ε lam :=
  conditional_CRO_trilemma_concrete famModel (fun _ _ _ => ⟨0, by positivity⟩) 1 2 1 0
    (by norm_num) (by norm_num) le_rfl (by norm_num) (fun l _ => (fam_HC l).ge)
    (fun l _ => (concrete_assumptions_satisfiable l).1)
    (fun l _ => (concrete_assumptions_satisfiable l).2.1)
    (fun l _ => (concrete_assumptions_satisfiable l).2.2.1)
    (fun l _ => by rw [fam_I]; simp)


end ConditionalCRO

/-! ## 11. Bloc de vérification pour l'évaluateur

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
#print axioms ConditionalCRO.factor_lt_one_iff
#print axioms ConditionalCRO.seuil_Hsharp
#print axioms ConditionalCRO.pinsker_finite
#print axioms ConditionalCRO.fano_finite
#print axioms ConditionalCRO.trilemma_explicit_concrete
#print axioms ConditionalCRO.trilemma_refined_concrete
#print axioms ConditionalCRO.lemma4_concrete
#print axioms ConditionalCRO.conditional_CRO_trilemma_concrete
#print axioms ConditionalCRO.concrete_assumptions_satisfiable
#print axioms ConditionalCRO.concrete_asymptotic_applies


/-! ## 12. Extension de la couche concrète (version 3.5, lot L1)

Ajout du 27 novembre 2026. Les sections 1 à 11 ci-dessus sont celles de la version
3.4, inchangées. Cette section démontre sur lois finies les résultats d'information
classique du chapitre 2 du manuscrit v36 : DPI (Lemmes 1.3 et A.2), Théorèmes 2.1 à
2.3, Proposition 2.1, Remarques 2.3 à 2.5, 2.11, 2.12, 2.15 et 3.9. Elle n'utilise
que Mathlib et aucune hypothèse nouvelle. -/

section ExtensionL1

open Finset

namespace ConditionalCRO

/-! ### 12.1 Symétrie, entropie de la première marginale, borne par le cardinal -/

/-- Entropie (nats) de la première marginale de w. -/
noncomputable def entN1 {α β : Type*} [Fintype α] [Fintype β] (w : α → β → ℝ) : ℝ :=
  -∑ a, (∑ b, w a b) * Real.log (∑ b, w a b)

/-- Symétrie de l'information mutuelle, I(A;B) = I(B;A). -/
theorem miN_symm {α β : Type*} [Fintype α] [Fintype β] (w : α → β → ℝ) :
    miN w = miN (fun b a => w a b) := by
  unfold miN
  rw [Finset.sum_comm]
  refine sum_congr rfl fun b _ => sum_congr rfl fun a _ => ?_
  rw [mul_comm (∑ b', w a b')]

/-- I(A;B) ≤ H(A). -/
theorem miN_le_entN1 {α β : Type*} [Fintype α] [Fintype β] (w : α → β → ℝ)
    (hw : ∀ a b, 0 ≤ w a b) : miN w ≤ entN1 w := by
  rw [miN_symm]
  exact miN_le_entN2 (fun b a => w a b) (fun b a => hw a b)

/-- L'entropie d'une loi sur β est au plus log |β| (nats). -/
theorem entN2_le_log_card {α β : Type*} [Fintype α] [Fintype β] [Nonempty β]
    (w : α → β → ℝ) (hw : ∀ a b, 0 ≤ w a b) (h1 : ∑ a, ∑ b, w a b = 1) :
    entN2 w ≤ Real.log (Fintype.card β) := by
  classical
  set r : β → ℝ := fun b => ∑ a, w a b with hr
  have hr0 : ∀ b, 0 ≤ r b := fun b => sum_nonneg fun a _ => hw a b
  have hr1 : ∑ b, r b = 1 := by rw [hr]; simp only; rw [Finset.sum_comm]; exact h1
  have l := log_sum_ineq univ r (fun _ => (1 : ℝ)) (fun b _ => hr0 b)
    (fun _ _ => zero_le_one) (fun _ _ _ => one_pos)
  simp only [div_one, sum_const, card_univ, nsmul_eq_mul, mul_one] at l
  rw [hr1, one_mul, one_div, Real.log_inv] at l
  have e : entN2 w = -∑ b, r b * Real.log (r b) := rfl
  rw [e]
  linarith

/-! ### 12.2 Inégalité de traitement des données (DPI), forme finie

Chaîne de Markov X → Y → Z : la loi jointe de (X, Y) est p et Z est tiré de Y par
un noyau stochastique k. La loi jointe de (X, Z) est alors x, z ↦ Σ_y p x y · k y z. -/

/-- **DPI finie** (Lemmes 1.3 et A.2). I(X;Z) ≤ I(X;Y). -/
theorem dpi_finite {α β γ : Type*} [Fintype α] [Fintype β] [Fintype γ]
    (p : α → β → ℝ) (k : β → γ → ℝ) (hp : ∀ a b, 0 ≤ p a b) (hk : ∀ b g, 0 ≤ k b g)
    (hk1 : ∀ b, ∑ g, k b g = 1) :
    miN (fun a g => ∑ b, p a b * k b g) ≤ miN p := by
  classical
  set pA : α → ℝ := fun a => ∑ b, p a b with hpA
  set pB : β → ℝ := fun b => ∑ a, p a b with hpB
  set w : α → γ → ℝ := fun a g => ∑ b, p a b * k b g with hw
  -- marginales de w
  have mA : ∀ a, ∑ g', w a g' = pA a := by
    intro a; simp only [hw, hpA]; rw [Finset.sum_comm]
    exact sum_congr rfl fun b _ => by rw [← mul_sum, hk1, mul_one]
  have mZ : ∀ g, ∑ a', w a' g = ∑ b, pB b * k b g := by
    intro g; simp only [hw, hpB]; rw [Finset.sum_comm]
    exact sum_congr rfl fun b _ => by rw [sum_mul]
  -- inégalité log-somme pour chaque (a, g)
  have key : ∀ a g, w a g * Real.log (w a g / (pA a * ∑ b, pB b * k b g))
      ≤ ∑ b, p a b * k b g * Real.log (p a b / (pA a * pB b)) := by
    intro a g
    have hpos : ∀ b, 0 < p a b * k b g → 0 < pA a * (pB b * k b g) := by
      intro b h
      have hp' : 0 < p a b := lt_of_le_of_ne (hp a b) (fun e => by rw [← e, zero_mul] at h; exact lt_irrefl 0 h)
      have hk' : 0 < k b g := by
        rcases (hk b g).lt_or_eq with h' | h'
        · exact h'
        · rw [← h', mul_zero] at h; exact absurd h (lt_irrefl 0)
      have h1 : p a b ≤ pA a := single_le_sum (f := fun b => p a b) (fun _ _ => hp _ _) (mem_univ b)
      have h2 : p a b ≤ pB b := single_le_sum (f := fun a => p a b) (fun _ _ => hp _ _) (mem_univ a)
      exact mul_pos (lt_of_lt_of_le hp' h1) (mul_pos (lt_of_lt_of_le hp' h2) hk')
    have l := log_sum_ineq univ (fun b => p a b * k b g) (fun b => pA a * (pB b * k b g))
      (fun b _ => mul_nonneg (hp a b) (hk b g))
      (fun b _ => mul_nonneg (sum_nonneg fun _ _ => hp _ _)
        (mul_nonneg (sum_nonneg fun _ _ => hp _ _) (hk b g)))
      (fun b _ => hpos b)
    have eB : ∑ b, pA a * (pB b * k b g) = pA a * ∑ b, pB b * k b g := by rw [mul_sum]
    rw [eB] at l
    refine le_trans l (le_of_eq (sum_congr rfl fun b _ => ?_))
    rcases (hk b g).lt_or_eq with h | h
    · rw [show pA a * (pB b * k b g) = (pA a * pB b) * k b g by ring,
        mul_div_mul_right _ _ h.ne']
    · rw [← h]; simp
  calc miN w = ∑ a, ∑ g, w a g * Real.log (w a g / (pA a * ∑ b, pB b * k b g)) := by
        unfold miN; exact sum_congr rfl fun a _ => sum_congr rfl fun g _ => by rw [mA, mZ]
    _ ≤ ∑ a, ∑ g, ∑ b, p a b * k b g * Real.log (p a b / (pA a * pB b)) :=
        sum_le_sum fun a _ => sum_le_sum fun g _ => key a g
    _ = miN p := by
        unfold miN
        refine sum_congr rfl fun a _ => ?_
        rw [Finset.sum_comm]
        refine sum_congr rfl fun b _ => ?_
        simp only [mul_comm (p a b) (k b _), mul_assoc, ← sum_mul, hk1, one_mul]
        rfl

/-! ### 12.3 DPI pour la variation totale -/

/-- Un post-traitement stochastique T ne crée pas de distinguabilité :
    tv(P·T, Q·T) ≤ tv(P, Q). -/
theorem tv_pushforward_le {σ τ : Type*} [Fintype σ] [Fintype τ] (P Q : σ → ℝ)
    (T : σ → τ → ℝ) (hT : ∀ s t, 0 ≤ T s t) (hT1 : ∀ s, ∑ t, T s t = 1) :
    tv (fun t => ∑ s, P s * T s t) (fun t => ∑ s, Q s * T s t) ≤ tv P Q := by
  classical
  unfold tv
  have h : ∀ t, max ((∑ s, P s * T s t) - ∑ s, Q s * T s t) 0
      ≤ ∑ s, max (P s - Q s) 0 * T s t := by
    intro t
    apply max_le
    · rw [← sum_sub_distrib]
      exact sum_le_sum fun s _ => by
        rw [← sub_mul]; exact mul_le_mul_of_nonneg_right (le_max_left _ _) (hT s t)
    · exact sum_nonneg fun s _ => mul_nonneg (le_max_right _ _) (hT s t)
  calc ∑ t, max ((∑ s, P s * T s t) - ∑ s, Q s * T s t) 0
      ≤ ∑ t, ∑ s, max (P s - Q s) 0 * T s t := sum_le_sum fun t _ => h t
    _ = ∑ s, max (P s - Q s) 0 := by
        rw [Finset.sum_comm]
        exact sum_congr rfl fun s _ => by rw [← mul_sum, hT1, mul_one]

end ConditionalCRO

namespace ConditionalCRO

/-! ### 12.4 Modèle CLO : bornes élémentaires, goulot contextuel, capacité Δ* -/

namespace CLOModel

variable {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C] [Fintype S] [Fintype V]
  (X : CLOModel lam M C S V)

/-- H(Σ|C) en bits (entropie de la preuve sachant le contexte). -/
noncomputable def HS : ℝ := (∑ c, X.pC c * entN1 (X.qSV c)) / Real.log 2

/-- Pour un contexte de probabilité non nulle, la loi de (Σ, V) sachant C = c est de masse 1. -/
lemma qSV_sum (c : C) (hc : 0 < X.pC c) : ∑ s, ∑ v, X.qSV c s v = 1 := by
  unfold qSV
  simp only [← mul_sum, X.ker_sum, mul_one]
  rw [Finset.sum_comm]
  exact X.qMS_sum c hc

/-- I(V;Σ|C) ≤ H(Σ|C). -/
lemma IV_le_HS : X.IV ≤ X.HS := by
  unfold IV HS
  apply div_le_div_of_nonneg_right _ log_two_pos'.le
  exact sum_le_sum fun c _ => mul_le_mul_of_nonneg_left
    (miN_le_entN1 _ (X.qSV_nonneg c)) (X.pC_nonneg c)

/-- H(V|C) ≤ log₂ |V|. -/
lemma HV_le_log_card [Nonempty V] : X.HV ≤ Real.log (Fintype.card V) / Real.log 2 := by
  unfold HV
  apply div_le_div_of_nonneg_right _ log_two_pos'.le
  calc ∑ c, X.pC c * entN2 (X.qSV c) ≤ ∑ c, X.pC c * Real.log (Fintype.card V) := by
        refine sum_le_sum fun c _ => ?_
        rcases (X.pC_nonneg c).lt_or_eq with h | h
        · exact mul_le_mul_of_nonneg_left
            (entN2_le_log_card _ (X.qSV_nonneg c) (X.qSV_sum c h)) h.le
        · rw [← h]; simp
    _ = Real.log (Fintype.card V) := by rw [← sum_mul, X.sum_pC, one_mul]

/-- **Théorème 2.1 (bornes élémentaires des métriques CLO).**
    Conf, Rel et, pour H(V|C) > 0, Opp sont dans [0, 1]. -/
theorem bornes_mesures [DecidableEq M] [Nonempty M] [Nonempty C] (D : C → S → M) :
    (0 ≤ X.Conf ∧ X.Conf ≤ 1) ∧ (0 ≤ X.Rel D ∧ X.Rel D ≤ 1) ∧
      (0 < X.HV → 0 ≤ X.Opp ∧ X.Opp ≤ 1) := by
  refine ⟨⟨?_, ?_⟩, X.Rel_mem D, fun h => ⟨div_nonneg X.IV_nonneg h.le, ?_⟩⟩
  · unfold Conf; linarith [X.TVmax_le_one]
  · unfold Conf; linarith [X.TVmax_nonneg]
  · unfold Opp; rw [div_le_one h]; exact X.IV_le_HV

/-- **Théorème 2.2 (goulot d'étranglement contextuel).**
    I(V;Σ|C) ≤ min{H(Σ|C), H(V|C)} ≤ log₂|V|, et log₂|V| ≤ αH(C) dès que
    |V| ≤ 2^(αH(C)) (granularité des verdicts, Définition 2.11). -/
theorem goulot_contexte [Nonempty V] (α : ℝ) :
    X.IV ≤ min X.HS X.HV ∧ min X.HS X.HV ≤ Real.log (Fintype.card V) / Real.log 2 ∧
      ((Fintype.card V : ℝ) ≤ (2 : ℝ) ^ (α * X.HC) →
        Real.log (Fintype.card V) / Real.log 2 ≤ α * X.HC) := by
  refine ⟨le_min X.IV_le_HS X.IV_le_HV, (min_le_right _ _).trans X.HV_le_log_card, ?_⟩
  intro hcard
  have hpos : (0 : ℝ) < Fintype.card V := by exact_mod_cast Fintype.card_pos
  have h := Real.log_le_log hpos hcard
  rw [Real.log_rpow (by norm_num)] at h
  rw [div_le_iff₀ log_two_pos']
  exact h

/-- **Remarque 2.11 (capacité de l'institution).** Pour tout protocole et toute
    institution dont les verdicts vérifient |V| ≤ 2^(αH(C)), la différence
    I(V;Σ|C) − I(M;Σ|C) est au plus γ + 1 = αH(C). Le supremum Δ* qui définit la
    capacité vérifie donc Δ* ≤ γ + 1. -/
theorem capacite_le_gamma_add_one [Nonempty V] (prm : InstitutionalParams)
    (hH : prm.H = X.HC) (hcard : (Fintype.card V : ℝ) ≤ (2 : ℝ) ^ (prm.α * prm.H)) :
    X.IV - X.I ≤ gamma prm + 1 := by
  have h1 := (X.goulot_contexte prm.α).2.2 (by rw [← hH]; exact hcard)
  have h2 := X.HV_le_log_card
  have h3 := X.I_nonneg
  have h4 := X.IV_le_HV
  unfold gamma
  rw [hH]
  linarith

/-- Un verdict à une seule valeur a une entropie conditionnelle nulle. -/
lemma HV_eq_zero_of_card_one (h : Fintype.card V = 1) : X.HV = 0 := by
  classical
  obtain ⟨v₀, hv₀⟩ := Fintype.card_eq_one_iff.1 h
  have hc : ∀ c, entN2 (X.qSV c) = 0 := by
    intro c
    unfold entN2
    have e : ∀ v, ∑ s, X.qSV c s v = ∑ s, ∑ v', X.qSV c s v' := by
      intro v
      refine sum_congr rfl fun s _ => ?_
      rw [Fintype.sum_eq_single v (fun v' hv' => absurd ((hv₀ v').trans (hv₀ v).symm) hv')]
    rcases (X.pC_nonneg c).lt_or_eq with hpos | hz
    · simp only [e, X.qSV_sum c hpos, Real.log_one, mul_zero, sum_const_zero, neg_zero]
    · have z : ∀ s v, X.qSV c s v = 0 := by
        intro s v
        unfold qSV qMS
        rw [← hz]; simp
      simp [z]
  unfold HV
  simp [hc]

end CLOModel

/-- Verdict constant : on remplace l'interprétation par un verdict à une seule valeur. -/
noncomputable def CLOModel.constVerdict {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C]
    [Fintype S] [Fintype V] (X : CLOModel lam M C S V) : CLOModel lam M C S (Fin 1)
  where
  P := X.P
  P_nonneg := X.P_nonneg
  P_sum := X.P_sum
  card_M := X.card_M
  unif := X.unif
  ker := fun _ _ _ => 1
  ker_nonneg := fun _ _ _ => zero_le_one
  ker_sum := fun _ _ => by simp

/-- **Remarque 2.12 (statut de l'Hypothèse 2.2).** La borne supérieure sur la taille
    de l'espace des verdicts n'entraîne pas la borne inférieure H(V|C) ≥ αH(C) − 1.
    Contre-exemple : la famille témoin à H(C) = 1 bit, munie d'un verdict constant, avec
    α = 2. On a |V| = 1 ≤ 2^(αH(C)) mais H(V|C) = 0 < αH(C) − 1 = 1. -/
theorem verdict_card_not_efficient (l : ℕ) :
    ((Fintype.card (Fin 1) : ℝ) ≤ (2 : ℝ) ^ (2 * (famModel l).constVerdict.HC)) ∧
      (famModel l).constVerdict.HV < 2 * (famModel l).constVerdict.HC - 1 := by
  have hHC : (famModel l).constVerdict.HC = 1 := CLOModel.fam_HC l
  have hHV : (famModel l).constVerdict.HV = 0 :=
    CLOModel.HV_eq_zero_of_card_one _ (Fintype.card_fin 1)
  rw [hHC, hHV]
  norm_num

end ConditionalCRO

namespace ConditionalCRO

/-! ### 12.5 Règles de composition (Théorème 2.3, Remarque 2.5)

Un post-traitement est un noyau stochastique T(c, σ₁, σ₂) qui calcule la nouvelle
preuve σ₂ à partir de (σ₁, c), sans autre accès au message. Le protocole composé
publie σ₂. La publication conjointe de deux preuves est un modèle sur S₁ × S₂ ; chaque
protocole composant en est le post-traitement par projection. -/

namespace CLOModel

variable {lam : ℕ} {M C S S' V : Type*} [Fintype M] [Fintype C] [Fintype S] [Fintype S']
  [Fintype V] (X : CLOModel lam M C S V)

/-- Expression de la fiabilité d'un décodeur sans indicatrice. -/
lemma Rel_eq [DecidableEq M] (D : C → S → M) : X.Rel D = ∑ c, ∑ s, X.P c (D c s) s := by
  unfold Rel
  refine sum_congr rfl fun c _ => ?_
  rw [Finset.sum_comm]
  refine sum_congr rfl fun s _ => ?_
  rw [Finset.sum_ite_eq]
  simp

/-- Le protocole composé P₁ ∘ P₂ : la preuve publiée σ₂ est tirée de (σ₁, c) par T,
    et l'institution l'interprète par un noyau `ker'`. -/
noncomputable def post {V' : Type*} [Fintype V'] (T : C → S → S' → ℝ)
    (hT : ∀ c s t, 0 ≤ T c s t) (hT1 : ∀ c s, ∑ t, T c s t = 1)
    (ker' : C → S' → V' → ℝ) (hk : ∀ c t v, 0 ≤ ker' c t v) (hk1 : ∀ c t, ∑ v, ker' c t v = 1) :
    CLOModel lam M C S' V' where
  P := fun c m t => ∑ s, X.P c m s * T c s t
  P_nonneg := fun c m t => sum_nonneg fun s _ => mul_nonneg (X.P_nonneg c m s) (hT c s t)
  P_sum := by
    rw [← X.P_sum]
    refine sum_congr rfl fun c _ => sum_congr rfl fun m _ => ?_
    rw [Finset.sum_comm]
    exact sum_congr rfl fun s _ => by rw [← mul_sum, hT1, mul_one]
  card_M := X.card_M
  unif := by
    intro c m
    have e : ∀ m, ∑ t, ∑ s, X.P c m s * T c s t = ∑ s, X.P c m s := fun m => by
      rw [Finset.sum_comm]
      exact sum_congr rfl fun s _ => by rw [← mul_sum, hT1, mul_one]
    simp only [e]
    exact X.unif c m
  ker := ker'
  ker_nonneg := hk
  ker_sum := hk1

variable {V' : Type*} [Fintype V'] (T : C → S → S' → ℝ) (hT : ∀ c s t, 0 ≤ T c s t)
  (hT1 : ∀ c s, ∑ t, T c s t = 1) (ker' : C → S' → V' → ℝ) (hk : ∀ c t v, 0 ≤ ker' c t v)
  (hk1 : ∀ c t, ∑ v, ker' c t v = 1)

/-- La loi de σ₂ sachant (m, c) est l'image par T de celle de σ₁. -/
lemma post_qS (c : C) (m : M) (t : S') :
    (X.post T hT hT1 ker' hk hk1).qS c m t = ∑ s, X.qS c m s * T c s t := by
  unfold qS post
  simp only
  have e : ∑ t', ∑ s, X.P c m s * T c s t' = ∑ s, X.P c m s := by
    rw [Finset.sum_comm]
    exact sum_congr rfl fun s _ => by rw [← mul_sum, hT1, mul_one]
  rw [e, sum_div]
  exact sum_congr rfl fun s _ => by ring

/-- **Théorème 2.3, composition séquentielle (confidentialité).**
    Conf(P₁ ∘ P₂) ≥ Conf(P₁). -/
theorem conf_post [Nonempty M] [Nonempty C] :
    X.Conf ≤ (X.post T hT hT1 ker' hk hk1).Conf := by
  unfold Conf
  have h : (X.post T hT hT1 ker' hk hk1).TVmax ≤ X.TVmax := by
    unfold TVmax
    apply Finset.sup'_le
    intro x _
    have e : (X.post T hT hT1 ker' hk hk1).TV x =
        tv (fun t => ∑ s, X.qS x.1 x.2.1 s * T x.1 s t)
          (fun t => ∑ s, X.qS x.1 x.2.2 s * T x.1 s t) := by
      unfold TV
      congr 1 <;> funext t <;> exact X.post_qS T hT hT1 ker' hk hk1 _ _ t
    rw [e]
    exact (tv_pushforward_le _ _ (T x.1) (hT x.1) (hT1 x.1)).trans
      (Finset.le_sup' X.TV (mem_univ x))
  linarith

/-- **Théorème 2.3, composition séquentielle (fiabilité).** Tout décodeur qui lit σ₂
    est dominé par un décodeur qui lit σ₁ : Relrec(P₁ ∘ P₂) ≤ Relrec(P₁). -/
theorem rel_post [DecidableEq M] [Nonempty S'] (D' : C → S' → M) :
    ∃ D : C → S → M, (X.post T hT hT1 ker' hk hk1).Rel D' ≤ X.Rel D := by
  classical
  -- pour chaque (c, s), une valeur t* qui maximise X.P c (D' c t) s
  have hmax : ∀ c s, ∃ t₀, ∀ t, X.P c (D' c t) s ≤ X.P c (D' c t₀) s := by
    intro c s
    obtain ⟨t₀, -, ht₀⟩ := Finset.exists_max_image univ (fun t => X.P c (D' c t) s) univ_nonempty
    exact ⟨t₀, fun t => ht₀ t (mem_univ t)⟩
  choose tstar htstar using hmax
  refine ⟨fun c s => D' c (tstar c s), ?_⟩
  rw [Rel_eq, Rel_eq]
  unfold post
  simp only
  refine sum_le_sum fun c _ => ?_
  rw [Finset.sum_comm]
  refine sum_le_sum fun s _ => ?_
  calc ∑ t, X.P c (D' c t) s * T c s t ≤ ∑ t, X.P c (D' c (tstar c s)) s * T c s t :=
        sum_le_sum fun t _ => mul_le_mul_of_nonneg_right (htstar c s t) (hT c s t)
    _ = X.P c (D' c (tstar c s)) s := by rw [← mul_sum, hT1, mul_one]

/-- Pour un post-traitement déterministe f, la fiabilité d'un décodeur D' de σ₂ est
    celle du décodeur D' ∘ f de σ₁. -/
theorem rel_post_det [DecidableEq M] [DecidableEq S'] (f : C → S → S') (D' : C → S' → M) :
    (X.post (fun c s t => if f c s = t then 1 else 0) (fun _ _ _ => by split_ifs <;> norm_num)
      (fun _ _ => by simp) ker' hk hk1).Rel D' = X.Rel (fun c s => D' c (f c s)) := by
  rw [Rel_eq, Rel_eq]
  unfold post
  simp only
  refine sum_congr rfl fun c _ => ?_
  rw [Finset.sum_comm]
  refine sum_congr rfl fun s _ => ?_
  simp only [mul_ite, mul_one, mul_zero]
  rw [Finset.sum_ite_eq]
  simp

/-- I(V;Σ₂|C) pour le verdict V de P₁ (verdict fixé) et la preuve post-traitée σ₂. -/
noncomputable def IVpost : ℝ :=
  (∑ c, X.pC c * miN (fun v t => ∑ s, X.qSV c s v * T c s t)) / Real.log 2

include hT hT1 in
/-- **Remarque 2.5 (opposabilité composée, verdict fixé).**
    V — (Σ₁, C) — (Σ₂, C) est une chaîne de Markov, donc I(V;Σ₂|C) ≤ I(V;Σ₁|C) et,
    pour H(V|C) > 0, Opp(P₁ ∘ P₂) ≤ Opp(P₁). -/
theorem opp_post :
    X.IVpost T ≤ X.IV ∧ (0 < X.HV → X.IVpost T / X.HV ≤ X.Opp) := by
  have h : X.IVpost T ≤ X.IV := by
    unfold IVpost IV
    apply div_le_div_of_nonneg_right _ log_two_pos'.le
    refine sum_le_sum fun c _ => mul_le_mul_of_nonneg_left ?_ (X.pC_nonneg c)
    rw [miN_symm (X.qSV c)]
    exact dpi_finite (fun v s => X.qSV c s v) (T c) (fun v s => X.qSV_nonneg c s v)
      (hT c) (hT1 c)
  exact ⟨h, fun hpos => by unfold Opp; exact div_le_div_of_nonneg_right h hpos.le⟩

end CLOModel

/-! ### 12.6 Composition parallèle

La publication conjointe de (σ₁, σ₂) est un modèle X sur S₁ × S₂. Chaque protocole
composant est le post-traitement de X par la projection correspondante. Le résultat
vaut sans supposer σ₁ et σ₂ indépendantes sachant (M, C) ; il contient donc le cas
indépendant du Théorème 2.3. -/

namespace CLOModel

variable {lam : ℕ} {M C S₁ S₂ V : Type*} [Fintype M] [Fintype C] [Fintype S₁] [Fintype S₂]
  [Fintype V] [DecidableEq S₁] [DecidableEq S₂] (X : CLOModel lam M C (S₁ × S₂) V)
  (k₁ : C → S₁ → V → ℝ) (hk₁ : ∀ c t v, 0 ≤ k₁ c t v) (hk₁1 : ∀ c t, ∑ v, k₁ c t v = 1)
  (k₂ : C → S₂ → V → ℝ) (hk₂ : ∀ c t v, 0 ≤ k₂ c t v) (hk₂1 : ∀ c t, ∑ v, k₂ c t v = 1)

/-- Premier protocole composant (publication de σ₁ seule). -/
noncomputable def proj₁ : CLOModel lam M C S₁ V :=
  X.post (fun _ s t => if s.1 = t then 1 else 0) (fun _ _ _ => by split_ifs <;> norm_num)
    (fun _ _ => by simp) k₁ hk₁ hk₁1

/-- Second protocole composant (publication de σ₂ seule). -/
noncomputable def proj₂ : CLOModel lam M C S₂ V :=
  X.post (fun _ s t => if s.2 = t then 1 else 0) (fun _ _ _ => by split_ifs <;> norm_num)
    (fun _ _ => by simp) k₂ hk₂ hk₂1

/-- **Théorème 2.3, composition parallèle.**
    Conf(P₁ ∥ P₂) ≤ min{Conf(P₁), Conf(P₂)} et tout décodeur de P₁ ou de P₂ se relève
    en un décodeur de P₁ ∥ P₂ de même fiabilité, d'où Relrec(P₁ ∥ P₂) ≥ max. -/
theorem composition_parallele [DecidableEq M] [Nonempty M] [Nonempty C]
    (D₁ : C → S₁ → M) (D₂ : C → S₂ → M) :
    X.Conf ≤ min (X.proj₁ k₁ hk₁ hk₁1).Conf (X.proj₂ k₂ hk₂ hk₂1).Conf ∧
      (X.proj₁ k₁ hk₁ hk₁1).Rel D₁ = X.Rel (fun c s => D₁ c s.1) ∧
      (X.proj₂ k₂ hk₂ hk₂1).Rel D₂ = X.Rel (fun c s => D₂ c s.2) :=
  ⟨le_min (X.conf_post _ _ _ _ _ _) (X.conf_post _ _ _ _ _ _),
    X.rel_post_det k₁ hk₁ hk₁1 (fun _ s => s.1) D₁,
    X.rel_post_det k₂ hk₂ hk₂1 (fun _ s => s.2) D₂⟩

end CLOModel

/-! ### 12.7 Pas de règle générale pour l'opposabilité en parallèle (Remarque 2.5) -/

/-- Inégalité de Fréchet : ab ≥ a + b − 1 pour a, b ∈ [0, 1]. Le minorant publié
    Conf(P₁) + Conf(P₂) − 1 n'entraîne donc pas le produit. -/
theorem frechet {a b : ℝ} (ha : a ≤ 1) (hb : b ≤ 1) : a + b - 1 ≤ a * b := by
  nlinarith [mul_nonneg (sub_nonneg.2 ha) (sub_nonneg.2 hb)]

/-- Information mutuelle de V et d'un bit Σ, pour la loi jointe w (indices V puis Σ). -/
private lemma miN_uniform_indep :
    miN (fun (_ : Fin 2) (_ : Fin 2) => (1 / 4 : ℝ)) = 0 := by
  simp only [miN, Fin.sum_univ_two]
  norm_num

/-- **Remarque 2.5, sous-additivité en défaut.** Σ₁ = B₁, Σ₂ = B₂ deux bits uniformes
    indépendants et V = B₁ ⊕ B₂ : I(V;Σ₁) = 0 mais I(V;(Σ₁,Σ₂)) = log 2 (un bit). -/
theorem xor_not_subadditive :
    miN (fun (v : Fin 2) (s : Fin 2 × Fin 2) =>
        if v = s.1 + s.2 then (1 / 4 : ℝ) else 0) = Real.log 2 ∧
      miN (fun (_ : Fin 2) (_ : Fin 2) => (1 / 4 : ℝ)) = 0 := by
  refine ⟨?_, miN_uniform_indep⟩
  simp only [miN, Fintype.sum_prod_type, Fin.sum_univ_two]
  norm_num
  ring

/-- **Remarque 2.5, sur-additivité en défaut.** Σ₁ = Σ₂ = V uniforme sur un bit :
    I(V;(Σ₁,Σ₂)) = log 2 < 2·log 2 = I(V;Σ₁) + I(V;Σ₂). -/
theorem copy_not_superadditive :
    miN (fun (v : Fin 2) (s : Fin 2 × Fin 2) =>
        if s.1 = v ∧ s.2 = v then (1 / 2 : ℝ) else 0) = Real.log 2 ∧
      miN (fun (v : Fin 2) (s : Fin 2) => if s = v then (1 / 2 : ℝ) else 0) = Real.log 2 ∧
      Real.log 2 < 2 * Real.log 2 := by
  refine ⟨?_, ?_, by linarith [Real.log_pos (by norm_num : (1 : ℝ) < 2)]⟩
  · simp only [miN, Fintype.sum_prod_type, Fin.sum_univ_two]
    norm_num
    ring
  · simp only [miN, Fin.sum_univ_two]
    norm_num
    ring

end ConditionalCRO

namespace ConditionalCRO

/-! ### 12.8 Règle de chaîne et information mutuelle conditionnelle -/

/-- Information mutuelle conditionnelle I(A;G|B) (nats) de la loi jointe u(a, b, g). -/
noncomputable def condMI {α β γ : Type*} [Fintype α] [Fintype β] [Fintype γ]
    (u : α → β → γ → ℝ) : ℝ :=
  ∑ a, ∑ b, ∑ g, u a b g * Real.log (u a b g * (∑ a', ∑ g', u a' b g') /
    ((∑ g', u a b g') * (∑ a', u a' b g)))

/-- **Règle de chaîne.** I(A; B, G) = I(A; B) + I(A; G | B). -/
theorem chain_rule {α β γ : Type*} [Fintype α] [Fintype β] [Fintype γ]
    (u : α → β → γ → ℝ) (hu : ∀ a b g, 0 ≤ u a b g) :
    miN (fun a (bg : β × γ) => u a bg.1 bg.2) = miN (fun a b => ∑ g, u a b g) + condMI u := by
  classical
  unfold miN condMI
  rw [← sum_add_distrib]
  refine sum_congr rfl fun a _ => ?_
  rw [Fintype.sum_prod_type]
  simp only
  rw [← sum_add_distrib]
  refine sum_congr rfl fun b _ => ?_
  -- marginales
  set pA := ∑ x : β × γ, u a x.1 x.2 with hpA
  have hpA' : pA = ∑ b', ∑ g, u a b' g := by rw [hpA, Fintype.sum_prod_type]
  set uAB := ∑ g', u a b g' with huAB
  set pB := ∑ a', ∑ g', u a' b g' with hpB
  have hpB' : ∑ a', ∑ g, u a' b g = pB := rfl
  rw [show (∑ b', ∑ g, u a b' g) = pA from hpA'.symm]
  rw [show uAB * Real.log (uAB / (pA * pB)) = ∑ g, u a b g * Real.log (uAB / (pA * pB)) by
    rw [huAB, sum_mul]]
  rw [← sum_add_distrib]
  refine sum_congr rfl fun g _ => ?_
  set pBG := ∑ a', u a' b g with hpBG
  rcases (hu a b g).lt_or_eq with h | h
  · have h1 : u a b g ≤ uAB := single_le_sum (f := fun g' => u a b g') (fun _ _ => hu _ _ _) (mem_univ g)
    have h2 : u a b g ≤ pBG := single_le_sum (f := fun a' => u a' b g) (fun _ _ => hu _ _ _) (mem_univ a)
    have h3 : uAB ≤ pB := single_le_sum (f := fun a' => ∑ g', u a' b g') (fun _ _ => sum_nonneg fun _ _ => hu _ _ _) (mem_univ a)
    have h4 : uAB ≤ pA := by
      rw [hpA']; exact single_le_sum (f := fun b' => ∑ g, u a b' g) (fun _ _ => sum_nonneg fun _ _ => hu _ _ _) (mem_univ b)
    have pAB : 0 < uAB := lt_of_lt_of_le h h1
    have ppBG : 0 < pBG := lt_of_lt_of_le h h2
    have ppB : 0 < pB := lt_of_lt_of_le pAB h3
    have ppA : 0 < pA := lt_of_lt_of_le pAB h4
    rw [← mul_add, ← Real.log_mul (by positivity) (by positivity)]
    congr 2
    field_simp
  · rw [← h]; simp

/-- Positivité de l'information mutuelle conditionnelle. -/
theorem condMI_nonneg {α β γ : Type*} [Fintype α] [Fintype β] [Fintype γ]
    (u : α → β → γ → ℝ) (hu : ∀ a b g, 0 ≤ u a b g) : 0 ≤ condMI u := by
  classical
  unfold condMI
  rw [Finset.sum_comm]
  refine sum_nonneg fun b _ => ?_
  set pB := ∑ a', ∑ g', u a' b g' with hpB
  -- log-somme sur α × γ, à b fixé
  let A : α × γ → ℝ := fun x => u x.1 b x.2
  let B : α × γ → ℝ := fun x => (∑ g', u x.1 b g') * (∑ a', u a' b x.2) / pB
  rcases (sum_nonneg (fun a' _ => sum_nonneg fun g' _ => hu a' b g') : 0 ≤ pB).lt_or_eq with hp | hp
  · have hAB : ∀ x ∈ (univ : Finset (α × γ)), 0 < A x → 0 < B x := by
      intro x _ hx
      have h1 : u x.1 b x.2 ≤ ∑ g', u x.1 b g' :=
        single_le_sum (f := fun g' => u x.1 b g') (fun _ _ => hu _ _ _) (mem_univ x.2)
      have h2 : u x.1 b x.2 ≤ ∑ a', u a' b x.2 :=
        single_le_sum (f := fun a' => u a' b x.2) (fun _ _ => hu _ _ _) (mem_univ x.1)
      exact div_pos (mul_pos (lt_of_lt_of_le hx h1) (lt_of_lt_of_le hx h2)) hp
    have l := log_sum_ineq univ A B (fun x _ => hu _ _ _)
      (fun x _ => div_nonneg (mul_nonneg (sum_nonneg fun _ _ => hu _ _ _)
        (sum_nonneg fun _ _ => hu _ _ _)) hp.le) hAB
    have eA : ∑ x, A x = pB := by rw [Fintype.sum_prod_type]
    have eB : ∑ x, B x = pB := by
      simp only [B]
      rw [← sum_div, Fintype.sum_prod_type]
      simp only [← mul_sum]
      rw [← sum_mul]
      have : ∑ g, ∑ a', u a' b g = pB := by rw [hpB, Finset.sum_comm]
      rw [this]
      exact mul_div_cancel_right₀ _ (show pB ≠ 0 from hp.ne')
    rw [eA, eB, div_self hp.ne', Real.log_one, mul_zero, Fintype.sum_prod_type] at l
    refine le_trans l (le_of_eq (sum_congr rfl fun a _ => sum_congr rfl fun g _ => ?_))
    simp only [A, B]
    congr 2
    rw [div_div_eq_mul_div]
  · have z : ∀ a g, u a b g = 0 := by
      intro a g
      have hz := (sum_eq_zero_iff_of_nonneg (fun a' _ => sum_nonneg fun g' _ => hu a' b g')).1 hp.symm a (mem_univ a)
      exact (sum_eq_zero_iff_of_nonneg (fun g' _ => hu a b g')).1 hz g (mem_univ g)
    simp [z]

/-- Si le noyau k ne dépend que de s, I(V; (M, Σ)) = I(V; Σ) : V ne dépend de M qu'à
    travers Σ. -/
theorem miN_kernel_only_on_s {μ σ ν : Type*} [Fintype μ] [Fintype σ] [Fintype ν]
    (q : μ → σ → ℝ) (k : σ → ν → ℝ) (hq : ∀ m s, 0 ≤ q m s)
    (hk1 : ∀ s, ∑ v, k s v = 1) :
    miN (fun v (ms : μ × σ) => q ms.1 ms.2 * k ms.2 v) =
      miN (fun v s => (∑ m, q m s) * k s v) := by
  classical
  unfold miN
  refine sum_congr rfl fun v _ => ?_
  rw [Fintype.sum_prod_type, Finset.sum_comm]
  refine sum_congr rfl fun s _ => ?_
  -- les deux marginales en v coïncident
  have eV : ∑ x : μ × σ, q x.1 x.2 * k x.2 v = ∑ s', (∑ m, q m s') * k s' v := by
    rw [Fintype.sum_prod_type, Finset.sum_comm]
    exact sum_congr rfl fun s' _ => by rw [sum_mul]
  simp only [eV]
  set pV := ∑ s', (∑ m, q m s') * k s' v
  have eS : ∀ m, ∑ v', q m s * k s v' = q m s := fun m => by rw [← mul_sum, hk1, mul_one]
  have eS' : ∑ v', (∑ m, q m s) * k s v' = ∑ m, q m s := by rw [← mul_sum, hk1, mul_one]
  simp only [eS, eS']
  have key : ∀ x, 0 ≤ x → x * k s v * Real.log (x * k s v / (pV * x)) =
      x * k s v * Real.log (k s v / pV) := by
    intro x hx
    rcases hx.lt_or_eq with h | h
    · congr 2; field_simp
    · rw [← h]; simp
  rw [key _ (sum_nonneg fun m _ => hq m s), sum_mul, sum_mul]
  exact sum_congr rfl fun m _ => key _ (hq m s)

/-! ### 12.9 Fondement informationnel de l'extraction bornée (Proposition 2.1) -/

namespace CLOModel

variable {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C] [Fintype S] [Fintype V]
  (X : CLOModel lam M C S V)

/-- I(V;M|C) en bits. -/
noncomputable def IVM : ℝ :=
  (∑ c, X.pC c * miN (fun v m => ∑ s, X.qMS c m s * X.ker c s v)) / Real.log 2

/-- I(V;Σ|M,C) en bits : l'information que l'institution tire de la preuve au-delà
    du message. -/
noncomputable def IVSM : ℝ :=
  (∑ c, X.pC c * condMI (fun v m s => X.qMS c m s * X.ker c s v)) / Real.log 2

/-- **Proposition 2.1.** Pour toute interprétation admissible,
    I(V;Σ|C) = I(V;M|C) + I(V;Σ|M,C) ≤ I(M;Σ|C) + I(V;Σ|M,C).
    En conséquence, I(V;Σ|M,C) ≤ Δ entraîne l'Hypothèse 2.1 (extraction bornée). -/
theorem fondement_extraction :
    X.IV = X.IVM + X.IVSM ∧ X.IVM ≤ X.I ∧ X.IV ≤ X.I + X.IVSM ∧
      ∀ Δ : ℝ, X.IVSM ≤ Δ → X.IV ≤ X.I + Δ := by
  have heq : X.IV = X.IVM + X.IVSM := by
    unfold IV IVM IVSM
    rw [← add_div, ← sum_add_distrib]
    congr 1
    refine sum_congr rfl fun c _ => ?_
    rw [← mul_add]
    congr 1
    have hu : ∀ v m s, 0 ≤ X.qMS c m s * X.ker c s v :=
      fun v m s => mul_nonneg (X.qMS_nonneg c m s) (X.ker_nonneg c s v)
    rw [← chain_rule _ hu, miN_symm (X.qSV c)]
    exact (miN_kernel_only_on_s (X.qMS c) (X.ker c) (X.qMS_nonneg c) (X.ker_sum c)).symm
  have hle : X.IVM ≤ X.I := by
    unfold IVM I
    apply div_le_div_of_nonneg_right _ log_two_pos'.le
    refine sum_le_sum fun c _ => mul_le_mul_of_nonneg_left ?_ (X.pC_nonneg c)
    rw [miN_symm]
    exact dpi_finite (X.qMS c) (X.ker c) (X.qMS_nonneg c) (X.ker_nonneg c) (X.ker_sum c)
  refine ⟨heq, hle, by linarith, fun Δ h => by linarith⟩

/-- I(V;Σ|M,C) ≥ 0. -/
lemma IVSM_nonneg : 0 ≤ X.IVSM :=
  div_nonneg (sum_nonneg fun c _ => mul_nonneg (X.pC_nonneg c)
    (condMI_nonneg _ fun v m s => mul_nonneg (X.qMS_nonneg c m s) (X.ker_nonneg c s v)))
    log_two_pos'.le

end CLOModel

/-! ### 12.10 Verdict déterministe sur le modèle concret (Remarques 2.4 et 3.9)

Un verdict V = f(Σ, C) est le cas particulier de l'interprétation admissible où les
ressources K sont constantes : son noyau vaut 1 en f(c, σ) et 0 ailleurs. -/

/-- Pour une loi jointe w(s, v) = r(s)·[f s = v], I(Σ;V) = H(V). -/
theorem miN_eq_entN2_of_det {σ ν : Type*} [Fintype σ] [Fintype ν] [DecidableEq ν]
    (r : σ → ℝ) (f : σ → ν) (hr : ∀ s, 0 ≤ r s) :
    miN (fun s v => if f s = v then r s else 0) =
      entN2 (fun s v => if f s = v then r s else 0) := by
  classical
  have hrow : ∀ s, ∑ v, (if f s = v then r s else 0) = r s := fun s => by
    rw [Finset.sum_ite_eq]; simp
  unfold miN entN2
  simp only [hrow]
  set pV : ν → ℝ := fun v => ∑ s, if f s = v then r s else 0 with hpV
  have lhs : ∀ s, ∑ v, (if f s = v then r s else 0) *
      Real.log ((if f s = v then r s else 0) / (r s * pV v)) =
      -(r s * Real.log (pV (f s))) := by
    intro s
    rw [Fintype.sum_eq_single (f s) (fun v hv => by simp [Ne.symm hv])]
    simp only [↓reduceIte]
    rcases (hr s).lt_or_eq with h | h
    · have hp : 0 < pV (f s) := lt_of_lt_of_le h (by
        rw [hpV]; simp only
        exact single_le_sum (f := fun s' => if f s' = f s then r s' else 0)
          (fun s' _ => by split_ifs <;> simp [hr s']) (mem_univ s) |>.trans_eq' (by simp))
      rw [show r s / (r s * pV (f s)) = (pV (f s))⁻¹ by field_simp, Real.log_inv]
      ring
    · rw [← h]; simp
  rw [sum_congr rfl fun s _ => lhs s, sum_neg_distrib]
  congr 1
  calc ∑ s, r s * Real.log (pV (f s))
      = ∑ s, ∑ v, (if f s = v then r s else 0) * Real.log (pV v) := by
        refine sum_congr rfl fun s _ => ?_
        rw [Fintype.sum_eq_single (f s) (fun v hv => by simp [Ne.symm hv])]
        simp
    _ = ∑ v, pV v * Real.log (pV v) := by
        rw [Finset.sum_comm]
        exact sum_congr rfl fun v _ => by rw [hpV, sum_mul]

namespace CLOModel

variable {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C] [Fintype S] [Fintype V]
  [DecidableEq V]

/-- Le modèle X dont l'interprétation est remplacée par le verdict déterministe f. -/
noncomputable def detVerdict (X : CLOModel lam M C S V) (f : C → S → V) : CLOModel lam M C S V where
  P := X.P
  P_nonneg := X.P_nonneg
  P_sum := X.P_sum
  card_M := X.card_M
  unif := X.unif
  ker := fun c s v => if f c s = v then 1 else 0
  ker_nonneg := fun _ _ _ => by split_ifs <;> norm_num
  ker_sum := fun c s => by rw [Finset.sum_ite_eq]; simp

/-- **Remarques 2.4 et 3.9 sur lois finies.** Pour un verdict déterministe,
    I(V;Σ|C) = H(V|C), donc Opp = 1 dès que H(V|C) > 0. -/
theorem opp_eq_one_of_det_concrete (X : CLOModel lam M C S V) (f : C → S → V) :
    (X.detVerdict f).IV = (X.detVerdict f).HV ∧
      (0 < (X.detVerdict f).HV → (X.detVerdict f).Opp = 1) := by
  have h : (X.detVerdict f).IV = (X.detVerdict f).HV := by
    unfold IV HV
    congr 1
    refine sum_congr rfl fun c _ => ?_
    congr 1
    have e : (X.detVerdict f).qSV c =
        fun s v => if f c s = v then ∑ m, (X.detVerdict f).qMS c m s else 0 := by
      funext s v
      unfold qSV detVerdict
      simp only [mul_ite, mul_one, mul_zero]
    rw [e]
    exact miN_eq_entN2_of_det _ (f c) fun s => sum_nonneg fun m _ => qMS_nonneg _ c m s
  exact ⟨h, fun hpos => by unfold Opp; rw [h, div_self hpos.ne']⟩

end CLOModel

/-! ### 12.11 Lecture du Lemme 2.3 (Remarques 2.3 et 2.15) -/

/-- Le minorant 1 − √(c₀βI) de la confidentialité décroît avec la fuite I et vaut 1
    pour une fuite nulle. -/
theorem conf_guarantee_antitone {β I₁ I₂ : ℝ} (hβ : 0 ≤ β) (h : I₁ ≤ I₂) :
    1 - Real.sqrt (c0 * β * I₂) ≤ 1 - Real.sqrt (c0 * β * I₁) ∧
      1 - Real.sqrt (c0 * β * 0) = 1 := by
  refine ⟨?_, by simp⟩
  have : c0 * β * I₁ ≤ c0 * β * I₂ := mul_le_mul_of_nonneg_left h (mul_nonneg c0_pos.le hβ)
  linarith [Real.sqrt_le_sqrt this]

end ConditionalCRO

end ExtensionL1

/-! ## 13. Bloc de vérification de l'extension (version 3.5)

Même exigence qu'en section 11 : chaque ligne doit afficher
`[propext, Classical.choice, Quot.sound]`. -/

#print axioms ConditionalCRO.miN_symm
#print axioms ConditionalCRO.miN_le_entN1
#print axioms ConditionalCRO.entN2_le_log_card
#print axioms ConditionalCRO.dpi_finite
#print axioms ConditionalCRO.tv_pushforward_le
#print axioms ConditionalCRO.CLOModel.bornes_mesures
#print axioms ConditionalCRO.CLOModel.goulot_contexte
#print axioms ConditionalCRO.CLOModel.capacite_le_gamma_add_one
#print axioms ConditionalCRO.verdict_card_not_efficient
#print axioms ConditionalCRO.CLOModel.conf_post
#print axioms ConditionalCRO.CLOModel.rel_post
#print axioms ConditionalCRO.CLOModel.opp_post
#print axioms ConditionalCRO.CLOModel.composition_parallele
#print axioms ConditionalCRO.frechet
#print axioms ConditionalCRO.xor_not_subadditive
#print axioms ConditionalCRO.copy_not_superadditive
#print axioms ConditionalCRO.chain_rule
#print axioms ConditionalCRO.condMI_nonneg
#print axioms ConditionalCRO.miN_kernel_only_on_s
#print axioms ConditionalCRO.CLOModel.fondement_extraction
#print axioms ConditionalCRO.CLOModel.IVSM_nonneg
#print axioms ConditionalCRO.miN_eq_entN2_of_det
#print axioms ConditionalCRO.CLOModel.opp_eq_one_of_det_concrete
#print axioms ConditionalCRO.conf_guarantee_antitone

/-! ## 14. Noyau algébrique quantique (version 3.6, lot L5a)

Ajout du 27 novembre 2026. Cette section formalise le Trilemme CRO conditionnel
quantique (Théorème 2.5 du manuscrit v36) sur le modèle du noyau classique : les
lemmes d'information quantique (Fano quantique, Holevo, Pinsker quantique) sont des
champs de `QuantumProtocolInstance`, les Hypothèses 2.5 à 2.7 forment
`QuantumAssumptions` et le régime (Hypothèse 2.8) est une prémisse. La Définition 2.27
et la Remarque 2.27 sont démontrées sur les lois finies de la section 12. -/

section ExtensionL5a

open Finset

namespace ConditionalCRO

/-! ### 14.1 Paramètres et instance d'un protocole post-quantique

Comme le noyau classique des sections 3 à 7, le noyau quantique travaille sur des
réels. Les lemmes d'information quantique y sont des champs de l'instance : Fano
quantique (Lemme 2.6), borne de Holevo (Lemme 2.7) et Pinsker quantique (Lemme 2.4).
L'information mutuelle I(M;Σ|C) est la moyenne des informations de Holevo, majorée par
leur maximum χmax (preuve de la Remarque 2.33). -/

/-- Paramètres institutionnels quantiques (Δ_q, α_q, θ_q, β_q, ζ_q, η_q) et H(C). -/
structure QuantumParams where
  H  : ℝ      -- H(C) (bits)
  Δq : ℝ      -- capacité d'extraction quantique
  αq : ℝ      -- granularité quantique des verdicts
  θq : ℝ      -- non-dégénérescence du verdict
  βq : ℝ      -- régularité quantique
  ζq : ℝ      -- terme de régularité relatif à l'état mélangé
  ηq : ℝ      -- perte d'interprétabilité quantique
  hH  : 0 ≤ H
  hΔq : 0 ≤ Δq
  hαq : 0 < αq
  hθq : 0 < θq ∧ θq ≤ 1
  hβq : 1 ≤ βq
  hζq : 0 ≤ ζq
  hηq : 0 ≤ ηq

/-- γ_q = θ_q·α_q·H(C) (Hypothèse 2.6). -/
def gammaQ (p : QuantumParams) : ℝ := p.θq * p.αq * p.H

/-- Point du modèle abstrait quantique. -/
structure QuantumProtocolInstance (lam : ℕ) where
  params : QuantumParams
  Conf : ℝ    -- Conf^q = 1 − TDmax (Définition 2.24)
  Rel  : ℝ    -- Rel^q, estimateur quantique optimal (Définition 2.25)
  Opp  : ℝ    -- Opp^q = I(V;Σ|C)/H(V|C) (Définition 2.26)
  I    : ℝ    -- I(M;Σ|C), moyenne des informations de Holevo
  χmax : ℝ    -- max_c χ(E_{m,c})
  Iacc : ℝ    -- information accessible
  IV   : ℝ    -- I(V;Σ|C)
  HV   : ℝ    -- H(V|C)
  TDmax : ℝ   -- max ½‖ρ^{m₀,c} − ρ^{m₁,c}‖₁
  Dmsg : ℝ    -- max D(ρ^{m₀,c} ‖ ρ^{m₁,c})
  Dmax : ℝ    -- max_c D(ρ̄^c ‖ I/d)
  hConf : Conf = 1 - TDmax
  hOpp  : Opp = IV / HV
  hTD   : 0 ≤ TDmax ∧ TDmax ≤ 1
  hRel  : 0 ≤ Rel ∧ Rel ≤ 1
  hI    : 0 ≤ I
  hIV   : 0 ≤ IV
  hDmax : 0 ≤ Dmax
  fano_q : Rel * lam - 1 ≤ Iacc          -- Lemme 2.6 (Fano quantique)
  holevo : Iacc ≤ I                      -- Lemme 2.7 (borne de Holevo)
  moyenne_le_max : I ≤ χmax              -- moyenne ≤ maximum (Remarque 2.33)
  pinsker_q : TDmax ^ 2 ≤ Dmsg / 2       -- Lemme 2.4 (Pinsker quantique)

/-- Hypothèses 2.5 à 2.7. Le régime (Hypothèse 2.8) est une prémisse des théorèmes. -/
structure QuantumAssumptions {lam : ℕ} (P : QuantumProtocolInstance lam) : Prop where
  /-- Hypothèse 2.5 (extraction quantique bornée) : I(V;Σ|C) ≤ I(M;Σ|C) + Δ_q. -/
  A5 : P.IV ≤ P.I + P.params.Δq
  /-- Hypothèse 2.6 (verdict efficace quantique) : H(V|C) ≥ γ_q … -/
  A6 : gammaQ P.params ≤ P.HV
  /-- … avec γ_q ≥ 1. -/
  A6γ : 1 ≤ gammaQ P.params
  /-- Hypothèse 2.7 (régularité quantique) : D ≤ β_q·χ + ζ_q·D(ρ̄ ‖ I/d). -/
  A7 : P.Dmsg ≤ P.params.βq * P.χmax + P.params.ζq * P.Dmax

namespace QuantumProtocolInstance

variable {lam : ℕ} (P : QuantumProtocolInstance lam)

/-- Fano quantique et Holevo donnent la relation de Fano sur I(M;Σ|C). -/
lemma fano_I : P.Rel * lam - 1 ≤ P.I := P.fano_q.trans P.holevo

/-- **Lemme 2.8 (garantie de confidentialité quantique).** Sous l'Hypothèse 2.7,
    Conf^q ≥ 1 − ½·√(2β_q·χmax + 2ζ_q·Dmax). -/
theorem conf_guarantee (A7 : P.Dmsg ≤ P.params.βq * P.χmax + P.params.ζq * P.Dmax) :
    1 - (1 / 2) * Real.sqrt (2 * P.params.βq * P.χmax + 2 * P.params.ζq * P.Dmax) ≤ P.Conf := by
  rw [P.hConf]
  have h0 := P.hTD.1
  have hsq : P.TDmax ^ 2 ≤ (1 / 2 * Real.sqrt (2 * P.params.βq * P.χmax + 2 * P.params.ζq * P.Dmax)) ^ 2 := by
    have hpos : 0 ≤ 2 * P.params.βq * P.χmax + 2 * P.params.ζq * P.Dmax := by
      have := P.pinsker_q; nlinarith [sq_nonneg P.TDmax]
    rw [mul_pow, Real.sq_sqrt hpos]
    have := P.pinsker_q
    linarith
  have hb : 0 ≤ 1 / 2 * Real.sqrt (2 * P.params.βq * P.χmax + 2 * P.params.ζq * P.Dmax) := by positivity
  have := (sq_le_sq₀ h0 hb).1 hsq
  linarith

end QuantumProtocolInstance

/-! ### 14.2 Trilemme CRO conditionnel quantique (Théorème 2.5) -/

/-- **Théorème 2.5, forme explicite.** Sous les Hypothèses 2.5, 2.6 et le régime
    χmax ≤ κ/λ (Hypothèse 2.8), pour λ ≥ 1 :
    Conf^q·Rel^q·Opp^q ≤ (1/γ_q)(Δ_q/λ + κ(Δ_q+1)/λ² + κ²/λ³). -/
theorem trilemma_pq_explicit {lam : ℕ} (P : QuantumProtocolInstance lam)
    (hA : QuantumAssumptions P) (κ : ℝ) (hκ : 0 ≤ κ) (hlam : 1 ≤ lam)
    (A8 : P.χmax ≤ κ / lam) :
    P.Conf * P.Rel * P.Opp ≤ (1 / gammaQ P.params) *
      (P.params.Δq / lam + κ * (P.params.Δq + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 3) := by
  have hC1 : P.Conf ≤ 1 := by rw [P.hConf]; linarith [P.hTD.1]
  exact product_bound_explicit hC1 P.hRel.1 P.fano_I P.hI P.hIV P.hOpp hA.A5 hA.A6 hA.A6γ hκ hlam
    (P.moyenne_le_max.trans A8)

/-- **Remarque 2.41 (la majoration publiée comme corollaire).** Sous les mêmes
    hypothèses, Conf^q·Rel^q·Opp^q ≤ (Δ_q + η_q·H(C))/λ + K/λ² + ε₀(λ) avec
    K = κ(Δ_q+1) + κ² et ε₀ négligeable. -/
theorem trilemma_pq_published {lam : ℕ} (P : QuantumProtocolInstance lam)
    (hA : QuantumAssumptions P) (κ : ℝ) (hκ : 0 ≤ κ) (hlam : 1 ≤ lam)
    (A8 : P.χmax ≤ κ / lam) :
    P.Conf * P.Rel * P.Opp ≤ (P.params.Δq + P.params.ηq * P.params.H) / lam +
      (κ * (P.params.Δq + 1) + κ ^ 2) / (lam : ℝ) ^ 2 + ε₀ lam := by
  have h := trilemma_pq_explicit P hA κ hκ hlam A8
  have hl : (1 : ℝ) ≤ lam := by exact_mod_cast hlam
  have hl0 : (0 : ℝ) < lam := by linarith
  have hΔ := P.params.hΔq
  have hB : 0 ≤ P.params.Δq / lam + κ * (P.params.Δq + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 3 := by
    positivity
  have hγ1 : 1 / gammaQ P.params ≤ 1 := by rw [div_le_one (by linarith [hA.A6γ])]; exact hA.A6γ
  have h1 := h.trans (mul_le_of_le_one_left hB hγ1)
  have h3 : κ ^ 2 / (lam : ℝ) ^ 3 ≤ κ ^ 2 / (lam : ℝ) ^ 2 := by
    have e : κ ^ 2 / (lam : ℝ) ^ 3 = κ ^ 2 / (lam : ℝ) ^ 2 * (1 / lam) := by field_simp
    rw [e]
    exact mul_le_of_le_one_right (by positivity) (by rw [div_le_one hl0]; exact hl)
  have hη : 0 ≤ P.params.ηq * P.params.H / lam := by
    have := P.params.hηq; have := P.params.hH; positivity
  have hε := ε₀_nonneg lam
  have e1 : (P.params.Δq + P.params.ηq * P.params.H) / lam =
      P.params.Δq / lam + P.params.ηq * P.params.H / lam := add_div _ _ _
  have e2 : (κ * (P.params.Δq + 1) + κ ^ 2) / (lam : ℝ) ^ 2 =
      κ * (P.params.Δq + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 2 := add_div _ _ _
  linarith

/-- Famille de protocoles post-quantiques indexée par λ, à paramètres fixes. -/
structure QuantumProtocolFamily where
  params : QuantumParams
  inst : ∀ lam : ℕ, QuantumProtocolInstance lam
  hparams : ∀ lam, (inst lam).params = params

/-- **Théorème 2.5, forme asymptotique.** Sous les Hypothèses 2.5 à 2.8, il existe K
    et ε négligeable tels que, pour λ ≥ 64,
    Conf^q·Rel^q·Opp^q ≤ (Δ_q + η_q·H(C))/λ + K/λ² + ε(λ). -/
theorem conditional_CRO_trilemma_pq (F : QuantumProtocolFamily) (κ : ℝ) (hκ : 0 ≤ κ)
    (hA : ∀ lam, 64 ≤ lam → QuantumAssumptions (F.inst lam))
    (A8 : ∀ lam, 64 ≤ lam → (F.inst lam).χmax ≤ κ / lam) :
    ∃ K : ℝ, ∃ ε : ℕ → ℝ, Negligible ε ∧ ∀ lam : ℕ, 64 ≤ lam →
      (F.inst lam).Conf * (F.inst lam).Rel * (F.inst lam).Opp ≤
        (F.params.Δq + F.params.ηq * F.params.H) / lam + K / (lam : ℝ) ^ 2 + ε lam := by
  refine ⟨κ * (F.params.Δq + 1) + κ ^ 2, ε₀, negligible_eps0, fun lam hlam => ?_⟩
  have h := trilemma_pq_published (F.inst lam) (hA lam hlam) κ hκ (by omega) (A8 lam hlam)
  rwa [F.hparams lam] at h

/-! ### 14.3 Forme raffinée, seuil H♯_q et forme simplifiée -/

/-- **Remarque 2.39 (forme raffinée quantique).** Avec Opp^q ≤ 1,
    Conf^q·Rel^q·Opp^q ≤ ((1 + κ/λ)/λ)·min{1, (κ/λ + Δ_q)/γ_q}. -/
theorem trilemma_pq_refined {lam : ℕ} (P : QuantumProtocolInstance lam)
    (hA : QuantumAssumptions P) (κ : ℝ) (hκ : 0 ≤ κ) (hlam : 1 ≤ lam)
    (A8 : P.χmax ≤ κ / lam) (hIVHV : P.IV ≤ P.HV) :
    P.Conf * P.Rel * P.Opp ≤
      ((κ / lam + 1) / lam) * min 1 ((κ / lam + P.params.Δq) / gammaQ P.params) := by
  have hC1 : P.Conf ≤ 1 := by rw [P.hConf]; linarith [P.hTD.1]
  exact product_bound_refined hC1 P.hRel.1 P.fano_I P.hIV P.hOpp hA.A5 hA.A6 hA.A6γ hκ hlam
    (P.moyenne_le_max.trans A8) hIVHV

/-- **Remarque 2.39, seuil.** Le facteur institutionnel quantique est < 1 si et
    seulement si Δ_q < γ_q − κ/λ, c'est-à-dire H(C) > H♯_q = (Δ_q + κ/λ)/(θ_q·α_q).
    Le paramètre η_q n'y intervient pas. -/
theorem seuil_Hsharp_q (p : QuantumParams) (κ lam : ℝ) (hγ : 0 < gammaQ p) :
    (min 1 ((κ / lam + p.Δq) / gammaQ p) < 1 ↔ p.Δq < gammaQ p - κ / lam) ∧
      (p.Δq < gammaQ p - κ / lam ↔ (p.Δq + κ / lam) / (p.θq * p.αq) < p.H) := by
  refine ⟨factor_lt_one_iff p.Δq (gammaQ p) κ lam hγ, ?_⟩
  have hθα : 0 < p.θq * p.αq := mul_pos p.hθq.1 p.hαq
  unfold gammaQ
  rw [div_lt_iff₀ hθα]
  constructor <;> intro h <;> linarith

/-- **Corollaire 2.2 (forme simplifiée quantique).** Pour D = Δ_q + η_q·H(C) > 0, le
    rapport du majorant D/λ + K/λ² à D/λ tend vers 1 quand λ → ∞. -/
theorem forme_simplifiee_pq (D K : ℝ) (hD : 0 < D) :
    Tendsto (fun lam : ℕ => (D / lam + K / (lam : ℝ) ^ 2) / (D / lam)) atTop (nhds 1) := by
  have e : ∀ lam : ℕ, 1 ≤ lam →
      (D / lam + K / (lam : ℝ) ^ 2) / (D / lam) = 1 + K / D * (1 / (lam : ℝ)) := by
    intro lam hl
    have hl0 : (0 : ℝ) < lam := by exact_mod_cast hl
    field_simp
  have h : Tendsto (fun lam : ℕ => 1 + K / D * (1 / (lam : ℝ))) atTop (nhds 1) := by
    have h0 : Tendsto (fun lam : ℕ => 1 / (lam : ℝ)) atTop (nhds 0) :=
      tendsto_one_div_atTop_nhds_zero_nat
    simpa using (h0.const_mul (K / D)).const_add 1
  refine h.congr' ?_
  filter_upwards [eventually_ge_atTop 1] with lam hl
  exact (e lam hl).symm

/-! ### 14.4 Statut des hypothèses quantiques (Remarques 2.31 à 2.33) -/

/-- **Remarque 2.31.** La borne k_λ ≤ 2^(α_q·H(C)) n'entraîne pas H(V|C) ≥ θ_q·α_q·H(C).
    Contre-exemple : verdict constant de la famille témoin (H(C) = 1), pour tous
    θ_q, α_q > 0. -/
theorem verdict_q_card_not_efficient (l : ℕ) (θq αq : ℝ) (hθ : 0 < θq) (hα : 0 < αq) :
    ((Fintype.card (Fin 1) : ℝ) ≤ (2 : ℝ) ^ (αq * (famModel l).constVerdict.HC)) ∧
      (famModel l).constVerdict.HV < θq * αq * (famModel l).constVerdict.HC := by
  have hHC : (famModel l).constVerdict.HC = 1 := CLOModel.fam_HC l
  have hHV : (famModel l).constVerdict.HV = 0 :=
    CLOModel.HV_eq_zero_of_card_one _ (Fintype.card_fin 1)
  rw [hHC, hHV]
  refine ⟨?_, by positivity⟩
  simp only [Fintype.card_fin, Nat.cast_one, mul_one]
  exact Real.one_le_rpow (by norm_num) hα.le

/-- **Remarque 2.32 (raccord avec l'Hypothèse 2.2).** Avec α_q = α, γ_q = γ si et
    seulement si θ_q = 1 − 1/(αH(C)) ; sous γ ≥ 1, ce choix est dans [1/2, 1). -/
theorem raccord_gamma_q (α H θq : ℝ) (hαH : 0 < α * H) :
    (θq * α * H = α * H - 1 ↔ θq = 1 - 1 / (α * H)) ∧
      (1 ≤ α * H - 1 → (1 / 2 ≤ 1 - 1 / (α * H) ∧ 1 - 1 / (α * H) < 1)) := by
  have hne : α * H ≠ 0 := hαH.ne'
  constructor
  · rw [mul_assoc]
    constructor
    · intro h
      apply mul_right_cancel₀ hne
      rw [h, sub_mul, one_mul, one_div_mul_cancel hne]
    · intro h
      rw [h, sub_mul, one_mul, one_div_mul_cancel hne]
  · intro h
    have h2 : 2 ≤ α * H := by linarith
    refine ⟨?_, by have := one_div_pos.2 hαH; linarith⟩
    have : 1 / (α * H) ≤ 1 / 2 := one_div_le_one_div_of_le (by norm_num) h2
    linarith

/-- **Remarque 2.33 (statut de l'Hypothèse 2.8).** Le régime χmax ≤ κ/λ entraîne
    I_acc ≤ I(M;Σ|C) ≤ κ/λ et, sous l'Hypothèse 2.7,
    Conf^q ≥ 1 − ½·√(2β_q·κ/λ + 2ζ_q·Dmax). -/
theorem statut_regime_q {lam : ℕ} (P : QuantumProtocolInstance lam) (κ : ℝ)
    (A7 : P.Dmsg ≤ P.params.βq * P.χmax + P.params.ζq * P.Dmax) (A8 : P.χmax ≤ κ / lam) :
    P.Iacc ≤ P.I ∧ P.I ≤ κ / lam ∧
      1 - (1 / 2) * Real.sqrt (2 * P.params.βq * (κ / lam) + 2 * P.params.ζq * P.Dmax) ≤ P.Conf := by
  refine ⟨P.holevo, P.moyenne_le_max.trans A8, le_trans ?_ (P.conf_guarantee A7)⟩
  have hβ : 0 ≤ P.params.βq := by linarith [P.params.hβq]
  have : 2 * P.params.βq * P.χmax + 2 * P.params.ζq * P.Dmax ≤
      2 * P.params.βq * (κ / lam) + 2 * P.params.ζq * P.Dmax := by nlinarith
  linarith [Real.sqrt_le_sqrt this]

/-! ### 14.5 Constantes, encadrement de η_q, décomposition de Δ_q -/

/-- **Remarque 2.35.** Les constantes de Pinsker vérifient (ln 2)/2 < 1/2 < c₀. -/
theorem constantes_pinsker : Real.log 2 / 2 < 1 / 2 ∧ (1 : ℝ) / 2 < c0 := by
  have h := Real.log_two_lt_d9
  exact ⟨by linarith, c0_gt_half⟩

/-- **Définition 2.30.** Δ_q = Δ + δ_enh − δ_degr. -/
def deltaQ (Δ δenh δdegr : ℝ) : ℝ := Δ + δenh - δdegr

/-- Sans renforcement (δ_enh = 0), la capacité quantique ne dépasse pas Δ. -/
theorem deltaQ_le (Δ δdegr : ℝ) (h : 0 ≤ δdegr) : deltaQ Δ 0 δdegr ≤ Δ := by
  unfold deltaQ; linarith

/-- Perte d'interprétabilité d'un canal T agissant sur la preuve, dans le modèle fini :
    le plus petit η tel que I(V;T(Σ)|C) ≥ I(V;Σ|C) − η·H(C) (Définition 2.27). -/
noncomputable def CLOModel.etaQ {lam : ℕ} {M C S S' V : Type*} [Fintype M] [Fintype C]
    [Fintype S] [Fintype S'] [Fintype V] (X : CLOModel lam M C S V) (T : C → S → S' → ℝ) : ℝ :=
  (X.IV - X.IVpost T) / X.HC

/-- **Remarque 2.27 (encadrement de η_q) sur lois finies.** Pour H(C) > 0,
    0 ≤ η_q ≤ log₂|V|/H(C), η_q réalise la Définition 2.27 avec égalité, et η_q ≤ α
    dès que |V| ≤ 2^(αH(C)). -/
theorem etaQ_bounds {lam : ℕ} {M C S S' V : Type*} [Fintype M] [Fintype C] [Fintype S]
    [Fintype S'] [Fintype V] [Nonempty V] (X : CLOModel lam M C S V) (T : C → S → S' → ℝ)
    (hT : ∀ c s t, 0 ≤ T c s t) (hT1 : ∀ c s, ∑ t, T c s t = 1) (hHC : 0 < X.HC) (α : ℝ) :
    0 ≤ X.etaQ T ∧ X.IVpost T = X.IV - X.etaQ T * X.HC ∧
      X.etaQ T ≤ Real.log (Fintype.card V) / Real.log 2 / X.HC ∧
      ((Fintype.card V : ℝ) ≤ (2 : ℝ) ^ (α * X.HC) → X.etaQ T ≤ α) := by
  have hpost := (X.opp_post T hT hT1).1
  have hpost0 : 0 ≤ X.IVpost T := by
    unfold CLOModel.IVpost
    refine div_nonneg (sum_nonneg fun c _ => mul_nonneg (X.pC_nonneg c) (miN_nonneg _
      (fun v t => sum_nonneg fun s _ => mul_nonneg (X.qSV_nonneg c s v) (hT c s t)) ?_))
      CLOModel.log_two_pos'.le
    have e : ∑ v, ∑ t, ∑ s, X.qSV c s v * T c s t = ∑ v, ∑ s, X.qSV c s v := by
      refine sum_congr rfl fun v _ => ?_
      rw [Finset.sum_comm]
      exact sum_congr rfl fun s _ => by rw [← mul_sum, hT1, mul_one]
    rw [e, Finset.sum_comm]
    exact X.qSV_sum_le c
  have hG := X.goulot_contexte α
  have hIVle : X.IV ≤ Real.log (Fintype.card V) / Real.log 2 := X.IV_le_HV.trans X.HV_le_log_card
  unfold CLOModel.etaQ
  refine ⟨div_nonneg (by linarith) hHC.le, by field_simp; ring, ?_, ?_⟩
  · exact div_le_div_of_nonneg_right (by linarith) hHC.le
  · intro hcard
    have h3 := hG.2.2 hcard
    rw [div_le_iff₀ hHC]
    linarith

/-! ### 14.6 Capacité institutionnelle quantique (Remarque 2.29) -/

/-- **Remarque 2.29.** L'inégalité de traitement des données ne fournit pas
    l'Hypothèse 2.5 : dans la famille témoin, le verdict recopie un bit de la preuve
    indépendant du message, d'où I(V;Σ|C) = 1 alors que I(M;Σ|C) = 0. L'inégalité
    d'extraction y exige Δ_q ≥ 1, et ce bit est exactement I(V;Σ|M,C) (Proposition 2.1). -/
theorem capacite_q_non_dpi (l : ℕ) :
    (famModel l).I = 0 ∧ (famModel l).IV = 1 ∧ ¬ ((famModel l).IV ≤ (famModel l).I + 0) ∧
      (famModel l).IVSM = 1 := by
  have hI := CLOModel.fam_I l
  have hIV := CLOModel.fam_IV l
  obtain ⟨heq, hle, -, -⟩ := (famModel l).fondement_extraction
  have hIVM0 : 0 ≤ (famModel l).IVM := by
    unfold CLOModel.IVM
    refine div_nonneg (sum_nonneg fun c _ => mul_nonneg (CLOModel.pC_nonneg _ c) (miN_nonneg _
      (fun v m => sum_nonneg fun s _ => mul_nonneg (CLOModel.qMS_nonneg _ c m s)
        (CLOModel.ker_nonneg _ c s v)) ?_)) CLOModel.log_two_pos'.le
    have e : ∑ v, ∑ m, ∑ s, (famModel l).qMS c m s * (famModel l).ker c s v =
        ∑ m, ∑ s, (famModel l).qMS c m s := by
      rw [Finset.sum_comm]
      refine sum_congr rfl fun m _ => ?_
      rw [Finset.sum_comm]
      exact sum_congr rfl fun s _ => by rw [← mul_sum, (famModel l).ker_sum, mul_one]
    rw [e]
    exact CLOModel.qMS_sum_le _ c
  refine ⟨hI, hIV, by rw [hI, hIV]; norm_num, ?_⟩
  rw [hI] at hle
  have : (famModel l).IVM = 0 := le_antisymm hle hIVM0
  rw [hIV, this, zero_add] at heq
  exact heq.symm

/-! ### 14.7 Portée du Théorème 2.5 : le régime est nécessaire (Remarque 2.37) -/

/-- Paramètres du témoin de portée quantique : H(C) = 2, Δ_q = 0, α_q = 1, θ_q = 1/2
    (γ_q = 1), β_q = 1, ζ_q = 0, η_q = 0 (encodage classique diagonal). -/
noncomputable def ScopeParamsQ : QuantumParams :=
  { H := 2, Δq := 0, αq := 1, θq := 1 / 2, βq := 1, ζq := 0, ηq := 0,
    hH := by norm_num, hΔq := le_refl _, hαq := by norm_num, hθq := by norm_num,
    hβq := le_refl _, hζq := le_refl _, hηq := le_refl _ }

/-- Instance hors régime : la preuve révèle M avec probabilité 1/2,
    I(M;Σ|C) = χmax = I_acc = λ/2. -/
noncomputable def scopeInstanceQ (lam : ℕ) (hlam : 64 ≤ lam) : QuantumProtocolInstance lam :=
  { params := ScopeParamsQ, Conf := 1 / 2, Rel := 1 / 2, Opp := 1, I := lam / 2,
    χmax := lam / 2, Iacc := lam / 2, IV := 1, HV := 1, TDmax := 1 / 2, Dmsg := 1 / 2,
    Dmax := 0,
    hConf := by norm_num, hOpp := by norm_num, hTD := by norm_num, hRel := by norm_num,
    hI := by positivity, hIV := by norm_num, hDmax := le_refl _,
    fano_q := by linarith, holevo := le_refl _, moyenne_le_max := le_refl _,
    pinsker_q := by norm_num }

/-- **Remarque 2.37 (l'Hypothèse 2.8 est nécessaire).** Pour tout λ ≥ 64, une instance
    satisfait les Hypothèses 2.5 à 2.7 avec Δ_q = η_q = 0 et Conf^q·Rel^q·Opp^q = 1/4,
    alors que χmax = λ/2 viole le régime. -/
theorem regime_q_necessary (lam : ℕ) (hlam : 64 ≤ lam) :
    QuantumAssumptions (scopeInstanceQ lam hlam) ∧
      (scopeInstanceQ lam hlam).params.Δq = 0 ∧ (scopeInstanceQ lam hlam).params.ηq = 0 ∧
      (scopeInstanceQ lam hlam).Conf * (scopeInstanceQ lam hlam).Rel *
        (scopeInstanceQ lam hlam).Opp = 1 / 4 ∧
      (scopeInstanceQ lam hlam).χmax = lam / 2 := by
  have hl : (64 : ℝ) ≤ lam := by exact_mod_cast hlam
  refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_, ?_, ?_, ?_⟩ <;>
    simp [scopeInstanceQ, ScopeParamsQ, gammaQ] <;> norm_num <;> linarith

/-! ### 14.8 Cohérence du modèle abstrait quantique -/

/-- Témoin de cohérence : une instance satisfait les Hypothèses 2.5 à 2.8 (κ = 0) et
    atteint la borne explicite Δ_q/(γ_q·λ) avec Δ_q = 1, γ_q = 1. -/
noncomputable def WitnessParamsQ : QuantumParams :=
  { H := 2, Δq := 1, αq := 1, θq := 1 / 2, βq := 1, ζq := 0, ηq := 0,
    hH := by norm_num, hΔq := by norm_num, hαq := by norm_num, hθq := by norm_num,
    hβq := le_refl _, hζq := le_refl _, hηq := le_refl _ }

noncomputable def witnessInstanceQ (lam : ℕ) (hlam : 1 ≤ lam) : QuantumProtocolInstance lam :=
  { params := WitnessParamsQ, Conf := 1, Rel := 1 / lam, Opp := 1, I := 0, χmax := 0,
    Iacc := 0, IV := 1, HV := 1, TDmax := 0, Dmsg := 0, Dmax := 0,
    hConf := by norm_num, hOpp := by norm_num, hTD := by norm_num,
    hRel := by
      have hl : (1 : ℝ) ≤ lam := by exact_mod_cast hlam
      exact ⟨by positivity, by rw [div_le_one (by linarith)]; exact hl⟩,
    hI := le_refl _, hIV := by norm_num, hDmax := le_refl _,
    fano_q := by
      have hl : (0 : ℝ) < lam := by exact_mod_cast hlam
      rw [div_mul_cancel₀ _ hl.ne']; norm_num,
    holevo := le_refl _, moyenne_le_max := le_refl _, pinsker_q := by norm_num }

/-- **Cohérence.** Les Hypothèses 2.5 à 2.8 sont satisfiables simultanément et la
    borne explicite du Théorème 2.5 est atteinte : produit = Δ_q/(γ_q·λ) = 1/λ. -/
theorem assumptions_q_consistent (lam : ℕ) (hlam : 1 ≤ lam) :
    QuantumAssumptions (witnessInstanceQ lam hlam) ∧
      (witnessInstanceQ lam hlam).χmax ≤ 0 / lam ∧
      (witnessInstanceQ lam hlam).Conf * (witnessInstanceQ lam hlam).Rel *
        (witnessInstanceQ lam hlam).Opp =
        (witnessInstanceQ lam hlam).params.Δq / (gammaQ (witnessInstanceQ lam hlam).params * lam) := by
  refine ⟨⟨?_, ?_, ?_, ?_⟩, ?_, ?_⟩ <;>
    simp [witnessInstanceQ, WitnessParamsQ, gammaQ]

/-! ### 14.9 Ordre de grandeur de D_max pour ML-DSA-65 (Remarque 2.36) -/

/-- **Remarque 2.36.** Une signature ML-DSA-65 compte 3 309 octets, soit 26 472 bits.
    Si H(Σ|C = c) ≤ λ + 256 avec λ ≤ 256, alors D_max = 26 472 − H(Σ|C = c) ≥ 25 960 bits :
    le minorant du Lemme 2.8 cesse d'être informatif dès que ζ_q n'est pas infime. -/
theorem dilithium_Dmax (lam Hs : ℝ) (hlam : lam ≤ 256) (hH : Hs ≤ lam + 256) :
    (25960 : ℝ) ≤ 3309 * 8 - Hs := by
  linarith

end ConditionalCRO

end ExtensionL5a

/-! ## 15. Bloc de vérification du noyau quantique (version 3.6) -/

#print axioms ConditionalCRO.QuantumProtocolInstance.conf_guarantee
#print axioms ConditionalCRO.trilemma_pq_explicit
#print axioms ConditionalCRO.trilemma_pq_published
#print axioms ConditionalCRO.conditional_CRO_trilemma_pq
#print axioms ConditionalCRO.trilemma_pq_refined
#print axioms ConditionalCRO.seuil_Hsharp_q
#print axioms ConditionalCRO.forme_simplifiee_pq
#print axioms ConditionalCRO.verdict_q_card_not_efficient
#print axioms ConditionalCRO.raccord_gamma_q
#print axioms ConditionalCRO.statut_regime_q
#print axioms ConditionalCRO.constantes_pinsker
#print axioms ConditionalCRO.deltaQ_le
#print axioms ConditionalCRO.etaQ_bounds
#print axioms ConditionalCRO.capacite_q_non_dpi
#print axioms ConditionalCRO.regime_q_necessary
#print axioms ConditionalCRO.assumptions_q_consistent
#print axioms ConditionalCRO.dilithium_Dmax

/-! ## 16. Bornes avancées (version 3.7, lot L2)

Ajout du 27 novembre 2026. Cette section démontre sur lois finies la Proposition 2.2
(borne aiguë en κ/λ², par la divergence binaire au lieu de h(p) ≤ 1), la dernière
phrase du Théorème 2.4, le Corollaire 2.1, les Remarques 2.20 (témoin réalisable),
2.24, 5.5 et, dans le modèle abstrait quantique, la Remarque 2.40. -/

section ExtensionL2

open Finset

namespace ConditionalCRO

/-! ### 16.1 Inégalité log-somme sur une partition en deux blocs -/

/-- Pour deux lois a, b (masse totale 1, a ≪ b) et un événement E de masses p et q,
    Σ a·log(a/b) ≥ p·log(p/q) + (1 − p)·log((1 − p)/(1 − q)) : c'est la réduction à
    deux issues de l'étape 1 de la preuve de la Proposition 2.2. -/
theorem log_sum_two_blocks {ι : Type*} [Fintype ι] (a b : ι → ℝ) (E : ι → Prop)
    [DecidablePred E] (ha : ∀ i, 0 ≤ a i) (hb : ∀ i, 0 ≤ b i) (hab : ∀ i, 0 < a i → 0 < b i)
    (ha1 : ∑ i, a i = 1) (hb1 : ∑ i, b i = 1) :
    (∑ i ∈ univ.filter E, a i) * Real.log ((∑ i ∈ univ.filter E, a i) / ∑ i ∈ univ.filter E, b i) +
      (1 - ∑ i ∈ univ.filter E, a i) *
        Real.log ((1 - ∑ i ∈ univ.filter E, a i) / (1 - ∑ i ∈ univ.filter E, b i))
      ≤ ∑ i, a i * Real.log (a i / b i) := by
  classical
  have l1 := log_sum_ineq (univ.filter E) a b (fun i _ => ha i) (fun i _ => hb i) (fun i _ => hab i)
  have l2 := log_sum_ineq (univ.filter (fun i => ¬ E i)) a b (fun i _ => ha i) (fun i _ => hb i)
    (fun i _ => hab i)
  have sa := sum_filter_add_sum_filter_not univ E a
  have sb := sum_filter_add_sum_filter_not univ E b
  have st := sum_filter_add_sum_filter_not univ E (fun i => a i * Real.log (a i / b i))
  rw [ha1] at sa; rw [hb1] at sb
  rw [show ∑ i ∈ univ.filter (fun i => ¬ E i), a i = 1 - ∑ i ∈ univ.filter E, a i by linarith,
    show ∑ i ∈ univ.filter (fun i => ¬ E i), b i = 1 - ∑ i ∈ univ.filter E, b i by linarith] at l2
  linarith

/-! ### 16.2 Fano aigu sur lois finies -/

namespace CLOModel

variable {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C] [Fintype S] [Fintype V]
  (X : CLOModel lam M C S V)

/-- Masse de référence b(c, m, s) = P(c, m)·P(c, s)/P(c), loi produit de M et Σ
    sachant C. -/
noncomputable def bProd (c : C) (m : M) (s : S) : ℝ :=
  (∑ s', X.P c m s') * (∑ m', X.P c m' s) / X.pC c

lemma bProd_nonneg (c : C) (m : M) (s : S) : 0 ≤ X.bProd c m s :=
  div_nonneg (mul_nonneg (sum_nonneg fun _ _ => X.P_nonneg _ _ _)
    (sum_nonneg fun _ _ => X.P_nonneg _ _ _)) (X.pC_nonneg c)

/-- I(M;Σ|C) en nats, écrite comme une divergence entre la loi jointe et b. -/
lemma I_nats : X.I * Real.log 2 =
    ∑ c, ∑ m, ∑ s, X.P c m s * Real.log (X.P c m s / X.bProd c m s) := by
  unfold I
  rw [div_mul_cancel₀ _ log_two_pos'.ne']
  refine sum_congr rfl fun c _ => ?_
  rcases (X.pC_nonneg c).lt_or_eq with h | h
  · unfold miN
    rw [mul_sum]
    refine sum_congr rfl fun m _ => ?_
    rw [mul_sum]
    refine sum_congr rfl fun s _ => ?_
    have e1 : ∑ b', X.qMS c m b' = (∑ s', X.P c m s') / X.pC c := by unfold qMS; rw [sum_div]
    have e2 : ∑ a', X.qMS c a' s = (∑ m', X.P c m' s) / X.pC c := by unfold qMS; rw [sum_div]
    rw [e1, e2]
    unfold qMS bProd
    have hne : X.pC c ≠ 0 := h.ne'
    rw [show (∑ s', X.P c m s') / X.pC c * ((∑ m', X.P c m' s) / X.pC c) =
        (∑ s', X.P c m s') * (∑ m', X.P c m' s) / X.pC c / X.pC c by field_simp,
      div_div_div_cancel_right₀ hne]
    field_simp
  · rw [← h, zero_mul]
    symm
    refine sum_eq_zero fun m _ => sum_eq_zero fun s _ => ?_
    rw [X.P_eq_zero_of_pC c h.symm m s, zero_mul]

/-- **Fano aigu sur lois finies** (étapes 1 à 3 de la preuve de la Proposition 2.2).
    Avec p = Rel(D) : I(M;Σ|C)·ln 2 ≥ p·λ·ln 2 + p·ln p − p. -/
theorem fano_sharp_model [DecidableEq M] [Nonempty M] (D : C → S → M) :
    X.Rel D * lam * Real.log 2 + X.Rel D * Real.log (X.Rel D) - X.Rel D ≤
      X.I * Real.log 2 := by
  classical
  set N : ℝ := (Fintype.card M : ℝ) with hN
  have hcard : N = 2 ^ lam := by rw [hN]; exact_mod_cast X.card_M
  have hN0 : 0 < N := by rw [hcard]; positivity
  have hN1 : 1 ≤ N := by rw [hcard]; exact one_le_pow₀ (by norm_num)
  have hrow : ∀ c m, ∑ s', X.P c m s' = X.pC c / N := fun c m => X.unif c m
  -- passage à ι = C × (M × S)
  let a : C × (M × S) → ℝ := fun x => X.P x.1 x.2.1 x.2.2
  let b : C × (M × S) → ℝ := fun x => X.bProd x.1 x.2.1 x.2.2
  let E : C × (M × S) → Prop := fun x => D x.1 x.2.2 = x.2.1
  have hsum3 : ∀ f : C → M → S → ℝ, ∑ x : C × (M × S), f x.1 x.2.1 x.2.2 = ∑ c, ∑ m, ∑ s, f c m s :=
    fun f => by rw [Fintype.sum_prod_type]; simp only [Fintype.sum_prod_type]
  have ha1 : ∑ x, a x = 1 := by rw [hsum3 (fun c m s => X.P c m s)]; exact X.P_sum
  have hb1 : ∑ x, b x = 1 := by
    rw [hsum3 (fun c m s => X.bProd c m s), ← X.sum_pC]
    refine sum_congr rfl fun c _ => ?_
    unfold bProd
    simp only [← sum_div]
    rw [← sum_mul_sum]
    rcases (X.pC_nonneg c).lt_or_eq with h | h
    · have e1 : ∑ m, ∑ s', X.P c m s' = X.pC c := rfl
      have e2 : ∑ s, ∑ m', X.P c m' s = X.pC c := by unfold pC; rw [Finset.sum_comm]
      rw [e1, e2]; field_simp
    · rw [← h]; simp
  have hab : ∀ x, 0 < a x → 0 < b x := by
    intro x hx
    simp only [b, bProd]
    have h1 : X.P x.1 x.2.1 x.2.2 ≤ ∑ s', X.P x.1 x.2.1 s' :=
      single_le_sum (f := fun s' => X.P x.1 x.2.1 s') (fun _ _ => X.P_nonneg _ _ _) (mem_univ _)
    have h2 : X.P x.1 x.2.1 x.2.2 ≤ ∑ m', X.P x.1 m' x.2.2 :=
      single_le_sum (f := fun m' => X.P x.1 m' x.2.2) (fun _ _ => X.P_nonneg _ _ _) (mem_univ _)
    exact div_pos (mul_pos (lt_of_lt_of_le hx h1) (lt_of_lt_of_le hx h2))
      (lt_of_lt_of_le hx (X.P_le_pC _ _ _))
  have key := log_sum_two_blocks a b E (fun x => X.P_nonneg _ _ _) (fun x => X.bProd_nonneg _ _ _)
    hab ha1 hb1
  -- masses de l'événement de succès
  have hp : ∑ x ∈ univ.filter E, a x = X.Rel D := by
    rw [sum_filter, hsum3 (fun c m s => if D c s = m then X.P c m s else 0)]
    rfl
  have hq : ∑ x ∈ univ.filter E, b x = 1 / N := by
    rw [sum_filter, hsum3 (fun c m s => if D c s = m then X.bProd c m s else 0)]
    have : ∀ c, ∑ m, ∑ s, (if D c s = m then X.bProd c m s else 0) = X.pC c / N := by
      intro c
      rw [Finset.sum_comm]
      simp only [sum_ite_eq, mem_univ, ite_true]
      unfold bProd
      simp only [hrow]
      rcases (X.pC_nonneg c).lt_or_eq with h | h
      · rw [← sum_div, ← mul_sum]
        have e2 : ∑ s, ∑ m', X.P c m' s = X.pC c := by unfold pC; rw [Finset.sum_comm]
        rw [e2]; field_simp
      · simp [← h]
    simp only [this]
    rw [← sum_div, X.sum_pC]
  have hI : ∑ x, a x * Real.log (a x / b x) = X.I * Real.log 2 := by
    rw [X.I_nats]; exact hsum3 (fun c m s => X.P c m s * Real.log (X.P c m s / X.bProd c m s))
  rw [hp, hq, hI] at key
  set p := X.Rel D with hpdef
  have hp0 : 0 ≤ p := (X.Rel_mem D).1
  have hp1 : p ≤ 1 := (X.Rel_mem D).2
  -- p·log(p/(1/N)) = p·log N + p·log p
  have e1 : p * Real.log (p / (1 / N)) = p * (lam * Real.log 2) + p * Real.log p := by
    rcases hp0.lt_or_eq with h | h
    · rw [div_div_eq_mul_div, div_one, Real.log_mul h.ne' hN0.ne', hcard, Real.log_pow]; ring
    · rw [← h]; simp
  -- (1 − p)·log((1 − p)/(1 − 1/N)) ≥ (1 − p)·log(1 − p) ≥ −p
  have e2 : -p ≤ (1 - p) * Real.log ((1 - p) / (1 - 1 / N)) := by
    rcases (sub_nonneg.2 hp1).lt_or_eq with h | h
    · have hl : -p ≤ (1 - p) * Real.log (1 - p) := by
        have := Real.one_sub_inv_le_log_of_pos h
        have e : (1 - p) * (1 - (1 - p)⁻¹) = -p := by field_simp; ring
        nlinarith [mul_le_mul_of_nonneg_left this h.le]
      refine hl.trans (mul_le_mul_of_nonneg_left ?_ h.le)
      rcases (sub_nonneg.2 (div_le_one_of_le₀ hN1 hN0.le : 1 / N ≤ 1)).lt_or_eq with h' | h'
      · apply Real.log_le_log h
        rw [le_div_iff₀ h']
        nlinarith [div_pos one_pos hN0]
      · rw [← h', div_zero, Real.log_zero]
        exact Real.log_nonpos h.le (by linarith)
    · rw [← h]; simp; linarith
  linarith

end CLOModel

/-! ### 16.3 Borne aiguë (Proposition 2.2) -/

/-- Étape 5 de la preuve de la Proposition 2.2, sur des réels. Si
    p·λ·ln 2 + p·ln p − p ≤ (κ/λ)·ln 2 avec λ ≥ 4, alors p ≤ 2κ/(λ(λ−3)) + 2^(−λ/2). -/
theorem rel_aigu_of_info {p lam κ : ℝ} (hp : 0 ≤ p) (hlam : 4 ≤ lam) (hκ : 0 ≤ κ)
    (h : p * lam * Real.log 2 + p * Real.log p - p ≤ κ / lam * Real.log 2) :
    p ≤ 2 * κ / (lam * (lam - 3)) + (2 : ℝ) ^ (-lam / 2) := by
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hl23 : 2 / 3 < Real.log 2 := by have := Real.log_two_gt_d9; linarith
  have hlam0 : 0 < lam := by linarith
  have hden : 0 < lam * (lam - 3) := by nlinarith
  have hA : 0 ≤ 2 * κ / (lam * (lam - 3)) := div_nonneg (by linarith) hden.le
  have hT : 0 < (2 : ℝ) ^ (-lam / 2) := Real.rpow_pos_of_pos (by norm_num) _
  by_cases hc : p ≤ (2 : ℝ) ^ (-lam / 2)
  · linarith
  push Not at hc
  have hp0 : 0 < p := hT.trans hc
  have hlog : -lam / 2 * Real.log 2 < Real.log p := by
    rw [← Real.log_rpow (by norm_num)]; exact Real.log_lt_log hT hc
  -- p·((λ−3)/2)·ln 2 ≤ (κ/λ)·ln 2
  have h1 : p * ((lam - 3) / 2 * Real.log 2) ≤ κ / lam * Real.log 2 := by
    have : p * (-lam / 2 * Real.log 2) ≤ p * Real.log p := mul_le_mul_of_nonneg_left hlog.le hp
    nlinarith
  have h2' : p * ((lam - 3) / 2) * Real.log 2 ≤ κ / lam * Real.log 2 := by nlinarith
  have h2 : p * ((lam - 3) / 2) ≤ κ / lam := le_of_mul_le_mul_right h2' hl2
  have h3 : p ≤ 2 * κ / (lam * (lam - 3)) := by
    rw [le_div_iff₀ hden]
    have := (le_div_iff₀ hlam0).1 h2
    nlinarith
  linarith

namespace CLOModel

variable {lam : ℕ} {M C S V : Type*} [Fintype M] [Fintype C] [Fintype S] [Fintype V]
  [DecidableEq M] [Nonempty M] [Nonempty C] (X : CLOModel lam M C S V)

omit [Nonempty C] in
/-- **Proposition 2.2 (2.61), borne aiguë sur la fiabilité de reconstruction.** Sous le
    régime I(M;Σ|C) ≤ κ/λ, pour λ ≥ 4 et tout décodeur D,
    Rel(D) ≤ 2κ/(λ(λ−3)) + 2^(−λ/2). -/
theorem rel_aigu (D : C → S → M) (κ : ℝ) (hκ : 0 ≤ κ) (hlam : 4 ≤ lam)
    (A4 : X.I ≤ κ / lam) :
    X.Rel D ≤ 2 * κ / ((lam : ℝ) * (lam - 3)) + (2 : ℝ) ^ (-(lam : ℝ) / 2) := by
  have h := X.fano_sharp_model D
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  refine rel_aigu_of_info (X.Rel_mem D).1 (by exact_mod_cast hlam) hκ ?_
  have := mul_le_mul_of_nonneg_right A4 hl2.le
  linarith

/-- **Proposition 2.2 (2.62), produit.** Sous les Hypothèses 2.1, 2.2 et 2.4,
    Conf·Rel·Opp ≤ (2κ/(λ(λ−3)) + 2^(−λ/2))·min{1, (κ/λ + Δ)/γ}. -/
theorem trilemma_aigu_concrete (D : C → S → M) (Δ α κ : ℝ) (hκ : 0 ≤ κ) (hlam : 4 ≤ lam)
    (A1 : X.IV ≤ X.I + Δ) (A2 : α * X.HC - 1 ≤ X.HV) (A2γ : 1 ≤ α * X.HC - 1)
    (A4 : X.I ≤ κ / lam) :
    X.Conf * X.Rel D * X.Opp ≤
      (2 * κ / ((lam : ℝ) * (lam - 3)) + (2 : ℝ) ^ (-(lam : ℝ) / 2)) *
        min 1 ((κ / lam + Δ) / (α * X.HC - 1)) := by
  have hR := X.rel_aigu D κ hκ hlam A4
  have hγ0 : 0 < α * X.HC - 1 := by linarith
  have hHV : 0 < X.HV := by linarith
  have hC1 : X.Conf ≤ 1 := by unfold Conf; linarith [X.TVmax_nonneg]
  have hC0 : 0 ≤ X.Conf := by unfold Conf; linarith [X.TVmax_le_one]
  have hR0 := (X.Rel_mem D).1
  have hO0 : 0 ≤ X.Opp := div_nonneg X.IV_nonneg hHV.le
  have hO1 : X.Opp ≤ 1 := by unfold Opp; rw [div_le_one hHV]; exact X.IV_le_HV
  have hO2 : X.Opp ≤ (κ / lam + Δ) / (α * X.HC - 1) := by
    unfold Opp
    rw [div_le_div_iff₀ hHV hγ0]
    have hI0 := X.I_nonneg
    have hpos : 0 ≤ κ / lam + Δ := by linarith [X.IV_nonneg]
    have e1 : X.IV * (α * X.HC - 1) ≤ (κ / lam + Δ) * (α * X.HC - 1) :=
      mul_le_mul_of_nonneg_right (by linarith) hγ0.le
    have e2 : (κ / lam + Δ) * (α * X.HC - 1) ≤ (κ / lam + Δ) * X.HV :=
      mul_le_mul_of_nonneg_left A2 hpos
    linarith
  calc X.Conf * X.Rel D * X.Opp ≤ 1 * (2 * κ / ((lam : ℝ) * (lam - 3)) + (2 : ℝ) ^ (-(lam : ℝ) / 2)) *
        min 1 ((κ / lam + Δ) / (α * X.HC - 1)) :=
        mul_le_mul (mul_le_mul hC1 hR hR0 zero_le_one) (le_min hO1 hO2) hO0
          (by rw [one_mul]; exact le_trans hR0 hR)
    _ = _ := by ring

/-- **Théorème 2.4, dernière phrase.** Sous l'Hypothèse 2.3 (et les supports
    communs) et le régime, Conf ≥ 1 − √(c₀βκ/λ). -/
theorem conf_regime_concrete (β κ : ℝ) (hβ : 1 ≤ β) (D : C → S → M) (hs : X.CommonSupport)
    (A3 : X.KLmax ≤ β * X.I) (A4 : X.I ≤ κ / lam) :
    1 - Real.sqrt (c0 * β * (κ / lam)) ≤ X.Conf :=
  le_trans (conf_guarantee_antitone (by linarith) A4).1 (lemma4_concrete X β hβ D hs A3)

end CLOModel

/-- **Théorème 2.4, dernière phrase, modèle abstrait.** -/
theorem conf_regime {lam : ℕ} (P : ProtocolInstance lam) (κ : ℝ)
    (A3 : P.KLmax ≤ P.params.β * P.I) (A4 : P.I ≤ κ / lam) :
    1 - Real.sqrt (c0 * P.params.β * (κ / lam)) ≤ P.Conf :=
  le_trans (conf_guarantee_antitone (by linarith [P.params.hβ_ge_one]) A4).1
    (lemma4_confidentiality_guarantee P A3)

end ConditionalCRO

namespace ConditionalCRO

/-! ### 16.4 Corollaire 2.1, Remarques 2.24 et 5.5 -/

/-- **Corollaire 2.1 (forme simplifiée).** Pour Δ > 0, le rapport du majorant
    Δ/λ + K/λ² à Δ/λ tend vers 1. Pour κ = 1, Δ = 5 et λ = 128, K = κ(Δ+1) + κ² = 7 et
    ce rapport vaut 1 + 7/640, entre 1,010 et 1,011. -/
theorem forme_simplifiee (Δ K : ℝ) (hΔ : 0 < Δ) :
    Tendsto (fun lam : ℕ => (Δ / lam + K / (lam : ℝ) ^ 2) / (Δ / lam)) atTop (nhds 1) ∧
      ((5 : ℝ) / 128 + 7 / 128 ^ 2) / (5 / 128) = 1 + 7 / 640 ∧
      (1.010 : ℝ) < 1 + 7 / 640 ∧ (1 : ℝ) + 7 / 640 < 1.011 := by
  refine ⟨forme_simplifiee_pq Δ K hΔ, by norm_num, by norm_num, by norm_num⟩

/-- **Remarque 2.24 (portée des études de cas).** Pour κ = 1 et λ = 128,
    (1 + κ/λ)/λ = 129/128² < 0,008. Une preuve qui contient le message (signature
    ECDSA, I(M;Σ|C) = λ) sort du régime dès que λ² > κ. -/
theorem portee_cas_etude :
    ((1 : ℝ) + 1 / 128) / 128 = 129 / 128 ^ 2 ∧ (129 : ℝ) / 128 ^ 2 < 0.008 ∧
      ∀ lam κ : ℝ, 0 < lam → (κ / lam < lam ↔ κ < lam ^ 2) := by
  refine ⟨by norm_num, by norm_num, fun lam κ hl => ?_⟩
  rw [div_lt_iff₀ hl]
  constructor <;> intro h <;> nlinarith

/-- Lemme entier : n⁴ ≤ 2ⁿ pour n ≥ 16. -/
lemma pow_four_le_two_pow (n : ℕ) (hn : 16 ≤ n) : (n : ℝ) ^ 4 ≤ 2 ^ n := by
  induction n, hn using Nat.le_induction with
  | base => norm_num
  | succ k hk ih =>
    have hk' : (16 : ℝ) ≤ k := by exact_mod_cast hk
    have h0 : (0 : ℝ) ≤ k := by linarith
    have step : ((k : ℝ) + 1) ^ 4 ≤ 2 * (k : ℝ) ^ 4 := by
      have e : 2 * (k : ℝ) ^ 4 - ((k : ℝ) + 1) ^ 4 =
          (k : ℝ) ^ 3 * ((k : ℝ) - 16) + 12 * (k : ℝ) ^ 3 - 6 * (k : ℝ) ^ 2 - 4 * k - 1 := by ring
      have h3 : 0 ≤ (k : ℝ) ^ 3 * ((k : ℝ) - 16) := mul_nonneg (by positivity) (by linarith)
      have h4 : 6 * (k : ℝ) ^ 2 + 4 * k + 1 ≤ 12 * (k : ℝ) ^ 3 := by nlinarith
      linarith
    calc ((↑(k + 1) : ℝ)) ^ 4 = ((k : ℝ) + 1) ^ 4 := by push_cast; ring
      _ ≤ 2 * (k : ℝ) ^ 4 := step
      _ ≤ 2 * 2 ^ k := by linarith
      _ = 2 ^ (k + 1) := by ring

/-- **Remarque 5.5 (statut d'une borne forte).** Le terme dominant Δ/(γλ) de la forme
    explicite est d'ordre exactement λ⁻¹ (λ·Δ/(γλ) = Δ/γ). La borne aiguë de la
    Proposition 2.2 est d'ordre λ⁻² : pour λ ≥ 16, 2κ/(λ(λ−3)) + 2^(−λ/2) ≤ (4κ + 1)/λ². -/
theorem borne_forte_statut (Δ γ κ : ℝ) (hκ : 0 ≤ κ) :
    (∀ lam : ℝ, 0 < lam → lam * (Δ / (γ * lam)) = Δ / γ) ∧
      ∀ n : ℕ, 16 ≤ n →
        2 * κ / ((n : ℝ) * (n - 3)) + (2 : ℝ) ^ (-(n : ℝ) / 2) ≤ (4 * κ + 1) / (n : ℝ) ^ 2 := by
  refine ⟨fun lam hl => by field_simp, fun n hn => ?_⟩
  have hn' : (16 : ℝ) ≤ n := by exact_mod_cast hn
  have hn0 : (0 : ℝ) < n := by linarith
  -- premier terme : λ(λ − 3) ≥ λ²/2 pour λ ≥ 6
  have h1 : 2 * κ / ((n : ℝ) * (n - 3)) ≤ 4 * κ / (n : ℝ) ^ 2 := by
    rw [div_le_div_iff₀ (by nlinarith) (by positivity)]
    nlinarith [mul_nonneg hκ (by nlinarith : (0 : ℝ) ≤ (n : ℝ) ^ 2 - 6 * n)]
  -- second terme : (n²·2^(−n/2))² = n⁴·2^(−n) ≤ 1
  have hT : 0 < (2 : ℝ) ^ (-(n : ℝ) / 2) := Real.rpow_pos_of_pos (by norm_num) _
  have hsq : ((2 : ℝ) ^ (-(n : ℝ) / 2)) ^ 2 * (2 : ℝ) ^ n = 1 := by
    rw [← Real.rpow_natCast ((2 : ℝ) ^ (-(n : ℝ) / 2)) 2, ← Real.rpow_mul (by norm_num),
      ← Real.rpow_natCast (2 : ℝ) n, ← Real.rpow_add (by norm_num)]
    norm_num
  have h4 := pow_four_le_two_pow n hn
  have h2 : (2 : ℝ) ^ (-(n : ℝ) / 2) ≤ 1 / (n : ℝ) ^ 2 := by
    rw [le_div_iff₀ (by positivity)]
    have hx : ((2 : ℝ) ^ (-(n : ℝ) / 2) * (n : ℝ) ^ 2) ^ 2 ≤ 1 := by
      have : ((2 : ℝ) ^ (-(n : ℝ) / 2) * (n : ℝ) ^ 2) ^ 2 =
          ((2 : ℝ) ^ (-(n : ℝ) / 2)) ^ 2 * (n : ℝ) ^ 4 := by ring
      rw [this]
      calc ((2 : ℝ) ^ (-(n : ℝ) / 2)) ^ 2 * (n : ℝ) ^ 4
          ≤ ((2 : ℝ) ^ (-(n : ℝ) / 2)) ^ 2 * (2 : ℝ) ^ n :=
            mul_le_mul_of_nonneg_left h4 (by positivity)
        _ = 1 := hsq
    nlinarith [sq_nonneg ((2 : ℝ) ^ (-(n : ℝ) / 2) * (n : ℝ) ^ 2 - 1),
      mul_pos hT (by positivity : (0 : ℝ) < (n : ℝ) ^ 2)]
  calc 2 * κ / ((n : ℝ) * (n - 3)) + (2 : ℝ) ^ (-(n : ℝ) / 2)
      ≤ 4 * κ / (n : ℝ) ^ 2 + 1 / (n : ℝ) ^ 2 := add_le_add h1 h2
    _ = (4 * κ + 1) / (n : ℝ) ^ 2 := by ring

/-! ### 16.5 Borne aiguë dans le cadre quantique (Remarque 2.40) -/

/-- Instance quantique munie de la minoration fine de l'information accessible :
    l'issue d'une mesure est classique et les étapes 1 à 3 de la Proposition 2.2 lui
    s'appliquent (preuve de la Remarque 2.40). -/
structure QuantumSharpInstance (lam : ℕ) extends QuantumProtocolInstance lam where
  fano_sharp_q : Rel * lam * Real.log 2 + Rel * Real.log Rel - Rel ≤ Iacc * Real.log 2

/-- **Remarque 2.40.** Sous le régime χmax ≤ κ/λ et λ ≥ 4,
    Rel^q ≤ 2κ/(λ(λ−3)) + 2^(−λ/2), et le produit est majoré par cette quantité
    multipliée par min{1, (κ/λ + Δ_q)/γ_q}. -/
theorem trilemma_aigu_q {lam : ℕ} (P : QuantumSharpInstance lam)
    (hA : QuantumAssumptions P.toQuantumProtocolInstance) (κ : ℝ) (hκ : 0 ≤ κ)
    (hlam : 4 ≤ lam) (A8 : P.χmax ≤ κ / lam) (hIVHV : P.IV ≤ P.HV) :
    P.Rel ≤ 2 * κ / ((lam : ℝ) * (lam - 3)) + (2 : ℝ) ^ (-(lam : ℝ) / 2) ∧
      P.Conf * P.Rel * P.Opp ≤ (2 * κ / ((lam : ℝ) * (lam - 3)) + (2 : ℝ) ^ (-(lam : ℝ) / 2)) *
        min 1 ((κ / lam + P.params.Δq) / gammaQ P.params) := by
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hx : P.Iacc ≤ κ / lam := P.holevo.trans (P.moyenne_le_max.trans A8)
  have hR : P.Rel ≤ 2 * κ / ((lam : ℝ) * (lam - 3)) + (2 : ℝ) ^ (-(lam : ℝ) / 2) := by
    refine rel_aigu_of_info P.hRel.1 (by exact_mod_cast hlam) hκ ?_
    have := mul_le_mul_of_nonneg_right hx hl2.le
    linarith [P.fano_sharp_q]
  refine ⟨hR, ?_⟩
  have hγ0 : 0 < gammaQ P.params := by linarith [hA.A6γ]
  have hHV : 0 < P.HV := by linarith [hA.A6, hA.A6γ]
  have hC1 : P.Conf ≤ 1 := by rw [P.hConf]; linarith [P.hTD.1]
  have hR0 := P.hRel.1
  have hO0 : 0 ≤ P.Opp := by rw [P.hOpp]; exact div_nonneg P.hIV hHV.le
  have hO1 : P.Opp ≤ 1 := by rw [P.hOpp, div_le_one hHV]; exact hIVHV
  have hI := P.moyenne_le_max.trans A8
  have hO2 : P.Opp ≤ (κ / lam + P.params.Δq) / gammaQ P.params := by
    rw [P.hOpp, div_le_div_iff₀ hHV hγ0]
    have hpos : 0 ≤ κ / lam + P.params.Δq := by linarith [P.hIV, hA.A5, P.hI]
    have e1 : P.IV * gammaQ P.params ≤ (κ / lam + P.params.Δq) * gammaQ P.params :=
      mul_le_mul_of_nonneg_right (by linarith [hA.A5]) hγ0.le
    have e2 := mul_le_mul_of_nonneg_left hA.A6 hpos
    linarith
  calc P.Conf * P.Rel * P.Opp ≤ 1 * (2 * κ / ((lam : ℝ) * (lam - 3)) + (2 : ℝ) ^ (-(lam : ℝ) / 2)) *
        min 1 ((κ / lam + P.params.Δq) / gammaQ P.params) :=
        mul_le_mul (mul_le_mul hC1 hR hR0 zero_le_one) (le_min hO1 hO2) hO0
          (by rw [one_mul]; exact le_trans hR0 hR)
    _ = _ := by ring

end ConditionalCRO

namespace ConditionalCRO

/-! ### 16.6 Témoin réalisable du facteur institutionnel (Remarque 2.20)

M uniforme sur {0,1}^λ, C uniforme sur γ + 1 bits, Σ = B uniforme sur Δ bits et
indépendant de (M, C), V = (B, K) avec K uniforme sur γ − Δ bits. La composante
g^M h^R de la preuve du manuscrit, uniforme et indépendante de M, ne change aucune des
grandeurs CLO ; elle est omise. -/

/-- Somme d'une indicatrice sur la première composante d'un couple. -/
lemma sum_pair_ite {A B : Type*} [Fintype A] [Fintype B] [DecidableEq A] (s : A) (f : ℝ) :
    ∑ v : A × B, (if v.1 = s then f else 0) = (Fintype.card B : ℝ) * f := by
  rw [Fintype.sum_prod_type]
  have h : ∀ b : A, (∑ k : B, if (b, k).1 = s then f else 0) =
      if b = s then (Fintype.card B : ℝ) * f else 0 := by
    intro b
    by_cases hb : b = s <;> simp [hb]
  simp only [h]
  rw [Finset.sum_ite_eq']
  simp

/-- La loi témoin, pour des entiers l = λ, d = Δ et g = γ. -/
noncomputable def witModel (l d g : ℕ) :
    CLOModel l (Fin (2 ^ l)) (Fin (2 ^ (g + 1))) (Fin (2 ^ d)) (Fin (2 ^ d) × Fin (2 ^ (g - d))) where
  P := fun _ _ _ => 1 / ((2 : ℝ) ^ (g + 1) * 2 ^ l * 2 ^ d)
  P_nonneg := fun _ _ _ => by positivity
  P_sum := by
    simp only [sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
    push_cast
    field_simp
  card_M := by simp
  unif := fun _ _ => by
    simp only [sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
    push_cast
    field_simp
  ker := fun _ s v => if v.1 = s then 1 / (2 : ℝ) ^ (g - d) else 0
  ker_nonneg := fun _ _ _ => by split_ifs <;> positivity
  ker_sum := fun _ s => by
    rw [sum_pair_ite, Fintype.card_fin]
    push_cast
    field_simp

namespace CLOModel

variable (l d g : ℕ)

lemma wit_pC (c : Fin (2 ^ (g + 1))) : (witModel l d g).pC c = 1 / (2 : ℝ) ^ (g + 1) := by
  simp only [pC, witModel, sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
  push_cast
  field_simp

lemma wit_qMS (c : Fin (2 ^ (g + 1))) (m : Fin (2 ^ l)) (s : Fin (2 ^ d)) :
    (witModel l d g).qMS c m s = 1 / ((2 : ℝ) ^ l * 2 ^ d) := by
  rw [qMS, wit_pC]
  simp only [witModel]
  field_simp

lemma wit_colS (c : Fin (2 ^ (g + 1))) (s : Fin (2 ^ d)) :
    ∑ m, (witModel l d g).qMS c m s = 1 / (2 : ℝ) ^ d := by
  simp only [wit_qMS, sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
  push_cast
  field_simp

lemma wit_rowM (c : Fin (2 ^ (g + 1))) (m : Fin (2 ^ l)) :
    ∑ s, (witModel l d g).qMS c m s = 1 / (2 : ℝ) ^ l := by
  simp only [wit_qMS, sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
  push_cast
  field_simp

lemma wit_qSV (c : Fin (2 ^ (g + 1))) (s : Fin (2 ^ d)) (v : Fin (2 ^ d) × Fin (2 ^ (g - d))) :
    (witModel l d g).qSV c s v = if v.1 = s then 1 / ((2 : ℝ) ^ d * 2 ^ (g - d)) else 0 := by
  rw [qSV, wit_colS]
  change 1 / (2 : ℝ) ^ d * (if v.1 = s then 1 / (2 : ℝ) ^ (g - d) else 0) = _
  split_ifs
  · field_simp
  · simp

lemma wit_I : (witModel l d g).I = 0 := by
  have h : ∀ c, miN ((witModel l d g).qMS c) = 0 := by
    intro c
    unfold miN
    refine sum_eq_zero fun m _ => sum_eq_zero fun s _ => ?_
    rw [wit_rowM, wit_colS, wit_qMS]
    rw [show 1 / ((2 : ℝ) ^ l * 2 ^ d) / (1 / 2 ^ l * (1 / 2 ^ d)) = 1 by field_simp]
    simp
  simp [I, h]

lemma wit_HC : (witModel l d g).HC = g + 1 := by
  have hl2 : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  simp only [HC, wit_pC, sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
  rw [one_div, Real.log_inv, Real.log_pow]
  push_cast
  field_simp

/-- Les lois de Σ ne dépendent pas du message : TV = 0, d'où Conf = 1. -/
lemma wit_qS (c : Fin (2 ^ (g + 1))) (m : Fin (2 ^ l)) (s : Fin (2 ^ d)) :
    (witModel l d g).qS c m s = 1 / (2 : ℝ) ^ d := by
  simp only [qS, witModel, sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
  push_cast
  field_simp

lemma wit_Conf : (witModel l d g).Conf = 1 := by
  have hTV : ∀ x, (witModel l d g).TV x = 0 := by
    intro x
    simp [TV, tv, wit_qS]
  have h0 : (witModel l d g).TVmax = 0 :=
    le_antisymm (Finset.sup'_le _ _ fun x _ => (hTV x).le) (TVmax_nonneg _)
  simp [Conf, h0]

lemma wit_KLmax : (witModel l d g).KLmax = 0 := by
  have hKL : ∀ x, (witModel l d g).KL x = 0 := by
    intro x
    simp only [KL, klN, wit_qS]
    rw [div_self (by positivity), Real.log_one]
    simp
  apply le_antisymm (Finset.sup'_le _ _ fun x _ => (hKL x).le)
  obtain ⟨x, hx⟩ := (univ_nonempty (α := Fin (2 ^ (g + 1)) × Fin (2 ^ l) × Fin (2 ^ l)))
  exact (hKL x).ge.trans (Finset.le_sup' _ hx)

/-- Masse des verdicts : chaque v a probabilité 1/(2^Δ·2^(γ−Δ)) sachant C. -/
lemma wit_colV (c : Fin (2 ^ (g + 1))) (v : Fin (2 ^ d) × Fin (2 ^ (g - d))) :
    ∑ s, (witModel l d g).qSV c s v = 1 / ((2 : ℝ) ^ d * 2 ^ (g - d)) := by
  simp only [wit_qSV]
  rw [Finset.sum_ite_eq]
  simp

lemma wit_rowS (c : Fin (2 ^ (g + 1))) (s : Fin (2 ^ d)) :
    ∑ v, (witModel l d g).qSV c s v = 1 / (2 : ℝ) ^ d := by
  simp only [wit_qSV]
  rw [sum_pair_ite, Fintype.card_fin]
  push_cast
  field_simp

lemma wit_IV : (witModel l d g).IV = d := by
  have hl2 : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  have h : ∀ c, miN ((witModel l d g).qSV c) = d * Real.log 2 := by
    intro c
    unfold miN
    have term : ∀ s v, (witModel l d g).qSV c s v *
        Real.log ((witModel l d g).qSV c s v /
          ((∑ v', (witModel l d g).qSV c s v') * ∑ s', (witModel l d g).qSV c s' v)) =
        (witModel l d g).qSV c s v * (d * Real.log 2) := by
      intro s v
      rw [wit_rowS, wit_colV]
      by_cases hv : v.1 = s
      · simp only [wit_qSV, hv, ↓reduceIte]
        congr 1
        rw [show 1 / ((2 : ℝ) ^ d * 2 ^ (g - d)) / (1 / 2 ^ d * (1 / (2 ^ d * 2 ^ (g - d)))) =
            2 ^ d by field_simp, Real.log_pow]
      · simp [wit_qSV, hv]
    simp only [term, ← sum_mul]
    rw [Finset.sum_comm]
    have : ∑ v, ∑ s, (witModel l d g).qSV c s v = 1 := by
      rw [Finset.sum_comm]
      simp only [wit_rowS, sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
      push_cast
      field_simp
    rw [this, one_mul]
  simp only [IV, h, wit_pC, ← sum_mul, sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
  push_cast
  field_simp

lemma wit_HV (hdg : d ≤ g) : (witModel l d g).HV = g := by
  have hl2 : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num)).ne'
  have e : (2 : ℝ) ^ d * 2 ^ (g - d) = 2 ^ g := by rw [← pow_add, Nat.add_sub_cancel' hdg]
  have h : ∀ c, entN2 ((witModel l d g).qSV c) = g * Real.log 2 := by
    intro c
    unfold entN2
    simp only [wit_colV, e, sum_const, card_univ, Fintype.card_prod, Fintype.card_fin, nsmul_eq_mul]
    push_cast
    rw [e, one_div, Real.log_inv, Real.log_pow]
    field_simp
  simp only [HV, h, wit_pC, ← sum_mul, sum_const, card_univ, Fintype.card_fin, nsmul_eq_mul]
  push_cast
  field_simp

end CLOModel

/-- **Remarque 2.20 (témoin réalisable du facteur institutionnel).** Pour tous entiers
    Δ ≤ γ avec γ ≥ 1 et tout λ, la loi `witModel λ Δ γ` satisfait les Hypothèses 2.1 à
    2.4 avec α = 1, β = 1 et κ = 0 ; elle vérifie Conf = 1 et Opp = Δ/γ, et
    l'extraction bornée y est une égalité. -/
theorem temoin_realisable (l d g : ℕ) (hdg : d ≤ g) (hg : 1 ≤ g) :
    (Fintype.card (Fin (2 ^ d) × Fin (2 ^ (g - d))) : ℝ) ≤ (2 : ℝ) ^ (1 * (witModel l d g).HC) ∧
      (witModel l d g).IV = (witModel l d g).I + d ∧
      1 * (witModel l d g).HC - 1 ≤ (witModel l d g).HV ∧
      1 ≤ 1 * (witModel l d g).HC - 1 ∧
      (witModel l d g).KLmax ≤ 1 * (witModel l d g).I ∧
      (witModel l d g).I ≤ 0 / l ∧
      (witModel l d g).Conf = 1 ∧
      (witModel l d g).Opp = d / g := by
  rw [CLOModel.wit_HC, CLOModel.wit_I, CLOModel.wit_IV, CLOModel.wit_HV l d g hdg,
    CLOModel.wit_KLmax, CLOModel.wit_Conf]
  have hg' : (1 : ℝ) ≤ g := by exact_mod_cast hg
  refine ⟨?_, by ring, by linarith, by linarith, by norm_num, by simp, rfl, ?_⟩
  · simp only [Fintype.card_prod, Fintype.card_fin, one_mul]
    push_cast
    rw [← pow_add, Nat.add_sub_cancel' hdg, show ((g : ℝ) + 1) = ((g + 1 : ℕ) : ℝ) by push_cast; ring,
      Real.rpow_natCast]
    exact pow_le_pow_right₀ (by norm_num) (by omega)
  · simp [CLOModel.Opp, CLOModel.wit_IV, CLOModel.wit_HV l d g hdg]

end ConditionalCRO

end ExtensionL2

/-! ## 17. Bloc de vérification des bornes avancées (version 3.7) -/

#print axioms ConditionalCRO.log_sum_two_blocks
#print axioms ConditionalCRO.CLOModel.fano_sharp_model
#print axioms ConditionalCRO.rel_aigu_of_info
#print axioms ConditionalCRO.CLOModel.rel_aigu
#print axioms ConditionalCRO.CLOModel.trilemma_aigu_concrete
#print axioms ConditionalCRO.CLOModel.conf_regime_concrete
#print axioms ConditionalCRO.conf_regime
#print axioms ConditionalCRO.forme_simplifiee
#print axioms ConditionalCRO.portee_cas_etude
#print axioms ConditionalCRO.pow_four_le_two_pow
#print axioms ConditionalCRO.borne_forte_statut
#print axioms ConditionalCRO.trilemma_aigu_q
#print axioms ConditionalCRO.temoin_realisable
