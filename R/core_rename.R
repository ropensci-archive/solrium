#' Rename a core
#'
#' @export
#'
#' @param name (character) The name of the core to be renamed. Required
#' @param other (character) The new name of the core. Required.
#' @param async	(character) Request ID to track this action which will be processed
#' asynchronously
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
#' # Status of particular cores
#' core_create("testcore") # or create in the CLI: bin/solr create -c testcore
#' core_rename("testcore", "newtestcore")
#' core_status("testcore") # core missing
#' core_status("newtestcore", FALSE) # not missing
#' }
core_rename <- function(name, other, async = NULL, raw = FALSE, callopts=list()) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'RENAME', core = name, other = other, async = async, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/cores'), args, callopts, conn$proxy)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}

