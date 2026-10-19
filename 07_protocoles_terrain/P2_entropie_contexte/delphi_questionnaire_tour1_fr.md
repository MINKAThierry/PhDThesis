# Questionnaire Delphi, tour 1 (P2, approche 3)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.2.4 (« 20 experts estiment $H(\mathcal{C})$ indépendamment, puis révisent après feedback anonymisé », arrêt lorsque l'IQR est inférieur à 5 bits)

[English version](delphi_questionnaire_tour1_en.md) · [Protocole P2](protocole_fr.md) · [Tours 2 à 4](delphi_retour_tours_2_4_fr.md)

Questionnaire individuel, rempli seul, sans échange avec les autres experts. Durée estimée 30 à 40 min **[à confirmer au pré-test]**. Le formulaire ne comporte aucun nom.

| Champ | Valeur |
|---|---|
| Code expert | `P2-EX-__` |
| Profil | ☐ droit et contentieux ☐ régulation et audit ☐ cryptographie appliquée |
| Date d'envoi / de retour | ___ / ___ / ______ → ___ / ___ / ______ |

## 1. Ce qui vous est demandé

Une institution (une juridiction, un régulateur, une commission électorale) traite des dossiers qui se présentent dans des contextes variés. Deux dossiers ont le même **contexte** lorsque l'institution les traiterait de la même manière, à preuve égale. On vous demande d'estimer **combien de contextes réellement distincts** une institution rencontre dans chacun des trois domaines ci-dessous, en tenant compte du fait que certains contextes sont fréquents et d'autres rares.

Cette quantité s'exprime en **bits**. Un domaine où l'on rencontrerait $N$ contextes distincts, tous aussi fréquents, a une entropie de $\log_2 N$ bits. Lorsque certains contextes sont beaucoup plus fréquents que d'autres, l'entropie est plus faible que $\log_2 N$.

| Nombre de contextes distincts équiprobables | Bits |
|---|---|
| 2 | 1 |
| 1 000 | ≈ 10 |
| 1 million | ≈ 20 |
| 1 milliard | ≈ 30 |
| $10^{12}$ | ≈ 40 |
| $10^{15}$ | ≈ 50 |
| $10^{18}$ | ≈ 60 |
| $10^{21}$ | ≈ 70 |

Vous pouvez répondre en bits ou en nombre de contextes. L'équipe fait la conversion.

Une méthode possible consiste à énumérer les éléments qui font varier le traitement d'un dossier (règles applicables, qualité des parties, délais, procédures) et à compter leurs combinaisons plausibles. Vous êtes libre d'en employer une autre.

## 2. Vos estimations

Pour chaque domaine, indiquez votre meilleure estimation, un intervalle dans lequel la vraie valeur se trouve selon vous avec une probabilité de 9 sur 10, votre confiance (0 aucune, 10 complète) et, en quelques lignes, l'argument principal de votre estimation. Les arguments seront communiqués anonymement aux autres experts.

### Domaine ELEC, contentieux électoral

Contestations relatives à des élections (politiques, professionnelles, associatives) portées devant une commission électorale ou un juge.

| Meilleure estimation | Borne basse | Borne haute | Confiance 0–10 |
|---|---|---|---|
| ______ ☐ bits ☐ contextes | ______ | ______ | ____ |

Argument principal

______________________________________________________________________
______________________________________________________________________

### Domaine FIN, conformité financière

Contrôles de conformité (prudentielle, LBC/FT, fiscale, comptable) d'entités financières ou publiques.

| Meilleure estimation | Borne basse | Borne haute | Confiance 0–10 |
|---|---|---|---|
| ______ ☐ bits ☐ contextes | ______ | ______ | ____ |

Argument principal

______________________________________________________________________
______________________________________________________________________

### Domaine CONT, signature contractuelle

Litiges portant sur des contrats signés, sur papier ou par voie électronique.

| Meilleure estimation | Borne basse | Borne haute | Confiance 0–10 |
|---|---|---|---|
| ______ ☐ bits ☐ contextes | ______ | ______ | ____ |

Argument principal

______________________________________________________________________
______________________________________________________________________

## 3. Question complémentaire

Classez les trois domaines du plus riche au moins riche en contextes distincts.

1. ________ 2. ________ 3. ________

Retournez ce questionnaire à l'adresse ou dans l'enveloppe indiquée, au plus tard le ___ / ___ / ______.

---

## Partie réservée à l'équipe

- Conversion en bits : $\log_2$ du nombre de contextes donné.
- Saisie dans [gabarit_delphi_fr.csv](gabarit_delphi_fr.csv), une ligne par domaine, avec `tour = 1`.
- Aucune valeur de la thèse n'est communiquée aux experts, à aucun tour ([protocole P2](protocole_fr.md#8-points-de-vigilance), point 4).

Licence CC BY 4.0.
