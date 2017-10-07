context("SolrClient")

test_that("SolrClient to remote Solr server works", {
  skip_on_cran()
  
  aa <- SolrClient$new(host = 'api.plos.org', path = 'search', port = NULL)
  
  expect_is(aa, "SolrClient")
  expect_is(aa$host, "character")
  expect_null(aa$proxy)
  expect_is(aa$errors, "character")
  expect_true(all(c('host', 'proxy', 'errors') %in% names(aa)))
})

test_that("SolrClient to local Solr server works", {
  skip_on_cran()
  
  bb <- SolrClient$new()
  
  expect_is(bb, "SolrClient")
  expect_is(bb$host, "character")
  expect_null(bb$proxy)
  expect_is(bb$errors, "character")
  expect_true(all(c('host', 'proxy', 'errors') %in% names(bb)))
})

test_that("SolrClient works with a proxy", {
  skip_on_cran()
  
  port <- 3128
  proxy <- list(url = "187.62.207.130", port = port)
  cc <- SolrClient$new(proxy = proxy)
  
  expect_is(cc, "SolrClient")
  expect_is(cc$host, "character")
  expect_is(cc$proxy, "proxy")
  expect_is(cc$proxy$proxy, "character")
})

test_that("SolrClient fails well", {
  skip_on_cran()
  
  #expect_error(SolrClient$new(host = "foobar"), "That does not appear to be a url")
  expect_error(SolrClient$new(errors = 'foo'), "errors must be one of")
  expect_error(SolrClient$new(proxy = list(foo = "bar")), "proxy URL not")
})
