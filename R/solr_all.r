#' @title All purpose search
#' 
#' @description Includes documents, facets, groups, mlt, stats, and highlights.
#'
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
 #' # connect
#' solr_connect('http://api.plos.org/search')
#'
#' solr_all(q='*:*', rows=2, fl='id')
#'
#' # facets
#' solr_all(q='*:*', rows=2, fl='id', facet="true", facet.field="journal")
#'
#' # mlt
#' solr_all(q='ecology', rows=2, fl='id', mlt='true', mlt.count=2, mlt.fl='abstract')
#'
#' # facets and mlt
#' solr_all(q='ecology', rows=2, fl='id', facet="true", facet.field="journal",
#' mlt='true', mlt.count=2, mlt.fl='abstract')
#'
#' # stats
#' solr_all(q='ecology', rows=2, fl='id', stats='true', stats.field='counter_total_all')
#'
#' # facets, mlt, and stats
#' solr_all(q='ecology', rows=2, fl='id', facet="true", facet.field="journal",
#' mlt='true', mlt.count=2, mlt.fl='abstract', stats='true', stats.field='counter_total_all')
#'
#' # group
#' solr_all(q='ecology', rows=2, fl='id', group='true',
#'    group.field='journal', group.limit=3)
#'
#' # facets, mlt, stats, and groups
#' solr_all(q='ecology', rows=2, fl='id', facet="true", facet.field="journal",
#'    mlt='true', mlt.count=2, mlt.fl='abstract', stats='true', stats.field='counter_total_all',
#'    group='true', group.field='journal', group.limit=3)
#'
#' # using wt = xml
#' solr_all(q='*:*', rows=50, fl=c('id','score'), fq='doc_type:full', wt="xml", raw=TRUE)
#' }

solr_all <- function(name = NULL, q='*:*', sort=NULL, start=0, rows=NULL, pageDoc=NULL,
  pageScore=NULL, fq=NULL, fl=NULL, defType=NULL, timeAllowed=NULL, qt=NULL,
  wt='json', NOW=NULL, TZ=NULL, echoHandler=NULL, echoParams=NULL, key = NULL,
  callopts=list(), raw=FALSE, parsetype='list', concat=',', ...) {

  check_defunct(...)
  conn <- solr_settings()
  check_conn(conn)
  if (!is.null(fl)) fl <- paste0(fl, collapse = ",")
  args <- sc(list(q = q, sort = sort, start = start, rows = rows, pageDoc = pageDoc,
                       pageScore = pageScore, fl = fl, fq = fq, defType = defType,
                       timeAllowed = timeAllowed, qt = qt, wt = wt, NOW = NOW, TZ = TZ,
                       echoHandler = echoHandler, echoParams = echoParams))

  # additional parameters
  args <- c(args, list(...))

  out <- structure(solr_GET(handle_url(conn, name), args, callopts, conn$proxy), 
                   class = "sr_search", wt = wt)
  if (raw) {
    return( out )
  } else {
    solr_parse(out, parsetype, concat)
  }
}
