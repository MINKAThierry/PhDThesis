# ePrint 2025/1590 - AIIP

> **Statut : PRÉPRINT (non évalué par les pairs)** · Source : Cryptology ePrint Archive, rapport 2025/1590

[English version](README_en.md)

## Référence

| Champ | Valeur |
|---|---|
| Titre | The AIIP Problem: Toward a Post-Quantum Hardness Assumption from Affine Iterated Inversion over Finite Fields |
| Auteurs | T. E. Minka Mi Nguidjoï |
| Archive | Cryptology ePrint Archive, Report 2025/1590 |
| Lien | <https://eprint.iacr.org/2025/1590> |
| Reçu / approuvé | 2025-09-03 / 2025-09-05 |
| Catégorie ePrint | Fondements |
| Mots-clés | AIIP, post-quantum cryptography, multivariate quadratic, hyperelliptic curve, hardness assumption, iterative inversion |
| Licence affichée sur ePrint | CC BY 4.0 (relevée le 2026-10-12) |
| Entrée BibTeX | [CITATION.bib](CITATION.bib) (clé `MINKA2025AIIP`, reprise de la bibliographie de la thèse) |

Ce document est un préprint déposé sur l'archive ePrint de l'IACR. Il n'a pas fait l'objet d'une évaluation par les pairs et ses résultats ne doivent pas être cités comme validés.

## Résumé

Paraphrase fidèle du résumé officiel publié sur la page ePrint (consultée le 2026-10-12). Le texte original fait foi et se lit à l'adresse <https://eprint.iacr.org/2025/1590>.

L'article propose le problème AIIP (Affine Iterated Inversion Problem) comme hypothèse de difficulté candidate pour la cryptographie post-quantique. Étant donné un polynôme $f \in \mathbb{F}_q[x]$ de degré $d \geq 2$, un nombre d'itérations $n$ et une cible $y$, il s'agit de trouver $x$ tel que $f^{(n)}(x) = y$. La difficulté est argumentée par deux voies indépendantes. La première relie AIIP au logarithme discret dans la jacobienne de courbes hyperelliptiques de très grand genre, dans l'arithmétique desquelles une instance AIIP est plongée. La seconde est une réduction en temps polynomial vers des systèmes structurés d'équations quadratiques multivariées (MQ), présentée comme établissant une difficulté dans le pire cas relativement à MQ, problème NP-difficile. Pour le cas quadratique $f(x) = x^2 + \alpha$ (ici $\alpha \in \mathbb{F}_q$ est une constante du polynôme, sans rapport avec la granularité des verdicts $\alpha$ de la thèse), l'auteur soutient que le système MQ obtenu se comporte heuristiquement comme un système aléatoire. Il énonce une condition suffisante de pseudo-aléa fondée sur une hypothèse cryptographique standard. L'article comprend aussi une analyse de sécurité face aux attaques classiques et quantiques, des paramètres concrets pour les niveaux de sécurité usuels ainsi qu'une discussion des usages en signature numérique et en chiffrement à clé publique.

## Rôle dans la thèse

Fondement de l'Axe I des perspectives (chapitre 5, « Fondations computationnelles. AIIP et le CASH Toolkit », [chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). Les Trilemmes CRO classique et quantique sont prouvés au sens de la théorie de l'information mais leurs instanciations pratiques requièrent des primitives résistant aux adversaires QPT. AIIP y est présenté comme une hypothèse candidate à cet effet. Il est aussi la base commune des trois primitives du CASH Toolkit (CEE 2025/1615, AOW 2025/1662, SH 2025/1708). Le programme à court terme du chapitre 5 place en premier l'écriture de l'argument qui exclut l'inversion successive par extraction de racines, puis la cryptanalyse d'AIIP, préalables à tout usage applicatif du CASH Toolkit. L'annexe des publications ([annexes/publications.tex](../../00_these/manuscrit/annexes/publications.tex)) renvoie également à cet axe.

## Réserves formulées dans la thèse

La thèse ne reprend pas AIIP comme hypothèse établie. Elle note que les deux réductions annoncées et leur portée restent à établir de façon indépendante. Elle formule surtout une objection à lever avant de considérer AIIP comme hypothèse candidate. Sauf argument contraire, résoudre $f^{(n)}(x) = y$ se ramène à $n$ extractions successives de racines d'un polynôme de degré $d$ sur $\mathbb{F}_q$ en suivant les antécédents successifs. Ces extractions se font en temps polynomial en $n$, $d$ et $\log q$ par l'algorithme de Cantor–Zassenhaus. Un argument qui exclut cette attaque, par exemple un contrôle de la ramification de l'arbre des antécédents, est donc un préalable. La cryptanalyse (attaques de Gröbner, algorithmes de comptage de points, variantes quantiques telles que Grover ou le MNFS quantique) reste à conduire.

## PDF et licence

Le PDF n'est pas joint à ce dossier. Il est disponible sur ePrint à l'adresse <https://eprint.iacr.org/2025/1590>. La page ePrint affiche la licence Creative Commons Attribution 4.0 (CC BY 4.0), qui autorise la redistribution avec attribution. Le PDF pourra donc être joint ultérieurement, accompagné de la mention d'attribution requise.
