# Schéma des données

> **Statut : PROPOSITION — calibration illustrative** · Source : thèse, chapitre 4, `tab:parametres_reference` (§4.1.3), `sec:donnees_brutes` et `tab:structure_csv` (§4.4.10)

[English version](SCHEMA_en.md)

Licence CC BY 4.0. Encodage UTF-8, séparateur virgule, point décimal.

Toutes les valeurs sont des **paramètres de calibration illustratifs**. Ce ne sont pas des mesures (voir [`../../03_resultats_these/resultats_these_fr.md`](../../03_resultats_these/resultats_these_fr.md), entrées R9 et R14).

## `parametres_reference.csv`

Il s'agit de la table unique de référence (`tab:parametres_reference` de la thèse). Toute valeur de $H(C)$, $\Delta$ ou $\alpha$ citée dans le manuscrit doit en provenir. Le fichier contient les trois systèmes classiques ; la ligne ML-DSA-65 de la table de la thèse figure dans `calibration_pq.csv`.

| Colonne | Type | Description |
|---|---|---|
| `system` | texte | Identifiant du système |
| `usage` | texte | Contexte institutionnel |
| `H_C_domaine` | réel (bits) | Entropie du contexte institutionnel général (chapitre 2) |
| `H_C_espece` | réel (bits) | Entropie du contexte d'une décision particulière (`sec:derivation_opposabilite`) |
| `H_V_C_espece` | réel (bits) | $H(V\mid C)$ dérivée de l'espace de verdicts d'espèce |
| `alpha` | réel | Granularité des verdicts $\alpha$ |
| `beta` | réel | Régularité $\beta$ (utilisée par les heuristiques SOTP) |
| `Delta` | réel (bits) | Capacité d'extraction institutionnelle $\Delta$ (calibration) |
| `lambda` | entier | Paramètre de sécurité de la calibration |
| `Conf_clo`, `Rel_ver_clo`, `Opp_clo` | réels | Métriques CLO de l'article CLO (échelle opérationnelle, fiabilité de vérification) |
| `product_clo` | réel | Produit $\mathrm{Conf}\cdot\mathrm{Rel}_{\mathrm{ver}}\cdot\mathrm{Opp}$ |
| `sotp_variant` | texte | Variante SOTP de référence |
| `sotp_d` | entier | Dimension de projection (SOTP-Base uniquement) |

## `calibration_pq.csv`

Il reproduit `tab:decomposition_borne_pq` et l'échantillon quantique de `sec:donnees_brutes`. Une valeur $\eta_q>0$ correspond au **scénario hypothétique** d'un support ou d'un vérificateur quantique. ML-DSA, SLH-DSA et ML-KEM produisent des chaînes de bits classiques, pour lesquelles $\eta_q=0$.

| Colonne | Type | Description |
|---|---|---|
| `system` | texte | Identifiant (nom de soumission NIST) |
| `nature` | texte | Nature et nom FIPS. ML-KEM est un mécanisme d'encapsulation et **non** une preuve |
| `Delta_q` | réel (bits) | Capacité d'extraction quantique $\Delta_q$ |
| `alpha_q`, `beta_q` | réels | Granularité et régularité |
| `eta_q` | réel | Coefficient de perte d'interprétabilité (scénario) |
| `H_C` | réel (bits) | Entropie contextuelle |
| `lambda` | entier | Paramètre de sécurité |
| `product_clo` | réel | Produit CLO (illustratif) |
| `borne_these` | réel | Valeur imprimée dans la thèse, égale à $(\Delta_q+\eta_q H(C))/\lambda$ |

## Correspondance avec `tab:structure_csv` (formulation initiale)

| Ancienne colonne | Nouvelle | Raison |
|---|---|---|
| `product_meas` | `product_clo` | Aucune mesure n'a été réalisée |
| `product_pred` | `product_clo` | La « prédiction » était le produit CLO lui-même ($\Delta:=\lambda\cdot$ produit) |
| `borne` | `borne_these` (+ `borne_serree` calculée par `validate_sotp.py`) | Distinguer la forme affaiblie de la borne serrée |
