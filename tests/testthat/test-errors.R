# errors
context("errors")

test_that("setting errors level gives correct error classes", {
  skip_on_cran()
  
  invisible(aa <- solr_connect('http://api.plos.org/search'))
  invisible(bb <- solr_connect('http://api.plos.org/search', errors = "simple"))
  invisible(cc <- solr_connect('http://api.plos.org/search', errors = "complete"))
  
  expect_is(aa, "solr_connection")
  expect_is(bb, "solr_connection")
  expect_is(cc, "solr_connection")
  expect_is(aa$errors, "character")
  expect_is(bb$errors, "character")
  expect_is(cc$errors, "character")
})

test_that("setting errors level gives correct error values", {
  skip_on_cran()
  
  invisible(aa <- solr_connect('http://api.plos.org/search'))
  invisible(bb <- solr_connect('http://api.plos.org/search', errors = "simple"))
  invisible(cc <- solr_connect('http://api.plos.org/search', errors = "complete"))
  
  expect_equal(aa$errors, "simple")
  expect_equal(bb$errors, "simple")
  expect_equal(cc$errors, "complete")
})

test_that("setting error levels gives correct effect - simple errors", {
  skip_on_cran()
  
  invisible(solr_connect('http://api.plos.org/search', errors = "simple"))
  
  expect_error(solr_search(q = "*:*", rows = "asdf", verbose = FALSE), "500 - For input string")
  expect_error(solr_search(q = "*:*", rows = "asdf", verbose = FALSE), "500 - For input string")
})

test_that("setting error levels gives correct effect - complete errors", {
  skip_on_cran()
  
  invisible(solr_connect('http://api.plos.org/search', errors = "complete"))
  errmssg <- "500 - For input string: \"asdf\"\nAPI stack trace"
  expect_error(solr_search(q = "*:*", rows = "asdf", verbose = FALSE), errmssg)
  expect_error(solr_search(q = "*:*", start = "asdf", verbose = FALSE), errmssg)
  expect_error(solr_search(q = "*:*", sort = "down", verbose = FALSE), 
    "Error : 400 - Can't determine a Sort Order \\(asc or desc\\) in sort spec 'down', pos=4\nAPI stack trace\n\n")
})
