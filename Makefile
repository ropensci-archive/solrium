vignettes: 
	cd inst/stuff;\
	Rscript -e 'library(knitr); knit("solr_localsetup.Rmd"); knit("solr_vignette.Rmd")'

pandoc:
	cd inst/stuff;\
	pandoc -H margins.sty solr_localsetup.md -o solr_localsetup.pdf;\
	pandoc -H margins.sty solr_localsetup.md -o solr_localsetup.html;\
	pandoc -H margins.sty solr_vignette.md -o solr_vignette.pdf;\
	pandoc -H margins.sty solr_vignette.md -o solr_vignette.html

move:
	cp inst/stuff/solr_* vignettes

cleanup:
	cd inst/stuff;\
	rm -rf cache