#' @title Add a replica property
#'
#' @description Assign an arbitrary property to a particular replica and give it
#' the value specified. If the property already exists, it will be overwritten
#' with the new value.
#'
#' @export
#' @inheritParams collection_create
#' @param shard (character) Required. The name of the shard the replica
#' belongs to
#' @param replica (character) Required. The replica, e.g. core_node1.
#' @param property (character) Required. The property to add. Note: this will
#' have the literal 'property.' prepended to distinguish it from
#' system-maintained properties. So these two forms are equivalent:
#' `property=special` and `property=property.special`
#' @param property.value (character) Required. The value to assign to
#' the property
#' @param shardUnique (logical) If `TRUE`, then setting this property in one
#' replica will (1) remove the property from all other replicas in that shard
#' Default: `FALSE`
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' # create collection
#' if (!conn$collection_exists("addrep")) {
#'   conn$collection_create(name = "addrep", numShards = 1)
#'   # OR bin/solr create -c addrep
#' }
#'
#' # status
#' conn$collection_clusterstatus()$cluster$collections$addrep$shards
#'
#' # add the value world to the property hello
#' conn$collection_addreplicaprop(name = "addrep", shard = "shard1",
#'   replica = "core_node1", property = "hello", property.value = "world")
#'
#' # check status
#' conn$collection_clusterstatus()$cluster$collections$addrep$shards
#' conn$collection_clusterstatus()$cluster$collections$addrep$shards$shard1$replicas$core_node1
#' }
collection_addreplicaprop <- function(conn, name, shard, replica, property,
  property.value, shardUnique = FALSE, raw = FALSE, callopts=list()) {

  conn$collection_addreplicaprop(name, shard, replica, property,
                                 property.value, shardUnique, raw, callopts)
}
