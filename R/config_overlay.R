#' Get Solr configuration overlay
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) The name of the core. If not given, all cores.
#' @param omitHeader (logical) If `TRUE`, omit header. Default: `FALSE`
#' @param ... curl options passed on to [crul::HttpClient]
#' @return A list with response from server
#' @examples \dontrun{
#' # start Solr with Cloud mode via the schemaless eg: bin/solr -e cloud
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' # get config overlay
#' conn$config_overlay("gettingstarted")
#'
#' # without header
#' conn$config_overlay("gettingstarted", omitHeader = TRUE)
#' }
config_overlay <- function(conn, name, omitHeader = FALSE, ...) {
  conn$config_overlay(name, omitHeader, ...)
}
