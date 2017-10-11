context("update_atomic_json")

test_that("update_atomic_json works", {
  skip_on_cran()

  if (!conn$collection_exists("books")) {
    conn$collection_delete("books")
    conn$collection_create("books")
  }

  file <- system.file("examples", "books2.json", package = "solrium")
  invisible(conn$update_json(file, "books"))

  # get a document
  res1 <- conn$get(ids = 343334534545, "books")

  # atomic update
  body <- '[{
   "id": "343334534545",
   "genre_s": {"set": "mystery" },
   "pages_i": {"inc": 1 }
  }]'
  aa <- conn$update_atomic_json(body, "books")

  # get the document after updating
  res2 <- conn$get(ids = 343334534545, "books")

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))

  expect_is(res1$response$docs, "data.frame")
  expect_equal(res1$response$docs$genre_s, "fantasy")
  expect_equal(res1$response$docs$pages_i, 384)
  expect_is(res2$response$docs, "data.frame")
  expect_equal(res2$response$docs$pages_i, 385)
})

test_that("update_atomic_json fails well", {
  expect_error(update_atomic_json(), "argument \"conn\" is missing")
  expect_error(update_atomic_json(5), "conn must be a SolrClient object")
})
