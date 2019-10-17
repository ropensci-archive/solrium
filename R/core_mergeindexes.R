#' @title Merge indexes (cores)
#'
#' @description Merges one or more indexes to another index. The indexes must
#' have completed commits, and should be locked against writes until the merge
#' is complete or the resulting merged index may become corrupted. The target
#' core index must already exist and have a compatible schema with the one or
#' more indexes that will be merged to it.
#'
#' @export
#'
#' @inheritParams core_create
#' @param indexDir (character)	Multi-valued, directories that would be merged.
#' @param srcCore	(character)	Multi-valued, source cores that would be merged.
#' @param async	(character) Request ID to track this action which will be
#' processed asynchronously
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg:
#' #  bin/solr start -e schemaless
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' ## FIXME: not tested yet
#'
#' # use indexDir parameter
#' # conn$core_mergeindexes(core="new_core_name",
#' #    indexDir = c("/solr_home/core1/data/index",
#' #    "/solr_home/core2/data/index"))
#'
#' # use srcCore parameter
#' # conn$core_mergeindexes(name = "new_core_name", srcCore = c('core1', 'core2'))
#' }
core_mergeindexes <- function(conn, name, indexDir = NULL, srcCore = NULL,
                              async = NULL, raw = FALSE, callopts = list()) {
  conn$core_mergeindexes(name, indexDir, srcCore, async, raw, callopts)
}
