> **Statut : PROPOSITION. construction (soumise à IEEE Transactions on Information Theory, retrait demandé en novembre 2026)** · Source : thèse, annexe A

# Sécurité game-based de la famille SOTP

*English version: [README_en.md](README_en.md)*

| Fichier | Contenu |
|---|---|
| [gamebased_fr.md](gamebased_fr.md) | Annexe A en Markdown, en français |
| [gamebased_en.md](gamebased_en.md) | Annexe A en Markdown, en anglais (contenu équivalent) |
| [gamebased_source_fr.tex](gamebased_source_fr.tex) | Source LaTeX de l'annexe A dans la version finale du manuscrit, copiée sans modification (en français) |
| [lean/GameBasedSOTP.lean](lean/GameBasedSOTP.lean) | Mécanisation en Lean 4 des réductions de SOTP-Low en situation réduite, version 1.2 (Mathlib seul, vérifiable sur <https://live.lean-lang.org>), avec la couche Iron dans le jeu de confidentialité (Théorème A.5) et le masque par troncature (Remarque 3.5), et son journal de compilation [lean/results/lean_build_v1.2.log](lean/results/lean_build_v1.2.log) |
| [lean/VERIFICATION_fr.md](lean/VERIFICATION_fr.md) | Dossier de vérification sur le modèle du dépôt de la preuve de Riemann : énoncés sans preuve (`Verification/Enonces.lean`), point d'entrée (`Principal.lean`), tests de non-vacuité (`Coherence.lean`), script `verifier.sh` et workflow GitHub `verification_lean_sotp.yml` |

Contenu de l'annexe. Jeux IND-CONF, BIND-REL et EXT-OPP ; ponts vers $\mathsf{Conf}$, $\mathsf{Rel}_{\mathrm{ver}}$ et $\mathsf{Opp}$ ; réductions de SOTP-Low au PRG et au logarithme discret ; règle de conception et théorème de dimensionnement JL de SOTP-Base ; sécurité de SOTP-High héritée de Groth16 ; corollaire des réductions de SOTP-Base ; tableau récapitulatif ; corollaire du produit CLO game-based et remarque de non-contradiction avec le trilemme ; mécanisation en situation réduite ; limitations.

Aucune version `.tex` anglaise n'est fournie. La version Markdown anglaise en tient lieu. Le fichier `.tex` utilise les macros du manuscrit (`\cmt`, `\Conf`, `\Relver`…) et se compile dans le cadre de [../../00_these/manuscrit/](../../00_these/manuscrit/).

Les jeux et leurs ponts vers les métriques CLO sont démontrés sur lois finies dans [`../../05_formalisation_lean/ConditionalCRO.lean`](../../05_formalisation_lean/ConditionalCRO.lean), version 3.8, section 18.

Les réductions établissent des garanties de confidentialité et de fiabilité de vérification. La confidentialité est calculatoire sous PRG et devient statistique lorsque le masque est tronqué (Remarque `rem:masque_troncature`). Elles ne fournissent aucune minoration de l'opposabilité et ne se comparent pas à la borne du trilemme, qui porte sur la confidentialité statistique et la fiabilité de reconstruction.
