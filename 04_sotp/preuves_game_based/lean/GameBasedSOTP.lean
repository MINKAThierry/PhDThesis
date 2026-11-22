/-
  Preuves game-based de SOTP-Low en situation réduite — Annexe de thèse
  =====================================================================
  Version 1.0 (22 novembre 2026).

  OBJET
  Test de faisabilité de la mécanisation des preuves game-based de l'annexe A,
  sur une version réduite de SOTP-Low. Le fichier n'utilise que Mathlib et se
  vérifie sur https://live.lean-lang.org (projet Mathlib). Vérifié le 22 novembre
  2026 sur ce site et localement (Lean 4.35.0, Mathlib v4.35.0) : aucune erreur,
  aucun avertissement, six `#print axioms` limités à propext, Classical.choice et
  Quot.sound.

  CE QUI EST CERTIFIÉ
  1. Masque jetable : la loi de m + y, y uniforme, ne dépend pas de m.
  2. Confidentialité (couche Gold) : pour tout adversaire A contre IND-CONF, le
     réducteur B construit à partir de A vérifie Adv^IND-CONF(A) = Adv^PRG(B).
     La graine est tirée uniformément dans un ensemble fini quelconque S, par
     exemple Z_q comme dans l'Algorithme SOTP-Low.
  3. Fiabilité de vérification (couches Gold et Iron) : deux ouvertures acceptées
     d'une même preuve sur deux messages distincts donnent le logarithme discret
     de h en base g. Le réducteur B résout DLOG chaque fois que A gagne BIND-REL,
     d'où Win^BIND-REL(A) ≤ Adv^DLOG(B).

  SITUATION RÉDUITE
  • Les probabilités sont des moyennes sur des ensembles finis (lois uniformes).
  • Les adversaires sont des fonctions ; leur aléa propre est absorbé dans leur
    description, ce qui suffit pour les deux réductions ci-dessus.
  • La couche Iron n'est pas modélisée dans le jeu de confidentialité (son
    masquage parfait est le terme 1/q de l'annexe), la couche Clay n'est pas
    modélisée (fonction publique du contexte).
  • PRG et DLOG ne sont pas des axiomes : ce sont les avantages de B, que le
    théorème relie à ceux de A.
-/

import Mathlib

open Finset

namespace GameBasedSOTP

/-! ## 1. Probabilité uniforme sur un ensemble fini -/

/-- Espérance de `f` sous la loi uniforme sur `X`. -/
noncomputable def avg {X : Type*} [Fintype X] (f : X → ℝ) : ℝ :=
  (∑ x, f x) / Fintype.card X

/-- Indicatrice d'une proposition décidable. -/
def ind (p : Prop) [Decidable p] : ℝ := if p then 1 else 0

lemma avg_add {X : Type*} [Fintype X] (f g : X → ℝ) :
    avg (fun x => f x + g x) = avg f + avg g := by
  unfold avg; rw [sum_add_distrib, add_div]

lemma avg_const {X : Type*} [Fintype X] [Nonempty X] (c : ℝ) :
    avg (fun _ : X => c) = c := by
  unfold avg
  have h : (Fintype.card X : ℝ) ≠ 0 := by exact_mod_cast Fintype.card_ne_zero
  rw [sum_const, card_univ, nsmul_eq_mul]; field_simp

/-- On peut échanger l'ordre de deux tirages uniformes indépendants. -/
lemma avg_comm {X Y : Type*} [Fintype X] [Fintype Y] (f : X → Y → ℝ) :
    avg (fun x => avg (fun y => f x y)) = avg (fun y => avg (fun x => f x y)) := by
  unfold avg
  simp only [← Finset.sum_div, div_div]
  rw [Finset.sum_comm, mul_comm]

lemma avg_mono {X : Type*} [Fintype X] {f g : X → ℝ} (h : ∀ x, f x ≤ g x) :
    avg f ≤ avg g := by
  unfold avg
  apply div_le_div_of_nonneg_right (sum_le_sum fun x _ => h x) (Nat.cast_nonneg _)

/-! ## 2. Masque jetable -/

/-- **Masque jetable.** Pour tout groupe abélien fini M et tout message m, la loi de
    m + y, avec y uniforme, est la loi uniforme : pour toute statistique f,
    E_y[f(m + y)] = E_y[f(y)]. -/
theorem otp_uniform {M : Type*} [AddCommGroup M] [Fintype M] (m : M) (f : M → ℝ) :
    avg (fun y => f (m + y)) = avg f := by
  unfold avg
  congr 1
  exact Fintype.sum_equiv (Equiv.addLeft m) _ _ (fun _ => rfl)

/-! ## 3. Confidentialité de la couche Gold, réduction au PRG

Jeu IND-CONF réduit. Le challenger tire b uniforme dans Bool et la graine s
uniforme dans S, puis envoie σ₁ = m_b + G(s). L'adversaire A rend une estimation de b.
Avantage : |Pr[A(σ₁) = b] − 1/2|.

Jeu PRG. Le distingueur reçoit y = G(s), s uniforme dans S, ou y uniforme dans M.
Avantage : |Pr[B(G(s)) = 1] − Pr[B(y) = 1]|. -/

variable {S M : Type*} [Fintype S] [AddCommGroup M] [Fintype M]

/-- Probabilité de succès de A dans IND-CONF. -/
noncomputable def winIND (G : S → M) (m : Bool → M) (A : M → Bool) : ℝ :=
  avg (fun b : Bool => avg (fun s : S => ind (A (m b + G s) = b)))

/-- Avantage de A dans IND-CONF. -/
noncomputable def advIND (G : S → M) (m : Bool → M) (A : M → Bool) : ℝ :=
  |winIND G m A - 1 / 2|

/-- Réducteur B : sur le défi y, il tire b, envoie m_b + y à A et rend 1 si A trouve b.
    `accB y` est sa probabilité de rendre 1. -/
noncomputable def accB (m : Bool → M) (A : M → Bool) (y : M) : ℝ :=
  avg (fun b : Bool => ind (A (m b + y) = b))

/-- Avantage de B dans le jeu PRG. -/
noncomputable def advPRG (G : S → M) (m : Bool → M) (A : M → Bool) : ℝ :=
  |avg (fun s : S => accB m A (G s)) - avg (fun y : M => accB m A y)|

/-- Sur un défi uniforme, B rend 1 avec probabilité 1/2 (masque jetable). -/
lemma accB_uniform (m : Bool → M) (A : M → Bool) :
    avg (fun y : M => accB m A y) = 1 / 2 := by
  have hsw : avg (fun y : M => accB m A y)
      = avg (fun b : Bool => avg (fun y : M => ind (A (m b + y) = b))) := by
    unfold accB; exact avg_comm _
  rw [hsw]
  have hotp : ∀ b : Bool, avg (fun y : M => ind (A (m b + y) = b))
      = avg (fun y : M => ind (A y = b)) :=
    fun b => otp_uniform (m b) (fun z => ind (A z = b))
  simp only [hotp]
  have hpart : ∀ y : M, ind (A y = false) + ind (A y = true) = 1 := by
    intro y; unfold ind; cases A y <;> simp
  have h1 : avg (fun y : M => ind (A y = false)) + avg (fun y : M => ind (A y = true))
      = 1 := by
    rw [← avg_add]; simp only [hpart]
    have : Nonempty M := ⟨0⟩
    exact avg_const 1
  unfold avg at h1 ⊢
  simp only [Fintype.univ_bool, mem_singleton, Bool.true_eq_false, not_false_eq_true,
    sum_insert, sum_singleton, Fintype.card_bool, Nat.cast_ofNat]
  linarith

/-- **Théorème (réduction de la confidentialité de SOTP-Low au PRG).** Pour tout
    adversaire A contre IND-CONF, le réducteur B construit à partir de A a exactement
    le même avantage dans le jeu PRG : Adv^IND-CONF(A) = Adv^PRG(B). En particulier,
    si G est un PRG sûr, la couche Gold est IND-CONF. -/
theorem ind_conf_eq_prg (G : S → M) (m : Bool → M) (A : M → Bool) :
    advIND G m A = advPRG G m A := by
  unfold advIND advPRG
  rw [accB_uniform]
  congr 2
  unfold winIND accB
  exact avg_comm _

/-- Si le défi PRG est remplacé par un masque uniforme, l'avantage IND-CONF est nul :
    confidentialité parfaite du masque jetable. -/
theorem ind_conf_perfect_otp (m : Bool → M) (A : M → Bool) :
    |avg (fun b : Bool => avg (fun y : M => ind (A (m b + y) = b))) - 1 / 2| = 0 := by
  have h := accB_uniform m A
  unfold accB at h
  rw [avg_comm] at h
  rw [h]; simp

/-! ## 4. Fiabilité de vérification, réduction au logarithme discret

Groupe G engendré par g d'ordre premier q. Engagement de Pedersen
Com(s, ρ) = g^s · h^ρ avec h = g^x. Une ouverture de la preuve (σ₁, σ₂) est un triplet
(m, s, ρ) avec σ₁ = m + PRG(s) et σ₂ = Com(s, ρ). -/

section DLog

variable {q : ℕ} [Fact q.Prime] {Γ : Type*} [Group Γ]

/-- Puissance indexée par ZMod q. -/
def zpowq (g : Γ) (a : ZMod q) : Γ := g ^ a.val

/-- Engagement de Pedersen, h = g^x. -/
def com (g : Γ) (x s ρ : ZMod q) : Γ := zpowq g s * (zpowq g x) ^ ρ.val

lemma zpowq_natCast (g : Γ) (hg : orderOf g = q) (n : ℕ) :
    zpowq g (n : ZMod q) = g ^ n := by
  unfold zpowq
  rw [ZMod.val_natCast, ← hg, pow_mod_orderOf]

/-- L'engagement s'écrit g^(s + x·ρ). -/
lemma com_eq (g : Γ) (hg : orderOf g = q) (x s ρ : ZMod q) :
    com g x s ρ = zpowq g (s + x * ρ) := by
  have e : s + x * ρ = ((s.val + x.val * ρ.val : ℕ) : ZMod q) := by
    push_cast; simp
  rw [e, zpowq_natCast g hg]
  unfold com zpowq
  rw [← pow_mul, ← pow_add]

/-- g^a = g^b dans ZMod q implique a = b (g d'ordre q). -/
lemma zpowq_inj (g : Γ) (hg : orderOf g = q) {a b : ZMod q}
    (h : zpowq g a = zpowq g b) : a = b := by
  unfold zpowq at h
  rw [pow_eq_pow_iff_modEq, hg] at h
  apply ZMod.val_injective
  exact Nat.ModEq.eq_of_lt_of_lt h (ZMod.val_lt a) (ZMod.val_lt b)

/-- **Extraction du logarithme discret.** Deux ouvertures (s₀, ρ₀) ≠ (s₁, ρ₁) d'un même
    engagement, avec s₀ ≠ s₁, donnent ρ₀ ≠ ρ₁ et x = (s₀ − s₁)/(ρ₁ − ρ₀). -/
theorem pedersen_extract (g : Γ) (hg : orderOf g = q) {x s₀ ρ₀ s₁ ρ₁ : ZMod q}
    (hcol : com g x s₀ ρ₀ = com g x s₁ ρ₁) (hs : s₀ ≠ s₁) :
    ρ₀ ≠ ρ₁ ∧ x = (s₀ - s₁) / (ρ₁ - ρ₀) := by
  rw [com_eq g hg, com_eq g hg] at hcol
  have e := zpowq_inj g hg hcol
  have hρ : ρ₀ ≠ ρ₁ := by
    intro h; apply hs; rw [h] at e; linear_combination e
  refine ⟨hρ, ?_⟩
  have hd : ρ₁ - ρ₀ ≠ 0 := sub_ne_zero.mpr (Ne.symm hρ)
  rw [eq_div_iff hd]
  linear_combination -e

variable {S M : Type*} [AddCommGroup M]

/-- Une ouverture : message, graine, aléa de l'engagement. -/
structure Opening (S M : Type*) (q : ℕ) where
  m : M
  s : S
  ρ : ZMod q

/-- Ouverture acceptée de la preuve (σ₁, σ₂) pour la graine dans ZMod q. -/
def accepts (g : Γ) (x : ZMod q) (PRG : ZMod q → M) (σ₁ : M) (σ₂ : Γ)
    (o : Opening (ZMod q) M q) : Prop :=
  σ₁ = o.m + PRG o.s ∧ σ₂ = com g x o.s o.ρ

/-- Victoire dans BIND-REL : deux ouvertures acceptées sur des messages distincts. -/
def winsBIND (g : Γ) (x : ZMod q) (PRG : ZMod q → M) (σ₁ : M) (σ₂ : Γ)
    (o₀ o₁ : Opening (ZMod q) M q) : Prop :=
  accepts g x PRG σ₁ σ₂ o₀ ∧ accepts g x PRG σ₁ σ₂ o₁ ∧ o₀.m ≠ o₁.m

/-- Le réducteur DLOG : il calcule (s₀ − s₁)/(ρ₁ − ρ₀) à partir des deux ouvertures. -/
def extract (o₀ o₁ : Opening (ZMod q) M q) : ZMod q :=
  (o₀.s - o₁.s) / (o₁.ρ - o₀.ρ)

/-- **Théorème (réduction de la fiabilité de vérification de SOTP-Low au DLOG).**
    Si A gagne BIND-REL, le réducteur rend exactement le logarithme discret x de h.
    Les messages distincts forcent des graines distinctes, condition qui exige la
    graine dans ZMod q. -/
theorem bind_rel_gives_dlog (g : Γ) (hg : orderOf g = q) (x : ZMod q)
    (PRG : ZMod q → M) (σ₁ : M) (σ₂ : Γ) (o₀ o₁ : Opening (ZMod q) M q)
    (hw : winsBIND g x PRG σ₁ σ₂ o₀ o₁) : extract o₀ o₁ = x := by
  obtain ⟨⟨h₀, c₀⟩, ⟨h₁, c₁⟩, hm⟩ := hw
  have hs : o₀.s ≠ o₁.s := by
    intro h; apply hm
    have : o₀.m + PRG o₀.s = o₁.m + PRG o₁.s := h₀.symm.trans h₁
    rw [h] at this; exact add_right_cancel this
  exact ((pedersen_extract g hg (c₀.symm.trans c₁) hs).2).symm

/-- **Corollaire probabiliste.** Pour tout adversaire A qui, sur h = g^x, rend une preuve
    et deux ouvertures, la probabilité de victoire dans BIND-REL (x uniforme) est au plus
    la probabilité de succès du réducteur contre DLOG : Win^BIND-REL(A) ≤ Adv^DLOG(B). -/
theorem win_bind_le_dlog (g : Γ) (hg : orderOf g = q) (PRG : ZMod q → M)
    (A : Γ → M × Γ × Opening (ZMod q) M q × Opening (ZMod q) M q)
    [∀ x, Decidable (winsBIND g x PRG (A (zpowq g x)).1 (A (zpowq g x)).2.1
      (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2)] :
    avg (fun x : ZMod q => ind (winsBIND g x PRG (A (zpowq g x)).1 (A (zpowq g x)).2.1
        (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2))
      ≤ avg (fun x : ZMod q =>
          ind (extract (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2 = x)) := by
  apply avg_mono
  intro x
  unfold ind
  split_ifs with h1 h2
  · exact le_rfl
  · exact absurd (bind_rel_gives_dlog g hg x PRG _ _ _ _ h1) h2
  · norm_num
  · exact le_rfl

end DLog

end GameBasedSOTP

/-! ## Bloc de vérification -/

#print axioms GameBasedSOTP.otp_uniform
#print axioms GameBasedSOTP.ind_conf_eq_prg
#print axioms GameBasedSOTP.ind_conf_perfect_otp
#print axioms GameBasedSOTP.pedersen_extract
#print axioms GameBasedSOTP.bind_rel_gives_dlog
#print axioms GameBasedSOTP.win_bind_le_dlog
