#' Request status of asynchronous CoreAdmin API call
#'
#' @export
#' @param requestid The name of one of the cores to be removed. Required
#' @inheritParams core_create
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg:
#' #   bin/solr start -e schemaless
#'
#' # FIXME: not tested yet...
#' # (conn <- SolrClient$new())
#' # conn$core_requeststatus(requestid = 1)
#' }
core_requeststatus <- function(conn, requestid, raw = FALSE,
  callopts = list()) {

  conn$core_requeststatus(requestid, raw, callopts)
}
