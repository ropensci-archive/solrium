context("delete_by_id")

test_that("delete by ", {
  skip_on_cran()

  if (!collection_exists(conn, "gettingstarted")) {
    collection_create(conn, name = "gettingstarted", numShards = 1)
  }
  ss <- list(list(id = 1, price = 100), list(id = 2, price = 500),
            list(id = 3, price = 100), list(id = 4, price = 500))
  invisible(add(ss, conn, name = "gettingstarted"))

  # single id
  aa <- conn$delete_by_id(ids = 1, "gettingstarted")

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))

  # many ids
  aa <- conn$delete_by_id(ids = c(3, 4), "gettingstarted")

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))

  res <- conn$get(ids = 3:4, "gettingstarted")
  expect_equal(length(res$response$docs), 0)
})

context("delete_by_query")

test_that("delete by many ids", {
  skip_on_cran()

  ss <- list(list(id = 10, title = "adfadsf"), list(id = 12, title = "though"),
          list(id = 13, title = "cheese"), list(id = 14, title = "animals"))
  invisible(add(ss, conn, name = "gettingstarted"))

  aa <- conn$delete_by_query(query = "title:cheese", "gettingstarted")

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))

  res <- conn$search("gettingstarted", params = list(q = "title:cheese"))
  expect_equal(NROW(res), 0)
})

test_that("delete fails well", {
  skip_on_cran()

  expect_error(delete_by_id(), "argument \"conn\" is missing")
  expect_error(delete_by_query(), "argument \"conn\" is missing")

  expect_error(delete_by_id(5), "conn must be a SolrClient object")
  expect_error(delete_by_query(5), "conn must be a SolrClient object")
})
