/-
  Dossier de vérification. Fichier des énoncés seuls
  ===================================================
  Ce fichier ne contient AUCUNE preuve. Chaque énoncé de la thèse y est écrit
  sous la forme `def NomEnonce : Prop := ...`, dans sa forme générale.
  Le fichier `Principal.lean` relie chaque énoncé au théorème existant de
  `ConditionalCRO.lean` (version 3.13). Tout écart entre l'énoncé écrit ici et le
  théorème démontré empêche la compilation de `Principal.lean`.

  Renvois : manuscrit v36 (« Aux fondements de la cryptographie
  institutionnelle »), numéro et page imprimée, d'après index_labels_v36.tsv.
  Les numéros et les pages cités dans les sections 1 à 5 sont identiques en v35.
  « Code B.1 » désigne le listing complet de l'annexe B (p. 239 à 266). Il
  reproduit `ConditionalCRO.lean` sans les quatre lignes d'auteurs de
  l'en-tête, si bien que la ligne n du listing est la ligne n + 4 du fichier.

  Importation. Les définitions et les preuves sont dans un seul fichier. La
  versions 3.5 à 3.13 prolongent la 3.4 par ajout des sections 12 à 29 en
  fin de fichier. Les lignes 5 à 1575 sont inchangées et les numéros de ligne cités
  restent valables. Ce fichier importe donc le module
  `ConditionalCRO`, qui importe lui-même Mathlib. Il n'importe rien d'autre.
-/

import ConditionalCRO

open Real Filter Finset
open ConditionalCRO

namespace Enonces

universe u₁ u₂ u₃ u₄

/-! ## 0. Définitions propres utilisées par les énoncés (rappel, sans code)

Ces définitions sont celles de `ConditionalCRO.lean`. Leur non-vacuité est
testée dans `Coherence.lean`.

* `c0 = 1/(2 ln 2)` : constante de Pinsker en bits. Remarque 2.16 (p. 58),
  code 3.9 (p. 112), fichier ligne 54, code B.1 ligne 50.
* `Negligible` : fonction négligeable. Code 3.4 (p. 111), fichier ligne 72, code B.1 ligne 68.
* `InstitutionalParams` : H(C), Δ, α, β avec H ≥ 0, Δ ≥ 0, α > 0, β ≥ 1.
  Définitions 2.10 à 2.12 (p. 55), code 3.5 (p. 111), fichier ligne 103, code B.1 ligne 99.
* `gamma p = α·H(C) − 1` : borne inférieure de H(V|C). Hypothèse 2.2 (p. 56),
  Hypothèse 3.2 et équation (3.24) (p. 108), fichier ligne 114, code B.1 ligne 110.
* `ProtocolInstance` : point du modèle abstrait, avec Conf = 1 − TVmax
  (Définition 3.1, p. 107), Rel (Définition 3.2, p. 108) et
  Opp = I(V;Σ|C)/H(V|C) (Définition 3.3, p. 108). Les champs `pinsker` et
  `fano` y sont posés (Hypothèse 3.4, p. 109). Code 3.7 (p. 112), fichier ligne 139,
  code B.1 ligne 135.
* `InstitutionalAssumptions` : Hypothèses 2.1, 2.2 et 2.3 (p. 55 et 56),
  Hypothèses 3.1 à 3.3 (p. 108 et 109), code 3.8 (p. 112), fichier ligne 159, code B.1 ligne 155.
* `ProtocolFamily` : code 3.1 (p. 110), fichier ligne 263, code B.1 ligne 259.
* `capacity_regime` : Définitions 5.1 à 5.3 (p. 173), code 3.15 (p. 120),
  fichier ligne 373, code B.1 ligne 369.
* `tv`, `klN`, `miN`, `entN2` : variation totale, divergence, information
  mutuelle et entropie sur lois finies (nats). Sous-section 3.4.9 (p. 117),
  fichier lignes 665, 669, 721 et 725.
* `CLOModel` : loi finie de (C, M, Σ), M uniforme sur 2^λ valeurs et
  indépendant de C, noyau de verdict admissible ne dépendant que de (Σ, C)
  (Définition 2.13, p. 55). Sous-section 3.4.9 (p. 117), fichier ligne 898, code B.1 ligne 894.
  Grandeurs `Conf`, `Rel D`, `Opp`, `I`, `IV`, `HV`, `HC` en bits, fichier
  lignes 925 à 964.
-/

/-! ## 1. Négligeabilité -/

/-- Lemme 3.1 (p. 113) : ε₀(λ) = 2^(−λ) est négligeable. Code 3.10 (p. 113),
    fichier ligne 80, code B.1 ligne 76 (p. 240). -/
def NegligeabiliteEps0 : Prop := Negligible ε₀

/-! ## 2. Noyau algébrique (modèle abstrait) -/

/-- Lemme 2.3 (p. 57), équation (2.46) ; code 3.11 (p. 113) ; fichier ligne 172,
    code B.1 ligne 168 (p. 241). Conf ≥ 1 − √(c₀·β·I(M;Σ|C)) sous l'Hypothèse 2.3. -/
def Lemme4 : Prop :=
  ∀ {lam : ℕ} (P : ProtocolInstance lam),
    P.KLmax ≤ P.params.β * P.I →
      1 - Real.sqrt (c0 * P.params.β * P.I) ≤ P.Conf

/-- Théorème 2.4, forme explicite (2.49) (p. 58) ; équation (3.30) (p. 114) ;
    fichier ligne 195, code B.1 ligne 191 (p. 242). -/
def TrilemmeExplicite : Prop :=
  ∀ {lam : ℕ} (P : ProtocolInstance lam),
    InstitutionalAssumptions P → ∀ (κ : ℝ), 0 ≤ κ → 1 ≤ lam → P.I ≤ κ / lam →
      P.Conf * P.Rel * P.Opp ≤
        (1 / gamma P.params) * (P.params.Δ / lam + κ * (P.params.Δ + 1) / (lam : ℝ) ^ 2
          + κ ^ 2 / (lam : ℝ) ^ 3)

/-- Forme publiée comme corollaire (Remarque 2.17, p. 61) ; Théorème 3.2
    (p. 109) ; fichier ligne 244, code B.1 ligne 240 (p. 243). -/
def TrilemmePublie : Prop :=
  ∀ {lam : ℕ} (P : ProtocolInstance lam),
    InstitutionalAssumptions P → ∀ (κ : ℝ), 0 ≤ κ → 1 ≤ lam → P.I ≤ κ / lam →
      P.Conf * P.Rel * P.Opp ≤
        P.params.Δ / lam + κ * (P.params.Δ + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 3

/-- Théorème 3.3 (p. 113), équation (3.29) (p. 114) ; forme (2.48) du
    Théorème 2.4 (p. 58) ; code 3.2 (p. 110) ; fichier ligne 274, code B.1 ligne 270 (p. 243). -/
def TrilemmeAsymptotique : Prop :=
  ∀ (F : ProtocolFamily) (κ : ℝ), 0 ≤ κ →
    (∀ lam, 64 ≤ lam → InstitutionalAssumptions (F.inst lam)) →
    (∀ lam, 64 ≤ lam → (F.inst lam).I ≤ κ / lam) →
      ∃ K : ℝ, ∃ ε : ℕ → ℝ, Negligible ε ∧ ∀ lam : ℕ, 64 ≤ lam →
        (F.inst lam).Conf * (F.inst lam).Rel * (F.inst lam).Opp ≤
          F.params.Δ / lam + K / (lam : ℝ) ^ 2 + ε lam

/-- Théorème 2.4, forme raffinée (2.50) (p. 58) ; sous-section 3.4.8
    (p. 115) ; code 3.14 (p. 116) ; fichier ligne 415, code B.1 ligne 411 (p. 246). -/
def TrilemmeRaffine : Prop :=
  ∀ {lam : ℕ} (P : ProtocolInstance lam),
    InstitutionalAssumptions P → ∀ (κ : ℝ), 0 ≤ κ → 1 ≤ lam → P.I ≤ κ / lam →
      P.IV ≤ P.HV →
        P.Conf * P.Rel * P.Opp ≤
          ((κ / lam + 1) / lam) * min 1 ((κ / lam + P.params.Δ) / gamma P.params)

/-- Théorème 3.4 (p. 114), équation (3.31) ; code 3.12 (p. 115) ; fichier ligne 322,
    code B.1 ligne 318 (p. 244). Témoin de cohérence du modèle abstrait. -/
def TemoinCoherence : Prop :=
  ∀ (lam : ℕ) (hlam : 1 ≤ lam),
    InstitutionalAssumptions (witnessInstance lam hlam) ∧
    (witnessInstance lam hlam).I ≤ 0 / lam ∧
    (witnessInstance lam hlam).Conf * (witnessInstance lam hlam).Rel *
      (witnessInstance lam hlam).Opp =
      (witnessInstance lam hlam).params.Δ / (gamma (witnessInstance lam hlam).params * lam)

/-- Théorème 3.5 (p. 115), équation (3.32) ; code 3.13 (p. 115) ; fichier ligne 356,
    code B.1 ligne 352 (p. 245). Témoin de portée, nécessité de l'Hypothèse 2.4. -/
def TemoinPortee : Prop :=
  ∀ (lam : ℕ) (hlam : 64 ≤ lam),
    InstitutionalAssumptions (scopeInstance lam hlam) ∧
    (scopeInstance lam hlam).params.Δ = 0 ∧
    (scopeInstance lam hlam).Conf * (scopeInstance lam hlam).Rel *
      (scopeInstance lam hlam).Opp = 1 / 4 ∧
    (scopeInstance lam hlam).I = lam / 2 - 1

/-- Théorème 3.6 (p. 120) ; code 3.16 (p. 120) ; fichier ligne 379, code B.1 ligne 375 (p. 245). -/
def RegimeHelios : Prop :=
  capacity_regime HeliosParams.Δ 128 = .MidCapacity

/-- Théorème 3.7 (p. 120) ; code 3.17 (p. 120) ; fichier ligne 386, code B.1 ligne 382 (p. 245). -/
def RegimeZkSNARK : Prop :=
  capacity_regime zkSNARKParams.Δ 256 = .MidCapacity

/-- Théorème 3.8 (p. 121) ; code 3.18 (p. 121) ; fichier ligne 393, code B.1 ligne 389 (p. 245). -/
def RegimeAuditTraditionnel : Prop :=
  capacity_regime TraditionalAuditParams.Δ 128 = .MidCapacity

/-- Verdict déterministe, Remarque 2.4 (p. 48) et Remarque 3.9 (p. 108) ;
    sous-section 3.4.8 (p. 115) ; fichier ligne 402, code B.1 ligne 398 (p. 245). -/
def VerdictDeterministe : Prop :=
  ∀ {lam : ℕ} (P : ProtocolInstance lam), P.IV = P.HV → 0 < P.HV → P.Opp = 1

/-- Verdict déterministe et capacité, sous-section 3.4.8 (p. 115) ;
    Remarque 2.18 (p. 61) ; fichier ligne 408, code B.1 ligne 404 (p. 246). -/
def VerdictDeterministeCapacite : Prop :=
  ∀ {lam : ℕ} (P : ProtocolInstance lam),
    InstitutionalAssumptions P → P.IV = P.HV → gamma P.params - P.I ≤ P.params.Δ

/-- Si Δ ≥ γ, le facteur institutionnel vaut 1. Remarque 2.18 (p. 61) ;
    sous-section 3.4.8 (p. 116) ; fichier ligne 447, code B.1 ligne 443 (p. 246). -/
def FacteurUnSiDeltaGrand : Prop :=
  ∀ {lam : ℕ} (P : ProtocolInstance lam),
    InstitutionalAssumptions P → ∀ (κ : ℝ), 0 ≤ κ → 1 ≤ lam →
      gamma P.params ≤ P.params.Δ →
        min 1 ((κ / lam + P.params.Δ) / gamma P.params) = 1

/-- Seuil H♯, sens 1 : facteur < 1 si et seulement si Δ < γ − κ/λ.
    Remarque 2.18 (p. 61) ; sous-section 3.4.8 (p. 116) ; fichier ligne 459, code B.1 ligne 455
    (p. 246). -/
def FacteurInferieurUnSsi : Prop :=
  ∀ (Δ γ κ lam : ℝ), 0 < γ →
    (min 1 ((κ / lam + Δ) / γ) < 1 ↔ Δ < γ - κ / lam)

/-- Seuil H♯, sens 2 : Δ < (αH − 1) − κ/λ si et seulement si
    H > H♯ = (Δ + 1 + κ/λ)/α. Équation (2.65) et Remarque 2.18 (p. 61) ;
    sous-section 3.4.8 (p. 116) ; fichier ligne 470, code B.1 ligne 466 (p. 247). -/
def SeuilHdiese : Prop :=
  ∀ (Δ α H κ lam : ℝ), 0 < α →
    (Δ < (α * H - 1) - κ / lam ↔ (Δ + 1 + κ / lam) / α < H)

/-! ## 3. Couche concrète : inégalités sur lois finies -/

/-- Pinsker fini (nats), étape 2 de la sous-section 3.4.9 (p. 117) ;
    fichier ligne 673, code B.1 ligne 669 (p. 250). -/
def PinskerFini : Prop :=
  ∀ {α : Type u₁} [Fintype α] (P Q : α → ℝ),
    (∀ a, 0 ≤ P a) → (∀ a, 0 ≤ Q a) → ∑ a, P a = 1 → ∑ a, Q a = 1 →
    (∀ a, 0 < P a → 0 < Q a) →
      tv P Q ^ 2 ≤ klN P Q / 2

/-- Positivité de l'information mutuelle, étape 3 de la sous-section 3.4.9
    (p. 117) ; fichier ligne 729, code B.1 ligne 725 (p. 251). -/
def InfoMutuellePositive : Prop :=
  ∀ {α : Type u₁} {β : Type u₂} [Fintype α] [Fintype β] (w : α → β → ℝ),
    (∀ a b, 0 ≤ w a b) → ∑ a, ∑ b, w a b ≤ 1 → 0 ≤ miN w

/-- Information mutuelle majorée par l'entropie, étape 3 de la
    sous-section 3.4.9 (p. 117) ; fichier ligne 765, code B.1 ligne 761 (p. 252). -/
def InfoMutuelleMajoree : Prop :=
  ∀ {α : Type u₁} {β : Type u₂} [Fintype α] [Fintype β] (w : α → β → ℝ),
    (∀ a b, 0 ≤ w a b) → miN w ≤ entN2 w

/-- Fano fini (nats), étape 4 de la sous-section 3.4.9 (p. 117) ;
    Lemme de Fano (1.9) (p. 17) ; fichier ligne 793, code B.1 ligne 789 (p. 252). -/
def FanoFini : Prop :=
  ∀ {α : Type u₁} {β : Type u₂} [Fintype α] [Fintype β] [DecidableEq α]
    (w : α → β → ℝ),
    (∀ a b, 0 ≤ w a b) → ∑ a, ∑ b, w a b = 1 →
    (∀ a, ∑ b, w a b = 1 / (Fintype.card α : ℝ)) → ∀ (d : β → α),
      (∑ b, w (d b) b) * Real.log (Fintype.card α) - Real.log 2 ≤ miN w

/-! ## 4. Couche concrète : modèle CLOModel -/

/-- I(V;Σ|C) ≤ H(V|C) démontré sur le modèle, étape 3 de la sous-section 3.4.9
    (p. 117) ; fichier ligne 1027, code B.1 ligne 1023 (p. 257). -/
def ModeleIVinfHV : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] (X : CLOModel lam M C S V),
    X.IV ≤ X.HV

/-- Pinsker démontré sur le modèle (bits, constante c₀), étape 2 de la
    sous-section 3.4.9 (p. 117) ; fichier ligne 1077, code B.1 ligne 1073 (p. 257). -/
def ModelePinsker : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [Nonempty M] [Nonempty C]
    (X : CLOModel lam M C S V),
    X.CommonSupport → X.TVmax ^ 2 ≤ c0 * X.KLmax

/-- Fano démontré sur le modèle : I(M;Σ|C) ≥ Rel(D)·λ − 1 pour tout décodeur.
    Hypothèse 3.4 (p. 109) devenue théorème ; étape 5 de la sous-section 3.4.9
    (p. 117) ; fichier ligne 1128, code B.1 ligne 1124 (p. 258). -/
def ModeleFano : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [DecidableEq M] [Nonempty M]
    (X : CLOModel lam M C S V) (D : C → S → M),
    X.Rel D * lam - 1 ≤ X.I

/-- Théorème 2.4, forme explicite (2.49) (p. 58), sur de vraies lois finies ;
    sous-section 3.4.9 (p. 117) ; fichier ligne 1319, code B.1 ligne 1315 (p. 262). -/
def TrilemmeExpliciteConcret : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [DecidableEq M] [Nonempty M]
    [Nonempty C] (X : CLOModel lam M C S V) (D : C → S → M) (Δ α : ℝ),
    Real.log (Fintype.card V) / Real.log 2 ≤ α * X.HC →
    X.IV ≤ X.I + Δ → α * X.HC - 1 ≤ X.HV → 1 ≤ α * X.HC - 1 →
    ∀ (κ : ℝ), 0 ≤ κ → 1 ≤ lam → X.I ≤ κ / lam →
      X.Conf * X.Rel D * X.Opp ≤
        (1 / (α * X.HC - 1)) * (Δ / lam + κ * (Δ + 1) / (lam : ℝ) ^ 2
          + κ ^ 2 / (lam : ℝ) ^ 3)

/-- Théorème 2.4, forme raffinée (2.50) (p. 58), sur de vraies lois finies ;
    sous-section 3.4.9 (p. 117) ; fichier ligne 1336, code B.1 ligne 1332 (p. 262). -/
def TrilemmeRaffineConcret : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [DecidableEq M] [Nonempty M]
    [Nonempty C] (X : CLOModel lam M C S V) (D : C → S → M) (Δ α : ℝ),
    Real.log (Fintype.card V) / Real.log 2 ≤ α * X.HC →
    X.IV ≤ X.I + Δ → α * X.HC - 1 ≤ X.HV → 1 ≤ α * X.HC - 1 →
    ∀ (κ : ℝ), 0 ≤ κ → 1 ≤ lam → X.I ≤ κ / lam →
      X.Conf * X.Rel D * X.Opp ≤
        ((κ / lam + 1) / lam) * min 1 ((κ / lam + Δ) / (α * X.HC - 1))

set_option linter.unusedVariables false in
/-- Lemme 2.3 (p. 57) sur de vraies lois finies ; sous-section 3.4.9
    (p. 117) ; fichier ligne 1351, code B.1 ligne 1347 (p. 262). Le décodeur D figure dans le
    théorème pour construire l'instance abstraite ; la conclusion n'en dépend
    pas. On garde ce lien muet pour rester fidèle au théorème. -/
def Lemme4Concret : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [DecidableEq M] [Nonempty M]
    [Nonempty C] (X : CLOModel lam M C S V) (β : ℝ), 1 ≤ β →
    ∀ (D : C → S → M), X.CommonSupport → X.KLmax ≤ β * X.I →
      1 - Real.sqrt (c0 * β * X.I) ≤ X.Conf

/-- Théorème 2.4, forme asymptotique (2.48) (p. 58), et Théorème 3.3
    (p. 113), sur une famille de lois finies ; sous-section 3.4.9 (p. 118) ;
    fichier ligne 1367, code B.1 ligne 1363 (p. 263). -/
def TrilemmeAsymptotiqueConcret : Prop :=
  ∀ {M S : ℕ → Type} {C V : Type}
    [∀ l, Fintype (M l)] [∀ l, DecidableEq (M l)] [∀ l, Nonempty (M l)]
    [∀ l, Fintype (S l)] [Fintype C] [Fintype V] [Nonempty C]
    (X : ∀ lam, CLOModel lam (M lam) C (S lam) V) (D : ∀ lam, C → S lam → M lam)
    (Δ α H₀ κ : ℝ), 0 < α → 0 ≤ Δ → 0 ≤ κ → 1 ≤ α * H₀ - 1 →
    (∀ lam, 64 ≤ lam → H₀ ≤ (X lam).HC) →
    (∀ lam, 64 ≤ lam → Real.log (Fintype.card V) / Real.log 2 ≤ α * (X lam).HC) →
    (∀ lam, 64 ≤ lam → (X lam).IV ≤ (X lam).I + Δ) →
    (∀ lam, 64 ≤ lam → α * (X lam).HC - 1 ≤ (X lam).HV) →
    (∀ lam, 64 ≤ lam → (X lam).I ≤ κ / lam) →
      ∃ K : ℝ, ∃ ε : ℕ → ℝ, Negligible ε ∧ ∀ lam : ℕ, 64 ≤ lam →
        (X lam).Conf * (X lam).Rel (D lam) * (X lam).Opp ≤
          Δ / lam + K / (lam : ℝ) ^ 2 + ε lam

/-! ## 5. Couche concrète : famille témoin famModel -/

/-- Non-vacuité sur de vraies lois : famModel satisfait toutes les
    hypothèses avec Δ = 1, α = 2, β = 1, κ = 0. Sous-section 3.4.9 (p. 118) ;
    fichier ligne 1516, code B.1 ligne 1512 (p. 265). -/
def FamilleTemoinHypotheses : Prop :=
  ∀ (l : ℕ),
    Real.log (Fintype.card (Fin 2)) / Real.log 2 ≤ 2 * (famModel l).HC ∧
    (famModel l).IV ≤ (famModel l).I + 1 ∧
    2 * (famModel l).HC - 1 ≤ (famModel l).HV ∧
    1 ≤ 2 * (famModel l).HC - 1 ∧
    (famModel l).KLmax ≤ 1 * (famModel l).I ∧
    (famModel l).I ≤ 0 / l ∧
    (famModel l).CommonSupport

/-- Le théorème asymptotique concret s'applique à famModel. Sous-section
    3.4.9 (p. 118) ; fichier ligne 1535, code B.1 ligne 1531 (p. 266). Le décodeur constant 0 est
    écrit avec le terme `Nat.two_pow_pos lam` (0 < 2^λ), seul terme de preuve du
    fichier, nécessaire pour nommer l'élément 0 de Fin (2^λ). Par
    non-pertinence des preuves, il coïncide avec celui du code B.1. -/
def FamilleTemoinAsymptotique : Prop :=
  ∃ K : ℝ, ∃ ε : ℕ → ℝ, Negligible ε ∧ ∀ lam : ℕ, 64 ≤ lam →
    (famModel lam).Conf * (famModel lam).Rel (fun _ _ => ⟨0, Nat.two_pow_pos lam⟩) *
      (famModel lam).Opp ≤ 1 / lam + K / (lam : ℝ) ^ 2 + ε lam

/-! ## 6. Extension v3.5, lot L1 : information classique finie et cadre CLO

Renvois au manuscrit v36 (numéro et page imprimée). Ces énoncés sont démontrés
dans la section 12 de `ConditionalCRO.lean` (version 3.5), ajoutée après la
version 3.4 imprimée en annexe B. Ils n'ont donc pas de numéro de ligne dans le
code B.1. Les définitions nouvelles (`entN1`, `condMI`, `HS`, `IVM`, `IVSM`,
`IVpost`, `post`, `proj₁`, `proj₂`, `constVerdict`, `detVerdict`) sont testées dans
`Coherence.lean`, section 6. -/

universe u₅ u₆

/-- Lemmes 1.3 (p. 17) et A.2 (p. 221), DPI. Pour une chaîne de Markov X → Y → Z
    où Z est tiré de Y par un noyau stochastique k, I(X;Z) ≤ I(X;Y). -/
def DPIFinie : Prop :=
  ∀ {α : Type u₁} {β : Type u₂} {γ : Type u₃} [Fintype α] [Fintype β] [Fintype γ]
    (p : α → β → ℝ) (k : β → γ → ℝ),
    (∀ a b, 0 ≤ p a b) → (∀ b g, 0 ≤ k b g) → (∀ b, ∑ g, k b g = 1) →
      miN (fun a g => ∑ b, p a b * k b g) ≤ miN p

/-- DPI pour la variation totale, utilisée dans la preuve du Théorème 2.3 (p. 49) :
    un post-traitement ne crée pas de distinguabilité. -/
def DPIVariationTotale : Prop :=
  ∀ {σ : Type u₁} {τ : Type u₂} [Fintype σ] [Fintype τ] (P Q : σ → ℝ) (T : σ → τ → ℝ),
    (∀ s t, 0 ≤ T s t) → (∀ s, ∑ t, T s t = 1) →
      tv (fun t => ∑ s, P s * T s t) (fun t => ∑ s, Q s * T s t) ≤ tv P Q

/-- Théorème 2.1 (p. 46), bornes élémentaires : Conf, Rel et, pour H(V|C) > 0,
    Opp sont dans [0, 1]. -/
def BornesElementaires : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] (X : CLOModel lam M C S V)
    [DecidableEq M] [Nonempty M] [Nonempty C] (D : C → S → M),
    (0 ≤ X.Conf ∧ X.Conf ≤ 1) ∧ (0 ≤ X.Rel D ∧ X.Rel D ≤ 1) ∧
      (0 < X.HV → 0 ≤ X.Opp ∧ X.Opp ≤ 1)

/-- Théorème 2.2 (p. 48), goulot d'étranglement contextuel :
    I(V;Σ|C) ≤ min{H(Σ|C), H(V|C)} ≤ log₂|V| ≤ αH(C), la dernière inégalité dès
    que |V| ≤ 2^(αH(C)) (Définition 2.11, p. 55). -/
def GoulotContextuel : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] (X : CLOModel lam M C S V)
    [Nonempty V] (α : ℝ),
    X.IV ≤ min X.HS X.HV ∧ min X.HS X.HV ≤ Real.log (Fintype.card V) / Real.log 2 ∧
      ((Fintype.card V : ℝ) ≤ (2 : ℝ) ^ (α * X.HC) →
        Real.log (Fintype.card V) / Real.log 2 ≤ α * X.HC)

/-- Remarque 2.11 (p. 56), Δ est une capacité de l'institution : pour tout
    protocole, I(V;Σ|C) − I(M;Σ|C) ≤ γ + 1, d'où Δ* ≤ γ + 1. -/
def CapaciteMajoree : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] (X : CLOModel lam M C S V)
    [Nonempty V] (prm : InstitutionalParams),
    prm.H = X.HC → (Fintype.card V : ℝ) ≤ (2 : ℝ) ^ (prm.α * prm.H) →
      X.IV - X.I ≤ gamma prm + 1

/-- Remarque 2.12 (p. 56) : la borne |V| ≤ 2^(αH(C)) n'entraîne pas
    H(V|C) ≥ αH(C) − 1. Contre-exemple, verdict constant, H(C) = 1 bit, α = 2. -/
def CardinalSansEfficacite : Prop :=
  ∀ (l : ℕ),
    ((Fintype.card (Fin 1) : ℝ) ≤ (2 : ℝ) ^ (2 * (famModel l).constVerdict.HC)) ∧
      (famModel l).constVerdict.HV < 2 * (famModel l).constVerdict.HC - 1

/-- Théorème 2.3 (p. 49), composition séquentielle : Conf(P₁ ∘ P₂) ≥ Conf(P₁). -/
def CompositionSequentielleConf : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {S' : Type u₄} {V : Type u₅}
    [Fintype M] [Fintype C] [Fintype S] [Fintype S'] [Fintype V]
    (X : CLOModel lam M C S V) {V' : Type u₆} [Fintype V'] (T : C → S → S' → ℝ)
    (hT : ∀ c s t, 0 ≤ T c s t) (hT1 : ∀ c s, ∑ t, T c s t = 1)
    (ker' : C → S' → V' → ℝ) (hk : ∀ c t v, 0 ≤ ker' c t v)
    (hk1 : ∀ c t, ∑ v, ker' c t v = 1) [Nonempty M] [Nonempty C],
    X.Conf ≤ (X.post T hT hT1 ker' hk hk1).Conf

/-- Théorème 2.3 (p. 49), composition séquentielle : tout décodeur de σ₂ est dominé
    par un décodeur de σ₁, d'où Relrec(P₁ ∘ P₂) ≤ Relrec(P₁). -/
def CompositionSequentielleRel : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {S' : Type u₄} {V : Type u₅}
    [Fintype M] [Fintype C] [Fintype S] [Fintype S'] [Fintype V]
    (X : CLOModel lam M C S V) {V' : Type u₆} [Fintype V'] (T : C → S → S' → ℝ)
    (hT : ∀ c s t, 0 ≤ T c s t) (hT1 : ∀ c s, ∑ t, T c s t = 1)
    (ker' : C → S' → V' → ℝ) (hk : ∀ c t v, 0 ≤ ker' c t v)
    (hk1 : ∀ c t, ∑ v, ker' c t v = 1) [DecidableEq M] [Nonempty S'] (D' : C → S' → M),
    ∃ D : C → S → M, (X.post T hT hT1 ker' hk hk1).Rel D' ≤ X.Rel D

/-- Remarque 2.5 (p. 49), opposabilité composée à verdict fixé :
    I(V;Σ₂|C) ≤ I(V;Σ₁|C) et Opp(P₁ ∘ P₂) ≤ Opp(P₁). -/
def OpposabiliteComposee : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {S' : Type u₄} {V : Type u₅}
    [Fintype M] [Fintype C] [Fintype S] [Fintype S'] [Fintype V]
    (X : CLOModel lam M C S V) (T : C → S → S' → ℝ),
    (∀ c s t, 0 ≤ T c s t) → (∀ c s, ∑ t, T c s t = 1) →
      X.IVpost T ≤ X.IV ∧ (0 < X.HV → X.IVpost T / X.HV ≤ X.Opp)

/-- Théorème 2.3 (p. 49), composition parallèle : Conf(P₁ ∥ P₂) ≤ min et tout
    décodeur d'un composant se relève avec la même fiabilité, d'où Relrec ≥ max. -/
def CompositionParallele : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S₁ : Type u₃} {S₂ : Type u₄} {V : Type u₅}
    [Fintype M] [Fintype C] [Fintype S₁] [Fintype S₂] [Fintype V]
    [DecidableEq S₁] [DecidableEq S₂] (X : CLOModel lam M C (S₁ × S₂) V)
    (k₁ : C → S₁ → V → ℝ) (hk₁ : ∀ c t v, 0 ≤ k₁ c t v) (hk₁1 : ∀ c t, ∑ v, k₁ c t v = 1)
    (k₂ : C → S₂ → V → ℝ) (hk₂ : ∀ c t v, 0 ≤ k₂ c t v) (hk₂1 : ∀ c t, ∑ v, k₂ c t v = 1)
    [DecidableEq M] [Nonempty M] [Nonempty C] (D₁ : C → S₁ → M) (D₂ : C → S₂ → M),
    X.Conf ≤ min (X.proj₁ k₁ hk₁ hk₁1).Conf (X.proj₂ k₂ hk₂ hk₂1).Conf ∧
      (X.proj₁ k₁ hk₁ hk₁1).Rel D₁ = X.Rel (fun c s => D₁ c s.1) ∧
      (X.proj₂ k₂ hk₂ hk₂1).Rel D₂ = X.Rel (fun c s => D₂ c s.2)

/-- Remarque 2.5 (p. 49), inégalité de Fréchet : ab ≥ a + b − 1 pour a, b ≤ 1. -/
def Frechet : Prop := ∀ {a b : ℝ}, a ≤ 1 → b ≤ 1 → a + b - 1 ≤ a * b

/-- Remarque 2.5 (p. 49) : pas de sous-additivité. V = B₁ ⊕ B₂ donne
    I(V;(Σ₁,Σ₂)) = log 2 alors que I(V;Σ₁) = 0. -/
def XorNonSousAdditif : Prop :=
  miN (fun (v : Fin 2) (s : Fin 2 × Fin 2) => if v = s.1 + s.2 then (1 / 4 : ℝ) else 0) =
      Real.log 2 ∧
    miN (fun (_ : Fin 2) (_ : Fin 2) => (1 / 4 : ℝ)) = 0

/-- Remarque 2.5 (p. 49) : pas de sur-additivité. Σ₁ = Σ₂ = V donne
    I(V;(Σ₁,Σ₂)) = log 2 < 2 log 2 = I(V;Σ₁) + I(V;Σ₂). -/
def CopieNonSurAdditive : Prop :=
  miN (fun (v : Fin 2) (s : Fin 2 × Fin 2) => if s.1 = v ∧ s.2 = v then (1 / 2 : ℝ) else 0) =
      Real.log 2 ∧
    miN (fun (v : Fin 2) (s : Fin 2) => if s = v then (1 / 2 : ℝ) else 0) = Real.log 2 ∧
    Real.log 2 < 2 * Real.log 2

/-- Règle de chaîne, utilisée dans les preuves de la Proposition 2.1 (p. 55) et du
    Lemme 1.3 (p. 17) : I(A;B,G) = I(A;B) + I(A;G|B). -/
def RegleDeChaine : Prop :=
  ∀ {α : Type u₁} {β : Type u₂} {γ : Type u₃} [Fintype α] [Fintype β] [Fintype γ]
    (u : α → β → γ → ℝ), (∀ a b g, 0 ≤ u a b g) →
      miN (fun a (bg : β × γ) => u a bg.1 bg.2) = miN (fun a b => ∑ g, u a b g) + condMI u

/-- Positivité de l'information mutuelle conditionnelle, I(A;G|B) ≥ 0 (preuve du
    Lemme 1.3, p. 17). -/
def InfoConditionnellePositive : Prop :=
  ∀ {α : Type u₁} {β : Type u₂} {γ : Type u₃} [Fintype α] [Fintype β] [Fintype γ]
    (u : α → β → γ → ℝ), (∀ a b g, 0 ≤ u a b g) → 0 ≤ condMI u

/-- Proposition 2.1 (p. 55), fondement informationnel de l'Hypothèse 2.1 :
    I(V;Σ|C) = I(V;M|C) + I(V;Σ|M,C) ≤ I(M;Σ|C) + I(V;Σ|M,C), et I(V;Σ|M,C) ≤ Δ
    entraîne l'extraction bornée. -/
def FondementExtraction : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] (X : CLOModel lam M C S V),
    X.IV = X.IVM + X.IVSM ∧ X.IVM ≤ X.I ∧ X.IV ≤ X.I + X.IVSM ∧
      ∀ Δ : ℝ, X.IVSM ≤ Δ → X.IV ≤ X.I + Δ

/-- Remarques 2.4 (p. 48) et 3.9 (p. 108), sur lois finies : un verdict
    déterministe donne I(V;Σ|C) = H(V|C), donc Opp = 1 dès que H(V|C) > 0. -/
def VerdictDeterministeConcret : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [DecidableEq V]
    (X : CLOModel lam M C S V) (f : C → S → V),
    (X.detVerdict f).IV = (X.detVerdict f).HV ∧
      (0 < (X.detVerdict f).HV → (X.detVerdict f).Opp = 1)

/-- Remarques 2.3 (p. 47) et 2.15 (p. 58) : le minorant 1 − √(c₀βI) décroît avec
    la fuite I et vaut 1 pour une fuite nulle. -/
def GarantieConfDecroissante : Prop :=
  ∀ {β I₁ I₂ : ℝ}, 0 ≤ β → I₁ ≤ I₂ →
    1 - Real.sqrt (c0 * β * I₂) ≤ 1 - Real.sqrt (c0 * β * I₁) ∧
      1 - Real.sqrt (c0 * β * 0) = 1

/-! ## 7. Extension v3.6, lot L5a : noyau algébrique quantique

Renvois au manuscrit v36. Ces énoncés sont démontrés dans la section 14 de
`ConditionalCRO.lean` (version 3.6). Dans le modèle abstrait quantique, Fano quantique
(Lemme 2.6, p. 71), la borne de Holevo (Lemme 2.7, p. 71) et Pinsker quantique
(Lemme 2.4, p. 70) sont des champs de `QuantumProtocolInstance`, comme Fano et Pinsker
dans le modèle abstrait classique. `QuantumAssumptions` porte les Hypothèses 2.5 à 2.7
(p. 75 et 76) ; le régime (Hypothèse 2.8, p. 76) est une prémisse. Les définitions
nouvelles sont testées dans `Coherence.lean`, section 7. -/

/-- Lemme 2.8 (p. 77), garantie de confidentialité quantique (2.108), sous l'Hypothèse 2.7 :
    Conf^q ≥ 1 − ½·√(2β_q·χmax + 2ζ_q·Dmax). -/
def GarantieConfQuantique : Prop :=
  ∀ {lam : ℕ} (P : QuantumProtocolInstance lam),
    P.Dmsg ≤ P.params.βq * P.χmax + P.params.ζq * P.Dmax →
      1 - 1 / 2 * Real.sqrt (2 * P.params.βq * P.χmax + 2 * P.params.ζq * P.Dmax) ≤ P.Conf

/-- Théorème 2.5 (p. 77), forme explicite (2.110), sous les Hypothèses 2.5, 2.6 et 2.8. -/
def TrilemmeQuantiqueExplicite : Prop :=
  ∀ {lam : ℕ} (P : QuantumProtocolInstance lam), QuantumAssumptions P →
    ∀ (κ : ℝ), 0 ≤ κ → 1 ≤ lam → P.χmax ≤ κ / lam →
      P.Conf * P.Rel * P.Opp ≤ 1 / gammaQ P.params *
        (P.params.Δq / lam + κ * (P.params.Δq + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 3)

/-- Remarque 2.41 (p. 80), la majoration publiée comme corollaire :
    produit ≤ (Δ_q + η_q·H(C))/λ + K/λ² + ε₀(λ). -/
def TrilemmeQuantiquePublie : Prop :=
  ∀ {lam : ℕ} (P : QuantumProtocolInstance lam), QuantumAssumptions P →
    ∀ (κ : ℝ), 0 ≤ κ → 1 ≤ lam → P.χmax ≤ κ / lam →
      P.Conf * P.Rel * P.Opp ≤ (P.params.Δq + P.params.ηq * P.params.H) / lam +
        (κ * (P.params.Δq + 1) + κ ^ 2) / (lam : ℝ) ^ 2 + ε₀ lam

/-- Théorème 2.5 (p. 77), forme asymptotique, pour une famille à paramètres fixes. -/
def TrilemmeQuantiqueAsymptotique : Prop :=
  ∀ (F : QuantumProtocolFamily) (κ : ℝ), 0 ≤ κ →
    (∀ lam : ℕ, 64 ≤ lam → QuantumAssumptions (F.inst lam)) →
    (∀ lam : ℕ, 64 ≤ lam → (F.inst lam).χmax ≤ κ / lam) →
      ∃ K : ℝ, ∃ ε : ℕ → ℝ, Negligible ε ∧ ∀ lam : ℕ, 64 ≤ lam →
        (F.inst lam).Conf * (F.inst lam).Rel * (F.inst lam).Opp ≤
          (F.params.Δq + F.params.ηq * F.params.H) / lam + K / (lam : ℝ) ^ 2 + ε lam

/-- Remarque 2.39 (p. 79), forme raffinée quantique (2.117). -/
def TrilemmeQuantiqueRaffine : Prop :=
  ∀ {lam : ℕ} (P : QuantumProtocolInstance lam), QuantumAssumptions P →
    ∀ (κ : ℝ), 0 ≤ κ → 1 ≤ lam → P.χmax ≤ κ / lam → P.IV ≤ P.HV →
      P.Conf * P.Rel * P.Opp ≤
        (κ / lam + 1) / lam * min 1 ((κ / lam + P.params.Δq) / gammaQ P.params)

/-- Remarque 2.39 (p. 79), seuil : facteur < 1 ⟺ Δ_q < γ_q − κ/λ ⟺ H(C) > H♯_q. -/
def SeuilHdieseQuantique : Prop :=
  ∀ (p : QuantumParams) (κ lam : ℝ), 0 < gammaQ p →
    (min 1 ((κ / lam + p.Δq) / gammaQ p) < 1 ↔ p.Δq < gammaQ p - κ / lam) ∧
      (p.Δq < gammaQ p - κ / lam ↔ (p.Δq + κ / lam) / (p.θq * p.αq) < p.H)

/-- Corollaire 2.2 (p. 80), forme simplifiée (2.118) : le rapport du majorant à
    (Δ_q + η_q·H(C))/λ tend vers 1. -/
def FormeSimplifieeQuantique : Prop :=
  ∀ (D K : ℝ), 0 < D →
    Tendsto (fun lam : ℕ => (D / lam + K / (lam : ℝ) ^ 2) / (D / lam)) atTop (nhds 1)

/-- Remarque 2.31 (p. 76) : k_λ ≤ 2^(α_q·H(C)) n'entraîne pas H(V|C) ≥ θ_q·α_q·H(C). -/
def CardinalSansEfficaciteQuantique : Prop :=
  ∀ (l : ℕ) (θq αq : ℝ), 0 < θq → 0 < αq →
    ((Fintype.card (Fin 1) : ℝ) ≤ (2 : ℝ) ^ (αq * (famModel l).constVerdict.HC)) ∧
      (famModel l).constVerdict.HV < θq * αq * (famModel l).constVerdict.HC

/-- Remarque 2.32 (p. 76), raccord γ_q = γ ⟺ θ_q = 1 − 1/(αH(C)) ∈ [1/2, 1). -/
def RaccordGammaQuantique : Prop :=
  ∀ (α H θq : ℝ), 0 < α * H →
    (θq * α * H = α * H - 1 ↔ θq = 1 - 1 / (α * H)) ∧
      (1 ≤ α * H - 1 → 1 / 2 ≤ 1 - 1 / (α * H) ∧ 1 - 1 / (α * H) < 1)

/-- Remarque 2.33 (p. 76), statut du régime quantique. -/
def StatutRegimeQuantique : Prop :=
  ∀ {lam : ℕ} (P : QuantumProtocolInstance lam) (κ : ℝ),
    P.Dmsg ≤ P.params.βq * P.χmax + P.params.ζq * P.Dmax → P.χmax ≤ κ / lam →
      P.Iacc ≤ P.I ∧ P.I ≤ κ / lam ∧
        1 - 1 / 2 * Real.sqrt (2 * P.params.βq * (κ / lam) + 2 * P.params.ζq * P.Dmax) ≤ P.Conf

/-- Remarque 2.35 (p. 77) : (ln 2)/2 < 1/2 < c₀. -/
def ConstantesPinsker : Prop := Real.log 2 / 2 < 1 / 2 ∧ (1 : ℝ) / 2 < c0

/-- Définition 2.30 (p. 75) : sans renforcement, Δ_q ≤ Δ. -/
def DecompositionDeltaQ : Prop := ∀ (Δ δdegr : ℝ), 0 ≤ δdegr → deltaQ Δ 0 δdegr ≤ Δ

/-- Définition 2.27 et Remarque 2.27 (p. 74), sur lois finies : 0 ≤ η_q ≤ log₂|V|/H(C),
    égalité dans la définition et η_q ≤ α si |V| ≤ 2^(αH(C)). -/
def EncadrementEtaQ : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {S' : Type u₄} {V : Type u₅}
    [Fintype M] [Fintype C] [Fintype S] [Fintype S'] [Fintype V] [Nonempty V]
    (X : CLOModel lam M C S V) (T : C → S → S' → ℝ),
    (∀ c s t, 0 ≤ T c s t) → (∀ c s, ∑ t, T c s t = 1) → 0 < X.HC → ∀ (α : ℝ),
      0 ≤ X.etaQ T ∧ X.IVpost T = X.IV - X.etaQ T * X.HC ∧
        X.etaQ T ≤ Real.log (Fintype.card V) / Real.log 2 / X.HC ∧
        ((Fintype.card V : ℝ) ≤ (2 : ℝ) ^ (α * X.HC) → X.etaQ T ≤ α)

/-- Remarque 2.29 (p. 74) : la DPI ne fournit pas l'Hypothèse 2.5 ; I(V;Σ|C) = 1,
    I(M;Σ|C) = 0 et I(V;Σ|M,C) = 1 dans la famille témoin. -/
def CapaciteQuantiqueHorsDPI : Prop :=
  ∀ (l : ℕ), (famModel l).I = 0 ∧ (famModel l).IV = 1 ∧
    ¬ ((famModel l).IV ≤ (famModel l).I + 0) ∧ (famModel l).IVSM = 1

/-- Remarque 2.37 (p. 79) : l'Hypothèse 2.8 est nécessaire. -/
def TemoinPorteeQuantique : Prop :=
  ∀ (lam : ℕ) (hlam : 64 ≤ lam),
    QuantumAssumptions (scopeInstanceQ lam hlam) ∧
      (scopeInstanceQ lam hlam).params.Δq = 0 ∧ (scopeInstanceQ lam hlam).params.ηq = 0 ∧
      (scopeInstanceQ lam hlam).Conf * (scopeInstanceQ lam hlam).Rel *
        (scopeInstanceQ lam hlam).Opp = 1 / 4 ∧
      (scopeInstanceQ lam hlam).χmax = lam / 2

/-- Cohérence du modèle abstrait quantique : les Hypothèses 2.5 à 2.8 sont satisfiables
    et la borne explicite du Théorème 2.5 est atteinte. -/
def TemoinCoherenceQuantique : Prop :=
  ∀ (lam : ℕ) (hlam : 1 ≤ lam),
    QuantumAssumptions (witnessInstanceQ lam hlam) ∧
      (witnessInstanceQ lam hlam).χmax ≤ 0 / lam ∧
      (witnessInstanceQ lam hlam).Conf * (witnessInstanceQ lam hlam).Rel *
        (witnessInstanceQ lam hlam).Opp =
        (witnessInstanceQ lam hlam).params.Δq / (gammaQ (witnessInstanceQ lam hlam).params * lam)

/-- Remarque 2.36 (p. 77) : D_max ≥ 25 960 bits pour ML-DSA-65. -/
def DmaxMLDSA : Prop :=
  ∀ (lam Hs : ℝ), lam ≤ 256 → Hs ≤ lam + 256 → (25960 : ℝ) ≤ 3309 * 8 - Hs

/-! ## 8. Extension v3.7, lot L2 : bornes avancées

Renvois au manuscrit v36. Énoncés démontrés dans la section 16 de
`ConditionalCRO.lean` (version 3.7). -/

/-- Proposition 2.2 (p. 62), étapes 1 à 3 de la preuve sur lois finies : avec
    p = Rel(D), I(M;Σ|C)·ln 2 ≥ p·λ·ln 2 + p·ln p − p. -/
def FanoAigu : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] (X : CLOModel lam M C S V)
    [DecidableEq M] [Nonempty M] (D : C → S → M),
    X.Rel D * lam * Real.log 2 + X.Rel D * Real.log (X.Rel D) - X.Rel D ≤ X.I * Real.log 2

/-- Proposition 2.2 (p. 62), borne aiguë (2.61) :
    Rel(D) ≤ 2κ/(λ(λ−3)) + 2^(−λ/2) sous le régime, pour λ ≥ 4. -/
def BorneAigue : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [DecidableEq M] [Nonempty M]
    (X : CLOModel lam M C S V) (D : C → S → M) (κ : ℝ),
    0 ≤ κ → 4 ≤ lam → X.I ≤ κ / lam →
      X.Rel D ≤ 2 * κ / ((lam : ℝ) * (lam - 3)) + (2 : ℝ) ^ (-(lam : ℝ) / 2)

/-- Proposition 2.2 (p. 62), produit (2.62) sous les Hypothèses 2.1, 2.2 et 2.4. -/
def TrilemmeAigu : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [DecidableEq M] [Nonempty M]
    [Nonempty C] (X : CLOModel lam M C S V) (D : C → S → M) (Δ α κ : ℝ),
    0 ≤ κ → 4 ≤ lam → X.IV ≤ X.I + Δ → α * X.HC - 1 ≤ X.HV → 1 ≤ α * X.HC - 1 →
      X.I ≤ κ / lam →
      X.Conf * X.Rel D * X.Opp ≤
        (2 * κ / ((lam : ℝ) * (lam - 3)) + (2 : ℝ) ^ (-(lam : ℝ) / 2)) *
          min 1 ((κ / lam + Δ) / (α * X.HC - 1))

/-- Théorème 2.4 (p. 58), dernière phrase, sur lois finies :
    Conf ≥ 1 − √(c₀βκ/λ) sous l'Hypothèse 2.3 et le régime. -/
def ConfRegimeConcret : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [DecidableEq M] [Nonempty M]
    [Nonempty C] (X : CLOModel lam M C S V) (β κ : ℝ), 1 ≤ β →
    ∀ (_ : C → S → M), X.CommonSupport → X.KLmax ≤ β * X.I → X.I ≤ κ / lam →
      1 - Real.sqrt (c0 * β * (κ / lam)) ≤ X.Conf

/-- Théorème 2.4 (p. 58), dernière phrase, modèle abstrait. -/
def ConfRegime : Prop :=
  ∀ {lam : ℕ} (P : ProtocolInstance lam) (κ : ℝ),
    P.KLmax ≤ P.params.β * P.I → P.I ≤ κ / lam →
      1 - Real.sqrt (c0 * P.params.β * (κ / lam)) ≤ P.Conf

/-- Corollaire 2.1 (p. 64), forme simplifiée, et valeur 1 + 7/640 pour κ = 1, Δ = 5,
    λ = 128. -/
def FormeSimplifiee : Prop :=
  ∀ (Δ K : ℝ), 0 < Δ →
    Tendsto (fun lam : ℕ => (Δ / lam + K / (lam : ℝ) ^ 2) / (Δ / lam)) atTop (nhds 1) ∧
      ((5 : ℝ) / 128 + 7 / 128 ^ 2) / (5 / 128) = 1 + 7 / 640 ∧
      (1.010 : ℝ) < 1 + 7 / 640 ∧ (1 : ℝ) + 7 / 640 < 1.011

/-- Remarque 2.24 (p. 65), portée des études de cas. -/
def PorteeCasEtude : Prop :=
  ((1 : ℝ) + 1 / 128) / 128 = 129 / 128 ^ 2 ∧ (129 : ℝ) / 128 ^ 2 < 0.008 ∧
    ∀ lam κ : ℝ, 0 < lam → (κ / lam < lam ↔ κ < lam ^ 2)

/-- Remarque 5.5 (p. 185) et Remarque 2.19 (p. 62), ordre des bornes : λ⁻¹ pour la
    forme explicite, λ⁻² pour la borne aiguë. -/
def BorneForteStatut : Prop :=
  ∀ (Δ γ κ : ℝ), 0 ≤ κ →
    (∀ lam : ℝ, 0 < lam → lam * (Δ / (γ * lam)) = Δ / γ) ∧
      ∀ n : ℕ, 16 ≤ n →
        2 * κ / ((n : ℝ) * (n - 3)) + (2 : ℝ) ^ (-(n : ℝ) / 2) ≤ (4 * κ + 1) / (n : ℝ) ^ 2

/-- Remarque 2.40 (p. 80), borne aiguë dans le cadre quantique. -/
def TrilemmeAiguQuantique : Prop :=
  ∀ {lam : ℕ} (P : QuantumSharpInstance lam), QuantumAssumptions P.toQuantumProtocolInstance →
    ∀ (κ : ℝ), 0 ≤ κ → 4 ≤ lam → P.χmax ≤ κ / lam → P.IV ≤ P.HV →
      P.Rel ≤ 2 * κ / ((lam : ℝ) * (lam - 3)) + (2 : ℝ) ^ (-(lam : ℝ) / 2) ∧
        P.Conf * P.Rel * P.Opp ≤ (2 * κ / ((lam : ℝ) * (lam - 3)) + (2 : ℝ) ^ (-(lam : ℝ) / 2)) *
          min 1 ((κ / lam + P.params.Δq) / gammaQ P.params)

/-- Remarque 2.20 (p. 63), témoin réalisable du facteur institutionnel : pour tous
    entiers Δ ≤ γ avec γ ≥ 1, une loi finie satisfait les Hypothèses 2.1 à 2.4
    (α = 1, β = 1, κ = 0) avec Conf = 1 et Opp = Δ/γ. -/
def TemoinRealisable : Prop :=
  ∀ (l d g : ℕ), d ≤ g → 1 ≤ g →
    (Fintype.card (Fin (2 ^ d) × Fin (2 ^ (g - d))) : ℝ) ≤ (2 : ℝ) ^ (1 * (witModel l d g).HC) ∧
      (witModel l d g).IV = (witModel l d g).I + d ∧
      1 * (witModel l d g).HC - 1 ≤ (witModel l d g).HV ∧
      1 ≤ 1 * (witModel l d g).HC - 1 ∧
      (witModel l d g).KLmax ≤ 1 * (witModel l d g).I ∧
      (witModel l d g).I ≤ 0 / l ∧
      (witModel l d g).Conf = 1 ∧
      (witModel l d g).Opp = d / g


/-! ## 9. Extension v3.8, lot L3 : jeux et ponts vers les métriques

Renvois au manuscrit v36. Énoncés démontrés dans la section 18 de
`ConditionalCRO.lean` (version 3.8). Les adversaires sont des fonctions sur des
ensembles finis, leur aléa propre étant moyenné. -/

/-- Définitions 2.5 (p. 50) et A.5 (p. 222), jeu IND-CONF : la probabilité de succès
    vaut ½ + avantage, avec avantage ½·Σ (P₀ − P₁)·a. -/
def JeuINDConf : Prop :=
  ∀ {α : Type u₁} [Fintype α] (P₀ P₁ a : α → ℝ), ∑ x, P₁ x = 1 →
    succIND P₀ P₁ a = 1 / 2 + advDist P₀ P₁ a

/-- Remarque 2.6 (p. 50), preuve : tout test, même non borné en calcul, a un avantage
    au plus égal à la moitié de la variation totale. -/
def AvantageTest : Prop :=
  ∀ {α : Type u₁} [Fintype α] (P₀ P₁ a : α → ℝ), (∀ x, 0 ≤ a x ∧ a x ≤ 1) →
    advDist P₀ P₁ a ≤ tv P₀ P₁ / 2

/-- Remarque 2.6 (p. 50), égalité pour le test de Neyman-Pearson. -/
def NeymanPearson : Prop :=
  ∀ {α : Type u₁} [Fintype α] (P₀ P₁ : α → ℝ),
    advDist P₀ P₁ (fun x => if P₁ x < P₀ x then (1 : ℝ) else 0) = tv P₀ P₁ / 2

/-- Remarques 2.6 (p. 50) et A.1 (p. 222), pont IND-CONF ↔ Conf :
    Adv^IND-CONF ≤ (1 − Conf)/2 pour tout distingueur. -/
def PontINDConf : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [Nonempty M] [Nonempty C]
    (X : CLOModel lam M C S V) (c : C) (m₀ m₁ : M) (a : S → ℝ),
    (∀ s, 0 ≤ a s ∧ a s ≤ 1) → advDist (X.qS c m₀) (X.qS c m₁) a ≤ (1 - X.Conf) / 2

/-- Remarque 2.6 (p. 50), la réciproque fait défaut : des lois de supports disjoints
    ont une variation totale égale à 1. -/
def ReciproqueINDConf : Prop :=
  ∀ {α : Type u₁} [Fintype α] (P Q : α → ℝ), (∀ x, 0 ≤ P x) → (∀ x, 0 ≤ Q x) →
    ∑ x, P x = 1 → (∀ x, P x = 0 ∨ Q x = 0) → tv P Q = 1

/-- Définitions 2.6 (p. 51) et A.6 (p. 223), jeu BIND-REL : le gain est une probabilité. -/
def JeuBINDRel : Prop :=
  ∀ {Ω : Type u₁} {M : Type u₂} [Fintype Ω] [DecidableEq M] (μ : Ω → ℝ),
    (∀ ω, 0 ≤ μ ω) → ∑ ω, μ ω = 1 → ∀ (acc : Ω → Bool) (o₀ o₁ : Ω → Option M),
      0 ≤ winBindRel μ acc o₀ o₁ ∧ winBindRel μ acc o₀ o₁ ≤ 1

/-- Remarques 2.7 (p. 51) et A.2 (p. 223), pont BIND-REL ↔ Relver :
    Relver ≥ 1 − ε_bind − ν, où ν est le défaut de complétude. -/
def PontBINDRel : Prop :=
  ∀ (compl winBind ν εb : ℝ), 1 - ν ≤ compl → winBind ≤ εb → 1 - εb - ν ≤ relver compl winBind

/-- Remarque 2.7 (p. 51), preuve : une ouverture parfaitement liante annule le gain
    BIND-REL et Relver se réduit à la complétude. -/
def OuvertureLiante : Prop :=
  ∀ {Ω : Type u₁} {M : Type u₂} [Fintype Ω] [DecidableEq M] (μ : Ω → ℝ) (acc : Ω → Bool)
    (o₀ o₁ : Ω → Option M) (compl : ℝ), 0 ≤ compl →
    (∀ ω, acc ω = true → o₀ ω ≠ none → o₁ ω ≠ none → o₀ ω = o₁ ω) →
      winBindRel μ acc o₀ o₁ = 0 ∧ relver compl (winBindRel μ acc o₀ o₁) = compl

/-- Remarques 2.2 (p. 45), 2.7 (p. 51) et A.2 (p. 223) : Conf = 1 entraîne
    Relrec = 2^(−λ) pour tout décodeur. -/
def RelrecConfUn : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [DecidableEq M] [Nonempty M] [Nonempty C]
    (X : CLOModel lam M C S V), X.Conf = 1 → ∀ D : C → S → M, X.Rel D = 1 / (2 : ℝ) ^ lam

/-- Lemme A.1 (p. 221), inégalité de Fano (nats) :
    H(A|B) ≤ h(ε) + ε·log(|A| − 1) pour tout estimateur g, avec ε = Pr[g(B) ≠ A]. -/
def FanoGeneral : Prop :=
  ∀ {α : Type u₁} {β : Type u₂} [Fintype α] [Fintype β] [DecidableEq α] (w : α → β → ℝ),
    (∀ a b, 0 ≤ w a b) → ∑ a, ∑ b, w a b = 1 → ∀ g : β → α,
      condEnt w ≤ binEntN (1 - ∑ b, w (g b) b) +
        (1 - ∑ b, w (g b) b) * Real.log ((Fintype.card α : ℝ) - 1)

/-- Remarque 2.8 (p. 52), étape de la preuve : I(V;Σ|C) = H(V|C) − H(V|Σ,C). -/
def InfoVerdictResidu : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] (X : CLOModel lam M C S V),
    X.IV = X.HV - X.HVSC

/-- Définitions 2.7 (p. 51) et A.7 (p. 224), Remarques 2.8 (p. 52) et A.3 (p. 224),
    pont EXT-OPP ↔ Opp : Opp ≥ 1 − (h(ε) + ε·log(|V| − 1))/(H(V|C)·ln 2) pour tout
    interprète qui lit (C, Σ), d'erreur ε. -/
def PontEXTOpp : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] (X : CLOModel lam M C S V)
    [DecidableEq V] (f : C → S → V), 0 < X.HV →
      1 - (binEntN (X.extErr f) + X.extErr f * Real.log ((Fintype.card V : ℝ) - 1)) /
        (X.HV * Real.log 2) ≤ X.Opp

/-- Remarques 2.8 (p. 52) et A.3 (p. 224), forme générale avec les ressources K :
    Opp ≥ 1 − (F + I(V;K|Σ,C))/H(V|C). -/
def PontEXTOppRessources : Prop :=
  ∀ (Opp HV HVSC HVSCK IVK F : ℝ), 0 < HV → Opp = 1 - HVSC / HV → HVSC = HVSCK + IVK →
    HVSCK ≤ F → 1 - (F + IVK) / HV ≤ Opp

/-- Corollaire A.2 (p. 229), produit CLO depuis les jeux, et minoration
    (1 − a)(1 − b)(1 − c) ≥ 1 − a − b − c. -/
def ProduitJeux : Prop :=
  ∀ (Cc Rv Op εi εb L : ℝ), εi ≤ 1 / 2 → εb ≤ 1 → 0 ≤ L →
    1 - 2 * εi ≤ Cc → 1 - εb ≤ Rv → L ≤ Op →
    (1 - 2 * εi) * (1 - εb) * L ≤ Cc * Rv * Op ∧
      ∀ a b c : ℝ, 0 ≤ a → a ≤ 1 → 0 ≤ b → b ≤ 1 → 0 ≤ c → c ≤ 1 →
        1 - a - b - c ≤ (1 - a) * (1 - b) * (1 - c)

/-- Remarque A.6 (p. 230), deux échelles distinctes : pour Conf = 1, Conf·Rel·Opp = Opp/2^λ
    pour tout décodeur, alors que Conf·Relver·Opp = Opp pour une complétude 1 et une
    ouverture liante. -/
def EchellesDistinctes : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [DecidableEq M] [Nonempty M] [Nonempty C]
    (X : CLOModel lam M C S V), X.Conf = 1 →
      (∀ D : C → S → M, X.Conf * X.Rel D * X.Opp = X.Opp / (2 : ℝ) ^ lam) ∧
        X.Conf * relver 1 0 * X.Opp = X.Opp


/-! ## 10. Extension v3.9, lot L5b : encodage classique diagonal

Renvois au manuscrit v36. Énoncés démontrés dans la section 20 de
`ConditionalCRO.lean` (version 3.9). Un état diagonal ρ = Σ_s p(s)|s⟩⟨s| est la
matrice complexe `diagState p` ; son spectre est tiré du polynôme caractéristique. -/

/-- Remarques 2.9 (p. 53) et 2.26 (p. 73) : pour deux états diagonaux de même masse,
    ½‖ρ_p − ρ_q‖₁ = TV(p, q). -/
def DistanceTraceTV : Prop :=
  ∀ {S : Type u₁} [Fintype S] [DecidableEq S] (p q : S → ℝ), ∑ s, p s = ∑ s, q s →
    traceDistDiag p q = tv p q

/-- Remarques 2.9 (p. 53) et 2.26 (p. 73) : en encodage diagonal, Conf^q = Conf. -/
def ConfQuantiqueDiagonale : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] (X : CLOModel lam M C S V)
    [DecidableEq S] [Nonempty C] [Nonempty M], X.ConfQdiag = X.Conf

/-- Remarque 2.25 (p. 70) : pour ρ = Σ_x P_X(x)|x⟩⟨x|, S(ρ) = H(X). -/
def VonNeumannShannon : Prop :=
  ∀ {S : Type u₁} [Fintype S] [DecidableEq S] (p : S → ℝ),
    vonNeumann (diagState p) (diagState_isHermitian p) = shannon p

/-- Remarque 2.34 (p. 76), cas limite de l'inégalité (68) de la version publiée :
    pour deux états orthogonaux équiprobables (λ = 1), la mesure dans la base
    calculatoire porte 1 bit sur M, alors que le membre de droite de (68) vaut 1/2. -/
def CasLimiteLemme6 : Prop :=
  miN mesureBase / Real.log 2 = 1 ∧
    (1 / 4 : ℝ) * ∑ m₀ : Bool, ∑ m₁ : Bool, ((1 : ℝ) / 2) *
      traceNorm (diagState (ketBit m₀) - diagState (ketBit m₁))
        (diagState_sub_isHermitian _ _) = 1 / 2 ∧
    (1 / 2 : ℝ) < 1


/-! ## 11. Extension v3.10, lot L4 : construction S-OTP

Renvois au manuscrit v36. Énoncés démontrés dans la section 22 de
`ConditionalCRO.lean` (version 3.10). -/

/-- Théorème 3.1 (p. 89), confidentialité, première étape : avec un masque uniforme,
    TV(P_{M*|M=m₀}, P_{M*|M=m₁}) = 0. -/
def MasqueUniforme : Prop :=
  ∀ {G : Type u₁} [AddCommGroup G] [Fintype G] [DecidableEq G] (m₀ m₁ : G),
    tv (maskLaw m₀) (maskLaw m₁) = 0

/-- Théorème 3.1 (p. 89), confidentialité : si la loi de Σ sachant (M, C) ne dépend pas
    de M, alors Conf = 1. -/
def ConfSOTP : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] (X : CLOModel lam M C S V)
    [Nonempty M] [Nonempty C], (∀ c m₀ m₁ s, X.qS c m₀ s = X.qS c m₁ s) → X.Conf = 1

/-- Théorème 3.1 (p. 89), opposabilité : si l'interprète ne lit la preuve qu'à travers
    la composante auxiliaire h, alors I(V;Σ|C) ≤ H(h|C) et Opp ≤ H(h|C)/H(V|C). -/
def OppSOTP : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] (X : CLOModel lam M C S V)
    [Nonempty S] {τ : Type u₅} [Fintype τ] [DecidableEq τ] (h : C → S → τ)
    (k : C → τ → V → ℝ), (∀ c t v, 0 ≤ k c t v) → (∀ c t, ∑ v, k c t v = 1) →
    (∀ c s v, X.ker c s v = k c (h c s) v) → 0 < X.HV →
      X.IV ≤ X.HT h ∧ X.Opp ≤ X.HT h / X.HV

/-- Remarque 3.2 (p. 89) : si h est une fonction du contexte public, H(h|C) = 0 et
    Opp = 0. -/
def OppSOTPPublic : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] (X : CLOModel lam M C S V)
    [DecidableEq M] [Nonempty M] [Nonempty S] {τ : Type u₅} [Fintype τ] [DecidableEq τ]
    (φ : C → τ) (k : C → τ → V → ℝ), (∀ c t v, 0 ≤ k c t v) → (∀ c t, ∑ v, k c t v = 1) →
    (∀ c s v, X.ker c s v = k c (φ c) v) → 0 < X.HV →
      X.HT (fun c _ => φ c) = 0 ∧ X.Opp = 0


/-! ## 12. Extension v3.11, lot L6 : protocoles de mesure et tableaux

Renvois au manuscrit v36. Énoncés démontrés dans la section 24 de
`ConditionalCRO.lean` (version 3.11). Les énoncés de la Proposition 4.1 portent sur une
valeur fixée de (M, C) et passent à la moyenne. -/

/-- Proposition 4.1 (p. 129), seconde inégalité pour deux traits indépendants :
    I(V;T₁) + I(V;T₂) ≤ I(V;T₁,T₂). -/
def TraitsSuperadditif : Prop :=
  ∀ {ν : Type u₁} {τ₁ : Type u₂} {τ₂ : Type u₃} [Fintype ν] [Fintype τ₁] [Fintype τ₂]
    (u : ν → τ₁ → τ₂ → ℝ), (∀ v t₁ t₂, 0 ≤ u v t₁ t₂) →
    (∀ t₁ t₂, ∑ v, u v t₁ t₂ = (∑ v, ∑ t₂', u v t₁ t₂') * (∑ v, ∑ t₁', u v t₁' t₂)) →
    miN (fun v t₁ => ∑ t₂, u v t₁ t₂) + miN (fun v t₂ => ∑ t₁, u v t₁ t₂) ≤
      miN (fun v (t : τ₁ × τ₂) => u v t.1 t.2)

/-- Proposition 4.1 (p. 129), première inégalité : I(g(V);T) ≤ I(V;T). -/
def TraitStatistique : Prop :=
  ∀ {ν : Type u₁} {ν' : Type u₂} {τ : Type u₃} [Fintype ν] [Fintype ν'] [Fintype τ]
    [DecidableEq ν'] (w : ν → τ → ℝ), (∀ v t, 0 ≤ w v t) → ∀ g : ν → ν',
    miN (fun v' t => ∑ v, if g v = v' then w v t else 0) ≤ miN w

/-- Proposition 4.1 (p. 129), dernière inégalité : I(V;T(Σ)) ≤ I(V;Σ). -/
def TraitFonctionPreuve : Prop :=
  ∀ {ν : Type u₁} {σ : Type u₂} {τ : Type u₃} [Fintype ν] [Fintype σ] [Fintype τ]
    [DecidableEq τ] (w : ν → σ → ℝ), (∀ v s, 0 ≤ w v s) → ∀ T : σ → τ,
    miN (fun v t => ∑ s, if T s = t then w v s else 0) ≤ miN w

/-- Proposition 4.1 (p. 129), borne de k bits : un trait binaire porte au plus 1 bit. -/
def TraitBinaire : Prop :=
  ∀ {ν : Type u₁} [Fintype ν] (w : ν → Bool → ℝ), (∀ v t, 0 ≤ w v t) →
    ∑ v, ∑ t, w v t = 1 → miN w / Real.log 2 ≤ 1

/-- Remarque 4.2 (p. 129) : I(V;Σ|M,C) ≥ I(V;Σ|C) − I(M;Σ|C), égalité si I(M;Σ|C) = 0. -/
def EstimateurMasquant : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] (X : CLOModel lam M C S V),
    X.IV - X.I ≤ X.IVSM ∧ (X.I = 0 → X.IVSM = X.IV)

/-- Définition 4.1 (p. 127), formulation initiale de l'estimateur : la différence
    I(V;Σ|C) − I(M;Σ|C) est au plus αH(C) − (Rel·λ − 1), minore Δ, et devient négative
    dès que αH(C) < Rel·λ − 1. -/
def EstimateurInitial : Prop :=
  ∀ (IV I αH Rel lam Δ : ℝ), IV ≤ αH → Rel * lam - 1 ≤ I → IV ≤ I + Δ →
    IV - I ≤ αH - (Rel * lam - 1) ∧ IV - I ≤ Δ ∧ (αH < Rel * lam - 1 → IV - I < 0)

/-- Définition 4.1 (p. 127), exemple : αH(C) = 20, Rel = 1, λ = 128 donnent −107. -/
def EstimateurInitialExemple : Prop :=
  (20 : ℝ) - (1 * 128 - 1) = -107 ∧ (20 : ℝ) < 1 * 128 - 1

/-- Tableaux 2.2 (p. 67) et 4.18 (p. 151) : Δ := λ·produit avec λ = 128. -/
def CalibrationDelta : Prop :=
  |128 * (0.437 : ℝ) - 56| < 1 / 2 ∧ |128 * (0.572 : ℝ) - 73| < 1 / 2 ∧
    |128 * (0.273 : ℝ) - 35| < 1 / 2 ∧ |(30 : ℝ) / 128 - 0.234| < 1 / 1000

/-- Tableaux 4.13 (p. 149) et 4.12 (p. 148) : totaux de la décomposition de Δ. -/
def DecompositionDelta : Prop :=
  (15 + 10 + 10 + 0 : ℝ) = 35 ∧ (15 + 20 + 15 + 6 : ℝ) = 56 ∧ (25 + 20 + 15 + 13 : ℝ) = 73 ∧
    (25 + 20 + 15 + 15 + 10 + 15 : ℝ) = 100

/-- Tableau 4.2 (p. 126) : γ̂ = 19, 1 et 1,97, et H♯ = 47,5 bits pour Helios. -/
def ParametresReference : Prop :=
  (1 : ℝ) * 20 - 1 = 19 ∧ (0.25 : ℝ) * 8 - 1 = 1 ∧ (0.27 : ℝ) * 11 - 1 = 1.97 ∧
    ((56 : ℝ) + 1) / 1.2 = 47.5

/-! ## 13. Extension v3.12, lot L7 : atteinte de la borne aiguë et k traits

Renvois au manuscrit v36. Énoncés démontrés dans la section 26 de
`ConditionalCRO.lean` (version 3.12). -/

/-- Remarques 2.19 (p. 62) et 2.21 (p. 63) : pour Δ ≤ γ, γ ≥ 1, λ ≥ 1 et
    λ²·2^(−λ) ≤ κ ≤ λ², le protocole qui révèle M avec probabilité ρ ≤ κ/λ² satisfait
    les Hypothèses 2.1, 2.2 et 2.4 ; sa fiabilité optimale vaut κ/λ², Conf = 1 − ρ,
    Opp = Δ/γ et le produit vaut (1 − ρ)·(κ/λ²)·(Δ/γ). -/
def BorneAigueAtteinte : Prop :=
  ∀ (l d g : ℕ) (κ : ℝ), 1 ≤ l → d ≤ g → 1 ≤ g →
    (l : ℝ) ^ 2 / (2 : ℝ) ^ l ≤ κ → κ ≤ (l : ℝ) ^ 2 →
    ∃ (ρ : ℝ) (h0 : 0 ≤ ρ) (h1 : ρ ≤ 1), ρ ≤ κ / (l : ℝ) ^ 2 ∧
      (Fintype.card (Fin (2 ^ d) × Fin (2 ^ (g - d))) : ℝ) ≤
        (2 : ℝ) ^ (1 * (rhoModel l d g ρ h0 h1).HC) ∧
      (rhoModel l d g ρ h0 h1).IV ≤ (rhoModel l d g ρ h0 h1).I + d ∧
      1 * (rhoModel l d g ρ h0 h1).HC - 1 ≤ (rhoModel l d g ρ h0 h1).HV ∧
      1 ≤ 1 * (rhoModel l d g ρ h0 h1).HC - 1 ∧
      (rhoModel l d g ρ h0 h1).I ≤ κ / l ∧
      (rhoModel l d g ρ h0 h1).Rel (CLOModel.decRho l d g) = κ / (l : ℝ) ^ 2 ∧
      (∀ D, (rhoModel l d g ρ h0 h1).Rel D ≤ κ / (l : ℝ) ^ 2) ∧
      (rhoModel l d g ρ h0 h1).Conf = 1 - ρ ∧
      (rhoModel l d g ρ h0 h1).Opp = d / g ∧
      (rhoModel l d g ρ h0 h1).Conf * (rhoModel l d g ρ h0 h1).Rel (CLOModel.decRho l d g) *
        (rhoModel l d g ρ h0 h1).Opp = (1 - ρ) * (κ / (l : ℝ) ^ 2) * (d / g)

/-- Remarques 2.19 et 2.21, valeurs numériques : pour κ ∈ {1, 4} et λ ∈ {64, 128, 256},
    la borne aiguë vaut entre 2,02 et 2,11 fois le produit si Δ = γ = 1, entre 2,02 et
    2,13 fois si (Δ, γ) ∈ {(5, 19), (10, 40)}. -/
def RapportsBorneAigue : Prop :=
  ∀ (κ k : ℕ), (κ = 1 ∨ κ = 4) → (k = 32 ∨ k = 64 ∨ k = 128) →
    (2.02 * produitTemoin (2 * k) κ 1 1 ≤ borneAigue (2 * k) κ 1 1 ∧
      borneAigue (2 * k) κ 1 1 ≤ 2.11 * produitTemoin (2 * k) κ 1 1) ∧
    (2.02 * produitTemoin (2 * k) κ 5 19 ≤ borneAigue (2 * k) κ 5 19 ∧
      borneAigue (2 * k) κ 5 19 ≤ 2.13 * produitTemoin (2 * k) κ 5 19) ∧
    (2.02 * produitTemoin (2 * k) κ 10 40 ≤ borneAigue (2 * k) κ 10 40 ∧
      borneAigue (2 * k) κ 10 40 ≤ 2.13 * produitTemoin (2 * k) κ 10 40)

/-- Remarque 2.19 (p. 62), Hypothèse 2.3 : pour κ ∈ {1, 4} et λ ∈ {64, 128, 256}, le
    témoin a des supports communs et vérifie KLmax ≤ 1,03·I. -/
def RegulariteTemoin : Prop :=
  ∀ (d g κ j : ℕ), (κ = 1 ∨ κ = 4) → (j = 6 ∨ j = 7 ∨ j = 8) →
    ∃ (h0 : 0 ≤ CLOModel.rhoOf (2 ^ j) ((κ : ℝ) / ((2 ^ j : ℕ) : ℝ) ^ 2))
      (h1 : CLOModel.rhoOf (2 ^ j) ((κ : ℝ) / ((2 ^ j : ℕ) : ℝ) ^ 2) ≤ 1),
      (rhoModel (2 ^ j) d g _ h0 h1).CommonSupport ∧
        (rhoModel (2 ^ j) d g _ h0 h1).KLmax ≤ 1.03 * (rhoModel (2 ^ j) d g _ h0 h1).I

/-- Proposition 4.1 (p. 129), seconde inégalité pour k traits mutuellement
    indépendants : ∑_j I(V;T_j) ≤ I(V;T). -/
def TraitsSuperadditifK : Prop :=
  ∀ {ν : Type u₁} {τ : Type u₂} [Fintype ν] [Fintype τ] [DecidableEq τ]
    (k : ℕ) (u : ν → (Fin k → τ) → ℝ), (∀ v t, 0 ≤ u v t) →
    ∀ (q : Fin k → τ → ℝ), (∀ j, ∑ x, q j x = 1) →
    (∀ t, ∑ v, u v t = ∏ j, q j (t j)) →
    ∑ j, miN (margTrait u j) ≤ miN u

/-- Proposition 4.1 (p. 129), les trois inégalités pour k traits fonctions de la
    preuve : ∑_j I(g_j(V);T_j) ≤ ∑_j I(V;T_j) ≤ I(V;T) ≤ I(V;Σ). -/
def MinorantTraits : Prop :=
  ∀ {ν : Type u₁} {ν' : Type u₂} {σ : Type u₃} {τ : Type u₄} [Fintype ν] [Fintype ν']
    [Fintype σ] [Fintype τ] [DecidableEq τ] [DecidableEq ν'] (k : ℕ) (w : ν → σ → ℝ),
    (∀ v s, 0 ≤ w v s) → ∀ (T : σ → Fin k → τ) (q : Fin k → τ → ℝ),
    (∀ j, ∑ x, q j x = 1) →
    (∀ t, ∑ v, ∑ s, (if T s = t then w v s else 0) = ∏ j, q j (t j)) →
    ∀ g : Fin k → ν → ν',
    ∑ j, miN (fun v' x => ∑ v, if g j v = v' then
        margTrait (fun v t => ∑ s, if T s = t then w v s else 0) j v x else 0) ≤
      ∑ j, miN (margTrait (fun v t => ∑ s, if T s = t then w v s else 0) j) ∧
    ∑ j, miN (margTrait (fun v t => ∑ s, if T s = t then w v s else 0) j) ≤
      miN (fun v t => ∑ s, if T s = t then w v s else 0) ∧
    miN (fun v t => ∑ s, if T s = t then w v s else 0) ≤ miN w

/-- Proposition 4.1 (p. 129), borne de k bits pour k traits binaires. -/
def MinorantKBits : Prop :=
  ∀ {ν : Type u₁} [Fintype ν] (k : ℕ) (u : ν → (Fin k → Bool) → ℝ),
    (∀ v t, 0 ≤ u v t) → ∑ v, ∑ t, u v t = 1 →
    (∑ j, miN (margTrait u j)) / Real.log 2 ≤ k

/-! ## 14. Extension v3.13, lot L8a : trilemme quantique pour l'encodage diagonal

Énoncés démontrés dans la section 28 de `ConditionalCRO.lean` (version 3.13). L'état de
la preuve pour (m, c) est ρ = Σ_s P(s|m,c)|s⟩⟨s|. -/

/-- Remarque 2.33 (p. 76), encodage diagonal : I(M;Σ|C) ≤ χmax. -/
def MoyenneMaxDiagonal : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [Nonempty C] (X : CLOModel lam M C S V),
    X.I ≤ X.chiMax

/-- Lemme 2.4 (p. 70), Pinsker quantique pour des états diagonaux, en nats :
    TDmax² ≤ D/2, sous des supports communs. -/
def PinskerQuantiqueDiagonal : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [Nonempty M] [Nonempty C]
    (X : CLOModel lam M C S V), X.CommonSupport →
    X.TVmax ^ 2 ≤ X.KLmax * Real.log 2 / 2

/-- Théorème 2.5 (p. 77), forme explicite, pour l'encodage diagonal et sans hypothèse
    posée : sous les Hypothèses 2.5 à 2.8, Conf^q·Rel^q·Opp^q ≤
    (1/γ_q)(Δ_q/λ + κ(Δ_q+1)/λ² + κ²/λ³). -/
def TrilemmePQDiagonal : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [DecidableEq M] [DecidableEq S]
    [Nonempty M] [Nonempty C] [Nonempty S] (X : CLOModel lam M C S V) (D : C → S → M)
    (p : QuantumParams), X.CommonSupport →
    X.IV ≤ X.I + p.Δq → gammaQ p ≤ X.HV → 1 ≤ gammaQ p →
    X.KLmax * Real.log 2 ≤ p.βq * X.chiMax + p.ζq * X.DmaxDiag →
    ∀ κ : ℝ, 0 ≤ κ → 1 ≤ lam → X.chiMax ≤ κ / lam →
    X.ConfQdiag * X.Rel D * X.Opp ≤ (1 / gammaQ p) *
      (p.Δq / lam + κ * (p.Δq + 1) / (lam : ℝ) ^ 2 + κ ^ 2 / (lam : ℝ) ^ 3)

/-- Lemme 2.8 (p. 77) pour l'encodage diagonal, sans hypothèse posée. -/
def ConfGuaranteeDiagonal : Prop :=
  ∀ {lam : ℕ} {M : Type u₁} {C : Type u₂} {S : Type u₃} {V : Type u₄}
    [Fintype M] [Fintype C] [Fintype S] [Fintype V] [DecidableEq M] [DecidableEq S]
    [Nonempty M] [Nonempty C] [Nonempty S] (X : CLOModel lam M C S V) (_D : C → S → M)
    (p : QuantumParams), X.CommonSupport →
    X.KLmax * Real.log 2 ≤ p.βq * X.chiMax + p.ζq * X.DmaxDiag →
    1 - (1 / 2) * Real.sqrt (2 * p.βq * X.chiMax + 2 * p.ζq * X.DmaxDiag) ≤ X.ConfQdiag

end Enonces
