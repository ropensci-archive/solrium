#' Check if a collection exists
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) The name of the core. If not given, all cores.
#' @param ... curl options passed on to [crul::HttpClient]
#' @details Simply calls [collection_list()] internally
#' @return A single boolean, `TRUE` or `FALSE`
#' @examples \dontrun{
#' # start Solr with Cloud mode via the schemaless eg: bin/solr -e cloud
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#' (conn <- SolrClient$new())
#'
#' # exists
#' conn$collection_exists("gettingstarted")
#'
#' # doesn't exist
#' conn$collection_exists("hhhhhh")
#' }
collection_exists <- function(conn, name, ...) {
  name %in% suppressMessages(conn$collection_list(...))$collections
}
