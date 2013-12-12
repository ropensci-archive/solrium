#' @param hl XXXX
#' @param hl.q XXXX
#' @param hl.fl XXXX
#' @param hl.snippets XXXX
#' @param hl.fragsize XXXX
#' @param hl.mergeContiguous XXXX
#' @param hl.requireFieldMatch XXXX
#' @param hl.maxAnalyzedChars XXXX
#' @param hl.alternateField XXXX
#' @param hl.maxAlternateFieldLength XXXX
#' @param hl.preserveMulti XXXX
#' @param hl.maxMultiValuedToExamine XXXX
#' @param hl.maxMultiValuedToMatch XXXX
#' @param hl.formatter XXXX
#' @param hl.simple.pre XXXX
#' @param hl.simple.post XXXX
#' @param hl.fragmenter XXXX
#' @param hl.fragListBuilder XXXX
#' @param hl.fragmentsBuilder XXXX
#' @param hl.boundaryScanner XXXX
#' @param hl.bs.maxScan XXXX
#' @param hl.bs.chars XXXX
#' @param hl.bs.type XXXX
#' @param hl.bs.language XXXX
#' @param hl.bs.country XXXX
#' @param hl.useFastVectorHighlighter XXXX
#' @param hl.usePhraseHighlighter XXXX
#' @param hl.highlightMultiTerm XXXX
#' @param hl.regex.slop XXXX
#' @param hl.regex.pattern XXXX
#' @param hl.regex.maxAnalyzedChars XXXX
#' @param q Query terms
#' @param start Record to start at, default to beginning.
#' @param rows Number of records to return.
#' @param key API key, if needed.
#' @param url URL endpoint
#' @param callopts Call options passed on to httr::GET
#' @param ... Further args.
#' @param wt (character) Data format to return. One of xml or json (default). 
#' @param raw (logical) If TRUE (default) raw json or xml returned. If FALSE,
#' 		parsed data returned.
#' @param fq Filter query, this does not affect the search, only what gets returned
#' @param fl Fields to return
#' @param parsetype One of list of df (data.frame)