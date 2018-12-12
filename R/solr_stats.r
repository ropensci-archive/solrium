#' @title Solr stats
#'
#' @description Returns only stat items
#'
#' @export
#' @template stats
#' @param conn A solrium connection object, see [SolrClient]
#' @param params (list) a named list of parameters, results in a GET reqeust
#' as long as no body parameters given
#' @param body (list) a named list of parameters, if given a POST request
#' will be performed
#' @return XML, JSON, a list, or data.frame
#' @seealso [solr_highlight()], [solr_facet()], [solr_search()], [solr_mlt()]
#' @references See <http://wiki.apache.org/solr/StatsComponent> for
#' more information on Solr stats.
#' @examples \dontrun{
#' # connect
#' (cli <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL))
#'
#' # get stats
#' solr_stats(cli, params = list(q='science', stats.field='counter_total_all'),
#'   raw=TRUE)
#' solr_stats(cli, params = list(q='title:"ecology" AND body:"cell"',
#'    stats.field=c('counter_total_all','alm_twitterCount')))
#' solr_stats(cli, params = list(q='ecology',
#'   stats.field=c('counter_total_all','alm_twitterCount'),
#'   stats.facet='journal'))
#' solr_stats(cli, params = list(q='ecology',
#'   stats.field=c('counter_total_all','alm_twitterCount'),
#'   stats.facet=c('journal','volume')))
#'
#' # Get raw data, then parse later if you feel like it
#' ## json
#' out <- solr_stats(cli, params = list(q='ecology',
#'   stats.field=c('counter_total_all','alm_twitterCount'),
#'   stats.facet=c('journal','volume')), raw=TRUE)
#' library("jsonlite")
#' jsonlite::fromJSON(out)
#' solr_parse(out) # list
#' solr_parse(out, 'df') # data.frame
#'
#' ## xml
#' out <- solr_stats(cli, params = list(q='ecology',
#'   stats.field=c('counter_total_all','alm_twitterCount'),
#'   stats.facet=c('journal','volume'), wt="xml"), raw=TRUE)
#' library("xml2")
#' xml2::read_xml(unclass(out))
#' solr_parse(out) # list
#' solr_parse(out, 'df') # data.frame
#'
#' # Get verbose http call information
#' solr_stats(cli, params = list(q='ecology', stats.field='alm_twitterCount'),
#'    callopts=list(verbose=TRUE))
#' }
solr_stats <- function(conn, name = NULL, params = list(q = '*:*',
  stats.field = NULL, stats.facet = NULL), body = NULL, callopts=list(),
  raw=FALSE, parsetype='df', progress = NULL, ...) {

  conn$stats(name = name, params = params, body = body, callopts = callopts,
             raw = raw, parsetype = parsetype, progress = progress, ...)
}
