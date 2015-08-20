#' List collections or cores
#' 
#' @name collections
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @details Calls \code{\link{collection_list}} or \code{\link{core_status}} internally, 
#' and parses out names for you.
#' @return A character vector
#' @examples \dontrun{
#' # connect
#' solr_connect(verbose = FALSE)
#' 
#' # list collections
#' collections()
#' 
#' # list cores
#' cores()
#' 
#' # curl options
#' library("httr")
#' collections(config = verbose())
#' }

#' @export
#' @rdname collections
collections <- function(...) {
  collection_list(...)$collections
}

#' @export
#' @rdname collections
cores <- function(...) {
  names(core_status(...)$status)
}
