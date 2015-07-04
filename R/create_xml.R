#' Update documents using XML
#' 
#' @export
#' @family update
#' @param files Path to file to load into Solr
#' @param base (character) URL endpoint. This is different from the other functions in that we aren't 
#' hitting a search endpoint. Pass in here 
#' @param wt (character) One of json (default) or xml. If json, uses 
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to parse
#' @param verbose If TRUE (default) the url call used printed to console.
#' @param raw (logical) If TRUE, returns raw data in format specified by wt param
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' 
#' @details You likely may not be able to run this function against many public Solr 
#' services, but should work locally.
#' 
#' @examples \dontrun{
#' # Add documents
#' file <- system.file("examples", "books2.xml", package = "solr")
#' update_xml(file)
#' 
#' # Update commands - can include many varying commands
#' ## Add file
#' file <- system.file("examples", "books2_delete.xml", package = "solr")
#' update_xml(file)
#' 
#' ## Delete file
#' file <- system.file("examples", "updatecommands_delete.xml", package = "solr")
#' update_xml(file)
#' }
update_xml <- function(files, commit = TRUE, wt = 'json', verbose = TRUE, 
                       raw = FALSE, base = 'http://localhost:8983', ...) {
  
  if (is.null(base)) stop("You must provide a url")
  args <- sc(list(commit = asl(commit), wt = 'json'))
  docreate(file.path(base, 'solr/update'), files, args, 'xml', verbose, raw, ...)
}
