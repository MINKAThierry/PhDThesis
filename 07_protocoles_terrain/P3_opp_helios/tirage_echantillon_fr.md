# Procédure de tirage de l'échantillon (P3)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.3.3, phase 3 (« échantillon aléatoire de 50 preuves (10 %) »)

[English version](tirage_echantillon_en.md) · [Protocole P3](protocole_fr.md)

Le tirage doit pouvoir être refait par toute personne qui dispose des données publiques. L'équipe de recherche ne doit pas pouvoir l'orienter. La procédure repose sur SHA-256 seulement. Elle peut être refaite avec n'importe quel outil standard.

## 1. Règle de tirage

1. **Liste des identifiants.** La liste des $N$ bulletins du tableau d'affichage à la clôture, chacun désigné par son empreinte publique (ou par son numéro d'ordre si l'instance électorale en attribue un), une par ligne. Cette liste est publiée.
2. **Graine.** La graine est la concaténation, séparée par `|`, de deux éléments publics, selon une règle fixée avant l'élection.
   - L'empreinte publiée du tableau d'affichage à la clôture, qui n'est connue de personne avant la clôture.
   - Cinq nombres de deux chiffres tirés publiquement au sort après la clôture, en présence d'un représentant de l'instance électorale (urne, dés à dix faces) **[procédé à arrêter]**.
3. **Clé de rang.** Pour chaque identifiant $x$, on calcule $\mathrm{SHA\text{-}256}(\text{graine} \,|\, x)$ en hexadécimal.
4. **Échantillon.** Les 50 identifiants dont la clé de rang est la plus petite, dans l'ordre lexicographique, forment l'échantillon. Ils sont ensuite mêlés aux preuves témoins puis présentés à chaque trustee dans un ordre qui lui est propre ([procédure des témoins](preuves_temoins_fr.md)).

La fonction `cro_terrain.sampling.draw_sample` applique cette règle.

```sh
python3 -m cro_terrain.sampling --seed "<empreinte>|<nombres tirés>" --ids identifiants.txt --k 50
```

## 2. Vérification manuelle (exemple)

Exemple avec une graine fictive et 10 identifiants `B001` à `B010`, échantillon de 3.

Graine : `EXEMPLE-empreinte-tableau|31 07 19 88 42`

```sh
printf '%s' 'EXEMPLE-empreinte-tableau|31 07 19 88 42|B009' | sha256sum
# 24ac8b891d5d5f812aa37a2e03fc2e45a68a33fd88ad03be89e56ba36cc0dfa0
```

| Rang | Identifiant | Clé de rang (SHA-256) |
|---|---|---|
| 1 | B009 | `24ac8b891d5d5f812aa37a2e03fc2e45a68a33fd88ad03be89e56ba36cc0dfa0` |
| 2 | B002 | `3e3698ff37b26928cf64d118e9998d8fdd5c110ecdd4b41892f22d25be38e3a1` |
| 3 | B010 | `4dde9d0f0a9e481b2292ce781c7c42f046282cc1fdc8fa321759d7e794000b99` |

Les sept autres identifiants ont une clé plus grande. Le séparateur `|` est inclus entre la graine et l'identifiant, sans espace ni retour à la ligne.

## 3. Procès-verbal de tirage

| Champ | Valeur |
|---|---|
| Date et lieu | ___ / ___ / ______ , __________ |
| Présents (équipe, instance électorale, trustees) | ______________________ |
| Nombre de bulletins $N$ au tableau d'affichage | ______ |
| Empreinte de la liste des identifiants publiée | `________________` |
| Empreinte du tableau d'affichage à la clôture | `________________` |
| Nombres tirés au sort | __ __ __ __ __ |
| Graine complète | `________________________________` |
| Taille de l'échantillon | 50 (10 % de 500 selon la thèse, ou ____ si $N$ diffère sensiblement) **[règle à arrêter]** |
| Outil utilisé et version | ______________________ |
| Vérification indépendante par un second outil | ☐ concordante ☐ discordante |

Liste des 50 identifiants tirés, avec leur clé de rang, annexée au procès-verbal.

Signatures

| Équipe de recherche | Instance électorale | Trustee témoin |
|---|---|---|
| | | |

## 4. Points de contrôle

☐ Règle de tirage et règle de formation de la graine communiquées à l'instance électorale avant l'élection
☐ Liste des identifiants publiée avant le tirage des nombres
☐ Échantillon recalculé par une seconde personne avec un autre outil
☐ Aucune modification de l'échantillon après le tirage

Licence CC BY 4.0.
