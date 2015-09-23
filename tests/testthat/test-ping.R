# ping
context("ping")

test_that("ping works against", {
  skip_on_cran()

  invisible(solr_connect(verbose = FALSE))

  aa <- ping(name = "gettingstarted")

  expect_is(aa, "list")
  expect_is(aa$responseHeader, "list")
  expect_equal(aa$responseHeader$status, 0)
  expect_equal(aa$responseHeader$params$q, "{!lucene}*:*")
})

test_that("ping gives raw data correctly", {
  skip_on_cran()
  
  solr_connect(verbose = FALSE)
  
  expect_is(ping("gettingstarted", raw = TRUE), "ping")
  expect_is(ping("gettingstarted", raw = FALSE), "list")
  expect_is(ping("gettingstarted", wt = "xml", raw = TRUE), "ping")
  expect_is(ping("gettingstarted", wt = "xml", raw = FALSE), "XMLInternalDocument")
})

test_that("ping fails well", {
  skip_on_cran()

  solr_connect(verbose = FALSE)

  expect_equal(ping()$status, "not found")
  expect_equal(ping("adfdafs")$status, "not found")
})
