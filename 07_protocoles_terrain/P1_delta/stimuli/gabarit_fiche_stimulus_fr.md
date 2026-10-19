# Gabarit de fiche stimulus (P1)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.1.2 (matériel expérimental) et §4.2.1.3, phase 1, étapes (a) et (b)

[English version](gabarit_fiche_stimulus_en.md) · [Catalogue des stimuli](catalogue_stimuli_fr.md) · [Protocole P1](../protocole_fr.md)

Une fiche par paire contexte–preuve, soit 50 fiches. Chaque fiche décrit le contexte $c$, les deux messages engagés $m$, les quatre variantes de preuve $\sigma$ et l'espace des verdicts. Elle sert à imprimer les dossiers remis aux participants et à saisir la vérité terrain. Les parties 1 à 4 sont internes. Seule la partie 5 est remise au participant.

## Principe de construction

Pour que $\hat I(V;\Sigma\mid M,C)$ soit estimable, une paire $c$ doit offrir plusieurs preuves pour un même message. Les cinq schémas retenus par la thèse sont probabilistes. ECDSA et RSA-PSS tirent un aléa à chaque signature (nonce $k$, sel PSS). ElGamal et Helios tirent un aléa de chiffrement. Les preuves Groth16 sont re-randomisables. Deux exécutions sur un même $(m, c)$ produisent donc deux preuves distinctes, toutes deux valides.

Les règles suivantes s'appliquent à toutes les fiches.

1. Les deux messages $m_1$ et $m_2$ d'une paire sont **tous deux compatibles** avec le contexte et avec le résultat de vérification. Aucun élément du dossier remis ne permet de les distinguer par une lecture honnête.
2. Le message $m$ n'apparaît jamais en clair dans le dossier remis. Pour une signature, le dossier montre le condensé signé et non le texte. Pour un chiffré ou une preuve à divulgation nulle, il montre le chiffré ou la preuve et les entrées publiques.
3. Les quatre variantes ont la même présentation (mise en page, longueur, résultat de vérification). Elles ne diffèrent que par les valeurs cryptographiques.
4. Les valeurs sont produites par une implémentation de référence documentée en partie 3. Les clés, graines et aléas sont conservés hors du dossier remis, avec la vérité terrain (jeu D7 du [plan de gestion des données](../../00_commun/plan_gestion_donnees_fr.md)). Ils ne sont publiés qu'après la clôture de toute collecte qui utilise le même jeu de stimuli.
5. Le contexte ne cite aucune personne, aucune institution ni aucune affaire réelle. Les noms sont fictifs et le signalent.
6. Une anomalie volontaire, lorsqu'il y en a une, figure dans la description de la situation (par exemple un horodatage postérieur à la clôture) et jamais dans la pièce cryptographique. La vérification de la preuve réussit toujours. La notice d'information annonce ces anomalies et le débriefing les explique.

---

## 1. Identification

| Champ | Valeur |
|---|---|
| Code de la paire (`id_stimulus`) | `___-C__` |
| Type de preuve (`type_preuve`) | ☐ ECD ☐ HEL ☐ G16 ☐ PSS ☐ EGC |
| Domaine (contrôle Q28) | ☐ 1 contrat ☐ 2 élection ☐ 3 contrôle financier ☐ 4 autre |
| Gabarit d'espace de verdicts | ☐ A acte ☐ B vote ☐ C contrôle financier |
| Bloc de rotation | ☐ C01–C02 ☐ C03–C04 ☐ C05–C06 ☐ C07–C08 ☐ C09–C10 |
| Version de la fiche | `v__` du ___ / ___ / ______ |
| Rédacteur, relecteur juridique, relecteur cryptographique | `____` / `____` / `____` |

## 2. Messages engagés (vérité terrain, ne pas diffuser)

| Code (`id_message_m`) | Contenu de $m$ | Ce qui distingue $m_1$ de $m_2$ |
|---|---|---|
| `___-C__-M1` | | |
| `___-C__-M2` | | |

Justifier en deux phrases que le contexte et le résultat de vérification sont compatibles avec chacun des deux messages.

______________________________________________________________________

## 3. Variantes de preuve

| Code (`id_preuve_sigma`) | Message | Valeur de $\sigma$ (format abrégé) | Graine ou aléa (référence D7) | Vérification |
|---|---|---|---|---|
| `___-C__-S1` | M1 | | `D7-____` | ☐ acceptée |
| `___-C__-S2` | M1 | | `D7-____` | ☐ acceptée |
| `___-C__-S3` | M2 | | `D7-____` | ☐ acceptée |
| `___-C__-S4` | M2 | | `D7-____` | ☐ acceptée |

Implémentation et paramètres : ______________________________ (bibliothèque, version, courbe ou module, fonction de hachage).

Affectation des variantes aux participants d'une strate qui voient la paire (une variante différente chacun) :

| Participant de la strate ayant reçu la paire | 1er | 2e | 3e | 4e |
|---|---|---|---|---|
| Variante | S__ | S__ | S__ | S__ |

## 4. Espace de verdicts

Recopier en Q01 du questionnaire les quatre libellés du gabarit coché en partie 1. Ils peuvent être adaptés au cas d'espèce sans changer leur ordre ni leur sens **[libellés à arrêter par l'équipe]**.

| Code | Gabarit A (acte entre parties, domaines 1 et 4) | Gabarit B (élection ou vote, domaine 2) | Gabarit C (contrôle financier, domaine 3) |
|---|---|---|---|
| 1 | L'acte est établi et opposable à la partie désignée. | Le bulletin est retenu dans le décompte. | Conforme, sans suite. |
| 2 | L'acte est établi mais son opposabilité exige des éléments complémentaires. | Le bulletin est retenu sous réserve d'un contrôle. | Conforme sous réserve, demande d'informations. |
| 3 | L'acte n'est pas établi. | Le bulletin est écarté. | Non conforme, mesure corrective demandée. |
| 4 | La pièce est écartée comme irrégulière ou suspecte. | Le scrutin est contesté pour fraude présumée et renvoyé. | Non conforme, sanction ou signalement. |

Dans les trois gabarits, $|\mathcal{V}_{\text{glob}}| = 4$.

Verdicts de référence attendus pour chaque message (rempli par le gold standard, [grille](../grille_gold_standard_fr.md)) : M1 → ____ ; M2 → ____.

## 5. Dossier remis au participant

Le dossier tient sur deux pages au plus. Il comporte, dans cet ordre, les éléments suivants.

**5.1 Situation.** Description factuelle en 150 à 250 mots. Les parties, la chronologie, l'objet du litige ou du contrôle, la question posée à l'institution.

**5.2 Pièce cryptographique.** Présentation homogène pour les 50 paires.

| Élément | Contenu |
|---|---|
| Nature de la pièce | par exemple « signature électronique ECDSA P-256 » |
| Données publiques | clé publique ou certificat, entrées publiques, condensé signé, identifiant du scrutin |
| Valeur de la preuve | valeur hexadécimale abrégée (16 premiers et 16 derniers caractères), longueur en octets |
| Résultat de vérification | « Vérification réussie avec la clé publique indiquée » ou formulation équivalente |
| Horodatage éventuel | date et heure déclarées, avec leur source |

**5.3 Question posée.** Une phrase qui renvoie au questionnaire, par exemple « Quelle décision rendriez-vous sur la base de ce dossier ? ».

## 6. Contrôles avant impression

☐ Les deux messages sont compatibles avec le dossier (relecture juridique)
☐ Les quatre variantes sont acceptées par l'implémentation de référence (relecture cryptographique)
☐ Les quatre dossiers imprimés sont identiques hormis la valeur de la preuve
☐ Aucun nom, aucune institution ni aucune affaire réelle
☐ Pré-test effectué auprès de ____ personnes hors échantillon **[à arrêter par l'équipe]**

Licence CC BY 4.0.
