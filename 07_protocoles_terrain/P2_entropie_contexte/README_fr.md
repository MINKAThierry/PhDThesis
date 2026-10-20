# Mesure de l'entropie contextuelle $H(\mathcal{C})$

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.2

[English version](README_en.md) · [Retour aux protocoles de terrain](../README_fr.md)

Ce dossier rassemble le protocole P2 et ses instruments. P2 estime $H(\mathcal{C})$ à l'échelle du domaine institutionnel par trois approches indépendantes. Aucune donnée n'a été recueillie. Les éléments qui ne figurent pas dans la thèse sont signalés par la mention **[à arrêter par l'équipe]**.

## Contenu

| Document | Rôle | Approche |
|---|---|---|
| [protocole_fr.md](protocole_fr.md) | Objectif, échelles de $H(\mathcal{C})$, hypothèses H2.1 à H2.3, plan, calendrier, points de vigilance | toutes |
| [grille_decomposition_structurelle_fr.md](grille_decomposition_structurelle_fr.md) | Grille d'éléments par composante L, T, R pour les trois domaines | 1 |
| [corpus_contextes_fr.md](corpus_contextes_fr.md) et [corpus_contextes.csv](corpus_contextes.csv) | Les 100 contextes (34 ELEC, 33 FIN, 33 CONT) avec les niveaux des éléments de la grille | 2 |
| [generer_corpus.py](generer_corpus.py) | Production reproductible du corpus (graine fixe, option `--check`) | 2 |
| [protocole_dissimilarite_mds_fr.md](protocole_dissimilarite_mds_fr.md) | Passation des jugements par paires, échelle 0 à 10, livret de secours, contrôles de qualité | 2 |
| [delphi_questionnaire_tour1_fr.md](delphi_questionnaire_tour1_fr.md) | Questionnaire individuel du tour 1 | 3 |
| [delphi_retour_tours_2_4_fr.md](delphi_retour_tours_2_4_fr.md) | Règle de conduite entre les tours et formulaire de révision | 3 |
| [delphi_synthese_fr.md](delphi_synthese_fr.md) | Rapport final et confrontation des trois approches | toutes |
| [gabarit_decomposition_fr.csv](gabarit_decomposition_fr.csv) | Saisie de la grille, une ligne par élément (jeu D6a) | 1 |
| [gabarit_dissimilarite_fr.csv](gabarit_dissimilarite_fr.csv) | Saisie des jugements, une ligne par paire présentée (jeu D6b) | 2 |
| [gabarit_delphi_fr.csv](gabarit_delphi_fr.csv) | Saisie des tours, une ligne par expert, tour et domaine (jeu D6c) | 3 |

Les pièces communes (consentement, engagement de confidentialité, fiche de recrutement, journal de séance, fiche d'écart, pré-enregistrement, plan d'analyse, dictionnaire des variables) sont dans [00_commun](../00_commun/README_fr.md). La notice d'information prévoit une séance de comparaison de contextes. La présente proposition en compte trois, une par domaine. La notice doit être complétée en conséquence avant le dépôt au comité d'éthique.

## Analyse

Les gabarits sont lus par le paquet [cro_terrain](../analyse/README_fr.md) (schémas `p2_decomposition`, `p2_dissimilarity`, `p2_delphi`). Le module `cro_terrain.p2` calcule les trois estimations.

```python
from cro_terrain.templates import read_template
from cro_terrain import p2

dec = read_template("gabarit_decomposition_fr.csv", "p2_decomposition")
tot = p2.decomposition_totals(dec["expert_id"], dec["domain"], dec["component"], dec["entropy_bits"])
print(p2.summarize_by_domain(tot))

dis = read_template("gabarit_dissimilarite_fr.csv", "p2_dissimilarity")
ids, D, n = p2.dissimilarity_matrix(dis["ctx_i"], dis["ctx_j"], dis["dissimilarity"])
k = p2.choose_dimensions(D, stress_max=0.15)        # seuil à déposer avant collecte
print(p2.mds_entropy(D, k, unit=1.0))               # unité à déposer avant collecte
```

Pour la MDS, la matrice est construite domaine par domaine, en filtrant les lignes sur la colonne `domain`.

## Ce que ce dossier ne contient pas

- Un pré-test des instruments.
- Le formulaire électronique de passation des jugements de dissimilarité, dont seul le cahier des charges est donné.
- Toute donnée de terrain.

## Licence

CC BY 4.0 pour les documents et le corpus, MIT pour `generer_corpus.py`.
