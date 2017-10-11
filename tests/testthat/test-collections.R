context("collections")

test_that("collections works - no collections", {
  skip_on_cran()
  skip_if_not(is_in_cloud_mode(conn))

  if (conn$collection_exists("books")) conn$collection_delete("books")
  if (conn$collection_exists("gettingstarted")) conn$collection_delete("gettingstarted")

  aa <- collections(conn)

  expect_is(aa, "character")
  expect_equal(length(aa), 0)
})

test_that("collections works - with some collections", {
  skip_on_cran()
  skip_if_not(is_in_cloud_mode(conn))

  if (!conn$collection_exists("books")) conn$collection_create("books")
  if (!conn$collection_exists("gettingstarted")) conn$collection_create("gettingstarted")

  aa <- collections(conn)

  expect_is(aa, "character")
  expect_equal(length(aa), 2)
})

test_that("collections works - new way of using", {
  skip_on_cran()
  skip_if_not(is_in_cloud_mode(conn))

  if (!conn$collection_exists("books")) conn$collection_create("books")
  if (!conn$collection_exists("gettingstarted")) conn$collection_create("gettingstarted")

  aa <- conn$collection_list()

  expect_is(aa, "list")
  expect_named(aa, c('responseHeader', 'collections'))
})

test_that("collections fails well", {
  expect_error(collections(), "argument \"conn\" is missing")
  expect_error(collections(5), "conn must be a SolrClient")
})
