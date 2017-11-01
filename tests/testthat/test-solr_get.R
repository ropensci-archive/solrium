context("get")

skip_on_cran()

if (!collection_exists(conn, "gettingstarted")) {
  collection_create(conn, name = "gettingstarted", numShards = 1)
}
ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
invisible(add(ss, conn, name = "gettingstarted"))

test_that("get works with a single id", {
  aa <- solr_get(conn, ids = 1, "gettingstarted")

  expect_is(aa, "list")
  expect_named(aa, c("response"))
  expect_named(aa$response, c("numFound", "start", "docs"))
  expect_is(aa$response$docs, "data.frame")
})

test_that("get works with many ids as vector", {
  aa <- solr_get(conn, ids = c(1, 2), "gettingstarted")

  expect_is(aa, "list")
  expect_named(aa, c("response"))
  expect_equal(NROW(aa$response$docs), 2)
})

test_that("get works with many ids as character string", {
  aa <- solr_get(conn, ids = "1,2", "gettingstarted")

  expect_is(aa, "list")
  expect_named(aa, c("response"))
  expect_equal(NROW(aa$response$docs), 2)
})

test_that("get works with new interface", {
  skip_on_cran()

  aa <- conn$get(1, "gettingstarted")

  expect_is(aa, "list")
  expect_named(aa$response, c("numFound", "start", "docs"))
})

test_that("get fails well", {
  skip_on_cran()

  expect_error(solr_get(), "argument \"conn\" is missing")
  expect_error(solr_get(5), "conn must be a SolrClient object")
})