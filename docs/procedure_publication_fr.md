# Procédure de publication du dépôt

> **Statut : PROPOSITION — documentation du dépôt** · Source : décisions de l'auteur (dépôt privé jusqu'à la soutenance), [`../CITATION.cff`](../CITATION.cff), [`../.zenodo.json`](../.zenodo.json), écarts recensés dans la [correspondance](correspondance_these_depot_fr.md)

[English version](procedure_publication_en.md) · [Retour à docs](README_fr.md)

Le dépôt `MINKAThierry/PhDThesis` reste **privé jusqu'à la soutenance**. Ce document fixe l'ordre des opérations qui le rendent public, l'archivent sur Zenodo et reportent le DOI dans la thèse. Chaque étape se coche dans la liste de la section 8.

## 1. Avant la soutenance

1. Ajouter à la main dans `.github/workflows/ci.yml`, job `python`, les lignes qui n'y figurent pas encore. Ce fichier n'a pas pu être modifié à distance.

   ```yaml
   - run: pip install cryptography && cd 07_protocoles_terrain/P1_delta/stimuli && python generer_exemples.py --check
   - run: cd 07_protocoles_terrain/P3_opp_helios/formation && python generer_bulletins_exercice.py --check
   - run: pip install dilithium-py==1.4.0 slh-dsa==0.2.5 && cd 07_protocoles_terrain/P5_delta_q/stimuli && python generer_signatures_pqc.py --check
   ```

2. Pousser et vérifier que les trois jobs (`python`, `sotp-high`, `lean`) passent.
3. Vérifier qu'aucun fichier ne renvoie à l'ancien dépôt compagnon (commande de la section 8).

## 2. Après la soutenance, mise à jour des statuts

| Fichier | Modification |
|---|---|
| [`../STATUS_fr.md`](../STATUS_fr.md), [`../STATUS_en.md`](../STATUS_en.md) | ligne « Manuscrit de thèse » portée à « thèse soutenue le __/__/____ » |
| [`../00_these/README_fr.md`](../00_these/README_fr.md) et version anglaise | même mention dans l'en-tête et dans la section Référence |
| [`../03_resultats_these/resultats_these_fr.md`](../03_resultats_these/resultats_these_fr.md) | phrase « Tant que la thèse n'est pas soutenue… » à réviser |

Le registre ne connaît que trois statuts (PUBLIÉ, PRÉPRINT, PROPOSITION). Décision de l'auteur (13 octobre 2026) pour les résultats de thèse après soutenance. Ils gardent le statut PROPOSITION avec la sous-étiquette « résultat de thèse soutenue ». Les autres sous-étiquettes (construction, conjecture, formalisation, calibration illustrative, protocole non déployé, implémentation de référence) restent inchangées. Le dépôt peut continuer d'évoluer d'ici là.

Si des formulations précisées soumises ont été publiées entre-temps, leur ligne passe de « PROPOSITION (formulations précisées soumises) » à PUBLIÉ avec leur DOI, dans le registre comme dans la fiche [`formulations_precisees/`](../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/README_fr.md) concernée. Il en va de même pour SOTP (*IEEE TIT*) et pour la formalisation Lean (*JAR*) en cas d'acceptation.

## 3. Choix du mode d'obtention du DOI

La version 1.0.0 doit contenir la thèse finale. La thèse finale doit citer le DOI de la version 1.0.0. Deux voies évitent ce cercle.

| Voie | Déroulé | Avantage | Inconvénient |
|---|---|---|---|
| **A. DOI réservé (recommandée)** | Créer à la main un enregistrement Zenodo, cocher la réservation de DOI, reporter ce DOI dans la thèse, puis téléverser l'archive de l'étiquette `v1.0.0` et publier l'enregistrement | la thèse finale et la version 1.0.0 portent le même DOI | archive téléversée à la main ; les versions suivantes ne sont pas créées automatiquement |
| B. Intégration GitHub de Zenodo | Rendre le dépôt public, activer le dépôt dans Zenodo, publier la release `v1.0.0`. Zenodo attribue le DOI. Le reporter ensuite dans une release `v1.0.1` | chaque release est archivée automatiquement | la version 1.0.0 contient encore le DOI provisoire ; la thèse doit citer `v1.0.1` ou le DOI de concept |

L'intégration GitHub de Zenodo ne fonctionne qu'avec un dépôt public. La voie A peut se préparer pendant que le dépôt est encore privé. Le choix est laissé à l'auteur, qui s'en chargera après la soutenance.

## 4. Version finale de la thèse

1. Remplacer `10.5281/zenodo.XXXXXXX` par le DOI obtenu dans [`../00_these/manuscrit/chap4/validation_retrospective.tex`](../00_these/manuscrit/chap4/validation_retrospective.tex) (§4.4.12, `subsec:depot`, écart E1).
2. Dans [`../00_these/manuscrit/annexes/bibliographie.bib`](../00_these/manuscrit/annexes/bibliographie.bib), entrée `CROTrilemmaDepot`, ajouter le champ `doi`.
3. Recompiler le manuscrit (`make` dans `00_these/manuscrit/`) et ajouter dans [`../00_these/pdf/`](../00_these/pdf/) le PDF de la version finale, sous le nom `MaThèse.pdf`.
4. Mettre à jour [`../00_these/README_fr.md`](../00_these/README_fr.md) et sa version anglaise (section « Version des sources »).

Les écarts E3 à E12 sont résolus dans la version finale des sources (voir la [correspondance](correspondance_these_depot_fr.md)).

## 5. Métadonnées du dépôt

| Fichier | Modification |
|---|---|
| [`../CITATION.cff`](../CITATION.cff) | `version: "1.0.0"`, `date-released` à la date de publication, ajout de `doi:` |
| [`../.zenodo.json`](../.zenodo.json) | `"version": "1.0.0-pre"` porté à `"1.0.0"` ; compléter `creators` si les encadrants doivent figurer. La double licence est déjà précisée. Le champ `license` (une seule valeur possible) indique MIT pour le code et le champ `notes` décrit la répartition MIT / CC BY 4.0 |
| [`../README_fr.md`](../README_fr.md), [`../README_en.md`](../README_en.md) | DOI ajouté dans la section Citer |
| [`historique_fr.md`](historique_fr.md), [`historique_en.md`](historique_en.md) | ligne datée de la publication |

### Compte GitHub

Le dépôt est publié sous le compte `MINKAThierry`, qui porte l'identité complète de l'auteur. L'adresse `https://github.com/MINKAThierry/PhDThesis` figure dans `CITATION.cff`, dans les sources du manuscrit (`chap3/cro_lean4.tex`, `chap4/validation_retrospective.tex`, `annexes/code_lean4.tex`, `annexes/bibliographie.bib`), dans les fiches de `00_these/` et dans les documents communs de `07_protocoles_terrain/00_commun/`. La graine des stimuli de P1, dans [`../07_protocoles_terrain/P1_delta/stimuli/generer_exemples.py`](../07_protocoles_terrain/P1_delta/stimuli/generer_exemples.py), est `MINKAThierry/PhDThesis/P1/stimuli/v1`. Les stimuli et le catalogue ont été régénérés avec cette graine le 19 octobre 2026, aucune donnée n'ayant été recueillie.

## 6. Étiquette et publication

1. Fusionner toutes les modifications des sections 2 à 5 et vérifier que l'intégration continue passe.
2. Poser l'étiquette annotée `v1.0.0` (`git tag -a v1.0.0 -m "Version 1.0.0"`, puis `git push origin v1.0.0`).
3. Voie A. Téléverser sur l'enregistrement réservé l'archive de l'étiquette (`git archive --format=zip v1.0.0`) puis publier l'enregistrement.
4. Rendre le dépôt public dans les paramètres GitHub du dépôt.
5. Voie B uniquement. Activer le dépôt dans Zenodo, publier la release `v1.0.0`, puis appliquer les sections 4 et 5 avec le DOI reçu dans une release `v1.0.1`.

## 7. Après publication

- Vérifier que le DOI résout vers l'enregistrement et que l'archive contient bien la thèse finale.
- Vérifier que les liens relatifs s'affichent correctement sur GitHub.
- Signaler l'adresse et le DOI aux revues où des soumissions sont en cours, si leur politique le demande.

## 8. Liste de contrôle

| ☐ | Contrôle | Commande ou méthode |
|---|---|---|
| ☐ | Aucun renvoi à l'ancien dépôt compagnon | recherche de son ancienne adresse GitHub dans tous les fichiers suivis (`git grep -i "<ancienne adresse>"`) |
| ☐ | Calcul, 17 tests | `cd 06_calcul && python3 -m pytest -q tests` |
| ☐ | SOTP-Low et SOTP-Base, 50 tests | `cd 04_sotp/reference_low_base && python3 -m pytest -q tests` |
| ☐ | SOTP-High, 15 contrôles | `cd 04_sotp/high && bash scripts/run_all.sh` |
| ☐ | Analyse de terrain, 111 tests | `cd 07_protocoles_terrain/analyse && python3 -m pytest -q tests` |
| ☐ | Lean, compilation sans `sorry`, dix `#print axioms` standard | `cd 05_formalisation_lean && lake exe cache get && lake build` |
| ☐ | Générateurs de stimuli reproductibles | les trois commandes `--check` de la section 1 |
| ☐ | Empreintes des sorties de référence | `sha256sum -c SHA256SUMS` dans `06_calcul/results/` et `05_formalisation_lean/results/` |
| ☐ | Fichiers non versionnés absents (`node_modules/`, `04_sotp/high/build/`, `.lake/`, `__pycache__/`) | `git status --ignored` |
| ☐ | Chaque fichier `_fr` a son pendant `_en` | inspection de l'arborescence |
| ☐ | Liens relatifs valides | vérificateur de liens Markdown |
| ☐ | Aucune donnée personnelle ni aucun secret | relecture de `07_protocoles_terrain/` (gabarits vides) et recherche de clés |
| ☐ | DOI identique dans la thèse, `CITATION.cff`, les README et Zenodo | comparaison manuelle |

## Licence

CC BY 4.0.
