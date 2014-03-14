# tests for solr_facet fxn in solr
context("solr_facet")

url <- 'http://api.plos.org/search'

a <- solr_facet(q='*:*', facet.field='journal', base=url, verbose=FALSE)
b <- solr_facet(q='*:*', base=url, facet.date='publication_date', facet.date.start='NOW/DAY-5DAYS', facet.date.end='NOW', facet.date.gap='+1DAY', verbose=FALSE)

test_that("solr_facet returns the correct dimensions in the data.frame", {
  expect_that(length(a), equals(4))
  expect_that(length(a$facet_queries), equals(0))
  expect_that(nrow(a$facet_fields$journal), equals(10))
  
  expect_that(length(b), equals(4))
  expect_that(length(b$facet_dates), equals(1))
  expect_that(dim(b$facet_dates$publication_date), equals(c(6,2)))
})

test_that("solr_facet returns the correct classes", {
  expect_is(a, "list")
  expect_is(b, "list")
  expect_is(b$facet_dates, "list")
  expect_is(b$facet_dates$publication_date, "data.frame")
})