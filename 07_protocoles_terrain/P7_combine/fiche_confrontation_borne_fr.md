# Fiche de confrontation à la borne (P7, partie C)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 2, remarque `rem:forme_raffinee_pq` (équation `eq:trilemme_pq_raffine`, seuil $H^\sharp_q$) ; chapitre 4, §4.2.7.2, partie C ; critère « borne » du tableau `tab:criteres_refutation`

[English version](fiche_confrontation_borne_en.md) · [Protocole P7](protocole_fr.md) · [Liste de vérification](liste_verification_hypotheses_fr.md)

Cette fiche n'est remplie que si la [liste de vérification](liste_verification_hypotheses_fr.md) conclut que toutes les hypothèses sont vérifiées. Sinon, seule la section 4 est remplie, avec la mention « non probante ».

## 1. Paramètres (déposés avant la confrontation)

| Paramètre | Valeur | Source |
|---|---|---|
| $\lambda$ | | schéma |
| $\kappa$ | | analyse du protocole |
| $\Delta_q$ (capacité déposée) | bits | pré-enregistrement |
| $\alpha_q$, $\theta_q$ | | P4, P5 |
| $H(C)$ | bits | P2 ou table de référence |
| $\gamma_q = \theta_q\alpha_q H(C)$ | | calculé |
| $\eta_q$ (pour la majoration affaiblie) | | P6 |

## 2. Calcul de la borne

| Quantité | Formule | Valeur |
|---|---|---|
| Facteur de Fano | $(1+\kappa/\lambda)/\lambda$ | |
| Terme de capacité | $\min\{1, (\kappa/\lambda + \Delta_q)/\gamma_q\}$ | |
| **Borne raffinée** | produit des deux lignes précédentes (`bounds.borne_raffinee_pq`) | |
| Seuil $H^\sharp_q$ | $(\Delta_q + \kappa/\lambda)/(\theta_q\alpha_q)$ (`bounds.h_sharp_q`) | bits |
| Régime | ☐ capacité ($H(C) > H^\sharp_q$) ☐ Fano ($H(C) \leq H^\sharp_q$) | |
| Majoration affaiblie (comparaison) | $(\Delta_q + \eta_q H(C))/\lambda$ (`bounds.majorant_affaibli_pq`) | |

`bounds.report_pq(lam, kappa, delta_q, theta_q, alpha_q, h_c)` remplit ce tableau.

## 3. Produit mesuré

| Facteur | Estimation | IC 95 % | Source |
|---|---|---|---|
| $\mathsf{Conf}^q$ | | | |
| $\mathsf{Rel}^q$ (à l'échelle information-théorique) | | | |
| $\mathsf{Opp}^q$ | | | |
| **Produit** | | [____ ; ____] | bootstrap conjoint **[méthode à arrêter]** |

Les facteurs doivent être exprimés sur l'échelle information-théorique des définitions du chapitre 2. L'échelle opérationnelle de l'article CLO ($\mathsf{Rel}_{\text{ver}}$) ne convient pas. Mélanger les deux échelles rend la comparaison non probante (remarque `rem:portee_cas_etude`).

## 4. Décision (`refutation.criterion_bound`)

| Situation | Décision |
|---|---|
| Hypothèses non toutes vérifiées | ☐ **non probante** |
| Hypothèses vérifiées, borne inférieure de l'IC du produit > borne raffinée | ☐ **réfutée**. L'une des hypothèses est réfutée selon le tableau `tab:criteres_refutation`. Un réajustement a posteriori de $\hat\Delta_q$ ne peut pas absorber l'écart. |
| Hypothèses vérifiées, borne inférieure de l'IC ≤ borne raffinée | ☐ **non réfutée** |

Rempli par ______ le ___ / ___ / ______. Contrôlé par ______.

Licence CC BY 4.0.
