context("solr_stats")

test_that("solr_stats works", {
  skip_on_cran()

  invisible(solr_connect('http://api.plos.org/search', verbose=FALSE))

  a <- solr_stats(q='science', stats.field='counter_total_all', raw=TRUE)
  b <- solr_stats(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), 
                  stats.facet=c('journal','volume'))
  c <- solr_stats(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), 
                  stats.facet=c('journal','volume'), raw=TRUE)
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

test_that("solr_stats works using wt=xml", {
  skip_on_cran()
  
  invisible(solr_connect('http://api.plos.org/search', verbose = FALSE))
  
  aa <- solr_stats(q='science', wt="xml", stats.field='counter_total_all', raw=TRUE)
  bb <- solr_stats(q='science', wt="xml", stats.field='counter_total_all')
  cc <- solr_stats(q='science', wt="xml", stats.field=c('counter_total_all','alm_twitterCount'), 
                   stats.facet=c('journal','volume'))
  
  # correct dimenions
  expect_equal(length(aa), 1)
  expect_equal(length(bb), 2)
  expect_equal(NROW(bb$data), 1)
  expect_named(cc$facet[[1]], c("lst", "lst"))
  expect_equal(length(cc), 2)
  
  # classes
  expect_is(aa, "sr_stats")
  expect_is(bb, "list")
  expect_is(cc, "list")
  expect_is(bb$data, "data.frame")
  expect_is(cc$facet[[1]][[1]], "data.frame")
  expect_equal(attr(aa, "wt"), "xml")
})
