#' @title Swap a core
#'
#' @description SWAP atomically swaps the names used to access two existing Solr cores.
#' This can be used to swap new content into production. The prior core remains
#' available and can be swapped back, if necessary. Each core will be known by
#' the name of the other, after the swap
#'
#' @export
#'
#' @param name (character) The name of one of the cores to be swapped. Required
#' @param other (character) The name of one of the cores to be swapped. Required.
#' @param async	(character) Request ID to track this action which will be processed
#' asynchronously
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' @details Do not use \code{core_swap} with a SolrCloud node. It is not supported and
#' can result in the core being unusable. We'll try to stop you if you try.
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg: bin/solr start -e schemaless
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#'
#' # connect
#' solr_connect()
#'
#' # Swap a core
#' ## First, create two cores
#' core_create("swapcoretest") # or create in the CLI: bin/solr create -c swapcoretest
#' core_create("swapcoretest") # or create in the CLI: bin/solr create -c swapcoretest
#'
#' ## check status
#' core_status("swapcoretest1", FALSE)
#' core_status("swapcoretest2", FALSE)
#'
#' ## swap core
#' core_swap("swapcoretest1", "swapcoretest2")
#'
#' ## check status again
#' core_status("swapcoretest1", FALSE)
#' core_status("swapcoretest2", FALSE)
#' }
core_swap <- function(name, other, async = NULL, raw = FALSE, callopts=list()) {
  conn <- solr_settings()
  check_conn(conn)
  if (is_in_cloud_mode(conn)) stop("You are in SolrCloud mode, stopping", call. = FALSE)
  args <- sc(list(action = 'SWAP', core = name, other = other, async = async, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/cores'), args, callopts, conn$proxy)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}

