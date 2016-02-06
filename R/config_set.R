#' Set Solr configuration details
#' 
#' @export
#' 
#' @param name (character) The name of the core. If not given, all cores.
#' @param set (list) List of key:value pairs of what to set. Default: NULL 
#' (nothing passed)
#' @param unset (list) One or more character strings of keys to unset. Default: NULL 
#' (nothing passed)
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
#' # set a property
#' config_set("gettingstarted", set = list(query.filterCache.autowarmCount = 1000))
#' 
#' # unset a property
#' config_set("gettingstarted", unset = "query.filterCache.size", config = verbose())
#' 
#' # both set a property and unset a property
#' config_set("gettingstarted", unset = "enableLazyFieldLoading")
#' 
#' # many properties
#' config_set("gettingstarted", set = list(
#'    query.filterCache.autowarmCount = 1000,
#'    query.commitWithin.softCommit = 'false'
#'  )
#' )
#' }
config_set <- function(name, set = NULL, unset = NULL, ...) {
  conn <- solr_settings()
  check_conn(conn)
  url <- file.path(conn$url, sprintf('solr/%s/config', name))
  body <- sc(list(`set-property` = unbox_if(set), 
                  `unset-property` = unset))
  res <- solr_POST_body(url, body, list(wt = "json"), conn$proxy, ...)
  jsonlite::fromJSON(res)
}
