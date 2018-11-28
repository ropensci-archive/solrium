context("solr_search")

test_that("solr_search works", {
  skip_on_cran()

  a <- conn_plos$search(params = list(q='*:*', rows=2, fl='id'))
  Sys.sleep(2)
  b <- conn_plos$search(params = list(q='title:"ecology" AND body:"cell"', fl='title', rows=5))
  Sys.sleep(2)

  # correct dimensions
  expect_that(length(a), equals(1))
  expect_that(length(b), equals(1))

  # correct classes
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")

  expect_is(
    solr_search(conn_plos, params = list(q='*:*', rows=2, fl='id')),
    "tbl_df")
  expect_is(
    solr_search(conn_plos, params = list(q='title:"ecology" AND body:"cell"',
      fl='title', rows=5)), "tbl_df")
})

test_that("solr_search fails well", {
  skip_on_cran()

  expect_error(conn_plos$search(params = list(q = "*:*", rows = "asdf")),
               "rows should be a numeric or integer")
  expect_error(solr_search(conn_plos, params = list(q = "*:*", rows = "asdf")),
               "rows should be a numeric or integer")
  expect_error(conn_plos$search(params = list(q = "*:*", sort = "down")),
               "400 - Can't determine a Sort Order \\(asc or desc\\) in sort spec 'down'")
  expect_error(conn_plos$search(params = list(q='*:*', fl=c('alm_twitterCount','id'),
                           fq='alm_notafield:[5 TO 50]', rows=10)),
               "undefined field")
  expect_error(conn_plos$search(params = list(q = "*:*", wt = "foobar")),
               "wt must be one of: json, xml, csv")

})


# test_that("solr_search works with Dryad", {
#   skip_on_cran()

#   a <- conn_dryad$search(params = list(q = '*:*', rows = 2))
#   Sys.sleep(2)
#   b <- conn_dryad$search(params = list(q = 'dc.title.en:ecology', rows = 5))

#   # correct dimensions
#   expect_equal(NROW(a), 2)
#   expect_equal(NROW(b), 5)

#   # correct classes
#   expect_is(a, "data.frame")
#   expect_is(a, "tbl_df")
#   expect_is(b, "data.frame")
#   expect_is(b, "tbl_df")

#   # correct content
#   expect_true(all(grepl("ecolog", b$dc.title.en, ignore.case = TRUE)))

#   # solr_search
#   expect_is(solr_search(conn_dryad, params = list(q = '*:*', rows = 2)),
#     "tbl_df")
#   expect_is(
#     solr_search(conn_dryad, params = list(q = 'dc.title.en:ecology', rows = 5)),
#     "tbl_df")
# })



test_that("solr_search optimize max rows with lower boundary", {
  skip_on_cran()

  a <- conn_plos$search(params = list(q='*:*', rows=1, fl='id'))
  query <- paste0('id:', a$id)
  b <- conn_plos$search(params = list(q=query, rows=1, fl='id'))
  cc <- conn_plos$search(params = list(q=query, rows=-1, fl='id'))

  expect_identical(b, cc)
})

test_that("solr_search optimize max rows with upper boundary", {
  skip_on_cran()

  a <- conn_plos$search(params = list(q='*:*', rows=1, fl='id'))
  query <- paste0('id:', a$id)
  b <- conn_plos$search(params = list(q=query, rows=1, fl='id'))
  c <- conn_plos$search(params = list(q=query, rows=50000, fl='id'))

  expect_identical(b, c)
})

test_that("solr_search optimize max rows with rows higher than upper boundary", {
  skip_on_cran()

  a <- conn_plos$search(params = list(q='*:*', rows=1, fl='id'))
  query <- paste0('id:', a$id)
  b <- conn_plos$search(params = list(q=query, rows=1, fl='id'))
  c <- conn_plos$search(params = list(q=query, rows=50001, fl='id'))

  expect_identical(b, c)
})

test_that("solr_search optimize max rows with rows=31 and minOptimizedRows=30", {
  skip_on_cran()

  a <- conn_plos$search(params = list(q='*:*', rows=1, fl='id'))
  query <- paste0('id:', a$id)
  b <- conn_plos$search(params = list(q=query, rows=1, fl='id'))
  c <- conn_plos$search(params = list(q=query, rows=31, fl='id'), optimizeMaxRows=TRUE, minOptimizedRows=30)

  expect_identical(b, c)
})


test_that("solr_search fails if optimize max rows is disabled with rows equal to -1", {
  skip_on_cran()

  expect_error(
    conn_plos$search(params = list(q='*:*', rows=-1, fl='id'), optimizeMaxRows=FALSE),
    "'rows' parameter cannot be negative"
  )
})
