#' Unload (delete) a core
#'
#' @export
#'
#' @inheritParams core_create
#' @param deleteIndex	(logical)	If `TRUE`, will remove the index when unloading
#' the core. Default: `FALSE`
#' @param deleteDataDir	(logical)	If `TRUE`, removes the data directory and all
#' sub-directories. Default: `FALSE`
#' @param deleteInstanceDir	(logical)	If `TRUE`, removes everything related to
#' the core, including the index directory, configuration files and other 
#' related files. Default: `FALSE`
#' @param async	(character) Request ID to track this action which will be 
#' processed asynchronously
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg:
#' #   bin/solr start -e schemaless
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' # Create a core
#' conn$core_create(name = "books")
#'
#' # Unload a core
#' conn$core_unload(name = "books")
#' ## not found
#' # conn$core_unload(name = "books")
#' # > Error: 400 - Cannot unload non-existent core [books]
#' }
core_unload <- function(conn, name, deleteIndex = FALSE, deleteDataDir = FALSE,
                        deleteInstanceDir = FALSE, async = NULL,
                        raw = FALSE, callopts = list()) {

  conn$core_unload(name, deleteIndex, deleteDataDir, deleteInstanceDir, async,
                   raw, callopts)
}
