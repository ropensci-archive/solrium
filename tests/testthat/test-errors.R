# errors
context("errors")

test_that("setting errors level gives correct error classes", {
  skip_on_cran()

  expect_is(conn_simp, "SolrClient")
  expect_is(conn_comp, "SolrClient")
  expect_is(conn_simp$errors, "character")
  expect_is(conn_comp$errors, "character")
})

test_that("setting errors level gives correct error values", {
  skip_on_cran()

  expect_equal(conn_plos$errors, "simple")
  expect_equal(conn_simp$errors, "simple")
  expect_equal(conn_comp$errors, "complete")
})

test_that("setting error levels gives correct effect - simple errors", {
  skip_on_cran()

  expect_error(conn_simp$search(params = list(q = "*:*", rows = "asdf")),
               "rows should be a numeric or integer class value")
  expect_error(conn_simp$search(params = list(q = "*:*", rows = "asdf")),
               "rows should be a numeric or integer class value")
})

test_that("setting error levels gives correct effect - complete errors", {
  skip_on_cran()

  expect_error(conn_comp$search(params = list(q = "*:*", rows = "asdf")),
               "rows should be a numeric or integer class value")
  expect_error(conn_comp$search(params = list(q = "*:*", start = "asdf")),
               "500 - For input string: \"asdf\"")
  expect_error(conn_comp$search(params = list(q = "*:*", sort = "down")),
    "400 - Can't determine a Sort Order \\(asc or desc\\) in sort spec 'down'")
})
