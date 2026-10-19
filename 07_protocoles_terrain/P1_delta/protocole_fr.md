# P1 — Protocole de mesure de $\Delta$, capacité d'extraction institutionnelle

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.1 (et §4.2.4 pour les seuils de validation)

[English version](protocole_en.md) · [README du dossier](README_fr.md)

## 1. Objectif

Mesurer empiriquement la capacité d'extraction institutionnelle $\Delta$ (en bits), définie par l'hypothèse d'extraction bornée (thèse, §4.2.1.1 et chapitre 2, §2.3.1.2)

$$I(V;\Sigma\mid C) \leq I(M;\Sigma\mid C) + \Delta .$$

## 2. Définition opérationnelle

$\Delta$ est la quantité d'information sur les verdicts qu'un acteur institutionnel peut extraire au-delà de l'information mutuelle brute contenue dans la preuve cryptographique. Elle capture la connaissance préalable non formalisée dans le contexte $C$, c'est-à-dire les précédents légaux, la formation spécialisée, les procédures institutionnelles et la capacité de délibération collective (thèse, définition `def:capacite_extraction_op`).

Par la proposition de fondement informationnel de l'hypothèse (chapitre 2, §2.3.1.2), la quantité contrôlée est l'information conditionnelle $I(V;\Sigma\mid M,C)$. L'hypothèse est satisfaite dès que $I(V;\Sigma\mid M,C) \leq \Delta$.

## 3. Estimateur

$$\hat\Delta = \hat I(V;\Sigma\mid M,C)$$

- Calcul sur les triplets $(v_i, \sigma_i, m_i)$ recueillis à contexte $c$ fixé.
- Estimateur plug-in avec correction de Miller–Madow, ou estimateur de type NSB pour les petits échantillons.
- Le message $m_i$ est connu de l'expérimentateur (vérité terrain) et non des participants.
- L'estimateur est biaisé positivement en petit échantillon. L'intervalle de confiance est obtenu par bootstrap non paramétrique sur les participants.
- L'estimateur antérieur $I_{\text{emp}}(V;\Sigma\mid C) - I_{\text{vrai}}(M;\Sigma\mid C)$ est abandonné, car il est systématiquement négatif pour un protocole fiable et ne fournit qu'une borne inférieure sur $\Delta$ (remarque de la thèse, §4.2.1.1).

Les calculs détaillés et les points de vigilance figurent dans le [plan d'analyse statistique](../00_commun/plan_analyse_statistique_fr.md).

## 4. Design expérimental

### 4.1 Participants (tableau `tab:stratification_delta`)

$N \geq 100$ professionnels des institutions cibles. L'effectif visé est 120, stratifié par niveau d'expertise et par type d'institution.

| Catégorie | Sous-groupe | Code | $n$ | $\Delta$ prédit |
|---|---|---|---|---|
| Juges | Généralistes (juridictions civiles) | JG | 20 | $\approx 25$ bits |
| Juges | Spécialisés (contrats, PKI, numérique) | JS | 20 | $\approx 40$ bits |
| Régulateurs financiers | Juniors (< 5 ans d'expérience) | RJ | 20 | $\approx 35$ bits |
| Régulateurs financiers | Seniors (≥ 5 ans, superviseurs) | RS | 20 | $\approx 65$ bits |
| Auditeurs | Cour des comptes (secteur public) | AP | 20 | $\approx 45$ bits |
| Auditeurs | Cabinets privés (Big 4 et équivalents) | AC | 20 | $\approx 55$ bits |
| **Total** | | | **120** | |

Les équivalences institutionnelles au Cameroun et le suivi des quotas figurent dans la [fiche de recrutement](../00_commun/fiche_recrutement_stratification_fr.md).

### 4.2 Matériel expérimental

- 5 types de preuves cryptographiques. ECDSA (`ECD`), Helios avec ElGamal et ZK (`HEL`), Groth16 zk-SNARK (`G16`), RSA-PSS (`PSS`) et ElGamal classique (`EGC`).
- 10 contextes standardisés par type de preuve (contractuels, électoraux, financiers), soit 50 paires contexte–preuve, décrites dans le [catalogue des stimuli](stimuli/catalogue_stimuli_fr.md).
- Questionnaire de 30 items par contexte ([questionnaire d'extraction de verdict](questionnaire_extraction_verdict_fr.md)). La thèse le qualifie de « validé ». Sa validation reste à conduire par un pré-test **[à arrêter par l'équipe]**.

### 4.3 Variantes à l'intérieur d'une paire

Pour que $I(V;\Sigma\mid M,C)$ soit estimable, chaque paire $c$ comporte plusieurs messages $m$ et, pour chaque message, plusieurs variantes de preuve $\sigma$. La proposition retient 2 messages et 2 variantes de preuve par message, soit 4 variantes par paire **[à arrêter par l'équipe]**. Chaque participant ne voit qu'une variante d'une paire donnée.

### 4.4 Affectation des stimuli (rotation équilibrée)

Chaque participant traite 10 contextes (thèse, §4.2.1.3). Le schéma proposé **[à arrêter par l'équipe]** est le suivant.

- Les 10 contextes de chaque type sont groupés en 5 blocs de 2 (C01–C02, C03–C04, C05–C06, C07–C08, C09–C10).
- La liste de rotation $r \in \{1,\dots,5\}$ attribue le bloc $r$ pour ECD, le bloc $r+1$ pour HEL, le bloc $r+2$ pour G16, le bloc $r+3$ pour PSS et le bloc $r+4$ pour EGC (indices modulo 5).
- Dans chaque strate, chaque liste est attribuée à 4 participants. Chaque paire est ainsi vue 4 fois par strate et 24 fois au total. Les 4 participants d'une strate qui voient une même paire reçoivent chacun une variante différente.
- L'ordre des 10 contextes dans la séance suit un carré latin équilibré sur les types de preuve, afin de neutraliser les effets d'ordre et de fatigue.

| Liste | ECD | HEL | G16 | PSS | EGC |
|---|---|---|---|---|---|
| 1 | C01–C02 | C03–C04 | C05–C06 | C07–C08 | C09–C10 |
| 2 | C03–C04 | C05–C06 | C07–C08 | C09–C10 | C01–C02 |
| 3 | C05–C06 | C07–C08 | C09–C10 | C01–C02 | C03–C04 |
| 4 | C07–C08 | C09–C10 | C01–C02 | C03–C04 | C05–C06 |
| 5 | C09–C10 | C01–C02 | C03–C04 | C05–C06 | C07–C08 |

## 5. Procédure

La session de chaque participant se déroule en cinq phases (thèse, §4.2.1.3).

| Phase | Contenu | Durée (thèse) | Instrument |
|---|---|---|---|
| 0 | Formation initiale aux concepts cryptographiques de base, sans révéler les mécanismes internes, afin d'homogénéiser le vocabulaire minimum | 2 h | [support_formation_phase0_fr.md](support_formation_phase0_fr.md) |
| 1 | Session principale. Pour chacun des 10 contextes assignés, (a) présentation du contexte $c$, (b) présentation de la preuve $\sigma$, (c) questionnaire d'extraction de verdict, (d) mesure du temps de réponse et notation de confiance subjective | 4 h | [questionnaire_extraction_verdict_fr.md](questionnaire_extraction_verdict_fr.md), [journal de séance](../00_commun/journal_session_fr.md) |
| 2 | Vérification test-retest. Re-présentation de 3 contextes déjà vus après un délai de 2 semaines | 1 h | [fiche_test_retest_fr.md](fiche_test_retest_fr.md) |
| 3 | Calcul du gold standard. Deux cryptographes experts indépendants rendent les verdicts corrects (accord inter-juge requis ≥ 90 %) | sans participants | [grille_gold_standard_fr.md](grille_gold_standard_fr.md) |
| 4 | Débriefing et restitution | 30 min | [fiche_debriefing_fr.md](fiche_debriefing_fr.md) |

Le gold standard (phase 3) ne mobilise pas les participants. Il peut être établi avant la phase 1, sur les stimuli seuls, afin que les experts ignorent les réponses des participants **[à arrêter par l'équipe]**.

Le déroulement minuté de la phase 1 est proposé dans le [guide de l'enquêteur](guide_enqueteur_fr.md). Il prévoit 20 min par contexte environ et deux pauses.

## 6. Métriques (algorithme `alg:estimation_delta`)

1. Présenter $\sigma_i$ avec $C$ aux acteurs institutionnels.
2. Enregistrer les verdicts $V$, les scores de confiance et les temps de décision.
3. Associer à chaque réponse le message $m$ connu de l'expérimentateur.
4. Tester l'admissibilité $V \perp M \mid (\Sigma, C)$ par un test de permutation.
5. Estimer $\hat\Delta = \hat I(V;\Sigma\mid M,C)$.
6. Estimer $\hat\alpha = \log_2|\mathcal{V}| / H(C)$.
7. Valider par fiabilité test-retest et cohérence inter-évaluateurs. Les seuils numériques retenus sont ceux du protocole standardisé (thèse, §4.2.4), soit ICC $\geq 0{,}8$ et $\kappa \geq 0{,}7$.

Les scores de confiance et les temps de décision servent à détecter les réponses prises au hasard, qui contamineraient l'estimation de l'information mutuelle (thèse, §4.2.1.4).

## 7. Prédictions vérifiables (thèse, §4.2.1.5)

1. $\hat\Delta_{\text{juge général}} \approx 25$ bits
2. $\hat\Delta_{\text{juge PKI}} \approx 40$ bits
3. $\hat\Delta_{\text{régulateur senior}} \approx 65$ bits
4. $\hat\Delta_{\text{ECDSA}} > \hat\Delta_{\text{Helios}}$ pour tout sous-groupe
5. Facteur d'amplification institutionnelle de 1,8 à 3,7 par rapport à la capacité individuelle de Miller (environ 20 bits)

La thèse présente ces chiffres comme des cibles plutôt que comme des bornes, susceptibles d'être démenties par la mesure.

## 8. Critères de réfutation

Les critères du tableau `tab:criteres_refutation` qui concernent P1 portent sur $\Delta$, sur l'admissibilité et sur $\gamma$. Ils sont reproduits à l'identique dans le [pré-enregistrement](../00_commun/preenregistrement_fr.md#5-critères-de-réfutation).

## 9. Durée, ressources et calendrier

La thèse prévoit 6 mois, 120 institutionnels et un coût estimé de 15 000 000 FCFA (tableau `tab:programme_experimental`), dans la fenêtre A1–A12 du calendrier (tableau `tab:calendrier_experimental`). La répartition interne proposée est la suivante **[à arrêter par l'équipe]**.

| Mois | Activité |
|---|---|
| M1 | Rédaction des 50 paires et de leurs variantes, gold standard, pré-test du questionnaire auprès de ____ personnes hors échantillon |
| M2 à M5 | Séances de phases 0, 1, 2 et 4 par vagues de ____ participants |
| M6 | Saisie, contrôle qualité, analyse selon le plan pré-enregistré, restitution |

## 10. Prérequis (thèse, §4.2.4 et §4.2.8.3)

☐ Conventions signées avec les institutions ([modèle](../00_commun/convention_institution_partenaire_fr.md))
☐ Avis favorable du comité d'éthique ([modèle](../00_commun/dossier_comite_ethique_fr.md))
☐ Financement obtenu
☐ Pré-enregistrement déposé ([modèle](../00_commun/preenregistrement_fr.md))
☐ Toutes les mentions [à arrêter par l'équipe] levées
