context("core_create")

test_that("core_create gives correct dimensions", {
  skip_on_cran()
  
  solr_connect(verbose = FALSE)
  
  aa <- core_create()
  
  # correct dimenions
  expect_equal(length(a), 1)
})

test_that("core_create gives correct classes", {
  skip_on_cran()
  
  solr_connect(verbose = FALSE)
  
  aa <- ""
  
  expect_is(a, "sr_stats")
})

test_that("core_create fails well", {
  skip_on_cran()
  
  solr_connect(verbose = FALSE)
  
  expect_error()
})
