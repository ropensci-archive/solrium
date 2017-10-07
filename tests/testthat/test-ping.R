context("ping - regular mode")
test_that("ping works", {
  skip_on_cran()
  skip_if_not(!is_in_cloud_mode(conn))

  if (!conn$core_exists("gettingstarted")) conn$core_create("gettingstarted")
  aa <- conn$ping(name = "gettingstarted")

  expect_is(aa, "list")
  expect_is(aa$responseHeader, "list")
  expect_equal(aa$responseHeader$status, 0)
  expect_equal(aa$responseHeader$params$q, "{!lucene}*:*")
})

test_that("ping gives raw data correctly", {
  skip_on_cran()
  skip_if_not(!is_in_cloud_mode(conn))
  
  expect_is(ping("gettingstarted", raw = TRUE), "ping")
  expect_is(ping("gettingstarted", raw = FALSE), "list")
  expect_is(ping("gettingstarted", wt = "xml", raw = TRUE), "ping")
  expect_is(ping("gettingstarted", wt = "xml", raw = FALSE), "xml_document")
})

test_that("ping fails well", {
  skip_on_cran()
  skip_if_not(!is_in_cloud_mode(conn))
  
  expect_equal(ping()$status, "not found")
  expect_equal(ping("adfdafs")$status, "not found")
})



context("ping - cloud mode")
test_that("ping works", {
  skip_on_cran()
  skip_if_not(is_in_cloud_mode(conn))
  
  if (!conn$collection_exists("gettingstarted")) {
    conn$collection_create("gettingstarted")
  }
  
  aa <- conn$ping(name = "gettingstarted")
  
  expect_is(aa, "list")
  expect_is(aa$responseHeader, "list")
  expect_equal(aa$responseHeader$status, 0)
  expect_equal(aa$responseHeader$params$q, "{!lucene}*:*")
})

test_that("ping gives raw data correctly", {
  skip_on_cran()
  skip_if_not(is_in_cloud_mode(conn))
  
  expect_is(ping(conn, "gettingstarted", raw = TRUE), "ping")
  expect_is(ping(conn, "gettingstarted", raw = FALSE), "list")
  expect_is(ping(conn, "gettingstarted", wt = "xml", raw = TRUE), "ping")
  expect_is(ping(conn, "gettingstarted", wt = "xml", raw = FALSE), "xml_document")
})

test_that("ping fails well", {
  skip_on_cran()
  skip_if_not(is_in_cloud_mode(conn))
  
  expect_error(conn$ping()$status, "argument \"name\" is missing")
  expect_equal(conn$ping("adfdafs")$status, "not found")
})
