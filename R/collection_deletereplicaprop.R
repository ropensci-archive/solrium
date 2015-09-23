#' @title Delete a replica property
#'
#' @description Deletes an arbitrary property from a particular replica.
#'
#' @export
#' @param name (character) Required. The name of the collection this replica belongs to.
#' @param shard (character) Required. The name of the shard the replica belongs to.
#' @param replica (character) Required. The replica, e.g. core_node1.
#' @param property (character) Required. The property to delete. Note: this will have the
#' literal 'property.' prepended to distinguish it from system-maintained properties.
#' So these two forms are equivalent: \code{property=special} and
#' \code{property=property.special}
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#'
#' # create collection
#' collection_create(name = "deleterep", numShards = 2) # bin/solr create -c deleterep
#'
#' # status
#' collection_clusterstatus()$cluster$collections$deleterep$shards
#'
#' # add the value bar to the property foo
#' collection_addreplicaprop(name = "deleterep", shard = "shard1", replica = "core_node1",
#'    property = "foo", property.value = "bar")
#'
#' # check status
#' collection_clusterstatus()$cluster$collections$deleterep$shards
#' collection_clusterstatus()$cluster$collections$deleterep$shards$shard1$replicas$core_node1
#'
#' # delete replica property
#' collection_deletereplicaprop(name = "deleterep", shard = "shard1",
#'    replica = "core_node1", property = "foo")
#'
#' # check status - foo should be gone
#' collection_clusterstatus()$cluster$collections$deleterep$shards$shard1$replicas$core_node1
#' }
collection_deletereplicaprop <- function(name, shard, replica, property,
                                         raw = FALSE, callopts=list()) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'DELETEREPLICAPROP', collection = name, shard = shard,
                  replica = replica, property = property, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, callopts, conn$proxy)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
