# P7 — Protocole combiné de validation post-quantique

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.7 (algorithme `alg:protocole_combine`, tableau `tab:criteres_refutation`)

[English version](protocole_en.md) · [README du dossier](README_fr.md)

## 1. Objectif

Valider conjointement les paramètres post-quantiques $(\Delta_q, \eta_q)$ et comparer les prédictions du trilemme CRO post-quantique aux mesures faites sur les normes NIST PQC (thèse, §4.2.7.1).

P7 ne crée pas de nouvelle collecte de verdicts. Il assemble les estimations de P5 ($\hat\Delta_q$) et de P6 ($\hat\eta_q$), y ajoute $\hat\beta_q$, vérifie les hypothèses du théorème et ne confronte qu'ensuite les mesures à la borne. Les 40 validateurs prévus par la thèse (tableau `tab:programme_experimental`) examinent la liste de vérification des hypothèses et le rapport de réfutation de façon indépendante **[rôle à arrêter par l'équipe]**.

## 2. Les quatre parties de l'algorithme

| Partie | Contenu (thèse) | Données | Mise en œuvre |
|---|---|---|---|
| A | Mesurer l'extraction sur ML-DSA et SLH-DSA sans bruit, calculer $\hat\Delta_q$ par comparaison avec le gold standard PQC | P5, phase 1, condition A | `p5.delta_q_by_condition`, critère $\Delta$ |
| B | Appliquer des canaux quantiques à intensité croissante, mesurer la décroissance de l'information mutuelle, calculer $\hat\eta_q$ par régression | P6 (simulation), P5 phase 2 | `p6.summarize`, `p5.eta_q_regression`, critère $\eta_q$ |
| C | Vérifier les hypothèses du théorème (dont $H(V\mid C) \geq \gamma_q$). Si elles tiennent, confronter $\mathsf{Conf}^q\cdot\mathsf{Rel}^q\cdot\mathsf{Opp}^q$ à la borne raffinée | P5, P6, analyse du protocole | [liste de vérification](liste_verification_hypotheses_fr.md), [fiche de confrontation](fiche_confrontation_borne_fr.md), `p7.Hypotheses`, critère borne |
| D | Comparer prédiction et mesure pour chaque norme PQC, calculer l'erreur relative et les intervalles de confiance | tout ce qui précède | `p7.cross_validation`, [rapport](modele_rapport_refutation_fr.md) |

`cro_terrain.p7.protocole_combine` enchaîne les quatre parties.

## 3. Borne confrontée

La forme raffinée quantique s'écrit (thèse, remarque `rem:forme_raffinee_pq`, équation `eq:trilemme_pq_raffine`)

$$\mathsf{Conf}^q\cdot\mathsf{Rel}^q\cdot\mathsf{Opp}^q \;\leq\; \frac{1+\kappa/\lambda}{\lambda}\,\min\left\{1,\;\frac{\kappa/\lambda + \Delta_q}{\gamma_q}\right\},\qquad \gamma_q = \theta_q\,\alpha_q\,H(C).$$

$\eta_q$ n'intervient pas dans la forme raffinée. Il n'apparaît que dans la majoration affaiblie $(\Delta_q + \eta_q H(C))/\lambda + O(\lambda^{-2})$ (`bounds.majorant_affaibli_pq`), qui est rapportée à titre de comparaison.

## 4. Sur $\hat\beta_q$

L'algorithme compte $\hat\beta_q$ parmi ses sorties. La régularité (hypothèse `ass:regularite_quantique`) porte sur les états $\rho_\Sigma^{m,c}$ produits par le protocole, non sur les réponses des participants. $\hat\beta_q$ se calcule donc à partir de la description du protocole. Pour des états donnés, la fonction `p7.beta_q_min` renvoie le plus petit $\beta_q$ compatible avec $\zeta_q = 0$.

Pour une signature, deux messages distincts donnent des états à supports disjoints. On a alors $D(\rho^{m_0,c}\,\|\,\rho^{m_1,c}) = +\infty$ et le protocole n'est pas quantique-régulier. Une signature révèle en outre le message engagé, si bien que $\chi_{\max} \gg \kappa/\lambda$ et que l'hypothèse de régime `ass:regime_quantique` échoue aussi.

## 5. Conséquence attendue pour ML-DSA et SLH-DSA

D'après la remarque `rem:portee_cas_etude`, les systèmes déployés ne sont pas des instances du théorème. Leurs valeurs servent à une calibration illustrative. Pour ML-DSA et SLH-DSA, la partie C conclut donc presque certainement **« comparaison non probante »**, faute de régularité et de régime. Cette issue est prévue. Ce n'est ni une réfutation ni une confirmation de la borne.

Les parties A, B et D gardent leur intérêt.

- A et B testent les critères portant sur $\Delta$ et sur $\eta_q$ ;
- D confronte les valeurs de la calibration illustrative aux mesures.

Une confrontation probante à la borne demande un protocole à fuite contrôlée, $I(M;\Sigma\mid C) \leq \kappa/\lambda$. Les engagements parfaitement masquants et les preuves à divulgation nulle de connaissance en sont les exemples canoniques. Pour le régime post-quantique, il faudrait leur version post-quantique, par exemple une variante de SOTP **[extension à arrêter par l'équipe]**.

## 6. Critères (tableau `tab:criteres_refutation`)

| Paramètre | Réfuté si… | Partie |
|---|---|---|
| $\Delta$ (ici $\Delta_q$) | la borne inférieure de l'IC 95 % de $\hat I(V;\Sigma\mid M,C)$ dépasse la capacité fixée avant l'expérience | A |
| Admissibilité | un test de permutation rejette $V \perp M \mid (\Sigma,C)$ au seuil 0,01 | A |
| $\gamma$ (ici $\gamma_q$) | la borne supérieure de l'IC 95 % de $\hat H(V\mid C)$ est inférieure à $\gamma_q$ | C |
| $\eta_q$ | l'IC 95 % de $\hat\eta_q$ exclut l'intervalle prédit avant l'expérience | B |
| Borne | hypothèses vérifiées, le produit mesuré dépasse la forme raffinée avec une confiance de 95 % | C |

Les seuils sont indicatifs et seront arrêtés lors du pré-enregistrement. Leur forme constitue l'engagement méthodologique (thèse, §4.2.7.3).

La thèse écrit le critère $\gamma$ classique avec $\alpha H(\mathcal{C}) - 1$. Pour le régime quantique, la proposition utilise $\gamma_q = \theta_q\alpha_q H(C)$ de l'hypothèse `ass:verdict_quantique` **[à confirmer par l'équipe]**.

## 7. Durée et ressources

La thèse prévoit 3 mois, 40 validateurs et un coût estimé de 6 000 000 FCFA (tableau `tab:programme_experimental`), dans la fenêtre A25–A36 (tableau `tab:calendrier_experimental`).

## 8. Prérequis

☐ P5 et P6 terminés, ou au moins leurs parties utilisées
☐ Paramètres $(\lambda, \kappa, \alpha_q, \theta_q, H(C))$ fixés avant la confrontation et déposés
☐ Description des états du protocole disponible pour $\hat\beta_q$ et $\chi_{\max}$
☐ Pré-enregistrement déposé ([modèle](../00_commun/preenregistrement_fr.md))

Licence CC BY 4.0.
