> **Statut : PROPOSITION — implémentation de référence** · Source : thèse, chapitre 4 (estimateurs, critères de réfutation)

# analyse — Chaîne d'analyse des données de terrain

*English version: [README_en.md](README_en.md)*

Le paquet `cro_terrain` met en œuvre les estimateurs que les protocoles P1 à P7 appliqueraient aux données recueillies. Aucun protocole n'a été déployé. Les tests et l'exemple utilisent exclusivement des données simulées, dont aucun chiffre ne doit être cité comme résultat.

| Module | Rôle |
|---|---|
| `information.py` | information mutuelle conditionnelle discrète, estimateur Δ̂ = Î(V;Σ\|M,C) avec correction de Miller–Madow, Ĥ(V\|C), Opp empirique |
| `statistics.py` | bootstrap par participant (IC à 95 %), test de permutation de l'admissibilité V ⊥ M \| (Σ,C) |
| `reliability.py` | ICC(2,1), kappa de Cohen et de Fleiss |
| `bounds.py` | forme raffinée de la borne, classique et post-quantique, seuils H♯ et H♯_q |
| `quantum.py` | estimation de η_q et contrôle négatif |
| `refutation.py` | application des critères de réfutation pré-enregistrés |
| `p1.py` | P1 : contrôles d'attention, exclusions, vecteur de verdict, listes de rotation, domaines des 50 paires |
| `p2.py` | P2 : décomposition structurelle, volume MDS (dépendance à l'unité), résumé et règle d'arrêt du Delphi |
| `p4.py` | P4 : algorithme `alg:estimation_conjointe` en six étapes, prérequis, dénombrement de $\mathcal{V}$, fiabilité, conversion des données de P1 |
| `p5.py` | P5 : $\hat\Delta_q$ par condition de bruit et par modalité d'aide, $\hat\eta_q$ par régression, erreurs d'interprétation, modèle de bruit de l'interface, ordre de Williams |
| `p6.py` | P6 : synthèse des simulations, plafond structurel de $\hat\eta_q$, heuristique d'Alicki-Fannes-Winter, lecture des prédictions |
| `p7.py` | P7 : algorithme `alg:protocole_combine`, vérification des hypothèses, $\hat\beta_q$ par entropie relative, confrontation à la borne, validation croisée |
| `sampling.py` | tirage aléatoire reproductible (graine publiée) |
| `simulate.py` | générateur de données synthétiques à Δ connu |
| `templates.py` | lecture des gabarits CSV des protocoles |

## Exécution

```sh
pip install --break-system-packages -r requirements.txt
python3 -m pytest -q tests        # 111 tests passés le 13 octobre 2026
python3 exemple_analyse.py        # exemple commenté sur données simulées
```
