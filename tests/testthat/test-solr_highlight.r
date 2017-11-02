context("solr_highlight")

test_that("solr_highlight works", {
  skip_on_cran()

  a <- conn_plos$highlight(params = list(q='alcohol', hl.fl = 'abstract',
                                         rows=10))
  Sys.sleep(2)
  b <- conn_plos$highlight(params = list(q='alcohol',
                                         hl.fl = c('abstract','title'),
                                         rows=3))

  # correct dimensions
  expect_that(NROW(a), equals(10))
  expect_that(NCOL(a), equals(2))
  expect_that(NROW(b), equals(3))
  expect_that(NCOL(b), equals(3))

  # correct classes
  expect_is(a, "tbl_df")
  expect_is(a$abstract, "character")

  expect_is(b, "tbl_df")
  expect_is(b$abstract, "character")
  expect_is(b$title, "character")
})

test_that("solr_highlight old style works", {
  skip_on_cran()

  expect_is(solr_highlight(conn_plos,
    params = list(q='alcohol', hl.fl = 'abstract', rows=10)),
    "tbl_df"
  )

  expect_is(solr_highlight(conn_plos,
    params = list(q='alcohol',
      hl.fl = c('abstract','title'), rows=3)),
    "tbl_df"
  )
})
