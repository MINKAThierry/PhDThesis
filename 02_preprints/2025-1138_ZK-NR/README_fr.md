# ePrint 2025/1138 - ZK-NR

> **Statut : PRÉPRINT (non évalué par les pairs)** · Source : Cryptology ePrint Archive, rapport 2025/1138

[English version](README_en.md)

## Référence

| Champ | Valeur |
|---|---|
| Titre | ZK-NR: A Layered Cryptographic Architecture for Explainable Non-Repudiation |
| Auteurs | T. E. Minka Mi Nguidjoï, F. S. Mani Onana, T. Djotio Ndié |
| Archive | Cryptology ePrint Archive, Report 2025/1138 |
| Lien | <https://eprint.iacr.org/2025/1138> |
| Reçu / approuvé | 2025-06-16 / 2025-06-17 |
| Catégorie ePrint | Protocoles cryptographiques |
| Mots-clés | Non-Repudiation, Post-Quantum Crypto, Merkle, STARKs, Signatures, Tamarin |
| Licence affichée sur ePrint | CC BY 4.0 (relevée le 2026-10-12) |
| Entrée BibTeX | [CITATION.bib](CITATION.bib) (clé `MINKA2025ZKNR_Exploration`, reprise de la bibliographie de la thèse) |

Ce document est un préprint déposé sur l'archive ePrint de l'IACR. Il n'a pas fait l'objet d'une évaluation par les pairs et ses résultats ne doivent pas être cités comme validés.

## Résumé

Paraphrase fidèle du résumé officiel publié sur la page ePrint (consultée le 2026-10-12). Le texte original fait foi et se lit à l'adresse <https://eprint.iacr.org/2025/1138>.

L'article présente ZK-NR, un protocole cryptographique modulaire de non-répudiation préservant la confidentialité, destiné à la coproduction de services publics numériques. Il combine des engagements de Merkle, des preuves à divulgation nulle de connaissance (STARKs), des signatures BLS à seuil et une authentification post-quantique Dilithium. Le protocole permet à des parties de produire des preuves sûres, vérifiables et auditables au sein d'infrastructures décentralisées. À la différence des signatures numériques classiques ou des journaux fondés sur une chaîne de blocs, il fournit des attestations formellement vérifiables sans révéler le contenu sensible. Les auteurs le destinent aux finances publiques, à l'administration électronique et aux écosystèmes numériques régulés.

Le protocole est modélisé dans Tamarin puis implémenté sous forme de preuve de concept avec des outils cryptographiques ouverts. Il est présenté comme une base reproductible pour des systèmes exigeant une confiance de long terme, la minimisation des données et la recevabilité juridique, notamment lorsque citoyens et institutions partagent la responsabilité de la preuve numérique. Il répond à la tension entre confidentialité et redevabilité. Le travail est déclaré préliminaire. Il porte sur la composition architecturale et la faisabilité de l'implémentation sans preuves formelles de sécurité.

La page ePrint signale un matériel complémentaire (`zk-nr_sup_mat.zip`) contenant les scripts d'implémentation, les journaux d'exécution et les instructions de reproduction. Elle annonce des preuves UC et une vérification symbolique Tamarin soumises séparément.

## Rôle dans la thèse

Premier stade de la série ZK-NR, citée dans l'Axe II des perspectives (chapitre 5, « Voie protocolaire. Q2CSI, ZK-NR et l'instanciation de l'esprit SOTP », [chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). La thèse le désigne comme ZK-NR v1. Il compose engagements de Merkle, STARKs, signatures BLS à seuil et authentification Dilithium en un protocole de non-répudiation sans divulgation. Il établit la faisabilité conceptuelle, les preuves formelles étant réservées aux versions ultérieures (2025/1422 puis 2025/1529).

## Réserves formulées dans la thèse

La thèse ne formule pas de réserve propre à ce préprint. Elle le présente comme une étape de faisabilité sans preuve formelle. L'indice $\Gamma_\text{CRO}$ n'est pas défini dans le cadre de la thèse. Les valeurs chiffrées qu'en donnent Q2CSI et ZK-NR v3 ne sont donc pas reprises comme résultats. Relier cet indice au produit $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}$ est une question ouverte (chapitre 5, Perspectives, Axe II).

## PDF et licence

Le PDF n'est pas joint à ce dossier. Il est disponible sur ePrint à l'adresse <https://eprint.iacr.org/2025/1138>. La page ePrint affiche la licence Creative Commons Attribution 4.0 (CC BY 4.0), qui autorise la redistribution avec attribution. Le PDF pourra donc être joint ultérieurement, accompagné de la mention d'attribution requise.
