#' Commit
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) A collection or core name. Required.
#' @param expunge_deletes merge segments with deletes away. Default: `FALSE`
#' @param wait_searcher block until a new searcher is opened and registered as
#' the main query searcher, making the changes visible. Default: `TRUE`
#' @param soft_commit  perform a soft commit - this will refresh the 'view' of
#' the index in a more performant manner, but without "on-disk" guarantees.
#' Default: `FALSE`
#' @param wt (character) One of json (default) or xml. If json, uses
#' [jsonlite::fromJSON()] to parse. If xml, uses [xml2::read_xml()] to parse
#' @param raw (logical) If `TRUE`, returns raw data in format specified by
#' `wt` param
#' @param ... curl options passed on to [crul::HttpClient]
#' @references <>
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' conn$commit("gettingstarted")
#' conn$commit("gettingstarted", wait_searcher = FALSE)
#'
#' # get xml back
#' conn$commit("gettingstarted", wt = "xml")
#' ## raw xml
#' conn$commit("gettingstarted", wt = "xml", raw = TRUE)
#' }
commit <- function(conn, name, expunge_deletes = FALSE, wait_searcher = TRUE,
                   soft_commit = FALSE, wt = 'json', raw = FALSE, ...) {

  conn$commit(name, expunge_deletes, wait_searcher, soft_commit, wt, raw, ...)
}
