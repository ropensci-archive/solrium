\name{solr_group}
\alias{solr_group}
\title{Solr grouped search.}
\usage{
solr_group(q = "*:*", start = 0, rows = NA, sort = NA, fq = NA,
  fl = NA, wt = "json", key = NA, group.field = NA, group.limit = NA,
  group.offset = NA, group.sort = NA, group.main = NA,
  group.ngroups = NA, group.truncate = NA, group.facet = NA,
  group.cache.percent = NA, group.query = NA, group.format = NA,
  group.func = NA, url = NA, callopts = list(), raw = FALSE,
  parsetype = "df", concat = ",", ...)
}
\arguments{
  \item{q}{Query terms, defaults to '*:*', or everything.}

  \item{fq}{Filter query, this does not affect the search,
  only what gets returned}

  \item{fl}{Fields to return}

  \item{url}{URL endpoint.}

  \item{wt}{Data type returned, defaults to 'json'}

  \item{key}{API key, if needed.}

  \item{group.field}{[fieldname] Group based on the unique
  values of a field. The field must currently be
  single-valued and must be either indexed, or be another
  field type that has a value source and works in a
  function query - such as ExternalFileField. Note: for
  Solr 3.x versions the field must by a string like field
  such as StrField or TextField, otherwise a http status
  400 is returned.}

  \item{group.func}{[function query] Group based on the
  unique values of a function query. <!> Solr4.0 This
  parameter only is supported on 4.0}

  \item{group.query}{[query] Return a single group of
  documents that also match the given query.}

  \item{rows}{[number] The number of groups to return.
  Defaults to 10.}

  \item{start}{[number] The offset into the list of
  groups.}

  \item{group.limit}{[number] The number of results
  (documents) to return for each group. Defaults to 1.}

  \item{group.offset}{[number] The offset into the document
  list of each group.}

  \item{sort}{[sortspec] How to sort the groups relative to
  each other. For example, sort=popularity desc will cause
  the groups to be sorted according to the highest
  popularity doc in each group. Defaults to "score desc".}

  \item{group.sort}{[sortspec] How to sort documents within
  a single group. Defaults to the same value as the sort
  parameter.}

  \item{group.format}{One of grouped or simple. If simple,
  the grouped documents are presented in a single flat
  list. The start and rows parameters refer to numbers of
  documents instead of numbers of groups.}

  \item{group.main}{(logical) If true, the result of the
  last field grouping command is used as the main result
  list in the response, using group.format=simple}

  \item{group.ngroups}{(logical) If true, includes the
  number of groups that have matched the query. Default is
  false. <!> Solr4.1 WARNING: If this parameter is set to
  true on a sharded environment, all the documents that
  belong to the same group have to be located in the same
  shard, otherwise the count will be incorrect. If you are
  using SolrCloud, consider using "custom hashing"}

  \item{group.truncate}{(logical) If true, facet counts are
  based on the most relevant document of each group
  matching the query. Same applies for StatsComponent.
  Default is false. <!> Solr3.4 Supported from Solr 3.4 and
  up.}

  \item{group.facet}{(logical) Ihether to compute grouped
  facets for the field facets specified in facet.field
  parameters. Grouped facets are computed based on the
  first specified group. Just like normal field faceting,
  fields shouldn't be tokenized (otherwise counts are
  computed for each token). Grouped faceting supports
  single and multivalued fields. Default is false. <!>
  Solr4.0 WARNING: If this parameter is set to true on a
  sharded environment, all the documents that belong to the
  same group have to be located in the same shard,
  otherwise the count will be incorrect. If you are using
  SolrCloud, consider using "custom hashing"}

  \item{group.cache.percent}{[0-100] If > 0 enables
  grouping cache. Grouping is executed actual two searches.
  This option caches the second search. A value of 0
  disables grouping caching. Default is 0. Tests have shown
  that this cache only improves search time with boolean
  queries, wildcard queries and fuzzy queries. For simple
  queries like a term query or a match all query this cache
  has a negative impact on performance}

  \item{callopts}{Call options passed on to httr::GET}

  \item{raw}{(logical) If TRUE, returns raw data in format
  specified by wt param}

  \item{parsetype}{(character) One of 'list' or 'df'}

  \item{concat}{(character) Character to concatenate
  elements of longer than length 1. Note that this only
  works reliably when data format is json (wt='json'). The
  parsing is more complicated in XML format, but you can do
  that on your own.}

  \item{...}{Further args.}
}
\value{
XML, JSON, a list, or data.frame
}
\description{
Solr grouped search.
}
\examples{
\dontrun{
url <- 'http://api.plos.org/search'; key = getOption('PlosApiKey')

# Basic group query
solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score', url=url, key=key)
solr_group(q='ecology', group.field='journal', group.limit=3, fl='article_type', url=url, key=key)

# Different ways to sort (notice diff btw sort of group.sort)
solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score', url=url, key=key)
solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score,alm_twitterCount',
   group.sort='alm_twitterCount desc', url=url, key=key)
solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score,alm_twitterCount',
   sort='score', group.sort='alm_twitterCount desc', url=url, key=key)

# Two group.field values
out <- solr_group(q='ecology', group.field='journal,article_type', group.limit=3, fl='id', url=url, key=key, raw=TRUE)
solr_parse(out)
solr_parse(out, 'df')

# Get two groups, one with alm_twitterCount of 0-10, and another group with 10 to infinity
solr_group(q='ecology', group.limit=3, fl='id,alm_twitterCount',
 group.query='alm_twitterCount:[0 TO 10],alm_twitterCount:[10 TO *]',
 url=url, key=key)

# Use of group.format and group.simple.
## The raw data structure of these two calls are slightly different, but
## the parsing inside the function outputs the same results. You can of course
## set raw=TRUE to get back what the data actually look like
solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score',
   group.format='simple', url=url, key=key)
solr_group(q='ecology', group.field='journal', group.limit=3, fl='id,score',
   group.format='simple', group.main='true', url=url, key=key)
}
}
\references{
See \url{http://wiki.apache.org/solr/FieldCollapsing} for
more information.
}
\seealso{
\code{\link{solr_highlight}}, \code{\link{solr_facet}}
}

