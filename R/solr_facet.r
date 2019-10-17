#' @title Faceted search
#'
#' @description Returns only facet items
#'
#' @export
#' @template facet
#' @param conn A solrium connection object, see [SolrClient]
#' @param params (list) a named list of parameters, results in a GET request
#' as long as no body parameters given
#' @param body (list) a named list of parameters, if given a POST request
#' will be performed
#' @return Raw json or xml, or a list of length 4 parsed elements
#' (usually data.frame's).
#' @seealso [solr_search()], [solr_highlight()], [solr_parse()]
#' @references See https://lucene.apache.org/solr/guide/8_2/faceting.html for
#' more information on faceting.
#' @examples \dontrun{
#' # connect - local Solr instance
#' (cli <- SolrClient$new())
#' cli$facet("gettingstarted", params = list(q="*:*", facet.field='name'))
#' cli$facet("gettingstarted", params = list(q="*:*", facet.field='name'),
#'   callopts = list(verbose = TRUE))
#' cli$facet("gettingstarted", body = list(q="*:*", facet.field='name'),
#'   callopts = list(verbose = TRUE))
#'
#' # Facet on a single field
#' solr_facet(cli, "gettingstarted", params = list(q='*:*', facet.field='name'))
#'
#' # Remote instance
#' (cli <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL))
#'
#' # Facet on multiple fields
#' solr_facet(cli, params = list(q='alcohol',
#'   facet.field = c('journal','subject')))
#'
#' # Using mincount
#' solr_facet(cli, params = list(q='alcohol', facet.field='journal',
#'   facet.mincount='500'))
#'
#' # Using facet.query to get counts
#' solr_facet(cli, params = list(q='*:*', facet.field='journal',
#'   facet.query=c('cell','bird')))
#'
#' # Using facet.pivot to simulate SQL group by counts
#' solr_facet(cli, params = list(q='alcohol', facet.pivot='journal,subject',
#'              facet.pivot.mincount=10))
#' ## two or more fields are required - you can pass in as a single
#' ## character string
#' solr_facet(cli, params = list(q='*:*', facet.pivot = "journal,subject",
#'   facet.limit =  3))
#' ## Or, pass in as a vector of length 2 or greater
#' solr_facet(cli, params = list(q='*:*', facet.pivot = c("journal", "subject"),
#'   facet.limit =  3))
#'
#' # Date faceting
#' solr_facet(cli, params = list(q='*:*', facet.date='publication_date',
#'   facet.date.start='NOW/DAY-5DAYS', facet.date.end='NOW',
#'   facet.date.gap='+1DAY'))
#' ## two variables
#' solr_facet(cli, params = list(q='*:*',
#'   facet.date=c('publication_date', 'timestamp'),
#'   facet.date.start='NOW/DAY-5DAYS', facet.date.end='NOW',
#'   facet.date.gap='+1DAY'))
#'
#' # Range faceting
#' solr_facet(cli, params = list(q='*:*', facet.range='counter_total_all',
#'   facet.range.start=5, facet.range.end=1000, facet.range.gap=10))
#'
#' # Range faceting with > 1 field, same settings
#' solr_facet(cli, params = list(q='*:*',
#'   facet.range=c('counter_total_all','alm_twitterCount'),
#'   facet.range.start=5, facet.range.end=1000, facet.range.gap=10))
#'
#' # Range faceting with > 1 field, different settings
#' solr_facet(cli, params = list(q='*:*',
#'   facet.range=c('counter_total_all','alm_twitterCount'),
#'   f.counter_total_all.facet.range.start=5,
#'   f.counter_total_all.facet.range.end=1000,
#'   f.counter_total_all.facet.range.gap=10,
#'   f.alm_twitterCount.facet.range.start=5,
#'   f.alm_twitterCount.facet.range.end=1000,
#'   f.alm_twitterCount.facet.range.gap=10))
#'
#' # Get raw json or xml
#' ## json
#' solr_facet(cli, params = list(q='*:*', facet.field='journal'), raw=TRUE)
#' ## xml
#' solr_facet(cli, params = list(q='*:*', facet.field='journal', wt='xml'),
#'   raw=TRUE)
#'
#' # Get raw data back, and parse later, same as what goes on internally if
#' # raw=FALSE (Default)
#' out <- solr_facet(cli, params = list(q='*:*', facet.field='journal'),
#'   raw=TRUE)
#' solr_parse(out)
#' out <- solr_facet(cli, params = list(q='*:*', facet.field='journal',
#'   wt = 'xml'), raw=TRUE)
#' solr_parse(out)
#'
#' # Using the USGS BISON API (https://bison.usgs.gov/#solr)
#' ## The occurrence endpoint
#' (cli <- SolrClient$new(host = "bison.usgs.gov", scheme = "https",
#'   path = "solr/occurrences/select", port = NULL))
#' solr_facet(cli, params = list(q='*:*', facet.field='year'))
#' solr_facet(cli, params = list(q='*:*', facet.field='computedStateFips'))
#'
#' # using a proxy
#' # cli <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL,
#' #   proxy = list(url = "http://54.195.48.153:8888"))
#' # solr_facet(cli, params = list(facet.field='journal'),
#' #   callopts=list(verbose=TRUE))
#' }
solr_facet <- function(conn, name = NULL, params = list(q = '*:*'),
  body = NULL, callopts = list(), raw = FALSE,  parsetype = 'df',
  concat = ',', progress = NULL, ...) {

  conn$facet(name = name, params = params, body = body, callopts = callopts,
             raw = raw, parsetype = parsetype, concat = concat, 
             progress = progress, ...)
}
