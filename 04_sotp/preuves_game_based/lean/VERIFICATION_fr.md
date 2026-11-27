# Dossier de vérification des preuves game-based de SOTP

*English version: [VERIFICATION_en.md](VERIFICATION_en.md)*

Ce dossier permet de juger ce que `GameBasedSOTP.lean` démontre sans lire tout le code. Il suit la structure du dossier [`../../../05_formalisation_lean/VERIFICATION_fr.md`](../../../05_formalisation_lean/VERIFICATION_fr.md), elle-même reprise du dépôt de la preuve Lean de l'hypothèse de Riemann. Il est **additif**. La version 1.1 du 27 novembre 2026 reprend la version 1.0 du 22 novembre sans la modifier. La version 1.2 du même jour ajoute les sections 5 et 6 en fin de fichier, la version 1.3 les sections 7 à 10. Les lignes 5 à 275 restent celles de la version 1.0 ; seule la ligne 4, qui porte le numéro de version, a changé.

## Ce qu'il faut lire et dans quel ordre

| Ordre | Fichier | Rôle |
|---|---|---|
| 1 | ce document | Carte, traçabilité et limites |
| 2 | [`Verification/Enonces.lean`](Verification/Enonces.lean) | Les 22 énoncés de l'annexe A et du chapitre 3, sans aucune preuve, chacun avec son renvoi au manuscrit v36 |
| 3 | [`Verification/Principal.lean`](Verification/Principal.lean) | Une ligne par énoncé, de la forme `theorem principal_x : Enonces.X := nomExistant` |
| 4 | [`Verification/Coherence.lean`](Verification/Coherence.lean) | Tests de non-vacuité des définitions propres |
| 5 | `results/verification.log`, `results/axiomes.txt` | Sorties du script d'audit (produites par le workflow) |
| 6 | [`GameBasedSOTP.lean`](GameBasedSOTP.lean) | Les preuves, 770 lignes |

## Comment vérifier

```bash
cd 04_sotp/preuves_game_based/lean
lake exe cache get && lake build GameBasedSOTP Verification
bash verifier.sh
```

Le script échoue si `Enonces.lean` contient une preuve, si `sorry`, `admit`, `native_decide` ou `axiom` apparaît dans les sources, si `Principal.lean` ne relie pas chaque énoncé à un théorème existant, si la compilation échoue, si un `#print axioms` sort des trois axiomes standard ou si `leanchecker` ou `nanoda_bin` rejette les déclarations. Le fichier principal se vérifie aussi en le collant dans <https://live.lean-lang.org> (projet Mathlib).

## Ce qui a été compilé et ce qui ne l'a pas été

| Contrôle | Où | Résultat |
|---|---|---|
| Version 1.1 : `GameBasedSOTP`, puis `Enonces`, `Principal` et `Coherence` | local, 27 novembre 2026, Lean 4.35.0, Mathlib v4.35.0 à imports ciblés | réussi, aucune erreur ni aucun avertissement ; 6 `#print axioms` dans le fichier, 6 sur `Principal.lean` et 5 sur `Coherence.lean`, tous standard |
| Version 1.0 sur live.lean-lang.org et en local | 22 novembre 2026 | réussi, six `#print axioms` standard |
| Version 1.3 avec `import Mathlib` complet, `verifier.sh` étapes 1 à 6 | faite par GitHub le 27 novembre 2026 | workflow `verification_lean_sotp.yml`, exécution 46017107545 réussie (commit 0a5a7bd) : 22 énoncés et 10 lemmes de cohérence limités aux trois axiomes standard, `leanchecker` sur les quatre modules, `nanoda_bin` sur `Principal.lean` |
| Version 1.3 : `GameBasedSOTP`, puis `Enonces`, `Principal` et `Coherence` | local, 27 novembre 2026, Lean 4.35.0, Mathlib v4.35.0 à imports ciblés | réussi, aucune erreur ni aucun avertissement ; 22 `#print axioms` dans le fichier, 22 sur `Principal.lean` et 10 sur `Coherence.lean`, tous standard |
| Version 1.2 collée dans <https://live.lean-lang.org> (projet Mathlib) | faite par Thierry MINKA le 27 novembre 2026 | aucune erreur ; les 12 `#print axioms` affichent `[propext, Classical.choice, Quot.sound]` |
| Version 1.2 avec `import Mathlib` complet, `verifier.sh` étapes 1 à 6 | faite par GitHub le 27 novembre 2026 | workflow `verification_lean_sotp.yml`, exécution 46011771993 réussie (commit f73fa3d) : 12 énoncés et 7 lemmes de cohérence limités aux trois axiomes standard, `leanchecker` sur les quatre modules, `nanoda_bin` sur `Principal.lean` |
| Version 1.2 : `GameBasedSOTP`, puis `Enonces`, `Principal` et `Coherence` | local, 27 novembre 2026, Lean 4.35.0, Mathlib v4.35.0 à imports ciblés | réussi, aucune erreur ni aucun avertissement ; 12 `#print axioms` dans le fichier, 12 sur `Principal.lean` et 7 sur `Coherence.lean`, tous standard |
| Version 1.1 avec `import Mathlib` complet, `verifier.sh` étapes 1 à 6 | faite par GitHub le 27 novembre 2026 | workflow `verification_lean_sotp.yml`, exécution 46004902085 réussie (commit 771e24b) : 6 énoncés et 5 lemmes de cohérence limités aux trois axiomes standard, `leanchecker` sur les quatre modules, `nanoda_bin` sur `Principal.lean` |

## Tableau de traçabilité

Les numéros et les pages sont ceux du manuscrit v36 (`index_labels_v36.tsv`). « Fichier » désigne la ligne de `GameBasedSOTP.lean`. `E` et `P` désignent les lignes de `Enonces.lean` et de `Principal.lean`. Les vingt-deux théorèmes affichent tous `[propext, Classical.choice, Quot.sound]`.

| Énoncé du manuscrit | Label | N° et page v36 | Nom Lean | Fichier | E / P | Statut |
|---|---|---|---|---|---|---|
| Masque jetable, la loi de m + y ne dépend pas de m | `thm:ann_sotp_low_conf` | Théorème A.1, preuve, p. 225 | `otp_uniform` | 78 | 35 / 17 | démontré |
| Réduction de SOTP-Low au PRG, Adv^IND-CONF(A) = Adv^PRG(B) | `thm:ann_sotp_low_conf` | Théorème A.1, p. 225 | `ind_conf_eq_prg` | 139 | 42 / 18 | démontré en situation réduite (a) |
| Masque uniforme, avantage nul | `thm:ann_sotp_low_conf` | Théorème A.1, p. 225 | `ind_conf_perfect_otp` | 149 | 48 / 19 | démontré |
| Extraction du logarithme discret depuis deux ouvertures de Pedersen | `def:ann_pedersen` | Définition A.2, p. 220 | `pedersen_extract` | 196 | 56 / 22 | démontré |
| Réduction de SOTP-Low au DLOG, une victoire livre x | `thm:ann_sotp_low_rel` | Théorème A.2, p. 226 | `bind_rel_gives_dlog` | 234 | 63 / 23 | démontré en situation réduite (a) |
| Win^BIND-REL(A) ≤ Adv^DLOG(B) | `thm:ann_sotp_low_rel`, `eq:ann_sotp_low_rel` | Théorème A.2 (p. 226), (A.18) p. 228 | `win_bind_le_dlog` | 247 | 71 / 24 | démontré en situation réduite (a) |
| Théorème A.5, (A.17) : avec la couche Iron, Adv^IND-CONF(A) ≤ Adv^PRG(B) + 1/q | `thm:ann_sotp_low_games`, `eq:ann_sotp_low_conf` | Théorème A.5, p. 228 | `ind_conf_complet` | 364 | 87 / 28 | démontré en situation réduite (a) (b) |
| Théorème A.5, (A.18) : Win^BIND-REL(A) ≤ Adv^DLOG(B) + 1/q | `thm:ann_sotp_low_games`, `eq:ann_sotp_low_rel` | Théorème A.5, p. 228 | `win_bind_complet` | 413 | 94 / 29 | démontré en situation réduite (a) |
| Loi de s mod N, k + 1 ou k antécédents | `rem:masque_troncature` | Remarque 3.5, p. 96 | `card_mod_eq` | 430 | 107 / 30 | démontré |
| Distance statistique du masque par troncature, r(N − r)/(qN) | `rem:masque_troncature` | Remarque 3.5, p. 96 | `trunc_dist` | 469 | 113 / 31 | démontré |
| Majorations N/(4q) et 2^(−λ−1) | `rem:masque_troncature` | Remarque 3.5, p. 96 | `trunc_bound` | 508 | 120 / 32 | démontré |
| Cas q ≥ 2^252, λ = 128 : 2^(−126) et 2^(−125) | `rem:masque_troncature` | Remarque 3.5, p. 96 | `trunc_ecdsa` | 522 | 127 / 33 | démontré |
| Borne de l'union sur les paires de contextes | `thm:ann_sotp_base_opp` | Théorème A.3, preuve, p. 227 | `union_bound` | 565 | 136 / 37 | démontré |
| Seuil k ≥ (12/δ²)·ln(N²/ε′) donne N²·e^(−kδ²/12) ≤ ε′ | `thm:ann_sotp_base_opp` | Théorème A.3, p. 227 | `jl_seuil` | 582 | 143 / 38 | démontré |
| Dimensionnement JL, échec au plus ε′ | `thm:ann_sotp_base_opp`, `thm:saturation_sotp_base` | Théorème A.3 (p. 227), Proposition 3.2 (p. 98) | `jl_dimensionnement` | 600 | 150 / 39 | démontré, queue de Chernoff posée (c) |
| JL, existence d'une projection qui préserve les distances | `lem:johnson_lindenstrauss`, `def:ann_jl` | Lemme 2.2 (p. 47), Définition A.4 (p. 221) | `jl_existence` | 619 | 161 / 40 | démontré, queue de Chernoff posée (c) |
| JL, seuil k > 24·ln N/ε² | `lem:johnson_lindenstrauss` | Lemme 2.2, preuve, p. 47 | `jl_seuil_existence` | 631 | 168 / 41 | démontré |
| SOTP-Base, Adv^IND-CONF ≤ Adv^PRG + 1/q | `cor:ann_sotp_base_reductions`, `thm:saturation_sotp_base` | Corollaire A.1 (p. 227), Proposition 3.2 (p. 98) | `base_ind_conf` | 656 | 173 / 42 | démontré en situation réduite (a) |
| SOTP-Base, Win^BIND-REL ≤ Adv^DLOG | `cor:ann_sotp_base_reductions`, `thm:saturation_sotp_base` | Corollaire A.1 (p. 227), Proposition 3.2 (p. 98) | `base_bind_rel` | 668 | 179 / 43 | démontré en situation réduite (a) |
| SOTP-High, loi de Σ indépendante de m | `thm:ann_sotp_high`, `thm:saturation_sotp_high` | Théorème A.4 (p. 227), Proposition 3.3 (1) (p. 100) | `high_conf` | 695 | 192 / 44 | démontré, divulgation nulle parfaite posée (d) |
| SOTP-High, Relver ≥ 1 − ε_sound − ε_coll − ε_dlog | `thm:ann_sotp_high`, `thm:saturation_sotp_high`, `def:ann_groth16` | Théorème A.4 (p. 227), Proposition 3.3 (2) (p. 100), Définition A.3 (p. 220) | `high_relver` | 706 | 198 / 45 | démontré, hypothèses de Groth16 posées (d) |
| La Conjecture 3.1 exige le modèle à contexte privé | `rem:statut_optimalite`, `conj:optimalite_universelle` | Remarque 3.8 et Conjecture 3.1, p. 104 | `conjecture_exige_contexte_prive` | 748 | 208 / 46 | démontré (e) |

(a) Situation réduite de la section « Mécanisation en situation réduite » (p. 230). Les probabilités sont des moyennes uniformes sur des ensembles finis. Les adversaires sont des fonctions dont l'aléa propre est absorbé dans leur description. La couche Iron n'est pas modélisée dans le jeu de confidentialité de la version 1.0 et la couche Clay ne l'est pas du tout.

(b) Couche Iron (section 5). L'adversaire reçoit σ₁ = m_b + G(s) et l'exposant s + xρ de σ₂ = g^s·h^ρ, avec h = g^x. Les lemmes `com_eq` et `zpowq_inj` justifient ce passage à l'exposant. Pour x ≠ 0, ρ ↦ s + xρ est une bijection de ZMod q (`avg_affine`), si bien que σ₂ est uniforme et indépendant de s. Le cas x = 0, de probabilité 1/q, donne le terme 1/q.

Les jeux IND-CONF, BIND-REL et EXT-OPP sur lois finies et leurs ponts vers Conf, Relver et Opp (Définitions 2.5 à 2.7 et A.5 à A.7, Remarques 2.6 à 2.8 et A.1 à A.3, Lemme A.1, Corollaire A.2, Remarque A.6) sont démontrés dans `ConditionalCRO.lean` version 3.8, section 18, parce qu'ils emploient le modèle `CLOModel`. Voir [`../../../05_formalisation_lean/VERIFICATION_fr.md`](../../../05_formalisation_lean/VERIFICATION_fr.md).

(c) Queue de Chernoff du χ² (section 7). Le tirage de Φ est un espace de probabilité fini. La majoration μ(paire déformée) ≤ 2·exp(−kδ²/12) de la preuve du Lemme 2.2 est une prémisse du théorème, faute de loi gaussienne et de borne de Chernoff du χ² sous cette forme dans Mathlib. La borne de l'union, le seuil et l'existence sont démontrés.

(d) Groth16 (section 9). La divulgation nulle parfaite est modélisée par une preuve π simulée qui ne dépend que des entrées publiques. La connaissance-solidité, la résistance aux collisions de Poseidon et le caractère liant sous DLog sont trois événements d'échec de probabilités majorées par ε_sound, ε_coll et ε_dlog, posées comme prémisses.

(e) Conjecture 3.1 (section 10). La conjecture est énoncée par `ConjectureOptimalite` (ligne 740) au-dessus d'un cadre abstrait `CadreOptimalite`. Elle n'est ni démontrée ni posée comme axiome. Le théorème démontré montre qu'elle est fausse dans tout cadre où SOTP a une opposabilité nulle face à un protocole du même régime d'opposabilité positive, ce qui est le cas du modèle actuel (Remarque 3.2 et témoin de la Remarque 2.20). Elle demande donc le modèle à contexte d'espèce privé. Pistes, non formalisées : une couche Clay qui transmet min{Δ, γ} bits de contexte privé, comme le témoin `witModel`, donnerait Opp(SOTP) = min{1, Δ/γ}, d'où C_R = 1 pour κ = 0 et C_R = 2 dès que κ/λ ≤ Δ. Il resterait à montrer qu'une construction réelle (Pedersen, PRG, JL ou Groth16) réalise cette couche sans perdre sa confidentialité. Ce travail relève du programme de recherche qui suit la thèse.

### Tests de cohérence des définitions propres

| Définition | Cas qui satisfait | Cas qui ne satisfait pas | Lignes de `Coherence.lean` |
|---|---|---|---|
| `avg`, `ind` | avg = 1/2 pour l'indicatrice d'un bit ; ind = 1 sur une proposition vraie | ind = 0 sur une proposition fausse | 20 à 30 |
| `winIND`, `advIND`, `accB`, `advPRG` | avantage 1/2 pour l'adversaire qui lit le bit sous G = 0, transmis au réducteur | avantage 0 pour un adversaire constant | 32 à 48 |
| `com`, `accepts`, `winsBIND`, `extract` | une preuve de ZMod 2 ouverte sur 0 et sur 1, l'extracteur rend x = 1 | deux ouvertures identiques ne gagnent pas | 50 à 66 |
| `winIND2`, `advIND2`, `truncLaw`, `distStat` (version 1.2) | distance 1/6 pour q = 3 et N = 2 | adversaire constant, avantage 0 ; distance 0 pour q = N | 67 à 82 |
| `prob`, `CadreOptimalite`, `ConjectureOptimalite` (version 1.3) | probabilité 1/2 d'un bit égal à 1 ; un cadre où la conjecture est vraie avec C = 1 | probabilité 0 de l'événement vide ; un cadre où elle est fausse | 84 à 110 |

## Carte de la preuve en langage simple

1. *Masque jetable.* `otp_uniform` (78) est un changement de variable y ↦ m + y dans une somme finie. Court.
2. *Confidentialité.* `accB_uniform` (113) applique le masque jetable au défi uniforme, où B rend 1 avec probabilité 1/2. `ind_conf_eq_prg` (139) échange ensuite deux moyennes. Court.
3. *Fiabilité.* `com_eq` (178) écrit l'engagement g^(s + xρ). `zpowq_inj` (187) en tire l'égalité des exposants dans ZMod q, puis `pedersen_extract` (196) résout en x. `bind_rel_gives_dlog` (234) montre que des messages distincts forcent des graines distinctes. `win_bind_le_dlog` (247) compare les indicatrices point par point.
4. *Bornes complètes.* `ind_conf_complet` (364) découpe la moyenne sur x en x = 0 et x ≠ 0. Pour x ≠ 0, `avg_affine` (328) rend l'exposant uniforme et la simulation de B est exacte. `accB2_uniform` (339) montre que B rend 1 avec probabilité 1/2 sur un défi uniforme. Longueur moyenne.
5. *Troncature.* `card_mod_eq` (430) compte les antécédents par le lemme `Nat.count_modEq_card_eq_ceil` de Mathlib. `trunc_dist` (469) somme les écarts positifs, qui valent (N − r)/(qN) pour y < r et 0 sinon. Court.

## Limites dites franchement

1. **Situation réduite.** Les théorèmes ne portent ni sur des adversaires probabilistes bornés en temps ni sur des familles indexées par λ. Le modèle probabiliste complet (VCVio) est une option du lot L4 de la feuille de route.
2. **PRG et DLOG.** Leur sécurité n'est pas démontrée. Les théorèmes relient l'avantage de A à celui du réducteur B, ce qui est la forme exacte d'une réduction.
3. **Couches Iron et Clay.** Depuis la version 1.2, la couche Iron figure dans le jeu de confidentialité (section 5). La couche Clay n'est pas modélisée.
4. **SOTP-Base et SOTP-High.** Depuis la version 1.3, leurs réductions et leur dimensionnement sont mécanisés, avec la queue de Chernoff et les hypothèses de Groth16 posées (notes (c) et (d)). La Conjecture 3.1 est seulement énoncée (note (e)).
5. **Compilation locale à imports ciblés.** La compilation locale remplace `import Mathlib` par dix modules de Mathlib. Le workflow GitHub compile avec `import Mathlib` complet. Lean 4.35.0 y affiche un avertissement qui propose le mot-clé `module`, sans effet sur les preuves.
6. **Troncature.** La section 6 calcule la distance entre G(s) et la loi uniforme. Le passage à Conf ≥ 1 − 2^(−λ) pour les lois de σ sachant deux messages suit de l'inégalité triangulaire ; il n'est pas formalisé ici.

## Reproductibilité

| Élément | Valeur |
|---|---|
| Lean | v4.35.0 ([`lean-toolchain`](lean-toolchain)) |
| Mathlib | v4.35.0, commit `56a005855ea17e0b0958f73ec801ae140b0a1679` ([`lake-manifest.json`](lake-manifest.json)) |
| Bibliothèques Lake | `GameBasedSOTP` (cible par défaut) et `Verification` |
| SHA-256 de `GameBasedSOTP.lean` | `7a2eaf8925b1669ad391c4dc7e185399131654ab2fe5b6f927b8d95f98f2ff39` (version 1.3) |
