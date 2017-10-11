#' Get core status
#'
#' @export
#'
#' @inheritParams core_create
#' @param indexInfo (logical)
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg:
#' #   bin/solr start -e schemaless
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' # Status of all cores
#' conn$core_status()
#'
#' # Status of particular cores
#' conn$core_status("gettingstarted")
#'
#' # Get index info or not
#' ## Default: TRUE
#' conn$core_status("gettingstarted", indexInfo = TRUE)
#' conn$core_status("gettingstarted", indexInfo = FALSE)
#' }
core_status <- function(conn, name = NULL, indexInfo = TRUE, raw = FALSE,
                        callopts=list()) {
  conn$core_status(name, indexInfo, raw, callopts)
}
