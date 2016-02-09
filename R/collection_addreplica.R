#' @title Add a replica
#'
#' @description Add a replica to a shard in a collection. The node name can be
#' specified if the replica is to be created in a specific node
#'
#' @export
#' @param name (character) The name of the collection. Required
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
#' if (!collection_exists("foobar")) {
#'   collection_create(name = "foobar", numShards = 2) # bin/solr create -c foobar
#' }
#'
#' # status
#' collection_clusterstatus()$cluster$collections$foobar
#'
#' # add replica
#' if (!collection_exists("foobar")) {
#'   collection_addreplica(name = "foobar", shard = "shard1")
#' }
#'
#' # status again
#' collection_clusterstatus()$cluster$collections$foobar
#' collection_clusterstatus()$cluster$collections$foobar$shards
#' collection_clusterstatus()$cluster$collections$foobar$shards$shard1
#' }
collection_addreplica <- function(name, shard = NULL, route = NULL, node = NULL,
                              instanceDir = NULL, dataDir = NULL, async = NULL,
                              raw = FALSE, callopts=list(), ...) {

  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'ADDREPLICA', collection = name, shard = shard, route = route,
                  node = node, instanceDir = instanceDir, dataDir = dataDir,
                  async = async, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, callopts, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
