# P4_delta_alpha — Estimation conjointe standardisée de $\Delta$ et $\alpha$

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.4 (algorithme `alg:estimation_conjointe`)

[English version](README_en.md) · [Retour aux protocoles de terrain](../README_fr.md)

P4 est le protocole de référence pour estimer $(\hat\Delta, \hat\alpha)$ dans une institution. Il fixe trois prérequis, six étapes et deux seuils de validation. Il réutilise les données de P1 ou s'applique à toute autre institution d'au moins 30 participants. Aucune donnée n'a été recueillie. Les éléments qui ne figurent pas dans la thèse sont signalés par la mention **[à arrêter par l'équipe]**.

## Contenu

| Document | Rôle | Étape |
|---|---|---|
| [protocole_fr.md](protocole_fr.md) | Objet, entrées et sorties, prérequis, six étapes, précisions | toutes |
| [liste_controle_prerequis_fr.md](liste_controle_prerequis_fr.md) | Prérequis bloquants de la thèse et conditions de validité proposées | `Require` |
| [fiche_denombrement_verdicts_fr.md](fiche_denombrement_verdicts_fr.md) | Dénombrement de $\mathcal{V}$ dans les textes, par deux rédacteurs indépendants | 5 |
| [grille_fiabilite_fr.md](grille_fiabilite_fr.md) | ICC test-retest et $\kappa$ inter-évaluateurs, décision | 6 |
| [rapport_estimation_fr.md](rapport_estimation_fr.md) | Modèle de rapport, critères de réfutation $\Delta$, admissibilité et $\gamma$ | sortie |
| [gabarit_verdicts_fr.csv](gabarit_verdicts_fr.csv) | Saisie des verdicts, une ligne par participant et par item (colonne `session` 1 ou 2) | 1 et 2 |
| [gabarit_denombrement_verdicts_fr.csv](gabarit_denombrement_verdicts_fr.csv) | Saisie du dénombrement des verdicts | 5 |

## Analyse

Le module `cro_terrain.p4` met en œuvre l'algorithme.

```python
from cro_terrain.templates import read_template
from cro_terrain import p4

d = read_template("gabarit_verdicts_fr.csv", "p4_verdicts")
v = read_template("gabarit_denombrement_verdicts_fr.csv", "p4_verdict_space")
rep = p4.estimation_conjointe(
    d, n_verdicts=p4.verdict_space_size(v, "INST-01"), h_c=8.0,  # H(C) issu de P2
    delta_prereg=25.0,                                            # capacité déposée
    institutional_agreement=True, ethics_approval=True)
print("\n".join(rep.summary()))
```

Pour réutiliser les données de P1, `p4.p1_to_p4` convertit une table `p1_answers` au format `p4_verdicts`. Le verdict retenu est alors le verdict global Q01. La session correspond à la phase de P1.

Le gabarit `gabarit_verdicts` doit comporter une colonne `id_preuve` qui identifie de façon unique un item par participant et par session. Sans elle, l'appariement du retest serait ambigu. La fonction lève alors une erreur.

## Ce que ce dossier ne contient pas

- Un estimateur de $\beta$. L'algorithme de la thèse n'en donne pas.
- Des stimuli propres. P4 utilise ceux de P1 ou ceux de l'étude à laquelle il s'applique.
- Toute donnée de terrain.

## Licence

CC BY 4.0.
