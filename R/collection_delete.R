#' Add a collection
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) The name of the core to be created. Required
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#' conn$collection_create(name = "helloWorld")
#' conn$collection_delete(name = "helloWorld")
#' }
collection_delete <- function(conn, name, raw = FALSE, ...) {
  conn$collection_delete(name, raw, ...)
}
