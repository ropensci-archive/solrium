#' @title Grouped search
#' 
#' @description Returns only group items
#'
#' @template group
#' @return XML, JSON, a list, or data.frame
#' @seealso \code{\link{solr_highlight}}, \code{\link{solr_facet}}
#' @references See \url{http://wiki.apache.org/solr/FieldCollapsing} for more
#' information.
#' @export
#' @examples \dontrun{
#' # connect
#' solr_connect('http://api.plos.org/search')
#'
#' # Basic group query
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl=c('id','score'))
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl='article_type')
#'
#' # Different ways to sort (notice diff btw sort of group.sort)
#' # note that you can only sort on a field if you return that field
#' solr_group(q='ecology', group.field='journal', group.limit=3,
#'    fl=c('id','score'))
#' solr_group(q='ecology', group.field='journal', group.limit=3,
#'    fl=c('id','score','alm_twitterCount'), group.sort='alm_twitterCount desc')
#' solr_group(q='ecology', group.field='journal', group.limit=3,
#'    fl=c('id','score','alm_twitterCount'), sort='score asc', group.sort='alm_twitterCount desc')
#'
#' # Two group.field values
#' out <- solr_group(q='ecology', group.field=c('journal','article_type'), group.limit=3,
#'    fl='id', raw=TRUE)
#' solr_parse(out)
#' solr_parse(out, 'df')
#'
#' # Get two groups, one with alm_twitterCount of 0-10, and another group with 10 to infinity
#' solr_group(q='ecology', group.limit=3, fl=c('id','alm_twitterCount'),
#'  group.query=c('alm_twitterCount:[0 TO 10]','alm_twitterCount:[10 TO *]'))
#'
#' # Use of group.format and group.simple.
#' ## The raw data structure of these two calls are slightly different, but
#' ## the parsing inside the function outputs the same results. You can of course
#' ## set raw=TRUE to get back what the data actually look like
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl=c('id','score'),
#'    group.format='simple')
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl=c('id','score'),
#'    group.format='grouped')
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl=c('id','score'),
#'    group.format='grouped', group.main='true')
#' }

solr_group <- function(name = NULL, q='*:*', start=0, rows = NA, sort = NA, fq = NA, fl = NULL,
  wt='json', key = NA, group.field = NA, group.limit = NA, group.offset = NA,
  group.sort = NA, group.main = NA, group.ngroups = NA,
  group.cache.percent = NA, group.query = NA, group.format = NA,
  group.func = NA, callopts=list(), raw=FALSE, parsetype='df',
  concat=',', ...) {

  check_defunct(...)
  conn <- solr_settings()
  check_conn(conn)
  if (!is.null(fl)) fl <- paste0(fl, collapse = ",")
  todonames <- c("group.query","group.field", 'q', 'start', 'rows', 'sort',
    'fq', 'wt', 'group.limit', 'group.offset', 'group.sort', 'group.sort',
    'group.format', 'group.func', 'group.main', 'group.ngroups',
    'group.cache.percent', 'group.cache.percent', 'fl')
  args <- collectargs(todonames)
  args$group <- 'true'

  # additional parameters
  args <- c(args, list(...))

  out <- structure(solr_GET(base = handle_url(conn, name), args, callopts, conn$proxy), 
                   class = "sr_group", wt = wt)
  if (raw) { return( out ) } else { solr_parse(out, parsetype, concat) }
}
