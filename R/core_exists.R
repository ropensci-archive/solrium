#' Check if a core exists
#' 
#' @export
#' 
#' @param name (character) The name of the core. If not given, all cores.
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' @details Simply calls \code{\link{core_status}} internally
#' @return A single boolean, \code{TRUE} or \code{FALSE}
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg: bin/solr start -e schemaless
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#' 
#' # connect
#' solr_connect()
#' 
#' # exists
#' core_exists("gettingstarted")
#' 
#' # doesn't exist
#' core_exists("hhhhhh")
#' }
core_exists <- function(name, callopts=list()) {
  tmp <- suppressMessages(core_status(name = name, callopts = callopts))
  if (length(tmp$status[[1]]) > 0) {
    TRUE 
  } else {
    FALSE
  }
}
