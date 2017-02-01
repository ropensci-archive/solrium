#' Atomic updates with JSON data
#'
#' @export
#' @param body (character) JSON as a character string
#' @param name (character) Name of the core or collection
#' @param wt (character) One of json (default) or xml. If json, uses 
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses 
#' \code{\link[xml2]{read_xml}} to parse
#' @param raw (logical) If \code{TRUE}, returns raw data in format specified by 
#' \code{wt} param
#' @param ... curl options passed on to \code{\link[httr]{POST}}
#' @examples \dontrun{
#' # start Solr in Cloud mode: bin/solr start -e cloud -noprompt
#' 
#' # connect
#' solr_connect()
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
update_atomic_json <- function(body, name, wt = 'json', raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  stop_if_absent(name)
  args <- list(wt = wt)
  doatomiccreate(file.path(conn$url, sprintf('solr/%s/update', name)), 
           body, args, "json", raw, ...)
}
