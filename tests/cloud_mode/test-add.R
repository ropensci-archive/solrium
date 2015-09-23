context("add documents")

# Using with Solr Cloud mode

test_that("adding documents from a ", {
  solr_connect()

  # setup
  pinged <- ping(name = "helloWorld", verbose = FALSE)$status
  if (pinged != "OK") collection_create(name = "helloWorld", numShards = 2)

  # list works
  ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
  list_out <- add(ss, "helloWorld")

  expect_is(list_out, "list")
  expect_equal(list_out$responseHeader$status, 0)

  # data.frame works
  df <- data.frame(id = c(67, 68), price = c(1000, 500000000))
  df_out <- add(df, "helloWorld")

  expect_is(df_out, "list")
  expect_equal(df_out$responseHeader$status, 0)
})
