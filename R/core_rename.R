#' Rename a core
#'
#' @export
#'
#' @inheritParams core_create
#' @param other (character) The new name of the core. Required.
#' @param async	(character) Request ID to track this action which will be
#' processed asynchronously
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg:
#' #   bin/solr start -e schemaless
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' # Status of particular cores
#' path <- "~/solr-8.2.0/server/solr/testcore/conf"
#' dir.create(path, recursive = TRUE)
#' files <- list.files(
#' "~/solr-8.2.0/server/solr/configsets/sample_techproducts_configs/conf/",
#' full.names = TRUE)
#' invisible(file.copy(files, path, recursive = TRUE))
#' conn$core_create("testcore") # or create in CLI: bin/solr create -c testcore
#'
#' # rename
#' conn$core_rename("testcore", "newtestcore")
#' ## status
#' conn$core_status("testcore") # core missing
#' conn$core_status("newtestcore", FALSE) # not missing
#'
#' # cleanup
#' conn$core_unload("newtestcore")
#' }
core_rename <- function(conn, name, other, async = NULL, raw = FALSE, callopts=list()) {
  conn$core_rename(name, other, async, raw, callopts)
}

