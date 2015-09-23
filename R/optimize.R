#' Optimize
#'
#' @export
#' @param name (character) A collection or core name. Required.
#' @param max_segments optimizes down to at most this number of segments. Default: 1
#' @param wait_searcher block until a new searcher is opened and registered as the
#' main query searcher, making the changes visible. Default: \code{TRUE}
#' @param soft_commit  perform a soft commit - this will refresh the 'view' of the
#' index in a more performant manner, but without "on-disk" guarantees.
#' Default: \code{FALSE}
#' @param wt (character) One of json (default) or xml. If json, uses
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to
#' parse
#' @param raw (logical) If \code{TRUE}, returns raw data in format specified by
#' \code{wt} param
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#'
#' optimize("gettingstarted")
#' optimize("gettingstarted", max_segments = 2)
#' optimize("gettingstarted", wait_searcher = FALSE)
#' 
#' # get xml back
#' optimize("gettingstarted", wt = "xml")
#' ## raw xml
#' optimize("gettingstarted", wt = "xml", raw = TRUE)
#' }
optimize <- function(name, max_segments = 1, wait_searcher = TRUE, soft_commit = FALSE,
                     wt = 'json', raw = FALSE, ...) {

  conn <- solr_settings()
  check_conn(conn)
  obj_proc(file.path(conn$url, sprintf('solr/%s/update', name)),
           body = list(optimize =
                         list(maxSegments = max_segments,
                              waitSearcher = asl(wait_searcher),
                              softCommit = asl(soft_commit))),
           args = list(wt = wt),
           raw = raw,
           conn$proxy, ...)
}
