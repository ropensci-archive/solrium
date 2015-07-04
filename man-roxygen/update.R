#' @param files Path to file to load into Solr
#' @param commit (logical) If \code{TRUE}, documents immediately searchable. 
#' Deafult: \code{TRUE}
#' @param wt (character) One of json (default) or xml. If json, uses 
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to 
#' parse
#' @param verbose If \code{TRUE} (default) the url call used printed to console.
#' @param raw (logical) If \code{TRUE}, returns raw data in format specified by 
#' \code{wt} param
#' @param base (character) URL endpoint. This is different from the other functions in 
#' that we aren't hitting a search endpoint. Pass in here 
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @details You likely may not be able to run this function against many public Solr 
#' services, but should work locally.
