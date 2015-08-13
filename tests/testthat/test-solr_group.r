context("solr_group")

test_that("solr_group works", {
  skip_on_cran()

  solr_connect('http://api.plos.org/search', verbose=FALSE)

  a <- solr_group(q='ecology', group.field='journal', group.limit=3, fl=c('id','score'))
  b <- solr_group(q='ecology', group.field='journal', group.limit=3,
                  fl=c('id','score','alm_twitterCount'),
                  group.sort='alm_twitterCount desc')
  out <- solr_group(q='ecology', group.field=c('journal','article_type'), group.limit=3, fl='id',
                    raw=TRUE)
  c <- out
  d <- solr_parse(out, 'df')
  e <- solr_group(q='ecology', group.field='journal', group.limit=3, fl=c('id','score'),
                  group.format='grouped', group.main='true')

  suppressPackageStartupMessages(library('jsonlite', quietly = TRUE))
  f <- jsonlite::fromJSON(out, FALSE)

  # correct dimensions
  expect_equal(NCOL(a), 5)
  expect_equal(NCOL(b), 6)
  expect_that(length(c), equals(1))
  expect_that(length(d), equals(2))
  expect_equal(NCOL(d$article_type), 4)
  expect_equal(NCOL(e), 4)
  expect_that(length(f), equals(1))
  expect_that(length(f$grouped), equals(2))

  #  correct classes
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
  expect_is(c, "sr_group")
  expect_is(d, "list")
  expect_is(d$journal, "data.frame")
  expect_is(e, "data.frame")
})
