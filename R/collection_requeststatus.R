#' @title Get request status
#'
#' @description Request the status of an already submitted Asynchronous Collection
#' API call. This call is also used to clear up the stored statuses.
#'
#' @export
#' @param requestid (character) Required. The user defined request-id for the request.
#' This can be used to track the status of the submitted asynchronous task. \code{-1}
#' is a special request id which is used to cleanup the stored states for all of the
#' already completed/failed tasks.
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#'
#' # invalid requestid
#' collection_requeststatus(requestid = "xxx")
#'
#' # valid requestid
#' collection_requeststatus(requestid = "xxx")
#' res$responseHeader
#' res$xxx
#' }
collection_requeststatus <- function(requestid, raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'REQUESTSTATUS', requestid = requestid, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
