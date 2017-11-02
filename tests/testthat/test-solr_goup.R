context("solr_group")

test_that("solr_group works", {
  skip_on_cran()

  a <- conn_plos$group(params = list(q='ecology', group.field='journal',
    group.limit=3, fl=c('id','score')))
  Sys.sleep(2)
  b <- conn_plos$group(params = list(q='ecology', group.field='journal',
    group.limit=3, fl=c('id','score','alm_twitterCount'),
    group.sort='alm_twitterCount desc'))
  Sys.sleep(2)
  out <- conn_plos$group(params = list(q='ecology',
    group.field=c('journal','article_type'), group.limit=3, fl='id'),
    raw=TRUE)
  Sys.sleep(2)
  c <- out
  d <- solr_parse(out, 'df')
  e <- conn_plos$group(params = list(q='ecology', group.field='journal', group.limit=3, fl=c('id','score'),
                  group.format='grouped', group.main='true'))

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

test_that("solr_group old style works", {
  skip_on_cran()

  expect_is(solr_group(conn_plos,
    params = list(q='ecology', group.field='journal',
      group.limit=3, fl=c('id','score'))),
    "data.frame"
  )

  expect_is(solr_group(conn_plos,
    params = list(q='ecology', group.field='journal', group.limit=3, fl=c('id','score'),
                  group.format='grouped', group.main='true')),
    "data.frame"
  )
})

