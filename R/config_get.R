#' Get Solr configuration details
#'
#' @export
#'
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) The name of the core. If not given, all cores.
#' @param what (character) What you want to look at. One of solrconfig or
#' schema. Default: solrconfig
#' @param wt (character) One of json (default) or xml. Data type returned.
#' If json, uses [jsonlite::fromJSON()] to parse. If xml, uses
#' [xml2::read_xml()] to parse.
#' @param raw (logical) If `TRUE`, returns raw data in format specified by
#' `wt`
#' @param ... curl options passed on to [crul::HttpClient]
#' @return A list, `xml_document`, or character
#' @details Note that if `raw=TRUE`, `what` is ignored. That is,
#' you get all the data when `raw=TRUE`.
#' @examples \dontrun{
#' # start Solr with Cloud mode via the schemaless eg: bin/solr -e cloud
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' # all config settings
#' conn$config_get("gettingstarted")
#'
#' # just znodeVersion
#' conn$config_get("gettingstarted", "znodeVersion")
#'
#' # just znodeVersion
#' conn$config_get("gettingstarted", "luceneMatchVersion")
#'
#' # just updateHandler
#' conn$config_get("gettingstarted", "updateHandler")
#'
#' # just updateHandler
#' conn$config_get("gettingstarted", "requestHandler")
#'
#' ## Get XML
#' conn$config_get("gettingstarted", wt = "xml")
#' conn$config_get("gettingstarted", "updateHandler", wt = "xml")
#' conn$config_get("gettingstarted", "requestHandler", wt = "xml")
#'
#' ## Raw data - what param ignored when raw=TRUE
#' conn$config_get("gettingstarted", raw = TRUE)
#' }
config_get <- function(conn, name, what = NULL, wt = "json", raw = FALSE, ...) {
  conn$config_get(name, what, wt, raw, ...)
}

config_parse <- function(x, what = NULL, wt, raw) {
  if (raw) {
    return(x)
  } else {
    switch(
      wt,
      json = {
        tt <- jsonlite::fromJSON(x)
        if (is.null(what)) {
          tt
        } else {
          tt$config[what]
        }
      },
      xml = {
        tt <- xml2::read_xml(x)
        if (is.null(what)) {
          tt
        } else {
          xml2::xml_find_all(tt, sprintf('//lst[@name="%s"]', what))
        }
      }
    )
  }
}
