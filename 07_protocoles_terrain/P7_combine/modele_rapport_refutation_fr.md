# Modèle de rapport de réfutation (P7, synthèse du programme)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.7.3 (tableau `tab:criteres_refutation`) et §4.2.7.2, partie D

[English version](modele_rapport_refutation_en.md) · [Protocole P7](protocole_fr.md)

Rapport final du programme expérimental. Il rassemble, pour chaque critère pré-enregistré, les entrées, la décision et la mention de fiabilité. Il présente ensuite la validation croisée des prédictions. La fonction `cro_terrain.refutation.apply_criteria` produit les décisions des critères à partir d'un dictionnaire de résultats.

## 1. En-tête

| Champ | Valeur |
|---|---|
| Pré-enregistrement | référence ______, déposé le __/__/____ |
| Protocoles dont les données sont utilisées | ☐ P1 ☐ P2 ☐ P3 ☐ P4 ☐ P5 ☐ P6 |
| Version du paquet d'analyse | ______ |
| Écarts au pré-enregistrement | ☐ aucun ☐ oui, fiches `ECART-____` |

## 2. Décisions par critère

| Paramètre | Population ou système | Entrées | Fiabilité | Décision |
|---|---|---|---|---|
| $\Delta$ | ______ | borne inférieure ____, capacité ____ | ☐ OK ☐ insuffisante | ☐ non réfuté ☐ réfuté ☐ non probant |
| Admissibilité | ______ | $p =$ ____, strates informatives ____ | ☐ OK ☐ insuffisante | ☐ non réfutée ☐ réfutée ☐ non testable |
| $\gamma$ ou $\gamma_q$ | ______ | borne supérieure ____, seuil ____ | ☐ OK ☐ insuffisante | ☐ non réfuté ☐ réfuté ☐ non probant |
| $\eta_q$ | scénario simulé | IC [____ ; ____], intervalle prédit [____ ; ____] | sans objet | ☐ non réfuté ☐ réfuté ☐ non probant |
| $\mathsf{Opp}$ Helios (P3) | ENSP | $\mathsf{Opp}_{\text{emp}} =$ ____, IC [____ ; ____] | | ☐ accord ☐ désaccord ☐ accord avec écart significatif ☐ non concluant |
| Borne classique | ______ | voir la fiche de confrontation | | ☐ non réfutée ☐ réfutée ☐ non probante |
| Borne post-quantique | ______ | voir la fiche de confrontation | | ☐ non réfutée ☐ réfutée ☐ non probante |

Si une étape de fiabilité n'atteint pas ses seuils (ICC $\geq 0{,}8$, $\kappa \geq 0{,}7$), la décision correspondante est rapportée mais marquée « non applicable ».

## 3. Validation croisée (partie D)

Une ligne par norme et par paramètre (`p7.cross_validation`). La valeur prédite est celle de la calibration illustrative de la thèse ou celle déposée avant l'expérience.

| Norme | Paramètre | Valeur prédite | Valeur mesurée | IC 95 % | Erreur relative | Prédite dans l'IC |
|---|---|---|---|---|---|---|
| ML-DSA-65 | $\Delta_q$ | | | | | ☐ |
| SLH-DSA | $\Delta_q$ | | | | | ☐ |
| (scénario simulé) | $\eta_q$ | | | | | ☐ |
| | | | | | | ☐ |

L'algorithme de la thèse parle de « trois standards PQC ». Depuis l'exclusion de ML-KEM, qui ne produit pas de preuve, deux schémas de signature restent. Le rapport indique le nombre de normes effectivement confrontées.

## 4. Lecture

Rédiger en respectant les règles suivantes.

1. Une comparaison non probante n'est ni une confirmation ni une réfutation. Elle est rapportée avec l'hypothèse qui manque.
2. Une réfutation porte sur l'hypothèse ou la valeur désignée par le critère. Elle ne s'étend pas au cadre de la cryptographie institutionnelle dans son ensemble.
3. Les valeurs de la calibration illustrative (ECDSA, Helios, zk-SNARK, ML-DSA) ne sont pas des instances du théorème. Leur écart aux mesures se lit comme une révision de la calibration.
4. Les résultats sur $\eta_q$ ne valent que pour le scénario simulé.

## 5. Revue indépendante

Deux validateurs du panel, qui n'ont pas participé à l'analyse, relisent le rapport et la [liste de vérification des hypothèses](liste_verification_hypotheses_fr.md).

| Validateur | Accord avec les décisions | Réserves |
|---|---|---|
| `P7-VA-__` | ☐ oui ☐ non | |
| `P7-VA-__` | ☐ oui ☐ non | |

Licence CC BY 4.0.
