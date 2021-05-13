context("solr_json_request")

skip_if(solr_missing(conn))
skip_on_ci()

test_that("solr_json_request works", {
  skip_on_cran()

  if (!collection_exists(conn, "books")) {
    collection_create(conn, name = "books")
  }

  a <- conn$json_request("gettingstarted", body = '{"query":"*:*"}')
  alist <- jsonlite::fromJSON(a)

  expect_is(a, "character")
  expect_match(a, "responseHeader")
  expect_match(a, "title")
  expect_named(alist, c("responseHeader", "response"))
  expect_is(alist$response$docs, "data.frame")
})
