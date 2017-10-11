#' @title Get cluster status
#'
#' @description Fetch the cluster status including collections, shards, 
#' replicas, configuration name as well as collection aliases and cluster 
#' properties.
#'
#' @export
#' @inheritParams collection_create
#' @param shard (character) The shard(s) for which information is requested. 
#' Multiple shard names can be specified as a character vector.
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#' conn$collection_clusterstatus()
#' res <- conn$collection_clusterstatus()
#' res$responseHeader
#' res$cluster
#' res$cluster$collections
#' res$cluster$collections$gettingstarted
#' res$cluster$live_nodes
#' }
collection_clusterstatus <- function(conn, name = NULL, shard = NULL, 
                                     raw = FALSE, ...) {
  conn$collection_clusterstatus(name, shard, raw, ...)
}

check_shard <- function(x) {
  if (is.null(x)) {
    x
  } else {
    paste0(x, collapse = ",")
  }
}
