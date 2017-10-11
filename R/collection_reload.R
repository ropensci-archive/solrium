#' Reload a collection
#'
#' @export
#' @inheritParams collection_create
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#' conn$collection_create(name = "helloWorld")
#' conn$collection_reload(name = "helloWorld")
#' }
collection_reload <- function(conn, name, raw = FALSE, ...) {
  conn$collection_reload(raw, ...)
}
