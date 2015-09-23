#' Request status of asynchronous CoreAdmin API call
#'
#' @export
#'
#' @param requestid The name of one of the cores to be removed. Required
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg: bin/solr start -e schemaless
#'
#' # FIXME: not tested yet...
#' # solr_connect()
#' # core_requeststatus(requestid = 1)
#' }
core_requeststatus <- function(requestid, raw = FALSE, callopts = list()) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'REQUESTSTATUS', requestid = requestid, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/cores'), args, callopts, conn$proxy)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
