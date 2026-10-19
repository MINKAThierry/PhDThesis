# P2: Trilemme CRO conditionnel (IEEE Access, 2026)

> **Statut : PUBLIÉ** · Source : *IEEE Access*, vol. 14, pp. 33263–33274, 2026, DOI [10.1109/ACCESS.2026.3669065](https://doi.org/10.1109/ACCESS.2026.3669065) · Thèse, chapitre 2, §2.3

[English version](README_en.md)

## Référence

T. E. MINKA MI NGUIDJOÏ, F. S. MANI ONANA, T. DJOTIO NDIÉ, « The Conditional CRO Trilemma: Impossibility Bounds on Confidentiality, Reliability, and Opposability Under Institutional Extraction Limits », *IEEE Access*, vol. 14, pp. 33263–33274, 2026. Reçu le 6 février 2026, accepté le 22 février 2026, publié le 27 février 2026. Entrée BibTeX dans [`CITATION.bib`](CITATION.bib).

## Fichiers

| Fichier | Contenu |
|---|---|
| [`article.pdf`](article.pdf) | Version publiée par l'éditeur (12 pages) |
| [`source/Final_Conditional_CRO_Trilemma.tex`](source/Final_Conditional_CRO_Trilemma.tex) | Source LaTeX de la version finale soumise |
| [`CITATION.bib`](CITATION.bib) | Référence bibliographique |
| [`formulations_precisees/`](formulations_precisees/) | Formulations précisées soumises à l'éditeur, non publiées (statut PROPOSITION) |

## Licence

L'article est publié en accès ouvert par l'IEEE sous licence Creative Commons Attribution 4.0 (CC BY 4.0), avec la mention « © 2026 The Authors ». Sa redistribution ici est permise sous réserve de citer la référence ci-dessus.

## Résumé

L'article répond au problème ouvert laissé par le cadre CLO, celui d'une explication théorique des compromis observés entre confidentialité, fiabilité et opposabilité. Il introduit un modèle formel muni de paramètres institutionnels, la capacité d'extraction $\Delta$, la granularité des verdicts $\alpha$ et la régularité $\beta$. Sous des hypothèses explicites sur les limites cognitives des institutions, il énonce le Trilemme CRO conditionnel, $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}\le\Delta/\lambda+O(\lambda^{-2})+\mathrm{negl}(\lambda)$, où $\lambda$ est le paramètre de sécurité. La preuve combine les inégalités de Pinsker et de Fano. L'article infère ensuite, à partir des systèmes déployés, des capacités implicites de 35 à 73 bits, qu'il rapproche de la rationalité limitée. Il propose enfin un cadre d'appariement entre protocoles et capacités institutionnelles, ainsi que des pistes de validation.

## Place dans la thèse

L'article fonde la contribution **C2** de la thèse (Trilemme CRO conditionnel classique, chapitre 2, §2.3). La thèse présente une version de la preuve qui diffère de la version publiée (`rem:version_preuve_classique`, §2.3.2) . La formalisation Lean a conduit à ces formulations alternatives (§3.4.9, `subsec:lean4_erreurs`).

## Ce que la thèse précise

La thèse conserve le modèle institutionnel, le rôle de $(\Delta,\alpha,\beta)$ et la forme de la borne principale dans le régime où elle est établie. Le détail énoncé par énoncé figure dans [`../../03_resultats_these/resultats_these_fr.md`](../../03_resultats_these/resultats_these_fr.md).

### Points communs avec les formulations précisées soumises ([`formulations_precisees/`](formulations_precisees/))

| Point | Dans l'article | Dans la thèse | Référence thèse |
|---|---|---|---|
| Lemme 4 | Majoration de $\mathrm{Conf}$, normalisée par $\lambda$ | Minoration $\mathrm{Conf}\ge 1-\sqrt{c_0\beta\, I(M;\Sigma\mid C)}$ | `lem:confidentiality_guarantee`, §2.3.2 |
| Hypothèse 2 | Majoration de l'espace des verdicts utilisée comme minoration de $H(V\mid C)$ | Hypothèse 2′ de verdict efficace, $H(V\mid C)\ge\gamma=\alpha H(C)-1\ge 1$, posée explicitement | `ass:verdicts_efficace`, `rem:statut_verdict_efficace`, §2.3.1.2 |
| Régime $I=O(1/\lambda)$ | Déduit d'une optimisation dont la résolution alternative ne produit pas ce régime | Hypothèse 4 explicite, $I(M;\Sigma\mid C)\le\kappa/\lambda$ | `ass:regime`, `rem:statut_regime`, §2.3.1.2 |
| Théorème 1 | Preuve en six étapes | Preuve complète à constantes explicites, $\frac{1}{\gamma}\bigl(\frac{\Delta}{\lambda}+\frac{\kappa(\Delta+1)}{\lambda^2}+\frac{\kappa^2}{\lambda^3}\bigr)$ | `thm:trilemme_cro_conditionnel`, §2.3.2 |
| Remarque 10 | Borne valable sans restriction sur la fuite | Hypothèse 4 nécessaire, établie par un cas limite | `rem:scope_trilemme_classique`, §2.3.2 |
| Constante $c_0$ | Qualifiée de serrée | Valide, sans être serrée | `rem:constante_c0`, §2.3.2 |
| Tableau 2 | Capacités implicites lues comme conséquences du théorème | Calibration illustrative sur l'échelle CLO | `rem:portee_cas_etude`, `tab:validation_cro_classique`, §2.3.3 et §2.3.5 |

### Apports propres à la thèse, absents du document soumis

| Point | Dans la thèse | Référence thèse |
|---|---|---|
| Interprète admissible et fondement de l'Hypothèse 1 | $I(V;\Sigma\mid C)=I(V;M\mid C)+I(V;\Sigma\mid M,C)$ ; $\Delta$ majore l'information tirée de la preuve au-delà du message | `def:interp_admissible`, `prop:fondement_extraction`, §2.3.1.2 |
| Forme raffinée et seuil $H^\sharp$ | $\frac{1+\kappa/\lambda}{\lambda}\min\{1,\frac{\kappa/\lambda+\Delta}{\gamma}\}$, régimes à contexte rare et riche | `eq:trilemme_cro_raffine`, `rem:activite_delta`, §2.3.2 et §2.3.4 |
| Fiabilité | Le théorème porte sur $\mathrm{Rel}_{\mathrm{rec}}$ | `rem:rel_ver`, §2.2.2.2 |
| Certification | Noyau algébrique certifié en Lean 4 | §3.4, [`../../05_formalisation_lean/`](../../05_formalisation_lean/) |
