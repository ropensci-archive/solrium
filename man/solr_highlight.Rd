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
  \item{hl}{XXXX}

  \item{hl.q}{XXXX}

  \item{hl.fl}{XXXX}

  \item{hl.snippets}{XXXX}

  \item{hl.fragsize}{XXXX}

  \item{hl.mergeContiguous}{XXXX}

  \item{hl.requireFieldMatch}{XXXX}

  \item{hl.maxAnalyzedChars}{XXXX}

  \item{hl.alternateField}{XXXX}

  \item{hl.maxAlternateFieldLength}{XXXX}

  \item{hl.preserveMulti}{XXXX}

  \item{hl.maxMultiValuedToExamine}{XXXX}

  \item{hl.maxMultiValuedToMatch}{XXXX}

  \item{hl.formatter}{XXXX}

  \item{hl.simple.pre}{XXXX}

  \item{hl.simple.post}{XXXX}

  \item{hl.fragmenter}{XXXX}

  \item{hl.fragListBuilder}{XXXX}

  \item{hl.fragmentsBuilder}{XXXX}

  \item{hl.boundaryScanner}{XXXX}

  \item{hl.bs.maxScan}{XXXX}

  \item{hl.bs.chars}{XXXX}

  \item{hl.bs.type}{XXXX}

  \item{hl.bs.language}{XXXX}

  \item{hl.bs.country}{XXXX}

  \item{hl.useFastVectorHighlighter}{XXXX}

  \item{hl.usePhraseHighlighter}{XXXX}

  \item{hl.highlightMultiTerm}{XXXX}

  \item{hl.regex.slop}{XXXX}

  \item{hl.regex.pattern}{XXXX}

  \item{hl.regex.maxAnalyzedChars}{XXXX}

  \item{q}{Query terms}

  \item{start}{Record to start at, default to beginning.}

  \item{rows}{Number of records to return.}

  \item{key}{API key, if needed.}

  \item{url}{URL endpoint}

  \item{callopts}{Call options passed on to httr::GET}

  \item{...}{Further args.}

  \item{wt}{(character) Data format to return. One of xml
  or json (default).}

  \item{raw}{(logical) If TRUE (default) raw json or xml
  returned. If FALSE, parsed data returned.}

  \item{fq}{Filter query, this does not affect the search,
  only what gets returned}

  \item{fl}{Fields to return}

  \item{parsetype}{One of list of df (data.frame)}
}
\value{
A list.
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

