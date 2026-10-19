# P1 — Cadre CLO (IEEE Access, 2026)

> **Statut : PUBLIÉ** · Source : *IEEE Access*, vol. 14, pp. 20427–20445, 2026, DOI [10.1109/ACCESS.2026.3660105](https://doi.org/10.1109/ACCESS.2026.3660105) · Thèse, chapitre 2, §2.2

[English version](README_en.md)

## Référence

T. E. MINKA MI NGUIDJOÏ, F. S. MANI ONANA, T. DJOTIO NDIÉ, « Cryptographic Legal Opposability (CLO) Framework: Confidentiality-Reliability-Opposability Trade-Offs in Institutional Cryptography », *IEEE Access*, vol. 14, pp. 20427–20445, 2026. Reçu le 4 décembre 2025, accepté le 21 janvier 2026, publié le 2 février 2026. Entrée BibTeX dans [`CITATION.bib`](CITATION.bib).

## Fichiers

| Fichier | Contenu |
|---|---|
| [`article.pdf`](article.pdf) | Version publiée par l'éditeur (19 pages) |
| [`source/Final_CLO_Framework.tex`](source/Final_CLO_Framework.tex) | Source LaTeX de la version finale soumise |
| [`CITATION.bib`](CITATION.bib) | Référence bibliographique |

## Licence

L'article est publié en accès ouvert par l'IEEE sous licence Creative Commons Attribution 4.0 (CC BY 4.0), avec la mention « © 2026 The Authors ». Sa redistribution ici est permise sous réserve de citer la référence ci-dessus.

## Résumé

L'article part d'une tension observée dans les systèmes de preuve cryptographique, où une sécurité accrue s'accompagne souvent d'une opacité accrue pour les institutions qui doivent décider. Il propose le cadre Cryptographic Legal Opposability (CLO), qui définit trois mesures information-théoriques. La confidentialité $\mathrm{Conf}$ et la fiabilité $\mathrm{Rel}$ y côtoient l'opposabilité $\mathrm{Opp}$, mesure nouvelle de la part de l'incertitude du verdict institutionnel que la preuve permet de lever. L'article établit des bornes sur ces mesures et des contraintes de faisabilité, dont un théorème de goulot contextuel où l'entropie du contexte $H(C)$ apparaît comme facteur limitant. Il présente la construction Semantic One-Time Pad (S-OTP) en trois couches (Gold, Iron, Clay) et des règles de composition. Des études de cas théoriques de systèmes déployés (Helios, zk-SNARKs, ECDSA) situent leurs produits $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}$ entre 0,27 et 0,57. L'établissement de bornes d'impossibilité générales y est laissé comme problème ouvert.

## Place dans la thèse

L'article fonde la contribution **C1** de la thèse (cadre CLO, chapitre 2, §2.2 « Le cadre CLO : formalisation des mesures »). Le problème ouvert qu'il formule est traité par P2 (contribution C2).

## Ce que la thèse précise

La thèse ne réécrit pas l'article. Elle en reprend le cadre et apporte les précisions suivantes, signalées dans le manuscrit par des remarques explicites. Le détail énoncé par énoncé figure dans [`../../03_resultats_these/resultats_these_fr.md`](../../03_resultats_these/resultats_these_fr.md). Aucun document de formulations précisées n'accompagne P1 dans ce dépôt.

| Point | Dans l'article | Dans la thèse | Référence thèse |
|---|---|---|---|
| Fiabilité | Fiabilité opérationnelle de vérification | Distinction entre $\mathrm{Rel}_{\mathrm{rec}}$ (reconstruction, contrôlée par Fano) et $\mathrm{Rel}_{\mathrm{ver}}$ (complétude et solidité de la vérification) | `def:fiabilite_clo`, `rem:rel_ver`, §2.2.2.2 |
| Goulot contextuel | $I(V;\Sigma\mid C)\le\min\{H(\Sigma\mid C),H(V\mid C)\}$, extraction plafonnée par $H(C)$ | Plafond $\alpha H(C)$ fixé par la granularité des verdicts | `thm:goulot_contexte` (Théorème 2.2), §2.2.3 |
| Interprétation | Verdict fonction déterministe de $(\Sigma,C)$ | Un verdict déterministe donne $\mathrm{Opp}=1$ pour tout protocole ; le cadre retient des interprétations admissibles | `rem:verdict_deterministe` (Remarque 2.4), `def:interp_admissible`, §2.2.3 et §2.3.1.2 |
| Composition | Minorations par produits en séquentiel, $\mathrm{Opp}\ge\min$ en séquentiel et $\mathrm{Opp}\approx$ produit en parallèle | Règles réécrites pour le post-traitement et la publication conjointe ; les règles d'opposabilité de l'article sont traitées comme des heuristiques | `thm:composition_sequentielle` (Théorème 2.3), `rem:composition_opp`, §2.2.3 |
| Optimalité de S-OTP | Théorème d'optimalité dans la classe OTP | Argument heuristique, la preuve d'optimalité restant ouverte | `thm:optimalite_sotp` (Remarque 3.3), §3.2 |
| Études de cas | Produits 0,27 à 0,57 rapprochés des compromis CRO | Valeurs exprimées sur l'échelle opérationnelle ($\mathrm{Rel}_{\mathrm{ver}}$), utilisées comme calibration illustrative | `rem:portee_cas_etude` (Remarque 2.19), §2.3.3 |
