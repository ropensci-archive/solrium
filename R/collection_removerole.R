#' @title Remove a role from a node
#'
#' @description Remove an assigned role. This API is used to undo the roles
#' assigned using \code{\link{collection_addrole}}
#'
#' @export
#' @param role (character) Required. The name of the role. The only supported role
#' as of now is overseer (set as default).
#' @param node (character) Required. The name of the node.
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#'
#' # get list of nodes
#' nodes <- collection_clusterstatus()$cluster$live_nodes
#' collection_addrole(node = nodes[1])
#' collection_removerole(node = nodes[1])
#' }
collection_removerole <- function(role = "overseer", node, raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'REMOVEROLE', role = role, node = node, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
