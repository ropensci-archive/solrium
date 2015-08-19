#' @title Highlighting search
#'
#' @description Returns only highlight items
#' 
#' @export
#' @template high
#' @return XML, JSON, a list, or data.frame
#' @seealso \code{\link{solr_search}}, \code{\link{solr_facet}}
#' @references See \url{http://wiki.apache.org/solr/HighlightingParameters} for
#' more information on highlighting.
#' @examples \dontrun{
#' # connect
#' solr_connect('http://api.plos.org/search')
#'
#' # highlight search
#' solr_highlight(q='alcohol', hl.fl = 'abstract', rows=10)
#' solr_highlight(q='alcohol', hl.fl = c('abstract','title'), rows=3)
#'
#' # Raw data back
#' ## json
#' solr_highlight(q='alcohol', hl.fl = 'abstract', rows=10,
#'    raw=TRUE)
#' ## xml
#' solr_highlight(q='alcohol', hl.fl = 'abstract', rows=10,
#'    raw=TRUE, wt='xml')
#' ## parse after getting data back
#' out <- solr_highlight(q='alcohol', hl.fl = c('abstract','title'), hl.fragsize=30,
#'    rows=10, raw=TRUE, wt='xml')
#' solr_parse(out, parsetype='df')
#' }

solr_highlight <- function(name = NULL, q, hl.fl = NULL, hl.snippets = NULL, hl.fragsize = NULL,
     hl.q = NULL, hl.mergeContiguous = NULL, hl.requireFieldMatch = NULL,
     hl.maxAnalyzedChars = NULL, hl.alternateField = NULL, hl.maxAlternateFieldLength = NULL,
     hl.preserveMulti = NULL, hl.maxMultiValuedToExamine = NULL,
     hl.maxMultiValuedToMatch = NULL, hl.formatter = NULL, hl.simple.pre = NULL,
     hl.simple.post = NULL, hl.fragmenter = NULL, hl.fragListBuilder = NULL,
     hl.fragmentsBuilder = NULL, hl.boundaryScanner = NULL, hl.bs.maxScan = NULL,
     hl.bs.chars = NULL, hl.bs.type = NULL, hl.bs.language = NULL, hl.bs.country = NULL,
     hl.useFastVectorHighlighter = NULL, hl.usePhraseHighlighter = NULL,
     hl.highlightMultiTerm = NULL, hl.regex.slop = NULL, hl.regex.pattern = NULL,
     hl.regex.maxAnalyzedChars = NULL, start = 0, rows = NULL,
     wt='json', raw = FALSE, key = NULL, callopts=list(),
     fl='DOES_NOT_EXIST', fq=NULL, parsetype='list') {

  conn <- solr_settings()
  check_conn(conn)
  if(!is.null(hl.fl)) names(hl.fl) <- rep("hl.fl", length(hl.fl))
  args <- sc(list(wt=wt, q=q, start=start, rows=rows, hl='true',
     hl.snippets=hl.snippets, hl.fragsize=hl.fragsize, fl=fl, fq=fq,
     hl.mergeContiguous = hl.mergeContiguous, hl.requireFieldMatch = hl.requireFieldMatch,
     hl.maxAnalyzedChars = hl.maxAnalyzedChars, hl.alternateField = hl.alternateField,
     hl.maxAlternateFieldLength = hl.maxAlternateFieldLength, hl.preserveMulti = hl.preserveMulti,
     hl.maxMultiValuedToExamine = hl.maxMultiValuedToExamine, hl.maxMultiValuedToMatch = hl.maxMultiValuedToMatch,
     hl.formatter = hl.formatter, hl.simple.pre = hl.simple.pre, hl.simple.post = hl.simple.post,
     hl.fragmenter = hl.fragmenter, hl.fragListBuilder = hl.fragListBuilder,
     hl.fragmentsBuilder = hl.fragmentsBuilder, hl.boundaryScanner = hl.boundaryScanner,
     hl.bs.maxScan = hl.bs.maxScan, hl.bs.chars = hl.bs.chars, hl.bs.type = hl.bs.type,
     hl.bs.language = hl.bs.language, hl.bs.country = hl.bs.country,
     hl.useFastVectorHighlighter = hl.useFastVectorHighlighter,
     hl.usePhraseHighlighter = hl.usePhraseHighlighter, hl.highlightMultiTerm = hl.highlightMultiTerm,
     hl.regex.slop = hl.regex.slop, hl.regex.pattern = hl.regex.pattern,
     hl.regex.maxAnalyzedChars = hl.regex.maxAnalyzedChars))
  args <- c(args, hl.fl)

  out <- structure(solr_GET(handle_url(conn, name), args, callopts, conn$proxy), 
                   class="sr_high", wt=wt)
  if(raw){ return( out ) } else { return( solr_parse(out, parsetype) ) }
}
