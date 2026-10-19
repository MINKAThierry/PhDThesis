# P3: Extension post-quantique du Trilemme CRO conditionnel (IEEE Access, 2026)

> **Statut : PUBLIÉ** · Source : *IEEE Access*, vol. 14, pp. 125130–125155, 2026, DOI [10.1109/ACCESS.2026.3722742](https://doi.org/10.1109/ACCESS.2026.3722742) · Thèse, chapitre 2, §2.4

[English version](README_en.md)

## Référence

T. E. MINKA MI NGUIDJOÏ, F. S. MANI ONANA, T. DJOTIO NDIÉ, « Post-Quantum Extension of the Conditional CRO Trilemma: Impossibility Bounds on Confidentiality, Reliability, and Opposability Under Quantum Institutional Extraction Limits », *IEEE Access*, vol. 14, pp. 125130–125155, 2026. Reçu le 19 juin 2026, accepté le 2 août 2026, publié le 12 août 2026. Entrée BibTeX dans [`CITATION.bib`](CITATION.bib).

## Fichiers

| Fichier | Contenu |
|---|---|
| [`article.pdf`](article.pdf) | Version publiée par l'éditeur (26 pages) |
| [`source/Final_PQ_Extension_CRO_Trilemma.tex`](source/Final_PQ_Extension_CRO_Trilemma.tex) | Source LaTeX de la version finale soumise |
| [`CITATION.bib`](CITATION.bib) | Référence bibliographique |
| [`formulations_precisees/`](formulations_precisees/) | Formulations précisées soumises à l'éditeur, non publiées (statut PROPOSITION) |

## Licence

L'article est publié en accès ouvert par l'IEEE sous licence Creative Commons Attribution 4.0 (CC BY 4.0), avec la mention « © 2026 The Authors ». Sa redistribution ici est permise sous réserve de citer la référence ci-dessus.

## Résumé

L'article se demande si les adversaires quantiques et les effets de canal quantique modifient les bornes du Trilemme CRO conditionnel. Il étend le modèle de capacité institutionnelle au cadre quantique avec deux paramètres, la capacité d'extraction quantique $\Delta_q$ et le coefficient de perte d'interprétabilité quantique $\eta_q$. Sous des hypothèses explicites, il énonce la borne $\mathrm{Conf}^q\cdot\mathrm{Rel}^q\cdot\mathrm{Opp}^q\le(\Delta_q+\eta_q H(C))/\lambda+O(\lambda^{-2})+\mathrm{negl}(\lambda)$. Les preuves mobilisent l'inégalité de Pinsker quantique, le lemme de mesure douce et l'inégalité de Fano quantique. Une analyse de cohérence interne associe aux finalistes NIST PQC (Dilithium, Kyber, SPHINCS+) des capacités implicites $\Delta_q\in[28,67]$ bits. L'article revient sur les systèmes déjà étudiés (Helios, zk-SNARKs, ECDSA) et propose un cadre d'appariement entre protocoles post-quantiques et capacités institutionnelles.

## Place dans la thèse

L'article fonde la contribution **C3** de la thèse (extension quantique du Trilemme CRO conditionnel, chapitre 2, §2.4). La thèse présente une version de la preuve qui diffère de la version publiée (`rem:version_preuve_pq`, §2.4.3) . La formalisation Lean a conduit à ces formulations alternatives (§3.4.9).

## Ce que la thèse précise

La thèse conserve le modèle institutionnel quantique, les paramètres $(\Delta_q,\alpha_q,\beta_q,\eta_q)$ et la forme de la borne principale dans le régime où elle est établie. Le détail énoncé par énoncé figure dans [`../../03_resultats_these/resultats_these_fr.md`](../../03_resultats_these/resultats_these_fr.md).

### Points communs avec les formulations précisées soumises ([`formulations_precisees/`](formulations_precisees/))

| Point | Dans l'article | Dans la thèse | Référence thèse |
|---|---|---|---|
| Lemme 6 | Inégalité (68) sur des tirages indépendants | La formulation s'en passe (cas limite des états orthogonaux), ainsi que de la majoration (72) du Lemme 7 | `rem:retrait_lemma6`, §2.4.4 |
| Lemme 7 | Minoration exprimée avec l'information accessible | Minoration avec l'information de Holevo, $\mathrm{Conf}^q\ge 1-\tfrac12\sqrt{2\beta_q\chi_{\max}+2\zeta_q D_{\max}}$ | `lem:q_conf_mi_pq`, §2.4.4 |
| Hypothèse 4 | Minoration de $H(V\mid C)$ déduite d'une majoration | Hypothèse 4′ explicite, $H(V\mid C)\ge\theta_q\alpha_q H(C)=\gamma_q\ge 1$ | `ass:verdict_quantique`, `rem:statut_verdict_quantique`, §2.4.3 |
| Régime de fuite | Remarque 17, validité affirmée pour $I\in[0,\lambda]$ | Hypothèse 6 explicite, $\chi_{\max}\le\kappa/\lambda$, nécessaire (cas limite) | `ass:regime_quantique`, `rem:scope_trilemme_pq`, §2.4.3 et §2.4.4 |
| Théorème 2 | Hypothèse 5 et constante $C(\beta_q,\alpha_q)$ | Preuve complète à constantes explicites, Hypothèse 5 abandonnée | `thm:trilemme_pq`, §2.4.4 |
| Tableaux 8 à 10, étude Dilithium-3 | Capacités implicites lues comme conséquences du théorème | Calibration illustrative sur l'échelle CLO | `subsec:analyse_coherence_pq`, §2.4.6 |

### Apports propres à la thèse, absents du document soumis

| Point | Dans la thèse | Référence thèse |
|---|---|---|
| Définition de $\eta_q$ | Une seule définition, comme perte, $I(V;\Lambda(\Sigma)\mid C)\ge I(V;\Sigma\mid C)-\eta_q H(C)$ ; $\eta_q=0$ pour toute preuve qui est une chaîne de bits (ML-DSA, SLH-DSA, Falcon) | `def:perte_interp_quantique_pq`, `rem:interpretation_physique_pq`, §2.4.2.3 |
| Constante de régularité | Renommée $\zeta_q$, distincte de $\eta_q$ | `ass:regularite_quantique`, §2.4.3 |
| $D_{\max}$ | Non négligeable pour les signatures NIST PQC (plus de $2{,}6\cdot10^4$ bits pour ML-DSA-65) ; la confidentialité de ces schémas relève du lemme classique | `rem:interp_lemme7`, §2.4.4 |
| Forme raffinée quantique et seuil $H^\sharp_q$ | $\frac{1+\kappa/\lambda}{\lambda}\min\{1,\frac{\kappa/\lambda+\Delta_q}{\gamma_q}\}$, $H^\sharp_q=(\Delta_q+\kappa/\lambda)/(\theta_q\alpha_q)$, où $\eta_q$ n'intervient pas | `rem:forme_raffinee_pq`, §2.4.4 et §2.4.5 |
| Paramètres de référence | ML-DSA-65 en contexte contractuel, $\Delta_q=28$ bits comme hypothèse de travail, $\eta_q=0$ | `tab:parametres_reference`, §4.1.3 |

La remarque sur $D_{\max}$ va plus loin que le document soumis, qui pose encore $D_{\max}=\mathrm{negl}(\lambda)$ pour ces schémas et note $\eta_q$ la constante de régularité du Lemme 7.
