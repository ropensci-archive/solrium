context("update_json")

test_that("update_json works", {
  skip_on_cran()

  file <- system.file("examples", "books2.json", package = "solrium")
  if (!conn$collection_exists("books")) conn$collection_create("books")
  aa <- conn$update_json(files = file, name = "books")

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))
  expect_true(conn$collection_exists("books"))
})

test_that("update_json works with old format", {
  skip_on_cran()

  file <- system.file("examples", "books2.json", package = "solrium")
  if (!conn$collection_exists("books")) conn$collection_create("books")
  aa <- update_json(conn, files = file, name = "books")

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))
  expect_true(conn$collection_exists("books"))
})

test_that("update_json fails well", {
  skip_on_cran()

  expect_error(update_json(), "argument \"conn\" is missing")

  expect_error(update_json(5), "conn must be a SolrClient object")
})
