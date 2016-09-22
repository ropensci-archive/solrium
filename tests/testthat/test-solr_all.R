context("solr_all")

test_that("solr_all works", {
  skip_on_cran()

  solr_connect('http://api.plos.org/search', verbose = FALSE)

  a <- solr_all(q='*:*', rows=2, fl='id')
  b <- solr_all(q='title:"ecology" AND body:"cell"', fl='title', rows=5)

  # correct dimensions
  expect_equal(length(a), 6)
  expect_equal(length(b), 6)

  # correct classes
  expect_is(a, "list")
  expect_is(a$search, "tbl_df")
  expect_is(b, "list")
  expect_is(b$search, "tbl_df")
  
  # right slot names
  expect_named(a, c('search','facet','high','mlt','group','stats'))
  expect_named(b, c('search','facet','high','mlt','group','stats'))
})

test_that("solr_all fails well", {
  skip_on_cran()

  invisible(solr_connect('http://api.plos.org/search', verbose = FALSE))

  expect_error(solr_all(q = "*:*", rows = "asdf"), "500 - For input string")
  expect_error(solr_all(q = "*:*", sort = "down"),
               "400 - Can't determine a Sort Order \\(asc or desc\\) in sort spec 'down'")
  expect_error(solr_all(q='*:*', fl=c('alm_twitterCount','id'),
                           fq='alm_notafield:[5 TO 50]', rows=10),
               "undefined field")
  expect_error(solr_all(q = "*:*", wt = "foobar"),
               "wt must be one of: json, xml, csv")

})

test_that("solr_all works with HathiTrust", {
  skip_on_cran()

  url_hathi <- "http://chinkapin.pti.indiana.edu:9994/solr/meta/select"
  invisible(solr_connect(url = url_hathi, verbose = FALSE))

  a <- solr_all(q = '*:*', rows = 2, fl = 'id')
  b <- solr_all(q = 'language:Spanish', rows = 5)

  # correct dimensions
  expect_equal(NROW(a$search), 2)
  expect_equal(NROW(b$search), 5)

  # correct classes
  expect_is(a, "list")
  expect_is(a$search, "data.frame")
  expect_is(a$high, "data.frame")
  expect_is(a$group, "data.frame")
  expect_null(b$stats)
  expect_null(b$facet)
  
  expect_is(b, "list")
  expect_is(a$search, "data.frame")
  expect_is(b$high, "data.frame")
  expect_is(b$group, "data.frame")
  expect_null(b$stats)
  expect_null(b$facet)

  # names
  expect_named(a$search, "id")
})

test_that("solr_all works with Datacite", {
  skip_on_cran()

  url_dc <- "http://search.datacite.org/api"
  invisible(solr_connect(url = url_dc, verbose = FALSE))

  a <- solr_all(q = '*:*', rows = 2)
  b <- solr_all(q = 'publisher:Data', rows = 5)

  # correct dimensions
  expect_equal(NROW(a$search), 2)
  expect_equal(NROW(b$search), 5)
})
