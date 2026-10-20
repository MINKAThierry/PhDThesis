# Protocole de mesure de $\Delta_q$, capacité d'extraction quantique

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.5 (algorithme `alg:estimation_delta_q`, tableau `tab:stratification_delta_q`)

[English version](protocole_en.md) · [README du dossier](README_fr.md)

## 1. Objectif

Mesurer empiriquement la capacité d'extraction institutionnelle quantique $\Delta_q$ (en bits), définie par

$$I(V^q;\Sigma\mid C)_\rho \leq I(M;\Sigma\mid C)_\rho + \Delta_q$$

(thèse, équation `eq:extraction_quantique_op`). La thèse la décompose en $\Delta_q = \Delta + \delta_{\text{enh}} - \delta_{\text{degr}}$, où $\delta_{\text{enh}}$ est le gain dû aux ressources quantiques et $\delta_{\text{degr}}$ la dégradation due au bruit quantique (définition `def:capacite_extraction_quantique_op`).

## 2. Portée, ce qui est mesuré et ce qui est simulé

Les signatures ML-DSA et SLH-DSA sont des chaînes de bits classiques. Pour elles, l'estimateur

$$\hat\Delta_q = \hat I(V^q;\Sigma\mid M,C)$$

coïncide avec l'estimateur classique de P1. On a de plus $\eta_q = 0$ (thèse, §4.2.5.1 et remarque `rem:interpretation_physique_pq`). P5 mesure donc deux choses distinctes.

| Partie | Ce qu'elle mesure | Statut |
|---|---|---|
| Phase 1 | $\hat\Delta_q$ sur des signatures post-quantiques réelles, avec et sans aide à l'interprétation | mesure sur un objet réel |
| Phase 2 | variation de $\hat\Delta_q$ et $\hat\eta_q$ lorsque le résultat de vérification passe par un vérificateur quantique simulé et bruité | **scénario hypothétique** d'un support ou d'un vérificateur quantique |

Les résultats de la phase 2 ne valent que pour ce scénario. Ils ne disent rien d'une perte d'interprétabilité des signatures ML-DSA ou SLH-DSA telles qu'elles sont déployées.

## 3. Participants (tableau `tab:stratification_delta_q`)

$N \geq 80$ professionnels formés aux systèmes post-quantiques.

| Catégorie | Sous-groupe | Code proposé | $n$ | $\Delta_q$ prédit |
|---|---|---|---|---|
| Régulateurs PQC | Juniors (formation initiale) | RQJ | 20 | $\approx 28$ bits |
| Régulateurs PQC | Seniors (formation avancée) | RQS | 20 | $\approx 45$ bits |
| Auditeurs crypto | Classiques (transition PQC) | ACL | 20 | $\approx 35$ bits |
| Auditeurs crypto | Experts PQC certifiés | AEX | 20 | $\approx 67$ bits |
| **Total** | | | **80** | |

Codes participants `P5-<strate>-NNN`. Le profil est recueilli avec le [questionnaire commun](../00_commun/questionnaire_profil_participant_fr.md), dont la question D2 porte sur la formation PQC (prédiction 5).

## 4. Matériel

| Élément (thèse) | Mise en œuvre proposée |
|---|---|
| ML-DSA-65 (FIPS 204) et SLH-DSA (FIPS 205) | ML-DSA-65 et SLH-DSA-SHAKE-128f, signatures produites par des implémentations de référence ([stimuli](stimuli/catalogue_stimuli_pqc_fr.md)) |
| ML-KEM (FIPS 203) | exclu, car c'est un mécanisme d'encapsulation de clé qui ne produit pas de preuve (thèse) |
| Simulateur d'environnement quantique, bruit de dépolarisation $p \in [0{,}001 ; 0{,}1]$ | intégré à l'interface de vérification ([spécification](specification_interface_verification_fr.md)) |
| Interface de vérification avec métriques de performance | [spécification](specification_interface_verification_fr.md) |
| Questionnaires adaptés au contexte NIST PQC | [questionnaire PQC](questionnaire_pqc_fr.md) |

L'algorithme de la thèse prend en entrée trois preuves $\{\sigma_1, \sigma_2, \sigma_3\}$, alors que la liste du matériel ne retient plus que deux schémas depuis l'exclusion de ML-KEM. La proposition retient les deux schémas. Une troisième famille (par exemple FN-DSA, FIPS 206 en projet) pourrait être ajoutée **[à arrêter par l'équipe]**.

## 5. Procédure (thèse, §4.2.5.3)

| Phase | Contenu | Durée | Instrument |
|---|---|---|---|
| 0 | Formation PQC (structure des clés, processus de signature, différences avec RSA et ECDSA, implications institutionnelles de la transition) | 3 h | [support](support_formation_pqc_fr.md) |
| 1 | Pour chaque item : contexte, signature ML-DSA ou SLH-DSA, verdict **sans aide** puis **avec aide**, temps et confiance | 4 h | [questionnaire](questionnaire_pqc_fr.md), [stimuli](stimuli/catalogue_stimuli_pqc_fr.md) |
| 2 | Simulation quantique, conditions A ($p = 0$), B ($0{,}001$), C ($0{,}01$), D ($0{,}1$) | 2 h | [fiche des conditions](fiche_conditions_bruit_fr.md), [interface](specification_interface_verification_fr.md) |
| 3 | Test-retest après 2 semaines | 1 h | [fiche test-retest](fiche_test_retest_pqc_fr.md) |
| 4 | Gold standard PQC par des experts | sans participants | [grille](grille_gold_standard_pqc_fr.md) |
| 5 | Débriefing | 30 min | [fiche](fiche_debriefing_pqc_fr.md) |

### 5.1 Phase 1, avec et sans aide

Pour chaque item, le participant rend d'abord un verdict à partir du dossier seul (`aide = 0`). Il reçoit ensuite une fiche d'aide à l'interprétation propre au schéma, puis rend un second verdict (`aide = 1`), qu'il peut garder identique. Cet ordre fixe, sans aide puis avec aide, évite que l'aide contamine le premier verdict. Il confond en revanche l'effet de l'aide avec celui d'un second examen. Ce point est rapporté **[à arrêter par l'équipe]**.

Plan proposé. 12 paires contexte–preuve (6 par schéma), chacune avec 2 messages et 2 variantes de signature. Chaque participant traite 6 paires, 3 par schéma, choisies par rotation équilibrée.

### 5.2 Phase 2, conditions de bruit

Chaque participant traite 12 items, 3 par condition. Les conditions sont présentées par blocs, dans un ordre de Williams propre au participant (`cro_terrain.p5.latin_square_order`). Dans les conditions B à D, le résultat de vérification affiché est celui d'un vérificateur quantique simulé dont le qubit de sortie subit un canal de dépolarisation de paramètre $p$. Le résultat affiché est donc inversé avec la probabilité $p/2$.

Avec les valeurs de la thèse, cette probabilité vaut au plus 5 % (condition D). L'effet attendu sur $\hat\Delta_q$ est faible. La puissance pour détecter la décroissance (prédiction 4) doit être évaluée par simulation avant la collecte **[à arrêter par l'équipe]**.

## 6. Estimateurs (algorithme `alg:estimation_delta_q`)

1. Présenter $\sigma_i$ avec son contexte $C$, dans l'environnement simulé.
2. Enregistrer les verdicts $V^q$, la confiance, les temps et les erreurs d'interprétation.
3. Apparier chaque verdict au message $m$.
4. Tester l'admissibilité $V^q \perp M \mid (\Sigma, C)$.
5. Estimer $\hat\Delta_q = \hat I(V^q;\Sigma\mid M,C)$, par condition et par modalité d'aide (`p5.delta_q_by_condition`).
6. Estimer $\hat\eta_q$ par régression sur les niveaux de bruit (`p5.eta_q_regression`). Pour chaque condition, $\hat\eta_q(p) = [\hat I(V;\Sigma\mid C)_A - \hat I(V;\Sigma\mid C)_p]/H(C)$, d'après l'équation `eq:estimateur_eta_q`, avec la condition A comme référence. La pente de $\hat\eta_q(p)$ en fonction de $p$ est rapportée.
7. Valider par test-retest et accord inter-évaluateurs (seuils ICC $\geq 0{,}8$ et $\kappa \geq 0{,}7$ de P4).

Une **erreur d'interprétation** est un verdict différent du verdict de référence du gold standard pour le même stimulus, le même message et la même condition (`p5.interpretation_errors`).

La thèse note qu'en régime quantique une faible stabilité test-retest peut refléter soit une incohérence des acteurs, soit une instabilité du canal. La mesure est donc d'abord répétée à bruit constant (condition A) avant que $p$ varie. Le test-retest de la phase 3 porte sur la condition A seulement.

## 7. Prédictions (thèse, §4.2.5.5)

1. $\hat\Delta_q < \hat\Delta$ pour les acteurs non formés (pénalité d'adaptation).
2. $\hat\Delta_q \to \hat\Delta$ pour les experts PQC (adaptation réussie).
3. $\hat\Delta_q \in [28, 67]$ bits pour les institutions bien préparées.
4. Décroissance de $\Delta_q$ avec le niveau de bruit quantique.
5. Corrélation positive entre formation PQC et $\Delta_q$.

Les prédictions 1 et 2 comparent $\hat\Delta_q$ à un $\hat\Delta$ classique. Celui-ci est mesuré soit sur les mêmes participants avec des stimuli classiques de P1, soit sur une strate comparable de P1 **[à arrêter par l'équipe]**. La fonction `p5.check_predictions` donne une lecture descriptive. Le test confirmatoire de chaque prédiction est fixé dans le [pré-enregistrement](../00_commun/preenregistrement_fr.md).

## 8. Analyse

Le paquet [cro_terrain](../analyse/README_fr.md) lit le [gabarit](gabarit_sessions_pqc_fr.csv) (schéma `p5_sessions`). Les colonnes `aide`, `condition_bruit`, `p_bruit`, `verdict_reference` et `erreur_interpretation` correspondent aux sections 5 et 6. L'IC de $\hat\Delta_q$ est obtenu par bootstrap sur les participants (`statistics.cluster_bootstrap`).

## 9. Durée, ressources et calendrier

La thèse prévoit 6 mois, 80 professionnels PQC et un coût estimé de 12 000 000 FCFA (tableau `tab:programme_experimental`), dans la fenêtre A13–A24 du calendrier (tableau `tab:calendrier_experimental`). La répartition interne est **[à arrêter par l'équipe]**.

## 10. Prérequis

☐ Conventions avec les institutions ([modèle](../00_commun/convention_institution_partenaire_fr.md))
☐ Avis favorable du comité d'éthique ([modèle](../00_commun/dossier_comite_ethique_fr.md))
☐ 12 paires de stimuli rédigées et leurs 48 signatures vérifiées
☐ Interface de vérification développée et testée, journal des tirages de bruit activé
☐ Simulation de puissance pour la prédiction 4
☐ Pré-enregistrement déposé ([modèle](../00_commun/preenregistrement_fr.md))
☐ Toutes les mentions [à arrêter par l'équipe] levées

Licence CC BY 4.0.
