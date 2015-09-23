#' Delete a collection alias
#'
#' @export
#' @param alias (character) Required. The alias name to be created
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#' collection_create(name = "thingsstuff", numShards = 2)
#' collection_createalias("tstuff", "thingsstuff")
#' collection_clusterstatus()$cluster$collections$thingsstuff$aliases # new alias
#' collection_deletealias("tstuff")
#' collection_clusterstatus()$cluster$collections$thingsstuff$aliases # gone
#' }
collection_deletealias <- function(alias, raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'DELETEALIAS', name = alias, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
