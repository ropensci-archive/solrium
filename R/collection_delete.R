#' Add a collection
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) The name of the core to be created. Required
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param callopts curl options passed on to \code{\link[crul]{HttpClient}}
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' if (!conn$collection_exists("helloWorld")) {
#'   conn$collection_create(name = "helloWorld")
#' }
#'
#' collection_delete(conn, name = "helloWorld")
#' }
collection_delete <- function(conn, name, raw = FALSE, callopts = list()) {
  conn$collection_delete(name, raw, callopts)
}
