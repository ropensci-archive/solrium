#' Get Solr stats.
#' 
#' @import httr
#' @importFrom plyr compact
#' @template stats
#' @return XML, JSON, a list, or data.frame
#' @seealso \code{\link{solr_highlight}}, \code{\link{solr_facet}}, 
#' \code{\link{solr_search}}, \code{\link{solr_mlt}}
#' @references See \url{http://wiki.apache.org/solr/StatsComponent} for 
#' more information on Solr stats.
#' @export
#' @examples \dontrun{
#' url <- 'http://api.plos.org/search'
#' solr_stats(q='science', stats.field='counter_total_all', base=url, raw=TRUE)
#' solr_stats(q='title:"ecology" AND body:"cell"', 
#'    stats.field=c('counter_total_all','alm_twitterCount'), base=url)
#' solr_stats(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), 
#'    stats.facet='journal', base=url)
#' solr_stats(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), 
#'    stats.facet=c('journal','volume'), base=url)
#' 
#' # Get raw data, then parse later if you feel like it
#' ## json
#' out <- solr_stats(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), 
#'    stats.facet=c('journal','volume'), base=url, raw=TRUE)
#' library(rjson)
#' fromJSON(out)
#' solr_parse(out) # list
#' solr_parse(out, 'df') # data.frame
#' 
#' ## xml
#' out <- solr_stats(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), 
#'    stats.facet=c('journal','volume'), base=url, raw=TRUE, wt="xml")
#' library(XML)
#' xmlParse(out)
#' solr_parse(out) # list
#' solr_parse(out, 'df') # data.frame
#' 
#' # Get verbose http call information
#' library(httr)
#' solr_stats(q='ecology', stats.field='alm_twitterCount', base=url, 
#'    callopts=verbose())
#' }

solr_stats <- function(q='*:*', stats.field=NULL, stats.facet=NULL, wt='json', start=0,
  rows=0, key = NULL, base = NULL, callopts=list(), raw=FALSE, parsetype='df', verbose=TRUE)
{
  if(is.null(base)){
    stop("You must provide a url, e.g., http://api.plos.org/search or http://localhost:8983/solr/select")
  }
  
  todonames <- c("q", "stats.field", "stats.facet", "start", "rows", "key", "wt")
  args <- collectargs(todonames)
  args$stats <- 'true'
  
  tt <- GET(base, query = args, callopts)
  if(verbose) message(URLdecode(tt$url))
  stop_for_status(tt)
  out <- content(tt, as="text")
  class(out) <- "sr_stats"
  attr(out, "wt") <- wt
  if(raw){ return( out ) } else { solr_parse(out, parsetype) }
}