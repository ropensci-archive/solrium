#' @title Create an alias for a collection
#'
#' @description Create a new alias pointing to one or more collections. If an
#' alias by the same name already exists, this action will replace the existing
#' alias, effectively acting like an atomic "MOVE" command.
#'
#' @export
#' @param alias (character) Required. The alias name to be created
#' @param collections (character) Required. A character vector of collections to be aliased
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#' collection_create(name = "thingsstuff", numShards = 2)
#' collection_createalias("tstuff", "thingsstuff")
#' collection_clusterstatus()$cluster$collections$thingsstuff$aliases # new alias
#' }
collection_createalias <- function(alias, collections, raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  collections <- check_shard(collections)
  args <- sc(list(action = 'CREATEALIAS', name = alias, collections = collections, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
