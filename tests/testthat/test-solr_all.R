context("solr_all")
test_that("solr_all works", {
  skip_on_cran()

  a <- conn_plos$all(params = list(q='*:*', rows=2, fl='id'))

  # correct dimensions
  expect_equal(length(a), 6)

  # correct classes
  expect_is(a, "list")
  expect_is(a$search, "tbl_df")

  # right slot names
  expect_named(a, c('search','facet','high','mlt','group','stats'))
})

test_that("solr_all fails well", {
  skip_on_cran()

  expect_error(conn_plos$all(params = list(q = "*:*", rows = "asdf")),
    "rows should be a numeric or integer class value")
  Sys.sleep(2)
  expect_error(conn_plos$all(params = list(q = "*:*", sort = "down")),
               "400 - Can't determine a Sort Order \\(asc or desc\\) in sort spec 'down'")
  Sys.sleep(2)
  expect_error(conn_plos$all(params = list(q='*:*', fl=c('alm_twitterCount','id'),
                           fq='alm_notafield:[5 TO 50]', rows=10)),
               "undefined field")
  expect_error(conn_plos$all(params = list(q = "*:*", wt = "foobar")),
               "wt must be one of: json, xml, csv")

})

test_that("solr_all works with Datacite", {
  skip_on_cran()

  a <- conn_dc$all(params = list(q = '*:*', rows = 2))
  b <- conn_dc$all(params = list(q = 'publisher:Data', rows = 5))
  # correct dimensions
  expect_equal(NROW(a$search), 2)
  expect_equal(NROW(b$search), 5)
})


test_that("solr_all old style works", {
  skip_on_cran()

  expect_is(solr_all(conn_plos,
    params = list(q='*:*', rows=2, fl='id')),
    "list"
  )
})


test_that("solr_all optimize max rows with lower boundary", {
  skip_on_cran()

  a <- conn_plos$all(params = list(q='*:*', rows=1, fl='id'))
  query <- paste0('id:', a$search$id)
  b <- conn_plos$all(params = list(q=query, rows=1, fl='id'))
  cc <- conn_plos$all(params = list(q=query, rows=-1, fl='id'))

  expect_identical(b, cc)
})

test_that("solr_all optimize max rows with upper boundary", {
  skip_on_cran()

  a <- conn_plos$all(params = list(q='*:*', rows=1, fl='id'))
  query <- paste0('id:', a$search$id)
  b <- conn_plos$all(params = list(q=query, rows=1, fl='id'))
  c <- conn_plos$all(params = list(q=query, rows=50000, fl='id'))

  expect_identical(b, c)
})

test_that("solr_all optimize max rows with rows higher than upper boundary", {
  skip_on_cran()

  a <- conn_plos$all(params = list(q='*:*', rows=1, fl='id'))
  query <- paste0('id:', a$search$id)
  b <- conn_plos$all(params = list(q=query, rows=1, fl='id'))
  c <- conn_plos$all(params = list(q=query, rows=50001, fl='id'))

  expect_identical(b, c)
})

test_that("solr_all optimize max rows with rows=31 and minOptimizedRows=30", {
  skip_on_cran()

  a <- conn_plos$all(params = list(q='*:*', rows=1, fl='id'))
  query <- paste0('id:', a$search$id)
  b <- conn_plos$all(params = list(q=query, rows=1, fl='id'))
  c <- conn_plos$all(params = list(q=query, rows=31, fl='id'), optimizeMaxRows=TRUE, minOptimizedRows=30)

  expect_identical(b, c)
})


test_that("solr_all fails if optimize max rows is disabled with rows equal to -1", {
  skip_on_cran()

  expect_error(
    conn_plos$all(params = list(q='*:*', rows=-1, fl='id'), optimizeMaxRows=FALSE),
    "'rows' parameter cannot be negative"
  )
})


test_that("solr_all: attributes", {
  skip_on_cran()

  a <- conn_dc$all(params = list(q = '*:*', rows = 2))
  expect_is(attr(a, "responseHeader"), "list")
  expect_named(attr(a, "responseHeader"), c("status", "QTime"))
})
