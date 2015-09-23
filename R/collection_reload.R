#' Reload a collection
#'
#' @export
#' @param name The name of the collection to reload. Required
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#' collection_create(name = "helloWorld")
#' collection_reload(name = "helloWorld")
#' }
collection_reload <- function(name, raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'RELOAD', name = name, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
