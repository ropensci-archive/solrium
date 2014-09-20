all: move rmd2md

vign:
	cd inst/stuff;\
	Rscript --vanilla -e 'library(knitr); knit("solr_localsetup.Rmd"); knit("solr_vignette.Rmd")'

move:
	cd inst/stuff;\
	cp solr_localsetup.md ../../vignettes;\
	cp solr_vignette.md ../../vignettes

pandoc:
	cd vignettes;\
	pandoc -H margins.sty solr_localsetup.md -o solr_localsetup.pdf --highlight-style=tango;\
	pandoc -H margins.sty solr_localsetup.md -o solr_localsetup.html --highlight-style=tango;\
	pandoc -H margins.sty solr_vignette.md -o solr_vignette.pdf --highlight-style=tango;\
	pandoc -H margins.sty solr_vignette.md -o solr_vignette.html --highlight-style=tango

rmd2md:
	cd vignettes;\
	mv solr_vignette.md solr_vignette.Rmd;\
	mv solr_localsetup.md solr_localsetup.Rmd

reducepdf:
	Rscript -e 'tools::compactPDF("vignettes/solr_vignette.pdf", gs_quality = "ebook")';\
	Rscript -e 'tools::compactPDF("vignettes/solr_localsetup.pdf", gs_quality = "ebook")'
