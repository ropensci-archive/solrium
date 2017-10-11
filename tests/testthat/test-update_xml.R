context("update_xml")

test_that("update_xml works", {
  skip_on_cran()

  file <- system.file("examples", "books.xml", package = "solrium")
  if (!conn$collection_exists("books")) conn$collection_create("books")
  aa <- conn$update_xml(files = file, name = "books")

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))
  expect_true(conn$collection_exists("books"))
})

test_that("update_xml works with old format", {
  skip_on_cran()

  file <- system.file("examples", "books.xml", package = "solrium")
  if (!conn$collection_exists("books")) conn$collection_create("books")
  aa <- update_xml(conn, files = file, name = "books")

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))
  expect_true(conn$collection_exists("books"))
})

test_that("update_xml fails well", {
  skip_on_cran()

  expect_error(update_xml(), "argument \"conn\" is missing")

  expect_error(update_xml(5), "conn must be a SolrClient object")
})
