# P2 — Protocole de mesure de $H(\mathcal{C})$, entropie contextuelle

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.2 (tableau `tab:estimations_structurelles_HC`)

[English version](protocole_en.md) · [README du dossier](README_fr.md)

## 1. Objectif

Quantifier empiriquement l'entropie contextuelle $H(\mathcal{C})$, c'est-à-dire la richesse informationnelle du contexte institutionnel dans lequel s'opère l'interprétation des preuves cryptographiques (thèse, §4.2.2.1).

## 2. Ce que P2 mesure et ce qu'il ne mesure pas

$H(\mathcal{C})$ caractérise la **distribution** des contextes possibles d'un domaine institutionnel et non un contexte particulier. La thèse distingue deux échelles qui portent le même symbole (§4.2.2.1 et §4.3.1).

| Échelle | Valeurs dans la thèse | Mesurée par P2 |
|---|---|---|
| Domaine (distribution des contextes) | 20 à 70 bits selon le domaine (tableau `tab:estimations_structurelles_HC`) | **oui** |
| Contexte d'espèce (dérivations du §4.3) | 8, 11 et 20 bits | non |

Les trois estimations de P2 sont donc confrontées aux plages du domaine, jamais aux valeurs d'espèce.

$H(\mathcal{C})$ intervient dans $\hat\alpha = \log_2|\mathcal{V}|/H(C)$ (P1 et P4) et dans le critère de réfutation portant sur $\gamma$ ([pré-enregistrement](../00_commun/preenregistrement_fr.md#5-critères-de-réfutation)).

## 3. Hypothèses testées (thèse, §4.2.2.2)

| Code | Domaine | Code de domaine | $H(\mathcal{C})$ estimé par la thèse |
|---|---|---|---|
| H2.1 | Contentieux électoral | `ELEC` | 30 à 50 bits |
| H2.2 | Conformité financière | `FIN` | 40 à 70 bits |
| H2.3 | Signature contractuelle | `CONT` | 20 à 40 bits |

Les composantes dominantes citées par la thèse sont le registre, les règles et l'historique pour `ELEC`, les transactions, les réglementations et l'audit pour `FIN`, les parties, les clauses et la juridiction pour `CONT`.

## 4. Trois approches indépendantes

La thèse propose trois approches (§4.2.2.2 à §4.2.2.4). Elles reposent sur des hypothèses différentes. Leur concordance, ou leur écart, est en soi un résultat.

### 4.1 Approche 1, décomposition structurelle

**Principe.** Identifier les dimensions indépendantes du contexte et sommer leurs entropies sous l'hypothèse d'indépendance approximative.

La thèse donne deux écritures. Le glossaire pose $H(C) = H(L) + H(T\mid L) + H(R\mid L,T)$, avec une composante juridique $L$, une composante temporelle $T$ et une composante procédurale $R$. Pour le domaine contractuel, l'équation `eq:decomposition_HC` écrit

$$H(C) = H(C_{\text{parties}}) + H(C_{\text{clauses}}) + H(C_{\text{juridiction}}) + H(C_{\text{historique}}).$$

La grille proposée concilie les deux écritures. Chaque élément concret (parties, clauses, juridiction, historique, etc.) est rattaché à l'une des composantes $L$, $T$ ou $R$. L'expert estime ensuite son entropie. Sous l'hypothèse d'indépendance, $H(T\mid L) \approx H(T)$ et $H(R\mid L,T) \approx H(R)$.

**Instrument.** [Grille de décomposition structurelle](grille_decomposition_structurelle_fr.md).

**Participants.** Les experts du panel Delphi, avant le tour 1 **[à arrêter par l'équipe]**.

### 4.2 Approche 2, modélisation probabiliste par MDS

**Design (thèse, §4.2.2.3).** Présenter $n_{\text{ctx}} = 100$ contextes variés à un panel de 5 à 10 experts, qui jugent leur dissimilarité par paires.

**Analyse.** Matrice de dissimilarité $D \in \mathbb{R}^{100\times 100}$, réduction par MDS, volume effectif $V_{\text{eff}} = \det(\hat\Sigma)^{1/2}$, estimation $H(\mathcal{C}) \approx \log_2 V_{\text{eff}}$.

**Adaptation proposée.** Juger les $\binom{100}{2} = 4\,950$ paires demanderait environ 11 h par expert à raison de 8 s par jugement. La proposition retient un corpus de 100 contextes répartis en trois domaines (34 `ELEC`, 33 `FIN`, 33 `CONT`) et ne fait juger que les paires **internes à chaque domaine**, soit $561 + 528 + 528 = 1\,617$ paires par expert, réparties en trois séances d'environ 1 h 30. On obtient une estimation par domaine, comme l'exigent les hypothèses H2.1 à H2.3 **[à arrêter par l'équipe]**.

**Instruments.** [Corpus des 100 contextes](corpus_contextes_fr.md) et [protocole de jugement de dissimilarité](protocole_dissimilarite_mds_fr.md).

### 4.3 Approche 3, consensus d'experts par méthode Delphi

**Procédure (thèse, §4.2.2.4).** 20 experts estiment $H(\mathcal{C})$ indépendamment, puis révisent après un retour anonymisé. Le processus compte au plus quatre tours et s'arrête lorsque l'écart interquartile (IQR) devient inférieur à 5 bits.

**Instruments.** [Questionnaire du tour 1](delphi_questionnaire_tour1_fr.md), [retour et révision des tours 2 à 4](delphi_retour_tours_2_4_fr.md), [synthèse finale](delphi_synthese_fr.md).

## 5. Participants

| Panel | Effectif (thèse) | Répartition proposée **[à arrêter par l'équipe]** |
|---|---|---|
| Delphi (et décomposition) | 20 experts | 7 droit et contentieux, 7 régulation et audit, 6 cryptographie appliquée |
| MDS | 5 à 10 experts | au moins 2 par profil |

Les codes `P2-EX-NN` et le suivi des quotas figurent dans la [fiche de recrutement](../00_commun/fiche_recrutement_stratification_fr.md#3-quotas-de-p2-thèse-4223-et-4224). Un expert peut appartenir aux deux panels. Les experts ne participent pas à P1.

## 6. Calendrier

La thèse prévoit 3 mois, 20 experts et un coût estimé de 5 000 000 FCFA (tableau `tab:programme_experimental`). La répartition interne proposée est la suivante **[à arrêter par l'équipe]**.

| Semaine | Activité |
|---|---|
| S1–S2 | Recrutement, consentement, finalisation du corpus de 100 contextes |
| S3 | Grille de décomposition (approche 1) |
| S4–S9 | Tours Delphi 1 à 4, à raison d'un tour toutes les deux semaines au plus |
| S4–S8 | Séances MDS, trois par expert, en parallèle du Delphi |
| S10–S12 | Analyse et confrontation des trois approches |

L'ordre recommandé fait passer la décomposition avant le tour 1 du Delphi, puis le tour 1 avant toute séance MDS. Un expert qui appartient aux deux panels n'est ainsi pas influencé par le corpus MDS lors de ses estimations directes.

## 7. Analyse

Les calculs suivent le [plan d'analyse statistique](../00_commun/plan_analyse_statistique_fr.md), section 8. Le module `cro_terrain.p2` du [paquet d'analyse](../analyse/README_fr.md) les met en œuvre.

| Approche | Estimation par domaine | Fonction |
|---|---|---|
| Décomposition | médiane et IQR des sommes par expert | `p2.decomposition_totals`, `p2.summarize_by_domain` |
| MDS | $\log_2 V_{\text{eff}}$, intervalle par bootstrap sur les experts | `p2.dissimilarity_matrix`, `p2.choose_dimensions`, `p2.mds_entropy`, `p2.mds_entropy_bootstrap` |
| Delphi | médiane du dernier tour | `p2.delphi_round_summary`, `p2.delphi_should_stop` |

Les trois estimations sont rapportées côte à côte avec la plage de la thèse. Elles ne sont pas combinées en une valeur unique **[à arrêter par l'équipe]**.

## 8. Points de vigilance

1. **Unité de l'échelle MDS.** Si l'on divise l'unité de dissimilarité par $s$, l'estimation $\log_2 V_{\text{eff}}$ augmente de $k\log_2 s$ bits pour $k$ dimensions retenues. Le test `test_mds_entropy_matches_covariance_and_unit_shift` le vérifie. L'unité et la règle de choix de $k$ doivent être fixées et déposées avant la collecte.
2. **Ordre de grandeur de l'approche MDS.** Avec une échelle de 0 à 10 et une unité d'une graduation, chaque dimension retenue apporte de l'ordre de $\log_2$ de l'écart type des coordonnées, soit quelques bits. Atteindre 20 à 70 bits demanderait des dizaines de dimensions, alors qu'un domaine ne compte que 33 ou 34 contextes. Un écart important entre l'approche MDS et les deux autres est donc prévisible. Il doit être interprété comme une limite de la méthode avant de l'être comme une réfutation.
3. **Indépendance des composantes.** La somme des entropies majore l'entropie jointe. L'approche 1 tend donc à surestimer $H(\mathcal{C})$ lorsque des éléments sont corrélés (par exemple la juridiction et le type de clause).
4. **Effet d'ancrage dans le Delphi.** Les plages de la thèse ne sont pas communiquées aux experts. Le retour de chaque tour ne donne que la distribution anonymisée des réponses du tour précédent.
5. **Lien avec $\hat\alpha$.** $\hat\alpha$ dépend de la valeur de $H(\mathcal{C})$ retenue. Le choix de l'approche de référence pour $\hat\alpha$ doit être déposé avant la collecte de P1 **[à arrêter par l'équipe]**.

## 9. Place de P2 dans les critères de réfutation

Le tableau `tab:criteres_refutation` de la thèse ne contient aucun critère portant sur $H(\mathcal{C})$ lui-même. P2 fournit la valeur de $H(\mathcal{C})$ qu'utilise le critère portant sur $\gamma$, réfuté si la borne supérieure de l'IC 95 % de $\hat H(V\mid C)$ est inférieure à $\alpha H(\mathcal{C}) - 1$ ([pré-enregistrement](../00_commun/preenregistrement_fr.md#5-critères-de-réfutation)).

La confrontation des estimations aux plages H2.1 à H2.3 est rapportée comme une mise en regard. Une estimation hors de la plage ne réfute pas le trilemme. Elle indique que les plages du tableau `tab:estimations_structurelles_HC` doivent être révisées.

## 10. Prérequis

☐ Avis favorable du comité d'éthique ([modèle](../00_commun/dossier_comite_ethique_fr.md))
☐ Engagements de confidentialité des experts signés ([modèle](../00_commun/engagement_confidentialite_fr.md))
☐ Corpus des 100 contextes relu et figé
☐ Unité de l'échelle MDS et règle de choix des dimensions déposées
☐ Pré-enregistrement déposé ([modèle](../00_commun/preenregistrement_fr.md))
☐ Toutes les mentions [à arrêter par l'équipe] levées

Licence CC BY 4.0.
