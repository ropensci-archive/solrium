#' @title Create an alias for a collection
#'
#' @description Create a new alias pointing to one or more collections. If an
#' alias by the same name already exists, this action will replace the existing
#' alias, effectively acting like an atomic "MOVE" command.
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param alias (character) Required. The alias name to be created
#' @param collections (character) Required. A character vector of collections
#' to be aliased
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param callopts curl options passed on to \code{\link[crul]{HttpClient}}
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' if (!conn$collection_exists("thingsstuff")) {
#'   conn$collection_create(name = "thingsstuff")
#' }
#'
#' conn$collection_createalias("tstuff", "thingsstuff")
#' conn$collection_clusterstatus()$cluster$collections$thingsstuff$aliases
#' }
collection_createalias <- function(conn, alias, collections, raw = FALSE, callopts = list()) {
  conn$collection_createalias(alias, collections, raw, callopts)
}
