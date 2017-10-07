#' Get the schema for a collection or core
#' 
#' @export
#' @param what (character) What to retrieve. By default, we retrieve the entire
#' schema. Options include: fields, dynamicfields, fieldtypes, copyfields, name,
#' version, uniquekey, similarity, "solrqueryparser/defaultoperator"
#' @inheritParams ping
#' @examples \dontrun{
#' # start Solr, in your CLI, run: `bin/solr start -e cloud -noprompt`
#' # after that, if you haven't run `bin/post -c gettingstarted docs/` yet, do so
#' 
#' # connect: by default we connect to localhost, port 8983
#' (cli <- SolrClient$new())
#' 
#' # get the schema for the gettingstarted index
#' schema(cli, name = "gettingstarted")
#' 
#' # Get parts of the schema
#' schema(cli, name = "gettingstarted", "fields")
#' schema(cli, name = "gettingstarted", "dynamicfields")
#' schema(cli, name = "gettingstarted", "fieldtypes")
#' schema(cli, name = "gettingstarted", "copyfields")
#' schema(cli, name = "gettingstarted", "name")
#' schema(cli, name = "gettingstarted", "version")
#' schema(cli, name = "gettingstarted", "uniquekey")
#' schema(cli, name = "gettingstarted", "similarity")
#' schema(cli, name = "gettingstarted", "solrqueryparser/defaultoperator")
#' 
#' # get raw data
#' schema(cli, name = "gettingstarted", "similarity", raw = TRUE)
#' schema(cli, name = "gettingstarted", "uniquekey", raw = TRUE)
#' 
#' # start Solr in Schemaless mode: bin/solr start -e schemaless
#' # schema(cli, "gettingstarted")
#' 
#' # start Solr in Standalone mode: bin/solr start
#' # then add a core: bin/solr create -c helloWorld
#' # schema(cli, "helloWorld")
#' }
schema <- function(conn, name, what = '', raw = FALSE, ...) {
  conn$schema(name = name, what = what, raw = raw, ...)
}
