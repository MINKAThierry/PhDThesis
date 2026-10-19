# Thèse de doctorat - version de dépôt

> **Statut : PROPOSITION: thèse déposée, soutenance à venir** · Source : manuscrit de thèse, version de dépôt (branche `style` des sources LaTeX)

[English version](README_en.md)

## Référence

T. E. MINKA MI NGUIDJOÏ, *Aux fondements de la cryptographie institutionnelle. Formalisation, bornes d'impossibilité, conditions d'optimalité et vérification formelle*, thèse de doctorat, LIMSI, École Nationale Supérieure Polytechnique, Université de Yaoundé I, 2026. Encadrement par Pr. Thomas DJOTIO NDIÉ et Dr. Flavien Serge MANI ONANA.

La thèse a été déposée. Elle n'a pas encore été soutenue ; ses résultats propres gardent donc le statut de proposition tant que le jury ne s'est pas prononcé. Les trois articles publiés sur lesquels elle s'appuie sont décrits dans [`../01_publie/`](../01_publie/).

## Contenu du dossier

| Dossier | Contenu |
|---|---|
| [`manuscrit/`](manuscrit/) | Sources LaTeX complètes de la version finale du manuscrit (chapitres, annexes, style, figures, bibliographie) et `Makefile` |
| [`pdf/`](pdf/) | `MaThèse.pdf`, le PDF de la version finale déposée (247 pages) |

## Compiler le manuscrit

```bash
cd manuscrit
make                    # LuaLaTeX + BibTeX (moteur prévu par le style)
make LATEX=pdflatex     # variante pdfLaTeX, celle qui a produit le PDF de dépôt
make clean
```

LuaLaTeX requiert la police système « Times New Roman » appelée par `style/these_ensp.sty`. Faute de cette police, le PDF de dépôt a été produit avec pdfLaTeX, que le style prend aussi en charge. Dans ce mode, le listing Lean de l'annexe B provoque des erreurs « Invalid UTF-8 » non bloquantes (caractères Unicode du code). Le `Makefile` enchaîne LuaLaTeX, BibTeX (moteur `backend=bibtex` de biblatex), `makeglossaries`, `makeindex` puis deux passes de LuaLaTeX.

## Version des sources

Les sources de `manuscrit/` sont celles de la version finale du manuscrit (octobre 2026). Elles intègrent les retours de l'expertise académique, la formalisation Lean en version 2.2 vérifiée en ligne et l'adresse de ce dépôt, `https://github.com/MINKAThierry/PhDThesis`. Le PDF `MaThèse.pdf` en est la compilation. Le PDF `these_version_depot.pdf` est celui de la version déposée le 28 septembre 2026, qui précède ces mises à jour.

## Correspondance avec le dépôt

Pour chaque chapitre, section, tableau ou script cité dans la thèse, le document [`../docs/correspondance_these_depot_fr.md`](../docs/correspondance_these_depot_fr.md) indique où le trouver dans ce dépôt. Les énoncés que la thèse ajoute ou précise par rapport aux articles publiés sont recensés dans [`../03_resultats_these/`](../03_resultats_these/).

## Licence

Texte du manuscrit et PDF : CC BY 4.0. Le listing Lean reproduit en annexe B relève de la licence MIT du code (voir [`../05_formalisation_lean/`](../05_formalisation_lean/)).
