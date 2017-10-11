context("update_atomic_xml")

library(xml2)

test_that("update_atomic_xml works", {
  skip_on_cran()

  if (conn$collection_exists("books")) {
    conn$collection_delete("books")
  }
  conn$collection_create("books")

  # Add documents
  file <- system.file("examples", "books.xml", package = "solrium")
  invisible(conn$update_xml(file, "books"))

  # get a document
  res1 <- conn$get(ids = '978-0641723445', "books", wt = "xml")
  res1_genre <- xml2::xml_text(
    xml2::xml_find_all(res1, '//doc//str[@name="genre_s"]'))
  res1_pages <- xml2::xml_text(
    xml2::xml_find_all(res1, '//doc//int[@name="pages_i"]'))

  # atomic update
  body <- '
  <add>
   <doc>
     <field name="id">978-0641723445</field>
     <field name="genre_s" update="set">mystery</field>
     <field name="pages_i" update="inc">1</field>
   </doc>
  </add>'
  aa <- conn$update_atomic_xml(body, name="books")

  # get the document again
  res2 <- conn$get(ids = '978-0641723445', "books", wt = "xml")
  res2_genre <- xml2::xml_text(
    xml2::xml_find_all(res2, '//doc//str[@name="genre_s"]'))
  res2_pages <- xml2::xml_text(
    xml2::xml_find_all(res2, '//doc//int[@name="pages_i"]'))

  expect_is(aa, "list")
  expect_named(aa, c("responseHeader"))
  expect_is(res1, "xml_document")
  expect_equal(res1_genre, "fantasy")
  expect_equal(res1_pages, "384")

  expect_is(res2, "xml_document")
  expect_equal(res2_genre, "mystery")
  expect_equal(res2_pages, "385")
})

test_that("update_atomic_xml fails well", {
  expect_error(update_atomic_xml(), "argument \"conn\" is missing")
  expect_error(update_atomic_xml(5), "conn must be a SolrClient object")
})
