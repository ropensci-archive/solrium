#' @title Get cluster status
#'
#' @description Fetch the cluster status including collections, shards, replicas,
#' configuration name as well as collection aliases and cluster properties.
#'
#' @export
#' @param name (character) The collection name for which information is requested.
#' If omitted, information on all collections in the cluster will be returned.
#' @param shard (character) The shard(s) for which information is requested. Multiple
#' shard names can be specified as a character vector.
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#' collection_clusterstatus()
#' res <- collection_clusterstatus()
#' res$responseHeader
#' res$cluster
#' res$cluster$collections
#' res$cluster$collections$gettingstarted
#' res$cluster$live_nodes
#' }
collection_clusterstatus <- function(name = NULL, shard = NULL, raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  shard <- check_shard(shard)
  args <- sc(list(action = 'CLUSTERSTATUS', collection = name, shard = shard, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}

check_shard <- function(x) {
  if (is.null(x)) {
    x
  } else {
    paste0(x, collapse = ",")
  }
}
