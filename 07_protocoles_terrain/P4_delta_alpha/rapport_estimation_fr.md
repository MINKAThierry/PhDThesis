# Modèle de rapport d'estimation conjointe (P4)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.4 (algorithme `alg:estimation_conjointe`) et §4.2.7.3 (tableau `tab:criteres_refutation`)

[English version](rapport_estimation_en.md) · [Protocole P4](protocole_fr.md)

Un rapport par institution. Les valeurs sont reprises du rapport produit par `cro_terrain.p4.estimation_conjointe` (méthode `summary()`). Les mentions « fiabilité insuffisante » ou « exploratoire » sont reportées en tête lorsqu'elles s'appliquent.

## 0. En-tête

| Champ | Valeur |
|---|---|
| Institution, type | `INST-__`, ______ |
| Contexte(s) $C$ | ______ |
| Données | ☐ P1 (converties par `p4.p1_to_p4`) ☐ collecte propre |
| Pré-enregistrement | référence ______ |
| Version du paquet d'analyse et du script | ______ |
| Mentions | ☐ aucune ☐ fiabilité insuffisante ☐ fiabilité non calculable ☐ exploratoire ($n < 30$) |

## 1. Prérequis

| Prérequis | État |
|---|---|
| Accord institutionnel | ☐ oui ☐ non |
| Avis éthique | ☐ oui ☐ non |
| $n \geq 30$ participants analysés | ☐ oui ☐ non ($n =$ ____) |

## 2. Déroulement des six étapes

| Étape | Statut | Détail |
|---|---|---|
| 1 Collecte | | réponses ____, participants ____, verdicts manquants ____ |
| 2 Appariement à $m$ | | réponses sans vérité terrain ____ |
| 3 Admissibilité | | $\hat I(V;M\mid\Sigma,C) =$ ____, $p =$ ____, strates informatives ____ |
| 4 $\hat\Delta$ | | ____ bits, IC 95 % [____ ; ____], $n$ participants ____ |
| 5 $\hat\alpha$ | | $|\mathcal{V}| =$ ____, $H(C) =$ ____ bits, $\hat\alpha =$ ____ ; $\hat H(V\mid C) =$ ____ bits, IC [____ ; ____] |
| 6 Fiabilité | | ICC ____, $\kappa$ inter ____, $\kappa$ retest ____ |

## 3. Critères de réfutation concernés

| Paramètre | Règle (tableau `tab:criteres_refutation`) | Entrées | Décision |
|---|---|---|---|
| $\Delta$ | réfuté si la borne inférieure de l'IC 95 % de $\hat I(V;\Sigma\mid M,C)$ dépasse la capacité fixée avant l'expérience | borne inférieure ____, capacité ____ | ☐ non réfuté ☐ réfuté ☐ non probant |
| Admissibilité | réfutée si le test de permutation rejette $V \perp M \mid (\Sigma,C)$ au seuil 0,01 | $p =$ ____ | ☐ non réfutée ☐ réfutée ☐ non testable |
| $\gamma$ | réfuté si la borne supérieure de l'IC 95 % de $\hat H(V\mid C)$ est inférieure à $\alpha H(\mathcal{C}) - 1$ | borne ____, $\gamma =$ ____ | ☐ non réfuté ☐ réfuté ☐ non probant |

Si la fiabilité est insuffisante ou non calculable, la colonne « Décision » est remplie à titre indicatif et marquée « non applicable ».

## 4. Lecture

Rédiger en quelques paragraphes, en se tenant aux règles suivantes.

1. $\hat\Delta$ et $\hat\alpha$ sont commentés séparément. Une erreur sur l'un ne se reporte pas sur l'autre (thèse, §4.2.4).
2. Si l'admissibilité est rejetée, $\hat\Delta$ n'est pas présenté comme une capacité d'extraction.
3. Les prédictions de la thèse (par exemple $\approx 25$ bits pour les juges généralistes) sont des cibles, non des bornes. Un écart se rapporte sans conclure au-delà du critère pré-enregistré.
4. $\beta$ n'est pas estimé par ce protocole.

## 5. Annexes

☐ Sortie complète de `estimation_conjointe(...).summary()`
☐ [Grille de fiabilité](grille_fiabilite_fr.md)
☐ [Fiche de dénombrement](fiche_denombrement_verdicts_fr.md) consolidée
☐ [Liste de contrôle des prérequis](liste_controle_prerequis_fr.md) signée
☐ Fiches d'écart

Rédigé par ______ le ___ / ___ / ______. Relu par ______.

Licence CC BY 4.0.
