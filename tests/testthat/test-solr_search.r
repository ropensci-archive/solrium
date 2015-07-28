context("solr_search")

test_that("solr_search works", {
  skip_on_cran()
  
  conn <- solr_connect('http://api.plos.org/search')
  
  a <- solr_search(conn, q='*:*', rows=2, fl='id', verbose=FALSE)
  b <- solr_search(conn, q='title:"ecology" AND body:"cell"', fl='title', rows=5, verbose=FALSE)
  
  # correct dimensions
  expect_that(length(a), equals(1))
  expect_that(length(b), equals(1))

  # correct classes
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
})
