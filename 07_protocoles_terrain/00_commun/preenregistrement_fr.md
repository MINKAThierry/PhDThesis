# Modèle de pré-enregistrement (OSF)

> **Statut : PROPOSITION: protocole non déployé** · Source : thèse, chapitre 4, §4.2.1, §4.2.2, §4.2.4 et §4.2.7.3 (tableau `tab:criteres_refutation`)

[English version](preenregistrement_en.md)

Ce modèle suit la structure du gabarit « OSF Preregistration ». Il est à compléter une fois par protocole (P1 à P7) puis à déposer sur OSF avec horodatage **avant toute collecte**. Les champs « ____ » sont à remplir. Les mentions [à arrêter par l'équipe] doivent toutes être levées avant le dépôt.

## 1. Informations administratives

- Titre de l'étude : ____________________________________________
- Protocole concerné : ☐ P1 $\Delta$ ☐ P2 $H(\mathcal{C})$ ☐ P3 $\mathsf{Opp}$ Helios ☐ P4 $\Delta$ et $\alpha$ ☐ P5 $\Delta_q$ ☐ P6 $\eta_q$ ☐ P7 combiné
- Investigateur principal : ____________________ Institution : LIMSI / ENSP, Université de Yaoundé I
- Équipe (initiales et rôles) : ____________________________________________
- Numéro d'approbation éthique : ____________ Date : ___ / ___ / ______
- Conventions institutionnelles signées (références) : ____________________________________________
- Version du protocole : ______ Date du dépôt OSF : ___ / ___ / ______ Lien OSF : ____________________
- Dépôt de code associé : https://github.com/MINKAThierry/PhDThesis (dossier `07_protocoles_terrain/`)

## 2. Hypothèses

Les hypothèses sont reprises de la thèse. Elles sont conditionnelles au cadre de la cryptographie institutionnelle, dans lequel $\Delta$, $\alpha$, $\beta$, $H(\mathcal{C})$, $\Delta_q$ et $\eta_q$ sont des paramètres institutionnels.

### 2.1 Hypothèses testées par P1 (thèse, §4.2.1.5)

| Code | Prédiction (thèse) | Population |
|---|---|---|
| H1.1 | $\hat\Delta_{\text{juge général}} \approx 25$ bits | Juges généralistes (juridictions civiles) |
| H1.2 | $\hat\Delta_{\text{juge PKI}} \approx 40$ bits | Juges spécialisés (contrats, PKI, numérique) |
| H1.3 | $\hat\Delta_{\text{régulateur senior}} \approx 65$ bits | Régulateurs financiers seniors |
| H1.4 | $\hat\Delta_{\text{ECDSA}} > \hat\Delta_{\text{Helios}}$ pour tout sous-groupe | Les six sous-groupes |
| H1.5 | Facteur d'amplification institutionnelle de 1,8 à 3,7 par rapport à la capacité individuelle de Miller (environ 20 bits) | Ensemble de l'échantillon |

Le tableau `tab:stratification_delta` prédit en outre $\approx 35$ bits pour les régulateurs juniors, $\approx 45$ bits pour les auditeurs de la Cour des comptes et $\approx 55$ bits pour les auditeurs de cabinets privés.

### 2.2 Hypothèses testées par P2 (thèse, §4.2.2.2, tableau `tab:estimations_structurelles_HC`)

| Code | Domaine | $H(\mathcal{C})$ estimé (thèse) |
|---|---|---|
| H2.1 | Contentieux électoral | 30 à 50 bits |
| H2.2 | Conformité financière | 40 à 70 bits |
| H2.3 | Signature contractuelle | 20 à 40 bits |

Ces plages portent sur l'entropie de la distribution des contextes d'un domaine et non sur le contexte d'espèce (thèse, §4.2.2.1 et §4.3.1).

### 2.3 Hypothèses des autres protocoles (rappel)

- P3 (§4.2.3.5) : $\mathsf{Opp}_{\text{prédit}} = 0{,}50$ pour Helios. Accord si $|\mathsf{Opp}_{\text{emp}} - 0{,}50| \leq 0{,}05$. Désaccord si 0,50 tombe hors de l'IC 95 % bootstrap de $\mathsf{Opp}_{\text{emp}}$.
- P4 (§4.2.4) : validation si ICC $\geq 0{,}8$ et $\kappa \geq 0{,}7$.
- P5 (§4.2.5.5) : $\hat\Delta_q < \hat\Delta$ pour les acteurs non formés, $\hat\Delta_q \to \hat\Delta$ pour les experts PQC, $\hat\Delta_q \in [28, 67]$ bits pour les institutions bien préparées, décroissance de $\Delta_q$ avec le bruit, corrélation positive entre formation PQC et $\Delta_q$.
- P6 (§4.2.6.5) : $\hat\eta_q \in [0{,}05 ; 0{,}15]$ pour un support simulé aux taux d'erreur du matériel actuel, $\hat\eta_q = 0$ aux fluctuations d'échantillonnage près lorsque la preuve est lue comme chaîne de bits (contrôle négatif).

### 2.4 Valeurs fixées avant l'expérience

| Grandeur | Valeur pré-enregistrée | Source |
|---|---|---|
| Capacité $\Delta$ de référence par strate | ____ bits (proposition : valeurs du tableau `tab:stratification_delta`) | thèse, §4.2.1.2 |
| $\alpha$ de référence par domaine | ____ (proposition : 1,0 ECDSA, 1,2 Helios, 1,5 zk-SNARK) | thèse, §4.1.3 |
| $H(\mathcal{C})$ de référence | ____ bits (issue de P2 si disponible, sinon tableau `tab:parametres_reference`) | thèse, §4.1.3 et §4.2.2 |
| Intervalle prédit pour $\eta_q$ | ____ (proposition : $[0{,}05 ; 0{,}15]$) | thèse, §4.2.6.5 |

## 3. Plan de recherche et échantillonnage

- Type d'étude : ☐ expérimentale à mesures répétées (P1, P4, P5) ☐ élicitation d'experts (P2) ☐ audit sur système déployé (P3) ☐ simulation avec participants (P6, P7)
- Population et strates : voir [fiche_recrutement_stratification_fr.md](fiche_recrutement_stratification_fr.md).
- Effectif cible (thèse) : P1 120 (6 strates de 20) ; P2 20 experts Delphi et 5 à 10 experts MDS ; P3 10 trustees ; P5 80 ; P6 40 ; P7 40. Effectif minimal de validité (thèse, §4.2.4) : $n \geq 30$.
- Mode d'assignation des stimuli (P1) : rotation équilibrée de 10 contextes par participant parmi les 50 paires contexte–preuve. Schéma proposé : 2 contextes par type de preuve, carré latin équilibré par strate **[à arrêter par l'équipe]**.
- Aveugle : le message $m$ (vérité terrain) est connu de l'expérimentateur et non des participants. Les experts du gold standard ignorent la strate des participants.

## 4. Variables et estimateurs

### 4.1 Variables mesurées

Verdict $v$ (vecteur des réponses aux items de verdict), confiance subjective (0 à 10), temps de décision (secondes), items de contrôle d'attention, identifiants pseudonymisés du stimulus, du contexte $c$, de la preuve $\sigma$ et du message $m$. Le détail figure dans le [dictionnaire des variables](dictionnaire_variables_fr.md).

### 4.2 Estimateur principal de $\Delta$ (thèse, éq. `eq:estimateur_delta`)

$$\hat{\Delta} = \hat{I}(V;\Sigma \mid M, C)$$

calculé sur les triplets $(v_i, \sigma_i, m_i)$ recueillis à contexte $c$ fixé. Deux variantes sont pré-enregistrées.

- Plug-in avec correction de Miller–Madow. Pour une entropie estimée sur $N$ observations avec $\hat K$ cases non vides, $\hat H_{\mathrm{MM}} = \hat H_{\mathrm{plug\text{-}in}} + (\hat K - 1)/(2N \ln 2)$ en bits. L'information conditionnelle est obtenue par $\hat I(V;\Sigma\mid M,C) = \hat H(V\mid M,C) - \hat H(V\mid \Sigma,M,C)$.
- Estimateur bayésien de type NSB (Nemenman–Shafee–Bialek) pour les petits échantillons.

L'estimateur est biaisé positivement en petit échantillon. L'intervalle de confiance est obtenu par bootstrap non paramétrique sur les participants (thèse, §4.2.1.1). L'estimateur antérieur $I_{\mathrm{emp}}(V;\Sigma\mid C) - I_{\mathrm{vrai}}(M;\Sigma\mid C)$ est abandonné (remarque de la thèse, §4.2.1.1).

### 4.3 Autres estimateurs

- $\hat\alpha = \log_2|\mathcal{V}| / H(C)$, calculé indépendamment de $\hat\Delta$ (thèse, §4.2.1.4 et §4.2.4).
- $\hat H(V\mid C)$ pour le critère portant sur $\gamma$.
- $\hat H(\mathcal{C})$ selon les trois approches de P2 (décomposition structurelle, MDS, Delphi).
- Fiabilité : ICC test-retest et $\kappa$ de Cohen inter-évaluateurs.

Le détail des calculs figure dans le [plan d'analyse statistique](plan_analyse_statistique_fr.md).

## 5. Critères de réfutation

Reproduction à l'identique du tableau `tab:criteres_refutation` de la thèse (§4.2.7.3). Les valeurs seuils sont indicatives et seront arrêtées lors du pré-enregistrement. Leur forme constitue l'engagement méthodologique.

| Paramètre | L'hypothèse est réfutée si… |
|---|---|
| $\Delta$ (Hypothèse d'extraction bornée, chap. 2, §2.3.1.2) | la borne inférieure de l'IC 95 % de $\hat{I}(V;\Sigma\mid M,C)$ dépasse la capacité fixée *avant* l'expérience pour la population étudiée. |
| Admissibilité (Définition de l'interprétation institutionnelle admissible, chap. 2, §2.3.1.2) | un test de permutation rejette $V \perp M \mid (\Sigma,C)$ au seuil $0{,}01$. |
| $\gamma$ (Hypothèse du verdict efficace, chap. 2, §2.3.1.2) | la borne supérieure de l'IC 95 % de $\hat{H}(V\mid C)$ est inférieure à $\alpha H(\mathcal{C}) - 1$. |
| $\eta_q$ (scénario quantique) | l'IC 95 % de $\hat{\eta}_q$ exclut l'intervalle prédit avant l'expérience. |
| Borne (hypothèses vérifiées) | le produit mesuré dépasse la forme raffinée de la borne avec une confiance de 95 %. |

Seuils arrêtés pour la présente étude :

- Capacité de référence par population : ____________________
- Seuil du test d'admissibilité : 0,01 (thèse)
- Valeur de $\alpha$ et de $H(\mathcal{C})$ utilisée pour $\gamma$ : $\alpha =$ ____ $H(\mathcal{C}) =$ ____ bits
- Intervalle prédit pour $\eta_q$ : ____________________

## 6. Règle d'arrêt

La thèse fixe les effectifs cibles mais ne formule pas de règle d'arrêt. La règle suivante est proposée **[à arrêter par l'équipe]**.

1. Plan à effectif fixe. La collecte s'arrête lorsque chaque strate atteint son quota (20 participants par strate pour P1) ou à la fin de la fenêtre de collecte prévue par la thèse (6 mois pour P1, 3 mois pour P2), selon ce qui survient en premier.
2. Aucune analyse intermédiaire de $\hat\Delta$, de $\hat\alpha$ ou de $\hat H(\mathcal{C})$ n'est réalisée avant la clôture. Seuls des indicateurs de qualité (taux de complétion, échecs aux items d'attention, écarts de protocole) sont suivis en cours de collecte.
3. Si une strate n'atteint pas son quota à la clôture, l'analyse porte sur l'effectif obtenu. Les estimations par strate en deçà de ____ participants **[à arrêter par l'équipe]** sont rapportées comme descriptives.
4. Pour l'ensemble de l'échantillon, l'effectif minimal de validité est $n \geq 30$ (thèse, §4.2.4). En deçà, aucun critère de réfutation n'est appliqué.
5. Pour le Delphi (P2), le processus s'arrête lorsque l'écart interquartile devient inférieur à 5 bits (thèse, §4.2.2.4), au plus tard après le quatrième tour.

## 7. Analyses prévues

### 7.1 Analyses confirmatoires

1. Test d'admissibilité $V \perp M \mid (\Sigma,C)$ par permutation, par contexte puis globalement. Si l'admissibilité est rejetée, l'estimation de $\Delta$ pour le contexte concerné est déclarée hors cadre (thèse, §4.2.1.4).
2. Estimation de $\hat\Delta$ par strate avec IC 95 % bootstrap sur les participants. Comparaison à la capacité pré-enregistrée (critère $\Delta$).
3. Comparaison $\hat\Delta_{\text{ECDSA}}$ contre $\hat\Delta_{\text{Helios}}$ dans chaque sous-groupe (H1.4) par différence appariée sur participants et IC bootstrap.
4. Rapport $\hat\Delta / 20$ bits pour H1.5.
5. Critère $\gamma$ sur $\hat H(V\mid C)$.

### 7.2 Analyses de fiabilité

ICC test-retest (seuil 0,8) sur les 3 contextes re-présentés à J+14. $\kappa$ de Cohen inter-évaluateurs (seuil 0,7). Accord du gold standard (seuil 90 %).

### 7.3 Analyses exploratoires (signalées comme telles)

Relations entre $\hat\Delta$ et ancienneté, formation cryptographique, confiance, temps de décision. Comparaison des trois estimations de $H(\mathcal{C})$.

## 8. Exclusions de données

Proposition **[à arrêter par l'équipe]** :

- Réponses d'un contexte exclues si le participant échoue à au moins 2 des 3 items de contrôle d'attention de ce contexte.
- Réponses d'un contexte signalées si le temps de complétion est inférieur à ____ secondes.
- Toutes les données d'un participant retirées s'il exerce son droit de retrait avant la date d'anonymisation.
- Contextes dont l'accord du gold standard reste inférieur à 90 % après arbitrage exclus des analyses d'exactitude.

## 9. Écarts au pré-enregistrement

Tout écart est déclaré au moyen de la [fiche d'écart de protocole](fiche_ecart_protocole_fr.md) puis rapporté dans la publication des résultats.

Signature de l'investigateur principal : ____________________ Date : ___ / ___ / ______
