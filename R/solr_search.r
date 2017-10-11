#' @title Solr search
#'
#' @description Returns only matched documents, and doesn't return other items,
#' including facets, groups, mlt, stats, and highlights.
#'
#' @export
#' @template search
#' @param conn A solrium connection object, see [SolrClient]
#' @param params (list) a named list of parameters, results in a GET reqeust
#' as long as no body parameters given
#' @param body (list) a named list of parameters, if given a POST request
#' will be performed
#' @return XML, JSON, a list, or data.frame
#' @seealso [solr_highlight()], [solr_facet()]
#' @references See <http://wiki.apache.org/solr/#Search_and_Indexing>
#' for more information.
#' @note SOLR v1.2 was first version to support csv. See
#' <https://issues.apache.org/jira/browse/SOLR-66>
#' @examples \dontrun{
#' # Connect to a local Solr instance
#' (cli <- SolrClient$new())
#' cli$search("gettingstarted")
#' cli$search("gettingstarted", q = "features:notes")
#'
#' solr_search(cli, "gettingstarted")
#' solr_search(cli, "gettingstarted", params = list(q = "features:notes"))
#' solr_search(cli, "gettingstarted", body = list(q = "features:notes"))
#'
#' (cli <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL))
#' cli$search(params = list(q = "*:*"))
#' cli$search(params = list(q = "title:golgi", fl = c('id', 'title')))
#'
#' cli$search(params = list(q = "*:*", facet = TRUE))
#'
#'
#' # search
#' solr_search(cli, params = list(q='*:*', rows=2, fl='id'))
#'
#' # search and return all rows
#' solr_search(q='*:*', rows=-1, fl='id')
#'
#' # Search for word ecology in title and cell in the body
#' solr_search(cli, params = list(q='title:"ecology" AND body:"cell"',
#'   fl='title', rows=5))
#'
#' # Search for word "cell" and not "body" in the title field
#' solr_search(cli, params = list(q='title:"cell" -title:"lines"', fl='title',
#'   rows=5))
#'
#' # Wildcards
#' ## Search for word that starts with "cell" in the title field
#' solr_search(cli, params = list(q='title:"cell*"', fl='title', rows=5))
#'
#' # Proximity searching
#' ## Search for words "sports" and "alcohol" within four words of each other
#' solr_search(cli, params = list(q='everything:"sports alcohol"~7',
#'   fl='abstract', rows=3))
#'
#' # Range searches
#' ## Search for articles with Twitter count between 5 and 10
#' solr_search(cli, params = list(q='*:*', fl=c('alm_twitterCount','id'),
#'   fq='alm_twitterCount:[5 TO 50]', rows=10))
#'
#' # Boosts
#' ## Assign higher boost to title matches than to body matches
#' ## (compare the two calls)
#' solr_search(cli, params = list(q='title:"cell" abstract:"science"',
#'   fl='title', rows=3))
#' solr_search(cli, params = list(q='title:"cell"^1.5 AND abstract:"science"',
#'   fl='title', rows=3))
#'
#' # FunctionQuery queries
#' ## This kind of query allows you to use the actual values of fields to
#' ## calculate relevancy scores for returned documents
#'
#' ## Here, we search on the product of counter_total_all and alm_twitterCount
#' ## metrics for articles in PLOS Journals
#' solr_search(cli, params = list(q="{!func}product($v1,$v2)",
#'   v1 = 'sqrt(counter_total_all)',
#'   v2 = 'log(alm_twitterCount)', rows=5, fl=c('id','title'),
#'   fq='doc_type:full'))
#'
#' ## here, search on the product of counter_total_all and alm_twitterCount,
#' ## using a new temporary field "_val_"
#' solr_search(cli,
#'   params = list(q='_val_:"product(counter_total_all,alm_twitterCount)"',
#'   rows=5, fl=c('id','title'), fq='doc_type:full'))
#'
#' ## papers with most citations
#' solr_search(cli, params = list(q='_val_:"max(counter_total_all)"',
#'    rows=5, fl=c('id','counter_total_all'), fq='doc_type:full'))
#'
#' ## papers with most tweets
#' solr_search(cli, params = list(q='_val_:"max(alm_twitterCount)"',
#'    rows=5, fl=c('id','alm_twitterCount'), fq='doc_type:full'))
#'
#' ## using wt = csv
#' solr_search(cli, params = list(q='*:*', rows=50, fl=c('id','score'),
#'   fq='doc_type:full', wt="csv"))
#' solr_search(cli, params = list(q='*:*', rows=50, fl=c('id','score'),
#'   fq='doc_type:full'))
#'
#' # using a proxy
#' # cli <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL,
#' #   proxy = list(url = "http://186.249.1.146:80"))
#' # solr_search(cli, q='*:*', rows=2, fl='id', callopts=list(verbose=TRUE))
#'
#' # Pass on curl options to modify request
#' ## verbose
#' solr_search(q='*:*', rows=2, fl='id', callopts = list(verbose=TRUE))
#' ## timeout
#' # solr_search(q='*:*', rows=200, fl='id', callopts=list(timeout_ms=1))
#'
#' ## Searching Europeana
#' ### They don't return the expected Solr output, so we can get raw data,
#' ### then parse separately
#' (cli <- SolrClient$new(host = "www.europeana.eu",
#'   path = "api/v2/search.json", port = NULL))
#' key <- getOption("eu_key")
#' dat <- solr_search(cli, params = list(query='*:*', rows=5, wskey=key),
#'   raw = TRUE)
#' library('jsonlite')
#' head( jsonlite::fromJSON(dat)$items )
#' }

solr_search <- function(conn, name = NULL, params = list(q = '*:*'),
  body = NULL, callopts = list(), raw = FALSE,  parsetype = 'df',
  concat = ',', ...) {

  conn$search(name = name, params = params, body = body, callopts = callopts,
              raw = raw, parsetype = parsetype, concat = concat, ...)
}

# solr_search <- function(name = NULL, q='*:*', sort=NULL, start=NULL, rows=NULL, pageDoc=NULL,
#   pageScore=NULL, fq=NULL, fl=NULL, defType=NULL, timeAllowed=NULL, qt=NULL,
#   wt='json', NOW=NULL, TZ=NULL, echoHandler=NULL, echoParams=NULL, key=NULL,
#   callopts=list(), raw=FALSE, parsetype='df', concat=',',
#   optimizeMaxRows=TRUE, minOptimizedRows=50000, ...) {

#   rows <- cn(rows)
#   if (!is.null(rows) && optimizeMaxRows) {
#     if (rows > minOptimizedRows || rows < 0) {
#       out <- solr_search_exec(name=name, q=q, rows='0', wt='json', raw='TRUE')
#       outJson <- fromJSON(out)
#       if (rows > outJson$response$numFound || rows < 0) rows <- as.double(outJson$response$numFound)
#     }
#   }

#   solr_search_exec(name, q, sort, start, rows, pageDoc,
#     pageScore, fq, fl, defType, timeAllowed,
#     qt, wt, NOW, TZ, echoHandler, echoParams,
#     key, callopts, raw, parsetype, concat, ...)
# }

# solr_search_exec <- function(name = NULL, q='*:*', sort=NULL, start=NULL, rows=NULL, pageDoc=NULL,
#   pageScore=NULL, fq=NULL, fl=NULL, defType=NULL, timeAllowed=NULL, qt=NULL,
#   wt='json', NOW=NULL, TZ=NULL, echoHandler=NULL, echoParams=NULL, key = NULL,
#   callopts=list(), raw=FALSE, parsetype='df', concat=',', ...) {

#   check_defunct(...)
#   conn <- solr_settings()
#   check_conn(conn)
#   check_wt(wt)
#   if (!is.null(fl)) fl <- paste0(fl, collapse = ",")
#   args <- sc(list(q = q, sort = sort, start = start, rows = rows, pageDoc = pageDoc,
#       pageScore = pageScore, fl = fl, defType = defType,
#       timeAllowed = timeAllowed, qt = qt, wt = wt, NOW = NOW, TZ = TZ,
#       echoHandler = echoHandler, echoParams = echoParams))

#   # args that can be repeated
#   todonames <- "fq"
#   args <- c(args, collectargs(todonames))

#   # additional parameters
#   args <- c(args, list(...))
#   if ('query' %in% names(args)) {
#     args <- args[!names(args) %in% "q"]
#   }

#   out <- structure(solr_GET(handle_url(conn, name), args, callopts, conn$proxy),
#                    class = "sr_search", wt = wt)
#   if (raw) {
#     return( out )
#   } else {
#     parsed <- cont_parse(out, wt)
#     parsed <- structure(parsed, class = c(class(parsed), "sr_search"))
#     solr_parse(parsed, parsetype, concat)
#   }
# }

# handle_url <- function(conn, name) {
#   if (is.null(name)) {
#     conn$url
#   } else {
#     file.path(conn$url, "solr", name, "select")
#   }
# }
