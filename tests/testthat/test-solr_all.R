context("solr_all")
test_that("solr_all works", {
  skip_on_cran()

  a <- conn_plos$all(params = list(q='*:*', rows=2, fl='id'))
  b <- conn_plos$all(params = list(q='title:"ecology" AND body:"cell"',
                              fl='title', rows=5))

  # correct dimensions
  expect_equal(length(a), 6)
  expect_equal(length(b), 6)

  # correct classes
  expect_is(a, "list")
  expect_is(a$search, "tbl_df")
  expect_is(b, "list")
  expect_is(b$search, "tbl_df")

  # right slot names
  expect_named(a, c('search','facet','high','mlt','group','stats'))
  expect_named(b, c('search','facet','high','mlt','group','stats'))
})

test_that("solr_all fails well", {
  skip_on_cran()

  expect_error(conn_plos$all(params = list(q = "*:*", rows = "asdf")), "500 - For input string")
  expect_error(conn_plos$all(params = list(q = "*:*", sort = "down")),
               "400 - Can't determine a Sort Order \\(asc or desc\\) in sort spec 'down'")
  expect_error(conn_plos$all(params = list(q='*:*', fl=c('alm_twitterCount','id'),
                           fq='alm_notafield:[5 TO 50]', rows=10)),
               "undefined field")
  expect_error(conn_plos$all(params = list(q = "*:*", wt = "foobar")),
               "wt must be one of: json, xml, csv")

})

test_that("solr_all works with HathiTrust", {
  skip_on_cran()

  a <- conn_hathi$all(params = list(q = '*:*', rows = 2, fl = 'id'))
  b <- conn_hathi$all(params = list(q = 'language:Spanish', rows = 5))

  # correct dimensions
  expect_equal(NROW(a$search), 2)
  expect_equal(NROW(b$search), 5)

  # correct classes
  expect_is(a, "list")
  expect_is(a$search, "data.frame")
  expect_is(a$high, "data.frame")
  expect_is(a$group, "data.frame")
  expect_null(b$stats)
  expect_null(b$facet)

  expect_is(b, "list")
  expect_is(a$search, "data.frame")
  expect_is(b$high, "data.frame")
  expect_is(b$group, "data.frame")
  expect_null(b$stats)
  expect_null(b$facet)

  # names
  expect_named(a$search, "id")
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
  expect_is(solr_all(conn_plos,
    params = list(q='*:*', rows=2, fl='id')),
    "list"
  )
})
