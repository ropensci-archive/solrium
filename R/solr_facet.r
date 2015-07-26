#' Do faceted searches, outputing facets only.
#'
#' @template facet
#' @return Raw json or xml, or a list of length 4 parsed elements (usually data.frame's).
#' @seealso \code{\link{solr_search}}, \code{\link{solr_highlight}}, \code{\link{solr_parse}}
#' @references See \url{http://wiki.apache.org/solr/SimpleFacetParameters} for
#' more information on faceting.
#' @export
#' @examples \dontrun{
#' conn <- solr_connect('http://api.plos.org/search')
#'
#' # Facet on a single field
#' solr_facet(conn, q='*:*', facet.field='journal')
#'
#' # Facet on multiple fields
#' solr_facet(conn, q='alcohol', facet.field=c('journal','subject'), base=url)
#'
#' # Using mincount
#' solr_facet(conn, q='alcohol', facet.field='journal', facet.mincount='500', base=url)
#'
#' # Using facet.query to get counts
#' solr_facet(conn, q='*:*', facet.field='journal', facet.query=c('cell','bird'), base=url)
#'
#' # Date faceting
#' solr_facet(conn, q='*:*', base=url, facet.date='publication_date',
#' facet.date.start='NOW/DAY-5DAYS', facet.date.end='NOW', facet.date.gap='+1DAY')
#'
#' # Range faceting
#' solr_facet(conn, q='*:*', base=url, facet.range='counter_total_all',
#' facet.range.start=5, facet.range.end=1000, facet.range.gap=10)
#'
#' # Range faceting with > 1 field, same settings
#' solr_facet(conn, q='*:*', base=url, facet.range=c('counter_total_all','alm_twitterCount'),
#' facet.range.start=5, facet.range.end=1000, facet.range.gap=10)
#'
#' # Range faceting with > 1 field, different settings
#' solr_facet(conn, q='*:*', base=url, facet.range=c('counter_total_all','alm_twitterCount'),
#' f.counter_total_all.facet.range.start=5, f.counter_total_all.facet.range.end=1000,
#' f.counter_total_all.facet.range.gap=10, f.alm_twitterCount.facet.range.start=5,
#' f.alm_twitterCount.facet.range.end=1000, f.alm_twitterCount.facet.range.gap=10)
#'
#' # Get raw json or xml
#' ## json
#' solr_facet(conn, q='*:*', facet.field='journal', base=url, raw=TRUE)
#' ## xml
#' solr_facet(conn, q='*:*', facet.field='journal', base=url, raw=TRUE, wt='xml')
#'
#' # Get raw data back, and parse later, same as what goes on internally if
#' # raw=FALSE (Default)
#' out <- solr_facet(conn, q='*:*', facet.field='journal', base=url, raw=TRUE)
#' solr_parse(out)
#' out <- solr_facet(conn, q='*:*', facet.field='journal', base=url, raw=TRUE,
#'    wt='xml')
#' solr_parse(out)
#'
#' # Using the USGS BISON API (http://bison.usgs.ornl.gov/services.html#solr)
#' ## The occurrence endpoint
#' conn <- solr_connect("http://bison.usgs.ornl.gov/solrstaging/occurrences/select")
#' solr_facet(conn, q='*:*', facet.field='year')
#' solr_facet(conn, q='*:*', facet.field='state_code')
#' solr_facet(conn, q='*:*', facet.field='basis_of_record')
#' 
#' # using a proxy
#' prox <- list(url = "186.249.1.146", port = 80)
#' conn <- solr_connect(url = 'http://api.plos.org/search', proxy = prox)
#' solr_facet(conn, facet.field='journal', callopts=verbose())
#' }

solr_facet <- function(conn, q="*:*", facet.query=NA, facet.field=NA,
   facet.prefix = NA,facet.sort = NA,facet.limit = NA,facet.offset = NA,
   facet.mincount = NA,facet.missing = NA,facet.method = NA,facet.enum.cache.minDf = NA,
   facet.threads = NA,facet.date = NA,facet.date.start = NA,facet.date.end = NA,
   facet.date.gap = NA,facet.date.hardend = NA,facet.date.other = NA,
   facet.date.include = NA,facet.range = NA,facet.range.start = NA,facet.range.end = NA,
   facet.range.gap = NA,facet.range.hardend = NA,facet.range.other = NA,
   facet.range.include = NA, start=NA, rows=NA, key=NA, wt='json',
   raw=FALSE, callopts=list(), verbose=TRUE, ...) {
  
  check_conn(conn)
  todonames <- c("q",  "facet.query",  "facet.field",
     "facet.prefix", "facet.sort", "facet.limit", "facet.offset",
     "facet.mincount", "facet.missing", "facet.method", "facet.enum.cache.minDf",
     "facet.threads", "facet.date", "facet.date.start", "facet.date.end",
     "facet.date.gap", "facet.date.hardend", "facet.date.other",
     "facet.date.include", "facet.range", "facet.range.start", "facet.range.end",
     "facet.range.gap", "facet.range.hardend", "facet.range.other",
     "facet.range.include",  "start",  "rows",  "key", "wt")
  args <- collectargs(todonames)
  args$fl <- 'DOES_NOT_EXIST'
  args$facet <- 'true'

  # additional parameters
  args <- c(args, list(...))

  out <- structure(solr_GET(conn$url, args, callopts, verbose, conn$proxy), class="sr_facet", wt=wt)
  if (raw){ return( out ) } else { solr_parse(out) }
}
