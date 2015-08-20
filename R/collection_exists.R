#' Check if a collection exists
#' 
#' @export
#' 
#' @param name (character) The name of the core. If not given, all cores.
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @details Simply calls \code{\link{collection_list}} internally
#' @return A single boolean, \code{TRUE} or \code{FALSE}
#' @examples \dontrun{
#' # start Solr with Cloud mode via the schemaless eg: bin/solr -e cloud
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#' 
#' # connect
#' solr_connect()
#' 
#' # exists
#' collection_exists("gettingstarted")
#' 
#' # doesn't exist
#' collection_exists("hhhhhh")
#' }
collection_exists <- function(name, ...) {
  tmp <- suppressMessages(collection_list(...))$collections
  if (name %in% tmp) {
    TRUE 
  } else {
    FALSE
  }
}
