# LaTeX sources of the manuscript

> **Status: PROPOSAL: thesis submitted, defence pending** · Source: LaTeX sources of the final version of the thesis (October 2026)

[Version française](README_fr.md)

Sources of the final version of the manuscript. The main file is `these2.tex`. The repository is cited there at the address `https://github.com/MINKAThierry/PhDThesis` (see [`../README_en.md`](../README_en.md)).

| Folder | Contents |
|---|---|
| `intro_conclu_gen/` | General introduction and conclusion |
| `chap1/` to `chap5/` | Chapters 1 to 5 |
| `annexes/` | Appendix A (game-based security), Appendix B (Lean code), Appendix C (publications), bibliography `bibliographie.bib` |
| `preambule/`, `style/`, `figures/` | Front matter, style file `these_ensp.sty`, figures |

Build with `make` (LuaLaTeX) or `make LATEX=pdflatex`. The comments of the `Makefile` are in English, following the repository rule for code.
