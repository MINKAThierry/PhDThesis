# Plan d'analyse statistique

> **Statut : PROPOSITION: protocole non déployé** · Source : thèse, chapitre 4, §4.2.1.1, §4.2.1.4, §4.2.2, §4.2.4 et §4.2.7.3

[English version](plan_analyse_statistique_en.md)

Ce plan fixe les calculs avant toute collecte. Il complète le [pré-enregistrement](preenregistrement_fr.md). Les choix que la thèse ne tranche pas sont marqués [à arrêter par l'équipe]. Le code correspondant sera placé dans le dossier `analyse/` du dépôt.

## 1. Notations

- $V$ verdict du participant. Deux niveaux sont distingués. $V_{\text{glob}}$ désigne le verdict global (item Q01, 4 modalités). $V$ désigne le vecteur formé de Q01 et des 22 items de dimension (Q02 à Q25 hors contrôles d'attention), chacun à 8 modalités.
- $\Sigma$ variante de preuve présentée, $M$ message engagé (vérité terrain connue de l'expérimentateur seul), $C$ contexte.
- $N$ nombre d'observations dans la cellule considérée, $\hat K$ nombre de cases non vides.
- Toutes les entropies sont en bits.

## 2. Préparation des données

1. Double saisie et rapprochement (voir le [plan de gestion des données](plan_gestion_donnees_fr.md)).
2. Calcul de `echecs_attention` (Q09 attendu 3, Q18 attendu 0, Q28 attendu égal au domaine du stimulus).
3. Application des règles d'exclusion pré-enregistrées (section 8 du pré-enregistrement). Les exclusions sont rapportées par strate et par stimulus.
4. Codage de « impossible à déterminer » comme une modalité distincte du verdict (code 0). Une non-réponse n'est pas une modalité. Les observations comportant plus de ____ items de dimension sans réponse sont écartées de l'analyse de $V$ **[à arrêter par l'équipe]**.

## 3. Estimateurs d'entropie

**Plug-in.** $\hat H_{\text{PI}} = -\sum_k \hat p_k \log_2 \hat p_k$ avec $\hat p_k = n_k / N$.

**Miller–Madow.** $\hat H_{\text{MM}} = \hat H_{\text{PI}} + \dfrac{\hat K - 1}{2N \ln 2}$.

**NSB.** Estimateur bayésien de Nemenman, Shafee et Bialek, fondé sur un mélange de lois a priori de Dirichlet choisi pour rendre quasi uniforme la loi a priori de l'entropie. Il est retenu pour les petits échantillons (thèse, §4.2.1.1). Le cardinal de l'alphabet transmis à l'estimateur est le nombre de modalités possibles. Ce n'est pas le nombre de modalités observées.

Les entropies conditionnelles sont des moyennes pondérées sur les cellules de conditionnement, par exemple $\hat H(V\mid M,C=c) = \sum_m \hat p(m\mid c)\, \hat H(V\mid M=m, C=c)$.

## 4. Test d'admissibilité $V \perp M \mid (\Sigma, C)$

Condition de la Définition de l'interprétation institutionnelle admissible (chapitre 2, §2.3.1.2). Test de permutation (thèse, algorithme `alg:estimation_delta`, ligne 6).

1. Statistique $T = \hat I_{\text{MM}}(V_{\text{glob}}; M \mid \Sigma, C)$, calculée sur toutes les observations de phase 1 d'une strate et d'un contexte.
2. Permutation des étiquettes $m$ à l'intérieur de chaque cellule $(\sigma, c)$, ce qui préserve la loi jointe de $(V,\Sigma,C)$ et la loi marginale de $M$ dans chaque cellule.
3. $B = 10\,000$ permutations **[à arrêter par l'équipe]**. Valeur $p = (1 + \#\{T^{*} \geq T\}) / (B + 1)$.
4. Rejet au seuil $0{,}01$ (critère de réfutation). Le test est répété sur le vecteur $V$ réduit aux items dont la loi est la plus dispersée **[à arrêter par l'équipe]**.

Lorsque la variante $\sigma$ détermine entièrement $m$ (par exemple une signature ECDSA présentée avec le document signé, public par destination), $I(V;M\mid\Sigma,C) = 0$ par construction et le test est sans objet. Ce cas est signalé dans la fiche du stimulus.

Si l'admissibilité est rejetée pour un contexte, l'estimation de $\Delta$ sur ce contexte est rapportée mais déclarée hors cadre (thèse, §4.2.1.4).

## 5. Estimation de $\Delta$

### 5.1 Estimateur principal

$$\hat\Delta = \hat I(V;\Sigma\mid M,C) = \hat H(V\mid M,C) - \hat H(V\mid \Sigma,M,C)$$

calculé à contexte $c$ fixé (thèse, éq. `eq:estimateur_delta`), puis agrégé sur les contextes d'un même type de preuve par moyenne pondérée par $\hat p(c)$. Les résultats sont présentés par strate, par type de preuve et pour l'ensemble.

### 5.2 Intervalle de confiance

Bootstrap non paramétrique sur les participants (thèse, §4.2.1.1). Pour chaque strate, on tire avec remise autant de participants que la strate en compte, on reprend toutes leurs observations puis on recalcule $\hat\Delta$. $B = 2\,000$ réplicats **[à arrêter par l'équipe]**. IC 95 % par la méthode des percentiles, avec la méthode BCa en analyse de sensibilité.

### 5.3 Point de vigilance sur la taille des cellules

Un estimateur plug-in de l'information mutuelle ne peut dépasser $\log_2 N$ dans une cellule de $N$ observations. Avec 120 participants et 10 contextes chacun, chacune des 50 paires reçoit en moyenne 24 observations, soit 4 environ par strate. L'estimation directe sur le vecteur $V$ ne peut donc pas atteindre les valeurs de 25 à 65 bits prédites par la thèse, quelle que soit la valeur vraie. Deux voies sont proposées **[à arrêter par l'équipe]**, toutes deux à rapporter.

- **Décomposition par items.** Par la règle de chaîne, $I(V;\Sigma\mid M,C) = \sum_{k} I(V_k;\Sigma\mid M,C,V_{<k})$. L'estimation tronque le conditionnement sur $V_{<k}$ à un ordre ____ **[à arrêter par l'équipe]**. À l'ordre zéro, la somme $\sum_k \hat I(V_k;\Sigma\mid M,C)$ majore l'information jointe lorsque les items sont conditionnellement indépendants sachant $(\Sigma,M,C)$. Cette approximation d'indépendance est du même type que celle de l'approche structurelle de $H(\mathcal{C})$ (thèse, §4.2.2.2). Son sens de biais doit être pris en compte dans l'application du critère de réfutation sur $\Delta$, qui porte sur la borne inférieure de l'IC.
- **Agrégation des contextes.** Mise en commun des observations de contextes jugés équivalents par le panel P2, ce qui augmente $N$ par cellule au prix d'une hypothèse d'homogénéité.

La conception des stimuli doit en outre prévoir, pour chaque couple $(m,c)$, au moins deux variantes $\sigma$ présentées à des participants différents. Sans cette variation, $\hat I(V;\Sigma\mid M,C)$ est nulle par construction.

### 5.4 Hypothèses dérivées

- H1.1 à H1.3. Comparaison de $\hat\Delta$ par strate aux valeurs prédites (25, 40 et 65 bits). Rapport de l'IC 95 %.
- H1.4. Différence $\hat\Delta_{\text{ECDSA}} - \hat\Delta_{\text{Helios}}$ dans chaque strate, IC par le même bootstrap sur participants. Prédiction confirmée dans une strate si la borne inférieure de l'IC est positive.
- H1.5. Rapport $\hat\Delta / 20$ bits par strate, comparé à l'intervalle 1,8 à 3,7.

## 6. Estimation de $\alpha$ et critère portant sur $\gamma$

- $\hat\alpha = \log_2|\mathcal{V}| / H(C)$, calculé indépendamment de $\hat\Delta$ (thèse, §4.2.4, étape 5). $H(C)$ provient de P2 ou, à défaut, de la table des paramètres de référence (thèse, §4.1.3).
- La valeur de $|\mathcal{V}|$ dépend du niveau de verdict retenu. Pour $V_{\text{glob}}$, $\log_2|\mathcal{V}| = 2$ bits. Pour le vecteur $V$, $\log_2|\mathcal{V}| = 2 + 22 \times 3 = 68$ bits, valeur fixée par l'instrument. Le niveau retenu pour $\hat\alpha$ est **[à arrêter par l'équipe]**. Les deux sont rapportés.
- Critère $\gamma$. $\hat H(V\mid C)$ est estimé par NSB avec IC bootstrap sur participants. L'hypothèse du verdict efficace est réfutée si la borne supérieure de l'IC 95 % est inférieure à $\alpha H(\mathcal{C}) - 1$, au même niveau de verdict que celui retenu pour $\alpha$.

## 7. Fiabilité

| Indicateur | Données | Méthode | Seuil (thèse) |
|---|---|---|---|
| Test-retest | 3 contextes re-présentés à J+14 (phase 2) | ICC(2,1) en accord absolu sur le score moyen des items de dimension et sur la confiance | ICC $\geq 0{,}8$ |
| Test-retest du verdict global | idem | $\kappa$ de Cohen entre phase 1 et phase 2 sur Q01 | $\kappa \geq 0{,}7$ |
| Inter-évaluateurs | Participants d'une même strate ayant vu le même stimulus | Moyenne des $\kappa$ de Cohen par paires sur Q01. Le $\kappa$ de Fleiss est donné en complément **[à arrêter par l'équipe]** | $\kappa \geq 0{,}7$ |
| Gold standard | Experts `GS-A` et `GS-B` | Pourcentage d'accord et $\kappa$ de Cohen sur Q01 et sur les items de dimension | accord $\geq 90\,\%$ |

Les seuils ICC $\geq 0{,}8$ et $\kappa \geq 0{,}7$ viennent de l'algorithme `alg:estimation_conjointe` (thèse, §4.2.4). Le seuil de 90 % vient de la phase 3 de P1 (thèse, §4.2.1.3). Si un seuil n'est pas atteint, les estimations sont rapportées avec la mention « fiabilité insuffisante » et ne servent pas à appliquer les critères de réfutation.

## 8. Analyses de P2

### 8.1 Décomposition structurelle

$H(C) = H(L) + H(T\mid L) + H(R\mid L,T)$ (thèse, glossaire des notations). Pour chaque composante, l'entropie d'un élément à $k$ modalités équiprobables vaut $\log_2 k$. Les éléments sont sommés sous l'hypothèse d'indépendance approximative (thèse, §4.2.2.2). Les estimations des experts sont résumées par la médiane et l'écart interquartile par domaine.

### 8.2 Modélisation par MDS

1. Matrice de dissimilarité $D \in \mathbb{R}^{100\times 100}$, moyenne des jugements des experts (thèse, §4.2.2.3).
2. MDS classique. Le nombre de dimensions retenu est le plus petit qui ramène le stress de Kruskal sous ____ **[à arrêter par l'équipe]**.
3. Covariance empirique $\hat\Sigma$ des coordonnées, volume effectif $V_{\text{eff}} = \det(\hat\Sigma)^{1/2}$, estimation $H(\mathcal{C}) \approx \log_2 V_{\text{eff}}$ (thèse, §4.2.2.3).
4. $V_{\text{eff}}$ dépend de l'unité de l'échelle de dissimilarité. L'unité retenue (par exemple un écart juste discernable fixé à une graduation de l'échelle 0 à 10) est **[à arrêter par l'équipe]** avant collecte.
5. Incertitude par bootstrap sur les experts.

### 8.3 Delphi

Médiane et écart interquartile de $H(\mathcal{C})$ à chaque tour. Arrêt lorsque l'écart interquartile est inférieur à 5 bits (thèse, §4.2.2.4). La valeur retenue est la médiane du dernier tour.

### 8.4 Confrontation des trois approches

Les trois estimations sont confrontées aux plages du tableau `tab:estimations_structurelles_HC`. Leur écart est rapporté sans être combiné en une valeur unique **[à arrêter par l'équipe]**.

## 9. Multiplicité et rapport

- Les critères de réfutation sont appliqués tels que pré-enregistrés, sans correction de multiplicité, car chacun porte sur une hypothèse distincte de la thèse.
- Les comparaisons secondaires (H1.4 sur six strates) sont accompagnées d'une correction de Holm **[à arrêter par l'équipe]**.
- Toute analyse non prévue ici est publiée dans une section « exploratoire ».
- Les graines aléatoires des permutations et du bootstrap sont fixées et publiées avec le code.

## 10. Logiciel

Python 3 avec numpy, scipy, pandas et scikit-learn pour le MDS. L'estimateur NSB sera implémenté ou repris d'une bibliothèque de référence **[à arrêter par l'équipe]**. Le code est versionné dans `analyse/` sous licence MIT et testé sur des données simulées avant l'ouverture des données réelles.
