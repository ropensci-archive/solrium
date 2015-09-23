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
#' @param name The name of the target core/index. Required
#' @param indexDir (character)	Multi-valued, directories that would be merged.
#' @param srcCore	(character)	Multi-valued, source cores that would be merged.
#' @param async	(character) Request ID to track this action which will be processed
#' asynchronously
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg: bin/solr start -e schemaless
#'
#' # connect
#' solr_connect()
#'
#' ## FIXME: not tested yet
#'
#' # use indexDir parameter
#' core_mergeindexes(core="new_core_name", indexDir = c("/solr_home/core1/data/index",
#'    "/solr_home/core2/data/index"))
#'
#' # use srcCore parameter
#' core_mergeindexes(name = "new_core_name", srcCore = c('core1', 'core2'))
#' }
core_mergeindexes <- function(name, indexDir = NULL, srcCore = NULL, async = NULL,
                        raw = FALSE, callopts = list()) {

  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'MERGEINDEXES', core = name, indexDir = indexDir,
                  srcCore = srcCore, async = async, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/cores'), args, callopts, conn$proxy)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
