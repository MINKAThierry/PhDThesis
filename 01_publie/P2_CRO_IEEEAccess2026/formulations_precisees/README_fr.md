# Formulations précisées proposées pour P2

> **Statut : PROPOSITION — formulations précisées soumises (non publiées)** · Source : document soumis à *IEEE Access* pour l'article DOI [10.1109/ACCESS.2026.3669065](https://doi.org/10.1109/ACCESS.2026.3669065) · Thèse, chapitre 2, §2.3 et chapitre 3, §3.4.9

[English version](README_en.md)

Ce dossier contient le document que les auteurs ont soumis à l'éditeur pour l'article « The Conditional CRO Trilemma ». Il présente des formulations plus précises de plusieurs énoncés. Il n'a pas été publié à ce jour. Tant que l'éditeur ne l'a pas accepté, la version publiée de l'article reste la référence bibliographique et le texte ci-dessous n'a que la valeur d'une proposition des auteurs.

| Fichier | Contenu |
|---|---|
| [`Correction_CRO_Trilemma.tex`](Correction_CRO_Trilemma.tex) | Source LaTeX (classe `article` standard, compilable partout ; à reporter dans le gabarit de l'éditeur pour la soumission) |
| [`Correction_CRO_Trilemma.pdf`](Correction_CRO_Trilemma.pdf) | PDF compilé avec pdfLaTeX (4 pages) |

Le texte est en anglais, langue de l'article. Il n'est pas traduit.

## Contenu du document

La formalisation des résultats en Lean 4 a mis en évidence les points que ce document précise. Il comporte quatre volets.

1. Le Lemme 4 est réénoncé dans la forme que sa preuve établit, une minoration $\mathrm{Conf}\ge 1-\sqrt{c_0\beta\, I(M;\Sigma\mid C)}$ au lieu d'une majoration. La constante $c_0=1/(2\ln 2)$ reste valide sans être serrée.
2. La condition d'efficacité du verdict utilisée à l'étape 3 devient l'Hypothèse 2′ explicite, $H(V\mid C)\ge\alpha H(C)-1=:\gamma\ge 1$.
3. Le régime de fuite $I(M;\Sigma\mid C)\le\kappa/\lambda$, que la formulation initiale tirait d'une optimisation, devient l'Hypothèse 4, la résolution alternative de cette optimisation ne produisant pas ce régime. Le Théorème 1 reçoit une preuve complète à constantes explicites,
$$\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}\le\frac{1}{\gamma}\left(\frac{\Delta}{\lambda}+\frac{\kappa(\Delta+1)}{\lambda^2}+\frac{\kappa^2}{\lambda^3}\right)\le\frac{\Delta}{\lambda}+O(\lambda^{-2}).$$
Un cas limite montre que l'Hypothèse 4 est nécessaire.
4. La Remarque 10 et la section VI-B sont précisées. Les capacités implicites du tableau 2 se lisent comme une calibration empirique de $\Delta$ sur l'échelle CLO, indépendante du Théorème 1.

Le modèle institutionnel (Hypothèses 1 à 3), le rôle des paramètres $(\Delta,\alpha,\beta)$ et la forme de la borne principale sont conservés dans le régime indiqué.

## Lien avec la thèse

La thèse intègre ces formulations au §2.3 et les retrace au §3.4.9 (« Ce que la formalisation a révélé »). Elle va au-delà de ce document sur plusieurs points (interprète admissible, proposition de fondement de l'Hypothèse 1, forme raffinée et seuil $H^\sharp$), recensés dans [`../README_fr.md`](../README_fr.md) et [`../../../03_resultats_these/resultats_these_fr.md`](../../../03_resultats_these/resultats_these_fr.md). Le script qui établit numériquement le cas limite du Théorème 1 dans sa formulation initiale se trouve dans [`../../../05_formalisation_lean/cas_limite/`](../../../05_formalisation_lean/cas_limite/).

## Recompiler

```bash
pdflatex Correction_CRO_Trilemma.tex
pdflatex Correction_CRO_Trilemma.tex
```
