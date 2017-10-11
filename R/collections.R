#' List collections or cores
#'
#' @export
#' @inheritParams ping
#' @details Calls [collection_list()] or [core_status()] internally,
#' and parses out names for you.
#' @return character vector
#' @examples \dontrun{
#' # connect
#' (conn <- SolrClient$new())
#'
#' # list collections
#' conn$collection_list()
#' collections(conn)
#'
#' # list cores
#' conn$core_status()
#' cores(conn)
#' }
collections <- function(conn, ...) {
	check_sr(conn)
  as.character(conn$collection_list(...)$collections)
}

#' @export
#' @rdname collections
cores <- function(conn, ...) {
	check_sr(conn)
  names(conn$core_status(...)$status)
}
