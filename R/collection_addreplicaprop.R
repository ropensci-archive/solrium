#' @title Add a replica property
#'
#' @description Assign an arbitrary property to a particular replica and give it
#' the value specified. If the property already exists, it will be overwritten
#' with the new value.
#'
#' @export
#' @param name (character) Required. The name of the collection this replica belongs to.
#' @param shard (character) Required. The name of the shard the replica belongs to.
#' @param replica (character) Required. The replica, e.g. core_node1.
#' @param property (character) Required. The property to add. Note: this will have the
#' literal 'property.' prepended to distinguish it from system-maintained properties.
#' So these two forms are equivalent: \code{property=special} and
#' \code{property=property.special}
#' @param property.value (character) Required. The value to assign to the property.
#' @param shardUnique (logical) If \code{TRUE}, then setting this property in one
#' replica will (1) remove the property from all other replicas in that shard.
#' Default: \code{FALSE}
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#'
#' # create collection
#' collection_create(name = "addrep", numShards = 2) # bin/solr create -c addrep
#'
#' # status
#' collection_clusterstatus()$cluster$collections$addrep$shards
#'
#' # add the value world to the property hello
#' collection_addreplicaprop(name = "addrep", shard = "shard1", replica = "core_node1",
#'    property = "hello", property.value = "world")
#'
#' # check status
#' collection_clusterstatus()$cluster$collections$addrep$shards
#' collection_clusterstatus()$cluster$collections$addrep$shards$shard1$replicas$core_node1
#' }
collection_addreplicaprop <- function(name, shard, replica, property, property.value,
                                      shardUnique = FALSE, raw = FALSE, callopts=list()) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'ADDREPLICAPROP', collection = name, shard = shard,
                  replica = replica, property = property,
                  property.value = property.value,
                  shardUnique = asl(shardUnique), wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, callopts, conn$proxy)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
