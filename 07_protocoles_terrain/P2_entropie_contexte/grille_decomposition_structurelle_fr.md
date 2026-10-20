# Grille de décomposition structurelle (P2, approche 1)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.2.2 (équation `eq:decomposition_HC`) ; glossaire des notations, $H(C) = H(L) + H(T\mid L) + H(R\mid L,T)$

[English version](grille_decomposition_structurelle_en.md) · [Protocole P2](protocole_fr.md)

Une grille par expert. Elle se remplit en 45 à 60 min environ, seul et sans documentation imposée **[durée à confirmer au pré-test]**. Le formulaire ne comporte aucun nom.

| Champ | Valeur |
|---|---|
| Code expert | `P2-EX-__` |
| Profil | ☐ droit et contentieux ☐ régulation et audit ☐ cryptographie appliquée |
| Date | ___ / ___ / ______ |

## Consignes

Pour chacun des trois domaines, on vous propose une liste d'**éléments** qui distinguent un contexte d'un autre. Chaque élément est rattaché à une composante.

- **L, composante juridique.** Ce qui relève des règles et des statuts (type d'acte, droit applicable, qualité des parties).
- **T, composante temporelle.** Ce qui relève des dates, des délais, de l'historique.
- **R, composante procédurale.** Ce qui relève des formes, des organes et des voies de procédure.

Pour chaque élément, indiquez le **nombre de modalités** que votre institution distingue en pratique, c'est-à-dire le nombre de cas qui conduiraient à traiter un dossier différemment. Par exemple, si une juridiction distingue trois régimes de preuve pour un contrat, l'élément « régime de preuve » a 3 modalités.

- Indiquez 1 si l'élément ne fait jamais varier le traitement.
- Si certaines modalités sont beaucoup plus fréquentes que d'autres, vous pouvez donner leurs fréquences approximatives dans la colonne « Fréquences ». L'entropie est alors calculée à partir de ces fréquences.
- Ne comptez pas deux fois la même distinction. Si deux éléments se recoupent, rayez l'un d'eux et indiquez-le dans « Remarques ».
- Ajoutez en fin de tableau les éléments manquants qui vous paraissent importants.

Aucune valeur de référence n'est communiquée. La colonne « Entropie (bits) » est calculée par l'équipe et vous ne la remplissez pas.

## Domaine CONT, signature contractuelle

Éléments proposés à partir de l'équation `eq:decomposition_HC` de la thèse (parties, clauses, juridiction, historique) complétée par des éléments procéduraux.

| N° | Composante | Élément | Exemples de modalités | Nb de modalités | Fréquences (facultatif) | Entropie (bits) | Remarques |
|---|---|---|---|---|---|---|---|
| C1 | L | Qualité juridique des parties (*parties*) | particulier, commerçant, société, personne publique | ____ | | | |
| C2 | L | Type de contrat | bail, vente, prestation, prêt, travail | ____ | | | |
| C3 | L | Clauses déterminantes en litige (*clauses*) | prix, durée, résiliation, exclusivité | ____ | | | |
| C4 | L | Droit applicable et juridiction (*juridiction*) | droit national, OHADA, droit étranger, arbitrage | ____ | | | |
| C5 | T | Historique de la relation (*historique*) | première relation, relation suivie, litige antérieur | ____ | | | |
| C6 | T | Stade d'exécution | non commencé, en cours, achevé, résilié | ____ | | | |
| C7 | T | Délai écoulé depuis la conclusion | moins d'un an, 1 à 5 ans, plus de 5 ans | ____ | | | |
| C8 | R | Forme de conclusion | papier, électronique simple, électronique qualifiée | ____ | | | |
| C9 | R | Mode de preuve produit | original, copie, extrait technique, témoignage | ____ | | | |
| C10 | R | Voie procédurale | amiable, référé, fond, arbitrage | ____ | | | |
| C11 | | | | ____ | | | |
| C12 | | | | ____ | | | |

## Domaine ELEC, contentieux électoral

La thèse cite comme composantes dominantes le registre, les règles et l'historique.

| N° | Composante | Élément | Exemples de modalités | Nb de modalités | Fréquences (facultatif) | Entropie (bits) | Remarques |
|---|---|---|---|---|---|---|---|
| E1 | L | Type de scrutin | présidentiel, législatif, local, professionnel, associatif | ____ | | | |
| E2 | L | Règles applicables | code électoral, statuts, règlement intérieur | ____ | | | |
| E3 | L | Situation de l'électeur au registre (*registre*) | inscrit, radié, inscrit ailleurs, procuration | ____ | | | |
| E4 | L | Objet de la contestation | éligibilité, régularité du vote, dépouillement, proclamation | ____ | | | |
| E5 | T | Phase du processus | inscription, campagne, vote, dépouillement, proclamation | ____ | | | |
| E6 | T | Historique contentieux (*historique*) | aucun, contentieux antérieur, annulation antérieure | ____ | | | |
| E7 | T | Respect des délais | dans les délais, hors délai, délai contesté | ____ | | | |
| E8 | R | Organe saisi | commission électorale, juge administratif, juge constitutionnel | ____ | | | |
| E9 | R | Mode de vote | urne, électronique sur place, électronique à distance | ____ | | | |
| E10 | R | Nature du recours | réclamation, recours en annulation, recours en réformation | ____ | | | |
| E11 | | | | ____ | | | |
| E12 | | | | ____ | | | |

## Domaine FIN, conformité financière

La thèse cite comme composantes dominantes les transactions, les réglementations et l'audit.

| N° | Composante | Élément | Exemples de modalités | Nb de modalités | Fréquences (facultatif) | Entropie (bits) | Remarques |
|---|---|---|---|---|---|---|---|
| F1 | L | Réglementation applicable (*réglementations*) | prudentielle, LBC/FT, fiscale, comptable | ____ | | | |
| F2 | L | Statut de l'entité contrôlée | banque, microfinance, assurance, entreprise publique | ____ | | | |
| F3 | L | Type d'opération (*transactions*) | virement, crédit, change, cryptoactif | ____ | | | |
| F4 | L | Niveau de risque du client | faible, standard, élevé, personne politiquement exposée | ____ | | | |
| F5 | T | Période contrôlée | exercice en cours, exercice clos, plusieurs exercices | ____ | | | |
| F6 | T | Antécédents de l'entité | aucun, observations, sanctions antérieures | ____ | | | |
| F7 | T | Fréquence des opérations | ponctuelle, répétée, continue | ____ | | | |
| F8 | R | Type de contrôle (*audit*) | sur pièces, sur place, audit externe, enquête | ____ | | | |
| F9 | R | Référentiel de contrôle | normes nationales, normes internationales, référentiel interne | ____ | | | |
| F10 | R | Suite procédurale possible | classement, injonction, sanction, transmission au parquet | ____ | | | |
| F11 | | | | ____ | | | |
| F12 | | | | ____ | | | |

## Question de clôture

Pour chaque domaine, la somme des entropies suppose les éléments indépendants. Selon vous, quels éléments sont les plus liés entre eux ?

- CONT : ______________________________________________
- ELEC : ______________________________________________
- FIN : ______________________________________________

## Calcul (rempli par l'équipe)

Pour un élément à $k$ modalités équiprobables, l'entropie vaut $\log_2 k$ bits. Si l'expert donne des fréquences $p_1, \dots, p_k$, elle vaut $-\sum_i p_i \log_2 p_i$ bits. La somme par composante donne $H(L)$, $H(T)$ et $H(R)$. Leur total est l'estimation de l'expert pour le domaine. Le calcul est fait par `cro_terrain.p2.element_entropy` et `cro_terrain.p2.decomposition_totals`.

| Domaine | $H(L)$ | $H(T)$ | $H(R)$ | Total (bits) |
|---|---|---|---|---|
| CONT | | | | |
| ELEC | | | | |
| FIN | | | | |

Saisie dans [gabarit_decomposition_fr.csv](gabarit_decomposition_fr.csv), une ligne par élément. La colonne `element` reçoit le numéro (C1, E4, F10, etc.) ou, pour un élément ajouté, son libellé.

Licence CC BY 4.0.
