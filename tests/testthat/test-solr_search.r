context("solr_search")

test_that("solr_search works", {
  skip_on_cran()

  solr_connect('http://api.plos.org/search', verbose = FALSE)

  a <- solr_search(q='*:*', rows=2, fl='id')
  b <- solr_search(q='title:"ecology" AND body:"cell"', fl='title', rows=5)

  # correct dimensions
  expect_that(length(a), equals(1))
  expect_that(length(b), equals(1))

  # correct classes
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
})

test_that("solr_search fails well", {
  skip_on_cran()
  
  invisible(solr_connect('http://api.plos.org/search', verbose = FALSE))
  
  expect_error(solr_search(q = "*:*", rows = "asdf"), "500 - For input string")
  expect_error(solr_search(q = "*:*", sort = "down"), 
               "Error : 400 - Can't determine a Sort Order \\(asc or desc\\) in sort spec 'down'")
  expect_error(solr_search(q='*:*', fl=c('alm_twitterCount','id'), 
                           fq='alm_notafield:[5 TO 50]', rows=10), 
               "undefined field")
  expect_error(solr_search(q = "*:*", wt = "foobar"), 
               "wt must be one of: json, xml, csv")
  
})
