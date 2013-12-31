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
#' url <- 'http://api.plos.org/search'; key = getOption('PlosApiKey')
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
#' solr_search(q='*:*', fl='alm_twitterCount,title', fq='alm_twitterCount:[5 TO 10]', 
#' rows=3, url=url, key=key)
#' 
#' # Boosts
#' ## Assign higher boost to title matches than to body matches (compare the two calls)
#' solr_search(q='title:"cell" abstract:"science"', fl='title', rows=3, 
#'    url=url, key=key)
#' solr_search(q='title:"cell"^1.5 AND abstract:"science"', fl='title', rows=3, 
#'    url=url, key=key)
#' 
#' # Parse data, using the USGS BISON API
#' url <- "http://bisonapi.usgs.ornl.gov/solr/occurrences/select"
#' out <- solr_search(q='*:*', fl='scientific_name,latitude,longitude', url=url, raw=TRUE)
#' solr_parse(out, 'df')
#' ## gives the same result
#' solr_search(q='*:*', fl='scientific_name,latitude,longitude', url=url)
#' 
#' ## You can choose how to combine elements longer than length 1
#' solr_search(q='*:*', fl='scientific_name,latitude,longitude', url=url, 
#'    parsetype='df', concat=';')
#' 
#' # Using the USGS BISON API (http://bison.usgs.ornl.gov/services.html#solr)
#' ## the species names endpoint
#' url2 <- "http://bisonapi.usgs.ornl.gov/solr/species/select"
#' solr_search(q='*:*', url=url2, parsetype='list')
#' 
#' # FunctionQuery queries
#' ## This kind of query allows you to use the actual values of fields to calculate 
#' ## relevancy scores for returned documents
#' 
#' ## Here, we search on the product of counter_total_all and alm_twitterCount 
#' ## metrics for articles in PLOS Journals
#' url <- 'http://api.plos.org/search'; key <- 'key'
#' solr_search(q="{!func}product($v1,$v2)", v1 = 'sqrt(counter_total_all)', 
#'    v2 = 'log(alm_twitterCount)', rows=5, fl='id,title', fq='doc_type:full', 
#'    url=url, key=key) 
#'    
#' ## here, search on the product of counter_total_all and alm_twitterCount, using 
#' ## a new temporary field "_val_"
#' solr_search(q='_val_:"product(counter_total_all,alm_twitterCount)"', 
#'    rows=5, fl='id,title', fq='doc_type:full', url=url, key=key) 
#' 
#' ## papers with most citations   
#' solr_search(q='_val_:"max(counter_total_all)"', 
#'    rows=5, fl='id,counter_total_all', fq='doc_type:full', url=url, key=key) 
#'    
#' ## papers with most tweets
#' solr_search(q='_val_:"max(alm_twitterCount)"', 
#'    rows=5, fl='id,alm_twitterCount', fq='doc_type:full', url=url, key=key) 
#' }

solr_search<- function(q='*:*', sort=NULL, start=0, rows=NULL, pageDoc=NULL, 
  pageScore=NULL, fq=NULL, fl=NULL, defType=NULL, timeAllowed=NULL, qt=NULL, 
  wt='json', NOW=NULL, TZ=NULL, echoHandler=NULL, echoParams=NULL, key = NULL, 
  url = NULL, callopts=list(), raw=FALSE, parsetype='df', concat=',', ...)
{
  args <- compact(list(q=q, sort=sort, start=start, rows=rows, pageDoc=pageDoc,
                       pageScore=pageScore, fq=fq, fl=fl, defType=defType, 
                       timeAllowed=timeAllowed, qt=qt, wt=wt, NOW=NOW, TZ=TZ,
                       echoHandler=echoHandler, echoParams=echoParams))
  
  # additional parameters
  args <- c(args, list(...))
  
  tt <- GET(url, query = args, callopts)
  stop_for_status(tt)
  out <- content(tt, as="text")
  class(out) <- "sr_search"
  attr(out, "wt") <- wt
  if(raw){ return( out ) } else { solr_parse(out, parsetype, concat) }
}