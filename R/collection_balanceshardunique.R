#' @title Balance a property
#'
#' @description Insures that a particular property is distributed evenly
#' amongst the physical nodes that make up a collection. If the property
#' already exists on a replica, every effort is made to leave it there. If the
#' property is not on any replica on a shard one is chosen and the property
#' is added.
#'
#' @export
#' @inheritParams collection_create
#' @param property (character) Required. The property to balance. The literal
#' "property." is prepended to this property if not specified explicitly.
#' @param onlyactivenodes (logical) Normally, the property is instantiated
#' on active nodes only. If `FALSE`, then inactive nodes are also included
#' for distribution. Default: `TRUE`
#' @param shardUnique (logical) Something of a safety valve. There is one
#' pre-defined property (preferredLeader) that defaults this value to `TRUE`.
#' For all other properties that are balanced, this must be set to `TRUE` or
#' an error message is returned
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' # create collection
#' if (!conn$collection_exists("addrep")) {
#'   conn$collection_create(name = "mycollection")
#'   # OR: bin/solr create -c mycollection
#' }
#'
#' # balance preferredLeader property
#' conn$collection_balanceshardunique("mycollection", property = "preferredLeader")
#'
#' # examine cluster status
#' conn$collection_clusterstatus()$cluster$collections$mycollection
#' }
collection_balanceshardunique <- function(conn, name, property, onlyactivenodes = TRUE,
                                          shardUnique = NULL, raw = FALSE, ...) {
  conn$collection_balanceshardunique(name, property, onlyactivenodes,
                                     shardUnique, raw, ...)
}
