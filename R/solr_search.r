#' @title Solr search
#' 
#' @description Returns only matched documents, and doesn't return other items, 
#' including facets, groups, mlt, stats, and highlights.
#'
#' @template search
#' @return XML, JSON, a list, or data.frame
#' @param wt (character) One of json, xml, or csv. Data type returned, defaults to 'csv'.
#' If json, uses \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses
#' \code{\link[XML]{xmlParse}} to parse. If csv, uses \code{\link{read.table}} to parse.
#' \code{wt=csv} gives the fastest performance at least in all the cases we have
#' tested in, thus it's the default value for \code{wt}.
#' @seealso \code{\link{solr_highlight}}, \code{\link{solr_facet}}
#' @references See \url{http://wiki.apache.org/solr/#Search_and_Indexing} for more information.
#' @note SOLR v1.2 was first version to support csv. See
#' \url{https://issues.apache.org/jira/browse/SOLR-66}
#' @export
#' @examples \dontrun{
#' # connect
#' solr_connect('http://api.plos.org/search')
#'
#' # search
#' solr_search(q='*:*', rows=2, fl='id')
#'
#' # Search for word ecology in title and cell in the body
#' solr_search(q='title:"ecology" AND body:"cell"', fl='title', rows=5)
#'
#' # Search for word "cell" and not "body" in the title field
#' solr_search(q='title:"cell" -title:"lines"', fl='title', rows=5)
#'
#' # Wildcards
#' ## Search for word that starts with "cell" in the title field
#' solr_search(q='title:"cell*"', fl='title', rows=5)
#'
#' # Proximity searching
#' ## Search for words "sports" and "alcohol" within four words of each other
#' solr_search(q='everything:"sports alcohol"~7', fl='abstract', rows=3)
#'
#' # Range searches
#' ## Search for articles with Twitter count between 5 and 10
#' solr_search(q='*:*', fl=c('alm_twitterCount','id'), fq='alm_twitterCount:[5 TO 50]',
#' rows=10)
#'
#' # Boosts
#' ## Assign higher boost to title matches than to body matches (compare the two calls)
#' solr_search(q='title:"cell" abstract:"science"', fl='title', rows=3)
#' solr_search(q='title:"cell"^1.5 AND abstract:"science"', fl='title', rows=3)
#'
#' # FunctionQuery queries
#' ## This kind of query allows you to use the actual values of fields to calculate
#' ## relevancy scores for returned documents
#'
#' ## Here, we search on the product of counter_total_all and alm_twitterCount
#' ## metrics for articles in PLOS Journals
#' solr_search(q="{!func}product($v1,$v2)", v1 = 'sqrt(counter_total_all)',
#'    v2 = 'log(alm_twitterCount)', rows=5, fl=c('id','title'), fq='doc_type:full')
#'
#' ## here, search on the product of counter_total_all and alm_twitterCount, using
#' ## a new temporary field "_val_"
#' solr_search(q='_val_:"product(counter_total_all,alm_twitterCount)"',
#'    rows=5, fl=c('id','title'), fq='doc_type:full')
#'
#' ## papers with most citations
#' solr_search(q='_val_:"max(counter_total_all)"',
#'    rows=5, fl=c('id','counter_total_all'), fq='doc_type:full')
#'
#' ## papers with most tweets
#' solr_search(q='_val_:"max(alm_twitterCount)"',
#'    rows=5, fl=c('id','alm_twitterCount'), fq='doc_type:full')
#'
#' ## using wt = csv
#' solr_search(q='*:*', rows=50, fl=c('id','score'), fq='doc_type:full', wt="csv")
#' solr_search(q='*:*', rows=50, fl=c('id','score'), fq='doc_type:full')
#'
#' # using a proxy
#' prox <- list(url = "186.249.1.146", port = 80)
#' solr_connect(url = 'http://api.plos.org/search', proxy = prox)
#' solr_search(q='*:*', rows=2, fl='id', callopts=verbose())
#' ## vs. w/o a proxy
#' solr_connect(url = 'http://api.plos.org/search')
#' solr_search(q='*:*', rows=2, fl='id', callopts=verbose())
#'
#' # Pass on curl options to modify request
#' solr_connect(url = 'http://api.plos.org/search')
#' ## verbose
#' solr_search(q='*:*', rows=2, fl='id', callopts=verbose())
#' ## progress
#' res <- solr_search(q='*:*', rows=200, fl='id', callopts=progress())
#' ## timeout
#' # solr_search(q='*:*', rows=200, fl='id', callopts=timeout(0.01))
#' ## combine curl options using the c() function
#' opts <- c(verbose(), progress())
#' res <- solr_search(q='*:*', rows=200, fl='id', callopts=opts)
#'
#' ## Searching Europeana
#' ### They don't return the expected Solr output, so we can get raw data, then parse separately
#' solr_connect('http://europeana.eu/api/v2/search.json')
#' key <- getOption("eu_key")
#' dat <- solr_search(query='*:*', rows=5, wskey = key, raw=TRUE)
#' library('jsonlite')
#' head( jsonlite::fromJSON(dat)$items )
#' 
#' # Connect to a local Solr instance
#' ## not run - replace with your local Solr URL and collection/core name
#' # solr_connect("localhost:8889")
#' # solr_search("gettingstarted")
#' }

solr_search <- function(name = NULL, q='*:*', sort=NULL, start=NULL, rows=NULL, pageDoc=NULL,
  pageScore=NULL, fq=NULL, fl=NULL, defType=NULL, timeAllowed=NULL, qt=NULL,
  wt='json', NOW=NULL, TZ=NULL, echoHandler=NULL, echoParams=NULL, key = NULL,
  callopts=list(), raw=FALSE, parsetype='df', concat=',', ...) {

  check_defunct(...)
  conn <- solr_settings()
  check_conn(conn)
  check_wt(wt)
  if (!is.null(fl)) fl <- paste0(fl, collapse = ",")
  args <- sc(list(q = q, sort = sort, start = start, rows = rows, pageDoc = pageDoc,
      pageScore = pageScore, fl = fl, defType = defType,
      timeAllowed = timeAllowed, qt = qt, wt = wt, NOW = NOW, TZ = TZ,
      echoHandler = echoHandler, echoParams = echoParams))
  
  # args that can be repeated
  todonames <- "fq"
  args <- c(args, collectargs(todonames))

  # additional parameters
  args <- c(args, list(...))
  if ('query' %in% names(args)) {
    args <- args[!names(args) %in% "q"]
  }

  out <- structure(solr_GET(handle_url(conn, name), args, callopts, conn$proxy), 
                   class = "sr_search", wt = wt)
  if (raw) {
    return( out )
  } else {
    solr_parse(out, parsetype, concat)
  }
}

handle_url <- function(conn, name) {
  if (is.null(name)) {
    conn$url
  } else {
    file.path(conn$url, "solr", name, "select")
  }
}
