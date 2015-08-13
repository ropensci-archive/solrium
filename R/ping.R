#' Ping a Solr instance
#' 
#' @export
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
#' # start Solr, in your CLI, run: `bin/solr start -e cloud -noprompt`
#' # after that, if you haven't run `bin/post -c gettingstarted docs/` yet, do so
#' 
#' # connect: by default we connect to localhost, port 8983
#' solr_connect()
#' 
#' # ping the gettingstarted index
#' ping("gettingstarted")
#' ping("gettingstarted", wt = "xml")
#' ping("gettingstarted", verbose = FALSE)
#' ping("gettingstarted", raw = TRUE)
#' 
#' library("httr")
#' ping("gettingstarted", wt="xml", config = verbose())
#' }

ping <- function(name, wt = 'json', verbose = TRUE, raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
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
