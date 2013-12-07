#' Solr search.
#' 
#' @import httr XML
#' @importFrom plyr compact
#' @template search
#' @return A list.
#' @seealso \code{\link{solr_highlight}}, \code{\link{solr_facet}}
#' @references See \url{http://wiki.apache.org/solr/#Search_and_Indexing} for 
#' more information.
#' @export
#' @examples \dontrun{
#' url <- 'http://api.plos.org/search'
#' key = getOption('PlosApiKey')
#' 
#' solr_search(q='*:*', rows=2, fl='id', url=url, key=key)
#' 
#' # Search for word ecology in title and cell in the body
#' solr_search(q='title:"ecology" AND body:"cell"', fl='title', rows=5, url=url, key=key)
#' 
#' # Search for word "cell" and not "body" in the title field
#' solr_search(q='title:"cell" -title:"lines"', fl='title', rows=5, url=url, key=key)
#' 
#' # Wildcards
#' ## Search for word that starts with "cell" in the title field
#' solr_search(q='title:"cell*"', fl='title', rows=5, url=url, key=key)
#' 
#' # Proximity searching
#' ## Search for words "sports" and "alcohol" within four words of each other
#' solr_search(q='everything:"sports alcohol"~7', fl='abstract', rows=3, url=url, key=key)
#' 
#' # Range searches
#' ## Search for articles with Twitter count between 5 and 10
#' solr_search(q='*:*', fl='alm_twitterCount,title', fq='alm_twitterCount:[5 TO 10]', rows=3, url=url, key=key)
#' 
#' # Boosts
#' ## Assign higher boost to title matches than to body matches (compare the two calls)
#' solr_search(q='title:"cell" abstract:"science"', fl='title', rows=3, url=url, key=key)
#' solr_search(q='title:"cell"^1.5 AND abstract:"science"', fl='title', rows=3, url=url, key=key)
#' }

solr_search<- function(q='*:*', sort=NULL, start=0, rows=NULL, pageDoc=NULL, 
  pageScore=NULL, fq=NULL, fl=NULL, defType=NULL, timeAllowed=NULL, qt=NULL, 
  wt='json', NOW=NULL, TZ=NULL, echoHandler=NULL, echoParams=NULL, key = NULL, 
  url = NULL, callopts=list())
{
  args <- compact(list(q=q, sort=sort, start=start, rows=rows, pageDoc=pageDoc,
                       pageScore=pageScore, fq=fq, fl=fl, defType=defType, 
                       timeAllowed=timeAllowed, qt=qt, wt=wt, NOW=NOW, TZ=TZ,
                       echoHandler=echoHandler, echoParams=echoParams))
  
  tt <- GET(url, query = args, callopts)
  stop_for_status(tt)
  out <- content(tt)
  return( out )
}