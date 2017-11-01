#' Create a shard
#'
#' @export
#' @inheritParams collection_create
#' @param shard (character) Required. The name of the shard to be split
#' @param ranges (character) A comma-separated list of hash ranges in
#' hexadecimal e.g. ranges=0-1f4,1f5-3e8,3e9-5dc
#' @param split.key (character) The key to use for splitting the index
#' @param async	(character) Request ID to track this action which will be
#' processed asynchronously
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' # create collection
#' if (!conn$collection_exists("trees")) {
#'   conn$collection_create("trees")
#' }
#'
#' # find shard names
#' names(conn$collection_clusterstatus()$cluster$collections$trees$shards)
#'
#' # split a shard by name
#' conn$collection_splitshard(name = "trees", shard = "shard1")
#'
#' # now we have three shards
#' names(conn$collection_clusterstatus()$cluster$collections$trees$shards)
#' }
collection_splitshard <- function(conn, name, shard, ranges = NULL, split.key = NULL,
                                  async = NULL, raw = FALSE, callopts = list()) {
  conn$collection_splitshard(name, shard, ranges, split.key, async, raw, callopts)
}
