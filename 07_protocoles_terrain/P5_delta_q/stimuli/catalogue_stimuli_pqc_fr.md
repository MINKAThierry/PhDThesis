# Catalogue des 12 paires contexte–signature post-quantique (P5)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.5.2 (ML-DSA, SLH-DSA, contextes de transaction, de document et de conformité)

[English version](catalogue_stimuli_pqc_en.md) · [Protocole P5](../protocole_fr.md) · [Gabarit de fiche stimulus (P1)](../../P1_delta/stimuli/gabarit_fiche_stimulus_fr.md)

Les fiches stimulus de P5 suivent le [gabarit de P1](../../P1_delta/stimuli/gabarit_fiche_stimulus_fr.md) et ses six règles de construction. Deux messages compatibles avec le dossier, deux signatures par message, la même présentation pour les quatre variantes, aucun nom réel. Le domaine et le gabarit d'espace de verdicts suivent les mêmes codes. La thèse cite trois types de contexte (transaction, document, conformité). La proposition en retient deux par schéma.

## 1. Liste des paires

Codes `MLD` pour ML-DSA-65 (FIPS 204) et `SLH` pour SLH-DSA-SHAKE-128f (FIPS 205).

| Code | Type de contexte | Dom. | Esp. | Situation | M1 / M2 |
|---|---|---|---|---|---|
| MLD-C01 | transaction | 3 | C | Ordre de virement signé par un établissement, bénéficiaire contesté (**rédigée en entier, §3.1**) | compte 0042 / compte 0917 |
| MLD-C02 | transaction | 3 | C | Ordre de cession de titres signé par un intermédiaire agréé | 1 000 titres / 10 000 titres |
| MLD-C03 | document | 1 | A | Contrat de prestation signé par une administration | durée 1 an / durée 3 ans |
| MLD-C04 | document | 4 | A | Décision d'agrément signée par un régulateur | agrément simple / agrément avec conditions |
| MLD-C05 | conformité | 3 | C | Rapport de contrôle interne signé et transmis au régulateur | aucune anomalie / deux anomalies |
| MLD-C06 | conformité | 3 | C | Déclaration de soupçon horodatée et signée | montant 5 M FCFA / 50 M FCFA |
| SLH-C01 | conformité | 3 | C | Attestation annuelle de conformité LBC/FT signée (**rédigée en entier, §3.2**) | sans réserve / réserve sur deux clients |
| SLH-C02 | conformité | 3 | C | Certificat de solvabilité signé par un commissaire aux comptes | ratio conforme / ratio limite |
| SLH-C03 | document | 1 | A | Acte notarié numérique archivé pour longue durée | clause de réméré / sans clause |
| SLH-C04 | document | 4 | A | Archive signée d'un registre foncier | parcelle A / parcelle B |
| SLH-C05 | transaction | 3 | C | Mise à jour de micrologiciel d'un terminal de paiement signée | version 4.1 / version 4.2 |
| SLH-C06 | transaction | 1 | A | Bon de livraison signé d'un marché public | livraison complète / livraison partielle |

SLH-DSA est souvent proposé pour l'archivage à long terme et la signature de micrologiciels, d'où le choix des contextes `SLH-C03` à `SLH-C05` **[à arrêter par l'équipe]**.

Rotation proposée en phase 1. Chaque participant voit 3 paires `MLD` et 3 paires `SLH` (blocs C01–C03 ou C04–C06 pour chaque schéma, croisés selon le participant). Chaque paire est vue par 40 participants, soit 10 par strate, répartis sur les 4 variantes.

## 2. Valeurs cryptographiques

[generer_signatures_pqc.py](generer_signatures_pqc.py) produit les clés et les signatures des deux paires rédigées. Les valeurs complètes sont dans [exemples_signatures_pqc.json](exemples_signatures_pqc.json).

```sh
pip install dilithium-py==1.4.0 slh-dsa==0.2.5
python3 generer_signatures_pqc.py --check   # vérifie les 8 signatures et leur distinction
```

Les deux schémas sont probabilistes. ML-DSA est utilisé en mode « hedged » et SLH-DSA en mode randomisé. Les signatures dépendent donc d'un aléa frais. Le fichier n'est pas reproductible bit à bit. L'option `--check` vérifie chaque signature avec sa clé publique et son message. Elle vérifie aussi qu'aucune signature n'est acceptée sur l'autre message et que les quatre variantes d'une paire sont distinctes.

Les bibliothèques utilisées sont des implémentations pédagogiques en Python. Elles ne sont pas auditées. Pour la collecte réelle, les signatures seront produites par une implémentation validée **[à arrêter par l'équipe]**.

## 3. Paires rédigées en entier

### 3.1 MLD-C01, ordre de virement

| Champ | Valeur |
|---|---|
| Schéma | ML-DSA-65 (FIPS 204), clé publique de 1 952 octets, signature de 3 309 octets |
| Clé publique (abrégée) | `6fd066757ef7d468…1727f168c48e1985` |
| M1 | ordre de virement de 12 500 000 FCFA vers le compte 0042 |
| M2 | ordre de virement de 12 500 000 FCFA vers le compte 0917 |

| Variante | Message | Condensé SHA-256 du document | Début de la signature |
|---|---|---|---|
| MLD-C01-S1 | M1 | `cf2b67e22029c500…9f22372c3dad1fc1` | `5fd9bbcefe2ce7c159194e4055c39750…` |
| MLD-C01-S2 | M1 | `cf2b67e22029c500…9f22372c3dad1fc1` | `0492287a065d9efd013d9e7a41c21547…` |
| MLD-C01-S3 | M2 | `be566d3543e83cf5…9271bd2a72b43455` | `795dd3650d0cde11ad6f241cc54c22da…` |
| MLD-C01-S4 | M2 | `be566d3543e83cf5…9271bd2a72b43455` | `1e6043d70c0a57d3ec0a67ff80a0f116…` |

**Dossier remis au participant (version S1).**

> **Situation.** Un établissement de paiement fictif a exécuté un virement de 12 500 000 FCFA ordonné par une entreprise cliente. Le client soutient que l'ordre qu'il a signé désignait un autre compte bénéficiaire que celui qui a été crédité. L'établissement produit l'extrait technique ci-dessous. Depuis l'année dernière, ses ordres sont signés avec un schéma post-quantique normalisé. Le régulateur est saisi d'une réclamation du client.
>
> | Élément | Contenu |
> |---|---|
> | Nature | Signature numérique ML-DSA-65 (FIPS 204) |
> | Clé publique du client | `6fd066757ef7d468…1727f168c48e1985` (1 952 octets), enregistrée lors de l'ouverture du compte |
> | Condensé SHA-256 de l'ordre signé | `cf2b67e22029c500…9f22372c3dad1fc1` |
> | Signature | `5fd9bbcefe2ce7c1…` (3 309 octets) |
> | Résultat de vérification | Vérification réussie avec la clé publique indiquée |
>
> **Question.** Quelle décision rendriez-vous sur la réclamation du client ?

Verdicts proposés (gabarit C). 1 conforme, sans suite. 2 conforme sous réserve, demande d'informations. 3 non conforme, mesure corrective demandée. 4 non conforme, sanction ou signalement.

### 3.2 SLH-C01, attestation de conformité

| Champ | Valeur |
|---|---|
| Schéma | SLH-DSA-SHAKE-128f (FIPS 205), clé publique de 32 octets, signature de 17 088 octets |
| Clé publique | `f32fedadefa8b511…fdf71568855892e2` |
| M1 | attestation de conformité LBC/FT pour l'exercice 2025, sans réserve |
| M2 | même attestation, avec réserve sur deux clients |

| Variante | Message | Condensé SHA-256 du document | Début de la signature |
|---|---|---|---|
| SLH-C01-S1 | M1 | `cf2f5f89e8a510df…2eb8340b8088f257` | `0a0e888963b4055ff9ca8de21989fbac…` |
| SLH-C01-S2 | M1 | `cf2f5f89e8a510df…2eb8340b8088f257` | `67c02b1c357b964cd1508bba045055ed…` |
| SLH-C01-S3 | M2 | `b6003f8e7c6fe5c0…27db2815b973f4a1` | `fb9e64616e24aff01df7a2e5c6965d82…` |
| SLH-C01-S4 | M2 | `b6003f8e7c6fe5c0…27db2815b973f4a1` | `65f4356909527fdaf4e4d585d1b46d95…` |

Les dossiers montrent le **début** des signatures SLH-DSA. Leur fin peut en effet coïncider d'une signature à l'autre, car les couches hautes de l'hyper-arbre sont communes à toutes les signatures d'une même clé. Montrer la fin donnerait au participant un indice de structure sans rapport avec le message.

**Dossier remis au participant (version S1).**

> **Situation.** Une société de microfinance fictive doit remettre chaque année au régulateur une attestation de conformité LBC/FT signée par son responsable de la conformité. Lors d'un contrôle sur place, l'inspecteur constate que deux clients à risque élevé n'ont pas fait l'objet de la vigilance renforcée. La société affirme que l'attestation signée mentionnait déjà ces deux clients en réserve. L'exemplaire papier conservé par le régulateur a été égaré. Seul l'extrait technique ci-dessous est disponible.
>
> | Élément | Contenu |
> |---|---|
> | Nature | Signature numérique SLH-DSA-SHAKE-128f (FIPS 205) |
> | Clé publique du responsable de la conformité | `f32fedadefa8b511…fdf71568855892e2` (32 octets) |
> | Condensé SHA-256 de l'attestation signée | `cf2f5f89e8a510df…2eb8340b8088f257` |
> | Signature | `0a0e888963b4055f…` (17 088 octets) |
> | Résultat de vérification | Vérification réussie avec la clé publique indiquée |
>
> **Question.** Quelle décision rendriez-vous à l'égard de la société ?

Verdicts proposés (gabarit C), comme en 3.1.

## 4. Fiche d'aide à l'interprétation (remise en phase 1, après le premier verdict)

Une fiche par schéma, d'une page. Elle explique ce qu'établit une vérification réussie, sans dire quel verdict rendre.

**ML-DSA-65.** Schéma de signature fondé sur les réseaux euclidiens (problèmes MLWE et MSIS), normalisé par le NIST en 2024 (FIPS 204). Une vérification réussie établit que la signature a été produite avec la clé privée associée à la clé publique, sur le document dont le condensé est indiqué. Deux signatures d'un même document diffèrent, car un aléa est utilisé à chaque signature. La sécurité vise le niveau 3 du NIST et résiste aux attaques connues par ordinateur quantique.

**SLH-DSA.** Schéma de signature fondé sur les fonctions de hachage seules (FIPS 205). Les signatures sont longues, de l'ordre de 17 ko pour ce jeu de paramètres. Une vérification réussie établit la même chose que pour ML-DSA. Sa sécurité ne repose que sur celle de la fonction de hachage, d'où son usage pour l'archivage à long terme.

Pour les deux schémas, la vérification ne dit rien de la personne qui détenait la clé, ni du moment de la signature, ni du contenu d'un document dont on n'a que le condensé.

Licence CC BY 4.0 pour les textes, MIT pour le script.
