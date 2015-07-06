context("add documents")

test_that("adding documents from a list works", {
  skip_on_cran()
  
  ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
  list_out <- add(ss)
  
  expect_is(list_out, "list")
  expect_equal(list_out$responseHeader$status, 0)
})

test_that("adding documents from a data.frame works", {
  skip_on_cran()
  
  df <- data.frame(id = c(67, 68), price = c(1000, 500000000))
  df_out <- add(df)
  
  expect_is(df_out, "list")
  expect_equal(df_out$responseHeader$status, 0)
})
