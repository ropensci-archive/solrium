context("add")

test_that("add works with a list and data.frame", {
  skip_on_cran()

  if (!collection_exists(conn, "books")) {
    collection_create(conn, name = "books")
  }

  ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
  aa <- add(ss, conn, name = "books")

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))
  expect_is(conn$get(c(1, 2), "books"), "list")
  expect_named(conn$get(c(1, 2), "books"), "response")


  df <- data.frame(id = c(67, 68), price = c(1000, 500000000))
  aa <- add(df, conn, "books")

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))
})

test_that("add works with new interface", {
  skip_on_cran()

  ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
  aa <- conn$add(ss, name = "books")

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))
})

test_that("add fails well", {
  skip_on_cran()

  expect_error(add(), "no applicable method")
  expect_error(add(5), "no applicable method")
  expect_error(add(mtcars, 4), "conn must be a SolrClient object")
})
