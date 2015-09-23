#' Commit
#' 
#' @export
#' @param name (character) A collection or core name. Required. 
#' @param expunge_deletes merge segments with deletes away. Default: \code{FALSE}
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
#' commit("gettingstarted")
#' commit("gettingstarted", wait_searcher = FALSE)
#' 
#' # get xml back
#' commit("gettingstarted", wt = "xml")
#' ## raw xml
#' commit("gettingstarted", wt = "xml", raw = TRUE)
#' }
commit <- function(name, expunge_deletes = FALSE, wait_searcher = TRUE, soft_commit = FALSE, 
                   wt = 'json', raw = FALSE, ...) {
  
  conn <- solr_settings()
  check_conn(conn)
  obj_proc(file.path(conn$url, sprintf('solr/%s/update', name)), 
           body = list(commit = 
                         list(expungeDeletes = asl(expunge_deletes), 
                              waitSearcher = asl(wait_searcher), 
                              softCommit = asl(soft_commit))), 
           args = list(wt = wt), 
           raw = raw, 
           conn$proxy, ...)
}
