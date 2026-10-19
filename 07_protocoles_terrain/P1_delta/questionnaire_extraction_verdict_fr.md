# Questionnaire d'extraction de verdict (P1)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.1.2 (« questionnaires de 30 items par contexte ») et §4.2.1.3, phase 1, étapes (c) et (d)

[English version](questionnaire_extraction_verdict_en.md) · [Protocole P1](protocole_fr.md) · [Dictionnaire des variables](../00_commun/dictionnaire_variables_fr.md)

Un exemplaire par participant et par contexte présenté, soit 10 exemplaires en phase 1 et 3 en phase 2. Le formulaire ne comporte aucun nom. Les codes des items (Q01 à Q30) sont ceux du dictionnaire des variables, jeu D4.

La thèse qualifie ce questionnaire de « validé ». La présente version n'a encore fait l'objet d'aucun pré-test. Le libellé des items, leur nombre par section et l'ordre des sections sont des propositions **[à arrêter par l'équipe après pré-test]**.

---

## Partie réservée à l'enquêteur

Ces champs sont remplis par l'enquêteur avant la remise du formulaire. Le participant ne les voit pas, à l'exception du code stimulus imprimé en en-tête.

| Champ | Valeur | Variable |
|---|---|---|
| Code participant | `P1-____-___` | `id_participant` |
| Phase | ☐ 1 séance principale ☐ 2 test-retest J+14 | `phase` |
| Séance | `S-____` | `id_session` |
| Enquêteur | `ENQ-__` | `id_enqueteur` |
| Stimulus (paire contexte–preuve) | `___-C__` | `id_stimulus` |
| Variante de preuve présentée | `___-C__-S_` | `id_preuve_sigma` |
| Message engagé (vérité terrain, **ne pas montrer**) | `___-C__-M_` | `id_message_m` |
| Rang de présentation dans la séance | ____ | `rang_presentation` |
| Domaine du stimulus (pour Q28) | ☐ 1 contrat ☐ 2 élection ☐ 3 contrôle financier ☐ 4 autre | contrôle de `q28_attention` |
| Heure de remise du contexte | __:__:__ | calcul de `temps_s` |
| Heure de remise du formulaire complété | __:__:__ | calcul de `temps_s` |

Le message engagé figure ici pour la saisie. Il est porté sur une étiquette détachable que l'enquêteur retire avant de remettre le formulaire au participant **[procédé à arrêter par l'équipe]**.

---

## Consignes au participant

Vous venez de lire un dossier composé d'une description de situation (le contexte) et d'une pièce cryptographique (la preuve). Répondez comme vous le feriez dans l'exercice de vos fonctions, en vous fondant uniquement sur le dossier et sur votre pratique professionnelle. Il n'y a pas de bonne ou de mauvaise réponse et vos réponses ne seront jamais rapportées à votre institution.

Pour les items Q02 à Q25, cochez une seule case par ligne.

- **1** signifie « pas du tout établi » et **7** « tout à fait établi ».
- **0** signifie « impossible à déterminer à partir du dossier ».

Ne revenez pas sur un contexte précédent. Lorsque vous avez terminé, retournez la feuille et levez la main.

---

## Section A. Verdict global

**Q01.** Si ce dossier vous était soumis dans vos fonctions, quelle décision prendriez-vous ? Cochez une seule réponse. Les quatre décisions possibles sont recopiées depuis la fiche stimulus et varient selon le domaine (gabarit A, B ou C de la [fiche stimulus](stimuli/gabarit_fiche_stimulus_fr.md#4-espace-de-verdicts)).

☐ 1 ______________________________________________
☐ 2 ______________________________________________
☐ 3 ______________________________________________
☐ 4 ______________________________________________

Variable `verdict_v`.

## Section B. Ce que la preuve établit

| Code | Item | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|---|---|
| Q02 | La pièce provient de la personne ou de l'organe désigné dans le dossier. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q03 | Le contenu couvert par la pièce n'a pas été modifié depuis qu'elle a été produite. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q04 | La pièce se rapporte bien à l'acte ou à l'opération décrit dans le contexte. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q05 | Le moment où l'acte a été accompli est établi. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q06 | L'auteur désigné ne pourrait pas utilement nier être à l'origine de la pièce. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q07 | L'auteur de la pièce était habilité à accomplir l'acte. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q08 | La pièce suffit, sans autre élément du dossier, à établir les faits qu'elle concerne. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q09 | Contrôle de lecture. Sur cette ligne, cochez la case 3. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |

## Section C. Ce que le dossier permet d'inférer

| Code | Item | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|---|---|
| Q10 | La volonté ou le consentement de l'auteur, au moment de l'acte, est établi. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q11 | L'acte respecte la règle applicable (clause contractuelle, code électoral, réglementation). | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q12 | Aucune substitution d'identité ou de clé n'a eu lieu. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q13 | La valeur en cause (montant, choix, quantité) est exacte. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q14 | Les informations que la pièce devait garder secrètes le sont restées. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q15 | L'acte n'a pas été accompli deux fois (double vote, double paiement, double engagement). | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q16 | Les procédures internes de l'institution émettrice ont été respectées. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q17 | Le contenu engagé par la pièce, qui n'apparaît pas en clair dans le dossier, peut être déduit. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q18 | Contrôle de lecture. Sur cette ligne, cochez la case 0. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |

## Section D. Portée institutionnelle

| Code | Item | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|---|---|
| Q19 | La pièce serait recevable devant votre institution. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q20 | La pièce a une force probante suffisante pour fonder une décision. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q21 | La charge de la preuve contraire pèserait sur la partie qui conteste la pièce. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q22 | Un précédent ou une pratique établie de votre institution s'applique à ce cas. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q23 | La pièce résisterait à une contestation technique devant votre institution. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q24 | La pièce a modifié la décision que vous auriez prise sans elle. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| Q25 | Un collègue de votre institution aboutirait à la même décision que vous. | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |

Tous les items Q02 à Q25 sont formulés dans le même sens. Aucun recodage n'est nécessaire pour le score moyen utilisé par l'ICC test-retest ([plan d'analyse](../00_commun/plan_analyse_statistique_fr.md), section 7).

## Section E. Confiance et éléments mobilisés

**Q26.** Quel est votre degré de confiance dans la décision donnée en Q01 ? Entourez un nombre (0 aucune confiance, 10 certitude complète).

0 — 1 — 2 — 3 — 4 — 5 — 6 — 7 — 8 — 9 — 10

Variable `confiance_0_10`.

**Q27.** Dans votre décision, quelle part revient à la pièce cryptographique plutôt qu'au reste du dossier ? (0 aucune part, 10 décision entièrement fondée sur la pièce)

0 — 1 — 2 — 3 — 4 — 5 — 6 — 7 — 8 — 9 — 10

Variable `q27_apport_preuve`.

**Q28.** Sans revenir au dossier, à quel domaine se rapportait la situation ?

☐ 1 un contrat ou un acte entre parties ☐ 2 une élection ou un vote ☐ 3 un contrôle financier ☐ 4 un autre domaine

Variable `q28_attention`. La réponse attendue est le domaine porté sur la fiche stimulus.

**Q29.** Pour rendre une décision définitive, solliciteriez-vous une expertise complémentaire ?

☐ 0 non ☐ 1 une expertise technique ☐ 2 une expertise juridique ☐ 3 les deux

Variable `q29_expertise`.

**Q30.** Sur quels éléments vous êtes-vous principalement appuyé ? Plusieurs réponses possibles.

☐ 1 la description de la situation
☐ 2 la pièce cryptographique elle-même (valeurs, formats)
☐ 3 le résultat de vérification indiqué dans le dossier
☐ 4 vos connaissances juridiques ou réglementaires
☐ 5 la pratique de votre institution
☐ 6 les notions vues lors de la formation (phase 0)
☐ 7 votre intuition ou votre expérience générale
☐ 8 autre : ______________________

Variable `q30_elements` (codes séparés par `;`).

---

## Règles de saisie et de contrôle

| Situation | Saisie |
|---|---|
| Une seule case cochée | code de la case |
| Aucune case cochée | cellule vide (non-réponse) |
| Plusieurs cases cochées sur Q01 à Q29 | cellule vide et mention dans `remarques` du journal de séance |
| Q09 différent de 3, Q18 différent de 0, Q28 différent du domaine | un échec chacun, cumulés dans `echecs_attention` |
| Au moins 2 échecs sur 3 pour ce contexte | `exclu = 1` (pré-enregistrement, section 8) |

Le temps `temps_s` est la différence, en secondes, entre l'heure de remise du formulaire complété et l'heure de remise du contexte. Il inclut la lecture du dossier, conformément à l'étape (d) de la phase 1.

## Correspondance avec les quantités de la thèse

- $V_{\text{glob}}$ est la réponse à Q01. $V$ est le vecteur (Q01, Q02 à Q25 hors Q09 et Q18), soit 23 composantes ([plan d'analyse](../00_commun/plan_analyse_statistique_fr.md), section 1).
- $|\mathcal{V}_{\text{glob}}| = 4$, ce qui donne $\log_2|\mathcal{V}_{\text{glob}}| = 2$ bits dans $\hat\alpha = \log_2|\mathcal{V}|/H(C)$. Le niveau de verdict retenu pour $\hat\alpha$ doit être fixé avant la collecte.
- Q17 vise directement l'extraction d'information sur le message engagé $m$. Il ne remplace pas l'estimateur $\hat\Delta = \hat I(V;\Sigma\mid M,C)$, qui est calculé à partir des réponses et de la vérité terrain.
- Q26 et `temps_s` servent à repérer les réponses données au hasard (thèse, §4.2.1.4).

Licence CC BY 4.0.
