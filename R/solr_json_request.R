#' @title Solr json request
#'
#' @description search using the JSON request API
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param name Name of a collection or core. Or leave as `NULL` if not needed.
#' @param body (list) a named list, or a valid JSON character string
#' @param callopts Call options passed on to [crul::HttpClient]
#' @param progress a function with logic for printing a progress
#' bar for an HTTP request, ultimately passed down to \pkg{curl}.
#' only supports `httr::progress` for now. See the README for an example.
#'
#' @return JSON character string
#' @references See https://lucene.apache.org/solr/guide/7_6/json-request-api.html
#' for more information.
#' @note SOLR v7.1 was first version to support this. See
#' <https://issues.apache.org/jira/browse/SOLR-11244>
#' @note POST request only, no GET request available
#' @examples \dontrun{
#' # Connect to a local Solr instance
#' (conn <- SolrClient$new())
#' 
#' ## body as JSON 
#' a <- conn$json_request("gettingstarted", body = '{"query":"*:*"}')
#' jsonlite::fromJSON(a)
#' ## body as named list
#' b <- conn$json_request("gettingstarted", body = list(query = "*:*"))
#' jsonlite::fromJSON(b)
#' 
#' ## body as JSON 
#' a <- solr_json_request(conn, "gettingstarted", body = '{"query":"*:*"}')
#' jsonlite::fromJSON(a)
#' ## body as named list
#' b <- solr_json_request(conn, "gettingstarted", body = list(query = "*:*"))
#' jsonlite::fromJSON(b)
#' }
solr_json_request <- function(conn, name = NULL, body = NULL, callopts = list(),
  progress = NULL) {

  conn$json_request(name = name, body = body, callopts = callopts, 
    progress = progress)
}
