#' @title Delete a replica
#'
#' @description Delete a replica from a given collection and shard. If the
#' corresponding core is up and running the core is unloaded and the entry is
#' removed from the clusterstate. If the node/core is down , the entry is taken
#' off the clusterstate and if the core comes up later it is automatically
#' unregistered.
#'
#' @export
#' @param name (character) Required. The name of the collection.
#' @param shard (character) Required. The name of the shard that includes the replica to
#' be removed.
#' @param replica (character) Required. The name of the replica to remove.
#' @param onlyIfDown (logical) When \code{TRUE} will not take any action if the replica
#' is active. Default: \code{FALSE}
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' @param ... You can pass in parameters like \code{property.name=value}	to set
#' core property name to value. See the section Defining core.properties for details on
#' supported properties and values.
#' (https://cwiki.apache.org/confluence/display/solr/Defining+core.properties)
#' @examples \dontrun{
#' solr_connect()
#'
#' # create collection
#' collection_create(name = "foobar2", numShards = 2) # bin/solr create -c foobar2
#'
#' # status
#' collection_clusterstatus()$cluster$collections$foobar2$shards$shard1
#'
#' # add replica
#' collection_addreplica(name = "foobar2", shard = "shard1")
#'
#' # delete replica
#' ## get replica name
#' nms <- names(collection_clusterstatus()$cluster$collections$foobar2$shards$shard1$replicas)
#' collection_deletereplica(name = "foobar2", shard = "shard1", replica = nms[1])
#'
#' # status again
#' collection_clusterstatus()$cluster$collections$foobar2$shards$shard1
#' }
collection_deletereplica <- function(name, shard = NULL, replica = NULL, onlyIfDown = FALSE,
                                  raw = FALSE, callopts=list(), ...) {

  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'DELETEREPLICA', collection = name, shard = shard, replica = replica,
                  onlyIfDown = asl(onlyIfDown), wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, callopts, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
