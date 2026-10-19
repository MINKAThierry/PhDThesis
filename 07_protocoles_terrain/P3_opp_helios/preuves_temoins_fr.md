# Procédure des preuves témoins (P3)

> **Statut : PROPOSITION — ajout au protocole de la thèse, non déployé** · Source : thèse, chapitre 4, §4.2.3.5 (mesure de $H_{\text{emp}}(V\mid C)$ au lieu de la postuler)

[English version](preuves_temoins_en.md) · [Protocole P3](protocole_fr.md)

La thèse ne prévoit pas de preuves témoins. Cette procédure est une proposition. Elle vise à éviter le cas où tous les verdicts sont identiques, qui rendrait $\mathsf{Opp}_{\text{emp}}$ indéfini ([protocole](protocole_fr.md#53-preuves-auditées)). Son adoption est **[à arrêter par l'équipe]**.

## 1. Principe

Le coordinateur prépare 10 preuves témoins, copies de bulletins publics du scrutin auxquelles une altération connue a été apportée. Elles sont mêlées en aveugle aux 50 preuves tirées. Les trustees ne savent ni combien il y a de témoins, ni lesquels. Ils savent seulement que le jeu d'audit peut en contenir.

Les témoins ne sont jamais déposés sur l'instance Helios. Ils n'existent que dans le jeu d'audit de recherche (convention, article 4).

## 2. Types d'altération

| Code | Altération | Effet attendu à la vérification |
|---|---|---|
| T1 | Un octet modifié dans une réponse d'une preuve « 0 ou 1 » | preuve de validité rejetée |
| T2 | Un octet modifié dans la preuve « somme égale à 1 » | preuve globale rejetée |
| T3 | Chiffré d'une option remplacé par celui d'un autre bulletin, preuves inchangées | preuves rejetées |
| T4 | Bulletin rejoué, copie exacte d'un bulletin déjà présent dans l'échantillon | preuves acceptées, doublon détectable par l'empreinte |
| T5 | Horodatage de dépôt modifié et placé après la clôture | preuves acceptées, anomalie de contexte |

La répartition proposée compte 2 témoins de chaque type **[à arrêter]**.

Les types T4 et T5 portent des preuves valides. Ils mesurent si les trustees regardent au-delà du résultat de vérification, ce qui correspond à la part du verdict qui ne vient pas de la preuve.

## 3. Préparation

1. Après le tirage, le coordinateur choisit au hasard les bulletins sources avec une graine distincte consignée dans le registre des témoins. Les sources des types T1, T2, T3 et T5 sont prises hors de l'échantillon. Celles du type T4 sont prises dans l'échantillon, puisqu'un bulletin rejoué doit y figurer deux fois.
2. Il applique les altérations sur une copie, dans le format de l'instance Helios, puis vérifie avec l'outil de vérification de cette instance que l'effet obtenu est bien l'effet attendu.
3. Il attribue à chaque témoin un identifiant d'audit de même forme que les autres (`P-01` à `P-60`), puis mélange les 60 preuves selon un ordre tiré au hasard, propre à chaque trustee.
4. Il consigne la correspondance entre identifiant d'audit, bulletin source, type d'altération et statut (`authentique` ou `temoin`) dans le registre des témoins, conservé hors de la vue des trustees jusqu'à la fin de l'audit.

## 4. Registre des témoins (confidentiel jusqu'à la clôture de l'audit)

| Identifiant d'audit | Bulletin source (empreinte) | Type | Effet vérifié | Statut |
|---|---|---|---|---|
| `P-__` | `________` | T_ | ☐ conforme | temoin |
| `P-__` | `________` | T_ | ☐ conforme | temoin |
| `P-__` | `________` | T_ | ☐ conforme | temoin |

Préparé par ______ le ___ / ___ / ______. Contrôlé par ______.

## 5. Saisie et analyse

La colonne `statut_reference` du [gabarit](gabarit_audit_preuves_fr.csv) reçoit `authentique` ou `temoin`. L'analyse rapporte $\mathsf{Opp}_{\text{emp}}$ sur les 60 preuves et sur les 50 preuves tirées seules, ainsi que le taux de détection de chaque type de témoin.

Licence CC BY 4.0.
