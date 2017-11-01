#' @title Delete a replica property
#'
#' @description Deletes an arbitrary property from a particular replica.
#'
#' @export
#' @inheritParams collection_create
#' @param shard (character) Required. The name of the shard the replica
#' belongs to.
#' @param replica (character) Required. The replica, e.g. core_node1.
#' @param property (character) Required. The property to delete. Note: this
#' will have the literal 'property.' prepended to distinguish it from
#' system-maintained properties. So these two forms are equivalent:
#' `property=special` and  `property=property.special`
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' # create collection
#' if (!conn$collection_exists("deleterep")) {
#'   conn$collection_create(name = "deleterep")
#'   # OR bin/solr create -c deleterep
#' }
#'
#' # status
#' conn$collection_clusterstatus()$cluster$collections$deleterep$shards
#'
#' # add the value bar to the property foo
#' conn$collection_addreplicaprop(name = "deleterep", shard = "shard1",
#'   replica = "core_node1", property = "foo", property.value = "bar")
#'
#' # check status
#' conn$collection_clusterstatus()$cluster$collections$deleterep$shards
#' conn$collection_clusterstatus()$cluster$collections$deleterep$shards$shard1$replicas$core_node1
#'
#' # delete replica property
#' conn$collection_deletereplicaprop(name = "deleterep", shard = "shard1",
#'    replica = "core_node1", property = "foo")
#'
#' # check status - foo should be gone
#' conn$collection_clusterstatus()$cluster$collections$deleterep$shards$shard1$replicas$core_node1
#' }
collection_deletereplicaprop <- function(conn, name, shard, replica, property,
                                         raw = FALSE, callopts=list()) {
  conn$collection_deletereplicaprop(name, shard, replica, property, raw,
                                    callopts)
}
