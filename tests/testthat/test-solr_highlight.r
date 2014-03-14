# tests for solr_highlight fxn in solr
context("solr_highlight")

url <- 'http://api.plos.org/search'

a <- solr_highlight(q='alcohol', hl.fl = 'abstract', rows=10, base = url, verbose=FALSE)
b <- solr_highlight(q='alcohol', hl.fl = c('abstract','title'), rows=3, base = url, verbose=FALSE)

test_that("solr_highlight returns the correct dimensions", {
  expect_that(length(a), equals(10))
  expect_that(length(a[[1]]), equals(1))
  expect_that(length(b), equals(3))
  expect_that(length(b[[3]]), equals(2))
})

test_that("solr_highlight returns the correct classes", {
  expect_is(a, "list")
  expect_is(a[[1]]$abstract, "character")
  
  expect_is(b, "list")
  expect_is(b[[1]], "list")
  expect_is(b[[1]]$abstract, "character")
  expect_is(b[[1]]$title, "character")
})