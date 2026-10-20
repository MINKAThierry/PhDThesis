# Protocole de mesure de $\mathsf{Opp}$ sur un système déployé (Helios, ENSP)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.3 ; dérivation Helios, §4.3 (`sec:derivation_helios`)

[English version](protocole_en.md) · [README du dossier](README_fr.md)

## 1. Objectif

Mesurer empiriquement l'opposabilité $\mathsf{Opp}$ sur un système cryptographique réellement déployé, puis comparer la valeur mesurée à la valeur prédite (thèse, §4.2.3.1).

## 2. Système cible

Système de vote Helios déployé pour une élection de délégués étudiants à l'École nationale supérieure polytechnique (ENSP) de l'Université de Yaoundé I (thèse, §4.2.3.1). L'élection est organisée par l'instance électorale compétente de l'ENSP. L'équipe de recherche n'organise pas l'élection et n'intervient pas sur son résultat ([modèle de convention](modele_convention_scrutin_fr.md)).

## 3. Grandeur mesurée et valeur prédite

$$\mathsf{Opp}_{\text{emp}} = \frac{I_{\text{emp}}(V;\Sigma\mid C)}{H_{\text{emp}}(V\mid C)}$$

(thèse, équation `eq:opp_empirique`).

| Élément | Codage dans P3 |
|---|---|
| $\Sigma$ | la preuve auditée, codée par son identifiant (`id_preuve`) |
| $V$ | verdict du trustee sur cette preuve, parmi 4 décisions (section 5.4) |
| $C$ | le scrutin audité, une seule valeur (`id_contexte = ENSP-<année>`) |

**Valeur prédite.** $\mathsf{Opp}_{\text{prédit}} = 0{,}50$, dérivée au §4.3 pour un tribunal de juridiction générale avec un espace de quatre verdicts ($H(V\mid C) = 2$ bits) et un signal expert binaire ($I(V;\Sigma\mid C) \approx 1$ bit). La calibration illustrative de l'article CLO donne $\mathsf{Conf}\cdot\mathsf{Rel}_{\text{ver}}\cdot\mathsf{Opp} \approx 0{,}437$ (équation `eq:prediction_sotp_opp`).

Le protocole met à l'épreuve l'hypothèse d'uniformité des verdicts qui fonde la valeur 0,50, en mesurant la distribution empirique $H_{\text{emp}}(V\mid C)$ au lieu de la postuler (thèse, §4.2.3.5).

## 4. Critère de validation (thèse, §4.2.3.5)

- **Accord** si $|\mathsf{Opp}_{\text{emp}} - \mathsf{Opp}_{\text{prédit}}| \leq 0{,}05$.
- **Désaccord** si $\mathsf{Opp}_{\text{prédit}}$ tombe hors de l'IC 95 % bootstrap de $\mathsf{Opp}_{\text{emp}}$. La valeur 0,50 et l'hypothèse d'uniformité qui la fonde sont alors réfutées.

Les deux conditions ne s'excluent pas. La fonction `cro_terrain.refutation.criterion_opp_helios` rapporte les deux indicateurs. La règle de priorité lorsque les deux sont vraies est **[à arrêter par l'équipe]**.

Cette valeur prédite porte sur un tribunal de juridiction générale. Les trustees de P3 sont des cryptographes formés. L'écart de population doit être rappelé à chaque mise en regard du résultat avec la prédiction.

## 5. Design

### 5.1 Participants

Commission de $n = 10$ trustees, doctorants et enseignants-chercheurs (thèse, §4.2.3.2). Codes `TR-01` à `TR-10`. Les trustees du scrutin réel (détenteurs de parts de clé) et les auditeurs de P3 peuvent être les mêmes personnes **[à arrêter par l'équipe avec l'instance électorale]**.

### 5.2 Taille de l'élection

Environ 500 votants, donc environ 500 bulletins accompagnés de preuves (thèse, §4.2.3.2).

### 5.3 Preuves auditées

**Selon la thèse.** Un échantillon aléatoire de 50 preuves (10 %), tiré après la clôture selon la [procédure de tirage](tirage_echantillon_fr.md).

**Ajout proposé, des preuves témoins.** Dans une élection régulière, toutes les preuves sont valides. Si les 10 trustees rendent tous le verdict « bulletin valide », $H_{\text{emp}}(V\mid C) = 0$ et $\mathsf{Opp}_{\text{emp}}$ n'est pas défini. Pour éviter ce cas dégénéré, la proposition ajoute 10 preuves témoins, copies altérées de bulletins du même scrutin, préparées par le coordinateur et mêlées en aveugle aux 50 preuves tirées ([procédure](preuves_temoins_fr.md)). Le jeu audité compte alors 60 preuves **[à arrêter par l'équipe]**.

$\mathsf{Opp}_{\text{emp}}$ est rapporté sur deux ensembles.

| Ensemble | Contenu | Rôle |
|---|---|---|
| Principal | 60 preuves (50 tirées, 10 témoins) | test du critère de la section 4 |
| Restreint | 50 preuves tirées seulement | valeur sur le système réel, éventuellement non définie |

L'exemple simulé du paquet d'analyse utilise 50 preuves dont 20 % de témoins. Il n'illustre que la chaîne de calcul.

### 5.4 Espace de verdicts

Les quatre décisions de la dérivation Helios (§4.3) sont transposées au niveau du bulletin.

| Code | Verdict sur la preuve | Décision de la dérivation |
|---|---|---|
| 1 | Bulletin valide, retenu | élection valide |
| 2 | Bulletin invalide, écarté | élection invalide |
| 3 | Vérification complémentaire ou recomptage demandé | recomptage ordonné |
| 4 | Investigation demandée | investigation demandée |

$|\mathcal{V}| = 4$, donc $\log_2|\mathcal{V}| = 2$ bits, comme dans la dérivation.

## 6. Procédure (thèse, §4.2.3.3)

| Phase | Contenu | Durée | Instrument |
|---|---|---|---|
| Préalable | Convention avec l'instance électorale, avis éthique, consentement des trustees, dépôt du pré-enregistrement | | [modèle de convention](modele_convention_scrutin_fr.md) |
| 1 | Formation des trustees sur Helios et les preuves à divulgation nulle | 4 h | [support de formation](support_formation_trustees_fr.md) |
| 2 | Élection réelle, déploiement standard de Helios | selon le calendrier électoral | aucun, l'équipe n'intervient pas |
| — | Après la proclamation, tirage public de l'échantillon puis préparation des preuves témoins | 1 h | [tirage](tirage_echantillon_fr.md), [preuves témoins](preuves_temoins_fr.md) |
| 3 | Session d'audit. Chaque trustee examine seul chaque preuve, rend un verdict et note sa confiance sur 10 | 3 h | [fiche d'audit](fiche_audit_preuve_fr.md) |
| Clôture | Procès-verbal signé, saisie, analyse | | [procès-verbal](proces_verbal_audit_fr.md), [gabarit](gabarit_audit_preuves_fr.csv) |

L'audit commence **après la proclamation des résultats**. Ses verdicts sont des données de recherche. Ils n'ont aucun effet sur le résultat de l'élection. Une anomalie réelle constatée pendant l'audit est signalée à l'instance électorale selon la procédure de la convention.

Avec 60 preuves en 3 h, chaque trustee dispose d'environ 3 min par preuve, pauses comprises.

## 7. Analyse

Le paquet [cro_terrain](../analyse/README_fr.md) lit le [gabarit](gabarit_audit_preuves_fr.csv) (schéma `p3_audit`). L'[exemple d'analyse](../analyse/exemple_analyse.py) montre la chaîne complète sur données simulées.

1. **Estimateur principal proposé.** `information.opp_emp_shuffle`, avec un numérateur corrigé par permutation. Avec 60 preuves vues 10 fois chacune, l'estimateur de Miller–Madow seul reste fortement biaisé vers le haut **[à arrêter par l'équipe]**.
2. **Intervalle de confiance.** Le bootstrap sur les trustees, exigé par la thèse, est rapporté à côté du bootstrap sur les preuves (`statistics.cluster_bootstrap`). Avec 10 trustees, l'intervalle par trustee est grossier. Rééchantillonner les trustees gonfle en outre la dépendance apparente entre $V$ et $\Sigma$. Le nombre de grappes est indiqué à côté de chaque intervalle.
3. **Robustesse.** $\Sigma$ codé par le statut de référence (`statut_reference`, authentique ou témoin) au lieu de l'identifiant. On obtient ainsi une borne inférieure.
4. **Décision.** `refutation.criterion_opp_helios`.
5. **Descriptif.** Distribution des verdicts, accord inter-trustees ($\kappa$ de Fleiss), taux de détection des témoins, confiance et temps par statut.

## 8. Prédiction et réfutation

Le critère de la section 4 figure dans le [pré-enregistrement](../00_commun/preenregistrement_fr.md), section 2.3. Un désaccord réfute la valeur 0,50 et l'hypothèse d'uniformité des verdicts. Il ne réfute pas le trilemme, dont $\mathsf{Opp}$ n'est qu'un facteur.

## 9. Durée, ressources et calendrier

La thèse prévoit 4 mois et 10 trustees (tableau `tab:programme_experimental`), dans la fenêtre A7–A12 du calendrier. Le README des protocoles recommande d'avancer P3 pour éprouver à petite échelle la chaîne complète, sans modifier sa durée ni son budget **[à arrêter par l'équipe]**.

| Mois | Activité |
|---|---|
| M1 | Convention, avis éthique, pré-enregistrement, recrutement des trustees |
| M2 | Formation (phase 1), préparation du tirage et de la procédure des témoins |
| M3 | Élection (phase 2), tirage public, audit (phase 3) |
| M4 | Saisie, analyse, restitution à l'instance électorale et aux trustees |

## 10. Prérequis

☐ Convention signée avec l'instance électorale de l'ENSP ([modèle](modele_convention_scrutin_fr.md)) et convention institutionnelle ([modèle](../00_commun/convention_institution_partenaire_fr.md))
☐ Avis favorable du comité d'éthique ([modèle](../00_commun/dossier_comite_ethique_fr.md))
☐ Consentement des 10 trustees ([notice](../00_commun/notice_information_consentement_fr.md))
☐ Graine du tirage et procédure des témoins déposées avant l'élection
☐ Pré-enregistrement déposé ([modèle](../00_commun/preenregistrement_fr.md))
☐ Toutes les mentions [à arrêter par l'équipe] levées

Licence CC BY 4.0.
