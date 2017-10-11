context("solr_error internal function")

test_that("solr_error works when no errors", {
  skip_on_cran()

  aa <- conn_simp$search(params = list(q = '*:*', rows = 2, fl = 'id'))
  expect_equal(conn$errors, "simple")
  expect_is(aa, "data.frame")
  expect_is(aa$id, "character")

  aa <- solr_search(conn_simp, params = list(q = '*:*', rows = 2, fl = 'id'))
  expect_equal(conn$errors, "simple")
  expect_is(aa, "data.frame")
  expect_is(aa$id, "character")
})


test_that("solr_error works when there should be errors - simple errors", {
  skip_on_cran()

  expect_equal(conn_simp$errors, "simple")
  expect_error(conn_simp$search(params = list(q = '*:*', rows = 5, sort = "things")),
               "Can't determine a Sort Order")
})

test_that("solr_error works when there should be errors - complete errors", {
  skip_on_cran()

  expect_equal(conn_comp$errors, "complete")
  expect_error(conn_comp$search(params = list(q = '*:*', rows = 5, sort = "things")),
               "Can't determine a Sort Order")
})

test_that("solr_error - test directly", {
  skip_on_cran()

  library(crul)
  res <- crul::HttpClient$new(url = "http://api.plos.org/search?wt=json&q=%22synthetic%20biology%22&rows=10&fl=id,title&sort=notasortoption")$get()
  expect_error(solrium:::solr_error(res), "Can't determine a Sort Order \\(asc or desc\\)")
})
