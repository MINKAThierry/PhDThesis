# ePrint 2025/1422 - Design ZK-NR

> **Statut : PRÉPRINT (non évalué par les pairs)** · Source : Cryptology ePrint Archive, rapport 2025/1422

[English version](README_en.md)

## Référence

| Champ | Valeur |
|---|---|
| Titre | Design ZK-NR: A Post-Quantum Layered Protocol for Legally Explainable Zero-Knowledge Non-Repudiation Attestation |
| Auteurs | T. E. Minka Mi Nguidjoï, F. S. Mani Onana, T. Djotio Ndié, R. Atsa Etoundi |
| Archive | Cryptology ePrint Archive, Report 2025/1422 |
| Lien | <https://eprint.iacr.org/2025/1422> |
| Reçu / approuvé | 2025-08-05 / 2025-08-07 |
| Catégorie ePrint | Protocoles cryptographiques |
| Mots-clés | ZK-NR, Q2CSI, CRO Trilemma, P-Q Cryptography, UC, Contextual Attestation, Legal Explainability, Dialectical Layering |
| Licence affichée sur ePrint | CC BY 4.0 (relevée le 2026-10-12) |
| Entrée BibTeX | [CITATION.bib](CITATION.bib) (clé `MINKA2025ZKNR_Design`, reprise de la bibliographie de la thèse) |

Ce document est un préprint déposé sur l'archive ePrint de l'IACR. Il n'a pas fait l'objet d'une évaluation par les pairs et ses résultats ne doivent pas être cités comme validés.

## Résumé

Paraphrase fidèle du résumé officiel publié sur la page ePrint (consultée le 2026-10-12). Le texte original fait foi et se lit à l'adresse <https://eprint.iacr.org/2025/1422>.

L'article présente la conception architecturale de ZK-NR, protocole cryptographique à couches pour des attestations sûres face aux adversaires quantiques, juridiquement interprétables et non répudiables de manière vérifiable. Il repose sur trois composants, des preuves à divulgation nulle de type STARK, des signatures post-quantiques hybrides et un ancrage sur registre qui accumule l'entropie. ZK-NR satisfait les exigences structurelles de deux modèles existants, le cadre Q2CSI et le modèle NIZK-E. L'interprétabilité sémantique est obtenue en maintenant une séparation structurelle entre preuves contextuelles et explications bornées. La correction cryptographique est visée dans le cadre de la composabilité universelle (UC), les preuves UC formelles étant renvoyées à un article ultérieur de la série (A.2). Cet article, premier de la série, ne traite que de l'architecture et du fonctionnement. Les suivants aborderont les fondements mathématiques, les stratégies d'implémentation et la validation opérationnelle avec des outils de vérification formelle. Le manuscrit s'inscrit dans un programme de recherche sur l'explicabilité juridique des protocoles post-quantiques. Il instancie le cadre générique Q2CSI (2025/1380), lui-même fondé sur le Trilemme CRO (2025/1348). ZK-NR répartit les trois garanties sur des couches sémantiquement séparées (Iron, Gold, Clay) dans une architecture modulaire conforme au modèle UC. Le travail est purement théorique, sans artefact d'implémentation, mesure de performance ni revendication expérimentale.

## Rôle dans la thèse

Deuxième stade de la série ZK-NR dans l'Axe II des perspectives ([chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). La thèse le désigne comme ZK-NR v2. Il construit l'architecture complète satisfaisant les propriétés Q2CSI et le modèle NIZK-E avec séparation structurelle entre preuves contextuelles et explications bornées.

## Réserves formulées dans la thèse

La thèse ne formule pas de réserve propre à ce préprint. Une différence de formulation mérite toutefois d'être relevée. La thèse écrit que la compatibilité UC y est « prouvée symboliquement » alors que le résumé ePrint indique que les preuves UC formelles sont renvoyées à un article ultérieur de la série (2025/1529). L'indice $\Gamma_\text{CRO}$ utilisé dans la série (Q2CSI, ZK-NR v3) n'est pas défini dans le cadre de la thèse.

## PDF et licence

Le PDF n'est pas joint à ce dossier. Il est disponible sur ePrint à l'adresse <https://eprint.iacr.org/2025/1422>. La page ePrint affiche la licence Creative Commons Attribution 4.0 (CC BY 4.0), qui autorise la redistribution avec attribution. Le PDF pourra donc être joint ultérieurement, accompagné de la mention d'attribution requise.
