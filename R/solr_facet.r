#' Do faceted searches, outputing facets only.
#' 
#' @import httr XML
#' @importFrom plyr compact
#' @template facet
#' @return A list.
#' @details 
#' A number of fields can be specified multiple times, in which case you can separate
#' them by commas, like \code{facet.field='journal,subject'}. Those fields are:
#' \itemize{
#'  \item facet.field
#'  \item facet.query
#'  \item facet.date
#'  \item facet.date.other
#'  \item facet.date.include
#'  \item facet.range
#'  \item facet.range.other
#'  \item facet.range.include
#' }
#' @seealso \code{\link{solr_search}}, \code{\link{solr_highlight}}
#' @references See \url{http://wiki.apache.org/solr/SimpleFacetParameters} for 
#' more information on faceting.
#' @examples \dontrun{
#' url <- 'http://api.plos.org/search'
#' key = getOption('PlosApiKey')
#' 
#' # Facet on a single field
#' solr_facet(q='*:*', facet.field='journal', url=url, key=key)
#' 
#' # Facet on multiple fields
#' solr_facet(q='alcohol', facet.field='journal,subject', url=url, key=key)
#' 
#' # Using mincount
#' solr_facet(q='alcohol', facet.field='journal', facet.mincount='500', url=url, key=key)
#' 
#' # Using facet.query to get counts
#' solr_facet(q='*:*', facet.field='journal', facet.query='cell,bird', url=url, key=key)
#' 
#' # Date faceting
#' solr_facet(q='*:*', url=url, facet.date='publication_date', 
#' facet.date.start='NOW/DAY-5DAYS', facet.date.end='NOW', facet.date.gap='+1DAY', key=key)
#' 
#' # Range faceting
#' solr_facet(q='*:*', url=url, facet.range='counter_total_all', 
#' facet.range.start=5, facet.range.end=1000, facet.range.gap=10, key=key)
#' 
#' # Range faceting with > 1 field, same settings
#' solr_facet(q='*:*', url=url, facet.range='counter_total_all,alm_twitterCount', 
#' facet.range.start=5, facet.range.end=1000, facet.range.gap=10, key=key)
#' 
#' # Range faceting with > 1 field, different settings
#' solr_facet(q='*:*', url=url, facet.range='counter_total_all,alm_twitterCount', 
#' f.counter_total_all.facet.range.start=5, f.counter_total_all.facet.range.end=1000, 
#' f.counter_total_all.facet.range.gap=10, f.alm_twitterCount.facet.range.start=5, f.alm_twitterCount.facet.range.end=1000, 
#' f.alm_twitterCount.facet.range.gap=10, key=key)
#' }
#' @export

solr_facet <- function(q="*:*", facet.query=NA, facet.field=NA,
   facet.prefix = NA,facet.sort = NA,facet.limit = NA,facet.offset = NA,
   facet.mincount = NA,facet.missing = NA,facet.method = NA,facet.enum.cache.minDf = NA,
   facet.threads = NA,facet.date = NA,facet.date.start = NA,facet.date.end = NA,
   facet.date.gap = NA,facet.date.hardend = NA,facet.date.other = NA,
   facet.date.include = NA,facet.range = NA,facet.range.start = NA,facet.range.end = NA,
   facet.range.gap = NA,facet.range.hardend = NA,facet.range.other = NA,
   facet.range.include = NA, start=NA, rows=NA, key=NA, url=NA, callopts=list(), ...)
{
  makemultiargs <- function(x){
    value <- eval(parse(text=x))
    if(is.na(value)){ NULL } else {
      if(!is.character(value)){ 
        value <- as.character(value)
      } 
      y <- strsplit(value,",")[[1]]
      names(y) <- rep(x, length(y))
      y
    }
  }
  todonames <- c("q",  "facet.query",  "facet.field", 
                 "facet.prefix", "facet.sort", "facet.limit", "facet.offset", 
                 "facet.mincount", "facet.missing", "facet.method", "facet.enum.cache.minDf", 
                 "facet.threads", "facet.date", "facet.date.start", "facet.date.end", 
                 "facet.date.gap", "facet.date.hardend", "facet.date.other", 
                 "facet.date.include", "facet.range", "facet.range.start", "facet.range.end", 
                 "facet.range.gap", "facet.range.hardend", "facet.range.other", 
                 "facet.range.include",  "start",  "rows",  "key")
  
  outlist <- list()
  for(i in seq_along(todonames)){
    outlist[[i]] <- makemultiargs(todonames[[i]])
  }
  args <- as.list(unlist(compact(outlist)))
  args$fl <- 'DOES_NOT_EXIST'
  args$facet <- 'true'
  args$wt <- 'json'
  
  # additional parameters
  args <- c(args, list(...))

  # API call
  tt <- GET(url, query=args, callopts)
  stop_for_status(tt)
  out <- content(tt)
  
  # Facet queries
#   fqout <- out$facet_counts$facet_queries
  fqdat <- out$facet_counts$facet_queries
  fqout <- data.frame(term=names(fqdat), value=do.call(c, fqdat), stringsAsFactors=FALSE)
  row.names(fqout) <- NULL
  
  # Facet fields
  dflist <- lapply(out$facet_counts$facet_fields, function(x){
    data.frame(do.call(rbind, lapply(seq(1, length(x), by=2), function(y){
      x[c(y, y+1)]
    })), stringsAsFactors=FALSE)
  })
  
  # Facet dates
#   datesout <- out$facet_counts$facet_dates
  datesout <- lapply(out$facet_counts$facet_dates, function(x){
    x <- x[!names(x) %in% c('gap','start','end')]
    x <- data.frame(date=names(x), value=do.call(c, x), stringsAsFactors=FALSE)
    row.names(x) <- NULL
    x
  })
  
  # Facet ranges
#   rangesout <- out$facet_counts$facet_ranges
  rangesout <- lapply(out$facet_counts$facet_ranges, function(x){
    x <- x[!names(x) %in% c('gap','start','end')]$counts
    data.frame(do.call(rbind, lapply(seq(1, length(x), by=2), function(y){
      x[c(y, y+1)]
    })), stringsAsFactors=FALSE)
  })
  
  # output
  return( list(facet_queries = replacelen0(fqout), 
               facet_fields = replacelen0(dflist), 
               facet_dates = replacelen0(datesout), 
               facet_ranges = replacelen0(rangesout)) )
}

replacelen0 <- function(x) if(length(x) < 1){ NULL } else { x }