#' Get Solr configuration overlay
#' 
#' @export
#' 
#' @param name (character) The name of the core. If not given, all cores.
#' @param omitHeader (logical) If \code{TRUE}, omit header. Default: \code{FALSE}
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @return A list with response from server
#' @examples \dontrun{
#' # start Solr with Cloud mode via the schemaless eg: bin/solr -e cloud
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#' 
#' # connect
#' solr_connect()
#' 
#' # get config overlay
#' config_overlay("gettingstarted")
#' 
#' # without header
#' config_overlay("gettingstarted", omitHeader = TRUE)
#' }
config_overlay <- function(name, omitHeader = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  url <- file.path(conn$url, sprintf('solr/%s/config/overlay', name))
  args <- sc(list(wt = "json", omitHeader = asl(omitHeader)))
  res <- solr_GET(url, args, conn$proxy, ...)
  jsonlite::fromJSON(res)
}
