# tests for solr_group fxn in solr
context("solr_group")

url <- 'http://api.plos.org/search'
key = getOption('PlosApiKey')

a <- solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score', url=url, key=key)
b <- solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score,alm_twitterCount', 
   group.sort='alm_twitterCount desc', url=url, key=key)
out <- solr_group(q='ecology', group.field='journal,article_type', group.limit=3, fl='id', url=url, key=key, raw=TRUE)
c <- out
d <- solr_parse(out, 'df')
e <- solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score', 
                group.format='grouped', group.main='true', url=url, key=key)

library(rjson)
f <- fromJSON(out)

test_that("solr_search returns the correct dimensions in the data.frame", {
  expect_that(dim(a), equals(c(26,5)))
  expect_that(dim(b), equals(c(26,6)))
  expect_that(length(c), equals(1))
  expect_that(length(d), equals(2))
  expect_that(dim(d$article_type), equals(c(29,4)))
  expect_that(dim(e), equals(c(10,4)))
  expect_that(length(f), equals(1))
  expect_that(length(f$grouped), equals(2))
})

test_that("solr_search returns the correct classes", {
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
  expect_is(c, "sr_group")
  expect_is(d, "list")
  expect_is(d$journal, "data.frame")
  expect_is(e, "data.frame")
})