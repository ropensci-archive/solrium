#' @title Add a replica
#'
#' @description Add a replica to a shard in a collection. The node name can be
#' specified if the replica is to be created in a specific node
#'
#' @export
#' @inheritParams collection_create
#' @param shard (character) The name of the shard to which replica is to be added.
#' If \code{shard} is not given, then \code{route} must be.
#' @param route (character) If the exact shard name is not known, users may pass
#' the \code{route} value and the system would identify the name of the shard.
#' Ignored if the \code{shard} param is also given
#' @param node (character) The name of the node where the replica should be created
#' @param instanceDir (character) The instanceDir for the core that will be created
#' @param dataDir	(character)	The directory in which the core should be created
#' @param async	(character) Request ID to track this action which will be processed
#' asynchronously
#' @param ... You can pass in parameters like `property.name=value`	to set
#' core property name to value. See the section Defining core.properties for details on
#' supported properties and values.
#' (https://lucene.apache.org/solr/guide/8_2/defining-core-properties.html)
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' # create collection
#' if (!conn$collection_exists("foobar")) {
#'   conn$collection_create(name = "foobar", numShards = 2)
#'   # OR bin/solr create -c foobar
#' }
#'
#' # status
#' conn$collection_clusterstatus()$cluster$collections$foobar
#'
#' # add replica
#' if (!conn$collection_exists("foobar")) {
#'   conn$collection_addreplica(name = "foobar", shard = "shard1")
#' }
#'
#' # status again
#' conn$collection_clusterstatus()$cluster$collections$foobar
#' conn$collection_clusterstatus()$cluster$collections$foobar$shards
#' conn$collection_clusterstatus()$cluster$collections$foobar$shards$shard1
#' }
collection_addreplica <- function(conn, name, shard = NULL, route = NULL, node = NULL,
                              instanceDir = NULL, dataDir = NULL, async = NULL,
                              raw = FALSE, callopts=list(), ...) {

  conn$collection_addreplica(name, shard, route, node, instanceDir, dataDir,
                             async, raw, callopts, ...)
}
