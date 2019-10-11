#' Set Solr configuration params
#'
#' @export
#'
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) The name of the core. If not given, all cores.
#' @param param (character) Name of a parameter
#' @param set (list) List of key:value pairs of what to set. Create or
#' overwrite a parameter set map. Default: NULL (nothing passed)
#' @param unset (list) One or more character strings of keys to unset.
#' Default: `NULL` (nothing passed)
#' @param update (list) List of key:value pairs of what to update. Updates
#' a parameter set map. This essentially overwrites the old parameter set,
#' so all parameters must be sent in each update request.
#' @param ... curl options passed on to [crul::HttpClient]
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
#' (conn <- SolrClient$new())
#'
#' # set a parameter set
#' myFacets <- list(myFacets = list(facet = TRUE, facet.limit = 5))
#' config_params(conn, "gettingstarted", set = myFacets)
#'
#' # check a parameter
#' config_params(conn, "gettingstarted", param = "myFacets")
#' }
config_params <- function(conn, name, param = NULL, set = NULL,
                          unset = NULL, update = NULL, ...) {
  conn$config_params(name, param, set, unset, update, ...)
}

name_by <- function(x, y) {
  if (is.null(x)) {
    NULL
  } else {
    stats::setNames(list(y = x), y)
  }
}
