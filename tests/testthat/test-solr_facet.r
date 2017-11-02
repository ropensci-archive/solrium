context("solr_facet")

test_that("solr_facet works", {
  skip_on_cran()

  a <- conn_plos$facet(params = list(q='*:*', facet.field='journal'))
  Sys.sleep(2)
  # FIXME: this doesn't work anymore
  # b <- conn_plos$facet(params = list(q='*:*', facet.date='publication_date',
  #                 facet.date.start='NOW/DAY-90DAYS', facet.date.end='NOW',
  #                 facet.date.gap='+1DAY'))
  c <- conn_plos$facet(params = list(q='alcohol', facet.pivot='journal,subject',
                  facet.pivot.mincount=10))

  # correct dimenions
  expect_equal(length(a), 5)
  expect_equal(length(a$facet_queries), 0)
  expect_equal(NCOL(a$facet_fields$journal), 2)

  # expect_that(length(b), equals(5))
  # expect_that(length(b$facet_dates), equals(1))
  # expect_that(dim(b$facet_dates$publication_date), equals(c(6,2)))

  expect_equal(length(c), 5)
  expect_equal(names(c$facet_pivot), c('journal', 'journal,subject'))
  expect_equal(names(c$facet_pivot$journal), c('journal', 'count'))
  expect_equal(names(c$facet_pivot$`journal,subject`), c('journal', 'subject', 'count'))
  expect_true(min(unlist(c$facet_pivot$`journal,subject`$count)) >= 10)

  # correct classes
  expect_is(a, "list")
  # expect_is(b, "list")
  expect_is(c, "list")
  # expect_is(b$facet_dates, "list")
  # expect_is(b$facet_dates$publication_date, "data.frame")
  expect_is(c$facet_pivot, "list")
  expect_is(c$facet_pivot$journal, "data.frame")
  expect_is(c$facet_pivot$`journal,subject`, "data.frame")
})


# test_that("faceting works against HathiTrust", {
#   # regular facet
#   a <- conn_hathi$facet(params = list(q = '*:*', facet.field = 'genre'))
#   # pivot facet
#   c <- conn_hathi$facet(params = list(q = '*:*', facet.pivot = 'genre,publisher',
#                   facet.pivot.mincount = 10))

#   expect_equal(length(a), 5)
#   expect_equal(length(a$facet_queries), 0)
#   expect_equal(NCOL(a$facet_fields$genre), 2)

#   expect_equal(length(c), 5)
#   expect_equal(names(c$facet_pivot), c('genre', 'genre,publisher'))
#   expect_named(c$facet_pivot$genre, c('genre', 'count'))
#   expect_named(c$facet_pivot$`genre,publisher`, c('genre', 'publisher', 'count'))
#   expect_true(min(unlist(c$facet_pivot$`genre,publisher`$count)) >= 10)

#   # correct classes
#   expect_is(a, "list")
#   expect_is(c, "list")
#   expect_is(c$facet_pivot, "list")
#   expect_is(c$facet_pivot$genre, "data.frame")
#   expect_is(c$facet_pivot$`genre,publisher`, "data.frame")
# })

test_that("solr_facet old style works", {
  skip_on_cran()

  expect_is(solr_facet(conn_plos,
    params = list(q='*:*', facet.field='journal')),
    "list"
  )
})
