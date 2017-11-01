#' @title Solr search
#'
#' @description Returns only matched documents, and doesn't return other items,
#' including facets, groups, mlt, stats, and highlights.
#'
#' @export
#' @template search
#' @template optimizerows
#' @param conn A solrium connection object, see [SolrClient]
#' @param params (list) a named list of parameters, results in a GET reqeust
#' as long as no body parameters given
#' @param body (list) a named list of parameters, if given a POST request
#' will be performed
#'
#' @return XML, JSON, a list, or data.frame
#' @seealso [solr_highlight()], [solr_facet()]
#' @references See <http://wiki.apache.org/solr/#Search_and_Indexing>
#' for more information.
#' @note SOLR v1.2 was first version to support csv. See
#' <https://issues.apache.org/jira/browse/SOLR-66>
#' @examples \dontrun{
#' # Connect to a local Solr instance
#' (cli <- SolrClient$new())
#' cli$search("gettingstarted", params = list(q = "features:notes"))
#'
#' solr_search(cli, "gettingstarted")
#' solr_search(cli, "gettingstarted", params = list(q = "features:notes"))
#' solr_search(cli, "gettingstarted", body = list(query = "features:notes"))
#'
#' (cli <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL))
#' cli$search(params = list(q = "*:*"))
#' cli$search(params = list(q = "title:golgi", fl = c('id', 'title')))
#'
#' cli$search(params = list(q = "*:*", facet = "true"))
#'
#'
#' # search
#' solr_search(cli, params = list(q='*:*', rows=2, fl='id'))
#'
#' # search and return all rows
#' solr_search(cli, params = list(q='*:*', rows=-1, fl='id'))
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
#' ## many fq values
#' solr_search(cli, params = list(q="*:*", fl=c('id','alm_twitterCount'),
#'    fq=list('doc_type:full','subject:"Social networks"',
#'            'alm_twitterCount:[100 TO 10000]'),
#'    sort='counter_total_month desc'))
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
#' solr_search(cli, params = list(q='*:*', rows=2, fl='id'),
#'   callopts = list(verbose=TRUE))
#' }

solr_search <- function(conn, name = NULL, params = list(q = '*:*'),
  body = NULL, callopts = list(), raw = FALSE, parsetype = 'df',
  concat = ',', optimizeMaxRows = TRUE, minOptimizedRows = 50000L, ...) {

  conn$search(name = name, params = params, body = body, callopts = callopts,
              raw = raw, parsetype = parsetype, concat = concat,
              optimizeMaxRows = optimizeMaxRows,
              minOptimizedRows = minOptimizedRows, ...)
}
