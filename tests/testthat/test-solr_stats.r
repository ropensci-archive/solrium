context("solr_stats")

test_that("solr_stats works", {
  skip_on_cran()
  
  url <- 'http://api.plos.org/search'
  
  a <- solr_stats(q='science', stats.field='counter_total_all', base=url, raw=TRUE, verbose=FALSE)
  b <- solr_stats(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), stats.facet=c('journal','volume'), base=url, verbose=FALSE)
  c <- solr_stats(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), stats.facet=c('journal','volume'), base=url, raw=TRUE, verbose=FALSE)
  d <- solr_parse(c) # list
  e <- solr_parse(c, 'df') # data.frame

  # correct dimenions
  expect_equal(length(a), 1)
  expect_equal(length(b), 2)
  expect_equal(nrow(b$data), 2)
  expect_equal(NCOL(b$facet$counter_total_all$journal), 9)
  expect_equal(length(c), 1)
  expect_equal(length(d), 2)
  expect_equal(length(d$data$alm_twitterCount), 8)
  expect_equal(length(e$facet$alm_twitterCount), 2)
  expect_equal(NCOL(e$facet$alm_twitterCount$volume), 9)
  expect_equal(length(e$facet$alm_twitterCount$volume$missing), 13)

  # classes
  expect_is(a, "sr_stats")
  expect_is(b, "list")
  expect_is(b$data, "data.frame")
  expect_is(b$facet$counter_total_all$journal, "data.frame")
  expect_is(c, "sr_stats")
  expect_equal(attr(c, "wt"), "json")
  expect_is(d, "list")
  expect_is(e, "list")
})
