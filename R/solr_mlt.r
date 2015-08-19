#' @title "more like this" search
#' 
#' @description Returns only more like this items
#'
#' @template mlt
#' @return XML, JSON, a list, or data.frame
#' @references See \url{http://wiki.apache.org/solr/MoreLikeThis} for more
#' information.
#' @export
#' @examples \dontrun{
#' # connect
#' solr_connect('http://api.plos.org/search')
#'
#' # more like this search
#' solr_mlt(q='*:*', mlt.count=2, mlt.fl='abstract', fl='score', fq="doc_type:full")
#' solr_mlt(q='*:*', rows=2, mlt.fl='title', mlt.mindf=1, mlt.mintf=1, fl='alm_twitterCount')
#' solr_mlt(q='title:"ecology" AND body:"cell"', mlt.fl='title', mlt.mindf=1, mlt.mintf=1,
#'    fl='counter_total_all', rows=5)
#' solr_mlt(q='ecology', mlt.fl='abstract', fl='title', rows=5)
#' solr_mlt(q='ecology', mlt.fl='abstract', fl=c('score','eissn'), rows=5)
#' solr_mlt(q='ecology', mlt.fl='abstract', fl=c('score','eissn'), rows=5)
#'
#' # get raw data, and parse later if needed
#' out <- solr_mlt(q='ecology', mlt.fl='abstract', fl='title', rows=2, raw=TRUE)
#' library('jsonlite')
#' jsonlite::fromJSON(out)
#' solr_parse(out, "df")
#' }

solr_mlt <- function(name = NULL, q='*:*', fq = NULL, mlt.count=NULL, mlt.fl=NULL, mlt.mintf=NULL,
  mlt.mindf=NULL, mlt.minwl=NULL, mlt.maxwl=NULL, mlt.maxqt=NULL, mlt.maxntp=NULL,
  mlt.boost=NULL, mlt.qf=NULL, fl=NULL, wt='json', start=0, rows=NULL, key = NULL,
  callopts=list(), raw=FALSE, parsetype='df', concat=',') {

  conn <- solr_settings()
  check_conn(conn)
  fl_str <- paste0(fl, collapse = ",")
  if (any(grepl('id', fl))) {
    fl2 <- fl_str
  } else {
    fl2 <- sprintf('id,%s',fl_str)
  }
  args <- sc(list(q = q, fq = fq, mlt = 'true', fl = fl2, mlt.count = mlt.count, mlt.fl = mlt.fl,
    mlt.mintf = mlt.mintf, mlt.mindf = mlt.mindf, mlt.minwl = mlt.minwl,
    mlt.maxwl = mlt.maxwl, mlt.maxqt = mlt.maxqt, mlt.maxntp = mlt.maxntp,
    mlt.boost = mlt.boost, mlt.qf = mlt.qf, start = start, rows = rows, wt = wt))

  out <- structure(solr_GET(handle_url(conn, name), args, callopts, conn$proxy), 
                   class = "sr_mlt", wt = wt)
  if (raw) { return( out ) } else { solr_parse(out, parsetype, concat) }
}
