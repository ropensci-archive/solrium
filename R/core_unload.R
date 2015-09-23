#' Unload (delete) a core
#'
#' @export
#'
#' @param name The name of one of the cores to be removed. Required
#' @param deleteIndex	(logical)	If \code{TRUE}, will remove the index when unloading
#' the core. Default: \code{FALSE}
#' @param deleteDataDir	(logical)	If \code{TRUE}, removes the data directory and all
#' sub-directories. Default: \code{FALSE}
#' @param deleteInstanceDir	(logical)	If \code{TRUE}, removes everything related to
#' the core, including the index directory, configuration files and other related
#' files. Default: \code{FALSE}
#' @param async	(character) Request ID to track this action which will be processed
#' asynchronously
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg: bin/solr start -e schemaless
#'
#' # connect
#' solr_connect()
#'
#' # Create a core
#' core_create(name = "thingsstuff")
#'
#' # Unload a core
#' core_unload(name = "fart")
#' }
core_unload <- function(name, deleteIndex = FALSE, deleteDataDir = FALSE,
                        deleteInstanceDir = FALSE, async = NULL,
                        raw = FALSE, callopts = list()) {

  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'UNLOAD', core = name, deleteIndex = asl(deleteIndex),
                  deleteDataDir = asl(deleteDataDir), deleteInstanceDir = asl(deleteInstanceDir),
                  async = async, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/cores'), args, callopts, conn$proxy)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
