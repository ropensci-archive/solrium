#' @param name Name of a collection or core. Or leave as \code{NULL} if not needed.
#' @param q Query terms, defaults to '*:*', or everything.
#' @param fq Filter query, this does not affect the search, only what gets returned
#' @param mlt.count The number of similar documents to return for each result. Default is 5.
#' @param mlt.fl The fields to use for similarity. NOTE: if possible these should have a stored 
#' TermVector DEFAULT_FIELD_NAMES = new String[] {"contents"}
#' @param mlt.mintf Minimum Term Frequency - the frequency below which terms will be ignored in 
#' the source doc. DEFAULT_MIN_TERM_FREQ = 2
#' @param mlt.mindf Minimum Document Frequency - the frequency at which words will be ignored which 
#' do not occur in at least this many docs. DEFAULT_MIN_DOC_FREQ = 5
#' @param mlt.minwl minimum word length below which words will be ignored. 
#' DEFAULT_MIN_WORD_LENGTH = 0
#' @param mlt.maxwl maximum word length above which words will be ignored. 
#' DEFAULT_MAX_WORD_LENGTH = 0
#' @param mlt.maxqt maximum number of query terms that will be included in any generated query. 
#' DEFAULT_MAX_QUERY_TERMS = 25
#' @param mlt.maxntp maximum number of tokens to parse in each example doc field that is not stored 
#' with TermVector support. DEFAULT_MAX_NUM_TOKENS_PARSED = 5000
#' @param mlt.boost [true/false] set if the query will be boosted by the interesting term relevance. 
#' DEFAULT_BOOST = false
#' @param mlt.qf Query fields and their boosts using the same format as that used in 
#' DisMaxQParserPlugin. These fields must also be specified in mlt.fl.
#' @param fl Fields to return. We force 'id' to be returned so that there is a unique identifier 
#' with each record.
#' @param wt (character) Data type returned, defaults to 'json'. One of json or xml. If json, 
#' uses \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to 
#' parse. csv is only supported in \code{\link{solr_search}} and \code{\link{solr_all}}.
#' @param start Record to start at, default to beginning.
#' @param rows Number of records to return. Defaults to 10.
#' @param key API key, if needed.
#' @param callopts Call options passed on to httr::GET
#' @param raw (logical) If TRUE, returns raw data in format specified by wt param
#' @param parsetype (character) One of 'list' or 'df'
#' @param concat (character) Character to concatenate elements of longer than length 1. 
#' Note that this only works reliably when data format is json (wt='json'). The parsing
#' is more complicated in XML format, but you can do that on your own.
#' 
#' @details The \code{verbose} parameter dropped. See \code{\link{solr_connect}}, which
#' can be used to set verbose status.
