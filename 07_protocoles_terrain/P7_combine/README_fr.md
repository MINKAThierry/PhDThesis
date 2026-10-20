# Protocole combiné de validation post-quantique

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.7 (algorithme `alg:protocole_combine`)

[English version](README_en.md) · [Retour aux protocoles de terrain](../README_fr.md)

P7 assemble les résultats de P5 ($\hat\Delta_q$) et de P6 ($\hat\eta_q$), calcule $\hat\beta_q$, vérifie les hypothèses du théorème CRO$^q$, puis confronte les mesures à la borne raffinée seulement si ces hypothèses tiennent. Il se termine par la validation croisée et par le rapport de réfutation de l'ensemble du programme. Les éléments qui ne figurent pas dans la thèse sont signalés par la mention **[à arrêter par l'équipe]**.

## Contenu

| Document | Rôle | Partie |
|---|---|---|
| [protocole_fr.md](protocole_fr.md) | Objectif, quatre parties, borne confrontée, $\hat\beta_q$, conséquence attendue pour les signatures, critères | toutes |
| [liste_verification_hypotheses_fr.md](liste_verification_hypotheses_fr.md) | Contrôle des hypothèses 1 à 4 et de l'admissibilité avant toute confrontation | C |
| [fiche_confrontation_borne_fr.md](fiche_confrontation_borne_fr.md) | Calcul de la borne raffinée, du seuil $H^\sharp_q$ et décision | C |
| [modele_rapport_refutation_fr.md](modele_rapport_refutation_fr.md) | Décisions sur tous les critères du tableau `tab:criteres_refutation`, validation croisée, revue indépendante | D |

## Analyse

```python
from cro_terrain import p7

hyp = p7.Hypotheses(lam=128, kappa=2.0, delta_q_ci_low=20.0, delta_q_prereg=28.0,
                    admissibility_p=0.4, admissibility_informative_strata=12,
                    log2_verdicts=2.0, alpha_q=0.2, theta_q=0.5, h_c=20.0,
                    h_v_c_ci=(1.8, 2.0), beta_q=1.04, chi_max=0.01)   # valeurs d'illustration
rep = p7.protocole_combine(hyp=hyp, eta_ci=(0.0, 0.01), eta_predicted=(0.05, 0.15),
                           product_ci_low=0.001)
print(rep["C_bound"])
```

Les valeurs ci-dessus ne servent qu'à illustrer l'appel de la fonction.

## Point principal

Pour ML-DSA et SLH-DSA, la régularité et le régime de confidentialité échouent presque certainement. La signature révèle le message engagé, si bien que $\hat\beta_q = +\infty$ et $\chi_{\max} \gg \kappa/\lambda$. La confrontation à la borne sera donc **non probante**, conformément à la remarque `rem:portee_cas_etude`. Une confrontation probante demande un protocole post-quantique à fuite contrôlée.

## Licence

CC BY 4.0.
