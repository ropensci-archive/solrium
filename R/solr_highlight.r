#' @title Highlighting search
#'
#' @description Returns only highlight items
#'
#' @export
#' @template high
#' @param conn A solrium connection object, see [SolrClient]
#' @param params (list) a named list of parameters, results in a GET reqeust
#' as long as no body parameters given
#' @param body (list) a named list of parameters, if given a POST request
#' will be performed
#' @return XML, JSON, a list, or data.frame
#' @seealso [solr_search()], [solr_facet()]
#' @references See <http://wiki.apache.org/solr/HighlightingParameters> for
#' more information on highlighting.
#' @examples \dontrun{
#' # connect
#' (conn <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL))
#'
#' # highlight search
#' solr_highlight(conn, params = list(q='alcohol', hl.fl = 'abstract', rows=10),
#'   parsetype = "list")
#' solr_highlight(conn, params = list(q='alcohol', hl.fl = c('abstract','title'),
#'   rows=3), parsetype = "list")
#'
#' # Raw data back
#' ## json
#' solr_highlight(conn, params = list(q='alcohol', hl.fl = 'abstract', rows=10),
#'    raw=TRUE)
#' ## xml
#' solr_highlight(conn, params = list(q='alcohol', hl.fl = 'abstract', rows=10,
#'    wt='xml'), raw=TRUE)
#' ## parse after getting data back
#' out <- solr_highlight(conn, params = list(q='theoretical math',
#'    hl.fl = c('abstract','title'), hl.fragsize=30, rows=10, wt='xml'),
#'    raw=TRUE)
#' solr_parse(out, parsetype='list')
#' }
solr_highlight <- function(conn, name = NULL, params = NULL, body = NULL,
                           callopts=list(), raw=FALSE, parsetype='df', ...) {

  conn$highlight(name = name, params = params, body = body, callopts = callopts,
             raw = raw, parsetype = parsetype, ...)
}
