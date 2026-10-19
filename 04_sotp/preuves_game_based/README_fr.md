> **Statut : PROPOSITION — construction (soumise à IEEE Transactions on Information Theory)** · Source : thèse, annexe A

# preuves_game_based — Sécurité game-based de la famille SOTP

*English version: [README_en.md](README_en.md)*

| Fichier | Contenu |
|---|---|
| [gamebased_fr.md](gamebased_fr.md) | Annexe A en Markdown, en français |
| [gamebased_en.md](gamebased_en.md) | Annexe A en Markdown, en anglais (contenu équivalent) |
| [gamebased_source_fr.tex](gamebased_source_fr.tex) | Source LaTeX de l'annexe A dans la version finale du manuscrit, copiée sans modification (en français) |

Contenu de l'annexe. Jeux IND-CONF, BIND-REL et EXT-OPP ; ponts vers $\mathsf{Conf}$, $\mathsf{Rel}_{\mathrm{ver}}$ et $\mathsf{Opp}$ ; réductions de SOTP-Low au PRG et au logarithme discret ; lemme de dimensionnement JL de SOTP-Base ; sécurité de SOTP-High héritée de Groth16 ; tableau récapitulatif ; corollaire du produit CLO game-based et remarque de non-contradiction avec le trilemme ; limitations.

Aucune version `.tex` anglaise n'est fournie. La version Markdown anglaise en tient lieu. Le fichier `.tex` utilise les macros du manuscrit (`\cmt`, `\Conf`, `\Relver`…) et se compile dans le cadre de [../../00_these/manuscrit/](../../00_these/manuscrit/).

Les réductions établissent des garanties calculatoires de confidentialité et de fiabilité de vérification. Elles ne fournissent aucune minoration de l'opposabilité et ne se comparent pas à la borne du trilemme, qui porte sur la confidentialité statistique et la fiabilité de reconstruction.
