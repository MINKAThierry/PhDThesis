# Build the thesis manuscript (LuaLaTeX + BibTeX backend of biblatex).
# LuaLaTeX needs the system font "Times New Roman" (see style/these_ensp.sty).
# The deposited PDF (../pdf/these_version_depot.pdf) was produced with pdfLaTeX,
# which the style file also supports:  make LATEX=pdflatex
# Usage: make        -> these2.pdf
#        make clean  -> remove auxiliary files
#        make distclean -> also remove the PDF

SHELL  := /bin/bash
MAIN   := these2
LATEX  ?= lualatex
# nonstopmode: the reference build logs recoverable errors (listings/UTF-8)
# without stopping; the leading '-' keeps make going on a non-zero exit code.
LFLAGS := -interaction=nonstopmode -file-line-error
BIBTEX := bibtex

.PHONY: all clean distclean

all: $(MAIN).pdf

$(MAIN).pdf: $(MAIN).tex $(wildcard */*.tex) $(wildcard style/*) annexes/bibliographie.bib
	-$(LATEX) $(LFLAGS) $(MAIN)
	$(BIBTEX) $(MAIN)
	-makeglossaries $(MAIN)
	-makeindex $(MAIN).idx
	-$(LATEX) $(LFLAGS) $(MAIN)
	$(BIBTEX) $(MAIN)
	-$(LATEX) $(LFLAGS) $(MAIN)
	-$(LATEX) $(LFLAGS) $(MAIN)
	@test -f $(MAIN).pdf

clean:
	rm -f $(MAIN).{aux,bbl,blg,log,out,toc,lof,lot,loa,lol,idx,ind,ilg,ist,acn,acr,alg,glo,gls,glg,run.xml,synctex.gz} $(MAIN)-blx.bib
	find . -name '*.aux' -delete

distclean: clean
	rm -f $(MAIN).pdf
