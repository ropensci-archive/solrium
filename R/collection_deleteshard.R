#' @title Delete a shard
#'
#' @description Deleting a shard will unload all replicas of the shard and remove
#' them from clusterstate.json. It will only remove shards that are inactive, or
#' which have no range given for custom sharding.
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) Required. The name of the collection that includes the shard
#' to be deleted
#' @param shard (character) Required. The name of the shard to be deleted
#' @param raw (logical) If `TRUE`, returns raw data
#' @param ... curl options passed on to [crul::HttpClient]
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' # create collection
#' if (!conn$collection_exists("buffalo")) {
#'   conn$collection_create(name = "buffalo")
#'   # OR: bin/solr create -c buffalo
#' }
#'
#' # find shard names
#' names(conn$collection_clusterstatus()$cluster$collections$buffalo$shards)
#'
#' # split a shard by name
#' collection_splitshard(conn, name = "buffalo", shard = "shard1")
#'
#' # now we have three shards
#' names(conn$collection_clusterstatus()$cluster$collections$buffalo$shards)
#'
#' # delete shard
#' conn$collection_deleteshard(name = "buffalo", shard = "shard1_1")
#' }
collection_deleteshard <- function(conn, name, shard, raw = FALSE, ...) {
  conn$collection_deleteshard(name, shard, raw, ...)
}
