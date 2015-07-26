#' Get Solr stats.
#'
#' @template stats
#' @return XML, JSON, a list, or data.frame
#' @seealso \code{\link{solr_highlight}}, \code{\link{solr_facet}},
#' \code{\link{solr_search}}, \code{\link{solr_mlt}}
#' @references See \url{http://wiki.apache.org/solr/StatsComponent} for
#' more information on Solr stats.
#' @export
#' @examples \dontrun{
#' conn <- solr_connect('http://api.plos.org/search')
#' 
#' solr_stats(conn, q='science', stats.field='counter_total_all', raw=TRUE)
#' solr_stats(conn, q='title:"ecology" AND body:"cell"',
#'    stats.field=c('counter_total_all','alm_twitterCount'))
#' solr_stats(conn, q='ecology', stats.field=c('counter_total_all','alm_twitterCount'),
#'    stats.facet='journal')
#' solr_stats(conn, q='ecology', stats.field=c('counter_total_all','alm_twitterCount'),
#'    stats.facet=c('journal','volume'))
#'
#' # Get raw data, then parse later if you feel like it
#' ## json
#' out <- solr_stats(conn, q='ecology', stats.field=c('counter_total_all','alm_twitterCount'),
#'    stats.facet=c('journal','volume'), raw=TRUE)
#' library("jsonlite")
#' jsonlite::fromJSON(out)
#' solr_parse(out) # list
#' solr_parse(out, 'df') # data.frame
#'
#' ## xml
#' out <- solr_stats(conn, q='ecology', stats.field=c('counter_total_all','alm_twitterCount'),
#'    stats.facet=c('journal','volume'), raw=TRUE, wt="xml")
#' library("XML")
#' XML::xmlParse(out)
#' solr_parse(out) # list
#' solr_parse(out, 'df') # data.frame
#'
#' # Get verbose http call information
#' library("httr")
#' solr_stats(conn, q='ecology', stats.field='alm_twitterCount',
#'    callopts=verbose())
#' }

solr_stats <- function(conn, q='*:*', stats.field=NULL, stats.facet=NULL, wt='json', start=0,
  rows=0, key = NULL, callopts=list(), raw=FALSE, parsetype='df', verbose=TRUE) {
  
  check_conn(conn)
  todonames <- c("q", "stats.field", "stats.facet", "start", "rows", "key", "wt")
  args <- collectargs(todonames)
  args$stats <- 'true'

  out <- structure(solr_GET(conn$url, args, callopts, verbose, conn$proxy), class="sr_stats", wt=wt)
  if(raw){ return( out ) } else { solr_parse(out, parsetype) }
}
