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
#' url <- 'http://api.plos.org/search'; key = getOption('PlosApiKey')
#' solr_stats(q='science', stats.field='counter_total_all', url=url, key=key, raw=TRUE)
#' solr_stats(q='title:"ecology" AND body:"cell"', 
#'    stats.field='counter_total_all,alm_twitterCount', url=url, key=key)
#' solr_stats(q='ecology', stats.field='counter_total_all,alm_twitterCount', 
#'    stats.facet='journal', url=url, key=key)
#' solr_stats(q='ecology', stats.field='counter_total_all,alm_twitterCount', 
#'    stats.facet='journal,volume', url=url, key=key)
#' 
#' # Get raw data, then parse later if you feel like it
#' ## json
#' out <- solr_stats(q='ecology', stats.field='counter_total_all,alm_twitterCount', 
#'    stats.facet='journal,volume', url=url, key=key, raw=TRUE)
#' library(rjson)
#' fromJSON(out)
#' solr_parse(out) # list
#' solr_parse(out, 'df') # data.frame
#' 
#' ## xml
#' out <- solr_stats(q='ecology', stats.field='counter_total_all,alm_twitterCount', 
#'    stats.facet='journal,volume', url=url, key=key, raw=TRUE, wt="xml")
#' library(XML)
#' xmlParse(out)
#' solr_parse(out) # list
#' solr_parse(out, 'df') # data.frame
#' 
#' # Get verbose http call information
#' library(httr)
#' solr_stats(q='ecology', stats.field='alm_twitterCount', url=url, key=key, 
#'    callopts=verbose())
#' }

solr_stats <- function(q='*:*', stats.field=NULL, stats.facet=NULL, wt='json', start=0,
  rows=0, key = NULL, url = NULL, callopts=list(), raw=FALSE, parsetype='df')
{
  makemultiargs <- function(x){
    value <- eval(parse(text=x))
    if(is.null(value)){ NULL } else {
      if(is.na(value)){ NULL } else {
        if(!is.character(value)){ 
          value <- as.character(value)
        } 
        y <- strsplit(value,",")[[1]]
        names(y) <- rep(x, length(y))
        y
      }
    }
  }
  todonames <- c("q", "stats.field", "stats.facet", "start", "rows", "key", "wt")
  outlist <- list()
  for(i in seq_along(todonames)){
    outlist[[i]] <- makemultiargs(todonames[[i]])
  }
  args <- as.list(unlist(compact(outlist)))
  args$stats <- 'true'
  
  tt <- GET(url, query = args, callopts)
  stop_for_status(tt)
  out <- content(tt, as="text")
  class(out) <- "sr_stats"
  attr(out, "wt") <- wt
  if(raw){ return( out ) } else { solr_parse(out, parsetype) }
}