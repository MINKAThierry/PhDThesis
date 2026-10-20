# Modèle de convention avec l'instance électorale (P3)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.3 (système cible et procédure) et §4.2.8.3 (accord institutionnel préalable)

[English version](modele_convention_scrutin_en.md) · [Protocole P3](protocole_fr.md) · [Convention institutionnelle générale](../00_commun/convention_institution_partenaire_fr.md)

Ce modèle complète la convention institutionnelle générale. Il règle les points propres à un scrutin réel. Il doit être relu par l'instance électorale, par la direction de l'ENSP et par le comité d'éthique **[à arrêter par l'équipe]**.

---

**Entre**

L'instance électorale chargée de l'élection des délégués étudiants de l'ENSP, représentée par ______________________, ci-après « l'instance électorale »,

**et**

L'équipe de recherche du LIMSI (ENSP, Université de Yaoundé I), représentée par ______________________, ci-après « l'équipe de recherche ».

## Article 1. Objet

La présente convention organise l'audit, à des fins de recherche, des preuves cryptographiques produites lors de l'élection des délégués étudiants de l'ENSP du ___ / ___ / ______ conduite avec le système Helios. L'audit vise à mesurer l'opposabilité empirique de ces preuves (thèse, §4.2.3).

## Article 2. Séparation des rôles

1. L'instance électorale organise l'élection, choisit et configure l'instance Helios, désigne les détenteurs de clé et proclame les résultats selon ses propres règles.
2. L'équipe de recherche ne participe ni à l'organisation de l'élection, ni au dépouillement, ni à la proclamation. Elle ne reçoit aucune part de clé de déchiffrement.
3. L'audit de recherche commence après la proclamation des résultats. Ses verdicts sont des données de recherche. Ils ne constituent ni une réclamation, ni un recours, ni un avis sur la régularité du scrutin.

## Article 3. Données communiquées à l'équipe de recherche

| Donnée | Communiquée | Remarque |
|---|---|---|
| Tableau d'affichage public (bulletins chiffrés, preuves, empreintes) | oui | données déjà publiques dans Helios |
| Empreinte publiée du tableau d'affichage à la clôture | oui | sert à la graine du tirage |
| Résultats proclamés | oui | publics |
| Liste électorale, identité ou alias des votants | **non** | |
| Parts de clé, choix déchiffrés individuellement | **non** | |
| Journaux techniques du serveur | ☐ oui ☐ non | **[à arrêter]**, sans adresse IP ni identifiant de votant |

Lorsque le tableau d'affichage associe un alias de votant à un bulletin, l'instance électorale remplace cet alias par un numéro d'ordre avant la transmission, ou l'équipe le supprime dès réception **[à arrêter]**.

## Article 4. Preuves témoins

L'instance électorale est informée que l'équipe ajoute à l'échantillon audité 10 preuves témoins, copies altérées de bulletins publics du même scrutin ([procédure](preuves_temoins_fr.md)). Ces copies n'existent que dans le jeu d'audit de recherche. Elles ne sont jamais déposées sur l'instance Helios ni transmises à quiconque comme bulletins.

## Article 5. Tirage de l'échantillon

Le tirage des 50 preuves est public. Il a lieu en présence d'au moins un représentant de l'instance électorale, selon la [procédure de tirage](tirage_echantillon_fr.md). La procédure et la règle de formation de la graine sont communiquées à l'instance électorale avant l'élection.

## Article 6. Anomalie réelle constatée

Si un trustee constate, sur une preuve tirée du tableau d'affichage et non sur une preuve témoin, une anomalie qu'il estime réelle, l'équipe de recherche en informe l'instance électorale par écrit dans un délai de ____ jours ouvrables. L'information mentionne la preuve concernée et le constat technique, sans aucune appréciation sur la régularité du scrutin. La suite éventuelle relève de la seule instance électorale.

## Article 7. Trustees

Les trustees qui participent à l'audit de recherche donnent leur consentement individuel. Ils peuvent se retirer à tout moment sans conséquence ([notice](../00_commun/notice_information_consentement_fr.md)). Leur participation ou leur retrait n'a aucune incidence sur leurs éventuelles fonctions dans l'élection.

## Article 8. Publication

Les résultats sont publiés sous forme agrégée. Ils ne permettent d'identifier ni un votant, ni un trustee, ni un bulletin autrement que par son empreinte publique. L'instance électorale reçoit le projet de publication ____ jours avant sa soumission et peut signaler toute erreur factuelle. Elle ne dispose d'aucun droit de veto sur les conclusions scientifiques.

## Article 9. Durée

La convention prend effet à sa signature et prend fin à la publication des résultats, au plus tard ____ mois après l'élection.

Fait à Yaoundé, le ___ / ___ / ______, en deux exemplaires.

| Pour l'instance électorale | Pour l'équipe de recherche |
|---|---|
| Nom, fonction, signature | Nom, fonction, signature |
| | |

Licence CC BY 4.0.
