#' @title Add a role to a node
#'
#' @description Assign a role to a given node in the cluster. The only supported role
#' as of 4.7 is 'overseer' . Use this API to dedicate a particular node as Overseer.
#' Invoke it multiple times to add more nodes. This is useful in large clusters where
#' an Overseer is likely to get overloaded . If available, one among the list of
#' nodes which are assigned the 'overseer' role would become the overseer. The
#' system would assign the role to any other node if none of the designated nodes
#' are up and running
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param role (character) Required. The name of the role. The only supported role
#' as of now is overseer (set as default).
#' @param node (character) Required. The name of the node. It is possible to assign a
#' role even before that node is started.
#' @param raw (logical) If `TRUE`, returns raw data
#' @param ... curl options passed on to [crul::HttpClient]
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' # get list of nodes
#' nodes <- conn$collection_clusterstatus()$cluster$live_nodes
#' collection_addrole(conn, node = nodes[1])
#' }
collection_addrole <- function(conn, role = "overseer", node, raw = FALSE, ...) {
  conn$collection_addrole(role, node, raw, ...)
}
