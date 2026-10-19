# ePrint 2025/1662 — AOW

> **Statut : PRÉPRINT (non évalué par les pairs)** · Source : Cryptology ePrint Archive, rapport 2025/1662

[English version](README_en.md)

## Référence

| Champ | Valeur |
|---|---|
| Titre | The Affine One-Wayness (AOW): A Transparent Post-Quantum Temporal Verification via Polynomial Iteration |
| Auteurs | T. E. Minka Mi Nguidjoï |
| Archive | Cryptology ePrint Archive, Report 2025/1662 |
| Lien | <https://eprint.iacr.org/2025/1662> |
| Reçu / approuvé | 2025-09-13 / 2025-09-17 |
| Catégorie ePrint | Fondements |
| Mots-clés | AOW, The AIIP, Verifiable Delay Functions (VDF), Distributed Synchronization, STARK, Byzantine Fault Tolerance, ZK Proof |
| Licence affichée sur ePrint | CC BY 4.0 (relevée le 2026-10-12) |
| Entrée BibTeX | [CITATION.bib](CITATION.bib) (clé `MINKA2025AOW`, reprise de la bibliographie de la thèse) |

Ce document est un préprint déposé sur l'archive ePrint de l'IACR. Il n'a pas fait l'objet d'une évaluation par les pairs et ses résultats ne doivent pas être cités comme validés.

## Résumé

Paraphrase fidèle du résumé officiel publié sur la page ePrint (consultée le 2026-10-12). Le texte original fait foi et se lit à l'adresse <https://eprint.iacr.org/2025/1662>.

Les systèmes distribués ont besoin de moyens transparents pour vérifier l'ordre des événements sans recourir à des autorités de confiance ni à des horloges synchronisées. L'article introduit l'Affine One-Wayness (AOW), primitive cryptographique de vérification temporelle post-quantique fondée sur l'évaluation itérée de polynômes sur des corps finis. La sécurité d'AOW est réduite de façon serrée à la difficulté du logarithme discret sur les courbes hyperelliptiques de grand genre (HCDLP). Elle est aussi réduite au problème AIIP, qui mobilise l'algèbre quadratique multivariée et l'arithmétique des courbes hyperelliptiques de grand genre. La construction utilise une mise en place transparente. L'auteur revendique une sécurité formelle face aux adversaires classiques comme quantiques. AOW s'intègre efficacement aux systèmes de preuve STARK pour une vérification à divulgation nulle du calcul séquentiel, avec un passage à l'échelle logarithmique. AOW constitue la composante de fiabilité du cadre CASH (Chaotic Affine Secure Hash). Elle vise l'ordonnancement d'événements résistant aux fautes byzantines et la synchronisation distribuée, sous des hypothèses cryptographiques standard.

## Rôle dans la thèse

Couche fiabilité ($\mathrm{Rel}$) du CASH Toolkit dans l'Axe I des perspectives ([chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). La thèse retient la vérification temporelle par évaluation polynomiale itérée et l'intégration STARK à mise à l'échelle logarithmique. La traçabilité temporelle produite par AOW, ancrage de séquences vérifiables sans autorité de confiance, alimente directement $\mathrm{Opp}$ puisque l'institution peut établir quand une preuve a été générée.

## Réserves formulées dans la thèse

La thèse ne formule pas de réserve propre à AOW. Elle rappelle que sa sécurité est réduite dans le préprint à HCDLP et à AIIP, « dont le statut est discuté ». La sécurité de cette primitive est réduite à AIIP (ePrint 2025/1590). Les réserves que la thèse formule sur AIIP s'appliquent donc par héritage, en particulier l'objection de l'inversion par extractions de racines successives (voir [2025-1590_AIIP](../2025-1590_AIIP/README_fr.md)). Les preuves actuelles du toolkit opèrent dans le modèle de l'oracle aléatoire.

## PDF et licence

Le PDF n'est pas joint à ce dossier. Il est disponible sur ePrint à l'adresse <https://eprint.iacr.org/2025/1662>. La page ePrint affiche la licence Creative Commons Attribution 4.0 (CC BY 4.0), qui autorise la redistribution avec attribution. Le PDF pourra donc être joint ultérieurement, accompagné de la mention d'attribution requise.
