# Doctoral thesis - submitted version

> **Status: PROPOSAL. thesis submitted, defence pending** · Source: thesis manuscript, submitted version (`style` branch of the LaTeX sources)

[Version française](README_fr.md)

## Reference

T. E. MINKA MI NGUIDJOÏ, *Aux fondements de la cryptographie institutionnelle. Formalisation, bornes d'impossibilité, conditions d'optimalité et vérification formelle* (Foundations of institutional cryptography: formalisation, impossibility bounds, optimality conditions and formal verification), PhD thesis, LIMSI, National Advanced School of Engineering (ENSP), University of Yaoundé I, 2026. Supervised by Prof. Thomas DJOTIO NDIÉ and Dr. Flavien Serge MANI ONANA.

The thesis has been submitted. It has not been defended yet, so its own results keep the status of proposals until the jury has ruled. The three published articles on which it builds are described in [`../01_publie/`](../01_publie/).

## Folder contents

| Folder | Contents |
|---|---|
| [`manuscrit/`](manuscrit/) | Complete LaTeX sources of the final version of the manuscript (chapters, appendices, style, figures, bibliography) and `Makefile` |
| [`pdf/`](pdf/) | `MaThèse.pdf`, the PDF of the final submitted version (247 pages)|

## Building the manuscript

```bash
cd manuscrit
make                    # LuaLaTeX + BibTeX (engine intended by the style file)
make LATEX=pdflatex     # pdfLaTeX variant, the one that produced the submitted PDF
make clean
```

LuaLaTeX requires the system font "Times New Roman" loaded by `style/these_ensp.sty`. Because this font was unavailable, the submitted PDF was produced with pdfLaTeX, which the style file also supports. In that mode the Lean listing of Appendix B triggers non-blocking "Invalid UTF-8" errors (Unicode characters in the code). The `Makefile` runs LuaLaTeX, BibTeX (biblatex with `backend=bibtex`), `makeglossaries`, `makeindex`, then two more LuaLaTeX passes.

## Version of the sources

The sources in `manuscrit/` are those of the final version of the manuscript (October 2026). They incorporate the feedback from the academic expert review, the Lean formalisation in version 2.2 verified online and the address of this repository, `https://github.com/MINKAThierry/PhDThesis`. `MaThèse.pdf` is their build. `these_version_depot.pdf` is the PDF of the version submitted on 28 September 2026, which predates these updates.

## Mapping to the repository

For every chapter, section, table or script cited in the thesis, [`../docs/correspondance_these_depot_en.md`](../docs/correspondance_these_depot_en.md) states where it lives in this repository. The statements that the thesis adds or refines with respect to the published articles are listed in [`../03_resultats_these/`](../03_resultats_these/).

## Licence

Manuscript text and PDF: CC BY 4.0. The Lean listing reproduced in Appendix B falls under the MIT licence of the code (see [`../05_formalisation_lean/`](../05_formalisation_lean/)).
