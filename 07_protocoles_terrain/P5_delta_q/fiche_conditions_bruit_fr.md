# Fiche des conditions de bruit (P5, phase 2)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.5.3, phase 2 (conditions A à D, 2 h)

[English version](fiche_conditions_bruit_en.md) · [Protocole P5](protocole_fr.md) · [Interface](specification_interface_verification_fr.md)

Une fiche par participant pour la phase 2. Elle est préparée par le coordinateur et contrôlée par l'enquêteur pendant la séance. Elle rappelle que la phase 2 relève du scénario hypothétique d'un vérificateur quantique.

## 1. Conditions (thèse)

| Condition | $p$ | Description dans la thèse | Inversion du résultat affiché |
|---|---|---|---|
| A | 0 | sans bruit, référence classique | 0 % |
| B | 0,001 | bruit faible, typique des systèmes corrigés | 0,05 % |
| C | 0,01 | bruit modéré, typique NISQ | 0,5 % |
| D | 0,1 | bruit élevé, test de robustesse | 5 % |

## 2. Ordre de Williams (4 participants consécutifs)

| Rang du participant modulo 4 | Bloc 1 | Bloc 2 | Bloc 3 | Bloc 4 |
|---|---|---|---|---|
| 0 | A | B | D | C |
| 1 | B | C | A | D |
| 2 | C | D | B | A |
| 3 | D | A | C | B |

Chaque condition occupe une fois chaque position. Elle précède en outre une fois chacune des autres. Ordre produit par `cro_terrain.p5.latin_square_order`.

## 3. Fiche du participant

| Champ | Valeur |
|---|---|
| Code participant | `P5-___-___` |
| Rang dans la série des participants | ____ (modulo 4 = ____) |
| Séance | `S-____` du ___ / ___ / ______ |
| Enquêteur | `ENQ-__` |
| Graine du générateur de bruit | `________________` |

| Bloc | Condition prévue | Condition affichée par l'interface | Items (stimulus et variante) | Début | Fin |
|---|---|---|---|---|---|
| 1 | | ☐ conforme | `___-C__-S_` ; `___-C__-S_` ; `___-C__-S_` | __:__ | __:__ |
| 2 | | ☐ conforme | `___-C__-S_` ; `___-C__-S_` ; `___-C__-S_` | __:__ | __:__ |
| 3 | | ☐ conforme | `___-C__-S_` ; `___-C__-S_` ; `___-C__-S_` | __:__ | __:__ |
| 4 | | ☐ conforme | `___-C__-S_` ; `___-C__-S_` ; `___-C__-S_` | __:__ | __:__ |

Inversions effectivement produites par l'interface, relevées dans le journal après la séance. Bloc 1 ____, bloc 2 ____, bloc 3 ____, bloc 4 ____.

## 4. Consigne lue au début de la phase 2

> « Dans cette partie, le résultat de vérification ne provient pas d'un logiciel classique. Il est produit par un vérificateur quantique simulé, dont le fonctionnement peut être perturbé par du bruit. Le niveau de bruit change d'un bloc à l'autre et il est indiqué à l'écran. Répondez comme vous le feriez si un tel vérificateur était utilisé dans votre institution. »

## 5. Contrôles

☐ Ordre des blocs conforme au tableau de la section 2
☐ Graine consignée avant le début
☐ Aucun item de la phase 2 n'est un item déjà vu en phase 1 par ce participant **[à arrêter : items nouveaux ou repris]**
☐ Écart éventuel déclaré par une [fiche d'écart](../00_commun/fiche_ecart_protocole_fr.md)

Licence CC BY 4.0.
