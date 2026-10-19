# P4 — Protocole standardisé d'estimation conjointe de $\Delta$ et $\alpha$

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.4 (algorithme `alg:estimation_conjointe`)

[English version](protocole_en.md) · [README du dossier](README_fr.md)

## 1. Objet

La thèse demande que les paramètres institutionnels soient mesurés **indépendamment** et **conjointement** avant le calcul de toute prédiction CRO (§4.2.4). P4 fixe la séquence, les prérequis et les seuils de cette mesure, de sorte que deux équipes appliquant les mêmes étapes aux mêmes entrées obtiennent des estimations compatibles.

P4 n'est pas une nouvelle campagne de terrain. Il s'applique :

- aux données de P1, qui en est la mise en œuvre la plus complète ;
- à toute autre institution étudiée, avec un effectif d'au moins 30 participants.

## 2. Entrées et sorties

| | Contenu |
|---|---|
| Entrées | institution $I$, types de preuves, contexte $C$ |
| Sorties | $\hat\Delta$ en bits, $\hat\alpha$ sans unité |
| Non couvert | $\beta$. L'algorithme de la thèse ne donne pas d'estimateur de $\beta$. P4 ne le calcule donc pas. |

## 3. Prérequis (ligne `Require` de l'algorithme)

Les trois prérequis sont des conditions d'entrée. Ils doivent être réunis **avant** toute collecte.

1. Accord institutionnel préalable.
2. Avis favorable d'un comité d'éthique de la recherche.
3. Effectif d'au moins 30 participants. En deçà, les estimateurs d'information mutuelle deviennent instables (thèse, §4.2.4).

Instrument : [liste de contrôle des prérequis](liste_controle_prerequis_fr.md). La fonction `cro_terrain.p4.Prerequisites` reprend la même vérification et la mentionne en tête du rapport d'analyse.

## 4. Les six étapes

| Étape | Contenu (thèse) | Mise en œuvre proposée | Instrument |
|---|---|---|---|
| 1 | Collecte des verdicts, des scores de confiance et des temps de décision | comme en P1, une ligne par participant et par paire contexte–preuve | [gabarit_verdicts_fr.csv](gabarit_verdicts_fr.csv), ou les données de P1 converties par `p4.p1_to_p4` |
| 2 | Appariement de chaque verdict au message $m$, connu du seul expérimentateur | colonne `message_m` remplie à la saisie depuis la vérité terrain | fiches stimulus |
| 3 | Test d'admissibilité $V \perp M \mid (\Sigma, C)$ | test de permutation conditionnel, seuil 0,01 | `statistics.admissibility_permutation_test` |
| 4 | $\hat\Delta \leftarrow \hat I(V;\Sigma\mid M,C)$ | Miller–Madow, IC 95 % par bootstrap sur les participants | `information.delta_hat` |
| 5 | $\hat\alpha \leftarrow \log_2|\mathcal{V}|/H(C)$, indépendamment de $\hat\Delta$ | $|\mathcal{V}|$ dénombré dans les textes de l'institution, $H(C)$ issu de P2 | [fiche de dénombrement](fiche_denombrement_verdicts_fr.md), `information.alpha_hat` |
| 6 | Validation, ICC $\geq 0{,}8$ et $\kappa \geq 0{,}7$ | ICC test-retest sur la confiance, $\kappa$ inter-évaluateurs sur le verdict | [grille de fiabilité](grille_fiabilite_fr.md), `reliability` |

La fonction `cro_terrain.p4.estimation_conjointe` enchaîne les six étapes et rend un rapport dans lequel chaque étape garde son propre statut. Une étape qui échoue reste visible et ne contamine pas silencieusement les suivantes.

## 5. Précisions sur les étapes

### 5.1 Étape 3, admissibilité

Le test n'a de puissance que dans les strates $(\Sigma, C)$ où $M$ prend au moins deux valeurs. Le nombre de strates informatives est rapporté. Si aucune strate n'est informative, le résultat est « non testable avec ce codage de $\Sigma$ ». Ce cas ne vaut pas preuve d'admissibilité.

Lorsque l'admissibilité est rejetée au seuil 0,01, $\hat\Delta$ est encore calculé, mais il est rapporté comme non interprétable en tant que capacité d'extraction (critère `tab:criteres_refutation`).

### 5.2 Étape 5, dénombrement de $|\mathcal{V}|$

La thèse calcule $\hat\alpha$ à partir de $\log_2|\mathcal{V}|$. P4 propose de dénombrer $\mathcal{V}$ dans les textes qui régissent l'institution (code de procédure, règlement, référentiel de contrôle). On n'utilise pas les verdicts observés, qui dépendent de l'échantillon. La [fiche de dénombrement](fiche_denombrement_verdicts_fr.md) est remplie par deux personnes indépendantes, l'une juriste et l'autre membre de l'institution.

Le niveau de verdict doit être cohérent avec celui de l'étape 4. Avec le verdict global de P1, on a $|\mathcal{V}| = 4$ et $\log_2|\mathcal{V}| = 2$ bits. Le choix entre verdict global et vecteur d'items est déposé avant la collecte ([plan d'analyse](../00_commun/plan_analyse_statistique_fr.md), section 6).

### 5.3 Étape 5, critère portant sur $\gamma$

$\hat H(V\mid C)$ est estimé par NSB, avec un IC par bootstrap sur les participants. L'hypothèse du verdict efficace est réfutée si la borne supérieure de l'IC 95 % est inférieure à $\alpha H(\mathcal{C}) - 1$ (tableau `tab:criteres_refutation`).

### 5.4 Étape 6, fiabilité

| Statistique | Données | Seuil |
|---|---|---|
| ICC(2,1) en accord absolu | confiance (ou score moyen des items) en session 1 et en session 2 sur les mêmes items | $\geq 0{,}8$ |
| $\kappa$ de Cohen inter-évaluateurs | moyenne sur les paires de participants d'une même strate, sur les stimulus vus par les deux | $\geq 0{,}7$ |
| $\kappa$ de Cohen test-retest | verdict en session 1 et en session 2 | rapporté, sans seuil propre dans l'algorithme |

Si un seuil n'est pas atteint, les estimations sont rapportées avec la mention « fiabilité insuffisante » et ne servent pas à appliquer les critères de réfutation. Si une statistique ne peut pas être calculée (pas de session 2, pas de stimulus commun), la mention est « fiabilité non calculable ».

Pour l'étape 6, un item est un stimulus, c'est-à-dire une paire (contexte, preuve), quelle que soit la variante $\sigma$ présentée. Dans P1, les participants d'une même strate qui voient une même paire reçoivent des variantes différentes par construction.

## 6. Rapport

Le rapport suit le [modèle de rapport d'estimation](rapport_estimation_fr.md). Il présente une ligne par étape, avec son statut, puis $\hat\Delta$ et $\hat\alpha$ avec leurs incertitudes. Il rend aussi la décision sur chaque critère de réfutation concerné ($\Delta$, admissibilité, $\gamma$).

## 7. Calendrier et ressources

La thèse n'attribue pas de ligne budgétaire propre à P4, qui réutilise les données de P1 (tableau `tab:programme_experimental`). Pour une institution hors P1, la durée et le coût suivent ceux de P1 rapportés à l'effectif **[à arrêter par l'équipe]**.

Licence CC BY 4.0.
