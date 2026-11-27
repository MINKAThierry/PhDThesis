/-
  Dossier de vérification. Tests de cohérence des définitions propres
  ===================================================================
  Une définition propre peut être vide ou triviale, ce qui rendrait sans portée
  un théorème qui l'emploie. Ce fichier montre, pour chaque définition propre de
  `GameBasedSOTP.lean` (version 1.3), un cas qui la satisfait et un cas qui ne la
  satisfait pas, ou deux valeurs extrêmes. Il ne contient ni `sorry` ni `axiom`.

  Définitions testées : avg, ind, winIND et advIND, accB et advPRG, com, accepts,
  winsBIND et extract, puis (version 1.2) winIND2, advIND2, truncLaw et distStat, enfin
  (version 1.3) prob, CadreOptimalite et ConjectureOptimalite.
-/

import Verification.Principal

open Finset
open GameBasedSOTP

namespace Coherence

/-! ## 1. Moyenne et indicatrice -/

/-- `avg` est une vraie moyenne : 1/2 pour l'indicatrice d'un bit, 1 pour une
    constante. -/
lemma avg_valeurs :
    avg (fun b : Bool => if b then (1 : ℝ) else 0) = 1 / 2 ∧ avg (fun _ : Bool => (1 : ℝ)) = 1 := by
  constructor <;> norm_num [avg]

/-- `ind` vaut 1 sur une proposition vraie et 0 sur une proposition fausse. -/
lemma ind_valeurs : ind (1 = 1) = 1 ∧ ind (1 = 2) = 0 := by
  constructor <;> norm_num [ind]

/-! ## 2. Jeu IND-CONF et jeu PRG -/

/-- Avec une graine unique et un générateur constant G = 0, le masque est nul et
    l'adversaire qui lit le bit gagne toujours : avantage 1/2. Un adversaire
    constant a un avantage nul. -/
lemma ind_extremes :
    advIND (fun _ : Unit => (0 : ZMod 2)) (fun b => if b then 1 else 0)
        (fun y => decide (y = 1)) = 1 / 2 ∧
      advIND (fun _ : Unit => (0 : ZMod 2)) (fun b => if b then 1 else 0) (fun _ => true) = 0 := by
  constructor <;> norm_num [advIND, winIND, avg, ind]

/-- Le réducteur B hérite de l'avantage : 1/2 contre G = 0 pour l'adversaire qui lit
    le bit. -/
lemma prg_extreme :
    advPRG (fun _ : Unit => (0 : ZMod 2)) (fun b => if b then 1 else 0)
      (fun y => decide (y = 1)) = 1 / 2 := by
  rw [← ind_conf_eq_prg]; exact ind_extremes.1

/-! ## 3. Engagement, ouvertures et jeu BIND-REL -/

/-- Groupe d'ordre 2 engendré par g, h = g (x = 1) et masque identité. -/
abbrev g₂ : Multiplicative (ZMod 2) := Multiplicative.ofAdd 1

/-- `winsBIND` est satisfiable : la preuve (σ₁, σ₂) = (0, g) s'ouvre sur m = 0 avec
    (s, ρ) = (0, 1) et sur m = 1 avec (s, ρ) = (1, 0). L'extracteur rend x = 1. Deux
    ouvertures identiques ne gagnent pas. -/
lemma bind_extremes :
    winsBIND g₂ (1 : ZMod 2) id 0 g₂ ⟨0, 0, 1⟩ ⟨1, 1, 0⟩ ∧
      extract (⟨0, 0, 1⟩ : Opening (ZMod 2) (ZMod 2) 2) ⟨1, 1, 0⟩ = 1 ∧
      ¬ winsBIND g₂ (1 : ZMod 2) id 0 g₂ ⟨0, 0, 1⟩ ⟨0, 0, 1⟩ := by
  refine ⟨?_, ?_, ?_⟩
  · refine ⟨⟨by decide, ?_⟩, ⟨by decide, ?_⟩, by decide⟩ <;> rfl
  · exact div_self (by decide)
  · exact fun h => h.2.2 rfl

/-! ## 4. Jeu IND-CONF avec couche Iron et masque par troncature (version 1.2) -/

/-- `winIND2`, `advIND2` : un adversaire constant gagne une fois sur deux, avantage nul. -/
lemma ind2_constant :
    advIND2 (q := 2) (fun _ => (0 : ZMod 2)) (fun b => if b then 1 else 0) (fun _ _ => true) = 0 := by
  simp [advIND2, winIND2, avg, ind]

/-- `truncLaw`, `distStat` : pour q = N la troncature est exacte (distance 0) ; pour
    q = 3 et N = 2 la distance vaut 1/6. -/
lemma trunc_valeurs :
    distStat (truncLaw (1 * 2 + 0) 2) (fun _ => 1 / ((2 : ℕ) : ℝ)) = 0 ∧
      distStat (truncLaw (1 * 2 + 1) 2) (fun _ => 1 / ((2 : ℕ) : ℝ)) = 1 / 6 := by
  rw [trunc_dist 2 1 0 (by norm_num) (by norm_num) (by norm_num),
    trunc_dist 2 1 1 (by norm_num) (by norm_num) (by norm_num)]
  norm_num

/-! ## 5. Probabilités finies, JL et cadre de la Conjecture 3.1 (version 1.3) -/

/-- `prob` : probabilité 1/2 d'un bit uniforme égal à 1, probabilité 0 de l'événement vide. -/
lemma prob_valeurs :
    prob (fun _ : Bool => (1 / 2 : ℝ)) (fun b => b = true) = 1 / 2 ∧
      prob (fun _ : Bool => (1 / 2 : ℝ)) (fun _ => False) = 0 := by
  constructor <;> simp [prob]

/-- Cadre à un régime et un protocole dont l'opposabilité vaut celle de SOTP : la
    conjecture y est vraie avec C = 1. -/
noncomputable def cadreVrai : CadreOptimalite :=
  { Regime := Unit, Proto := Unit, regime := fun _ => (), fuiteNegligeable := fun _ => True,
    opp := fun _ => 1 / 2, sotp := fun _ => () }

lemma cadreVrai_conjecture : ConjectureOptimalite cadreVrai :=
  fun _ => ⟨1, le_rfl, fun _ _ _ => by simp [cadreVrai]⟩

/-- Cadre où SOTP a une opposabilité nulle et un autre protocole une opposabilité 1/2 : la
    conjecture y est fausse. -/
noncomputable def cadreFaux : CadreOptimalite :=
  { Regime := Unit, Proto := Bool, regime := fun _ => (), fuiteNegligeable := fun _ => True,
    opp := fun b => if b then 1 / 2 else 0, sotp := fun _ => false }

lemma cadreFaux_conjecture : ¬ ConjectureOptimalite cadreFaux :=
  conjecture_exige_contexte_prive cadreFaux () true rfl trivial (by simp [cadreFaux])
    (by simp [cadreFaux])

end Coherence
