# Liste de vérification des hypothèses du théorème CRO$^q$ (P7, partie C)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 2, hypothèses `ass:extraction_quantique`, `ass:verdict_quantique`, `ass:regularite_quantique`, `ass:regime_quantique`, définition de l'interprète admissible ; remarque `rem:portee_cas_etude` ; chapitre 4, §4.2.7.2, partie C

[English version](liste_verification_hypotheses_en.md) · [Protocole P7](protocole_fr.md)

Une liste par protocole confronté (par exemple ML-DSA-65 dans le contexte $C$ de l'institution $I$). Elle est remplie **avant** toute comparaison à la borne. Une seule hypothèse non vérifiée rend la comparaison non probante. Elle ne peut pas alors être réfutée ni confirmée. La fonction `cro_terrain.p7.Hypotheses.evaluate` applique les mêmes contrôles.

| Champ | Valeur |
|---|---|
| Protocole (schéma, paramètres) | ______ |
| Institution, contexte | `INST-__`, ______ |
| Paramètres déposés | $\lambda =$ ____, $\kappa =$ ____, $\alpha_q =$ ____, $\theta_q =$ ____, $H(C) =$ ____ bits |
| Sources des estimations | P5 ______, P6 ______, analyse du protocole ______ |

## Contrôles

| N° | Hypothèse (thèse) | Contrôle | Données | Résultat |
|---|---|---|---|---|
| 0 | Domaine des théorèmes | $\lambda \geq 64$ | paramètre du schéma | ☐ vérifiée ☐ non |
| 1 | Extraction bornée quantique, $I(V;\Sigma\mid C) \leq I(M;\Sigma\mid C) + \Delta_q$ | critère $\Delta$ non réfuté : borne inférieure de l'IC 95 % de $\hat I(V;\Sigma\mid M,C)$ ≤ capacité déposée | P5, partie A | ☐ vérifiée ☐ non ☐ non testable |
| 1 bis | Interprète admissible, $V \perp M \mid (\Sigma, C)$ | test de permutation non rejeté au seuil 0,01, avec au moins une strate informative | P5, partie A | ☐ vérifiée ☐ non ☐ non testable |
| 2a | Verdict efficace quantique, espace de verdicts | $\log_2 k_\lambda \leq \alpha_q H(C)$ | dénombrement de $\mathcal{V}$ (P4) | ☐ vérifiée ☐ non |
| 2b | Verdict efficace quantique, non-dégénérescence | $\gamma_q = \theta_q\alpha_q H(C) \geq 1$ | paramètres déposés | ☐ vérifiée ☐ non |
| 2c | Verdict efficace quantique, $H(V\mid C) \geq \gamma_q$ | borne supérieure de l'IC 95 % de $\hat H(V\mid C)$ (NSB) ≥ $\gamma_q$ | P5 | ☐ vérifiée ☐ non |
| 3 | Régularité quantique, $D(\rho_\Sigma^{m_0,c}\|\rho_\Sigma^{m_1,c}) \leq \beta_q\,\chi(\mathcal{E}_{m,c}) + \zeta_q\,D(\bar\rho_\Sigma^c\|\mathbb{I}/d_\Sigma)$ | $\hat\beta_q$ fini (avec $\zeta_q = 0$, `p7.beta_q_min`) ou démonstration analytique | description du protocole | ☐ vérifiée ☐ non |
| 4 | Régime de confidentialité quantique, $\chi_{\max} \leq \kappa/\lambda$ | $\chi_{\max}$ calculé ou majoré | description du protocole | ☐ vérifiée ☐ non |

## Repères pour les signatures post-quantiques

Pour une signature ML-DSA ou SLH-DSA, le message engagé est lié à la signature par son condensé. On s'attend donc aux résultats suivants **[à confirmer protocole par protocole]**.

- Contrôle 3. Supports disjoints entre messages, $D = +\infty$, d'où $\hat\beta_q = +\infty$ et une régularité non vérifiée.
- Contrôle 4. $\chi_{\max}$ de l'ordre de $H(M\mid C)$, très supérieur à $\kappa/\lambda$, d'où un régime non vérifié.
- Conclusion. Comparaison à la borne non probante (remarque `rem:portee_cas_etude`).

## Décision

☐ Toutes les hypothèses sont vérifiées. La comparaison à la borne est probante ([fiche de confrontation](fiche_confrontation_borne_fr.md)).
☐ Hypothèse(s) non vérifiée(s) : ______. La comparaison n'est pas probante. Le rapport le mentionne sans conclure sur la borne.

Rempli par ______ le ___ / ___ / ______. Revu de façon indépendante par deux validateurs ______ et ______.

Licence CC BY 4.0.
