/-
  Dossier de vérification. Fichier des énoncés seuls
  ===================================================
  Ce fichier ne contient AUCUNE preuve. Chaque énoncé de la thèse y est écrit
  sous la forme `def NomEnonce : Prop := ...`, dans sa forme générale.
  Le fichier `Principal.lean` relie chaque énoncé au théorème existant de
  `ConditionalCRO.lean` (version 3.4). Tout écart entre l'énoncé écrit ici et le
  théorème démontré empêche la compilation de `Principal.lean`.

  Renvois : manuscrit v35 (« Aux fondements de la cryptographie
  institutionnelle »), numéro et page imprimée, d'après index_labels_v35.tsv.
  « Code B.1 » désigne le listing complet de l'annexe B (p. 239 à 266). Il
  reproduit `ConditionalCRO.lean` sans les quatre lignes d'auteurs de
  l'en-tête, si bien que la ligne n du listing est la ligne n + 4 du fichier.

  Importation. Les définitions et les preuves de la version 3.4 sont dans un
  seul fichier, que l'on ne modifie pas. Ce fichier importe donc le module
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

end Enonces
