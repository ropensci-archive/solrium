context("schema - cloud mode")

test_that("both R6 and normal function call work", {
  skip_on_cran()

  expect_is(conn$schema, "function")
  expect_equal(names(formals(schema))[1], "conn")
})

test_that("schema works against", {
  skip_on_cran()
  skip_if_not(!is_in_cloud_mode(conn))

  aa <- conn$schema(name = "gettingstarted")
  bb <- conn$schema(name = "gettingstarted", what = "fields")

  expect_is(conn$schema(name = "gettingstarted", "dynamicfields"), "list")
  expect_is(conn$schema(name = "gettingstarted", "fieldtypes"), "list")
  expect_is(conn$schema(name = "gettingstarted", "copyfields"), "list")
  expect_is(conn$schema(name = "gettingstarted", "name"), "list")
  expect_is(conn$schema(name = "gettingstarted", "version"), "list")
  expect_is(conn$schema(name = "gettingstarted", "uniquekey"), "list")
  expect_is(conn$schema(name = "gettingstarted", "similarity"), "list")

  expect_is(aa, "list")
  expect_is(aa$responseHeader, "list")
  expect_is(aa$schema, "list")
  expect_is(aa$schema$name, "character")

  expect_is(bb, "list")
  expect_is(bb$fields, "data.frame")
})

test_that("schema fails well", {
  skip_on_cran()
  skip_if_not(!is_in_cloud_mode(conn))

  expect_error(conn$schema(), "argument \"name\" is missing")
  expect_error(conn$schema(name = "gettingstarted", "stuff"), "Not Found")
})

test_that("schema old style works", {
  skip_on_cran()

  expect_is(schema(conn, name = "gettingstarted"),
    "list"
  )
})
