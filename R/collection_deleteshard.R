#' @title Delete a shard
#'
#' @description Deleting a shard will unload all replicas of the shard and remove
#' them from clusterstate.json. It will only remove shards that are inactive, or
#' which have no range given for custom sharding.
#'
#' @export
#' @param name (character) Required. The name of the collection that includes the shard
#' to be deleted
#' @param shard (character) Required. The name of the shard to be deleted
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#' # create collection
#' # collection_create(name = "buffalo") # bin/solr create -c buffalo
#'
#' # find shard names
#' names(collection_clusterstatus()$cluster$collections$buffalo$shards)
#' # split a shard by name
#' collection_splitshard(name = "buffalo", shard = "shard1")
#' # now we have three shards
#' names(collection_clusterstatus()$cluster$collections$buffalo$shards)
#'
#' # delete shard
#' collection_deleteshard(name = "buffalo", shard = "shard1_1")
#' }
collection_deleteshard <- function(name, shard, raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'DELETESHARD', collection = name, shard = shard, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
