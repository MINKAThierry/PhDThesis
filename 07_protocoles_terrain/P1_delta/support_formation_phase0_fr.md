# Support de formation de la phase 0 (P1)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.1.3, phase 0 (« introduction aux concepts cryptographiques de base sans révéler les mécanismes internes, afin d'homogénéiser le vocabulaire minimum », 2 h)

[English version](support_formation_phase0_en.md) · [Protocole P1](protocole_fr.md) · [Guide de l'enquêteur](guide_enqueteur_fr.md)

Ce document est le canevas de la formation et la trame des diapositives. Il fixe ce qui est dit et, surtout, ce qui ne l'est pas. La même formation est donnée, mot pour mot, à toutes les strates. L'enquêteur lit les encadrés « à dire » et ne les commente pas au-delà des réponses types de la section 9.

## 1. Principes de neutralité

La phase 0 sert à donner un vocabulaire commun. Elle ne doit pas changer ce que l'étude mesure, à savoir la capacité propre de chaque institution à tirer un verdict d'une preuve. Les règles suivantes en découlent.

1. **Aucun exemple tiré des stimuli.** Les exemples de la formation portent sur des situations sans rapport avec les 50 paires (un colis, un diplôme, une loterie).
2. **Aucune règle de décision.** On explique ce qu'est une vérification réussie. On ne dit jamais quelle décision juridique ou réglementaire en tirer.
3. **Aucun mécanisme interne.** Pas de formule, pas de courbe elliptique, pas de module RSA. Les schémas sont présentés par leur fonction (signer, chiffrer, prouver) et par leur résultat de vérification.
4. **Mêmes limites pour tous les schémas.** Chaque schéma reçoit le même temps de présentation et la même structure, pour ne favoriser aucun type de preuve.
5. **Aucune mention de $\Delta$, des prédictions ni des hypothèses.** L'objet précis de l'étude est expliqué au débriefing.

## 2. Déroulement (2 h)

| Durée | Module | Diapositives |
|---|---|---|
| 10 min | Accueil, objectifs de la formation, règles de la journée | 1–3 |
| 15 min | Module 1. Empreinte numérique (fonction de hachage) | 4–6 |
| 20 min | Module 2. Signature électronique, clé publique, certificat, horodatage | 7–11 |
| 15 min | Module 3. Chiffrement | 12–14 |
| 15 min | Module 4. Preuve à divulgation nulle de connaissance | 15–17 |
| 10 min | Pause | |
| 15 min | Module 5. Vote électronique vérifiable | 18–20 |
| 10 min | Module 6. Lire une pièce cryptographique dans un dossier | 21–23 |
| 10 min | Exercice de familiarisation sur un dossier fictif hors étude | 24–25 |
| 0 à 10 min | Questions (réponses types, section 9) | 26 |

Les durées des modules sont des propositions **[à arrêter par l'équipe]**. La durée totale de 2 h est celle de la thèse.

## 3. Module 1. Empreinte numérique

> **À dire.** Une fonction de hachage transforme un document de taille quelconque en une courte chaîne de caractères de longueur fixe, appelée empreinte ou condensé. Deux propriétés comptent ici. Si le document change, même d'une virgule, l'empreinte change. Retrouver le document à partir de l'empreinte seule est impossible en pratique.

Exemple de diapositive. L'empreinte SHA-256 de « Le colis 4521 a été livré le 3 mai » comparée à celle de « Le colis 4521 a été livré le 4 mai ». Les deux chaînes n'ont rien en commun.

Point à retenir. L'empreinte permet de vérifier qu'un document donné est bien celui qui a été traité. Elle ne dit pas ce que contient un document qu'on n'a pas sous les yeux.

## 4. Module 2. Signature électronique

> **À dire.** Une signature électronique est produite avec une clé privée, que seul le signataire détient. Elle est vérifiée avec la clé publique correspondante, que tout le monde peut connaître. Elle porte sur l'empreinte d'un document. Une vérification réussie établit deux choses. La signature a été produite avec la clé privée qui correspond à la clé publique utilisée pour vérifier. Le document dont on a l'empreinte n'a pas été modifié depuis. Le rattachement d'une clé publique à une personne passe par un certificat, délivré par une autorité de certification. L'heure d'une signature est établie par un horodatage, dont la fiabilité dépend de sa source.

Deux familles sont citées par leur nom, sans détail. ECDSA et RSA-PSS. Signer deux fois le même document donne deux signatures différentes, toutes deux valides.

Point à retenir. La vérification porte sur la clé, l'empreinte et la signature. La question de savoir qui détenait la clé et à quel moment relève du dossier.

## 5. Module 3. Chiffrement

> **À dire.** Chiffrer un contenu le rend illisible pour qui ne détient pas la clé de déchiffrement. Avec un chiffrement à clé publique, n'importe qui peut chiffrer, seul le détenteur de la clé privée peut déchiffrer. Chiffrer deux fois le même contenu donne deux chiffrés différents. À la seule vue d'un chiffré, on ne peut rien dire de son contenu.

Un schéma est cité par son nom, sans détail. ElGamal.

Point à retenir. Un chiffré seul ne prouve rien sur ce qu'il contient, à moins d'être accompagné d'une preuve (module 4).

## 6. Module 4. Preuve à divulgation nulle de connaissance

> **À dire.** Une preuve à divulgation nulle de connaissance permet de convaincre qu'une affirmation est vraie sans révéler les informations qui la rendent vraie. Par exemple « ce montant est inférieur au seuil » sans révéler le montant. Une vérification réussie établit que l'affirmation est vraie pour les données publiques indiquées, sous les hypothèses du système. Elle ne révèle pas les données secrètes.

Exemple de diapositive. Une loterie fictive prouve qu'un ticket gagnant fait partie des tickets vendus sans révéler son numéro.

Un système est cité par son nom, sans détail. Groth16, qui produit des preuves très courtes.

## 7. Module 5. Vote électronique vérifiable

> **À dire.** Dans un vote électronique vérifiable, chaque bulletin est chiffré. Une preuve jointe établit que le bulletin est bien formé (par exemple, qu'il contient exactement un choix) sans révéler ce choix. Les bulletins sont publiés sur un tableau d'affichage public. Le décompte est obtenu en combinant les chiffrés puis en déchiffrant seulement le total, sous le contrôle de plusieurs détenteurs de clés.

Un système est cité par son nom, sans détail. Helios.

Point à retenir. La vérification d'un bulletin établit qu'il est bien formé. Elle ne dit pas pour qui il a été déposé.

## 8. Module 6. Lire une pièce cryptographique dans un dossier

On présente la mise en page commune à tous les dossiers de l'étude, sur un exemple hors étude (une attestation de diplôme signée).

| Rubrique | Ce qu'elle contient |
|---|---|
| Nature | le type de pièce (signature, chiffré, preuve) |
| Données publiques | clé publique, certificat, empreinte, entrées publiques |
| Valeur de la preuve | une suite de caractères hexadécimaux, abrégée |
| Résultat de vérification | toujours indiqué par une phrase |
| Horodatage | date, heure et source déclarée |

> **À dire.** Dans tous les dossiers de l'étude, la vérification technique a été faite pour vous et son résultat est indiqué. Vous n'avez aucun calcul à faire. On vous demande la décision que vous prendriez dans vos fonctions.

**Exercice de familiarisation.** Les participants lisent l'attestation de diplôme signée et remplissent un questionnaire d'essai de 5 items, sur le modèle du questionnaire de l'étude. Les réponses ne sont ni ramassées ni commentées. L'exercice ne sert qu'à se familiariser avec l'échelle 0 à 7.

## 9. Réponses types aux questions fréquentes

| Question | Réponse type |
|---|---|
| « Que faut-il décider dans tel cas ? » | « Il n'y a pas de bonne réponse attendue. Répondez comme dans vos fonctions. » |
| « Une signature valide prouve-t-elle que la personne a signé ? » | « Elle prouve que la clé correspondante a servi. Le reste dépend du dossier. » |
| « Peut-on casser ces systèmes ? » | « Dans l'étude, vous pouvez considérer que les schémas sont utilisés correctement. » |
| « Pourquoi ces questions de contrôle ? » | « Elles servent à vérifier la qualité des réponses. Elles ne vous évaluent pas. » |
| Question technique détaillée | « Ce point dépasse la formation. Nous pourrons en parler au débriefing. » |

Toute question non prévue et sa réponse sont notées dans le [journal de séance](../00_commun/journal_session_fr.md).

## 10. Contrôle de fidélité

☐ Diapositives identiques pour toutes les séances (numéro de version : ____)
☐ Encadrés « à dire » lus sans ajout
☐ Aucun exemple tiré des 50 paires
☐ Durée effective notée dans le journal de séance

Licence CC BY 4.0.
