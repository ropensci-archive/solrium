#' Solr grouped search.
#' 
#' @import httr XML
#' @importFrom plyr compact
#' @template group
#' @return XML, JSON, a list, or data.frame
#' @seealso \code{\link{solr_highlight}}, \code{\link{solr_facet}}
#' @references See \url{http://wiki.apache.org/solr/FieldCollapsing} for more 
#' information.
#' @export
#' @examples \dontrun{
#' url <- 'http://api.plos.org/search'
#' 
#' # Basic group query
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score', base=url)
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl='article_type', base=url)
#' 
#' # Different ways to sort (notice diff btw sort of group.sort)
#' # note that you can only sort on a field if you return that field
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl=c('id','score'), base=url)
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl=c('id','score','alm_twitterCount'), 
#'    group.sort='alm_twitterCount desc', base=url)
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl=c('id','score','alm_twitterCount'), 
#'    sort='score asc', group.sort='alm_twitterCount desc', base=url)
#' 
#' # Two group.field values
#' out <- solr_group(q='ecology', group.field=c('journal','article_type'), group.limit=3, fl='id', 
#'    base=url, raw=TRUE)
#' solr_parse(out)
#' solr_parse(out, 'df')
#' 
#' # Get two groups, one with alm_twitterCount of 0-10, and another group with 10 to infinity
#' solr_group(q='ecology', group.limit=3, fl=c('id','alm_twitterCount'), 
#'  group.query=c('alm_twitterCount:[0 TO 10]','alm_twitterCount:[10 TO *]'), 
#'  base=url)
#'  
#' # Use of group.format and group.simple. 
#' ## The raw data structure of these two calls are slightly different, but 
#' ## the parsing inside the function outputs the same results. You can of course
#' ## set raw=TRUE to get back what the data actually look like
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl=c('id','score'), 
#'    group.format='simple', base=url)
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl=c('id','score'), 
#'    group.format='grouped', base=url)
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl=c('id','score'), 
#'    group.format='grouped', group.main='true', base=url)
#' }

solr_group <- function(q='*:*', start=0, rows = NA, sort = NA, fq = NA, fl = NA,
  wt='json', key = NA, group.field = NA, group.limit = NA, group.offset = NA, 
  group.sort = NA, group.main = NA, group.ngroups = NA, 
  group.cache.percent = NA, group.query = NA, group.format = NA,
  group.func = NA, base = NA, callopts=list(), raw=FALSE, parsetype='df', 
  concat=',', verbose=TRUE, ...)
{
  if(is.na(base)){
    stop("You must provide a url, e.g., http://api.plos.org/search or http://localhost:8983/solr/select")
  }

  todonames <- c("group.query","group.field", 'q', 'start', 'rows', 'sort', 
    'fq', 'wt', 'group.limit', 'group.offset', 'group.sort', 'group.sort', 
    'group.format', 'group.func', 'group.main', 'group.ngroups',
    'group.cache.percent', 'group.cache.percent', 'fl')
  args <- collectargs(todonames)
  args$group <- 'true'
 
  # additional parameters
  args <- c(args, list(...))
  
  tt <- GET(base, query = args, callopts)
  if(verbose) message(URLdecode(tt$url))
  stop_for_status(tt)
  out <- content(tt, as="text")
  class(out) <- "sr_group"
  attr(out, "wt") <- wt
  if(raw){ return( out ) } else { solr_parse(out, parsetype, concat) }
}