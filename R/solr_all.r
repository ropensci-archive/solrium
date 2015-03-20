#' All purpose function to do search, faceting, grouping, mlt, etc.
#'
#' @import httr XML
#' @template search
#' @param wt (character) One of json (default) or xml. If json, uses 
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} 
#' to parse. You can't use \code{csv} because the point of this function 
#' @return XML, JSON, a list, or data.frame
#' @seealso \code{\link{solr_highlight}}, \code{\link{solr_facet}}
#' @references See \url{http://wiki.apache.org/solr/#Search_and_Indexing} for
#' more information.
#' @export
#' @examples \dontrun{
#' url <- 'http://api.plos.org/search'
#' solr_all(q='*:*', rows=2, fl='id', base=url)
#' 
#' # facets
#' solr_all(q='*:*', rows=2, fl='id', base=url, facet="true", facet.field="journal")
#' 
#' # mlt
#' solr_all(q='ecology', rows=2, fl='id', base=url, mlt='true', mlt.count=2, mlt.fl='abstract')
#' 
#' # facets and mlt
#' solr_all(q='ecology', rows=2, fl='id', base=url, facet="true", facet.field="journal", 
#' mlt='true', mlt.count=2, mlt.fl='abstract')
#' 
#' # stats
#' solr_all(q='ecology', rows=2, fl='id', base=url, stats='true', stats.field='counter_total_all')
#' 
#' # facets, mlt, and stats
#' solr_all(q='ecology', rows=2, fl='id', base=url, facet="true", facet.field="journal", 
#' mlt='true', mlt.count=2, mlt.fl='abstract', stats='true', stats.field='counter_total_all')
#' 
#' # group
#' solr_all(q='ecology', rows=2, fl='id', base=url, group='true', 
#' group.field='journal', group.limit=3)
#' 
#' # facets, mlt, stats, and groups
#' solr_all(q='ecology', rows=2, fl='id', base=url, facet="true", facet.field="journal", 
#' mlt='true', mlt.count=2, mlt.fl='abstract', stats='true', stats.field='counter_total_all',
#' group='true', group.field='journal', group.limit=3)
#'
#' # using wt = xml
#' solr_all(q='*:*', rows=50, fl=c('id','score'), fq='doc_type:full', base=url, wt="xml", raw=TRUE)
#' }

solr_all <- function(q='*:*', sort=NULL, start=0, rows=NULL, pageDoc=NULL,
  pageScore=NULL, fq=NULL, fl=NULL, defType=NULL, timeAllowed=NULL, qt=NULL,
  wt='json', NOW=NULL, TZ=NULL, echoHandler=NULL, echoParams=NULL, key = NULL,
  base = NULL, callopts=list(), raw=FALSE, parsetype='list', concat=',', ..., verbose=TRUE) {
  
  if (is.null(base)) {
    stop("You must provide a url, e.g., http://api.plos.org/search or http://localhost:8983/solr/select")
  }

  if (!is.null(fl)) fl <- paste0(fl, collapse = ",")
  args <- sc(list(q = q, sort = sort, start = start, rows = rows, pageDoc = pageDoc,
                       pageScore = pageScore, fl = fl, fq = fq, defType = defType,
                       timeAllowed = timeAllowed, qt = qt, wt = wt, NOW = NOW, TZ = TZ,
                       echoHandler = echoHandler, echoParams = echoParams))

  # additional parameters
  args <- c(args, list(...))

  out <- structure(solr_GET(base, args, callopts, verbose), class = "sr_search", wt = wt)
  if (raw) {
    return( out )
  } else {
    solr_parse(out, parsetype, concat)
  }
}
