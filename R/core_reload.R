#' Reload a core
#'
#' @export
#'
#' @inheritParams core_create
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg:
#' #  bin/solr start -e schemaless
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' # Status of particular cores
#' conn$core_reload("gettingstarted")
#' conn$core_status("gettingstarted")
#' }
core_reload <- function(conn, name, raw = FALSE, callopts=list()) {
  conn$core_reload(name, raw, callopts)
}

