#' Solr "more like this" search
#' 
#' @import httr XML
#' @importFrom plyr compact
#' @template mlt
#' @return XML, JSON, a list, or data.frame
#' @references See \url{http://wiki.apache.org/solr/MoreLikeThis} for more
#' information.
#' @export
#' @examples \dontrun{
#' url <- 'http://api.plos.org/search'; key = getOption('PlosApiKey')
#' 
#' solr_mlt(q='*:*', mlt.count=2, mlt.fl='abstract', fl='score', url=url, key=key, 
#'    fq="doc_type:full")
#' solr_mlt(q='*:*', rows=2, mlt.fl='title', mlt.mindf=1, mlt.mintf=1, fl='alm_twitterCount', 
#'    url=url, key=key)
#' solr_mlt(q='title:"ecology" AND body:"cell"', mlt.fl='title', mlt.mindf=1, mlt.mintf=1, 
#'    fl='counter_total_all', rows=5, url=url, key=key)
#' solr_mlt(q='ecology', mlt.fl='abstract', fl='title', rows=5, url=url, key=key)
#' 
#' # get raw data, and parse later if needed
#' out=solr_mlt(q='ecology', mlt.fl='abstract', fl='title', rows=2, url=url, key=key, 
#'    raw=TRUE, wt="xml")
#' library(XML)
#' xmlParse(out)
#' solr_parse(out, "df")
#' }

solr_mlt <- function(q='*:*', fq = NULL, mlt.count=NULL, mlt.fl=NULL, mlt.mintf=NULL, 
  mlt.mindf=NULL, mlt.minwl=NULL, mlt.maxwl=NULL, mlt.maxqt=NULL, mlt.maxntp=NULL, 
  mlt.boost=NULL, mlt.qf=NULL, fl=NULL, wt='json', start=0, rows=NULL, key = NULL, 
  url = NULL, callopts=list(), raw=FALSE, parsetype='df', concat=',')
{
  flsplit <- strsplit(fl, ",")[[1]]
  if(any(grepl('id', flsplit))){
    fl2 <- fl
  } else
  {
    fl2 <- sprintf('id,%s',fl)
  }
  args <- compact(list(q=q, fq=fq, mlt='true', fl=fl2, mlt.count=mlt.count, mlt.fl=mlt.fl, 
    mlt.mintf=mlt.mintf, mlt.mindf=mlt.mindf, mlt.minwl=mlt.minwl, 
    mlt.maxwl=mlt.maxwl, mlt.maxqt=mlt.maxqt, mlt.maxntp=mlt.maxntp, 
    mlt.boost=mlt.boost, mlt.qf=mlt.qf, start=start, rows=rows, wt=wt))
  
  tt <- GET(url, query = args, callopts)
  stop_for_status(tt)
  out <- content(tt, as="text")
  class(out) <- "sr_mlt"
  attr(out, "wt") <- wt
  if(raw){ return( out ) } else { solr_parse(out, parsetype, concat) }
}