#' @title Add, edit, delete a cluster-wide property
#'
#' @description Important: whether add, edit, or delete is used is determined
#' by the value passed to the \code{val} parameter. If the property name is
#' new, it will be added. If the property name exists, and the value is
#' different, it will be edited. If the property name exists, and the value
#' is `NULL` or empty the property is deleted (unset).
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) Name of the core or collection
#' @param val (character) Required. The value of the property. If the value is
#' empty or null, the property is unset.
#' @param raw (logical) If \code{TRUE}, returns raw data in format specified by
#' \code{wt} param
#' @param callopts curl options passed on to [crul::HttpClient]
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' # add the value https to the property urlScheme
#' collection_clusterprop(conn, name = "urlScheme", val = "https")
#'
#' # status again
#' collection_clusterstatus(conn)$cluster$properties
#'
#' # delete the property urlScheme by setting val to NULL or a 0 length string
#' collection_clusterprop(conn, name = "urlScheme", val = "")
#' }
collection_clusterprop <- function(conn, name, val, raw = FALSE,
                                   callopts=list()) {
  conn$collection_clusterprop(name, val, raw, callopts)
}
