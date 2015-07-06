#' Optimize
#' 
#' @export
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
#' @param base (character) URL endpoint. This is different from the other functions in 
#' that we aren't hitting a search endpoint. Pass in here 
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' optimize()
#' optimize(max_segments = 2)
#' optimize(wait_searcher = FALSE)
#' }
optimize <- function(max_segments = 1, wait_searcher = TRUE, soft_commit = FALSE, 
                     wt = 'json', raw = FALSE, base = 'http://localhost:8983', ...) {
  
  if (is.null(base)) stop("You must provide a url")
  args <- sc(list(maxSegments = max_segments, waitSearcher = asl(wait_searcher), 
                  softCommit = asl(soft_commit), wt = 'json'))
  obj_proc(file.path(base, 'solr/update'), list(optimize = c()), args, raw, ...)
}
