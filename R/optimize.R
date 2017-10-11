#' Optimize
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) A collection or core name. Required.
#' @param max_segments optimizes down to at most this number of segments.
#' Default: 1
#' @param wait_searcher block until a new searcher is opened and registered
#' as the main query searcher, making the changes visible. Default: `TRUE`
#' @param soft_commit  perform a soft commit - this will refresh the 'view'
#' of the index in a more performant manner, but without "on-disk" guarantees.
#' Default: `FALSE`
#' @param wt (character) One of json (default) or xml. If json, uses
#' [jsonlite::fromJSON()] to parse. If xml, uses [xml2::read_xml()] to
#' parse
#' @param raw (logical) If `TRUE`, returns raw data in format specified by
#' \code{wt} param
#' @param ... curl options passed on to [crul::HttpClient]
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' solr_optimize(conn, "gettingstarted")
#' solr_optimize(conn, "gettingstarted", max_segments = 2)
#' solr_optimize(conn, "gettingstarted", wait_searcher = FALSE)
#'
#' # get xml back
#' solr_optimize(conn, "gettingstarted", wt = "xml")
#' ## raw xml
#' solr_optimize(conn, "gettingstarted", wt = "xml", raw = TRUE)
#' }
solr_optimize <- function(conn, name, max_segments = 1, wait_searcher = TRUE,
                     soft_commit = FALSE, wt = 'json', raw = FALSE, ...) {
  conn$optimize(name, max_segments, wait_searcher, soft_commit, wt, raw, ...)
}
