context("collections management")

test_that("adding a collection works", {
  skip_on_cran()

  solr_connect()
  ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))

  # setup
  pinged <- ping(name = "helloWorld", verbose = FALSE)$status
  if (pinged != "OK") collection_delete(name = "helloWorld")

  # add collection
  list_out <- add(ss, "helloWorld")

  expect_is(list_out, "list")
  expect_equal(list_out$responseHeader$status, 0)
})

test_that("adding a collection fails well", {
  skip_on_cran()

  solr_connect()

  expect_error(collection_create(name = "helloWorld", verbose = FALSE), "collection already exists")
})
