# Fiche d'audit d'une preuve (P3, phase 3)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.3.3, phase 3 (« chaque trustee examine indépendamment la preuve, rend un verdict $v \in \mathcal{V}$, note sa confiance sur 10 »)

[English version](fiche_audit_preuve_en.md) · [Protocole P3](protocole_fr.md)

Une fiche par trustee et par preuve, soit 60 fiches par trustee. Les fiches d'un trustee sont reliées dans l'ordre de présentation qui lui a été attribué. Le trustee remplit sa fiche seul, sans échanger avec les autres trustees.

## Consignes au trustee (lues en début de séance)

> « Vous allez examiner une série de bulletins publiés lors de l'élection. Pour chacun, vous disposez de son contenu (chiffrés, preuves, empreinte, horodatage) et de l'outil de vérification de l'instance Helios. Vous pouvez lancer la vérification, comparer les empreintes et consulter le tableau d'affichage. Indiquez ensuite la décision que vous recommanderiez à l'instance électorale pour ce bulletin, ainsi que votre confiance. La série peut contenir des bulletins que l'équipe a modifiés. Ne communiquez pas avec les autres trustees pendant la séance. Il n'y a pas de limite de temps par bulletin, mais la séance dure 3 h. »

---

| Champ | Valeur | Variable du gabarit |
|---|---|---|
| Séance | `S-____` | `id_session` |
| Trustee | `TR-__` | `id_trustee` |
| Preuve (identifiant d'audit) | `P-__` | `id_preuve` |
| Type de preuve | Helios, bulletin chiffré avec preuves de validité | `type_preuve = HEL` |
| Scrutin | `ENSP-______` | `id_contexte` |
| Rang dans la série du trustee | ____ / 60 | |
| Heure de début | __:__:__ | calcul de `temps_s` |

### 1. Contrôles effectués

Cochez ce que vous avez fait.

☐ Vérification des preuves « 0 ou 1 » de chaque chiffré ☐ acceptées ☐ rejetées ☐ non concluant
☐ Vérification de la preuve globale (le bulletin contient exactement un choix) ☐ acceptée ☐ rejetée ☐ non concluant
☐ Recalcul de l'empreinte du bulletin et comparaison avec le tableau d'affichage ☐ concordante ☐ discordante
☐ Recherche de doublons de l'empreinte dans le tableau d'affichage ☐ aucun ☐ doublon trouvé
☐ Contrôle de l'horodatage par rapport aux heures d'ouverture et de clôture ☐ conforme ☐ hors période
☐ Autre : ______________________

### 2. Verdict

Quelle décision recommanderiez-vous à l'instance électorale pour ce bulletin ? Une seule réponse.

| Code | Verdict | |
|---|---|---|
| 1 | Bulletin valide, retenu | ☐ |
| 2 | Bulletin invalide, écarté | ☐ |
| 3 | Vérification complémentaire ou recomptage demandé | ☐ |
| 4 | Investigation demandée | ☐ |

Variable `verdict`.

### 3. Confiance

Quel est votre degré de confiance dans ce verdict ? (0 aucune, 10 certitude complète)

0 — 1 — 2 — 3 — 4 — 5 — 6 — 7 — 8 — 9 — 10

Variable `confiance_0_10`.

### 4. Motif principal (facultatif, une ligne)

______________________________________________________________________

Heure de fin __:__:__

---

## Partie réservée au coordinateur (après l'audit)

| Champ | Valeur | Variable |
|---|---|---|
| Statut de la preuve d'après le registre | ☐ authentique ☐ témoin, type T_ | `statut_reference` |
| Durée (s) | ______ | `temps_s` |
| Incident ou remarque | ______________________ | `remarques` |

## Règles de saisie

Une ligne par fiche dans [gabarit_audit_preuves_fr.csv](gabarit_audit_preuves_fr.csv). Plusieurs cases cochées en section 2 donnent une cellule vide et une mention dans `remarques`. Les contrôles cochés en section 1 et le motif sont saisis dans `remarques`, codés par leur numéro de ligne (par exemple `C1:acc;C3:conc`) **[codage à arrêter]**.

Licence CC BY 4.0.
