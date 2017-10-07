#' Ping a Solr instance
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) Name of a collection or core. Required.
#' @param wt (character) One of json (default) or xml. If json, uses
#' [jsonlite::fromJSON()] to parse. If xml, uses [xml2::read_xml)] to parse
#' @param raw (logical) If `TRUE`, returns raw data in format specified by
#' `wt` param
#' @param ... curl options passed on to [crul::HttpClient]
#'
#' @return if `wt="xml"` an object of class `xml_document`, if
#' `wt="json"` an object of class `list`
#'
#' @details You likely may not be able to run this function against many public
#' Solr services as they hopefully don't expose their admin interface to the
#' public, but works locally.
#'
#' @examples \dontrun{
#' # start Solr, in your CLI, run: `bin/solr start -e cloud -noprompt`
#' # after that, if you haven't run `bin/post -c gettingstarted docs/` yet,
#' # do so
#'
#' # connect: by default we connect to localhost, port 8983
#' (cli <- SolrClient$new())
#'
#' # ping the gettingstarted index
#' cli$ping("gettingstarted")
#' ping(cli, "gettingstarted")
#' ping(cli, "gettingstarted", wt = "xml")
#' ping(cli, "gettingstarted", verbose = FALSE)
#' ping(cli, "gettingstarted", raw = TRUE)
#'
#' ping(cli, "gettingstarted", wt="xml", verbose = TRUE)
#' }
ping <- function(conn, name, wt = 'json', raw = FALSE, ...) {
  conn$ping(name = name, wt = wt, raw = raw, ...)
}
