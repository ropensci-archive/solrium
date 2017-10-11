#' Atomic updates with XML data
#'
#' Atomic updates to parts of Solr documents
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param body (character) XML as a character string
#' @param name (character) Name of the core or collection
#' @param wt (character) One of json (default) or xml. If json, uses
#' [jsonlite::fromJSON()] to parse. If xml, uses [xml2::read_xml()] to parse
#' @param raw (logical) If `TRUE`, returns raw data in format specified by
#' `wt` param
#' @param ... curl options passed on to [crul::HttpClient]
#' @references
#' <https://lucene.apache.org/solr/guide/7_0/updating-parts-of-documents.html>
#' @examples \dontrun{
#' # start Solr in Cloud mode: bin/solr start -e cloud -noprompt
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' # create a collection
#' if (!conn$collection_exists("books")) {
#'   conn$collection_delete("books")
#'   conn$collection_create("books")
#' }
#'
#' # Add documents
#' file <- system.file("examples", "books.xml", package = "solrium")
#' cat(readLines(file), sep = "\n")
#' conn$update_xml(file, "books")
#'
#' # get a document
#' conn$get(ids = '978-0641723445', "books", wt = "xml")
#'
#' # atomic update
#' body <- '
#' <add>
#'  <doc>
#'    <field name="id">978-0641723445</field>
#'    <field name="genre_s" update="set">mystery</field>
#'    <field name="pages_i" update="inc">1</field>
#'  </doc>
#' </add>'
#' conn$update_atomic_xml(body, name="books")
#'
#' # get the document again
#' conn$get(ids = '978-0641723445', "books", wt = "xml")
#'
#' # another atomic update
#' body <- '
#' <add>
#'  <doc>
#'    <field name="id">978-0641723445</field>
#'    <field name="price" update="remove">12.5</field>
#'  </doc>
#' </add>'
#' conn$update_atomic_xml(body, "books")
#'
#' # get the document again
#' conn$get(ids = '978-0641723445', "books", wt = "xml")
#' }
update_atomic_xml <- function(conn, body, name, wt = 'json', raw = FALSE, ...) {
	check_sr(conn)
  conn$update_atomic_xml(body, name, wt, raw, ...)
}
