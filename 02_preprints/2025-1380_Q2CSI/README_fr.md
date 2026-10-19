# ePrint 2025/1380 - Q2CSI

> **Statut : PRÉPRINT (non évalué par les pairs)** · Source : Cryptology ePrint Archive, rapport 2025/1380

[English version](README_en.md)

## Référence

| Champ | Valeur |
|---|---|
| Titre | Quantum Composable and Contextual Security Infrastructure (Q2CSI): A Modular Architecture for Legally Explainable Cryptographic Signatures |
| Auteurs | T. E. Minka Mi Nguidjoï, F. S. Mani Onana, T. Djotio Ndié, T. Bouetou Bouetou |
| Archive | Cryptology ePrint Archive, Report 2025/1380 |
| Lien | <https://eprint.iacr.org/2025/1380> |
| Reçu / approuvé | 2025-07-29 / 2025-07-30 |
| Catégorie ePrint | Protocoles cryptographiques |
| Mots-clés | CRO Trilemma, Post-Quantum, UC Security, Contextual Signatures, Composable Protocols, Legal Opposability |
| Licence affichée sur ePrint | CC BY 4.0 (relevée le 2026-10-12) |
| Entrée BibTeX | [CITATION.bib](CITATION.bib) (clé `MINKA2025Q2CSI`, reprise de la bibliographie de la thèse) |

Ce document est un préprint déposé sur l'archive ePrint de l'IACR. Il n'a pas fait l'objet d'une évaluation par les pairs et ses résultats ne doivent pas être cités comme validés.

## Résumé

Paraphrase fidèle du résumé officiel publié sur la page ePrint (consultée le 2026-10-12). Le texte original fait foi et se lit à l'adresse <https://eprint.iacr.org/2025/1380>.

Les auteurs partent du conflit entre confidentialité, fiabilité et opposabilité juridique, formalisé comme Trilemme CRO, qui fixe une borne entropique $\Gamma_\text{CRO}$ à la sécurité cryptographique en contexte adverse. Ils proposent Q2CSI, cadre à couches qui traite le trilemme par séparation des préoccupations. La sécurité y est répartie en trois couches isolées mais composables, Iron (fiabilité, intégrité temporelle et de journalisation), Gold (confidentialité, préservation de l'entropie sémantique) et Clay (opposabilité, interprétabilité institutionnelle). Le cadre intègre les contraintes entropiques dans un modèle de composabilité universelle (UC) étendu. Il annonce $\Gamma_\text{CRO} < 0{,}4$, présenté comme une amélioration par rapport aux conceptions monolithiques, ainsi qu'une résilience aux menaces post-quantiques. L'architecture est instanciée de façon abstraite avec des primitives minimales (chiffrement IND-CCA2, signatures EUF-CMA) puis validée dans un cadre UC symbolique. Les preuves revendiquent l'isolation stricte des couches, une fuite contextuelle bornée et la compatibilité avec les adversaires quantiques. Les auteurs y voient une base pour des protocoles post-quantiques juridiquement vérifiables (attestations à divulgation nulle, signatures conformes aux exigences réglementaires). La note de la page précise que le travail s'appuie sur 2025/1348, qu'une instanciation concrète figure dans 2025/1138 et que l'article ne comporte ni artefact d'implémentation ni revendication de performance.

## Rôle dans la thèse

Pièce centrale de l'Axe II des perspectives ([chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). La thèse présente Q2CSI comme la traduction architecturale de l'esprit SOTP. La décomposition Iron ($\mathrm{Rel}$), Gold ($\mathrm{Conf}$), Clay ($\mathrm{Opp}$) transpose le paradigme Gold-Iron-Clay dans le modèle de Canetti. Q2CSI incarne l'esprit SOTP sous la forme d'un schéma d'architecture plutôt que d'une construction abstraite. Une question ouverte porte sur sa complétude, à savoir si tout protocole institutionnel séparant les trois couches est UC-équivalent à une instanciation Q2CSI. La limite L3 du chapitre 5 ([chap5/discussions.tex](../../00_these/manuscrit/chap5/discussions.tex)) le range aussi parmi les prépublications développant les jeux cryptographiques non encore publiés dans une revue.

## Réserves formulées dans la thèse

L'indice $\Gamma_\text{CRO}$ n'est pas défini dans le cadre de la thèse. Les valeurs chiffrées qu'en donne le préprint ne sont donc pas reprises comme résultats. Relier cet indice au produit $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}$ est une question ouverte (chapitre 5, Perspectives, Axe II).

## PDF et licence

Le PDF n'est pas joint à ce dossier. Il est disponible sur ePrint à l'adresse <https://eprint.iacr.org/2025/1380>. La page ePrint affiche la licence Creative Commons Attribution 4.0 (CC BY 4.0), qui autorise la redistribution avec attribution. Le PDF pourra donc être joint ultérieurement, accompagné de la mention d'attribution requise.
