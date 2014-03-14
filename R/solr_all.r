#' Solr search.
#' 
#' @import httr XML
#' @importFrom plyr compact
#' @template search
#' @return XML, JSON, a list, or data.frame
#' @seealso \code{\link{solr_highlight}}, \code{\link{solr_facet}}
#' @references See \url{http://wiki.apache.org/solr/#Search_and_Indexing} for 
#' more information.
#' @export
#' @examples \dontrun{
#' url <- 'http://api.plos.org/search'
#' solr_all(q='*:*', rows=2, fl='id', base=url)
#' }

solr_all <- function(q='*:*', sort=NULL, start=0, rows=NULL, pageDoc=NULL, 
  pageScore=NULL, fq=NULL, fl=NULL, defType=NULL, timeAllowed=NULL, qt=NULL, 
  wt='json', NOW=NULL, TZ=NULL, echoHandler=NULL, echoParams=NULL, key = NULL, 
  base = NULL, callopts=list(), raw=FALSE, parsetype='df', concat=',', ..., verbose=TRUE)
{
  if(is.null(base)){
    stop("You must provide a url, e.g., http://api.plos.org/search or http://localhost:8983/solr/select")
  }
  
  args <- compact(list(q=q, sort=sort, start=start, rows=rows, pageDoc=pageDoc,
                       pageScore=pageScore, fq=fq, fl=fl, defType=defType, 
                       timeAllowed=timeAllowed, qt=qt, wt=wt, NOW=NOW, TZ=TZ,
                       echoHandler=echoHandler, echoParams=echoParams))
  
  # additional parameters
  args <- c(args, list(...))
  
  tt <- GET(base, query = args, callopts)
  if(verbose) message(URLdecode(tt$url))
  stop_for_status(tt)
  out <- content(tt, as="text")
  class(out) <- "sr_search"
  attr(out, "wt") <- wt
  if(raw){ return( out ) } else { solr_parse(out, parsetype, concat) }
}