#' Ping a Solr instance
#' 
#' @export
#' @param base URL endpoint. This is different from the other functions in that we aren't 
#' hitting a search endpoint. Pass in here 
#' @param wt (character) One of json (default) or xml. If json, uses 
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to parse
#' @param verbose If TRUE (default) the url call used printed to console.
#' @param raw (logical) If TRUE, returns raw data in format specified by wt param
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' 
#' @details You likely may not be able to run this function against many public Solr 
#' services, but should work locally.
#' 
#' @examples \dontrun{
#' ping()
#' ping('http://localhost:8983')
#' ping('http://localhost:8983', wt="xml")
#' ping('http://localhost:8983', verbose=FALSE)
#' ping('http://localhost:8983', raw=TRUE)
#' 
#' library("httr")
#' ping('http://localhost:8983', wt="xml", callopts = verbose())
#' }

ping <- function(base = 'http://localhost:8983', wt = 'json', verbose = TRUE, raw = FALSE, 
                 callopts = list()) {
  
  if(is.null(base)){
    stop("You must provide a url, e.g., http://api.plos.org/search or http://localhost:8983/solr/select")
  }
  out <- structure(solr_GET(file.path(base, 'solr/admin/ping'), args=list(wt = wt), callopts, verbose), class="ping", wt=wt)
  if(raw){ return( out ) } else { solr_parse(out) }
}
