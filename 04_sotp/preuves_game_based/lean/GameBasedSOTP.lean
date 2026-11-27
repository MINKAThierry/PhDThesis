/-
  Preuves game-based de SOTP-Low en situation réduite — Annexe de thèse
  =====================================================================
  Version 1.3 (27 novembre 2026), qui reprend la 1.0 sans la modifier.

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

/-! ## Extension de la version 1.2 (27 novembre 2026, lot L4)

Les sections 5 et 6 complètent la mécanisation de SOTP-Low. La section 5 ajoute la
couche Iron au jeu IND-CONF et établit les bornes complètes du Théorème A.5. La
section 6 calcule la distance statistique du masque par troncature (Remarque 3.5). -/

namespace GameBasedSOTP

/-! ## 5. Bornes game-based complètes de SOTP-Low (version 1.2)

Le jeu IND-CONF comprend ici la couche Iron. L'adversaire reçoit σ₁ = m_b + G(s) et
σ₂ = g^s·h^ρ = g^(s + xρ) avec h = g^x (lemme `com_eq`). Comme g^· est injectif sur
ZMod q (lemme `zpowq_inj`), un adversaire qui lit σ₂ est une fonction de l'exposant
e = s + xρ. La clé x, la graine s et l'aléa ρ sont uniformes dans ZMod q. -/

section Complet

variable {q : ℕ} [Fact q.Prime] {M : Type*} [AddCommGroup M] [Fintype M]

/-- Probabilité de succès dans IND-CONF avec la couche Iron. -/
noncomputable def winIND2 (G : ZMod q → M) (m : Bool → M) (A : M → ZMod q → Bool) : ℝ :=
  avg (fun x : ZMod q => avg (fun b : Bool => avg (fun s : ZMod q =>
    avg (fun ρ : ZMod q => ind (A (m b + G s) (s + x * ρ) = b)))))

/-- Avantage dans IND-CONF avec la couche Iron. -/
noncomputable def advIND2 (G : ZMod q → M) (m : Bool → M) (A : M → ZMod q → Bool) : ℝ :=
  |winIND2 G m A - 1 / 2|

/-- Réducteur B : sur le défi y, il tire b et un exposant e uniforme, envoie (m_b + y, e)
    à A et rend 1 si A trouve b. -/
noncomputable def accB2 (m : Bool → M) (A : M → ZMod q → Bool) (y : M) : ℝ :=
  avg (fun b : Bool => avg (fun e : ZMod q => ind (A (m b + y) e = b)))

/-- Avantage de B dans le jeu PRG, graine uniforme dans ZMod q. -/
noncomputable def advPRG2 (G : ZMod q → M) (m : Bool → M) (A : M → ZMod q → Bool) : ℝ :=
  |avg (fun s : ZMod q => accB2 m A (G s)) - avg (fun y : M => accB2 m A y)|

omit [Fact q.Prime] in
lemma ind_nonneg_le_one (p : Prop) [Decidable p] : 0 ≤ ind p ∧ ind p ≤ 1 := by
  unfold ind; split_ifs <;> norm_num

omit [Fact q.Prime] in
lemma avg_bounds {X : Type*} [Fintype X] [Nonempty X] (f : X → ℝ)
    (h : ∀ x, 0 ≤ f x ∧ f x ≤ 1) : 0 ≤ avg f ∧ avg f ≤ 1 := by
  constructor
  · have := avg_mono (f := fun _ : X => (0 : ℝ)) (g := f) (fun x => (h x).1)
    rwa [avg_const] at this
  · have := avg_mono (f := f) (g := fun _ : X => (1 : ℝ)) (fun x => (h x).2)
    rwa [avg_const] at this

/-- Pour h ≠ 1 (x ≠ 0), l'exposant s + xρ est uniforme et indépendant de s. -/
lemma avg_affine (s x : ZMod q) (hx : x ≠ 0) (f : ZMod q → ℝ) :
    avg (fun ρ : ZMod q => f (s + x * ρ)) = avg f := by
  unfold avg
  congr 1
  exact Fintype.sum_equiv ((Equiv.mulLeft₀ x hx).trans (Equiv.addLeft s)) _ _ (fun _ => rfl)

omit [Fact q.Prime] in
lemma avg_bool_ind (z : Bool) : avg (fun b : Bool => ind (z = b)) = 1 / 2 := by
  unfold avg ind; cases z <;> simp

/-- Sur un défi uniforme, B rend 1 avec probabilité 1/2. -/
lemma accB2_uniform (m : Bool → M) (A : M → ZMod q → Bool) :
    avg (fun y : M => accB2 m A y) = 1 / 2 := by
  have h1 : avg (fun y : M => accB2 m A y) =
      avg (fun b : Bool => avg (fun e : ZMod q => avg (fun y : M => ind (A (m b + y) e = b)))) := by
    unfold accB2
    rw [avg_comm]
    congr 1; funext b
    rw [avg_comm]
  rw [h1]
  have h2 : ∀ b e, avg (fun y : M => ind (A (m b + y) e = b)) = avg (fun y : M => ind (A y e = b)) :=
    fun b e => otp_uniform (m b) (fun z => ind (A z e = b))
  simp only [h2]
  rw [avg_comm]
  have h3 : ∀ e : ZMod q, avg (fun b : Bool => avg (fun y : M => ind (A y e = b))) = 1 / 2 := by
    intro e
    rw [avg_comm]
    have : Nonempty M := ⟨0⟩
    simp only [avg_bool_ind]
    exact avg_const _
  simp only [h3]
  have : Nonempty (ZMod q) := ⟨0⟩
  exact avg_const _

/-- **Théorème A.5, (A.17), en situation réduite.** Avec la couche Iron,
    Adv^IND-CONF(A) ≤ Adv^PRG(B) + 1/q. Le terme 1/q est la probabilité de h = 1. -/
theorem ind_conf_complet (G : ZMod q → M) (m : Bool → M) (A : M → ZMod q → Bool) :
    advIND2 G m A ≤ advPRG2 G m A + 1 / q := by
  have hq : (1 : ℝ) < q := by exact_mod_cast (Fact.out : q.Prime).one_lt
  have hcard : (Fintype.card (ZMod q) : ℝ) = q := by rw [ZMod.card]
  have hne : Nonempty (ZMod q) := ⟨0⟩
  set W : ZMod q → ℝ := fun x => avg (fun b : Bool => avg (fun s : ZMod q =>
    avg (fun ρ : ZMod q => ind (A (m b + G s) (s + x * ρ) = b)))) with hW
  set Ws := avg (fun s : ZMod q => accB2 m A (G s)) with hWs
  have hsim : ∀ x, x ≠ 0 → W x = Ws := by
    intro x hx
    simp only [hW, hWs, accB2]
    rw [avg_comm]
    congr 1; funext s; congr 1; funext b
    exact avg_affine s x hx (fun e => ind (A (m b + G s) e = b))
  have hWb : ∀ x, 0 ≤ W x ∧ W x ≤ 1 := fun x =>
    avg_bounds _ fun b => avg_bounds _ fun s => avg_bounds _ fun ρ => ind_nonneg_le_one _
  have hWsb : 0 ≤ Ws ∧ Ws ≤ 1 := avg_bounds _ fun s =>
    avg_bounds _ fun b => avg_bounds _ fun e => ind_nonneg_le_one _
  have hsum : ∑ x, W x = W 0 + ((q : ℝ) - 1) * Ws := by
    rw [← Finset.add_sum_erase _ _ (mem_univ (0 : ZMod q))]
    rw [sum_congr rfl fun x hx => hsim x (ne_of_mem_erase hx), sum_const, card_erase_of_mem
      (mem_univ _), card_univ, nsmul_eq_mul, ZMod.card]
    push_cast [Nat.cast_sub (Fact.out : q.Prime).one_lt.le]
    ring
  have hwin : winIND2 G m A = Ws + (W 0 - Ws) / q := by
    show avg W = _
    unfold avg
    rw [hsum, hcard]
    field_simp
    ring
  have hprg : advPRG2 G m A = |Ws - 1 / 2| := by
    unfold advPRG2; rw [accB2_uniform]
  unfold advIND2
  rw [hwin, hprg]
  have hd : |(W 0 - Ws) / q| ≤ 1 / q := by
    rw [abs_div, abs_of_pos (by linarith : (0 : ℝ) < q)]
    apply div_le_div_of_nonneg_right _ (by linarith)
    rw [abs_le]; constructor <;> linarith [hWb 0, hWsb]
  calc |Ws + (W 0 - Ws) / q - 1 / 2| = |(Ws - 1 / 2) + (W 0 - Ws) / q| := by ring_nf
    _ ≤ |Ws - 1 / 2| + |(W 0 - Ws) / q| := abs_add_le _ _
    _ ≤ |Ws - 1 / 2| + 1 / q := by linarith

end Complet

section DLogComplet

variable {q : ℕ} [Fact q.Prime] {Γ : Type*} [Group Γ] {M : Type*} [AddCommGroup M]

/-- **Théorème A.5, (A.18), en situation réduite.** Win^BIND-REL(A) ≤ Adv^DLOG(B) + 1/q. -/
theorem win_bind_complet (g : Γ) (hg : orderOf g = q) (PRG : ZMod q → M)
    (A : Γ → M × Γ × Opening (ZMod q) M q × Opening (ZMod q) M q)
    [∀ x, Decidable (winsBIND g x PRG (A (zpowq g x)).1 (A (zpowq g x)).2.1
      (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2)] :
    avg (fun x : ZMod q => ind (winsBIND g x PRG (A (zpowq g x)).1 (A (zpowq g x)).2.1
        (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2))
      ≤ avg (fun x : ZMod q =>
          ind (extract (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2 = x)) + 1 / q := by
  have h := win_bind_le_dlog g hg PRG A
  have : (0 : ℝ) ≤ 1 / q := by positivity
  linarith

end DLogComplet

/-! ## 6. Masque par troncature (Remarque 3.5) -/

/-- Nombre de graines s < q telles que s mod N = y, pour q = kN + r et r < N. -/
lemma card_mod_eq (N k r y : ℕ) (hN : 0 < N) (hr : r < N) (hy : y < N) :
    ((range (k * N + r)).filter (fun s => s % N = y)).card = k + if y < r then 1 else 0 := by
  have h := Nat.count_modEq_card_eq_ceil (k * N + r) hN y
  rw [Nat.count_eq_card_filter_range] at h
  have e : (range (k * N + r)).filter (fun s => s ≡ y [MOD N]) =
      (range (k * N + r)).filter (fun s => s % N = y) := by
    apply filter_congr; intro s _; unfold Nat.ModEq; rw [Nat.mod_eq_of_lt hy]
  rw [e, Nat.mod_eq_of_lt hy] at h
  have hNq : (0 : ℚ) < N := by exact_mod_cast hN
  have key : ⌈(((k * N + r : ℕ) : ℚ) - (y : ℚ)) / N⌉ = (k : ℤ) + if y < r then 1 else 0 := by
    have : (((k * N + r : ℕ) : ℚ) - y) / N = ((r : ℚ) - y) / N + (k : ℤ) := by
      push_cast; field_simp; ring
    rw [this, Int.ceil_add_intCast, add_comm]
    congr 1
    split_ifs with hyr
    · rw [Int.ceil_eq_iff]; push_cast
      have h1 : (y : ℚ) < r := by exact_mod_cast hyr
      have h2 : (r : ℚ) < N := by exact_mod_cast hr
      constructor
      · rw [lt_div_iff₀ hNq]; linarith
      · rw [div_le_iff₀ hNq]; linarith
    · rw [Int.ceil_eq_iff]; push_cast
      have h1 : (r : ℚ) ≤ y := by exact_mod_cast (not_lt.mp hyr)
      have h2 : (y : ℚ) < N := by exact_mod_cast hy
      constructor
      · rw [lt_div_iff₀ hNq]; linarith
      · rw [div_le_iff₀ hNq]; linarith
  rw [key] at h
  exact_mod_cast h

/-- Loi de G(s) = s mod N pour s uniforme dans {0, …, q − 1}. -/
noncomputable def truncLaw (q N : ℕ) (y : Fin N) : ℝ :=
  (((range q).filter (fun s => s % N = y.val)).card : ℝ) / q

/-- Distance statistique entre deux lois sur Fin N. -/
noncomputable def distStat {N : ℕ} (P Q : Fin N → ℝ) : ℝ := ∑ y, max (P y - Q y) 0

/-- **Remarque 3.5.** Pour q = kN + r avec r < N, la distance statistique entre s mod N
    (s uniforme modulo q) et la loi uniforme sur N valeurs vaut r(N − r)/(qN). -/
theorem trunc_dist (N k r : ℕ) (hN : 0 < N) (hr : r < N) (hq : 0 < k * N + r) :
    distStat (truncLaw (k * N + r) N) (fun _ => 1 / (N : ℝ)) =
      r * (N - r) / ((k * N + r : ℕ) * N) := by
  set q := k * N + r with hqdef
  have hNr : (0 : ℝ) < N := by exact_mod_cast hN
  have hqr : (0 : ℝ) < q := by exact_mod_cast hq
  have hqv : (q : ℝ) = k * N + r := by rw [hqdef]; push_cast; ring
  have term : ∀ y : Fin N, max (truncLaw q N y - 1 / N) 0 =
      if y.val < r then ((N : ℝ) - r) / (q * N) else 0 := by
    intro y
    unfold truncLaw
    rw [card_mod_eq N k r y.val hN hr y.isLt]
    split_ifs with h
    · rw [max_eq_left]
      · push_cast; field_simp; rw [hqv]; ring
      · push_cast
        rw [sub_nonneg, div_le_div_iff₀ hNr hqr, hqv]
        have : (r : ℝ) < N := by exact_mod_cast hr
        nlinarith
    · rw [max_eq_right]
      push_cast
      rw [sub_nonpos, div_le_div_iff₀ hqr hNr, hqv]
      have : (0 : ℝ) ≤ r := by positivity
      nlinarith
  unfold distStat
  simp only [term]
  rw [Fin.sum_univ_eq_sum_range (fun i => if i < r then ((N : ℝ) - r) / (q * N) else 0) N,
    sum_ite, sum_const_zero, add_zero, sum_const, nsmul_eq_mul]
  have hc : ((range N).filter (fun i => i < r)).card = r := by
    rw [show (range N).filter (fun i => i < r) = range r by
      ext i; simp only [mem_filter, mem_range]; constructor
      · exact fun h => h.2
      · exact fun h => ⟨lt_trans h hr, h⟩]
    exact card_range r
  rw [hc]
  ring

/-- Majoration r(N − r)/(qN) ≤ N/(4q), puis N/(4q) ≤ 1/(2N) dès que N² ≤ 2q, c'est-à-dire
    2^(−λ−1) pour N = 2^λ et |q| ≥ 2λ. -/
theorem trunc_bound (N q r : ℕ) (hN : 0 < N) (hq : 0 < q) :
    (r : ℝ) * (N - r) / (q * N) ≤ N / (4 * q) ∧
      ((N : ℝ) ^ 2 ≤ 2 * q → (N : ℝ) / (4 * q) ≤ 1 / (2 * N)) := by
  have hNr : (0 : ℝ) < N := by exact_mod_cast hN
  have hqr : (0 : ℝ) < q := by exact_mod_cast hq
  constructor
  · rw [div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [sq_nonneg ((N : ℝ) - 2 * r)]
  · intro h
    rw [div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith

/-- **Remarque 3.5, valeurs numériques.** Pour q ≥ 2^252 et λ = 128,
    2^λ/(4q) ≤ 2^(−126), donc 2·2^λ/(4q) ≤ 2^(−125). -/
theorem trunc_ecdsa (q : ℝ) (hq : (2 : ℝ) ^ 252 ≤ q) :
    (2 : ℝ) ^ 128 / (4 * q) ≤ 1 / 2 ^ 126 ∧ 2 * ((2 : ℝ) ^ 128 / (4 * q)) ≤ 1 / 2 ^ 125 := by
  have hq0 : (0 : ℝ) < q := lt_of_lt_of_le (by positivity) hq
  have h1 : (2 : ℝ) ^ 128 / (4 * q) ≤ 1 / 2 ^ 126 := by
    rw [div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith
  refine ⟨h1, ?_⟩
  have : (2 : ℝ) * (1 / 2 ^ 126) = 1 / 2 ^ 125 := by norm_num
  linarith

end GameBasedSOTP

/-! ## Bloc de vérification de la version 1.2 -/

#print axioms GameBasedSOTP.ind_conf_complet
#print axioms GameBasedSOTP.win_bind_complet
#print axioms GameBasedSOTP.card_mod_eq
#print axioms GameBasedSOTP.trunc_dist
#print axioms GameBasedSOTP.trunc_bound
#print axioms GameBasedSOTP.trunc_ecdsa

/-! ## Extension de la version 1.3 (27 novembre 2026, lot L4)

Les sections 7 à 10 traitent SOTP-Base (dimensionnement de Johnson-Lindenstrauss et
réductions), SOTP-High (sécurité héritée de Groth16) et l'énoncé de la Conjecture 3.1. -/

namespace GameBasedSOTP

/-! ## 7. SOTP-Base : dimensionnement de Johnson-Lindenstrauss (Lemme 2.2, Théorème A.3)

Le tirage de la matrice Φ est modélisé par un espace de probabilité fini Ω de loi μ.
Pour chaque paire de contextes p, l'événement `bad p ω` dit que Φ_ω déforme la distance
de la paire de plus d'un facteur 1 ± δ. La queue de Chernoff du χ² (preuve du Lemme 2.2,
d'après Dasgupta et Gupta) est posée comme hypothèse nommée : μ(bad p) ≤ 2·exp(−kδ²/12).
Elle n'est pas démontrée ici, faute de loi gaussienne et de borne de Chernoff du χ² dans
Mathlib sous cette forme. -/

/-- Probabilité d'un événement dans un espace fini de loi μ. -/
noncomputable def prob {Ω : Type*} [Fintype Ω] (μ : Ω → ℝ) (E : Ω → Prop) [DecidablePred E] :
    ℝ :=
  ∑ ω, if E ω then μ ω else 0

/-- Borne de l'union sur un ensemble fini d'événements. -/
theorem union_bound {Ω ι : Type*} [Fintype Ω] (μ : Ω → ℝ) (hμ : ∀ ω, 0 ≤ μ ω)
    (P : Finset ι) (bad : ι → Ω → Prop) [∀ p, DecidablePred (bad p)]
    [DecidablePred (fun ω => ∃ p ∈ P, bad p ω)] :
    prob μ (fun ω => ∃ p ∈ P, bad p ω) ≤ ∑ p ∈ P, prob μ (bad p) := by
  unfold prob
  rw [Finset.sum_comm]
  refine sum_le_sum fun ω _ => ?_
  split_ifs with h
  · obtain ⟨p, hp, hb⟩ := h
    calc μ ω = if bad p ω then μ ω else 0 := by simp [hb]
      _ ≤ ∑ p' ∈ P, if bad p' ω then μ ω else 0 :=
          single_le_sum (f := fun p' => if bad p' ω then μ ω else 0)
            (fun p' _ => by split_ifs <;> simp [hμ ω]) hp
  · exact sum_nonneg fun p' _ => by split_ifs <;> simp [hμ ω]

/-- **Théorème A.3, arithmétique du seuil.** Si k ≥ (12/δ²)·ln(N²/ε′), alors
    N²·exp(−kδ²/12) ≤ ε′. -/
theorem jl_seuil (N k δ ε : ℝ) (hN : 0 < N) (hδ : 0 < δ) (hε : 0 < ε)
    (hk : 12 / δ ^ 2 * Real.log (N ^ 2 / ε) ≤ k) :
    N ^ 2 * Real.exp (-(k * δ ^ 2 / 12)) ≤ ε := by
  have hN2 : 0 < N ^ 2 := by positivity
  have h1 : Real.log (N ^ 2 / ε) ≤ k * δ ^ 2 / 12 := by
    have : 12 / δ ^ 2 * Real.log (N ^ 2 / ε) * (δ ^ 2 / 12) = Real.log (N ^ 2 / ε) := by
      field_simp
    nlinarith [sq_nonneg δ, mul_le_mul_of_nonneg_right hk (by positivity : (0 : ℝ) ≤ δ ^ 2 / 12)]
  have h2 : N ^ 2 / ε ≤ Real.exp (k * δ ^ 2 / 12) := by
    rw [← Real.exp_log (by positivity : (0 : ℝ) < N ^ 2 / ε)]
    exact Real.exp_le_exp.mpr h1
  rw [Real.exp_neg, ← div_eq_mul_inv, div_le_iff₀ (Real.exp_pos _)]
  rw [div_le_iff₀ hε] at h2
  linarith

/-- **Théorème A.3.** Sous la queue de Chernoff posée pour chaque paire, et si le nombre
    de paires est au plus N²/2, la probabilité qu'une paire au moins soit déformée est au
    plus N²·exp(−kδ²/12), donc au plus ε′ pour k ≥ (12/δ²)·ln(N²/ε′). -/
theorem jl_dimensionnement {Ω ι : Type*} [Fintype Ω] (μ : Ω → ℝ) (hμ : ∀ ω, 0 ≤ μ ω)
    (P : Finset ι) (bad : ι → Ω → Prop) [∀ p, DecidablePred (bad p)]
    [DecidablePred (fun ω => ∃ p ∈ P, bad p ω)] (N k δ ε : ℝ) (hN : 0 < N) (hδ : 0 < δ)
    (hε : 0 < ε) (hP : (P.card : ℝ) ≤ N ^ 2 / 2)
    (chernoff : ∀ p ∈ P, prob μ (bad p) ≤ 2 * Real.exp (-(k * δ ^ 2 / 12)))
    (hk : 12 / δ ^ 2 * Real.log (N ^ 2 / ε) ≤ k) :
    prob μ (fun ω => ∃ p ∈ P, bad p ω) ≤ ε := by
  have h1 := union_bound μ hμ P bad
  have h2 : ∑ p ∈ P, prob μ (bad p) ≤ P.card * (2 * Real.exp (-(k * δ ^ 2 / 12))) := by
    have := sum_le_sum chernoff
    simpa [sum_const, nsmul_eq_mul] using this
  have h3 : (P.card : ℝ) * (2 * Real.exp (-(k * δ ^ 2 / 12))) ≤
      N ^ 2 * Real.exp (-(k * δ ^ 2 / 12)) := by
    have he := Real.exp_pos (-(k * δ ^ 2 / 12))
    nlinarith
  linarith [jl_seuil N k δ ε hN hδ hε hk]

/-- **Lemme 2.2, existence.** Si la probabilité d'échec est strictement inférieure à 1,
    il existe un tirage Φ_ω qui préserve toutes les distances. -/
theorem jl_existence {Ω ι : Type*} [Fintype Ω] (μ : Ω → ℝ) (h1 : ∑ ω, μ ω = 1)
    (P : Finset ι) (bad : ι → Ω → Prop) [∀ p, DecidablePred (bad p)]
    [DecidablePred (fun ω => ∃ p ∈ P, bad p ω)]
    (hlt : prob μ (fun ω => ∃ p ∈ P, bad p ω) < 1) : ∃ ω, ∀ p ∈ P, ¬ bad p ω := by
  by_contra hc
  push Not at hc
  have : prob μ (fun ω => ∃ p ∈ P, bad p ω) = 1 := by
    unfold prob; rw [← h1]
    exact sum_congr rfl fun ω _ => by simp [hc ω]
  linarith

/-- **Lemme 2.2, seuil.** Pour k > 24·ln N/ε², N²·exp(−kε²/12) < 1. -/
theorem jl_seuil_existence (N k ε : ℝ) (hN : 1 ≤ N) (hε : 0 < ε)
    (hk : 24 * Real.log N / ε ^ 2 < k) : N ^ 2 * Real.exp (-(k * ε ^ 2 / 12)) < 1 := by
  have hN0 : 0 < N := by linarith
  have hlog : 2 * Real.log N < k * ε ^ 2 / 12 := by
    have := (div_lt_iff₀ (by positivity : (0 : ℝ) < ε ^ 2)).1 hk
    linarith
  have hN2 : N ^ 2 = Real.exp (2 * Real.log N) := by
    rw [← Real.log_rpow hN0, Real.exp_log (by positivity)]; norm_cast
  rw [hN2, ← Real.exp_add]
  calc Real.exp (2 * Real.log N + -(k * ε ^ 2 / 12)) < Real.exp 0 :=
        Real.exp_lt_exp.mpr (by linarith)
    _ = 1 := Real.exp_zero

/-! ## 8. SOTP-Base : réductions (Corollaire A.1, Proposition 3.2)

La couche Clay de SOTP-Base (projection JL du contexte) est une fonction publique z de c
et du tirage public de Φ. Un adversaire contre SOTP-Base qui lit aussi z est, pour z fixé,
un adversaire contre le jeu de SOTP-Low, dont le réducteur calcule z lui-même. -/

section Base

variable {q : ℕ} [Fact q.Prime] {M Z : Type*} [AddCommGroup M] [Fintype M]

/-- **Corollaire A.1, confidentialité.** Pour toute valeur publique z de la couche Clay,
    Adv^IND-CONF ≤ Adv^PRG + 1/q. -/
theorem base_ind_conf (G : ZMod q → M) (m : Bool → M) (A : M → ZMod q → Z → Bool) (z : Z) :
    advIND2 G m (fun y e => A y e z) ≤ advPRG2 G m (fun y e => A y e z) + 1 / q :=
  ind_conf_complet G m (fun y e => A y e z)

end Base

section BaseDLog

variable {q : ℕ} [Fact q.Prime] {Γ : Type*} [Group Γ] {M Z : Type*} [AddCommGroup M]

/-- **Corollaire A.1, fiabilité.** Pour toute valeur publique z de la couche Clay,
    Win^BIND-REL ≤ Adv^DLOG. -/
theorem base_bind_rel (g : Γ) (hg : orderOf g = q) (PRG : ZMod q → M) (z : Z)
    (A : Z → Γ → M × Γ × Opening (ZMod q) M q × Opening (ZMod q) M q)
    [∀ x, Decidable (winsBIND g x PRG (A z (zpowq g x)).1 (A z (zpowq g x)).2.1
      (A z (zpowq g x)).2.2.1 (A z (zpowq g x)).2.2.2)] :
    avg (fun x : ZMod q => ind (winsBIND g x PRG (A z (zpowq g x)).1 (A z (zpowq g x)).2.1
        (A z (zpowq g x)).2.2.1 (A z (zpowq g x)).2.2.2))
      ≤ avg (fun x : ZMod q =>
          ind (extract (A z (zpowq g x)).2.2.1 (A z (zpowq g x)).2.2.2 = x)) :=
  win_bind_le_dlog g hg PRG (A z)

end BaseDLog

/-! ## 9. SOTP-High : sécurité héritée de Groth16 (Théorème A.4, Proposition 3.3)

La divulgation nulle parfaite de Groth16 est modélisée par un simulateur : la preuve π
est tirée selon une loi `Sim` qui ne dépend que des entrées publiques (h_c, c_m). La
connaissance-solidité de Groth16, la résistance aux collisions de Poseidon et le
caractère liant sous DLog sont des hypothèses nommées, sous forme de probabilités
d'échec majorées. -/

section High

variable {q : ℕ} [Fact q.Prime]

/-- **Théorème A.4, confidentialité, et Proposition 3.3 (1).** L'engagement c_m = g^m·h^ρ
    a pour exposant m + xρ. Pour h ≠ 1 (x ≠ 0), toute statistique F de (c_m, π) dont π suit
    le simulateur a la même espérance pour deux messages : la loi de Σ ne dépend pas de m. -/
theorem high_conf (x : ZMod q) (hx : x ≠ 0) (F : ZMod q → ℝ) (m₀ m₁ : ZMod q) :
    avg (fun ρ : ZMod q => F (m₀ + x * ρ)) = avg (fun ρ : ZMod q => F (m₁ + x * ρ)) := by
  rw [avg_affine m₀ x hx F, avg_affine m₁ x hx F]

end High

/-- **Théorème A.4, fiabilité, et Proposition 3.3 (2).** Une victoire BIND-REL contre
    SOTP-High est contenue dans l'union de trois échecs : extraction Groth16, collision
    Poseidon, deux témoins extraits sur des messages distincts (DLOG). Sa probabilité est
    au plus ε_sound + ε_coll + ε_dlog, et Relver ≥ 1 − ε_sound − ε_coll − ε_dlog pour une
    complétude parfaite. -/
theorem high_relver {Ω : Type*} [Fintype Ω] (μ : Ω → ℝ) (hμ : ∀ ω, 0 ≤ μ ω)
    (W E₁ E₂ E₃ : Ω → Prop) [DecidablePred W] [DecidablePred E₁] [DecidablePred E₂]
    [DecidablePred E₃] (hW : ∀ ω, W ω → E₁ ω ∨ E₂ ω ∨ E₃ ω) (εs εc εd : ℝ)
    (h₁ : prob μ E₁ ≤ εs) (h₂ : prob μ E₂ ≤ εc) (h₃ : prob μ E₃ ≤ εd) :
    prob μ W ≤ εs + εc + εd ∧ 1 - (εs + εc + εd) ≤ max 0 (1 - prob μ W) := by
  have hle : prob μ W ≤ prob μ E₁ + prob μ E₂ + prob μ E₃ := by
    unfold prob
    rw [← sum_add_distrib, ← sum_add_distrib]
    refine sum_le_sum fun ω _ => ?_
    have h0 := hμ ω
    have hw := hW ω
    split_ifs <;> first | linarith | (exfalso; tauto)
  refine ⟨by linarith, le_trans (by linarith) (le_max_right _ _)⟩

/-! ## 10. Conjecture 3.1 (énoncé seulement)

La conjecture est posée dans un modèle où la couche Clay transmet un contexte d'espèce que
l'institution ne détient pas. Ce modèle n'est pas formalisé. L'énoncé ci-dessous en garde
la structure logique au-dessus d'un cadre abstrait : des protocoles rangés par régime,
une notion de fuite négligeable, une opposabilité et la variante SOTP de chaque régime.
La constante C_R est choisie avant tout protocole, donc indépendamment de λ, Δ et γ. La
conjecture n'est pas démontrée et n'est pas posée comme axiome. -/

/-- Cadre abstrait de la Conjecture 3.1. -/
structure CadreOptimalite where
  Regime : Type
  Proto : Type
  regime : Proto → Regime
  fuiteNegligeable : Proto → Prop
  opp : Proto → ℝ
  sotp : Regime → Proto

/-- **Conjecture 3.1 (énoncé).** Pour chaque régime R, il existe C_R ≥ 1 tel que tout
    protocole du régime à fuite négligeable vérifie Opp(P′) ≤ C_R·Opp(SOTP_R). -/
def ConjectureOptimalite (F : CadreOptimalite) : Prop :=
  ∀ R : F.Regime, ∃ C : ℝ, 1 ≤ C ∧
    ∀ P : F.Proto, F.regime P = R → F.fuiteNegligeable P → F.opp P ≤ C * F.opp (F.sotp R)

/-- **Remarque 3.8.** Dans un cadre où la variante SOTP d'un régime a une opposabilité
    nulle (couche Clay fonction du contexte public, Remarque 3.2) alors qu'un protocole
    du même régime à fuite négligeable a une opposabilité positive (témoin de la
    Remarque 2.20), la conjecture est fausse : elle exige le modèle à contexte privé. -/
theorem conjecture_exige_contexte_prive (F : CadreOptimalite) (R : F.Regime) (P : F.Proto)
    (hR : F.regime P = R) (hf : F.fuiteNegligeable P) (hP : 0 < F.opp P)
    (hS : F.opp (F.sotp R) = 0) : ¬ ConjectureOptimalite F := by
  intro h
  obtain ⟨C, _, hC⟩ := h R
  have := hC P hR hf
  rw [hS, mul_zero] at this
  linarith

end GameBasedSOTP

/-! ## Bloc de vérification de la version 1.3 -/

#print axioms GameBasedSOTP.union_bound
#print axioms GameBasedSOTP.jl_seuil
#print axioms GameBasedSOTP.jl_dimensionnement
#print axioms GameBasedSOTP.jl_existence
#print axioms GameBasedSOTP.jl_seuil_existence
#print axioms GameBasedSOTP.base_ind_conf
#print axioms GameBasedSOTP.base_bind_rel
#print axioms GameBasedSOTP.high_conf
#print axioms GameBasedSOTP.high_relver
#print axioms GameBasedSOTP.conjecture_exige_contexte_prive
