# Support de formation PQC (P5, phase 0)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.5.3, phase 0 (« introduction aux standards NIST PQC portant sur la structure des clés, le processus de signature et les différences avec RSA/ECDSA ; formation sur les implications institutionnelles de la transition post-quantique », 3 h)

[English version](support_formation_pqc_en.md) · [Protocole P5](protocole_fr.md) · [Formation de P1](../P1_delta/support_formation_phase0_fr.md)

Canevas de la formation et trame des diapositives. Les règles de neutralité de la [formation de P1](../P1_delta/support_formation_phase0_fr.md#1-principes-de-neutralité) s'appliquent. La formation ne s'appuie sur aucun exemple tiré des stimuli, ne donne aucune règle de décision et ne mentionne ni $\Delta_q$ ni les prédictions.

La formation suit la stratification de la thèse. Elle est identique pour les quatre strates. Les écarts de formation PQC antérieure entre strates sont précisément ce que la prédiction 5 met à l'épreuve. Les rendre égaux n'est pas le but.

## 1. Déroulement (3 h)

| Durée | Module | Contenu |
|---|---|---|
| 10 min | Ouverture | objectifs, règles de la journée, place de la formation dans l'étude |
| 25 min | M1. Pourquoi une transition | algorithme de Shor, menace sur RSA et ECDSA, principe « récolter maintenant, déchiffrer plus tard », calendrier de transition |
| 30 min | M2. Les normes NIST | FIPS 203 (ML-KEM, encapsulation de clé, ne produit pas de preuve), FIPS 204 (ML-DSA), FIPS 205 (SLH-DSA), niveaux de sécurité |
| 15 min | Pause | |
| 35 min | M3. Structure des clés et des signatures | tailles comparées (ECDSA P-256 64 octets, RSA-3072 384 octets, ML-DSA-65 3 309 octets, SLH-DSA-SHAKE-128f 17 088 octets), clé publique et clé privée, signature probabiliste |
| 25 min | M4. Processus de signature et de vérification | ce que vérifie le vérificateur, ce qu'il ne vérifie pas, mode hybride, gestion des certificats |
| 25 min | M5. Implications institutionnelles | archivage à long terme, valeur probante des signatures anciennes, migration des infrastructures, exigences réglementaires |
| 15 min | M6. Lecture d'un extrait technique | présentation commune des dossiers, exemple hors étude (signature d'un procès-verbal fictif de conseil d'administration) |

Les durées des modules sont des propositions **[à arrêter par l'équipe]**. La durée totale de 3 h est celle de la thèse.

## 2. Points clés

**M1.** Un ordinateur quantique suffisamment grand casserait RSA et ECDSA. Les signatures produites aujourd'hui avec ces schémas pourraient alors être contrefaites, ce qui pose la question de leur valeur probante future. Le calendrier exact de cette menace est incertain.

**M2.** Le NIST a publié en 2024 trois normes post-quantiques. Deux d'entre elles sont des schémas de signature, ML-DSA et SLH-DSA. La troisième, ML-KEM, sert à établir des clés et ne produit aucune preuve.

**M3.** Les signatures post-quantiques sont des chaînes de bits, comme les signatures classiques. Elles sont seulement plus longues. Comme pour ECDSA ou RSA-PSS, deux signatures d'un même document diffèrent.

**M4.** Une vérification réussie établit que la signature a été produite avec la clé privée correspondante, sur le document dont le condensé est indiqué. Elle ne dit rien de la personne qui détenait la clé ni du moment de la signature.

**M5.** La transition soulève des questions institutionnelles. Elles portent sur la durée de conservation des preuves, sur la coexistence de signatures classiques et post-quantiques et sur la charge de la preuve en cas de contestation d'une signature ancienne. Le module expose ces questions sans y répondre.

## 3. Ce que la formation ne présente pas

- La phase 2 et le vérificateur quantique simulé. Ils sont présentés au début de la phase 2, par la consigne de la [fiche des conditions](fiche_conditions_bruit_fr.md).
- Les fiches d'aide à l'interprétation de la phase 1, dont l'effet est mesuré.
- Toute valeur de $\Delta_q$, de $\eta_q$ ou de la décomposition $\Delta_q = \Delta + \delta_{\text{enh}} - \delta_{\text{degr}}$.

## 4. Contrôle de fidélité

☐ Diapositives identiques pour toutes les strates (version ____)
☐ Aucun exemple tiré des 12 paires
☐ Aucune présentation de la phase 2 ni des fiches d'aide
☐ Durée effective notée dans le [journal de séance](../00_commun/journal_session_fr.md)

Licence CC BY 4.0.
