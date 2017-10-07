context("solr_mlt")

test_that("solr_mlt works", {
  skip_on_cran()

  a <- conn_plos$mlt(params = list(q='*:*', mlt.count=2, mlt.fl='abstract', fl='score', fq="doc_type:full"))
  c <- conn_plos$mlt(params = list(q='ecology', mlt.fl='abstract', fl='title', rows=5))

  out <- conn_plos$mlt(params = list(q='ecology', mlt.fl='abstract', fl='title', rows=2, wt="xml"), raw=TRUE)
  library("xml2")
  outxml <- read_xml(unclass(out))
  outdf <- solr_parse(out, "df")

  # correct dimensions
  expect_equal(dim(a$docs), c(10,2))
  expect_equal(dim(c$docs), c(5, 2))
  expect_equal(length(c$mlt), 5)

  expect_equal(length(outxml), 2)
  expect_equal(dim(outdf$mlt[[1]]), c(5, 5))

  # correct classes
  expect_is(a, "list")
  #   expect_is(b, "list")
  expect_is(c, "list")
  expect_is(a$docs, "data.frame")
  #   expect_is(b$mlt, "data.frame")
  expect_is(c$docs, "data.frame")

  expect_is(outxml, "xml_document")
  expect_is(outdf, "list")
  expect_is(outdf$mlt[[1]], "data.frame")
})
