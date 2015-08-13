# solr_settings
context("solr_settings")

test_that("solr_settings gives right classes", {
  skip_on_cran()
  
  invisible(solr_connect('http://api.plos.org/search'))
  aa <- solr_settings()
  
  expect_is(aa, "solr_connection")
  expect_is(aa$url, "character")
  expect_null(aa$proxy)
  expect_is(aa$errors, "character")
})


test_that("solr_settings gives right values", {
  skip_on_cran()
  
  invisible(solr_connect('http://api.plos.org/search'))
  aa <- solr_settings()
  
  expect_equal(aa$errors, "simple")
})


test_that("solr_settings fails with a argument passed", {
  skip_on_cran()
  
  expect_error(solr_settings(3), "unused argument")
})
