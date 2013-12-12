\name{solr_facet}
\alias{solr_facet}
\title{Do faceted searches, outputing facets only.}
\usage{
solr_facet(q = "*:*", facet.query = NA, facet.field = NA,
  facet.prefix = NA, facet.sort = NA, facet.limit = NA,
  facet.offset = NA, facet.mincount = NA, facet.missing = NA,
  facet.method = NA, facet.enum.cache.minDf = NA, facet.threads = NA,
  facet.date = NA, facet.date.start = NA, facet.date.end = NA,
  facet.date.gap = NA, facet.date.hardend = NA, facet.date.other = NA,
  facet.date.include = NA, facet.range = NA, facet.range.start = NA,
  facet.range.end = NA, facet.range.gap = NA, facet.range.hardend = NA,
  facet.range.other = NA, facet.range.include = NA, start = NA,
  rows = NA, key = NA, url = NA, wt = "json", raw = FALSE,
  callopts = list(), ...)
}
\arguments{
  \item{facet}{XXXX}

  \item{facet.query}{XXXX}

  \item{facet.field}{XXXX}

  \item{facet.prefix}{XXXX}

  \item{facet.sort}{XXXX}

  \item{facet.limit}{XXXX}

  \item{facet.offset}{XXXX}

  \item{facet.mincount}{XXXX}

  \item{facet.missing}{XXXX}

  \item{facet.method}{XXXX}

  \item{facet.enum.cache.minDf}{XXXX}

  \item{facet.threads}{XXXX}

  \item{facet.date}{XXXX}

  \item{facet.date.start}{XXXX}

  \item{facet.date.end}{XXXX}

  \item{facet.date.gap}{XXXX}

  \item{facet.date.hardend}{XXXX}

  \item{facet.date.other}{XXXX}

  \item{facet.date.include}{XXXX}

  \item{facet.range}{XXXX}

  \item{facet.range.start}{XXXX}

  \item{facet.range.end}{XXXX}

  \item{facet.range.gap}{XXXX}

  \item{facet.range.hardend}{XXXX}

  \item{facet.range.other}{XXXX}

  \item{facet.range.include}{XXXX}

  \item{q}{Query terms}

  \item{start}{Record to start at, default to beginning.}

  \item{rows}{Number of records to return.}

  \item{key}{API key, if needed.}

  \item{url}{URL endpoint}

  \item{wt}{(character) Data format to return. One of xml
  or json (default).}

  \item{raw}{(logical) If TRUE (default) raw json or xml
  returned. If FALSE, parsed data returned.}

  \item{callopts}{Call options passed on to httr::GET}

  \item{...}{Further args.}
}
\value{
Raw json or xml, or a list of length 4 parsed elements
(usually data.frame's).
}
\description{
Do faceted searches, outputing facets only.
}
\details{
A number of fields can be specified multiple times, in
which case you can separate them by commas, like
\code{facet.field='journal,subject'}. Those fields are:
\itemize{ \item facet.field \item facet.query \item
facet.date \item facet.date.other \item facet.date.include
\item facet.range \item facet.range.other \item
facet.range.include }
}
\examples{
\dontrun{
url <- 'http://api.plos.org/search'; key = getOption('PlosApiKey')

# Facet on a single field
solr_facet(q='*:*', facet.field='journal', url=url, key=key)

# Facet on multiple fields
solr_facet(q='alcohol', facet.field='journal,subject', url=url, key=key)

# Using mincount
solr_facet(q='alcohol', facet.field='journal', facet.mincount='500', url=url, key=key)

# Using facet.query to get counts
solr_facet(q='*:*', facet.field='journal', facet.query='cell,bird', url=url, key=key)

# Date faceting
solr_facet(q='*:*', url=url, facet.date='publication_date',
facet.date.start='NOW/DAY-5DAYS', facet.date.end='NOW', facet.date.gap='+1DAY', key=key)

# Range faceting
solr_facet(q='*:*', url=url, facet.range='counter_total_all',
facet.range.start=5, facet.range.end=1000, facet.range.gap=10, key=key)

# Range faceting with > 1 field, same settings
solr_facet(q='*:*', url=url, facet.range='counter_total_all,alm_twitterCount',
facet.range.start=5, facet.range.end=1000, facet.range.gap=10, key=key)

# Range faceting with > 1 field, different settings
solr_facet(q='*:*', url=url, facet.range='counter_total_all,alm_twitterCount',
f.counter_total_all.facet.range.start=5, f.counter_total_all.facet.range.end=1000,
f.counter_total_all.facet.range.gap=10, f.alm_twitterCount.facet.range.start=5, f.alm_twitterCount.facet.range.end=1000,
f.alm_twitterCount.facet.range.gap=10, key=key)

# Get raw json or xml
solr_facet(q='*:*', facet.field='journal', url=url, key=key, raw=TRUE) # json
solr_facet(q='*:*', facet.field='journal', url=url, key=key, raw=TRUE, wt='xml') # xml

# Get raw data back, and parse later, same as what goes on internally if raw=FALSE (Default)
out <- solr_facet(q='*:*', facet.field='journal', url=url, key=key, raw=TRUE)
solr_parse(out)
out <- solr_facet(q='*:*', facet.field='journal', url=url, key=key, raw=TRUE, wt='xml')
solr_parse(out)
}
}
\references{
See \url{http://wiki.apache.org/solr/SimpleFacetParameters}
for more information on faceting.
}
\seealso{
\code{\link{solr_search}}, \code{\link{solr_highlight}},
\code{\link{solr_parse}}
}

