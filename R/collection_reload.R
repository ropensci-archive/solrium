#' Reload a collection
#'
#' @export
#' @inheritParams collection_create
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' if (!conn$collection_exists("helloWorld")) {
#'   conn$collection_create(name = "helloWorld")
#' }
#'
#' conn$collection_reload(name = "helloWorld")
#' }
collection_reload <- function(conn, name, raw = FALSE, callopts) {
  conn$collection_reload(name, raw, callopts)
}
