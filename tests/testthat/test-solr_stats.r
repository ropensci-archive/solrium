# tests for solr_stats fxn in solr
context("solr_stats")

url <- 'http://api.plos.org/search'

a <- solr_stats(q='science', stats.field='counter_total_all', base=url, raw=TRUE, verbose=FALSE)
b <- solr_stats(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), stats.facet=c('journal','volume'), base=url, verbose=FALSE)
c <- solr_stats(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), stats.facet=c('journal','volume'), base=url, raw=TRUE, verbose=FALSE)
d <- solr_parse(c) # list
e <- solr_parse(c, 'df') # data.frame

test_that("solr_stats returns the correct dimensions", {
  expect_that(length(a), equals(1))
  expect_that(length(b), equals(2))
  expect_that(nrow(b$data), equals(2))
  expect_that(nrow(b$facet$counter_total_all$journal), equals(8))
  expect_that(length(c), equals(1))
  expect_that(length(d), equals(2))
  expect_that(length(d$data$alm_twitterCount), equals(8))
  expect_that(length(e$facet$alm_twitterCount), equals(2))
  expect_that(length(e$facet$alm_twitterCount$volume), equals(9))
  expect_that(length(e$facet$alm_twitterCount$volume$missing), equals(12))
})

test_that("solr_stats returns the correct classes", {
  expect_is(a, "sr_stats")
  expect_is(b, "list")
  expect_is(b$data, "data.frame")
  expect_is(b$facet$counter_total_all$journal, "data.frame")
  expect_is(c, "sr_stats")
  expect_equal(attr(c, "wt"), "json")
  expect_is(d, "list")
  expect_is(e, "list")
})