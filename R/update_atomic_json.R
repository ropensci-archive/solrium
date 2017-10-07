#' Atomic updates with JSON data
#'
#' @export
#' @param body (character) JSON as a character string
#' @inheritParams update_atomic_xml
#' @examples \dontrun{
#' # start Solr in Cloud mode: bin/solr start -e cloud -noprompt
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' # create a collection
#' collection_create("books")
#'
#' # Add documents
#' file <- system.file("examples", "books2.json", package = "solrium")
#' cat(readLines(file), sep = "\n")
#' update_json(file, "books")
#'
#' # get a document
#' solr_get(ids = 343334534545, "books")
#'
#' # atomic update
#' body <- '[{
#'  "id": "343334534545",
#'  "genre_s": {"set": "mystery" },
#'  "pages_i": {"inc": 1 },
#'  "year": {"add": "2009" }
#' }]'
#' update_atomic_json(body, "books")
#'
#' # get the document again
#' solr_get(ids = 343334534545, "books")
#'
#' # another atomic update
#' body <- '[{
#'  "id": "343334534545",
#'  "year": {"remove": "2009" }
#' }]'
#' update_atomic_json(body, "books")
#'
#' # get the document again
#' solr_get(ids = 343334534545, "books")
#' }
update_atomic_json <- function(conn, body, name, wt = 'json', raw = FALSE, ...) {
  conn$update_atomic_json(body, name, wt, raw, ...)
}
