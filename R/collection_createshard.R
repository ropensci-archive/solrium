#' Create a shard
#'
#' @export
#' @param name (character) Required. The name of the collection that includes the shard
#' that will be splitted.
#' @param shard (character) Required. The name of the shard to be created.
#' @param createNodeSet (character) Allows defining the nodes to spread the new
#' collection across. If not provided, the CREATE operation will create shard-replica
#' spread across all live Solr nodes. The format is a comma-separated list of
#' node_names, such as localhost:8983_solr, localhost:8984_s olr, localhost:8985_solr.
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#' ## FIXME - doesn't work right now
#' # collection_create(name = "trees")
#' # collection_createshard(name = "trees", shard = "newshard")
#' }
collection_createshard <- function(name, shard, createNodeSet = NULL, raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'CREATESHARD', collection = name, shard = shard,
                  createNodeSet = createNodeSet, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
