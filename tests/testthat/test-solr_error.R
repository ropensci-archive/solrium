context("solr_error internal function")

test_that("solr_error works when no errors", {
  skip_on_cran()

  invisible(solr_connect('http://api.plos.org/search', verbose = FALSE))
  
  aa <- solr_search(q = '*:*', rows = 2, fl = 'id')
  expect_equal(solr_settings()$errors, "simple")
  expect_is(aa, "data.frame")
  expect_is(aa$id, "character")
})


test_that("solr_error works when there should be errors - simple errors", {
  skip_on_cran()
  
  invisible(solr_connect('http://api.plos.org/search', verbose = FALSE))
  
  expect_equal(solr_settings()$errors, "simple")
  expect_error(solr_search(q = '*:*', rows = 5, sort = "things"), 
               "Can't determine a Sort Order")
})

test_that("solr_error works when there should be errors - complete errors", {
  skip_on_cran()
  
  invisible(solr_connect('http://api.plos.org/search', 
                         errors = "complete", 
                         verbose = FALSE))
  
  expect_equal(solr_settings()$errors, "complete")
  expect_error(solr_search(q = '*:*', rows = 5, sort = "things"), 
               "Can't determine a Sort Order")
  expect_error(solr_search(q = '*:*', rows = 5, sort = "things"), 
               "no stack trace")
})

test_that("solr_error - test directly", {
  skip_on_cran()
  
  invisible(solr_connect('http://api.plos.org/search', 
                         errors = "complete", 
                         verbose = FALSE))
  
  library("httr")
  res <- GET("http://api.plos.org/search?wt=json&q=%22synthetic%20biology%22&rows=10&fl=id,title&sort=notasortoption")
  expect_error(solrium:::solr_error(res), "Can't determine a Sort Order \\(asc or desc\\)")
})
