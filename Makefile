all: move rmd2md

move:
	cd inst/stuff;\
	cp solr_localsetup.md ../../vignettes;\
	cp solr_vignette.md ../../vignettes;\
	cp solr_management.md ../../vignettes

rmd2md:
	cd vignettes;\
	mv solr_vignette.md solr_vignette.Rmd;\
	mv solr_localsetup.md solr_localsetup.Rmd;\
	mv solr_management.md solr_management.Rmd
