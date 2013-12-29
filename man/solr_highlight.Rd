\name{solr_highlight}
\alias{solr_highlight}
\title{Do highlighting searches, outputing highlight only.}
\usage{
solr_highlight(q, hl.fl = NULL, hl.snippets = NULL, hl.fragsize = NULL,
  hl.q = NULL, hl.mergeContiguous = NULL, hl.requireFieldMatch = NULL,
  hl.maxAnalyzedChars = NULL, hl.alternateField = NULL,
  hl.maxAlternateFieldLength = NULL, hl.preserveMulti = NULL,
  hl.maxMultiValuedToExamine = NULL, hl.maxMultiValuedToMatch = NULL,
  hl.formatter = NULL, hl.simple.pre = NULL, hl.simple.post = NULL,
  hl.fragmenter = NULL, hl.fragListBuilder = NULL,
  hl.fragmentsBuilder = NULL, hl.boundaryScanner = NULL,
  hl.bs.maxScan = NULL, hl.bs.chars = NULL, hl.bs.type = NULL,
  hl.bs.language = NULL, hl.bs.country = NULL,
  hl.useFastVectorHighlighter = NULL, hl.usePhraseHighlighter = NULL,
  hl.highlightMultiTerm = NULL, hl.regex.slop = NULL,
  hl.regex.pattern = NULL, hl.regex.maxAnalyzedChars = NULL, start = 0,
  rows = NULL, wt = "json", raw = FALSE, key = NULL, url = NULL,
  callopts = list(), fl = "DOES_NOT_EXIST", fq = NULL,
  parsetype = "list")
}
\arguments{
  \item{q}{Query terms, defaults to '*:*', or everything.}

  \item{mlt.count}{The number of similar documents to
  return for each result. Default is 5.}

  \item{mlt.fl}{The fields to use for similarity. NOTE: if
  possible these should have a stored TermVector
  DEFAULT_FIELD_NAMES = new String[] {"contents"}}

  \item{mlt.mintf}{Minimum Term Frequency - the frequency
  below which terms will be ignored in the source doc.
  DEFAULT_MIN_TERM_FREQ = 2}

  \item{mlt.mindf}{Minimum Document Frequency - the
  frequency at which words will be ignored which do not
  occur in at least this many docs. DEFAULT_MIN_DOC_FREQ =
  5}

  \item{mlt.minwl}{minimum word length below which words
  will be ignored. DEFAULT_MIN_WORD_LENGTH = 0}

  \item{mlt.maxwl}{maximum word length above which words
  will be ignored. DEFAULT_MAX_WORD_LENGTH = 0}

  \item{mlt.maxqt}{maximum number of query terms that will
  be included in any generated query.
  DEFAULT_MAX_QUERY_TERMS = 25}

  \item{mlt.maxntp}{maximum number of tokens to parse in
  each example doc field that is not stored with TermVector
  support. DEFAULT_MAX_NUM_TOKENS_PARSED = 5000}

  \item{mlt.boost}{[true/false] set if the query will be
  boosted by the interesting term relevance. DEFAULT_BOOST
  = false}

  \item{mlt.qf}{Query fields and their boosts using the
  same format as that used in DisMaxQParserPlugin. These
  fields must also be specified in mlt.fl.}

  \item{fq}{Filter query, this does not affect the search,
  only what gets returned}

  \item{fl}{Fields to return. We force 'id' to be returned
  so that there is a unique identifier with each record.}

  \item{concat}{(character) Character to concatenate
  elements of longer than length 1. Note that this only
  works reliably when data format is json (wt='json'). The
  parsing is more complicated in XML format, but you can do
  that on your own.}

  \item{url}{URL endpoint.}

  \item{key}{API key, if needed.}

  \item{callopts}{Call options passed on to httr::GET}

  \item{raw}{(logical) If TRUE, returns raw data in format
  specified by wt param}

  \item{parsetype}{(character) One of 'list' or 'df'}

  \item{start}{Record to start at, default to beginning.}

  \item{rows}{Number of records to return. Defaults to 10.}

  \item{wt}{Data type returned, defaults to 'json'}
}
\value{
XML, JSON, a list, or data.frame
}
\description{
Do highlighting searches, outputing highlight only.
}
\examples{
\dontrun{
url <- 'http://api.plos.org/search'; key = getOption('PlosApiKey')

solr_highlight(q='alcohol', hl.fl = 'abstract', rows=10, url = url, key=key)
solr_highlight(q='alcohol', hl.fl = 'abstract,title', rows=3, url = url, key=key)

# Raw data back
## json
solr_highlight(q='alcohol', hl.fl = 'abstract', rows=10, url = url, key=key, raw=TRUE)
## xml
solr_highlight(q='alcohol', hl.fl = 'abstract', rows=10, url = url, key=key, raw=TRUE, wt='xml')
## parse after getting data back
out <- solr_highlight(q='alcohol', hl.fl = 'abstract,title', hl.fragsize=30, rows=10, url = url, key=key, raw=TRUE, wt='xml')
solr_parse(out, parsetype='df')
}
}
\references{
See
\url{http://wiki.apache.org/solr/HighlightingParameters}
for more information on highlighting.
}
\seealso{
\code{\link{solr_search}}, \code{\link{solr_facet}}
}

