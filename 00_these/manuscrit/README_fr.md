# Sources LaTeX du manuscrit

> **Statut : PROPOSITION — thèse déposée, soutenance à venir** · Source : sources LaTeX de la version finale de la thèse (octobre 2026)

[English version](README_en.md)

Sources de la version finale du manuscrit. Le fichier principal est `these2.tex`. Le dépôt y est cité à l'adresse `https://github.com/MINKAThierry/PhDThesis` (voir [`../README_fr.md`](../README_fr.md)).

| Dossier | Contenu |
|---|---|
| `intro_conclu_gen/` | Introduction et conclusion générales |
| `chap1/` à `chap5/` | Chapitres 1 à 5 |
| `annexes/` | Annexe A (sécurité game-based), annexe B (code Lean), annexe C (publications), bibliographie `bibliographie.bib` |
| `preambule/`, `style/`, `figures/` | Pages liminaires, feuille de style `these_ensp.sty`, figures |

Compilation avec `make` (LuaLaTeX) ou `make LATEX=pdflatex`. Les commentaires du `Makefile` sont en anglais, conformément à la règle du dépôt pour le code.
