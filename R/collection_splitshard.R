#' Create a shard
#'
#' @export
#' @param name (character) Required. The name of the collection that includes the shard
#' to be split
#' @param shard (character) Required. The name of the shard to be split
#' @param ranges (character) A comma-separated list of hash ranges in hexadecimal
#' e.g. ranges=0-1f4,1f5-3e8,3e9-5dc
#' @param split.key (character) The key to use for splitting the index
#' @param async	(character) Request ID to track this action which will be processed
#' asynchronously
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#' # create collection
#' collection_create(name = "trees")
#' # find shard names
#' names(collection_clusterstatus()$cluster$collections$trees$shards)
#' # split a shard by name
#' collection_splitshard(name = "trees", shard = "shard1")
#' # now we have three shards
#' names(collection_clusterstatus()$cluster$collections$trees$shards)
#' }
collection_splitshard <- function(name, shard, ranges = NULL, split.key = NULL,
                                  async = NULL, raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'SPLITSHARD', collection = name, shard = shard,
                  ranges = do_ranges(ranges), split.key = split.key, async = async, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
