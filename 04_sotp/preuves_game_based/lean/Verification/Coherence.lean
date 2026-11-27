/-
  Dossier de vérification. Tests de cohérence des définitions propres
  ===================================================================
  Une définition propre peut être vide ou triviale, ce qui rendrait sans portée
  un théorème qui l'emploie. Ce fichier montre, pour chaque définition propre de
  `GameBasedSOTP.lean` (version 1.1), un cas qui la satisfait et un cas qui ne la
  satisfait pas, ou deux valeurs extrêmes. Il ne contient ni `sorry` ni `axiom`.

  Définitions testées : avg, ind, winIND et advIND, accB et advPRG, com, accepts,
  winsBIND et extract.
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

end Coherence
