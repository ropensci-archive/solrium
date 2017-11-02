solrium 1.0.0
=============

This is v1, indicating breaking changes from the previous version!

### NEW FEATURES

* Package has been reworked to allow control over what parameters are sent
as query parameters and which as body. If only query parameters given, we do a
`GET` request, but if any body parameters given (even if query params given)
we do a `POST` request.  This means that all `solr_*` functions have more or
less the same parameters, and you now pass query parameters to `params` and
body parameters to `body`. This definitely breaks previous code, apologies
for that, but the bump in major version is a big indicator of the breakage.
* As part of overhaual, moved to using an `R6` setup for the Solr connection
object. The connection object deals with connection details, and you can call
all methods on the object created. Additionally, you can simply
pass the connection object to standalone methods. This change means
you can create connection objects to >1 Solr instance, so you can use many
Solr instances in one R session. (#100)
* gains new functions `update_atomic_json` and `update_atomic_xml` for doing
atomic updates (#97) thanks @yinghaoh
* `solr_search` and `solr_all` gain attributes that include `numFound`,
`start`, and `maxScore` (#94)
* `solr_search`/`solr_all`/`solr_mlt` gain new feature where we automically
check for and adjust `rows` parameter for you if you allow us to.
You can toggle this behavior and you can set a minimum number for rows
to be optimized with `minOptimizedRows`. See (#102) (#104) (#105) for
discussion. Thanks @1havran

### MINOR IMPROVEMENTS

* Replaced `httr` with `crul`. Should only be noticeable with respect
to specifying curl options (#98)
* Added more tests (#56)
* `optimize` renamed to `solr_optimize` (#107)
* now `solr_facet` fails better when no `facet.*` fields given (#103)

### BUG FIXES

* Fixed `solr_highlight` parsing to data.frame bug (#109)


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
