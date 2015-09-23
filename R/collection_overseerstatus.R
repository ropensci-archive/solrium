#' @title Get overseer status
#'
#' @description Returns the current status of the overseer, performance statistics
#' of various overseer APIs as well as last 10 failures per operation type.
#'
#' @export
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#' collection_overseerstatus()
#' res <- collection_overseerstatus()
#' res$responseHeader
#' res$leader
#' res$overseer_queue_size
#' res$overseer_work_queue_size
#' res$overseer_operations
#' res$collection_operations
#' res$overseer_queue
#' res$overseer_internal_queue
#' res$collection_queue
#' }
collection_overseerstatus <- function(raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'OVERSEERSTATUS', wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
