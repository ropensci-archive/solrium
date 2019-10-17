#' @title "more like this" search
#'
#' @description Returns only more like this items
#'
#' @export
#' @template mlt
#' @template optimizerows
#' @param conn A solrium connection object, see [SolrClient]
#' @param params (list) a named list of parameters, results in a GET request
#' as long as no body parameters given
#' @param body (list) a named list of parameters, if given a POST request
#' will be performed
#' @return XML, JSON, a list, or data.frame
#' @references See https://lucene.apache.org/solr/guide/8_2/morelikethis.html
#' for more information.
#' @examples \dontrun{
#' # connect
#' (conn <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL))
#'
#' # more like this search
#' conn$mlt(params = list(q='*:*', mlt.count=2, mlt.fl='abstract', fl='score',
#'   fq="doc_type:full"))
#' conn$mlt(params = list(q='*:*', rows=2, mlt.fl='title', mlt.mindf=1,
#'   mlt.mintf=1, fl='alm_twitterCount'))
#' conn$mlt(params = list(q='title:"ecology" AND body:"cell"', mlt.fl='title',
#'   mlt.mindf=1, mlt.mintf=1, fl='counter_total_all', rows=5))
#' conn$mlt(params = list(q='ecology', mlt.fl='abstract', fl='title', rows=5))
#' solr_mlt(conn, params = list(q='ecology', mlt.fl='abstract',
#'   fl=c('score','eissn'), rows=5))
#' solr_mlt(conn, params = list(q='ecology', mlt.fl='abstract',
#'   fl=c('score','eissn'), rows=5, wt = "xml"))
#'
#' # get raw data, and parse later if needed
#' out <- solr_mlt(conn, params=list(q='ecology', mlt.fl='abstract', fl='title',
#'  rows=2), raw=TRUE)
#' solr_parse(out, "df")
#' }
solr_mlt <- function(conn, name = NULL, params = NULL, body = NULL,
                     callopts=list(), raw=FALSE, parsetype='df', concat=',',
                     optimizeMaxRows = TRUE, minOptimizedRows = 50000L, 
                     progress = NULL, ...) {

  conn$mlt(name = name, params = params, body = body, callopts = callopts,
           raw = raw, parsetype = parsetype, concat = concat,
           optimizeMaxRows = optimizeMaxRows,
           minOptimizedRows = minOptimizedRows, progress = progress, ...)
}
