#' Update documents using XML
#' 
#' @export
#' @family update
#' @template update
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
