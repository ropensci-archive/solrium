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
#' @param role (character) Required. The name of the role. The only supported role
#' as of now is overseer (set as default).
#' @param node (character) Required. The name of the node. It is possible to assign a
#' role even before that node is started.
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#'
#' # get list of nodes
#' nodes <- collection_clusterstatus()$cluster$live_nodes
#' collection_addrole(node = nodes[1])
#' }
collection_addrole <- function(role = "overseer", node, raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'ADDROLE', role = role, node = node, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
