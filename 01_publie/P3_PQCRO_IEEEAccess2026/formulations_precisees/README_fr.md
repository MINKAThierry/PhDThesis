# Formulations précisées proposées pour P3

> **Statut : PROPOSITION: formulations précisées soumises (non publiées)** · Source : document soumis à *IEEE Access* pour l'article DOI [10.1109/ACCESS.2026.3722742](https://doi.org/10.1109/ACCESS.2026.3722742) · Thèse, chapitre 2, §2.4 et chapitre 3, §3.4.9

[English version](README_en.md)

Ce dossier contient le document que les auteurs ont soumis à l'éditeur pour l'article « Post-Quantum Extension of the Conditional CRO Trilemma ». Il présente des formulations plus précises de plusieurs énoncés. Il n'a pas été publié à ce jour. Tant que l'éditeur ne l'a pas accepté, la version publiée de l'article reste la référence bibliographique et le texte ci-dessous n'a que la valeur d'une proposition des auteurs.

| Fichier | Contenu |
|---|---|
| [`Correction_PQ_CRO_Trilemma.tex`](Correction_PQ_CRO_Trilemma.tex) | Source LaTeX (classe `article` standard, compilable partout ; à reporter dans le gabarit de l'éditeur pour la soumission) |
| [`Correction_PQ_CRO_Trilemma.pdf`](Correction_PQ_CRO_Trilemma.pdf) | PDF compilé avec pdfLaTeX (4 pages) |

Le texte est en anglais, langue de l'article. Il n'est pas traduit.

## Contenu du document

La preuve du Théorème 2 reprend les points précisés pour le trilemme classique (voir [`../../P2_CRO_IEEEAccess2026/formulations_precisees/`](../../P2_CRO_IEEEAccess2026/formulations_precisees/)). Le document, parallèle à celui de P2, comporte quatre volets.

1. La formulation se passe du Lemme 6, car deux messages encodés dans des états orthogonaux constituent un cas limite pour l'inégalité (68). Elle se passe aussi de la majoration (72) du Lemme 7, qui en dépend. La minoration (71) est réénoncée avec l'information de Holevo $\chi_{\max}$ au lieu de l'information accessible.
2. La condition d'efficacité du verdict devient l'Hypothèse 4′ explicite, $H(V\mid C)\ge\theta_q\alpha_q H(C)=:\gamma_q\ge 1$.
3. Le régime de fuite $\chi_{\max}\le\kappa/\lambda$ devient l'Hypothèse 6. Le Théorème 2 reçoit une preuve complète à constantes explicites,
$$\mathrm{Conf}^q\cdot\mathrm{Rel}^q\cdot\mathrm{Opp}^q\le\frac{1}{\gamma_q}\left(\frac{\Delta_q}{\lambda}+\frac{\kappa(\Delta_q+1)}{\lambda^2}+\frac{\kappa^2}{\lambda^3}\right)\le\frac{\Delta_q+\eta_q H(C)}{\lambda}+O(\lambda^{-2})+\mathrm{negl}(\lambda).$$
L'Hypothèse 5 et la constante $C(\beta_q,\alpha_q)$ ne sont plus nécessaires. La Remarque 17 est reformulée, car le régime $I=\Theta(\lambda)$ s'écarte de celui où la borne est établie.
4. Les capacités implicites des tableaux 8 à 10, l'étude de cas Dilithium-3 et le point 2 de la Remarque 10 se lisent comme une calibration empirique de $\Delta_q$ sur l'échelle CLO, indépendante du Théorème 2.

Le modèle institutionnel quantique (Hypothèses 1 à 3), les paramètres $(\Delta_q,\alpha_q,\beta_q,\eta_q)$, l'étape de Fano quantique et la forme de la borne principale sont conservés dans le régime indiqué.

## Lien avec la thèse

La thèse intègre ces formulations au §2.4 et les retrace au §3.4.9. Sur deux points, elle va plus loin que le document soumis.

- Elle donne à $\eta_q$ une définition unique de perte d'interprétabilité. Elle renomme $\zeta_q$ la constante de régularité que le document soumis note encore $\eta_q$ dans le Lemme 7.
- Elle établit que $D_{\max}$ n'est pas négligeable pour les signatures NIST PQC (plus de $2{,}6\cdot10^4$ bits pour ML-DSA-65), alors que le document soumis pose $D_{\max}=\mathrm{negl}(\lambda)$ pour ces schémas.

Ces écarts sont recensés dans [`../README_fr.md`](../README_fr.md) et [`../../../03_resultats_these/resultats_these_fr.md`](../../../03_resultats_these/resultats_these_fr.md).

## Recompiler

```bash
pdflatex Correction_PQ_CRO_Trilemma.tex
pdflatex Correction_PQ_CRO_Trilemma.tex
```
