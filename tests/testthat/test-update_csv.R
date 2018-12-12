context("update_csv")

df <- data.frame(id=1:3, name=c('red', 'blue', 'green'))
write.csv(df, file="df.csv", row.names=FALSE, quote = FALSE)

test_that("update_csv works", {
  skip_on_cran()

  if (!conn$collection_exists("books")) conn$collection_create("books")

  aa <- conn$update_csv("df.csv", name = "books")

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))
  expect_true(conn$collection_exists("books"))
})

test_that("update_csv works with old format", {
  skip_on_cran()

  if (!conn$collection_exists("books")) conn$collection_create("books")
  aa <- update_csv(conn, "df.csv", name = "books")

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))
  expect_true(conn$collection_exists("books"))
})

test_that("update_csv fails well", {
  skip_on_cran()

  expect_error(update_csv(), "argument \"conn\" is missing")

  expect_error(update_csv(5), "conn must be a SolrClient object")
})

# cleanup
unlink("df.csv")
