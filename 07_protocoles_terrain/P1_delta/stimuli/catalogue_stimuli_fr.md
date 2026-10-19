# Catalogue des 50 paires contexte–preuve (P1)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.1.2 (« 5 types de preuves, 10 contextes standardisés par type, soit 50 paires contexte–preuve »)

[English version](catalogue_stimuli_en.md) · [Gabarit de fiche stimulus](gabarit_fiche_stimulus_fr.md) · [Protocole P1](../protocole_fr.md)

La thèse fixe le nombre de types de preuve, le nombre de contextes et leurs domaines (contractuels, électoraux, financiers). Les 50 situations ci-dessous sont des propositions. Deux d'entre elles sont rédigées en entier (section 3), avec des valeurs cryptographiques réelles et reproductibles. Les 48 autres restent à rédiger selon le [gabarit](gabarit_fiche_stimulus_fr.md) **[à arrêter par l'équipe]**.

Toutes les situations sont fictives. Elles ne citent aucune personne, aucune institution ni aucune affaire réelle.

## 1. Répartition

| Type | Schéma | Contrat (1) | Élection (2) | Contrôle financier (3) | Autre (4) |
|---|---|---|---|---|---|
| ECD | ECDSA P-256 | 6 | 1 | 3 | 0 |
| HEL | Helios (ElGamal exponentiel et preuves à divulgation nulle) | 0 | 10 | 0 | 0 |
| G16 | Groth16 sur BN254 | 2 | 1 | 7 | 0 |
| PSS | RSA-PSS 3072 bits | 5 | 0 | 3 | 2 |
| EGC | ElGamal classique, sans preuve de validité | 3 | 3 | 3 | 1 |
| **Total** | | **16** | **15** | **16** | **3** |

Le domaine conditionne le gabarit d'espace de verdicts (A pour les domaines 1 et 4, B pour le domaine 2, C pour le domaine 3) et la réponse attendue à l'item de contrôle Q28.

La répartition n'est pas équilibrée entre types, car chaque schéma a ses usages institutionnels propres (Helios est un système de vote). L'effet du domaine et celui du type de preuve sont donc partiellement confondus. Le plan d'analyse traite le type de preuve comme facteur principal et rapporte le domaine à titre descriptif **[à arrêter par l'équipe]**.

## 2. Liste des paires

Colonnes. **Dom.** code du domaine. **Esp.** gabarit d'espace de verdicts. **M1 / M2** les deux messages engagés, connus de l'expérimentateur seul.

### 2.1 ECDSA (`ECD`)

| Code | Dom. | Esp. | Situation | M1 / M2 |
|---|---|---|---|---|
| ECD-C01 | 1 | A | Bail commercial signé électroniquement, le preneur conteste la clause de révision du loyer (**rédigée en entier, §3.1**) | version A (révision 3 %) / version B (révision 8 %) |
| ECD-C02 | 1 | A | Avenant à un contrat de fourniture, date d'effet contestée | effet au 1er mars / effet au 1er juin |
| ECD-C03 | 1 | A | Reconnaissance de dette signée depuis une application mobile | montant 2 M FCFA / montant 5 M FCFA |
| ECD-C04 | 1 | A | Bon de commande signé par l'ordonnateur d'un établissement public | quantité 200 / quantité 2 000 |
| ECD-C05 | 1 | A | Mandat de représentation signé à distance | mandat spécial / mandat général |
| ECD-C06 | 3 | C | Ordre de virement signé par le client d'une banque, fraude alléguée | bénéficiaire habituel / nouveau bénéficiaire |
| ECD-C07 | 3 | C | Attestation de conformité signée par un responsable de la conformité | aucune réserve / réserve sur un client |
| ECD-C08 | 3 | C | Rapport d'audit interne signé, version déposée contestée | opinion sans réserve / opinion avec réserve |
| ECD-C09 | 2 | B | Procès-verbal de bureau de vote signé par le président du bureau | 312 votants / 321 votants |
| ECD-C10 | 1 | A | Ordre de cession de cryptoactifs signé depuis un portefeuille | cession partielle / cession totale |

### 2.2 Helios (`HEL`)

| Code | Dom. | Esp. | Situation | M1 / M2 |
|---|---|---|---|---|
| HEL-C01 | 2 | B | Élection pilote des représentants d'un ordre professionnel, un bulletin est contesté au dépouillement (**rédigée en entier, §3.2**) | liste 1 / liste 2 |
| HEL-C02 | 2 | B | Élection des délégués du personnel d'une entreprise | candidat A / candidat B |
| HEL-C03 | 2 | B | Élection du bureau d'une chambre consulaire | liste 1 / liste 2 |
| HEL-C04 | 2 | B | Vote d'une résolution en assemblée générale d'actionnaires | pour / contre |
| HEL-C05 | 2 | B | Consultation locale pilote | oui / non |
| HEL-C06 | 2 | B | Élection au conseil d'une université | collège A / collège B |
| HEL-C07 | 2 | B | Bulletin déposé au titre d'une procuration contestée | liste 1 / liste 2 |
| HEL-C08 | 2 | B | Bulletin horodaté après la clôture annoncée du scrutin | pour / contre |
| HEL-C09 | 2 | B | Vote du conseil d'administration d'une coopérative | candidat A / candidat B |
| HEL-C10 | 2 | B | Élection du conseil syndical d'une copropriété | liste 1 / liste 2 |

### 2.3 Groth16 (`G16`)

| Code | Dom. | Esp. | Situation | M1 / M2 |
|---|---|---|---|---|
| G16-C01 | 3 | C | Preuve qu'une opération reste sous le seuil de déclaration LBC/FT sans en révéler le montant | 4,2 M FCFA / 4,9 M FCFA |
| G16-C02 | 3 | C | Preuve de solvabilité d'un établissement de microfinance (actifs ≥ passifs) | marge de 2 % / marge de 15 % |
| G16-C03 | 3 | C | Preuve de réserves d'une plateforme de cryptoactifs | couverture 101 % / couverture 140 % |
| G16-C04 | 3 | C | Preuve qu'un revenu déclaré appartient à une tranche fiscale | bas de tranche / haut de tranche |
| G16-C05 | 2 | B | Preuve d'éligibilité d'un électeur sans révélation d'identité | inscrit bureau 12 / inscrit bureau 47 |
| G16-C06 | 1 | A | Preuve de majorité civile d'un cocontractant | 19 ans / 43 ans |
| G16-C07 | 3 | C | Preuve du respect d'un ratio prudentiel | ratio 8,1 % / ratio 12,4 % |
| G16-C08 | 3 | C | Preuve de non-appartenance à une liste de sanctions | client ancien / client récent |
| G16-C09 | 1 | A | Preuve de capacité financière d'un soumissionnaire à un marché public | 1,1 fois le seuil / 3 fois le seuil |
| G16-C10 | 3 | C | Preuve d'exactitude d'un agrégat statistique transmis au régulateur | agrégat issu de 40 entités / de 400 entités |

### 2.4 RSA-PSS (`PSS`)

| Code | Dom. | Esp. | Situation | M1 / M2 |
|---|---|---|---|---|
| PSS-C01 | 1 | A | Contrat de travail signé avec un certificat qualifié, clause de non-concurrence contestée | sans clause / avec clause |
| PSS-C02 | 1 | A | Acte de cession de parts sociales | 30 % des parts / 51 % des parts |
| PSS-C03 | 1 | A | Facture électronique signée, montant contesté | 1,8 M FCFA / 8,1 M FCFA |
| PSS-C04 | 3 | C | Déclaration réglementaire périodique transmise au régulateur | déclaration initiale / déclaration rectificative |
| PSS-C05 | 3 | C | Relevé de compte signé par la banque, produit comme pièce | solde créditeur / solde débiteur |
| PSS-C06 | 1 | A | Offre signée dans un marché public | offre de base / offre avec variante |
| PSS-C07 | 4 | A | Décision administrative individuelle signée par une autorité | autorisation / refus |
| PSS-C08 | 3 | C | États financiers certifiés signés par un commissaire aux comptes | certification pure / certification avec observation |
| PSS-C09 | 1 | A | Procuration bancaire signée | procuration limitée / procuration générale |
| PSS-C10 | 4 | A | Acte d'état civil numérique signé par un officier d'état civil | acte original / acte rectifié |

### 2.5 ElGamal classique (`EGC`)

| Code | Dom. | Esp. | Situation | M1 / M2 |
|---|---|---|---|---|
| EGC-C01 | 1 | A | Offre de prix scellée dans un appel d'offres | 96 M FCFA / 104 M FCFA |
| EGC-C02 | 1 | A | Enchère scellée pour la cession d'un actif | 12 M FCFA / 15 M FCFA |
| EGC-C03 | 2 | B | Bulletin chiffré sans preuve de validité dans un scrutin associatif | candidat A / candidat B |
| EGC-C04 | 2 | B | Vote secret d'un jury de sélection | admis / ajourné |
| EGC-C05 | 3 | C | Déclaration de patrimoine chiffrée remise à une autorité de contrôle | patrimoine stable / hausse de 40 % |
| EGC-C06 | 3 | C | Montant chiffré d'une opération signalée par un établissement | 9 M FCFA / 90 M FCFA |
| EGC-C07 | 1 | A | Clause de prix chiffrée d'un contrat-cadre | prix ferme / prix révisable |
| EGC-C08 | 2 | B | Vote chiffré d'une assemblée syndicale | grève / pas de grève |
| EGC-C09 | 3 | C | Déclaration chiffrée du bénéficiaire effectif d'une société | bénéficiaire résident / non-résident |
| EGC-C10 | 4 | A | Pièce chiffrée placée sous séquestre sur décision de justice | pièce intégrale / pièce partielle |

## 3. Paires rédigées en entier

Les valeurs ont été produites par [generer_exemples.py](generer_exemples.py), qui les recalcule bit à bit à partir d'étiquettes publiques. Les valeurs complètes figurent dans [exemples_stimuli.json](exemples_stimuli.json). Le script vérifie chaque signature et chaque preuve. Les signatures ECDSA sont en outre vérifiées par le paquet `cryptography`.

```sh
python3 generer_exemples.py --check   # régénère et compare au fichier versionné
```

La dérivation des aléas à partir d'étiquettes publiques ne vaut que pour du matériel de stimulus. Un signataire réel ne doit jamais tirer ses aléas ainsi.

### 3.1 ECD-C01, bail commercial

**Partie interne (fiche stimulus, parties 1 à 4).**

| Champ | Valeur |
|---|---|
| Type, domaine, gabarit | ECD, 1 contrat, A |
| Bloc de rotation | C01–C02 |
| M1 | Version A du bail, révision annuelle du loyer de 3 % |
| M2 | Version B du bail, révision annuelle du loyer de 8 % |
| Clé publique (P-256, compressée) | `021a26a752f445f9…c8024d59f80cef31` |

| Variante | Message | Condensé SHA-256 signé | Signature $r\Vert s$ (64 octets, abrégée) |
|---|---|---|---|
| ECD-C01-S1 | M1 | `762129ae8337ec2c…5cf294973b9b066a` | `b233296db8a50f5c…8a092129c759739b` |
| ECD-C01-S2 | M1 | `762129ae8337ec2c…5cf294973b9b066a` | `01b44f2ecd89a24e…15a5405844cdd282` |
| ECD-C01-S3 | M2 | `0aa3d6973e53eb14…d139efce4b542838` | `fe8c70a679a764bb…493a01257d0492d6` |
| ECD-C01-S4 | M2 | `0aa3d6973e53eb14…d139efce4b542838` | `b065d819d8d316f3…4a41d82fcfac9a3a` |

Les deux messages sont compatibles avec le dossier. Le dossier ne reproduit pas le texte signé, seulement son condensé. Les deux parties produisent chacune une version imprimée différente. Aucune des deux versions imprimées n'est rattachée au condensé dans le dossier.

**Dossier remis au participant (partie 5), version S1.**

> **Situation.** La SARL FICTIVE (le preneur) occupe depuis deux ans un local commercial appartenant à la SCI FICTIVE (le bailleur). Le bail a été conclu à distance. Le gérant du preneur l'a signé avec une application de signature électronique fournie par le bailleur. Le bailleur applique depuis janvier une révision annuelle de 8 % du loyer. Le preneur soutient qu'il a signé une version prévoyant une révision de 3 % et produit un exemplaire imprimé en ce sens. Le bailleur produit un exemplaire imprimé portant 8 %. Les deux exemplaires imprimés ne comportent aucune signature manuscrite. Le bailleur verse aux débats l'extrait technique ci-dessous, issu de l'application de signature. Le preneur ne conteste pas avoir utilisé l'application à la date indiquée.
>
> **Pièce cryptographique.**
>
> | Élément | Contenu |
> |---|---|
> | Nature | Signature électronique ECDSA, courbe P-256, hachage SHA-256 |
> | Clé publique du signataire | `021a26a752f445f9…c8024d59f80cef31`, rattachée au gérant du preneur par l'application |
> | Condensé du document signé | `762129ae8337ec2c…5cf294973b9b066a` |
> | Signature (64 octets) | `b233296db8a50f5c…8a092129c759739b` |
> | Résultat de vérification | Vérification réussie avec la clé publique indiquée |
> | Horodatage | 14 mars, 10 h 42, déclaré par l'application du bailleur |
>
> **Question.** Quelle décision rendriez-vous, sur la base de ce dossier, quant à l'opposabilité au preneur de la clause de révision appliquée par le bailleur ?

Verdicts proposés en Q01 (gabarit A). 1 la clause est établie et opposable au preneur. 2 la clause est établie mais son opposabilité exige des éléments complémentaires. 3 la clause n'est pas établie. 4 la pièce est écartée comme irrégulière ou suspecte.

Les variantes S2, S3 et S4 ne diffèrent de S1 que par les lignes « Condensé » et « Signature ».

### 3.2 HEL-C01, bulletin contesté

**Partie interne (fiche stimulus, parties 1 à 4).**

| Champ | Valeur |
|---|---|
| Type, domaine, gabarit | HEL, 2 élection, B |
| Bloc de rotation | C01–C02 |
| M1 | Choix de la liste 1, vecteur chiffré $(1, 0)$ |
| M2 | Choix de la liste 2, vecteur chiffré $(0, 1)$ |
| Groupe | MODP 2048 bits, RFC 3526 groupe 14, $g = 2$ |
| Clé publique du scrutin | `1ae02c3ee997a986…c3be34dfea8ced10` |
| Preuves jointes | une preuve disjonctive « 0 ou 1 » par chiffré et une preuve « la somme vaut 1 » |

| Variante | Message | Empreinte du bulletin (SHA-256) | Premier chiffré, composante $\alpha$ (abrégée) |
|---|---|---|---|
| HEL-C01-S1 | M1 | `79f2c21343aef9a7…cb9a65fbe9fc2aed` | `2c99e85399b9fa96…7b3c14e96345000c` |
| HEL-C01-S2 | M1 | `31cca81374aac1cd…7db60c15ff257fe6` | `2d36ecfef5332147…6feef0a54fb17e40` |
| HEL-C01-S3 | M2 | `0378e343a5fad53e…68a0596ab1800bdc` | `3fc38671671fbf7f…2c1aec99b7723b06` |
| HEL-C01-S4 | M2 | `d74634a8b3ab9fe1…c20f44e092464c20` | `ab4acdfcd6172cfd…6723efd1d3e4f613` |

Les deux messages sont compatibles avec le dossier. Les chiffrés sont sémantiquement sûrs sous l'hypothèse DDH et les preuves ne révèlent rien du choix. Seul le dépouillement homomorphe, après déchiffrement collectif, renseigne sur la somme des choix.

**Dossier remis au participant (partie 5), version S1.**

> **Situation.** Un ordre professionnel fictif élit ses représentants par un scrutin électronique pilote de type Helios. Deux listes sont en présence. Après la clôture, la liste 2 conteste un bulletin déposé depuis le poste d'un membre qui affirme ne pas avoir voté. La commission électorale dispose du bulletin publié sur le tableau d'affichage public du scrutin et de son empreinte. Le membre reconnaît avoir reçu ses identifiants de vote mais déclare les avoir confiés à un collègue pour une vérification technique. Le résultat définitif dépend de ce bulletin, car l'écart entre les listes est d'une voix.
>
> **Pièce cryptographique.**
>
> | Élément | Contenu |
> |---|---|
> | Nature | Bulletin chiffré (ElGamal exponentiel, groupe de 2048 bits) avec preuves à divulgation nulle de validité |
> | Clé publique du scrutin | `1ae02c3ee997a986…c3be34dfea8ced10` |
> | Empreinte du bulletin | `79f2c21343aef9a7…cb9a65fbe9fc2aed` |
> | Chiffrés | deux paires $(\alpha, \beta)$ de 2048 bits chacune, une par liste |
> | Résultat de vérification | Les trois preuves de validité sont acceptées. Le bulletin contient exactement un choix. |
> | Horodatage | dépôt 2 h 15 avant la clôture, selon le tableau d'affichage |
>
> **Question.** Quelle décision rendriez-vous sur ce bulletin ?

Verdicts proposés en Q01 (gabarit B). 1 le bulletin est retenu dans le décompte. 2 le bulletin est retenu sous réserve d'un contrôle. 3 le bulletin est écarté. 4 le scrutin est contesté pour fraude présumée et renvoyé.

Ce stimulus illustre la prédiction 4 du protocole ($\hat\Delta_{\text{ECDSA}} > \hat\Delta_{\text{Helios}}$). La pièce Helios ne porte, par construction, aucune information sur le choix, alors que la pièce ECDSA est attachée au contenu signé par son condensé.

## 4. Contrôles avant la collecte

☐ 48 fiches restantes rédigées selon le gabarit
☐ Relecture juridique et cryptographique de chaque fiche
☐ Valeurs des 200 variantes produites et vérifiées par un script versionné
☐ Gold standard établi sur les 50 paires ([grille](../grille_gold_standard_fr.md))
☐ Pré-test du dossier et du questionnaire hors échantillon

Licence CC BY 4.0 pour les textes, MIT pour le script.
