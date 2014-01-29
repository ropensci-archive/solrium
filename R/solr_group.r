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
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score', url=url)
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl='article_type', url=url)
#' 
#' # Different ways to sort (notice diff btw sort of group.sort)
#' # note that you can only sort on a field if you return that field
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score', url=url)
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score,alm_twitterCount', 
#'    group.sort='alm_twitterCount desc', url=url)
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score,alm_twitterCount', 
#'    sort='score asc', group.sort='alm_twitterCount desc', url=url)
#' 
#' # Two group.field values
#' out <- solr_group(q='ecology', group.field='journal,article_type', group.limit=3, fl='id', url=url, raw=TRUE)
#' solr_parse(out)
#' solr_parse(out, 'df')
#' 
#' # Get two groups, one with alm_twitterCount of 0-10, and another group with 10 to infinity
#' solr_group(q='ecology', group.limit=3, fl='id,alm_twitterCount', 
#'  group.query='alm_twitterCount:[0 TO 10],alm_twitterCount:[10 TO *]', 
#'  url=url)
#'  
#' # Use of group.format and group.simple. 
#' ## The raw data structure of these two calls are slightly different, but 
#' ## the parsing inside the function outputs the same results. You can of course
#' ## set raw=TRUE to get back what the data actually look like
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score', 
#'    group.format='simple', url=url)
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score', 
#'    group.format='grouped', url=url)
#' solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score', 
#'    group.format='grouped', group.main='true', url=url)
#' }

solr_group <- function(q='*:*', start=0, rows = NA, sort = NA, fq = NA, fl = NA,
  wt='json', key = NA, group.field = NA, group.limit = NA, group.offset = NA, 
  group.sort = NA, group.main = NA, group.ngroups = NA, 
  group.cache.percent = NA, group.query = NA, group.format = NA,
  group.func = NA, url = NA, callopts=list(), raw=FALSE, parsetype='df', 
  concat=',', verbose=TRUE, ...)
{
  if(is.na(url)){
    stop("You must provide a url, e.g., http://api.plos.org/search or http://localhost:8983/solr/select")
  }
    
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
  todonames <- c("group.query","group.field", 'q', 'start', 'rows', 'sort', 'fq', 'wt', 
                 'group.limit', 'group.offset', 'group.sort', 'group.sort', 
                 'group.format', 'group.func', 'group.main', 'group.ngroups', 
                 'group.cache.percent', 'group.cache.percent')
  outlist <- list()
  for(i in seq_along(todonames)){
    outlist[[i]] <- makemultiargs(todonames[[i]])
  }
  args <- as.list(unlist(compact(outlist)))
  args$group <- 'true'
  if(!is.na(fl))
    args$fl <- fl
 
  # additional parameters
  args <- c(args, list(...))
  
  tt <- GET(url, query = args, callopts)
  if(verbose) message(URLdecode(tt$url))
  stop_for_status(tt)
  out <- content(tt, as="text")
  class(out) <- "sr_group"
  attr(out, "wt") <- wt
  if(raw){ return( out ) } else { solr_parse(out, parsetype, concat) }
}