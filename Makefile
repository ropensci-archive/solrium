PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --no-init-file

vign_local_setup:
	cd vignettes;\
	${RSCRIPT} -e "knitr::knit('local_setup.Rmd.og', output = 'local_setup.Rmd')"
	cd ..

vign_search:
	cd vignettes;\
	${RSCRIPT} -e "knitr::knit('search.Rmd.og', output = 'search.Rmd')"
	cd ..

vign_document_management:
	cd vignettes;\
	${RSCRIPT} -e "knitr::knit('document_management.Rmd.og', output = 'document_management.Rmd')"
	cd ..

vign_cores_collections:
	cd vignettes;\
	${RSCRIPT} -e "knitr::knit('cores_collections.Rmd.og', output = 'cores_collections.Rmd')"
	cd ..

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples()"

codemeta:
	${RSCRIPT} -e "codemetar::write_codemeta()"

check: build
	_R_CHECK_CRAN_INCOMING_=FALSE R CMD CHECK --as-cran --no-manual `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -f `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -rf ${PACKAGE}.Rcheck

test:
	${RSCRIPT} -e 'devtools::test()'

readme:
	${RSCRIPT} -e "knitr::knit('README.Rmd')"

check_windows:
	${RSCRIPT} -e "devtools::check_win_devel(); devtools::check_win_release()"
		
