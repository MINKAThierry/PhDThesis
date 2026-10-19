# ePrint 2025/1708 - SH

> **Statut : PRÉPRINT (non évalué par les pairs)** · Source : Cryptology ePrint Archive, rapport 2025/1708

[English version](README_en.md)

## Référence

| Champ | Valeur |
|---|---|
| Titre | The Semantic Holder (SH): Algebraic Extraction for Legal Opposability |
| Auteurs | T. E. Minka Mi Nguidjoï |
| Archive | Cryptology ePrint Archive, Report 2025/1708 |
| Lien | <https://eprint.iacr.org/2025/1708> |
| Reçu / approuvé | 2025-09-20 / 2025-09-21 |
| Catégorie ePrint | Fondements |
| Mots-clés | Semantic Holder, CASH framework, legal opposability, AIIP problem, STARK proofs, verifiable computation, PQ cryptography |
| Licence affichée sur ePrint | CC BY 4.0 (relevée le 2026-10-12) |
| Entrée BibTeX | [CITATION.bib](CITATION.bib) (clé `MINKA2025SH`, reprise de la bibliographie de la thèse) |

Ce document est un préprint déposé sur l'archive ePrint de l'IACR. Il n'a pas fait l'objet d'une évaluation par les pairs et ses résultats ne doivent pas être cités comme validés.

## Résumé

Paraphrase fidèle du résumé officiel publié sur la page ePrint (consultée le 2026-10-12). Le texte original fait foi et se lit à l'adresse <https://eprint.iacr.org/2025/1708>.

L'article introduit le Semantic Holder (SH), composante d'opposabilité de la boîte à outils CASH (Chaotic Affine Secure Hash), qui complète la mise en œuvre de la démarche Q2CSI par ce cadre. SH produit des interprétations juridiquement opposables par extraction algébrique d'information à partir des traces d'itération polynomiale. Il fonctionne aux côtés de CEE (confidentialité) et d'AOW (fiabilité). Fondé sur le problème AIIP, SH fournit des interprétations juridiques vérifiables mathématiquement avec des bornes minimales d'opposabilité garanties. L'auteur établit un score d'opposabilité $\Omega \geq 0{,}60$, étayé par des garanties de préservation de l'entropie, d'explicabilité institutionnelle et de contestabilité juridique. SH permet un calcul vérifiable efficace fondé sur STARK ainsi qu'une compatibilité entre juridictions. Sa résistance quantique découle de sa réduction à la difficulté d'AIIP. Les applications couvertes sont les contrats intelligents juridiques, l'audit de conformité réglementaire et l'authentification de la preuve numérique, avec des recommandations de paramètres pour les niveaux de sécurité usuels. Le travail vise des systèmes cryptographiques soumis à des contraintes juridiques, avec une opposabilité transparente et vérifiable sans sacrifice de sécurité ni de performance.

## Rôle dans la thèse

Couche opposabilité ($\mathrm{Opp}$) du CASH Toolkit dans l'Axe I des perspectives ([chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). La thèse retient l'extraction algébrique depuis les traces de polynômes itérés pour produire des interprétations juridiquement opposables ainsi que les trois propriétés visées (préservation entropique, explicabilité institutionnelle, contestabilité juridique vérifiable par STARK). Elle pose comme question ouverte la définition d'un score d'opposabilité pour SH qui soit relié à $\mathrm{Opp}$.

## Réserves formulées dans la thèse

Le score agrégé $\Omega$ et la valeur $\Omega \geq 0{,}60$ avancés dans le préprint ne sont pas définis dans le cadre de la thèse. Ils n'y sont pas repris comme résultats. La sécurité de cette primitive est réduite à AIIP (ePrint 2025/1590). Les réserves que la thèse formule sur AIIP s'appliquent donc par héritage, en particulier l'objection de l'inversion par extractions de racines successives (voir [2025-1590_AIIP](../2025-1590_AIIP/README_fr.md)).

## PDF et licence

Le PDF n'est pas joint à ce dossier. Il est disponible sur ePrint à l'adresse <https://eprint.iacr.org/2025/1708>. La page ePrint affiche la licence Creative Commons Attribution 4.0 (CC BY 4.0), qui autorise la redistribution avec attribution. Le PDF pourra donc être joint ultérieurement, accompagné de la mention d'attribution requise.
