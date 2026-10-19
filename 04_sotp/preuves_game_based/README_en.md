> **Status: PROPOSAL — construction (submitted to IEEE Transactions on Information Theory)** · Source: thesis, Annex A

# preuves_game_based — Game-based security of the SOTP family

*Version française : [README_fr.md](README_fr.md)*

| File | Content |
|---|---|
| [gamebased_fr.md](gamebased_fr.md) | Annex A in Markdown, French |
| [gamebased_en.md](gamebased_en.md) | Annex A in Markdown, English (equivalent content) |
| [gamebased_source_fr.tex](gamebased_source_fr.tex) | LaTeX source of Annex A in the final version of the manuscript, copied unchanged (French) |

Content of the annex: IND-CONF, BIND-REL and EXT-OPP games; bridges to $\mathsf{Conf}$, $\mathsf{Rel}_{\mathrm{ver}}$ and $\mathsf{Opp}$; reductions of SOTP-Low to the PRG and to the discrete logarithm; JL sizing lemma for SOTP-Base; security of SOTP-High inherited from Groth16; summary table; corollary on the game-based CLO product and remark on non-contradiction with the trilemma; limitations.

No English `.tex` version is provided; the English Markdown version serves that purpose. The `.tex` file uses the manuscript macros (`\cmt`, `\Conf`, `\Relver`, …) and compiles within [../../00_these/manuscrit/](../../00_these/manuscrit/).

The reductions establish computational guarantees of confidentiality and verification reliability. They provide no lower bound on opposability and are not comparable with the trilemma bound, which concerns statistical confidentiality and reconstruction reliability.
