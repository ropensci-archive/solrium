# tests for solr_search fxn in solr
context("solr_search")

url <- 'http://api.plos.org/search'
key = getOption('PlosApiKey')

a <- solr_search(q='*:*', rows=2, fl='id', url=url, key=key)
b <- solr_search(q='title:"ecology" AND body:"cell"', fl='title', rows=5, url=url, key=key)

test_that("solr_search returns the correct dimensions in the data.frame", {
  expect_that(length(a), equals(1))
  expect_that(length(b), equals(1))
})

test_that("solr_search returns the correct classes", {
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
})