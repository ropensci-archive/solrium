#' @title Grouped search
#'
#' @description Returns only group items
#'
#' @export
#' @template group
#' @param conn A solrium connection object, see [SolrClient]
#' @param params (list) a named list of parameters, results in a GET reqeust
#' as long as no body parameters given
#' @param body (list) a named list of parameters, if given a POST request
#' will be performed
#' @return XML, JSON, a list, or data.frame
#' @seealso [solr_highlight()], [solr_facet()]
#' @references See <http://wiki.apache.org/solr/FieldCollapsing> for more
#' information.
#' @examples \dontrun{
#' # connect
#' (cli <- SolrClient$new())
#'
#' # by default we do a GET request
#' cli$group("gettingstarted",
#'   params = list(q='*:*', group.field='compName_s'))
#' # OR
#' solr_group(cli, "gettingstarted",
#'   params = list(q='*:*', group.field='compName_s'))
#'
#' # connect
#' (cli <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL))
#'
#' # Basic group query
#' solr_group(cli, params = list(q='ecology', group.field='journal',
#'   group.limit=3, fl=c('id','score')))
#' solr_group(cli, params = list(q='ecology', group.field='journal',
#'   group.limit=3, fl='article_type'))
#'
#' # Different ways to sort (notice diff btw sort of group.sort)
#' # note that you can only sort on a field if you return that field
#' solr_group(cli, params = list(q='ecology', group.field='journal', group.limit=3,
#'    fl=c('id','score')))
#' solr_group(cli, params = list(q='ecology', group.field='journal', group.limit=3,
#'    fl=c('id','score','alm_twitterCount'), group.sort='alm_twitterCount desc'))
#' solr_group(cli, params = list(q='ecology', group.field='journal', group.limit=3,
#'    fl=c('id','score','alm_twitterCount'), sort='score asc',
#'    group.sort='alm_twitterCount desc'))
#'
#' # Two group.field values
#' out <- solr_group(cli, params = list(q='ecology', group.field=c('journal','article_type'),
#'   group.limit=3, fl='id'), raw=TRUE)
#' solr_parse(out)
#' solr_parse(out, 'df')
#'
#' # Get two groups, one with alm_twitterCount of 0-10, and another group
#' # with 10 to infinity
#' solr_group(cli, params = list(q='ecology', group.limit=3, fl=c('id','alm_twitterCount'),
#'  group.query=c('alm_twitterCount:[0 TO 10]','alm_twitterCount:[10 TO *]')))
#'
#' # Use of group.format and group.simple.
#' ## The raw data structure of these two calls are slightly different, but
#' ## the parsing inside the function outputs the same results. You can
#' ## of course set raw=TRUE to get back what the data actually look like
#' solr_group(cli, params = list(q='ecology', group.field='journal', group.limit=3,
#'   fl=c('id','score'), group.format='simple'))
#' solr_group(cli, params = list(q='ecology', group.field='journal', group.limit=3,
#'   fl=c('id','score'), group.format='grouped'))
#' solr_group(cli, params = list(q='ecology', group.field='journal', group.limit=3,
#'   fl=c('id','score'), group.format='grouped', group.main='true'))
#'
#' # xml back
#' solr_group(cli, params = list(q='ecology', group.field='journal', group.limit=3,
#'   fl=c('id','score'), wt = "xml"))
#' solr_group(cli, params = list(q='ecology', group.field='journal', group.limit=3,
#'   fl=c('id','score'), wt = "xml"), parsetype = "list")
#' res <- solr_group(cli, params = list(q='ecology', group.field='journal', group.limit=3,
#'   fl=c('id','score'), wt = "xml"), raw = TRUE)
#' library("xml2")
#' xml2::read_xml(unclass(res))
#'
#' solr_group(cli, params = list(q='ecology', group.field='journal', group.limit=3,
#'   fl='article_type', wt = "xml"))
#' solr_group(cli, params = list(q='ecology', group.field='journal', group.limit=3,
#'   fl='article_type', wt = "xml"), parsetype = "list")
#' }
solr_group <- function(conn, name = NULL, params = NULL, body = NULL,
  callopts=list(), raw=FALSE, parsetype='df', concat=',', 
  progress = NULL, ...) {

  conn$group(name = name, params = params, body = body, callopts = callopts,
             raw = raw, parsetype = parsetype, concat = concat, 
             progress = progress, ...)
}
