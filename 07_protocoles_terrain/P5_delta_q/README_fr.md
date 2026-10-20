# Mesure de la capacité d'extraction quantique $\Delta_q$

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.5

[English version](README_en.md) · [Retour aux protocoles de terrain](../README_fr.md)

P5 mesure $\hat\Delta_q = \hat I(V^q;\Sigma\mid M,C)$ auprès de 80 professionnels formés aux systèmes post-quantiques. La mesure porte sur des signatures ML-DSA-65 et SLH-DSA réelles (phase 1), puis sur un vérificateur quantique simulé et bruité (phase 2, scénario hypothétique). Aucune donnée n'a été recueillie. Les éléments qui ne figurent pas dans la thèse sont signalés par la mention **[à arrêter par l'équipe]**.

## Contenu

| Document | Rôle | Phase |
|---|---|---|
| [protocole_fr.md](protocole_fr.md) | Objectif, portée (réel ou simulé), stratification, matériel, procédure, estimateurs, prédictions | toutes |
| [support_formation_pqc_fr.md](support_formation_pqc_fr.md) | Formation de 3 h aux normes NIST PQC | 0 |
| [stimuli/catalogue_stimuli_pqc_fr.md](stimuli/catalogue_stimuli_pqc_fr.md) | 12 paires, 2 rédigées en entier, fiches d'aide à l'interprétation | 1 |
| [stimuli/generer_signatures_pqc.py](stimuli/generer_signatures_pqc.py) et [exemples_signatures_pqc.json](stimuli/exemples_signatures_pqc.json) | Signatures ML-DSA-65 et SLH-DSA réelles des 2 paires rédigées, vérifiables | 1 |
| [questionnaire_pqc_fr.md](questionnaire_pqc_fr.md) | Verdict et confiance sans aide puis avec aide, contrôle d'attention, règles de saisie | 1, 2, 3 |
| [specification_interface_verification_fr.md](specification_interface_verification_fr.md) | Cahier des charges de l'interface, modèle de bruit, journal, tests d'acceptation | 1, 2, 3 |
| [fiche_conditions_bruit_fr.md](fiche_conditions_bruit_fr.md) | Conditions A à D, ordre de Williams, fiche du participant | 2 |
| [fiche_test_retest_pqc_fr.md](fiche_test_retest_pqc_fr.md) | Retest à bruit constant, 4 items | 3 |
| [grille_gold_standard_pqc_fr.md](grille_gold_standard_pqc_fr.md) | Verdicts de référence selon le résultat affiché | 4 |
| [fiche_debriefing_pqc_fr.md](fiche_debriefing_pqc_fr.md) | Texte de restitution et questions propres à P5 | 5 |
| [gabarit_sessions_pqc_fr.csv](gabarit_sessions_pqc_fr.csv) | Saisie, une ligne par écran | saisie |

## Analyse

Le module `cro_terrain.p5` calcule $\hat\Delta_q$ par condition et par modalité d'aide. Il estime $\hat\eta_q(p)$ par rapport à la condition A, puis la pente de $\hat\eta_q$ en fonction de $p$. Il calcule aussi les erreurs d'interprétation et donne une lecture descriptive des cinq prédictions. Il fournit enfin le modèle de bruit de l'interface et l'ordre de Williams.

```python
from cro_terrain.templates import read_template
from cro_terrain import p5

d = read_template("gabarit_sessions_pqc_fr.csv", "p5_sessions")
print(p5.delta_q_by_condition(d, aid="0", alphabet_size=4))
print(p5.eta_q_regression(d, h_c=10.5, aid="0", alphabet_size=4))   # H(C) d'espèce ML-DSA
print(p5.error_rate_by_condition(d))
```

## Points principaux à trancher

1. **Portée de la phase 2.** Pour ML-DSA et SLH-DSA, $\eta_q = 0$, car ce sont des chaînes de bits. La phase 2 ne mesure qu'un scénario hypothétique. Le protocole et le débriefing le disent.
2. **Effet attendu du bruit.** Avec $p \leq 0{,}1$, le résultat affiché n'est inversé qu'au plus une fois sur vingt. La prédiction 4 demande une simulation de puissance avant la collecte.
3. **Référence classique.** Les prédictions 1 et 2 comparent $\hat\Delta_q$ à un $\hat\Delta$ classique. La source de ce dernier (mêmes participants ou strate de P1) est à arrêter.
4. **Trois preuves ou deux schémas.** L'algorithme de la thèse prend trois preuves en entrée, alors que le matériel ne compte plus que deux schémas.

## Licence

CC BY 4.0 pour les documents, MIT pour le script. Les bibliothèques `dilithium-py` (MIT) et `slh-dsa` (LGPL-3.0) sont des dépendances. Elles ne sont pas incluses dans le dépôt.
