# Retour anonymisé et révision, tours 2 à 4 (P2, approche 3)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.2.4 (révision après feedback anonymisé, procédure en quatre rounds, arrêt lorsque l'IQR est inférieur à 5 bits)

[English version](delphi_retour_tours_2_4_en.md) · [Protocole P2](protocole_fr.md) · [Tour 1](delphi_questionnaire_tour1_fr.md) · [Synthèse](delphi_synthese_fr.md)

Ce document a deux parties. La partie A est la règle que suit l'équipe entre deux tours. La partie B est le formulaire envoyé à chaque expert à partir du tour 2.

## Partie A. Règle de conduite entre deux tours

1. **Calcul.** Pour chaque domaine, l'équipe calcule sur les réponses du tour qui s'achève l'effectif, la médiane, le premier et le troisième quartile, l'écart interquartile (IQR), le minimum et le maximum (`cro_terrain.p2.delphi_round_summary`).
2. **Arrêt par domaine.** Un domaine est clos dès que son IQR est inférieur à 5 bits. Il n'est plus soumis aux tours suivants. Les domaines non clos continuent jusqu'au tour 4 au plus (`p2.delphi_should_stop`).
3. **Arguments.** L'équipe regroupe les arguments par thème, les reformule pour qu'aucun expert ne soit identifiable. Elle retient pour chaque domaine au plus cinq arguments favorables à une valeur haute et cinq favorables à une valeur basse **[à arrêter par l'équipe]**.
4. **Neutralité.** Le retour ne contient aucune valeur de la thèse, aucun avis de l'équipe et aucune indication sur la « bonne » valeur.
5. **Délais.** Deux semaines par tour au plus. Un expert qui ne répond pas à un tour est relancé une fois. Il reste invité aux tours suivants et sa dernière réponse est conservée pour le calcul **[à arrêter par l'équipe]**.
6. **Traçabilité.** Chaque retour envoyé est archivé avec sa date. La liste des domaines clos à chaque tour figure dans la [synthèse](delphi_synthese_fr.md).

## Partie B. Formulaire du tour ___ (2, 3 ou 4)

| Champ | Valeur |
|---|---|
| Code expert | `P2-EX-__` |
| Tour | ☐ 2 ☐ 3 ☐ 4 |
| Date d'envoi / de retour | ___ / ___ / ______ → ___ / ___ / ______ |

### B.1 Ce que le groupe a répondu au tour précédent

Rempli par l'équipe pour chaque domaine encore ouvert. Vos propres réponses du tour précédent sont rappelées dans la dernière colonne. Elles ne sont connues que de vous et de l'équipe.

| Domaine | Réponses | Médiane | 1er quartile | 3e quartile | IQR | Min – max | Votre réponse précédente |
|---|---|---|---|---|---|---|---|
| ELEC | ____ | ____ bits | ____ | ____ | ____ | ____ – ____ | ____ bits [____ ; ____] |
| FIN | ____ | ____ bits | ____ | ____ | ____ | ____ – ____ | ____ bits [____ ; ____] |
| CONT | ____ | ____ bits | ____ | ____ | ____ | ____ – ____ | ____ bits [____ ; ____] |

Domaines clos au tour précédent (IQR inférieur à 5 bits), à ne plus estimer : ______

### B.2 Arguments du groupe (anonymisés)

| Domaine | Arguments en faveur d'une valeur plus haute | Arguments en faveur d'une valeur plus basse |
|---|---|---|
| ELEC | 1. … | 1. … |
| FIN | 1. … | 1. … |
| CONT | 1. … | 1. … |

### B.3 Votre estimation révisée

Vous pouvez maintenir ou modifier votre estimation. Si votre nouvelle estimation se situe hors de l'intervalle entre le 1er et le 3e quartile du groupe, indiquez brièvement pourquoi.

| Domaine | Meilleure estimation (bits) | Borne basse | Borne haute | Confiance 0–10 | Inchangée |
|---|---|---|---|---|---|
| ELEC | ______ | ______ | ______ | ____ | ☐ |
| FIN | ______ | ______ | ______ | ____ | ☐ |
| CONT | ______ | ______ | ______ | ____ | ☐ |

Justification (obligatoire si hors de l'intervalle interquartile du groupe)

______________________________________________________________________
______________________________________________________________________

Retour au plus tard le ___ / ___ / ______.

---

Saisie dans [gabarit_delphi_fr.csv](gabarit_delphi_fr.csv), une ligne par domaine encore ouvert, avec le numéro du tour. La justification est saisie dans la colonne `argument`.

Licence CC BY 4.0.
