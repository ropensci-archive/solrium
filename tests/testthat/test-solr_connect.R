# solr_connect
context("solr_connect")

test_that("solr_connect to remote Solr server works", {
  skip_on_cran()
  
  invisible(aa <- solr_connect('http://api.plos.org/search'))
  
  expect_is(aa, "solr_connection")
  expect_is(aa$url, "character")
  expect_null(aa$proxy)
  expect_is(aa$errors, "character")
  expect_named(aa, c('url', 'proxy', 'errors', 'verbose'))
})

test_that("solr_connect to local Solr server works", {
  skip_on_cran()
  
  invisible(bb <- solr_connect())
  
  expect_is(bb, "solr_connection")
  expect_is(bb$url, "character")
  expect_null(bb$proxy)
  expect_is(bb$errors, "character")
  expect_named(bb, c('url', 'proxy', 'errors', 'verbose'))
})

test_that("solr_connect works with a proxy", {
  skip_on_cran()
  
  port = 3128
  proxy <- list(url = "187.62.207.130", port = port)
  invisible(cc <- solr_connect(proxy = proxy))
  
  expect_is(cc, "solr_connection")
  expect_is(cc$url, "character")
  expect_is(cc$proxy, "request")
  expect_is(cc$proxy$options, "list")
  expect_equal(cc$proxy$options$proxyport, port)
  expect_is(cc$errors, "character")
})

test_that("solr_connect fails well", {
  skip_on_cran()
  
  expect_error(solr_connect("foobar"), "That does not appear to be a url")
  expect_error(solr_connect(errors = 'foo'), "should be one of")
  expect_error(solr_connect(proxy = list(foo = "bar")), 
               "Input to proxy can only contain")
})
