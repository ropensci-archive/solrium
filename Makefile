all: move rmd2md

move:
	cd inst/stuff;\
	cp solr_localsetup.md ../../vignettes;\
	cp solr_search.md ../../vignettes;\
	cp solr_management.md ../../vignettes

rmd2md:
	cd vignettes;\
	mv solr_search.md solr_search.Rmd;\
	mv solr_localsetup.md solr_localsetup.Rmd;\
	mv solr_management.md solr_management.Rmd
