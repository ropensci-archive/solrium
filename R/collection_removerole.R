#' @title Remove a role from a node
#'
#' @description Remove an assigned role. This API is used to undo the roles
#' assigned using \code{\link{collection_addrole}}
#'
#' @export
#' @param role (character) Required. The name of the role. The only supported
#' role as of now is overseer (set as default).
#' @param node (character) Required. The name of the node.
#' @inheritParams collection_create
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' # get list of nodes
#' nodes <- conn$collection_clusterstatus()$cluster$live_nodes
#' conn$collection_addrole(node = nodes[1])
#' conn$collection_removerole(node = nodes[1])
#' }
collection_removerole <- function(conn, role = "overseer", node, raw = FALSE, 
                                  ...) {
  conn$collection_removerole(role, node, raw, ...)
}
