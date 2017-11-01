#' List collections
#'
#' @export
#' @inheritParams ping
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' conn$collection_list()
#' conn$collection_list()$collections
#' collection_list(conn)
#' }
collection_list <- function(conn, raw = FALSE, ...) {
  conn$collection_list(raw = raw, ...)
}
