# ePrint 2025/1615 — CEE

> **Statut : PRÉPRINT (non évalué par les pairs)** · Source : Cryptology ePrint Archive, rapport 2025/1615

[English version](README_en.md)

## Référence

| Champ | Valeur |
|---|---|
| Titre | The Chaotic Entropic Expansion (CEE): A Transparent Post-Quantum Data Confidentiality Primitive via Entropic Chaotic Maps |
| Auteurs | T. E. Minka Mi Nguidjoï |
| Archive | Cryptology ePrint Archive, Report 2025/1615 |
| Lien | <https://eprint.iacr.org/2025/1615> |
| Reçu / approuvé | 2025-09-08 / 2025-09-11 |
| Catégorie ePrint | Fondements |
| Mots-clés | finite fields, polynomial iteration, entropy bounds, post-quantum cryptography, one-way functions, CASH framework |
| Licence affichée sur ePrint | CC BY 4.0 (relevée le 2026-10-12) |
| Entrée BibTeX | [CITATION.bib](CITATION.bib) (clé `MINKA2025CEE`, reprise de la bibliographie de la thèse) |

Ce document est un préprint déposé sur l'archive ePrint de l'IACR. Il n'a pas fait l'objet d'une évaluation par les pairs et ses résultats ne doivent pas être cités comme validés.

## Résumé

Paraphrase fidèle du résumé officiel publié sur la page ePrint (consultée le 2026-10-12). Le texte original fait foi et se lit à l'adresse <https://eprint.iacr.org/2025/1615>.

L'article introduit la Chaotic Entropic Expansion (CEE), fonction à sens unique construite à partir d'applications polynomiales itérées sur des corps finis. Pour les polynômes d'une classe spécifiquement définie, l'auteur prouve qu'après $N$ itérations la sortie conserve une min-entropie d'au moins $\log_2 q - N\log_2 d$ bits. La distance statistique de la sortie à la distribution uniforme est bornée par $(q-1)(d^N-1)/(2\sqrt{q})$. La sécurité est formalisée par le problème AIIP, avec des réductions qui rattachent sa difficulté à la résolution d'équations quadratiques multivariées (MQ) et au calcul de logarithmes discrets. Face aux adversaires quantiques, CEE atteindrait une sécurité en $O(2^{\lambda/2})$ pour un niveau de sécurité classique de $\lambda$ bits. L'article comprend une cryptanalyse et des recommandations de paramètres. CEE est reconnue plus lente qu'AES. Sa structure algébrique est présentée comme ouvrant des applications en calcul vérifiable et en cryptographie post-quantique dans le cadre CASH. La note de la page la décrit comme la première composante du cadre CASH (CEE, AOW, SH), contribution théorique sans implémentation ni mesure de performance.

## Rôle dans la thèse

Couche confidentialité ($\mathrm{Conf}$) du CASH Toolkit dans l'Axe I des perspectives ([chap5/perspectives.tex](../../00_these/manuscrit/chap5/perspectives.tex)). La thèse retient de CEE la minoration de min-entropie résiduelle et le trait caractéristique de la construction, dont la transparence algébrique délibérément préservée permet à $\mathrm{Conf}$ de coexister avec $\mathrm{Opp}$ sans conflit structurel. Une question ouverte porte sur la préservation des bornes CRO, à un facteur constant près, par l'assemblage $(CEE \,\|\, AOW \,\|\, SH)$ en architecture Gold-Iron-Clay.

## Réserves formulées dans la thèse

La borne de distance statistique à l'uniforme annoncée dans le préprint, $(q-1)(d^N-1)/(2\sqrt{q})$, dépasse $1$ dès que $d^N > 2\sqrt{q}/(q-1) + 1$, c'est-à-dire pour tout $N$ utile. Elle est alors vide, puisqu'une distance statistique est toujours au plus égale à $1$. Une borne non triviale reste à établir. La thèse relève aussi que les preuves actuelles du toolkit opèrent dans le modèle de l'oracle aléatoire et que des preuves en modèle standard renforceraient sa fondation. La sécurité de cette primitive est réduite à AIIP (ePrint 2025/1590). Les réserves que la thèse formule sur AIIP s'appliquent donc par héritage, en particulier l'objection de l'inversion par extractions de racines successives (voir [2025-1590_AIIP](../2025-1590_AIIP/README_fr.md)).

## PDF et licence

Le PDF n'est pas joint à ce dossier. Il est disponible sur ePrint à l'adresse <https://eprint.iacr.org/2025/1615>. La page ePrint affiche la licence Creative Commons Attribution 4.0 (CC BY 4.0), qui autorise la redistribution avec attribution. Le PDF pourra donc être joint ultérieurement, accompagné de la mention d'attribution requise.
