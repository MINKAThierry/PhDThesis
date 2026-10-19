> **Statut : PROPOSITION — implémentation de référence** (construction SOTP-High, non auditée, démonstration) · Source : thèse, chapitre 3, sous-section SOTP-High (algorithme 3, proposition et remarques) ; annexe A, théorème `thm:ann_sotp_high`

# SOTP-High — implémentation de référence exécutable

[English version](README_en.md)

Ce dossier contient une implémentation exécutable de la construction SOTP-High décrite au chapitre 3 de la thèse. Le circuit est écrit en Circom 2, la preuve est un zk-SNARK Groth16 sur la courbe BN254 (nommée `bn128` dans snarkjs). L'ensemble sert de démonstration. Il n'a fait l'objet d'aucun audit de sécurité et la cérémonie de mise en place qu'il exécute est locale, donc non sûre pour un usage réel.

## Relation prouvée

Le circuit établit la relation de l'annexe A (théorème `thm:ann_sotp_high`)

$$
\mathcal{R} = \{((h_c, c_m), (m, c, \rho)) : h_c = \mathsf{Poseidon}(c) \wedge c_m = m\cdot G + \rho\cdot H \wedge \mathsf{Conforme}(m, c) = 1\}.
$$

La thèse note l'engagement multiplicativement ($c_m = g^m h^\rho$). Le circuit utilise la notation additive de la courbe Baby Jubjub, ce qui revient au même.

### Correspondance circuit ↔ relation $\mathcal{R}$ ↔ couches Gold/Iron/Clay

| Élément de la thèse | Couche | Réalisation dans `circuits/sotp_high.circom` |
|---|---|---|
| $h_c = \mathsf{Poseidon}(c)$ | Clay | `Poseidon(4)` de circomlib sur `c[0..3]`, sortie publique `h_c` |
| $c_m = g^m h^\rho$ | Iron | `PedersenCommitBJJ` : `EscalarMulFix(64, G)` + `EscalarMulFix(253, H)` + `BabyAdd`, sorties publiques `cm_x`, `cm_y` |
| $\mathsf{Conforme}(m, c) = 1$ | assertion certifiée | `ConformeAML` : `Num2Bits(64)` (contrôles de plage) + `LessThan(64)` + appartenance à la liste autorisée |
| ZK de $\pi$ | Gold | apportée par Groth16 (snarkjs), pas par le circuit |
| $\mathsf{Groth16.Verify}$, ligne 15 ($b_1$) | — | `snarkjs.groth16.verify` dans `scripts/verify.js` et `scripts/verify.sh` |
| $[c_m \in \mathbb{G}]$, ligne 16 ($b_2$) | Iron | `babyjub.inCurve` et `babyjub.inSubgroup` (circomlibjs) dans `scripts/verify.js` |
| $\sigma = (h_c, \pi, c_m, \mathsf{metadata})$, ligne 13 | Clay | `sigma.json` écrit par `scripts/prove.js` |
| Setup avec destruction des toxiques, lignes 2 à 7 | — | `scripts/build.sh` (cérémonie locale de démonstration, voir plus bas) |

Les signaux publics apparaissent dans `public.json` dans l'ordre `[h_c, cm_x, cm_y]`. Le témoin privé se compose de `m`, `c[0..3]` et `rho`.

### Couche Clay : contexte institutionnel encodé

Le contexte $c$ est un vecteur de quatre éléments du corps scalaire de BN254.

| Champ | Signification dans l'exemple |
|---|---|
| `c[0]` | seuil de déclaration $T$ (unités monétaires, $< 2^{64}$) |
| `c[1]` | code du type d'opération |
| `c[2]` | code de juridiction (120 dans les exemples, code numérique ISO 3166 du Cameroun) |
| `c[3]` | version du référentiel de règles |

Le condensé $h_c$ est un élément du corps de BN254 (environ 254 bits), là où la thèse parle d'un condensé de 256 bits. Les champs `c[2]` et `c[3]` n'interviennent que par $h_c$ dans cet exemple.

### Couche Iron : engagement de Pedersen dans le circuit

L'engagement $c_m = m\cdot G + \rho\cdot H$ est calculé dans le circuit sur Baby Jubjub, courbe d'Edwards tordue définie sur le corps scalaire de BN254, ce qui rend l'arithmétique de courbe native dans le circuit. Les générateurs $G$ et $H$ sont les deux premiers points de base du hachage de Pedersen de circomlib (`BASE[0]` et `BASE[1]` de `pedersen.circom`). circomlib les obtient par essais successifs à partir de `blake256("PedersenGenerator_<i>_<essai>")`. Le premier encodage qui se décompresse en un point de la courbe est retenu puis multiplié par le cofacteur 8, ce qui place le point dans le sous-groupe d'ordre premier $\ell$ (environ $2^{251}$). Cette dérivation « nothing-up-my-sleeve » est publique et reproductible. Personne ne connaît donc $\log_G H$, ce dont dépend le caractère liant de l'engagement sous l'hypothèse DLog. Le test `generators G, H are the nothing-up-my-sleeve circomlib Pedersen bases` recalcule ces deux points avec circomlibjs et vérifie qu'ils coïncident avec les constantes du circuit.

Le prouveur tire $\rho$ uniformément dans $[0, \ell)$ (`sampleRho` dans `scripts/lib.js`). L'engagement est alors uniforme dans le sous-groupe quel que soit $m$, ce qui donne le masquage parfait invoqué par la proposition de la thèse. Le montant $m$ est contraint sur 64 bits et $\rho$ sur 253 bits.

### Prédicat $\mathsf{Conforme}(m, c)$ : un exemple

Le prédicat implémenté est une règle de conformité de type anti-blanchiment (AML), choisie à titre d'illustration.

$$
\mathsf{Conforme}(m, c) = 1 \iff m < c[0] \ \wedge\ c[1] \in \{1, 2, 3\}.
$$

Le montant doit être strictement inférieur au seuil fixé par le contexte et le type d'opération doit appartenir à la liste autorisée, fixée dans le circuit et donc publique. Les contrôles de plage `Num2Bits(64)` sur $m$ et sur $c[0]$ sont indispensables, faute de quoi le comparateur `LessThan(64)` pourrait être trompé par le repliement modulo $p$ (le cas `inputs/hors_plage.json`, montant « négatif » $p-1$, le vérifie).

Ce prédicat n'est qu'un exemple. Un autre contexte institutionnel appellerait un autre prédicat, donc un autre circuit et une autre mise en place Groth16 propre à ce circuit.

## Ce que l'exécution démontre

- **Complétude.** Pour un témoin satisfaisant $\mathcal{R}$, la preuve est générée puis acceptée ($b_1 \wedge b_2$). Les signaux publics coïncident avec un calcul hors circuit de $\mathsf{Poseidon}(c)$ et de $m\cdot G + \rho\cdot H$.
- **Rejet.** Une preuve dont l'un des signaux publics ($h_c$, `cm_x` ou `cm_y`) est modifié est rejetée, de même qu'une preuve rejouée avec le condensé d'un autre contexte ou une preuve dont un élément est altéré. Aucun témoin ne peut être produit pour une entrée non conforme (montant au-dessus du seuil, montant égal au seuil, type d'opération non autorisé, montant hors plage).
- **Zéro-connaissance.** Elle est héritée de Groth16 (propriété du système de preuve, non testée par l'exécution). Le test de masquage se borne à constater que deux engagements du même $m$ avec des $\rho$ différents diffèrent alors que $h_c$ reste identique.

## Ce que l'exécution ne démontre pas

- Aucune minoration d'opposabilité. Conformément à la remarque `rem:heuristique_sotp_high` et au théorème `thm:ann_sotp_high`, $h_c$ et les métadonnées sont des fonctions du contexte public ($I(V; h_c \mid C) = 0$). L'expression $0{,}45\,\beta\log_2\lambda/\lambda$ reste une heuristique de conception non prouvée. Les paramètres institutionnels $\Delta$, $\alpha$, $\beta$ n'interviennent pas dans ce code.
- Aucune optimalité. L'optimalité de la famille SOTP est une conjecture de la thèse.
- Aucune sécurité de la mise en place. La cérémonie Powers of Tau et la phase 2 sont exécutées localement par une seule partie avec de l'aléa tiré de `/dev/urandom`. Qui exécute `build.sh` pourrait conserver les toxiques et forger des preuves. La thèse mentionne le trusted setup comme limite de SOTP-High. Un usage réel exigerait une cérémonie multipartite.
- Aucun audit du code, du circuit ni des dépendances. La correction du prédicat d'exemple ne vaut que pour la règle jouet décrite ci-dessus.
- Aucune sécurité post-quantique (Groth16 et Pedersen reposent sur des hypothèses de type logarithme discret et appariement).

## Prérequis

- Node.js ≥ 18 (testé avec Node 22.22.2) et npm.
- Aucune installation globale. Le compilateur Circom est fourni par le paquet npm `circom2` (circom 2.2.2 compilé en WebAssembly).

Les versions sont épinglées dans `package.json` et `package-lock.json`.

| Paquet | Version | Rôle |
|---|---|---|
| `circom2` | 0.2.22 (circom 2.2.2) | compilation du circuit |
| `snarkjs` | 0.7.6 | Powers of Tau, setup, preuve et vérification Groth16 |
| `circomlib` | 2.0.5 | gadgets Poseidon, Baby Jubjub, comparateurs |
| `circomlibjs` | 0.1.7 | calculs de référence hors circuit et contrôle $b_2$ |

## Commandes

```bash
npm install                      # dépendances épinglées
bash scripts/build.sh            # compilation + Powers of Tau 2^13 + setup Groth16 (≈ 5 min)
bash scripts/prove.sh inputs/conforme.json          # -> build/out/conforme/
bash scripts/verify.sh build/out/conforme           # b1 (snarkjs CLI puis JS) et b2
node scripts/verify.js build/out/conforme --open build/out/conforme/opening.json   # ouverture de c_m
node scripts/prove.js inputs/non_conforme.json build/out/nc   # échoue, code de sortie 2
npm test                         # node --test test/sotp_high.test.js
bash scripts/run_all.sh          # chaîne complète (REBUILD=1 pour refaire la mise en place)
```

### Fichiers d'entrée

| Fichier | Contenu | Résultat attendu |
|---|---|---|
| `inputs/conforme.json` | $m = 750\,000$, seuil $10^6$, type 1 | preuve acceptée |
| `inputs/conforme_limite.json` | $m = 999\,999$, seuil $10^6$, type 3 | preuve acceptée |
| `inputs/non_conforme.json` | $m = 1\,500\,000$, seuil $10^6$ | pas de témoin |
| `inputs/seuil_atteint.json` | $m = 10^6$ égal au seuil | pas de témoin |
| `inputs/type_non_autorise.json` | type 7 | pas de témoin |
| `inputs/hors_plage.json` | $m = p - 1$ | pas de témoin (contrôle de plage) |

Un champ `rho` facultatif fixe l'aléa d'engagement. En son absence, `prove.js` le tire uniformément dans $[0, \ell)$.

### Fichiers produits

`scripts/prove.js` écrit dans le dossier de sortie `proof.json` ($\pi$), `public.json` ($h_c$, `cm_x`, `cm_y`), `sigma.json` ($\sigma$ avec métadonnées, dont l'empreinte SHA-256 de la clé de vérification) et `opening.json`. Ce dernier contient l'ouverture secrète $(m, c, \rho)$ conservée par le prouveur. Il est exclu du suivi de version.

Le dossier `examples/` conserve `verification_key.json`, une preuve `proof.json`, ses signaux `public.json` et `sigma.json`. Les fichiers volumineux (`.ptau`, `.zkey`, `.r1cs`, `.wasm`) sont ignorés par git et régénérés par `scripts/build.sh`. La clé de vérification d'`examples/` correspond à la dernière mise en place exécutée. Une nouvelle exécution de `build.sh` produit une autre clé, puis `run_all.sh` régénère les exemples.

## Sortie attendue (extrait de `run_all.sh`)

```text
[prove] witness + Groth16 proof OK for inputs/conforme.json in 1239 ms
[verify] b1 Groth16.Verify = true
[verify] b2 c_m in subgroup = true
[verify] opening (m, c, rho) matches (h_c, c_m) = true
[verify] ACCEPT
   non_conforme: no witness (expected)
   seuil_atteint: no witness (expected)
   type_non_autorise: no witness (expected)
   hors_plage: no witness (expected)
# tests 15
# pass 15
# fail 0
### run_all: all steps passed
```

## Performances mesurées

Les mesures ont été relevées sur la machine de développement (Linux, Node 22.22.2, snarkjs 0.7.6). Elles sont indicatives.

| Grandeur | Valeur |
|---|---|
| Contraintes R1CS | 6 135 (5 457 non linéaires, 678 linéaires) |
| Fils (wires) | 6 135 |
| Entrées privées / sorties publiques | 6 / 3 |
| Powers of Tau | $2^{13}$ = 8 192 |
| Mise en place complète (`build.sh`) | ≈ 4 min 40 s (dominée par `powersoftau prepare phase2`) |
| Taille de `proof.json` (JSON compact de snarkjs) | ≈ 723 octets |
| Taille de `public.json` | ≈ 238 octets |
| Taille de $\pi$ compressée (3 éléments de groupe, A et C dans $\mathbb{G}_1$, B dans $\mathbb{G}_2$), à titre informatif | 32 + 64 + 32 = 128 octets |
| Génération du témoin et de la preuve | ≈ 0,85 à 1,25 s |
| Vérification Groth16 (à chaud, médiane de 10) | ≈ 26 ms |
| Vérification à froid (initialisation de la courbe comprise) | ≈ 0,3 à 0,9 s |

La taille de 128 octets correspond à la borne basse de l'intervalle de 128 à 200 octets cité par la thèse. Elle reste indépendante de la taille du circuit.

## Organisation

```text
circuits/sotp_high.circom   circuit (ConformeAML, PedersenCommitBJJ, SotpHigh)
scripts/build.sh            compilation et mise en place locale de démonstration
scripts/prove.js|prove.sh   Prove : témoin, preuve, sigma, ouverture
scripts/verify.js|verify.sh Verify : b1 et b2, ouverture facultative
scripts/run_all.sh          chaîne complète
scripts/lib.js              utilitaires (Poseidon, Baby Jubjub, générateurs, aléa)
inputs/                     entrées d'exemple
test/sotp_high.test.js      tests (node:test)
examples/                   clé de vérification, preuve et signaux publics d'exemple
```

## Licence

Code sous licence MIT. Documentation sous licence CC BY 4.0.
