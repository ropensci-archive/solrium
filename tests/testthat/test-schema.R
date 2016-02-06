# schema
context("schema")

test_that("schema works against", {
  skip_on_cran()

  invisible(solr_connect(verbose = FALSE))

  aa <- schema(name = "gettingstarted")
  bb <- schema(name = "gettingstarted", "fields")
  
  expect_is(schema(name = "gettingstarted", "dynamicfields"), "list")
  expect_is(schema(name = "gettingstarted", "fieldtypes"), "list")
  expect_is(schema(name = "gettingstarted", "copyfields"), "list")
  expect_is(schema(name = "gettingstarted", "name"), "list")
  expect_is(schema(name = "gettingstarted", "version"), "list")
  expect_is(schema(name = "gettingstarted", "uniquekey"), "list")
  expect_is(schema(name = "gettingstarted", "similarity"), "list")

  expect_is(aa, "list")
  expect_is(aa$responseHeader, "list")
  expect_is(aa$schema, "list")
  expect_is(aa$schema$name, "character")
  
  expect_is(bb, "list")
  expect_is(bb$fields, "data.frame")
})

test_that("schema fails well", {
  skip_on_cran()
  
  invisible(solr_connect(verbose = FALSE))
  
  expect_error(schema(), "argument \"name\" is missing")
  expect_error(schema(name = "gettingstarted", "stuff"), "Client error")
})
