#' @title Real time get
#' 
#' @description Get documents by id
#' 
#' @export
#' @param ids Document IDs, one or more in a vector or list
#' @param name (character) A collection or core name. Required.
#' @param fl Fields to return, can be a character vector like \code{c('id', 'title')}, 
#' or a single character vector with one or more comma separated names, like 
#' \code{'id,title'}
#' @param wt (character) One of json (default) or xml. Data type returned.
#' If json, uses \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses
#' \code{\link[XML]{xmlParse}} to parse.
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
#' 
#' # Get raw JSON
#' solr_get(ids = 1, "gettingstarted", raw = TRUE, wt = "json")
#' solr_get(ids = 1, "gettingstarted", raw = TRUE, wt = "xml")
#' }
solr_get <- function(ids, name, fl = NULL, wt = 'json', raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  if (!is.null(fl)) fl <- paste0(fl, collapse = ",")
  args <- sc(list(ids = paste0(ids, collapse = ","), fl = fl, wt = wt))
  res <- solr_GET(file.path(conn$url, sprintf('solr/%s/get', name)), args, conn$proxy, ...)
  config_parse(res, wt = wt, raw = raw)
}
