context("solr_highlight")

test_that("solr_highlight works", {
  skip_on_cran()
  
  conn <- solr_connect('http://api.plos.org/search')
  
  a <- solr_highlight(conn, q='alcohol', hl.fl = 'abstract', rows=10, verbose=FALSE)
  b <- solr_highlight(conn, q='alcohol', hl.fl = c('abstract','title'), rows=3, verbose=FALSE)
  
  # correct dimensions
  expect_that(length(a), equals(10))
  expect_that(length(a[[1]]), equals(1))
  expect_that(length(b), equals(3))
  expect_that(length(b[[3]]), equals(2))

  # correct classes
  expect_is(a, "list")
  expect_is(a[[1]]$abstract, "character")
  
  expect_is(b, "list")
  expect_is(b[[1]], "list")
  expect_is(b[[1]]$abstract, "character")
  expect_is(b[[1]]$title, "character")
})
