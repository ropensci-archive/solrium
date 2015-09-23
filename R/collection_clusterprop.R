#' @title Add, edit, delete a cluster-wide property
#'
#' @description Important: whether add, edit, or delete is used is determined by
#' the value passed to the \code{val} parameter. If the property name is
#' new, it will be added. If the property name exists, and the value is different,
#' it will be edited. If the property name exists, and the value is NULL or empty
#' the property is deleted (unset).
#'
#' @export
#' @param name (character) Required. The name of the property. The two supported
#' properties names are urlScheme and autoAddReplicas. Other names are rejected
#' with an error
#' @param val (character) Required. The value of the property. If the value is
#' empty or null, the property is unset.
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#'
#' # add the value https to the property urlScheme
#' collection_clusterprop(name = "urlScheme", val = "https")
#'
#' # status again
#' collection_clusterstatus()$cluster$properties
#'
#' # delete the property urlScheme by setting val to NULL or a 0 length string
#' collection_clusterprop(name = "urlScheme", val = "")
#' }
collection_clusterprop <- function(name, val, raw = FALSE, callopts=list()) {
  conn <- solr_settings()
  check_conn(conn)
  val <- if (is.null(val)) "" else val
  args <- sc(list(action = 'CLUSTERPROP', name = name, val = val, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, callopts, conn$proxy)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
