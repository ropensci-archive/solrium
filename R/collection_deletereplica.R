#' @title Delete a replica
#'
#' @description Delete a replica from a given collection and shard. If the
#' corresponding core is up and running the core is unloaded and the entry is
#' removed from the clusterstate. If the node/core is down , the entry is taken
#' off the clusterstate and if the core comes up later it is automatically
#' unregistered.
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) Required. The name of the collection.
#' @param shard (character) Required. The name of the shard that includes the replica to
#' be removed.
#' @param replica (character) Required. The name of the replica to remove.
#' @param onlyIfDown (logical) When `TRUE` will not take any action if the replica
#' is active. Default: `FALSE`
#' @param raw (logical) If `TRUE`, returns raw data
#' @param callopts curl options passed on to [crul::HttpClient]
#' @param ... You can pass in parameters like \code{property.name=value}	to set
#' core property name to value. See the section Defining core.properties for details on
#' supported properties and values.
#' (https://lucene.apache.org/solr/guide/8_2/defining-core-properties.html)
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' # create collection
#' if (!conn$collection_exists("foobar2")) {
#'   conn$collection_create(name = "foobar2", maxShardsPerNode = 2)
#' }
#'
#' # status
#' conn$collection_clusterstatus()$cluster$collections$foobar2$shards$shard1
#'
#' # add replica
#' conn$collection_addreplica(name = "foobar2", shard = "shard1")
#'
#' # delete replica
#' ## get replica name
#' nms <- names(conn$collection_clusterstatus()$cluster$collections$foobar2$shards$shard1$replicas)
#' conn$collection_deletereplica(name = "foobar2", shard = "shard1", replica = nms[1])
#'
#' # status again
#' conn$collection_clusterstatus()$cluster$collections$foobar2$shards$shard1
#' }
collection_deletereplica <- function(conn, name, shard = NULL, replica = NULL,
                                     onlyIfDown = FALSE, raw = FALSE,
                                     callopts=list(), ...) {

  conn$collection_deletereplica(name, shard, replica, onlyIfDown, raw,
                                callopts, ...)
}
