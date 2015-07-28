#' Ping a Solr instance
#' 
#' @export
#' @param conn Connection object. Required.
#' @param name (character) Name of a collection or core. Required.
#' @param wt (character) One of json (default) or xml. If json, uses 
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to parse
#' @param verbose If TRUE (default) the url call used printed to console.
#' @param raw (logical) If TRUE, returns raw data in format specified by wt param
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' 
#' @details You likely may not be able to run this function against many public Solr 
#' services as they hopefully don't expose their admin interface to the public, but 
#' works locally.
#' 
#' @examples \dontrun{
#' # by default we connect to localhost, port 8983
#' conn <- solr_connect()
#' ping(conn, "helloWorld")
#' ping(conn, "helloWorld", wt = "xml")
#' ping(conn, "helloWorld", verbose = FALSE)
#' ping(conn, "helloWorld", raw = TRUE)
#' 
#' library("httr")
#' ping(conn, "helloWorld", wt="xml", config = verbose())
#' }

ping <- function(conn, name, wt = 'json', verbose = TRUE, raw = FALSE, ...) {
  if (is.null(conn)) {
    stop("You must provide a connection object")
  }
  res <- tryCatch(solr_GET(file.path(conn$url, sprintf('solr/%s/admin/ping', name)), 
           args = list(wt = wt), verbose = verbose, conn$proxy, ...), error = function(e) e)
  if (is(res, "error")) {
    return(list(status = "not found"))
  } else {
    out <- structure(res, class = "ping", wt = wt)
    if (raw) { 
      return( out ) 
    } else { 
      solr_parse(out) 
    }
  }
}
