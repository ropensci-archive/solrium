#' @param q Query terms, defaults to '*:*', or everything.
#' @param stats.field The number of similar documents to return for each result.
#' @param stats.facet You can not facet on multi-valued fields. 
#' @param url URL endpoint.
#' @param key API key, if needed.
#' @param callopts Call options passed on to httr::GET
#' @param raw (logical) If TRUE, returns raw data in format specified by wt param
#' @param parsetype (character) One of 'list' or 'df'
#' @param start Record to start at, default to beginning.
#' @param rows Number of records to return. Defaults to 10.
#' @param wt Data type returned, defaults to 'json'