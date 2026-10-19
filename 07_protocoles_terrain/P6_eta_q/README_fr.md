# P6_eta_q — Mesure de la perte d'interprétabilité quantique $\eta_q$

> **Statut : PROPOSITION — protocole non déployé, scénario hypothétique** · Source : thèse, chapitre 4, §4.2.6

[English version](README_en.md) · [Retour aux protocoles de terrain](../README_fr.md)

P6 estime $\hat\eta_q = [I(V^q;\rho_\Sigma\mid C) - I(V^q;\Lambda(\rho_\Sigma)\mid C)]/H(C)$ par simulation de canaux quantiques. Il porte sur le scénario hypothétique d'un support ou d'un vérificateur quantique. Pour les signatures post-quantiques actuelles, qui sont des chaînes de bits, $\eta_q = 0$. Les éléments qui ne figurent pas dans la thèse sont signalés par la mention **[à arrêter par l'équipe]**.

## Contenu

| Document | Rôle |
|---|---|
| [protocole_fr.md](protocole_fr.md) | Définition, portée, deux volets (simulation et experts), procédure, prédictions, points de vigilance |
| [plan_simulation_fr.md](plan_simulation_fr.md) | Plan versionné `plan-v0.1` : modèle, canaux, niveaux, contrôles, sorties |
| [fiche_parametres_canaux_fr.md](fiche_parametres_canaux_fr.md) | Relevé sourcé des taux d'erreur du matériel et conversion en paramètres de canal |
| [fiche_elicitation_experts_fr.md](fiche_elicitation_experts_fr.md) | Intervalle prédit de $\eta_q$ fixé par 40 experts avant la simulation |
| [sortie_plan_reference_fr.csv](sortie_plan_reference_fr.csv) | Sortie de `plan-v0.1` (200 exécutions), reproduite à l'identique par un test |
| [gabarit_simulation_fr.csv](gabarit_simulation_fr.csv) | Gabarit des sorties de simulation |

## Exécution et analyse

```sh
cd ../analyse
python3 -m cro_terrain.quantum --out ../P6_eta_q/sortie_plan_reference_fr.csv --lang fr
```

```python
from cro_terrain.templates import read_template
from cro_terrain import p6

s = p6.summarize(read_template("sortie_plan_reference_fr.csv", "p6_simulation"))
print(p6.check_predictions(s))
```

## Ce que montre le plan de référence

Il s'agit d'une propriété du modèle jouet, non d'un résultat.

- $\hat\eta_q$ croît avec le bruit sur les quatre canaux et respecte l'heuristique d'Alicki-Fannes-Winter.
- Le contrôle négatif (preuve lue comme chaîne de bits) donne exactement $\hat\eta_q = 0$.
- Avec $H(C) = 10{,}5$ bits, $\hat\eta_q$ ne dépasse pas 0,030 et vaut au plus 0,009 pour le canal combiné provisoire. Il reste donc très en dessous de l'intervalle de 0,05 à 0,15 attendu par la thèse.
- Un plafond structurel s'applique toujours, $\hat\eta_q \leq I(V^q;\rho_\Sigma\mid C)/H(C) \leq \log_2|\mathcal{V}|/H(C)$. Il vaut environ 0,14 dans le modèle à $H(C) = 10{,}5$ bits contre 0,07 à $H(C) = 20$ bits.

## Licence

CC BY 4.0 pour les documents et les sorties. Le code est dans le paquet d'analyse (MIT).
