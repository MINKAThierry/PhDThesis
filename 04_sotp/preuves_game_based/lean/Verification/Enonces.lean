/-
  Dossier de vérification. Fichier des énoncés seuls
  ===================================================
  Ce fichier ne contient AUCUNE preuve. Chaque énoncé de l'annexe A et du chapitre 3
  mécanisé dans `GameBasedSOTP.lean` (version 1.3) y est écrit sous la forme
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

universe u₁ u₂ u₃

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


/-! ## 3. Bornes complètes et masque par troncature (version 1.2, lot L4) -/

/-- Théorème A.5, (A.17) (p. 228), en situation réduite et avec la couche Iron :
    Adv^IND-CONF(A) ≤ Adv^PRG(B) + 1/q. -/
def ConfSOTPLowComplete : Prop :=
  ∀ {q : ℕ} [Fact q.Prime] {M : Type u₁} [AddCommGroup M] [Fintype M]
    (G : ZMod q → M) (m : Bool → M) (A : M → ZMod q → Bool),
    advIND2 G m A ≤ advPRG2 G m A + 1 / q

/-- Théorème A.5, (A.18) (p. 228), en situation réduite :
    Win^BIND-REL(A) ≤ Adv^DLOG(B) + 1/q. -/
def RelSOTPLowComplete : Prop :=
  ∀ {q : ℕ} [Fact q.Prime] {Γ : Type u₁} [Group Γ] {M : Type u₂} [AddCommGroup M]
    (g : Γ), orderOf g = q →
    ∀ (PRG : ZMod q → M) (A : Γ → M × Γ × Opening (ZMod q) M q × Opening (ZMod q) M q)
      [∀ x, Decidable (winsBIND g x PRG (A (zpowq g x)).1 (A (zpowq g x)).2.1
        (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2)],
      avg (fun x : ZMod q => ind (winsBIND g x PRG (A (zpowq g x)).1 (A (zpowq g x)).2.1
          (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2))
        ≤ avg (fun x : ZMod q =>
            ind (extract (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2 = x)) + 1 / q

/-- Remarque 3.5 (p. 96), loi de s mod N : pour q = kN + r et r < N, la valeur y < N a
    k + 1 antécédents si y < r et k sinon. -/
def LoiTroncature : Prop :=
  ∀ (N k r y : ℕ), 0 < N → r < N → y < N →
    ((Finset.range (k * N + r)).filter (fun s => s % N = y)).card = k + if y < r then 1 else 0

/-- Remarque 3.5 (p. 96) : la distance statistique entre G(s) = s mod N et la loi uniforme
    vaut r(N − r)/(qN). -/
def DistanceTroncature : Prop :=
  ∀ (N k r : ℕ), 0 < N → r < N → 0 < k * N + r →
    distStat (truncLaw (k * N + r) N) (fun _ => 1 / (N : ℝ)) =
      r * (N - r) / ((k * N + r : ℕ) * N)

/-- Remarque 3.5 (p. 96) : r(N − r)/(qN) ≤ N/(4q), et N/(4q) ≤ 2^(−λ−1) pour N = 2^λ
    dès que N² ≤ 2q (|q| ≥ 2λ). -/
def BorneTroncature : Prop :=
  ∀ (N q r : ℕ), 0 < N → 0 < q →
    (r : ℝ) * (N - r) / (q * N) ≤ N / (4 * q) ∧
      ((N : ℝ) ^ 2 ≤ 2 * q → (N : ℝ) / (4 * q) ≤ 1 / (2 * N))

/-- Remarque 3.5 (p. 96), cas q ≈ 2^252 et λ = 128 : 2^λ/(4q) ≤ 2^(−126), d'où un écart à 1
    de Conf au plus 2^(−125). -/
def TroncatureECDSA : Prop :=
  ∀ q : ℝ, (2 : ℝ) ^ 252 ≤ q →
    (2 : ℝ) ^ 128 / (4 * q) ≤ 1 / 2 ^ 126 ∧ 2 * ((2 : ℝ) ^ 128 / (4 * q)) ≤ 1 / 2 ^ 125


/-! ## 4. SOTP-Base, SOTP-High et Conjecture 3.1 (version 1.3, lot L4) -/

/-- Théorème A.3 (p. 227), borne de l'union : la probabilité qu'une paire au moins soit
    déformée est au plus la somme des probabilités par paire. -/
def BorneUnion : Prop :=
  ∀ {Ω : Type u₁} {ι : Type u₂} [Fintype Ω] (μ : Ω → ℝ), (∀ ω, 0 ≤ μ ω) →
    ∀ (P : Finset ι) (bad : ι → Ω → Prop) [∀ p, DecidablePred (bad p)]
      [DecidablePred (fun ω => ∃ p ∈ P, bad p ω)],
      prob μ (fun ω => ∃ p ∈ P, bad p ω) ≤ ∑ p ∈ P, prob μ (bad p)

/-- Théorème A.3 (p. 227), seuil : k ≥ (12/δ²)·ln(N²/ε′) entraîne N²·exp(−kδ²/12) ≤ ε′. -/
def SeuilJL : Prop :=
  ∀ (N k δ ε : ℝ), 0 < N → 0 < δ → 0 < ε → 12 / δ ^ 2 * Real.log (N ^ 2 / ε) ≤ k →
    N ^ 2 * Real.exp (-(k * δ ^ 2 / 12)) ≤ ε

/-- Théorème A.3 (p. 227) et Proposition 3.2 (p. 98), avec la queue de Chernoff du χ²
    posée pour chaque paire : Φ préserve toutes les distances avec probabilité au moins
    1 − ε′. -/
def DimensionnementJL : Prop :=
  ∀ {Ω : Type u₁} {ι : Type u₂} [Fintype Ω] (μ : Ω → ℝ), (∀ ω, 0 ≤ μ ω) →
    ∀ (P : Finset ι) (bad : ι → Ω → Prop) [∀ p, DecidablePred (bad p)]
      [DecidablePred (fun ω => ∃ p ∈ P, bad p ω)] (N k δ ε : ℝ), 0 < N → 0 < δ → 0 < ε →
      (P.card : ℝ) ≤ N ^ 2 / 2 →
      (∀ p ∈ P, prob μ (bad p) ≤ 2 * Real.exp (-(k * δ ^ 2 / 12))) →
      12 / δ ^ 2 * Real.log (N ^ 2 / ε) ≤ k →
      prob μ (fun ω => ∃ p ∈ P, bad p ω) ≤ ε

/-- Lemme 2.2 (p. 47), existence : une probabilité d'échec inférieure à 1 donne un tirage
    qui préserve toutes les distances. -/
def ExistenceJL : Prop :=
  ∀ {Ω : Type u₁} {ι : Type u₂} [Fintype Ω] (μ : Ω → ℝ), ∑ ω, μ ω = 1 →
    ∀ (P : Finset ι) (bad : ι → Ω → Prop) [∀ p, DecidablePred (bad p)]
      [DecidablePred (fun ω => ∃ p ∈ P, bad p ω)],
      prob μ (fun ω => ∃ p ∈ P, bad p ω) < 1 → ∃ ω, ∀ p ∈ P, ¬ bad p ω

/-- Lemme 2.2 (p. 47), seuil : k > 24·ln N/ε² entraîne N²·exp(−kε²/12) < 1. -/
def SeuilExistenceJL : Prop :=
  ∀ (N k ε : ℝ), 1 ≤ N → 0 < ε → 24 * Real.log N / ε ^ 2 < k →
    N ^ 2 * Real.exp (-(k * ε ^ 2 / 12)) < 1

/-- Corollaire A.1 (p. 227) et Proposition 3.2 (p. 98), confidentialité de SOTP-Base. -/
def ConfSOTPBase : Prop :=
  ∀ {q : ℕ} [Fact q.Prime] {M : Type u₁} {Z : Type u₂} [AddCommGroup M] [Fintype M]
    (G : ZMod q → M) (m : Bool → M) (A : M → ZMod q → Z → Bool) (z : Z),
    advIND2 G m (fun y e => A y e z) ≤ advPRG2 G m (fun y e => A y e z) + 1 / q

/-- Corollaire A.1 (p. 227) et Proposition 3.2 (p. 98), fiabilité de SOTP-Base. -/
def RelSOTPBase : Prop :=
  ∀ {q : ℕ} [Fact q.Prime] {Γ : Type u₁} [Group Γ] {M : Type u₂} {Z : Type u₃}
    [AddCommGroup M] (g : Γ), orderOf g = q → ∀ (PRG : ZMod q → M) (z : Z)
    (A : Z → Γ → M × Γ × Opening (ZMod q) M q × Opening (ZMod q) M q)
    [∀ x, Decidable (winsBIND g x PRG (A z (zpowq g x)).1 (A z (zpowq g x)).2.1
      (A z (zpowq g x)).2.2.1 (A z (zpowq g x)).2.2.2)],
    avg (fun x : ZMod q => ind (winsBIND g x PRG (A z (zpowq g x)).1 (A z (zpowq g x)).2.1
        (A z (zpowq g x)).2.2.1 (A z (zpowq g x)).2.2.2))
      ≤ avg (fun x : ZMod q =>
          ind (extract (A z (zpowq g x)).2.2.1 (A z (zpowq g x)).2.2.2 = x))

/-- Théorème A.4 (p. 227) et Proposition 3.3 (1) (p. 100) : pour h ≠ 1, toute statistique
    de (c_m, π simulée) a la même espérance pour deux messages. -/
def ConfSOTPHigh : Prop :=
  ∀ {q : ℕ} [Fact q.Prime] (x : ZMod q), x ≠ 0 → ∀ (F : ZMod q → ℝ) (m₀ m₁ : ZMod q),
    avg (fun ρ : ZMod q => F (m₀ + x * ρ)) = avg (fun ρ : ZMod q => F (m₁ + x * ρ))

/-- Théorème A.4 (p. 227) et Proposition 3.3 (2) (p. 100) : gain BIND-REL au plus
    ε_sound + ε_coll + ε_dlog et Relver ≥ 1 − ε_sound − ε_coll − ε_dlog. -/
def RelSOTPHigh : Prop :=
  ∀ {Ω : Type u₁} [Fintype Ω] (μ : Ω → ℝ), (∀ ω, 0 ≤ μ ω) →
    ∀ (W E₁ E₂ E₃ : Ω → Prop) [DecidablePred W] [DecidablePred E₁] [DecidablePred E₂]
      [DecidablePred E₃], (∀ ω, W ω → E₁ ω ∨ E₂ ω ∨ E₃ ω) → ∀ (εs εc εd : ℝ),
      prob μ E₁ ≤ εs → prob μ E₂ ≤ εc → prob μ E₃ ≤ εd →
      prob μ W ≤ εs + εc + εd ∧ 1 - (εs + εc + εd) ≤ max 0 (1 - prob μ W)

/-- Remarque 3.8 (p. 104) : la Conjecture 3.1 exige le modèle à contexte privé ; elle
    est fausse dans un cadre où SOTP a une opposabilité nulle face à un protocole du
    même régime d'opposabilité positive. -/
def ConjectureExigeContextePrive : Prop :=
  ∀ (F : CadreOptimalite) (R : F.Regime) (P : F.Proto), F.regime P = R →
    F.fuiteNegligeable P → 0 < F.opp P → F.opp (F.sotp R) = 0 → ¬ ConjectureOptimalite F

end Enonces
