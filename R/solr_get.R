#' @title Real time get
#' 
#' @description Get documents by id
#' 
#' @export
#' @param ids Document IDs, one or more in a vector or list
#' @param name (character) A collection or core name. Required.
#' @param raw (logical) If \code{TRUE}, returns raw data in format specified by 
#' \code{wt} param
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @details We use json internally as data interchange format for this function.
#' @examples \dontrun{
#' solr_connect()
#' 
#' # add some documents first
#' ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
#' add(ss, name = "gettingstarted")
#' 
#' # Now, get documents by id
#' solr_get(ids = 1, "gettingstarted")
#' solr_get(ids = 2, "gettingstarted")
#' solr_get(ids = c(1, 2), "gettingstarted")
#' solr_get(ids = "1,2", "gettingstarted")
#' }
solr_get <- function(ids, name, wt = 'json', raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(ids = paste0(ids, collapse = ","), wt = 'json'))
  res <- solr_GET(file.path(conn$url, sprintf('solr/%s/get', name)), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
