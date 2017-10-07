#' Create a shard
#'
#' @export
#' @inheritParams collection_create
#' @param shard (character) Required. The name of the shard to be created.
#' @param createNodeSet (character) Allows defining the nodes to spread the new
#' collection across. If not provided, the CREATE operation will create 
#' shard-replica spread across all live Solr nodes. The format is a 
#' comma-separated list of node_names, such as localhost:8983_solr, 
#' localhost:8984_s olr, localhost:8985_solr.
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#' ## FIXME - doesn't work right now
#' # conn$collection_create(name = "trees")
#' # conn$collection_createshard(name = "trees", shard = "newshard")
#' }
collection_createshard <- function(conn, name, shard, createNodeSet = NULL, 
                                   raw = FALSE, ...) {
  conn$collection_createshard(name, shard, createNodeSet, raw, ...)
}
