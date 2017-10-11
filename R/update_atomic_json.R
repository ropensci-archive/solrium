#' Atomic updates with JSON data
#'
#' Atomic updates to parts of Solr documents
#'
#' @export
#' @param body (character) JSON as a character string
#' @inheritParams update_atomic_xml
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
#' file <- system.file("examples", "books2.json", package = "solrium")
#' cat(readLines(file), sep = "\n")
#' conn$update_json(file, "books")
#'
#' # get a document
#' conn$get(ids = 343334534545, "books")
#'
#' # atomic update
#' body <- '[{
#'  "id": "343334534545",
#'  "genre_s": {"set": "mystery" },
#'  "pages_i": {"inc": 1 }
#' }]'
#' conn$update_atomic_json(body, "books")
#'
#' # get the document again
#' conn$get(ids = 343334534545, "books")
#'
#' # another atomic update
#' body <- '[{
#'  "id": "343334534545",
#'  "price": {"remove": "12.5" }
#' }]'
#' conn$update_atomic_json(body, "books")
#'
#' # get the document again
#' conn$get(ids = 343334534545, "books")
#' }
update_atomic_json <- function(conn, body, name, wt = 'json',
	  raw = FALSE, ...) {

	check_sr(conn)
  conn$update_atomic_json(body, name, wt, raw, ...)
}
