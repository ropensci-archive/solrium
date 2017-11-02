context("solr_mlt")

test_that("solr_mlt works", {
  skip_on_cran()

  a <- conn_plos$mlt(params = list(q='*:*', mlt.count=2,
    mlt.fl='abstract', fl='score', fq="doc_type:full"))
  Sys.sleep(2)
  c <- conn_plos$mlt(params = list(q='ecology', mlt.fl='abstract',
    fl='title', rows=5))
  Sys.sleep(2)

  out <- conn_plos$mlt(params = list(q='ecology', mlt.fl='abstract',
    fl='title', rows=2, wt="xml"), raw=TRUE)
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

test_that("solr_mlt old style works", {
  skip_on_cran()

  expect_is(
    solr_mlt(conn_plos,
      params = list(q='*:*', mlt.count=2,
        mlt.fl='abstract', fl='score', fq="doc_type:full")),
    "list"
  )

  expect_is(
    solr_mlt(conn_plos,
      params = list(q='ecology',
        mlt.fl='abstract', fl='title', rows=5)),
    "list"
  )
})





test_that("solr_mlt optimize max rows with lower boundary", {
  skip_on_cran()

  a <- conn_plos$mlt(params = list(q='*:*', mlt.count=2, mlt.fl='abstract', rows=1))
  query <- paste0('id:', a$docs$id)
  b <- conn_plos$mlt(params = list(q=query, mlt.count=2, mlt.fl='abstract', rows=1))
  cc <- conn_plos$mlt(params = list(q=query, mlt.count=2, mlt.fl='abstract', rows=-1))

  expect_identical(b, cc)
})

test_that("solr_mlt optimize max rows with upper boundary", {
  skip_on_cran()

  a <- conn_plos$mlt(params = list(q='*:*', mlt.count=2, mlt.fl='abstract', rows=1))
  query <- paste0('id:', a$docs$id)
  b <- conn_plos$mlt(params = list(q=query, mlt.count=2, mlt.fl='abstract', rows=1))
  c <- conn_plos$mlt(params = list(q=query, mlt.count=2, mlt.fl='abstract', rows=50000))

  expect_identical(b, c)
})

test_that("solr_mlt optimize max rows with rows higher than upper boundary", {
  skip_on_cran()

  a <- conn_plos$mlt(params = list(q='ecology', mlt.count=2, mlt.fl='abstract', rows=1))
  query <- paste0('id:', a$docs$id)
  b <- conn_plos$mlt(params = list(q=query, mlt.count=2, mlt.fl='abstract', rows=1))
  c <- conn_plos$mlt(params = list(q=query, mlt.count=2, mlt.fl='abstract', rows=50001))

  expect_identical(b, c)
})

test_that("solr_mlt optimize max rows with rows=31 and minOptimizedRows=30", {
  skip_on_cran()

  a <- conn_plos$mlt(params = list(q='*:*', mlt.count=2, mlt.fl='abstract', rows=1))
  query <- paste0('id:', a$docs$id)
  b <- conn_plos$mlt(params = list(q=query, mlt.count=2, mlt.fl='abstract', rows=1))
  c <- conn_plos$mlt(params = list(q=query, mlt.count=2, mlt.fl='abstract', rows=31),
    optimizeMaxRows=TRUE, minOptimizedRows=30)

  expect_identical(b, c)
})


test_that("solr_mlt fails if optimize max rows is disabled with rows equal to -1", {
  skip_on_cran()

  expect_error(
    conn_plos$mlt(params = list(q='*:*', mlt.count=2, mlt.fl='abstract', rows=-1),
      optimizeMaxRows=FALSE),
    "'rows' parameter cannot be negative"
  )
})
