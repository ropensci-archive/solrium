context("solr_search")

test_that("solr_search works", {
  skip_on_cran()

  a <- conn_plos$search(params = list(q='*:*', rows=2, fl='id'))
  b <- conn_plos$search(params = list(q='title:"ecology" AND body:"cell"', fl='title', rows=5))

  # correct dimensions
  expect_that(length(a), equals(1))
  expect_that(length(b), equals(1))

  # correct classes
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
})

test_that("solr_search fails well", {
  skip_on_cran()

  expect_error(conn_plos$search(params = list(q = "*:*", rows = "asdf")), 
               "500 - For input string")
  expect_error(conn_plos$search(params = list(q = "*:*", sort = "down")),
               "400 - Can't determine a Sort Order \\(asc or desc\\) in sort spec 'down'")
  expect_error(conn_plos$search(params = list(q='*:*', fl=c('alm_twitterCount','id'),
                           fq='alm_notafield:[5 TO 50]', rows=10)),
               "undefined field")
  expect_error(conn_plos$search(params = list(q = "*:*", wt = "foobar")),
               "wt must be one of: json, xml, csv")

})

test_that("solr_search works with HathiTrust", {
  skip_on_cran()

  a <- conn_hathi$search(params = list(q = '*:*', rows = 2, fl = 'id'))
  b <- conn_hathi$search(params = list(q = 'language:Spanish', rows = 5))

  # correct dimensions
  expect_equal(NROW(a), 2)
  expect_equal(NROW(b), 5)

  # correct classes
  expect_is(a, "data.frame")
  expect_is(a, "tbl_df")
  expect_is(b, "data.frame")
  expect_is(b, "tbl_df")

  # names
  expect_named(a, "id")
})

# test_that("solr_search works with Datacite", {
#   skip_on_cran()

#   url_dc <- "http://search.datacite.org/api"
#   invisible(solr_connect(url = url_dc, verbose = FALSE))

#   a <- solr_search(q = '*:*', rows = 2)
#   b <- solr_search(q = 'publisher:Data', rows = 5)

#   # correct dimensions
#   expect_equal(NROW(a), 2)
#   expect_equal(NROW(b), 5)

#   # correct classes
#   expect_is(a, "data.frame")
#   expect_is(a, "tbl_df")
#   expect_is(b, "data.frame")
#   expect_is(b, "tbl_df")
# })

test_that("solr_search works with Dryad", {
  skip_on_cran()

  a <- conn_dryad$search(params = list(q = '*:*', rows = 2))
  b <- conn_dryad$search(params = list(q = 'dc.title.en:ecology', rows = 5))

  # correct dimensions
  expect_equal(NROW(a), 2)
  expect_equal(NROW(b), 5)

  # correct classes
  expect_is(a, "data.frame")
  expect_is(a, "tbl_df")
  expect_is(b, "data.frame")
  expect_is(b, "tbl_df")

  # correct content
  expect_true(all(grepl("ecolog", b$dc.title.en, ignore.case = TRUE)))
})
