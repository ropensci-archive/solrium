#' Check if a core exists
#'
#' @export
#'
#' @inheritParams core_create
#' @details Simply calls [core_status()] internally
#' @return A single boolean, `TRUE` or `FALSE`
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg:
#' #   bin/solr start -e schemaless
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or create as below
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' # exists
#' conn$core_exists("gettingstarted")
#'
#' # doesn't exist
#' conn$core_exists("hhhhhh")
#' }
core_exists <- function(conn, name, callopts=list()) {
  tmp <- suppressMessages(core_status(conn, name = name, callopts = callopts))
  length(tmp$status[[1]]) > 0
}
