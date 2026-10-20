# Protocoles de terrain - mesure des paramètres institutionnels

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.1.2, §4.2 et §4.2.8

[English version](README_en.md)

## Statut

Ce dossier rassemble les instruments opérationnels (formulaires, guides, gabarits de données) qui permettraient de déployer le programme expérimental spécifié au chapitre 4 de la thèse. Aucun de ces protocoles n'a été déployé. Aucune donnée n'a été recueillie. Les valeurs numériques citées (effectifs, durées, seuils, prédictions) sont reprises de la thèse et gardent le statut que la thèse leur donne. Les prédictions sont des paris falsifiables et les paramètres de référence relèvent d'une calibration illustrative (thèse, §4.1.3).

Lorsqu'un instrument exige un détail que la thèse ne fixe pas, la valeur proposée est signalée par la mention **[à arrêter par l'équipe]**. Ces mentions doivent toutes être levées avant le pré-enregistrement.

## Vue d'ensemble des sept protocoles

| Code | Paramètre mesuré | Section de la thèse | Dossier | Participants (thèse) |
|---|---|---|---|---|
| P1 | $\Delta$, capacité d'extraction institutionnelle | §4.2.1 | [P1_delta/](P1_delta/README_fr.md) | 120 institutionnels stratifiés |
| P2 | $H(\mathcal{C})$, entropie contextuelle | §4.2.2 | [P2_entropie_contexte/](P2_entropie_contexte/README_fr.md) | 20 experts (Delphi), 5 à 10 experts (MDS) |
| P3 | $\mathsf{Opp}$, opposabilité mesurée sur Helios (ENSP) | §4.2.3 | [P3_opp_helios/](P3_opp_helios/README_fr.md) | 10 trustees, environ 500 votants |
| P4 | $\Delta$ et $\alpha$ estimés conjointement | §4.2.4 | [P4_delta_alpha/](P4_delta_alpha/README_fr.md) | $n \geq 30$ |
| P5 | $\Delta_q$, capacité d'extraction quantique | §4.2.5 | [P5_delta_q/](P5_delta_q/README_fr.md) | 80 professionnels PQC |
| P6 | $\eta_q$, perte d'interprétabilité quantique | §4.2.6 | [P6_eta_q/](P6_eta_q/README_fr.md) | 40 experts et simulation |
| P7 | Validation combinée post-quantique $(\Delta_q, \eta_q, \beta_q)$ | §4.2.7 | [P7_combine/](P7_combine/README_fr.md) | 40 validateurs |

Le dossier [00_commun/](00_commun/README_fr.md) contient les pièces partagées par tous les protocoles (pré-enregistrement, dossier éthique, consentement, convention, confidentialité, quotas, profil, journal de séance, écarts, gestion des données, plan d'analyse). Le dossier [analyse/](analyse/README_fr.md) contient le paquet Python `cro_terrain` qui met en œuvre les estimateurs, les contrôles de fiabilité et les critères de réfutation.

## Ordre de déploiement recommandé

La thèse désigne l'audit post-électoral Helios à l'ENSP comme « le point d'entrée naturel du programme », parce qu'il est le plus léger en ressources et le seul entièrement internalisable à l'ENSP (§4.2.8.3). L'ordre recommandé en découle.

1. **P3** (audit Helios ENSP). Il éprouve à petite échelle la chaîne complète (éthique, consentement, collecte, gestion des données, analyse) avec 10 trustees.
2. **P2** (entropie contextuelle). Il fournit $H(\mathcal{C})$, dont dépendent $\hat\alpha$ et le critère de réfutation portant sur $\gamma$.
3. **P1** (capacité $\Delta$). Il exige les conventions avec les juridictions, régulateurs et cabinets ainsi que le gold standard.
4. **P4** (estimation conjointe de $\Delta$ et $\alpha$). Il réutilise les données de P1 et la valeur de $H(\mathcal{C})$ issue de P2 avec les seuils de validation ICC $\geq 0{,}8$ et $\kappa \geq 0{,}7$.
5. **P5**, **P6** puis **P7** (volet post-quantique).

Le calendrier de la thèse (tableau ci-dessous) fait démarrer P1 et P2 dès les mois A1–A6 et P3 en A7–A12. L'ordre recommandé ici avance P3 sans modifier les durées ni les budgets. La décision finale sur l'enchaînement est **[à arrêter par l'équipe]** selon l'obtention des accords institutionnels.

## Calendrier (thèse, tableau `tab:calendrier_experimental`, §4.2.8.2)

| Activité | A1–A6 | A7–A12 | A13–A18 | A19–A24 | A25–A30 | A31–A36 |
|---|---|---|---|---|---|---|
| Mesure $\Delta$ (§4.2.1) | ×× | ×× | | | | |
| Mesure $H(\mathcal{C})$ (§4.2.2) | × | × | | | | |
| Mesure $\mathsf{Opp}$ Helios (§4.2.3) | | ×× | × | | | |
| Mesure $\Delta_q$ (§4.2.5) | | | ×× | ×× | | |
| Mesure $\eta_q$ (§4.2.6) | | | | ×× | × | |
| Validation PQC (§4.2.7) | | | | | ×× | × |
| Analyse longitudinale | | | | | | ×× |

## Budget et ressources (thèse, tableau `tab:programme_experimental`, §4.2.8.1)

| Protocole | Section | Durée | Participants | Coût estimé |
|---|---|---|---|---|
| Mesure de $\Delta$ | §4.2.1 | 6 mois | 120 institutionnels | 15 000 000 FCFA |
| Mesure de $H(\mathcal{C})$ | §4.2.2 | 3 mois | 20 experts | 5 000 000 FCFA |
| Mesure de $\mathsf{Opp}$ sur Helios | §4.2.3 | 4 mois | 10 trustees | 8 000 000 FCFA |
| Mesure de $\Delta_q$ | §4.2.5 | 6 mois | 80 professionnels PQC | 12 000 000 FCFA |
| Mesure de $\eta_q$ | §4.2.6 | 4 mois | 40 experts et simulation | 8 000 000 FCFA |
| Validation combinée PQC | §4.2.7 | 3 mois | 40 validateurs | 6 000 000 FCFA |
| **Total** | | **26 mois** | **310** | **54 000 000 FCFA** |

Selon la thèse, ces coûts sont des ordres de grandeur indicatifs qui feront l'objet d'une évaluation budgétaire affinée lors de la mise en œuvre. Les 26 mois de travail cumulés se répartissent sur un calendrier de 36 mois. Le protocole P4 n'a pas de ligne propre dans ce tableau, car il réutilise les données de P1.

## Préalables au déploiement (thèse, §4.2.8.3)

- Accord des juridictions et régulateurs approchés (modèle dans [00_commun/convention_institution_partenaire_fr.md](00_commun/convention_institution_partenaire_fr.md)).
- Approbation d'un comité d'éthique de la recherche (modèle dans [00_commun/dossier_comite_ethique_fr.md](00_commun/dossier_comite_ethique_fr.md)).
- Financement de l'ordre de grandeur indiqué plus haut.

## Critères de réfutation

Les critères de réfutation sont fixés avant toute collecte (thèse, tableau `tab:criteres_refutation`, §4.2.7.3). Ils sont reproduits à l'identique dans le [modèle de pré-enregistrement](00_commun/preenregistrement_fr.md#5-critères-de-réfutation). Selon la thèse, les valeurs seuils sont indicatives et seront arrêtées lors du pré-enregistrement, leur forme constituant l'engagement méthodologique.

## Licence

Textes, formulaires et gabarits de données sous licence CC BY 4.0.
