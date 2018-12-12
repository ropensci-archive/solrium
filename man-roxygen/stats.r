#' @param name Name of a collection or core. Or leave as \code{NULL} if
#' not needed.
#' @param callopts Call options passed on to [crul::HttpClient]
#' @param raw (logical) If TRUE, returns raw data in format specified by
#' wt param
#' @param parsetype (character) One of 'list' or 'df'
#' @param progress a function with logic for printing a progress
#' bar for an HTTP request, ultimately passed down to \pkg{curl}. only supports 
#' \code{httr::progress} for now. See the README for an example.
#' @param ... Further args to be combined into query
#'
#' @section Stats parameters:
#' \itemize{
#'  \item q Query terms, defaults to '*:*', or everything.
#'  \item stats.field The number of similar documents to return for each result.
#'  \item stats.facet You can not facet on multi-valued fields.
#'  \item wt (character) Data type returned, defaults to 'json'. One of json
#'  or xml. If json, uses \code{\link[jsonlite]{fromJSON}} to parse. If xml,
#'  uses \code{\link[XML]{xmlParse}} to parse. csv is only supported in
#'  \code{\link{solr_search}} and \code{\link{solr_all}}.
#'  \item start Record to start at, default to beginning.
#'  \item rows Number of records to return. Defaults to 10.
#'  \item key API key, if needed.
#' }
