#' Delete a collection alias
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param alias (character) Required. The alias name to be created
#' @param raw (logical) If `TRUE`, returns raw data
#' @param ... curl options passed on to [crul::HttpClient]
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#' conn$collection_create(name = "thingsstuff", numShards = 2)
#' conn$collection_createalias("tstuff", "thingsstuff")
#' conn$collection_clusterstatus()$cluster$collections$thingsstuff$aliases # new alias
#' conn$collection_deletealias("tstuff")
#' conn$collection_clusterstatus()$cluster$collections$thingsstuff$aliases # gone
#' }
collection_deletealias <- function(conn, alias, raw = FALSE, ...) {
  conn$collection_deletealias(alias, raw, ...)
}
