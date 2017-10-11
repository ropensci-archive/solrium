#' @title Real time get
#'
#' @description Get documents by id
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param ids Document IDs, one or more in a vector or list
#' @param name (character) A collection or core name. Required.
#' @param fl Fields to return, can be a character vector like
#' `c('id', 'title')`, or a single character vector with one or more
#' comma separated names, like `'id,title'`
#' @param wt (character) One of json (default) or xml. Data type returned.
#' If json, uses [jsonlite::fromJSON()] to parse. If xml, uses
#' [xml2::read_xml()] to parse.
#' @param raw (logical) If `TRUE`, returns raw data in format specified by
#' `wt` param
#' @param ... curl options passed on to [crul::HttpClient]
#' @details We use json internally as data interchange format for this function.
#' @examples \dontrun{
#' (cli <- SolrClient$new())
#'
#' # add some documents first
#' ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
#' add(cli, ss, name = "gettingstarted")
#'
#' # Now, get documents by id
#' solr_get(cli, ids = 1, "gettingstarted")
#' solr_get(cli, ids = 2, "gettingstarted")
#' solr_get(cli, ids = c(1, 2), "gettingstarted")
#' solr_get(cli, ids = "1,2", "gettingstarted")
#'
#' # Get raw JSON
#' solr_get(cli, ids = 1, "gettingstarted", raw = TRUE, wt = "json")
#' solr_get(cli, ids = 1, "gettingstarted", raw = TRUE, wt = "xml")
#' }
solr_get <- function(conn, ids, name, fl = NULL, wt = 'json', raw = FALSE, ...) {
	check_sr(conn)
  conn$get(ids = ids, name = name, fl = fl, wt = wt, raw = raw, ...)
}
