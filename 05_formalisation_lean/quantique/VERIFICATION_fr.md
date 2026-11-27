# Dossier de vérification de la couche quantique

*English version: [VERIFICATION_en.md](VERIFICATION_en.md)*

Ce dossier accompagne `QuantiqueCRO.lean`, version 1.0 du 27 novembre 2026 (lot L5c de la [feuille de route](../FEUILLE_DE_ROUTE_FORMALISATION_fr.md)). Il suit la structure du dossier [`../VERIFICATION_fr.md`](../VERIFICATION_fr.md), reprise du dépôt de la preuve Lean de l'hypothèse de Riemann.

## Pourquoi un projet distinct

Le noyau quantique de `ConditionalCRO.lean` (section 14) pose Pinsker quantique, Fano quantique et la borne de Holevo comme champs d'une instance abstraite. Pour fonder cette couche sur de vrais états quantiques, ce projet emploie la bibliothèque [Physlib](https://github.com/leanprover-community/physlib), partie QuantumInfo, au commit `31f35373ab937172abc689c128177c98405dc936`. Physlib fixe Lean et Mathlib en v4.36.0 alors que `ConditionalCRO.lean` reste en v4.35.0. Le projet a donc son propre `lakefile.toml` et son propre `lean-toolchain`. live.lean-lang.org ne charge pas Physlib : la vérification passe par le workflow GitHub [`verification_lean_quantique.yml`](../../.github/workflows/verification_lean_quantique.yml).

## Ce qu'il faut lire et dans quel ordre

| Ordre | Fichier | Rôle |
|---|---|---|
| 1 | ce document | Carte, traçabilité et limites |
| 2 | [`Verification/Enonces.lean`](Verification/Enonces.lean) | Les 10 énoncés, sans preuve, avec leur renvoi au manuscrit v36 |
| 3 | [`Verification/Principal.lean`](Verification/Principal.lean) | Une ligne par énoncé |
| 4 | [`Verification/Coherence.lean`](Verification/Coherence.lean) | Tests de non-vacuité de `confQ` |
| 5 | [`QuantiqueCRO.lean`](QuantiqueCRO.lean) | Les preuves, 147 lignes |

## Comment vérifier

```bash
cd 05_formalisation_lean/quantique
lake exe cache get && lake build QuantiqueCRO Verification
bash verifier.sh
```

## Ce qui a été compilé

| Contrôle | Où | Résultat |
|---|---|---|
| Version 1.0, `verifier.sh` étapes 1 à 6 | faite par GitHub le 27 novembre 2026 | workflow `verification_lean_quantique.yml`, exécution 46029211703 réussie : 10 énoncés et 2 lemmes de cohérence limités aux trois axiomes standard, `leanchecker` sur les quatre modules, `nanoda_bin` sur `Principal.lean` |
| Compilation locale | conteneur de travail | non faite : le cache de Mathlib v4.36.0 n'y est pas accessible |

## Tableau de traçabilité

| Énoncé du manuscrit | Label | N° et page v36 | Nom Lean | Fichier | E / P | Statut |
|---|---|---|---|---|---|---|
| Conf^q ∈ [0, 1] | `def:conf_quantique_clo`, `def:conf_quantique` | Définitions 2.8 (p. 52) et 2.24 (p. 73) | `confQ_bornes` | 57 | 19 / 14 | démontré |
| Famille indépendante du message, Conf^q = 1 | `def:conf_quantique_clo` | Définition 2.8, p. 52 | `confQ_eq_one_of_indep` | 74 | 25 / 15 | démontré |
| S(A\|B) = S(AB) − S(B) | `def:entropie_conditionnelle_quantique` | Définition 2.14, p. 69 | `entropie_conditionnelle_def` | 93 | 31 / 16 | définition de Physlib |
| I(A;B) = S(A) + S(B) − S(AB) | `def:information_mutuelle_quantique` | Définition 2.15, p. 69 | `information_mutuelle_def` | 97 | 36 / 17 | définition de Physlib |
| 0 ≤ S(ρ) ≤ log d | `subsubsec:von_neumann` | 1.3.2.1, p. 18 | `vonNeumann_bornes` | 101 | 41 / 18 | démontré (Physlib) |
| D_max = log d − S(ρ̄) ≥ 0 | `lem:q_conf_mi_pq` | Lemme 2.8, p. 77 | `Dmax_nonneg` | 108 | 46 / 19 | démontré |
| Sous-additivité de l'entropie de von Neumann | `subsubsec:von_neumann` | 1.3.2.1, p. 18 | `sous_additivite` | 112 | 51 / 20 | démontré (Physlib) |
| I(A;B) ≥ 0 | `def:information_mutuelle_quantique` | Définition 2.15, p. 69 | `information_mutuelle_nonneg` | 117 | 56 / 21 | démontré |
| Sous-additivité forte, I(A;B\|C) ≥ 0 | `subsubsec:von_neumann` | 1.3.2.1, p. 18 | `cmi_quantique_nonneg` | 122 | 61 / 22 | démontré (Physlib) |
| DPI quantique de l'entropie relative | `eq:qdpi` | (1.14), p. 18 | `dpi_quantique` | 129 | 66 / 23 | démontré (Physlib) |

« Démontré (Physlib) » signifie que le théorème de ce dossier applique directement un théorème démontré de Physlib (`Sᵥₙ_le_log_d`, `Sᵥₙ_subadditivity`, `qcmi_nonneg`, `sandwichedRenyiEntropy_DPI`). Les `#print axioms` confirment que ces théorèmes n'utilisent aucun `sorry` de Physlib.

## Limites dites franchement

1. **Lemmes encore posés.** Pinsker quantique (Lemmes 1.4 et 2.4), mesure douce (Lemmes 1.5 et 2.5), Fano quantique (Lemmes 1.6 et 2.6) et la borne de Holevo avec mesure de Helstrom (Lemme 2.7) ne figurent pas dans Physlib sous cette forme. Ils restent des champs du noyau quantique de `ConditionalCRO.lean`. Le chemin prévu est le suivant : Pinsker quantique par la mesure de Helstrom, le Pinsker fini de `ConditionalCRO.lean` et `dpi_quantique` ; Fano quantique par réduction au cas classique sur l'issue d'une POVM.
2. **Pas de lien formel avec `ConditionalCRO.lean`.** Les deux projets n'ont pas la même version de Lean. Le raccord entre `confQ` et le champ `Conf` de `QuantumProtocolInstance` est donc décrit et non démontré.
3. **Égalité décidable classique.** Les lemmes de Physlib sur la distance de trace sont énoncés avec l'égalité décidable classique. La section 1 ouvre `Classical` pour s'y conformer, ce qui ne change pas le sens des énoncés.
4. **Canaux et norme diamant.** Les Définitions 2.18 à 2.22 (canaux dépolarisant, d'amortissement, de déphasage, d'effacement, norme diamant) ne sont pas encore écrites.

## Reproductibilité

| Élément | Valeur |
|---|---|
| Lean | v4.36.0 ([`lean-toolchain`](lean-toolchain)) |
| Physlib | commit `31f35373ab937172abc689c128177c98405dc936` ([`lake-manifest.json`](lake-manifest.json)) |
| Mathlib | v4.36.0, commit `fc4f59e577feb1a4956671bc04ac18aaaf8cd842` |
| SHA-256 de `QuantiqueCRO.lean` | `6ff36963f2bb7a57a0e390325b56866dc1e30c0eda1a5d4293686175b9cb1bc9` (version 1.0) |
