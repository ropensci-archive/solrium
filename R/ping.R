#' Ping a Solr instance
#' 
#' @export
#' @param conn Connection object. Required.
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
#' # by default we connect to localhost, port 8983
#' conn <- solr_connect()
#' ping(conn)
#' ping(conn, wt = "xml")
#' ping(conn, verbose = FALSE)
#' ping(conn, raw = TRUE)
#' 
#' library("httr")
#' ping(conn, wt="xml", callopts = verbose())
#' }

ping <- function(conn, wt = 'json', verbose = TRUE, raw = FALSE, callopts = list()) {
  if (is.null(conn)) {
    stop("You must provide a connection object")
  }
  out <- structure(solr_GET(file.path(conn$url, 'solr/admin/ping'), args = list(wt = wt), 
                            callopts, verbose, conn$proxy), class = "ping", wt = wt)
  if (raw) { 
    return( out ) 
  } else { 
    solr_parse(out) 
  }
}
