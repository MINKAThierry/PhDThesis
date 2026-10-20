# Spécification de l'interface de vérification post-quantique (P5)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.5.2 (« interface de vérification post-quantique avec métriques de performance », « simulateur d'environnement quantique avec bruit de dépolarisation paramétrable $p \in [0{,}001 ; 0{,}1]$ »)

[English version](specification_interface_verification_en.md) · [Protocole P5](protocole_fr.md)

Cahier des charges de l'application utilisée en phases 1 à 3. Aucune implémentation n'est fournie dans le dépôt. Les fonctions de référence pour le modèle de bruit et l'ordre des conditions sont dans `cro_terrain.p5`.

## 1. Principes

1. **Hors ligne.** L'application fonctionne sans réseau, sur des postes préparés par l'équipe.
2. **Aucune donnée identifiante.** Elle ne connaît que les codes participants.
3. **Vérification réelle en phase 1.** La vérification ML-DSA ou SLH-DSA est exécutée réellement avec une implémentation validée. Le résultat affiché est le résultat obtenu.
4. **Vérification simulée en phase 2.** Le résultat affiché est celui d'un vérificateur quantique simulé. L'écran l'indique en clair. Il s'agit d'un scénario hypothétique, car aucun vérificateur de ce type n'est déployé.
5. **Journalisation complète.** Chaque affichage, chaque réponse et chaque tirage aléatoire sont enregistrés avec leur horodatage.

## 2. Écrans

| Écran | Contenu | Phase |
|---|---|---|
| Accueil | saisie du code participant par l'enquêteur, choix de la phase, contrôle de la liste de rotation | toutes |
| Dossier | situation, extrait technique de la signature selon la présentation commune de P1 | 1, 2, 3 |
| Vérification | bouton « vérifier », puis résultat et métriques de performance | 1, 2, 3 |
| Réponse | questions Q1 et Q2 (et Q3 en phase 2) du [questionnaire](questionnaire_pqc_fr.md) | 1, 2, 3 |
| Aide | fiche d'aide du schéma, puis Q1' et Q2' | 1 |
| Pause | imposée toutes les 50 min, d'une durée de 10 min | 1, 2 |

## 3. Métriques de performance affichées

| Métrique | Phase 1 | Phase 2 |
|---|---|---|
| Schéma et jeu de paramètres | oui | oui |
| Taille de la clé publique et de la signature (octets) | oui | oui |
| Durée de vérification mesurée (ms) | oui | oui |
| Résultat de vérification | réel | simulé, avec la mention « vérificateur simulé » |
| Taux d'erreur du canal simulé ($p/2$) | non | **[à arrêter]**, affiché ou non |

## 4. Modèle de bruit (phase 2)

Le vérificateur simulé calcule d'abord le vrai résultat de vérification $r \in \{\text{réussie}, \text{échec}\}$. Il l'encode sur un qubit, $|0\rangle$ pour la réussite et $|1\rangle$ pour l'échec. Il applique ensuite un canal de dépolarisation $\rho \mapsto (1-p)\rho + p\,I/2$, puis mesure le qubit. Le résultat affiché est donc inversé avec la probabilité $p/2$ (`cro_terrain.p5.depolarizing_flip_probability`).

| Condition | $p$ (thèse) | Probabilité d'inversion $p/2$ |
|---|---|---|
| A | 0 | 0 |
| B | 0,001 | 0,0005 |
| C | 0,01 | 0,005 |
| D | 0,1 | 0,05 |

Le tirage utilise un générateur pseudo-aléatoire initialisé par une graine propre à la séance, consignée dans le journal. La fonction `p5.noisy_verification_result(true_result, p, rng)` donne le comportement de référence.

Ce modèle est une proposition minimale. Le simulateur de P6 (`cro_terrain.quantum`) permet de remplacer ce canal par un autre (déphasage, amortissement) ou d'encoder le résultat sur plusieurs qubits **[à arrêter par l'équipe]**.

## 5. Ordre de présentation

- Phase 1. Liste de rotation du participant (catalogue, section 1). L'ordre des items est tiré au hasard dans chaque bloc de schéma.
- Phase 2. Quatre blocs de 3 items, un par condition, dans l'ordre de Williams du participant (`p5.latin_square_order`). Chacune des 4 conditions occupe une fois chaque rang sur 4 participants consécutifs. Chaque condition en précède une fois chacune des autres.

## 6. Journal exporté

Un fichier CSV par séance, au format du [gabarit](gabarit_sessions_pqc_fr.csv), plus un fichier de traces.

| Trace | Contenu |
|---|---|
| `graine` | graine du générateur de la séance |
| `affichages` | horodatage, item, condition, vrai résultat, résultat affiché |
| `reponses` | horodatage de chaque réponse, valeur, écran |
| `incidents` | interruptions, retours en arrière refusés, erreurs logicielles |

## 7. Tests d'acceptation avant la collecte

☐ Les 48 signatures du jeu de stimuli sont acceptées en phase 1. Aucune ne l'est sur l'autre message
☐ Sur 100 000 tirages simulés, la fréquence d'inversion observée est compatible avec $p/2$ pour chaque condition
☐ L'ordre des conditions respecte le plan de Williams
☐ Le CSV exporté est lu sans erreur par `cro_terrain.templates.read_template(..., "p5_sessions")`
☐ Le premier verdict n'est plus modifiable après l'affichage de l'aide

Licence CC BY 4.0.
