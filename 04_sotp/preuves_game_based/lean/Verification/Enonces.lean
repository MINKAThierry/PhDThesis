/-
  Dossier de vérification. Fichier des énoncés seuls
  ===================================================
  Ce fichier ne contient AUCUNE preuve. Chaque énoncé de l'annexe A de la thèse
  mécanisé dans `GameBasedSOTP.lean` (version 1.1) y est écrit sous la forme
  `def NomEnonce : Prop := ...`. Le fichier `Principal.lean` relie chaque énoncé
  au théorème existant. Tout écart entre l'énoncé écrit ici et le théorème
  démontré empêche la compilation de `Principal.lean`.

  Renvois : manuscrit v36 (« Aux fondements de la cryptographie
  institutionnelle »), numéro et page imprimée, d'après index_labels_v36.tsv.

  Situation réduite (annexe A, section « Mécanisation en situation réduite »,
  p. 230). Les probabilités sont des moyennes uniformes sur des ensembles finis.
  Les adversaires sont des fonctions dont l'aléa propre est absorbé dans leur
  description. PRG et DLOG ne sont pas des axiomes : ce sont les avantages du
  réducteur B, que les théorèmes relient à ceux de l'adversaire A.

  Importation. Ce fichier importe le module `GameBasedSOTP`, qui importe
  lui-même Mathlib. Il n'importe rien d'autre.
-/

import GameBasedSOTP

open GameBasedSOTP

universe u₁ u₂

namespace Enonces

/-! ## 1. Confidentialité de la couche Gold (Théorème A.1) -/

/-- Masque jetable, étape de la preuve du Théorème A.1 (p. 225) : la loi de m + y,
    y uniforme, ne dépend pas de m. -/
def MasqueJetable : Prop :=
  ∀ {M : Type u₁} [AddCommGroup M] [Fintype M] (m : M) (f : M → ℝ),
    avg (fun y => f (m + y)) = avg f

/-- Théorème A.1 (p. 225), réduction de SOTP-Low au PRG en situation réduite :
    pour tout adversaire A contre IND-CONF, le réducteur B construit à partir de A
    vérifie Adv^IND-CONF(A) = Adv^PRG(B). -/
def ReductionPRG : Prop :=
  ∀ {S : Type u₁} {M : Type u₂} [Fintype S] [AddCommGroup M] [Fintype M]
    (G : S → M) (m : Bool → M) (A : M → Bool), advIND G m A = advPRG G m A

/-- Théorème A.1 (p. 225), terme statistique : avec un masque uniforme au lieu de
    G(s), l'avantage IND-CONF est nul. -/
def MasqueParfait : Prop :=
  ∀ {M : Type u₁} [AddCommGroup M] [Fintype M] (m : Bool → M) (A : M → Bool),
    |avg (fun b : Bool => avg (fun y : M => ind (A (m b + y) = b))) - 1 / 2| = 0

/-! ## 2. Fiabilité de vérification (Définition A.2, Théorème A.2) -/

/-- Définition A.2 (p. 220), engagement de Pedersen : deux ouvertures d'un même
    engagement à graines distinctes livrent le logarithme discret de h = g^x. -/
def ExtractionPedersen : Prop :=
  ∀ {q : ℕ} [Fact q.Prime] {Γ : Type u₁} [Group Γ] (g : Γ), orderOf g = q →
    ∀ {x s₀ ρ₀ s₁ ρ₁ : ZMod q}, com g x s₀ ρ₀ = com g x s₁ ρ₁ → s₀ ≠ s₁ →
      ρ₀ ≠ ρ₁ ∧ x = (s₀ - s₁) / (ρ₁ - ρ₀)

/-- Théorème A.2 (p. 226), réduction de SOTP-Low au logarithme discret : toute
    victoire BIND-REL livre exactement x. -/
def ReductionDLOG : Prop :=
  ∀ {q : ℕ} [Fact q.Prime] {Γ : Type u₁} [Group Γ] {M : Type u₂} [AddCommGroup M]
    (g : Γ), orderOf g = q →
    ∀ (x : ZMod q) (PRG : ZMod q → M) (σ₁ : M) (σ₂ : Γ) (o₀ o₁ : Opening (ZMod q) M q),
      winsBIND g x PRG σ₁ σ₂ o₀ o₁ → extract o₀ o₁ = x

/-- Théorème A.2 (p. 226) et (A.18) (p. 228) en situation réduite :
    Win^BIND-REL(A) ≤ Adv^DLOG(B), x uniforme dans ZMod q. -/
def GainBINDRel : Prop :=
  ∀ {q : ℕ} [Fact q.Prime] {Γ : Type u₁} [Group Γ] {M : Type u₂} [AddCommGroup M]
    (g : Γ), orderOf g = q →
    ∀ (PRG : ZMod q → M) (A : Γ → M × Γ × Opening (ZMod q) M q × Opening (ZMod q) M q)
      [∀ x, Decidable (winsBIND g x PRG (A (zpowq g x)).1 (A (zpowq g x)).2.1
        (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2)],
      avg (fun x : ZMod q => ind (winsBIND g x PRG (A (zpowq g x)).1 (A (zpowq g x)).2.1
          (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2))
        ≤ avg (fun x : ZMod q =>
            ind (extract (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2 = x))

end Enonces
