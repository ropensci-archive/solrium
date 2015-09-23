#' Get core status
#'
#' @export
#'
#' @param name (character) The name of the core. If not given, all cores.
#' @param indexInfo (logical)
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg: bin/solr start -e schemaless
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#'
#' # connect
#' solr_connect()
#'
#' # Status of all cores
#' core_status()
#'
#' # Status of particular cores
#' core_status("gettingstarted")
#'
#' # Get index info or not
#' ## Default: TRUE
#' core_status("gettingstarted", indexInfo = TRUE)
#' core_status("gettingstarted", indexInfo = FALSE)
#' }
core_status <- function(name = NULL, indexInfo = TRUE, raw = FALSE, callopts=list()) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'STATUS', core = name, indexInfo = asl(indexInfo), wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/cores'), args, callopts, conn$proxy)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}

