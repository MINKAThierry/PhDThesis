# Fiche de dénombrement de l'espace des verdicts $\mathcal{V}$ (P4, étape 5)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.4, étape 5 ($\hat\alpha \leftarrow \log_2|\mathcal{V}|/H(C)$) ; dérivations du §4.3 ($|\mathcal{V}| = 4$ pour Helios, 8 pour le régulateur financier)

[English version](fiche_denombrement_verdicts_en.md) · [Protocole P4](protocole_fr.md) · [Gabarit](gabarit_denombrement_verdicts_fr.csv)

## 1. Pourquoi dénombrer

$\hat\alpha$ dépend de $|\mathcal{V}|$, le nombre de décisions distinctes que l'institution peut rendre dans le contexte étudié. Les dérivations de la thèse posent cette valeur à partir des pratiques documentées (quatre décisions pour un contentieux électoral, huit pour un régulateur financier). P4 propose de l'établir à partir des textes, avant la collecte, afin qu'elle ne dépende pas des verdicts observés.

## 2. Procédure

1. Deux personnes indépendantes remplissent la fiche, l'une juriste (`D-A`), l'autre membre de l'institution (`D-B`).
2. Chacune liste toutes les décisions prévues par les textes applicables au contexte $C$, avec leur fondement.
3. Pour chaque décision, elle indique si elle la **retient** comme verdict distinct. Une décision est retenue si elle produit des effets juridiques différents des autres. Deux formulations aux mêmes effets comptent pour une seule.
4. Les deux listes sont confrontées. Le coordinateur tranche les divergences après échange. La règle appliquée est notée.
5. $|\mathcal{V}|$ est le nombre de codes retenus dans la liste consolidée (`cro_terrain.p4.verdict_space_size`).

## 3. Fiche (une par institution et par contexte)

| Champ | Valeur |
|---|---|
| Institution | `INST-__` |
| Contexte $C$ | `______` |
| Rédacteur | ☐ `D-A` juriste ☐ `D-B` membre de l'institution ☐ liste consolidée |
| Textes consultés (références et versions) | ______________________ |

| Code | Décision (libellé) | Fondement juridique (texte, article) | Retenue comme verdict distinct | Motif si non retenue |
|---|---|---|---|---|
| 1 | | | ☐ oui ☐ non | |
| 2 | | | ☐ oui ☐ non | |
| 3 | | | ☐ oui ☐ non | |
| 4 | | | ☐ oui ☐ non | |
| 5 | | | ☐ oui ☐ non | |
| 6 | | | ☐ oui ☐ non | |
| 7 | | | ☐ oui ☐ non | |
| 8 | | | ☐ oui ☐ non | |
| 9 | | | ☐ oui ☐ non | |
| 10 | | | ☐ oui ☐ non | |

$|\mathcal{V}| =$ ____ et $\log_2|\mathcal{V}| =$ ____ bits.

## 4. Exemple (contentieux électoral, d'après la dérivation Helios de la thèse)

Exemple d'illustration tiré du §4.3. Il ne remplace pas le dénombrement sur les textes réels.

| Code | Décision | Fondement | Retenue |
|---|---|---|---|
| 1 | Validation de l'élection | à compléter selon le code électoral applicable | oui |
| 2 | Annulation de l'élection | idem | oui |
| 3 | Recomptage ordonné | idem | oui |
| 4 | Investigation demandée | idem | oui |

$|\mathcal{V}| = 4$, d'où $\log_2|\mathcal{V}| = 2$ bits (thèse, équation `eq:hvc_helios`).

## 5. Cohérence avec le questionnaire

Si le questionnaire présente aux participants un nombre de décisions différent de $|\mathcal{V}|$ (par exemple les quatre verdicts du questionnaire de P1), l'écart est noté ici et dans le rapport.

Écart constaté ☐ non ☐ oui : ______________________

## 6. Saisie

Une ligne par décision et par rédacteur dans [gabarit_denombrement_verdicts_fr.csv](gabarit_denombrement_verdicts_fr.csv). La colonne `retenu_oui_non` reçoit `oui` ou `non`. La colonne `remarques` commence par le code du rédacteur (`D-A`, `D-B`) ou par `consolidee` pour la liste consolidée. Lorsque des lignes `consolidee` existent, `verdict_space_size` ne compte qu'elles.

Licence CC BY 4.0.
