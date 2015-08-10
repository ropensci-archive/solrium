context("solr_mlt")

test_that("solr_mlt works", {
  skip_on_cran()

  solr_connect('http://api.plos.org/search', verbose=FALSE)

  a <- solr_mlt(q='*:*', mlt.count=2, mlt.fl='abstract', fl='score', fq="doc_type:full")
  # b <- solr_mlt(q='*:*', rows=2, mlt.fl='title', mlt.mindf=1, mlt.mintf=1, fl='alm_twitterCount', base=url, key=key)
  c <- solr_mlt(q='ecology', mlt.fl='abstract', fl='title', rows=5)

  out <- solr_mlt(q='ecology', mlt.fl='abstract', fl='title', rows=2, raw=TRUE, wt="xml")
  library("XML")
  outxml <- xmlParse(out)
  outdf <- solr_parse(out, "df")

  # correct dimensions
  expect_that(dim(a$docs), equals(c(10,2)))
  expect_that(dim(c$docs), equals(c(5,2)))
  expect_that(length(c$mlt), equals(4))

  expect_that(length(outxml), equals(1))
  expect_that(dim(outdf), equals(c(12,2)))

  # correct classes
  expect_is(a, "list")
  #   expect_is(b, "list")
  expect_is(c, "list")
  expect_is(a$docs, "data.frame")
  #   expect_is(b$mlt, "data.frame")
  expect_is(c$docs, "data.frame")

  expect_is(outxml, "XMLInternalDocument")
  expect_is(outdf, "data.frame")
})
