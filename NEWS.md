solrium 0.4.0
=============

### MINOR IMPROVEMENTS

* Change `dplyr::rbind_all()` (deprecated) to `dplyr::bind_rows()` (#90)
* Added additional examples of using pivot facetting to `solr_facet()` (#91)
* Fix to `solr_group()` (#92)
* Replaced dependency `XML` with `xml2` (#57)
* Added examples and tests for a few more public Solr instances (#30)
* Now using `tibble` to give back compact data.frame's
* namespace all base package calls
* Many changes to internal parsers to use `xml2` instead of `XML`, and 
improvements

solrium 0.3.0
=============

### NEW FEATURES

* released to CRAN
