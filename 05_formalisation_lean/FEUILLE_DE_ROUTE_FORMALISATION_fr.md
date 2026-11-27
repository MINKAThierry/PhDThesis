# Feuille de route pour formaliser tout le manuscrit en Lean

Version du 27 novembre 2026, établie sur le manuscrit v36 et la formalisation en ligne (ConditionalCRO.lean v3.4, GameBasedSOTP.lean). Le détail énoncé par énoncé figure dans `INVENTAIRE_LEAN_MANUSCRIT_fr.md`.

## Avancement

| Lot | État | Version | Couverture après le lot |
|---|---|---|---|
| L1 information classique finie | **terminé le 27 novembre 2026** (24 théorèmes ajoutés, 18 énoncés dans `Enonces.lean`) | `ConditionalCRO.lean` v3.5 | 57 sur 144 (40 %) |
| L5a noyau quantique | **terminé le 27 novembre 2026** (17 théorèmes ajoutés, 17 énoncés dans `Enonces.lean`) | `ConditionalCRO.lean` v3.6 | 79 sur 144 (55 %) |
| L2 bornes avancées | **terminé le 27 novembre 2026** (13 théorèmes ajoutés, 10 énoncés dans `Enonces.lean`) | `ConditionalCRO.lean` v3.7 | 85 sur 144 (59 %) |
| L3 jeux et ponts | **terminé le 27 novembre 2026** (15 théorèmes ajoutés, 15 énoncés dans `Enonces.lean`) ; les ponts utilisent `CLOModel` et sont donc dans `ConditionalCRO.lean` ; `GameBasedSOTP.lean` reçoit la structure du dépôt de Riemann | `ConditionalCRO.lean` v3.8, `GameBasedSOTP.lean` v1.1 | 100 sur 145 (69 %) (a) |
| L5b encodage diagonal | **terminé le 27 novembre 2026** (6 théorèmes ajoutés, 4 énoncés dans `Enonces.lean`) ; spectre des états diagonaux par le polynôme caractéristique de Mathlib | `ConditionalCRO.lean` v3.9 | 104 sur 145 (72 %) |
| L4 constructions SOTP | **terminé le 27 novembre 2026** en trois parties : SOTP-Low complet (Théorème A.5, Remarque 3.5) ; S-OTP (Théorème 3.1, Remarque 3.2) ; SOTP-Base (Lemme 2.2, Théorème A.3, Corollaire A.1, Proposition 3.2) et SOTP-High (Théorème A.4, Proposition 3.3), avec la queue de Chernoff et les hypothèses de Groth16 posées ; Conjecture 3.1 énoncée sans preuve, avec le théorème qui montre qu'elle exige le modèle à contexte privé | `GameBasedSOTP.lean` v1.3, `ConditionalCRO.lean` v3.10 | 118 sur 145 (81 %) |
| L6 chapitres 4 et 5 | prochain lot | v3.11 prévue | — |

(a) La Remarque 2.2 (`rem:rel_ver`), classée hors champ dans l'inventaire initial, contient l'affirmation « Conf = 1 entraîne Relrec = 2^(−λ) ». Elle est démontrée par `rel_of_conf_one` et compte désormais parmi les énoncés formalisables, qui passent de 144 à 145.

## Point de départ

Le manuscrit compte 170 énoncés numérotés. Parmi eux, 144 relèvent d'une formalisation et 42 sont couverts aujourd'hui (29 %).

- **Couvert.** Le noyau algébrique du Trilemme CRO classique sous ses formes explicite, raffinée, publiée et asymptotique. Les témoins de cohérence et de portée. Les régimes de Helios, des zk-SNARKs et de l'audit traditionnel. Le seuil H♯ dans les deux sens. Une couche concrète où Pinsker et Fano sont démontrés pour des lois finies. Les réductions de SOTP-Low au PRG et au logarithme discret, en situation réduite.
- **Non couvert.** Les théorèmes 2.1 à 2.3 du cadre CLO, la DPI et la Proposition 2.1. La borne aiguë et les témoins réalisables. Les ponts entre jeux et métriques. Les propriétés de S-OTP et des trois variantes SOTP. Tout le volet quantique. Le minorant par traits du chapitre 4.

## Règles qui gouvernent le chantier

1. **Le manuscrit est gelé jusqu'à la soutenance.** Si la formalisation fait apparaître une formulation à préciser, elle est consignée dans un journal des écarts, sans toucher au manuscrit. Ce journal servira après la soutenance.
2. **La thèse l'emporte.** Chaque énoncé Lean reprend la formulation du manuscrit v36, dans le cadre de la cryptographie institutionnelle. Δ, α, β, γ et κ gardent leur sens.
3. **Copier-coller en ligne.** Tout ce qui sera montré au jury doit compiler sur live.lean-lang.org, qui ne charge que Mathlib. Les lots L1 à L4, L5a, L5b et L6 n'utilisent donc que Mathlib. Seul le lot L5c a besoin de Physlib et reste réservé au dépôt.
4. **Structure du dépôt de la preuve de Riemann.** Chaque nouvel énoncé entre dans `Verification/Enonces.lean` sans preuve, avec son renvoi au manuscrit v36. Il reçoit une ligne dans `Principal.lean` et, pour une définition nouvelle, un test de non-vacuité dans `Coherence.lean`. `verifier.sh`, `VERIFICATION_fr.md` et `_en.md`, le workflow GitHub et les README sont mis à jour à chaque lot.
5. **Exigences de sortie.** Aucun `sorry`, aucun `axiom` déclaré. Chaque `#print axioms` n'affiche que `propext`, `Classical.choice` et `Quot.sound`. Une hypothèse du manuscrit reste une prémisse nommée, jamais un axiome.
6. **Fichiers touchés.** Dans FINAL, seuls `ConditionalCRO.lean` et `GameBasedSOTP.lean` changent. L'essentiel du travail se fait dans `PhDThesis/05_formalisation_lean/` et `PhDThesis/04_sotp/preuves_game_based/lean/`.

## Les lots

### L1 · Information classique finie et cadre CLO (chapitre 2, sections 2.2 et 2.3)

- **Énoncés.** DPI (Lemmes 1.3 et A.2), Théorème 2.1 (bornes élémentaires), Lemme 2.1, Théorème 2.2 (goulot contextuel), Théorème 2.3 et Remarque 2.5 (composition). Proposition 2.1 (fondement informationnel de l'extraction). Remarques 2.3, 2.11 (capacité Δ* majorée par γ + 1), 2.12 (contre-exemple montrant que la borne sur le cardinal n'entraîne pas H(V|C) ≥ γ), 2.15 et 3.9. Définitions 2.1 et 2.13 (protocole CLO, interprétation admissible).
- **Méthode.** Étendre le modèle fini `CLOModel` avec l'information mutuelle conditionnelle et la règle de chaîne. La DPI s'obtient alors par la positivité de l'information mutuelle conditionnelle, déjà presque disponible avec `miN_nonneg`.
- **Effort estimé.** 3 à 4 sessions. Risque faible, car la couche concrète contient déjà la moitié des outils.
- **État.** Terminé en v3.5. Le Lemme 2.1 est relié à `lemma4_concrete`, qui en démontre l'énoncé. Le Théorème 2.3 parallèle est démontré sans supposer σ₁ et σ₂ indépendantes sachant (M, C), ce qui contient le cas du manuscrit.

### L2 · Bornes avancées et témoins réalisables (chapitre 2, section 2.4)

- **Énoncés.** Proposition 2.2 (borne aiguë, terme dominant en κ/λ²), Corollaire 2.1, Remarques 2.19 à 2.22 et 2.24, Remarque 5.5. Dernière phrase du Théorème 2.4, Conf ≥ 1 − √(c₀βκ/λ), aujourd'hui seulement déduite sur papier.
- **Méthode.** La borne aiguë demande h(p) ≤ p·log₂(e/p) et Fano sous sa forme en d(p ‖ 2^−λ). Les témoins réalisables sont des lois explicites sur des ensembles finis, construites comme `famModel`. Les valeurs numériques de la Remarque 2.24 se vérifient avec `norm_num`.
- **Effort estimé.** 3 sessions. Le point délicat est la minoration de la divergence binaire.
- **État.** Terminé en v3.7. La Proposition 2.2 est démontrée sur lois finies par l'inégalité log-somme appliquée en une fois à tout (C, M, Σ), ce qui évite l'inégalité de Jensen. La dernière phrase du Théorème 2.4, le Corollaire 2.1, le témoin réalisable (Remarque 2.20), les Remarques 2.24, 5.5 et 2.40 sont démontrés. Restent sur papier l'optimalité de l'ordre λ⁻² (protocole à révélation ρ de la Remarque 2.19) et le témoin combiné de la Remarque 2.21, dont les entropies ne sont pas uniformes.

### L3 · Jeux et ponts vers les métriques (chapitre 2, section 2.3.4 et annexe A)

- **Énoncés.** Définitions des jeux IND-CONF, BIND-REL et EXT-OPP (2.5 à 2.7 et A.5 à A.7). Ponts IND-CONF ↔ Conf, BIND-REL ↔ Relver et EXT-OPP ↔ Opp (Remarques 2.6 à 2.8 et A.1 à A.3). Corollaire A.2 et Remarque A.6.
- **Méthode.** Reprendre le modèle à moyennes finies de `GameBasedSOTP.lean`. Le pont IND-CONF repose sur le test de Neyman-Pearson pour une paire de lois finies. Le pont EXT-OPP applique `fano_finite` à l'estimation du verdict.
- **Effort estimé.** 3 sessions.

### L4 · Constructions S-OTP et SOTP (chapitre 3 et annexe A)

- **Énoncés.** Théorème 3.1 (S-OTP) et Propositions 3.1 à 3.3. Théorèmes A.1 à A.5 et Corollaire A.1. Remarque 3.5 (masque par troncature, Conf ≥ 1 − 2^−λ). Lemme 2.2 et Définition A.4 (Johnson-Lindenstrauss). Définition A.3 (Groth16). Énoncé formel de la Conjecture 3.1.
- **Méthode.**
  - **SOTP-Low.** On passe de la situation réduite aux bornes complètes du Théorème A.5. La troncature se traite comme une distance statistique sur Z_q.
  - **SOTP-Base.** Le lemme JL entre d'abord comme hypothèse nommée tirée de la littérature, comme le fait le manuscrit. Sa démonstration (concentration gaussienne) est une option qui n'existe pas dans Mathlib.
  - **SOTP-High.** La connaissance-solidité de Groth16 est une hypothèse cryptographique nommée, comme dans le manuscrit.
  - **Conjecture 3.1.** Elle est seulement énoncée en Lean, sous forme de `def ... : Prop`, sans preuve ni axiome. Elle reste ouverte.
- **Effort estimé.** 5 à 6 sessions. Une option permettra plus tard de porter les jeux vers VCVio, avec des adversaires probabilistes, dans le dépôt seulement.

### L5 · Extension quantique (chapitre 2, section 2.5)

- **L5a, noyau algébrique quantique.**
  - *Énoncés.* Théorème 2.5 et Corollaire 2.2, Hypothèses 2.5 à 2.8 et Définition 2.30. Remarques 2.27 (encadrement de η_q), 2.31 à 2.33, 2.35 à 2.37 et 2.39 à 2.41.
  - *Méthode.* On procède comme pour le cas classique en v2.x. Une `QuantumProtocolInstance` sur des réels porte comme champs les lemmes quantiques posés et le trilemme quantique en découle. C'est le gain le plus rapide du chantier.
  - *Effort estimé.* 2 sessions.
  - *État.* Terminé en v3.6. Le gain dépasse la prévision (79 énoncés au lieu de 75), car les Hypothèses 2.5 à 2.8 et les Lemmes 2.4, 2.6 et 2.7 sont désormais posés en Lean. La Remarque 2.40 (borne aiguë quantique) passe au lot L2, puisqu'elle dépend de la Proposition 2.2.
- **L5b, encodage classique diagonal.**
  - *Énoncés.* Remarques 2.9, 2.25 et 2.26, ainsi que le contre-exemple de la Remarque 2.34 (lemme 6 publié, I_acc = 1 bit contre 1/2).
  - *Méthode.* Des états diagonaux réduits à des lois finies, en Mathlib seul.
  - *Effort estimé.* 2 sessions.
- **L5c, information quantique complète.**
  - *Énoncés.* Lemmes 1.4 à 1.6 et 2.4 à 2.8. Définitions 2.8, 2.9, 2.14 à 2.22 et 2.24 à 2.29 (entropies, information accessible, canaux, norme diamant).
  - *Méthode.* Physlib (partie QuantumInfo, issue de Lean-QuantumInfo), qui contient Holevo et la sous-additivité forte. On s'appuie aussi sur Lean-Quantum pour la DPI de l'entropie relative. Les lemmes absents (Pinsker quantique, mesure douce, Fano quantique) seront démontrés ou posés comme hypothèses nommées, selon l'état de la bibliothèque au moment du lot.
  - *Effort estimé.* 6 sessions ou plus. C'est le lot le plus incertain. Il ne compilera pas sur live.lean-lang.org.

### L6 · Protocoles de mesure (chapitres 4 et 5)

- **Énoncés.** Proposition 4.1 (minorant par traits) et Remarque 4.2 (estimateur pour une preuve masquante). Définitions 4.1 et 4.2.
- **Certification numérique des tableaux.** Les valeurs calculées des chapitres 1, 2, 4 et 5 sont vérifiées par `norm_num`. Cela concerne les produits CLO, Δ obtenu par inversion de la forme publiée, γ, H♯ et les demi-largeurs d'intervalle. Les protocoles empiriques eux-mêmes restent hors champ formel.
- **Effort estimé.** 2 sessions.

## Ordre proposé et jalons

| Ordre | Lot | Gain de couverture | Compatible live.lean-lang.org |
|---|---|---|---|
| 1 | L1 information classique finie | +15 énoncés | oui |
| 2 | L5a noyau quantique | +18 énoncés | oui |
| 3 | L2 bornes avancées | +7 énoncés, dernière phrase du Théorème 2.4 | oui |
| 4 | L3 jeux et ponts | +14 énoncés | oui |
| 5 | L5b encodage diagonal | +4 énoncés | oui |
| 6 | L4 SOTP | +14 énoncés | oui, hors option VCVio |
| 7 | L6 chapitres 4 et 5 | +4 énoncés et tableaux | oui |
| 8 | L5c information quantique | +26 énoncés | non, dépôt seulement |

Après les lots 1 et 2, la couverture passe de 29 % à 52 %. Après le lot 7, elle atteint 82 %. Le lot 8 porte le total à 100 % des énoncés formalisables, avec les hypothèses nommées dites franchement.

Chaque lot se termine par une version numérotée des fichiers Lean (v3.5, v3.6…), une compilation locale complète, le passage du workflow GitHub et un test sur live.lean-lang.org. Les commits suivent tes règles d'identité et ne portent aucune ligne Co-Authored-By.

## Limites dites franchement

- Les adversaires des jeux sont modélisés par des moyennes sur des ensembles finis. Le modèle probabiliste complet (VCVio) est une option du lot L4.
- JL, la connaissance-solidité de Groth16 et la sécurité du PRG et du logarithme discret restent des hypothèses nommées. Le manuscrit les pose aussi.
- La Conjecture 3.1 est énoncée et non démontrée.
- Le lot L5c dépend de bibliothèques qui évoluent vite. Sa portée exacte sera fixée au début du lot.
