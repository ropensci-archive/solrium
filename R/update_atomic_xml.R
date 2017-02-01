#' Atomic updates with XML data
#'
#' @export
#' @family update
#' @template update
#' @template commitcontrol
#' @param files Path to a single file to load into Solr
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
