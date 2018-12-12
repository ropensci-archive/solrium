context("cursorMark")

test_that("solr_search and cursorMark", {
  skip_on_cran()

  # no nextCursorMark exists when user doesn't ask for it
  b <- conn_plos$search(params = list(q='*:*', rows=2))
  expect_null(attr(b, "nextCursorMark"))

  # nextCursorMark exists when user gives cursorMark as a param
  a <- conn_plos$search(params = 
    list(q='*:*', rows=100, sort='id asc', cursorMark = "*"))
  expect_is(attr(a, "nextCursorMark"), "character")
  
  # cursor works for another request
  d <- conn_plos$search(params = 
    list(q='*:*', rows=100, sort='id asc', 
      cursorMark = attr(a, "nextCursorMark")))
  expect_is(attr(d, "nextCursorMark"), "character")
})
