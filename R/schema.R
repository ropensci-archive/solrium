#' Get the schema for a collection or core
#' 
#' @export
#' @param name (character) Name of collection or core
#' @param what (character) What to retrieve. By default, we retrieve the entire
#' schema. Options include: fields, dynamicfields, fieldtypes, copyfields, name,
#' version, uniquekey, similarity, "solrqueryparser/defaultoperator"
#' @param raw (logical) If \code{TRUE}, returns raw data 
#' @param verbose If TRUE (default) the url call used printed to console.
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # start Solr, in your CLI, run: `bin/solr start -e cloud -noprompt`
#' # after that, if you haven't run `bin/post -c gettingstarted docs/` yet, do so
#' 
#' # connect: by default we connect to localhost, port 8983
#' solr_connect()
#' 
#' # get the schema for the gettingstarted index
#' schema(name = "gettingstarted")
#' 
#' # Get parts of the schema
#' schema(name = "gettingstarted", "fields")
#' schema(name = "gettingstarted", "dynamicfields")
#' schema(name = "gettingstarted", "fieldtypes")
#' schema(name = "gettingstarted", "copyfields")
#' schema(name = "gettingstarted", "name")
#' schema(name = "gettingstarted", "version")
#' schema(name = "gettingstarted", "uniquekey")
#' schema(name = "gettingstarted", "similarity")
#' schema(name = "gettingstarted", "solrqueryparser/defaultoperator")
#' 
#' # get raw data
#' schema(name = "gettingstarted", "similarity", raw = TRUE)
#' schema(name = "gettingstarted", "uniquekey", raw = TRUE)
#' 
#' # start Solr in Schemaless mode: bin/solr start -e schemaless
#' # schema("gettingstarted")
#' 
#' # start Solr in Standalone mode: bin/solr start
#' # then add a core: bin/solr create -c helloWorld
#' # schema("helloWorld")
#' }
schema <- function(name, what = '', raw = FALSE, verbose = TRUE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  res <- solr_GET(file.path(conn$url, sprintf('solr/%s/schema', name), what), 
                  list(wt = "json"), verbose = verbose, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
