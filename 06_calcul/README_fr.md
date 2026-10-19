> **Statut : PROPOSITION — calibration illustrative** · Source : thèse, chapitre 4 (tableau des paramètres de référence, calibration rétrospective)

# 06_calcul — Calibration illustrative et vérifications numériques

*English version: [README_en.md](README_en.md)*

Ce dossier recalcule chaque valeur numérique du chapitre 4. Les valeurs sont des paramètres de calibration illustratifs et non des mesures. Les systèmes déployés (ECDSA, Helios, zk-SNARKs, ML-DSA) ne sont pas des instances du théorème. Leur rôle se limite à vérifier que les ordres de grandeur retenus sont mutuellement cohérents.

| Élément | Contenu |
|---|---|
| [python/cro/](python/cro/) | bornes du Trilemme (forme explicite et forme raffinée), quantités informationnelles, heuristiques SOTP, lecture des données |
| [python/validate_sotp.py](python/validate_sotp.py) | calibration classique et post-quantique |
| [python/sensitivity_eta_q.py](python/sensitivity_eta_q.py) | sensibilité au coefficient η_q (scénario hypothétique d'un support quantique) |
| [python/verifications.py](python/verifications.py) | contrôles numériques cités dans la thèse |
| [data/](data/) | table de référence et calibration post-quantique, schéma dans [SCHEMA_fr.md](data/SCHEMA_fr.md) |
| [results/](results/) | sorties de référence et empreintes SHA-256 |
| [tests/](tests/) | 17 tests qui recalculent les valeurs de la thèse |

## Exécution

```sh
pip install --break-system-packages -r python/requirements.txt
./reproduire.sh --sans-lean      # Python seul
./reproduire.sh                  # Python et compilation Lean (../05_formalisation_lean)
```

Exécution du 12 octobre 2026 : 17 tests passés.
