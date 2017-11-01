#' @title All purpose search
#'
#' @description Includes documents, facets, groups, mlt, stats, and highlights
#'
#' @export
#' @template search
#' @template optimizerows
#' @param conn A solrium connection object, see [SolrClient]
#' @param params (list) a named list of parameters, results in a GET reqeust
#' as long as no body parameters given
#' @param body (list) a named list of parameters, if given a POST request
#' will be performed
#' @return XML, JSON, a list, or data.frame
#' @seealso [solr_highlight()], [solr_facet()]
#' @references See <http://wiki.apache.org/solr/#Search_and_Indexing> for
#' more information.
#' @examples \dontrun{
#' # connect
#' (cli <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL))
#'
#' solr_all(cli, params = list(q='*:*', rows=2, fl='id'))
#'
#' # facets
#' solr_all(cli, params = list(q='*:*', rows=2, fl='id', facet="true",
#'   facet.field="journal"))
#'
#' # mlt
#' solr_all(cli, params = list(q='ecology', rows=2, fl='id', mlt='true',
#'   mlt.count=2, mlt.fl='abstract'))
#'
#' # facets and mlt
#' solr_all(cli, params = list(q='ecology', rows=2, fl='id', facet="true",
#'   facet.field="journal", mlt='true', mlt.count=2, mlt.fl='abstract'))
#'
#' # stats
#' solr_all(cli, params = list(q='ecology', rows=2, fl='id', stats='true',
#'   stats.field='counter_total_all'))
#'
#' # facets, mlt, and stats
#' solr_all(cli, params = list(q='ecology', rows=2, fl='id', facet="true",
#'   facet.field="journal", mlt='true', mlt.count=2, mlt.fl='abstract',
#'   stats='true', stats.field='counter_total_all'))
#'
#' # group
#' solr_all(cli, params = list(q='ecology', rows=2, fl='id', group='true',
#'  group.field='journal', group.limit=3))
#'
#' # facets, mlt, stats, and groups
#' solr_all(cli, params = list(q='ecology', rows=2, fl='id', facet="true",
#'  facet.field="journal", mlt='true', mlt.count=2, mlt.fl='abstract',
#'  stats='true', stats.field='counter_total_all', group='true',
#'  group.field='journal', group.limit=3))
#'
#' # using wt = xml
#' solr_all(cli, params = list(q='*:*', rows=50, fl=c('id','score'),
#'   fq='doc_type:full', wt="xml"), raw=TRUE)
#' }

solr_all <- function(conn, name = NULL, params = NULL, body = NULL,
                     callopts=list(), raw=FALSE, parsetype='df',
                     concat=',', optimizeMaxRows = TRUE,
                     minOptimizedRows = 50000L, ...) {

  conn$all(name = name, params = params, body = body, callopts = callopts,
             raw = raw, parsetype = parsetype, concat = concat,
             optimizeMaxRows = optimizeMaxRows,
             minOptimizedRows = minOptimizedRows, ...)
}
