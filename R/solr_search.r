#' Solr search.
#' 
#' @import httr XML
#' @template search
#' @return XML, JSON, a list, or data.frame
#' @seealso \code{\link{solr_highlight}}, \code{\link{solr_facet}}
#' @references See \url{http://wiki.apache.org/solr/#Search_and_Indexing} for more information.
#' @export
#' @examples \dontrun{
#' url <- 'http://api.plos.org/search'
#' solr_search(q='*:*', rows=2, fl='id', base=url)
#' 
#' # Search for word ecology in title and cell in the body
#' solr_search(q='title:"ecology" AND body:"cell"', fl='title', rows=5, base=url)
#' 
#' # Search for word "cell" and not "body" in the title field
#' solr_search(q='title:"cell" -title:"lines"', fl='title', rows=5, base=url)
#' 
#' # Wildcards
#' ## Search for word that starts with "cell" in the title field
#' solr_search(q='title:"cell*"', fl='title', rows=5, base=url)
#' 
#' # Proximity searching
#' ## Search for words "sports" and "alcohol" within four words of each other
#' solr_search(q='everything:"sports alcohol"~7', fl='abstract', rows=3, base=url)
#' 
#' # Range searches
#' ## Search for articles with Twitter count between 5 and 10
#' solr_search(q='*:*', fl=c('alm_twitterCount','id'), fq='alm_twitterCount:[5 TO 50]', 
#' rows=10, base=url)
#' 
#' # Boosts
#' ## Assign higher boost to title matches than to body matches (compare the two calls)
#' solr_search(q='title:"cell" abstract:"science"', fl='title', rows=3, 
#'    base=url)
#' solr_search(q='title:"cell"^1.5 AND abstract:"science"', fl='title', rows=3, 
#'    base=url)
#' 
#' # Parse data, using the USGS BISON API
#' url <- "http://bisonapi.usgs.ornl.gov/solr/occurrences/select"
#' out <- solr_search(q='*:*', fl=c('scientificName','decimalLatitude','decimalLongitude'), 
#'    base=url, raw=TRUE)
#' solr_parse(out, 'df')
#' ## gives the same result
#' solr_search(q='*:*', fl=c('scientificName','decimalLatitude','decimalLongitude'), base=url)
#' 
#' ## You can choose how to combine elements longer than length 1
#' solr_search(q='*:*', fl=c('scientificName','decimalLatitude','decimalLongitude'), base=url, 
#'    parsetype='df', concat=';')
#' 
#' # Using the USGS BISON API (http://bison.usgs.ornl.gov/services.html#solr)
#' ## the species names endpoint
#' url2 <- "http://bisonapi.usgs.ornl.gov/solr/occurrences/select"
#' solr_search(q='*:*', base=url2, parsetype='list', rows=2)
#' solr_search(scientificName='Helianthus annuus', fl=c('scientificName','TSNs'), base=url2)
#' 
#' # FunctionQuery queries
#' ## This kind of query allows you to use the actual values of fields to calculate 
#' ## relevancy scores for returned documents
#' 
#' ## Here, we search on the product of counter_total_all and alm_twitterCount 
#' ## metrics for articles in PLOS Journals
#' url <- 'http://api.plos.org/search'
#' solr_search(q="{!func}product($v1,$v2)", v1 = 'sqrt(counter_total_all)', 
#'    v2 = 'log(alm_twitterCount)', rows=5, fl=c('id','title'), fq='doc_type:full', 
#'    base=url) 
#'    
#' ## here, search on the product of counter_total_all and alm_twitterCount, using 
#' ## a new temporary field "_val_"
#' solr_search(q='_val_:"product(counter_total_all,alm_twitterCount)"', 
#'    rows=5, fl=c('id','title'), fq='doc_type:full', base=url) 
#' 
#' ## papers with most citations   
#' solr_search(q='_val_:"max(counter_total_all)"', 
#'    rows=5, fl=c('id','counter_total_all'), fq='doc_type:full', base=url) 
#'    
#' ## papers with most tweets
#' solr_search(q='_val_:"max(alm_twitterCount)"', 
#'    rows=5, fl=c('id','alm_twitterCount'), fq='doc_type:full', base=url) 
#'    
#' ## using wt = csv
#' url <- 'http://api.plos.org/search'
#' solr_search(q='*:*', rows=50, fl=c('id','score'), fq='doc_type:full', base=url, wt="csv")
#' solr_search(q='*:*', rows=50, fl=c('id','score'), fq='doc_type:full', base=url)
#' 
#' ## Searching Europeana
#' ### They don't return the expected Solr output, so we can get raw data, then parse separately
#' url <- 'http://europeana.eu/api/v2/search.json'
#' key <- getOption("eu_key")
#' dat <- solr_search(query='*:*', rows=5, base=url, wskey = key, raw=TRUE)
#' library('jsonlite')
#' head( jsonlite::fromJSON(dat)$items )
#' }

solr_search <- function(q='*:*', sort=NULL, start=NULL, rows=NULL, pageDoc=NULL, 
  pageScore=NULL, fq=NULL, fl=NULL, defType=NULL, timeAllowed=NULL, qt=NULL, 
  wt='json', NOW=NULL, TZ=NULL, echoHandler=NULL, echoParams=NULL, key = NULL, 
  base = NULL, callopts=list(), raw=FALSE, parsetype='df', concat=',', ..., verbose=TRUE)
{
  if(is.null(base)){
    stop("You must provide a url, e.g., http://api.plos.org/search or http://localhost:8983/solr/select")
  }
  
  if(!is.null(fl)) fl <- paste0(fl, collapse = ",")
  args <- sc(list(q=q, sort=sort, start=start, rows=rows, pageDoc=pageDoc,
      pageScore=pageScore, fl=fl, fq=fq, defType=defType, 
      timeAllowed=timeAllowed, qt=qt, wt=wt, NOW=NOW, TZ=TZ,
      echoHandler=echoHandler, echoParams=echoParams))
  
  # additional parameters
  args <- c(args, list(...))
  if('query' %in% names(args)){
    args <- args[!names(args) %in% "q"]
  }

  out <- structure(solr_GET(base, args, callopts, verbose), class="sr_search", wt=wt)
  if(raw){ return( out ) } else { solr_parse(out, parsetype, concat) }
}
