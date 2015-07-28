#' Get the schema for a collection or core
#' 
#' @export
#' @param conn Connection object. Required. See \code{\link{solr_connect}}.
#' @param name (character) Name of collection or core
#' @param wt (character) One of json (default) or xml. If json, uses 
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to 
#' parse
#' @param raw (logical) If \code{TRUE}, returns raw data in format specified by 
#' \code{wt} param
#' @param verbose If TRUE (default) the url call used printed to console.
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' conn <- solr_connect()
#' 
#' # start Solr in Schemaless mode: bin/solr start -e schemaless
#' # schema(conn, "gettingstarted")
#' 
#' # start Solr in Standalone mode: bin/solr start
#' # then add a core: bin/solr create -c helloWorld
#' # schema(conn, "helloWorld")
#' }
schema <- function(conn, name = NULL, wt = 'json', raw = FALSE, verbose = TRUE, ...) {
  check_conn(conn)
  args <- list(wt = 'json')
  res <- solr_GET(file.path(conn$url, sprintf('solr/%s/schema', name)), args, verbose = verbose, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
