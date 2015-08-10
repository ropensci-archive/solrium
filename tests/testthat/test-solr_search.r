context("solr_search")

test_that("solr_search works", {
  skip_on_cran()

  solr_connect('http://api.plos.org/search')

  a <- solr_search(q='*:*', rows=2, fl='id', verbose=FALSE)
  b <- solr_search(q='title:"ecology" AND body:"cell"', fl='title', rows=5, verbose=FALSE)

  # correct dimensions
  expect_that(length(a), equals(1))
  expect_that(length(b), equals(1))

  # correct classes
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
})

test_that("solr_search fails well", {
  skip_on_cran()
  
  solr_connect('http://api.plos.org/search')
  
  expect_error(solr_search(q = "*:*", rows = "asdf", verbose = FALSE), "500 - For input string")
  expect_error(solr_search(q = "*:*", sort = "down", verbose = FALSE), 
               "Error : 400 - Can't determine a Sort Order \\(asc or desc\\) in sort spec 'down'")
  expect_error(solr_search(q = "*:*", fl = "stuff", verbose = FALSE), 
               "not compatible with STRSXP")
  expect_error(solr_search(q = "*:*", wt = "foobar", verbose = FALSE), 
               "wt must be one of: json, xml, csv")
  
})
