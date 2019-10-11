#' @title Swap a core
#'
#' @description SWAP atomically swaps the names used to access two existing
#' Solr cores. This can be used to swap new content into production. The
#' prior core remains available and can be swapped back, if necessary. Each
#' core will be known by the name of the other, after the swap
#'
#' @export
#'
#' @inheritParams core_create
#' @param other (character) The name of one of the cores to be swapped.
#' Required.
#' @param async	(character) Request ID to track this action which will be
#' processed asynchronously
#' @details Do not use `core_swap` with a SolrCloud node. It is not
#' supported and can result in the core being unusable. We'll try to stop
#' you if you try.
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg:
#' #   bin/solr start -e schemaless
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' # Swap a core
#' ## First, create two cores
#' conn$core_create("swapcoretest1")
#' # - or create on CLI: bin/solr create -c swapcoretest1
#' conn$core_create("swapcoretest2")
#' # - or create on CLI: bin/solr create -c swapcoretest2
#'
#' ## check status
#' conn$core_status("swapcoretest1", FALSE)
#' conn$core_status("swapcoretest2", FALSE)
#'
#' ## swap core
#' conn$core_swap("swapcoretest1", "swapcoretest2")
#'
#' ## check status again
#' conn$core_status("swapcoretest1", FALSE)
#' conn$core_status("swapcoretest2", FALSE)
#' }
core_swap <- function(conn, name, other, async = NULL, raw = FALSE,
                      callopts=list()) {
  conn$core_swap(name, other, async, raw, callopts)
}

