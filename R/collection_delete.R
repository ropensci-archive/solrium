#' Add a collection
#' 
#' @export
#' @param conn Connection object. Required. See \code{\link{solr_connect}}.
#' @param name The name of the collection to be created. Required
#' @param verbose If TRUE (default) the url call used printed to console.
#' @param raw (logical) If \code{TRUE}, returns raw data in format specified by 
#' \code{wt} param
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' conn <- solr_connect()
#' collection_create(conn, name = "helloWorld")
#' collection_delete(conn, name = "helloWorld")
#' }
collection_delete <- function(conn, name, verbose=TRUE, raw = FALSE, ...) {
  check_conn(conn)
  args <- sc(list(action = 'DELETE', name = name, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, verbose = verbose, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
