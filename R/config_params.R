#' Set Solr configuration params
#' 
#' @export
#' 
#' @param name (character) The name of the core. If not given, all cores.
#' @param param (character) Name of a parameter
#' @param set (list) List of key:value pairs of what to set. Create or overwrite 
#' a parameter set map. Default: NULL (nothing passed)
#' @param unset (list) One or more character strings of keys to unset. Default: NULL 
#' (nothing passed)
#' @param update (list) List of key:value pairs of what to update. Updates a parameter 
#' set map. This essentially overwrites the old parameter set, so all parameters must 
#' be sent in each update request.
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @return A list with response from server
#' @details The Request Parameters API allows creating parameter sets that can 
#' override or take the place of parameters defined in solrconfig.xml. It is 
#' really another endpoint of the Config API instead of a separate API, and 
#' has distinct commands. It does not replace or modify any sections of 
#' solrconfig.xml, but instead provides another approach to handling parameters 
#' used in requests. It behaves in the same way as the Config API, by storing 
#' parameters in another file that will be used at runtime. In this case, 
#' the parameters are stored in a file named params.json. This file is kept in 
#' ZooKeeper or in the conf directory of a standalone Solr instance.
#' @examples \dontrun{
#' # start Solr in standard or Cloud mode
#' # connect
#' solr_connect()
#' 
#' # set a parameter set
#' myFacets <- list(myFacets = list(facet = TRUE, facet.limit = 5))
#' config_params("gettingstarted", set = myFacets)
#' 
#' # check a parameter
#' config_params("gettingstarted", param = "myFacets")
#' 
#' # see all params
#' config_params("gettingstarted")
#' }
config_params <- function(name, param = NULL, set = NULL, 
                          unset = NULL, update = NULL, ...) {
  
  conn <- solr_settings()
  check_conn(conn)
  if (all(vapply(list(set, unset, update), is.null, logical(1)))) {
    if (is.null(param)) {
      url <- file.path(conn$url, sprintf('solr/%s/config/params', name))
    } else {
      url <- file.path(conn$url, sprintf('solr/%s/config/params/%s', name, param))
    }
    res <- solr_GET(url, list(wt = "json"), conn$proxy, ...)
  } else {
    url <- file.path(conn$url, sprintf('solr/%s/config/params', name))
    body <- sc(c(name_by(unbox_if(set, TRUE), "set"), 
                 name_by(unbox_if(unset, TRUE), "unset"),
                 name_by(unbox_if(update, TRUE), "update")))
    res <- solr_POST_body(url, body, list(wt = "json"), conn$proxy, ...)
  }
  jsonlite::fromJSON(res)
}

name_by <- function(x, y) {
  if (is.null(x)) {
    NULL
  } else {
    setNames(list(y = x), y)
  }
}
