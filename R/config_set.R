#' Set Solr configuration details
#'
#' @export
#'
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) The name of the core. If not given, all cores.
#' @param set (list) List of key:value pairs of what to set. Default: NULL
#' (nothing passed)
#' @param unset (list) One or more character strings of keys to unset. Default: NULL
#' (nothing passed)
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
#' # set a property
#' conn$config_set("gettingstarted", 
#'   set = list(query.filterCache.autowarmCount = 1000))
#'
#' # unset a property
#' conn$config_set("gettingstarted", unset = "query.filterCache.size", 
#'   verbose = TRUE)
#'
#' # both set a property and unset a property
#' conn$config_set("gettingstarted", unset = "enableLazyFieldLoading")
#'
#' # many properties
#' conn$config_set("gettingstarted", set = list(
#'    query.filterCache.autowarmCount = 1000,
#'    query.commitWithin.softCommit = 'false'
#'  )
#' )
#' }
config_set <- function(conn, name, set = NULL, unset = NULL, ...) {
  conn$config_set(name, set, unset, ...)
}
