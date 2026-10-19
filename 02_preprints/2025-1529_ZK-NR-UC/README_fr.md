# ePrint 2025/1529 — ZK-NR UC (v3)

> **Statut : PRÉPRINT (non évalué par les pairs)** · Source : Cryptology ePrint Archive, rapport 2025/1529

[English version](README_en.md)

## Référence

| Champ | Valeur |
|---|---|
| Titre | UC-Security of the ZK-NR Protocol under Contextual Entropy Constraints: A Composable Zero-Knowledge Attestation Framework |
| Auteurs | T. E. Minka Mi Nguidjoï |
| Archive | Cryptology ePrint Archive, Report 2025/1529 |
| Lien | <https://eprint.iacr.org/2025/1529> |
| Reçu / approuvé | 2025-08-26 / 2025-08-30 |
| Catégorie ePrint | Protocoles cryptographiques |
| Mots-clés | Universal Composability, ZK proofs, PQ cryptography, CRO trilemma, non-repudiation, contextual entropy |
| Licence affichée sur ePrint | CC BY 4.0 (relevée le 2026-10-12) |
| Entrée BibTeX | [CITATION.bib](CITATION.bib) (clé `MINKA2025ZKNR_UC`, reprise de la bibliographie de la thèse) |

Ce document est un préprint déposé sur l'archive ePrint de l'IACR. Il n'a pas fait l'objet d'une évaluation par les pairs et ses résultats ne doivent pas être cités comme validés.

## Résumé

Paraphrase fidèle du résumé officiel publié sur la page ePrint (consultée le 2026-10-12). Le texte original fait foi et se lit à l'adresse <https://eprint.iacr.org/2025/1529>.

Le Trilemme CRO décrit le conflit entre confidentialité, fiabilité et opposabilité juridique dans les systèmes de preuve. L'article donne une preuve complète de sécurité dans le cadre de la composabilité universelle (UC) pour le protocole ZK-NR, conception à couches destinée à approcher la limite du trilemme. Chacune des trois couches (Iron, Gold, Clay) est modélisée comme une fonctionnalité idéale munie d'une sémantique d'effacement. L'auteur prouve l'indistinguabilité des exécutions réelle et idéale sous hypothèses post-quantiques. Il en conclut que ZK-NR est sûr au sens composable et atteint formellement un indice CRO $\Gamma_\text{CRO} < 0{,}4 + \mathrm{negl}(\lambda)$ face à des adversaires contextuels adaptatifs. La page précise que l'article est théorique, sans détail d'implémentation ni mesure de performance. Il est présenté comme le deuxième d'une série de quatre.

## Rôle dans la thèse

Troisième stade de la série ZK-NR dans l'Axe II des perspectives ([chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). La thèse le désigne comme ZK-NR v3. Il établit la preuve UC complète pour les trois couches, modélisées comme fonctionnalités idéales avec sémantique d'effacement, ainsi que l'indistinguabilité réel/idéal sous hypothèses post-quantiques. Le programme à court terme du chapitre 5 prévoit d'exhiber la réduction UC entre SOTP-High et ZK-NR v3, ce qui relierait formellement la théorie abstraite de SOTP à une instanciation composable. La limite L3 ([chap5/discussions.tex](../../00_these/manuscrit/chap5/discussions.tex)) le range parmi les prépublications développant les jeux cryptographiques non encore publiés dans une revue.

## Réserves formulées dans la thèse

L'indice $\Gamma_\text{CRO}$ n'est pas défini dans le cadre de la thèse. Les valeurs chiffrées qu'en donne le préprint ne sont donc pas reprises comme résultats. Relier cet indice au produit $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}$ est une question ouverte (chapitre 5, Perspectives, Axe II).

## PDF et licence

Le PDF n'est pas joint à ce dossier. Il est disponible sur ePrint à l'adresse <https://eprint.iacr.org/2025/1529>. La page ePrint affiche la licence Creative Commons Attribution 4.0 (CC BY 4.0), qui autorise la redistribution avec attribution. Le PDF pourra donc être joint ultérieurement, accompagné de la mention d'attribution requise.
