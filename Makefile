all: move pandoc rmd2md reducepdf

vignettes: 
	cd inst/stuff;\
	Rscript -e 'library(knitr); knit("solr_localsetup.Rmd"); knit("solr_vignette.Rmd")'

move:
	cp inst/stuff/solr_* vignettes

pandoc:
	cd vignettes;\
	pandoc -H margins.sty solr_localsetup.md -o solr_localsetup.pdf --highlight-style=tango;\
	pandoc -H margins.sty solr_localsetup.md -o solr_localsetup.html --highlight-style=tango;\
	pandoc -H margins.sty solr_vignette.md -o solr_vignette.pdf --highlight-style=tango;\
	pandoc -H margins.sty solr_vignette.md -o solr_vignette.html --highlight-style=tango

rmd2md:
	cd vignettes;\
	cp solr_vignette.md solr_vignette.Rmd;\
	cp solr_localsetup.md solr_localsetup.Rmd

reducepdf:
	Rscript -e 'tools::compactPDF("vignettes/solr_vignette.pdf", gs_quality = "ebook")';\
	Rscript -e 'tools::compactPDF("vignettes/solr_localsetup.pdf", gs_quality = "ebook")'