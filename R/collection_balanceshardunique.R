#' @title Balance a property
#'
#' @description Insures that a particular property is distributed evenly amongst the
#' physical nodes that make up a collection. If the property already exists on a replica,
#' every effort is made to leave it there. If the property is not on any replica on a
#' shard one is chosen and the property is added.
#'
#' @export
#' @param name (character) Required. The name of the collection to balance the property in
#' @param property (character) Required. The property to balance. The literal "property."
#' is prepended to this property if not specified explicitly.
#' @param onlyactivenodes (logical) Normally, the property is instantiated on active
#' nodes only. If \code{FALSE}, then inactive nodes are also included for distribution.
#' Default: \code{TRUE}
#' @param shardUnique (logical) Something of a safety valve. There is one pre-defined
#' property (preferredLeader) that defaults this value to \code{TRUE}. For all other
#' properties that are balanced, this must be set to \code{TRUE} or an error message is
#' returned
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#'
#' # create collection
#' collection_create(name = "mycollection") # bin/solr create -c mycollection
#'
#' # balance preferredLeader property
#' collection_balanceshardunique("mycollection", property = "preferredLeader")
#'
#' # examine cluster status
#' collection_clusterstatus()$cluster$collections$mycollection
#' }
collection_balanceshardunique <- function(name, property, onlyactivenodes = TRUE,
                                          shardUnique = NULL, raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'BALANCESHARDUNIQUE', collection = name, property = property,
                  onlyactivenodes = asl(onlyactivenodes), shardUnique = asl(shardUnique),
                  wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
