#' @param q Query terms, defaults to '*:*', or everything.
#' @param stats.field The number of similar documents to return for each result.
#' @param stats.facet You can not facet on multi-valued fields.
#' @param wt Data type returned, defaults to 'json'
#' @param start Record to start at, default to beginning.
#' @param rows Number of records to return. Defaults to 10.
#' @param key API key, if needed.
#' @param base URL endpoint.
#' @param callopts Call options passed on to httr::GET
#' @param raw (logical) If TRUE, returns raw data in format specified by wt param
#' @param parsetype (character) One of 'list' or 'df'
#' @param verbose If TRUE (default) the url call used printed to console.
#'
