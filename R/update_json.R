#' Update documents using JSON
#' 
#' @export
#' @family update
#' @template update
#' @param files Path to file to load into Solr
#' @examples \dontrun{
#' # Add documents
#' file <- system.file("examples", "books2.json", package = "solr")
#' update_json(file)
#' 
#' # Update commands - can include many varying commands
#' ## Add file
#' file <- system.file("examples", "updatecommands_add.json", package = "solr")
#' update_json(file)
#' 
#' ## Delete file
#' file <- system.file("examples", "updatecommands_delete.json", package = "solr")
#' update_json(file)
#' }
update_json <- function(files, commit = TRUE, wt = 'json', 
                        raw = FALSE, base = 'http://localhost:8983', ...) {
  
  if (is.null(base)) stop("You must provide a url")
  args <- sc(list(commit = asl(commit), wt = 'json'))
  docreate(file.path(base, 'solr/update/json'), files, args, 'json', raw, ...)
}
