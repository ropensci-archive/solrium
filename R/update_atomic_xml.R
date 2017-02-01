#' Atomic updates with XML data
#'
#' @export
#' @param body (character) XML as a character string
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
#' file <- system.file("examples", "books.xml", package = "solrium")
#' cat(readLines(file), sep = "\n")
#' update_json(file, "books")
#' 
#' # get a document
#' solr_get(ids = 343334534545, "books", wt = "xml")
#'
#' # atomic update
#' body <- '
#' <add>
#'  <doc>
#'    <field name="id">343334534545</field>
#'    <field name="genre_s" update="set">mystery</field>
#'    <field name="pages_i" update="inc">1</field>
#'    <field name="year" update="add">2009</field>
#'  </doc>
#' </add>'
#' update_atomic_xml(body, name="books")
#' 
#' # get the document again
#' solr_get(ids = 343334534545, "books", wt = "xml")
#' 
#' # another atomic update
#' body <- '
#' <add>
#'  <doc>
#'    <field name="id">343334534545</field>
#'    <field name="year" update="remove">2009</field>
#'  </doc>
#' </add>'
#' update_atomic_xml(body, "books")
#' 
#' # get the document again
#' solr_get(ids = 343334534545, "books", wt = "xml")
#' }
update_atomic_xml <- function(body, name, wt = 'json', raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  stop_if_absent(name)
  args <- list(wt = wt)
  doatomiccreate(file.path(conn$url, sprintf('solr/%s/update', name)), 
                 body, args, "xml", raw, ...)
}
