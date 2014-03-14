# tests for solr_mlt fxn in solr
context("solr_mlt")

url <- 'http://api.plos.org/search'

a <- solr_mlt(q='*:*', mlt.count=2, mlt.fl='abstract', fl='score', base=url, fq="doc_type:full", verbose=FALSE)
# b <- solr_mlt(q='*:*', rows=2, mlt.fl='title', mlt.mindf=1, mlt.mintf=1, fl='alm_twitterCount', base=url, key=key)
c <- solr_mlt(q='ecology', mlt.fl='abstract', fl='title', rows=5, base=url, verbose=FALSE)

out <- solr_mlt(q='ecology', mlt.fl='abstract', fl='title', rows=2, base=url, raw=TRUE, wt="xml", verbose=FALSE)
library(XML)
outxml <- xmlParse(out)
outdf <- solr_parse(out, "df")

test_that("solr_mlt returns the correct dimensions", {
  expect_that(dim(a$docs), equals(c(10,2)))
  expect_that(length(a$mlt), equals(10))
  
#   expect_that(dim(b$docs), equals(c(2,2)))
#   expect_that(dim(b$mlt), equals(c(10,2)))
  
  expect_that(dim(c$docs), equals(c(5,2)))
  expect_that(length(c$mlt), equals(4))
  
  expect_that(length(outxml), equals(1))
  expect_that(dim(outdf), equals(c(12,2)))
})

test_that("solr_mlt returns the correct classes", {
  expect_is(a, "list")
#   expect_is(b, "list")
  expect_is(c, "list")
  expect_is(a$docs, "data.frame")
#   expect_is(b$mlt, "data.frame")
  expect_is(c$docs, "data.frame")
  
  expect_is(outxml, "XMLInternalDocument")
  expect_is(outdf, "data.frame")
})