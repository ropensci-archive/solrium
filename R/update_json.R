#' Update documents using JSON
#' 
#' @export
#' @family update
#' @template update
#' @template commitcontrol
#' @param files Path to file to load into Solr
#' @examples \dontrun{
#' # Add documents
#' file <- system.file("examples", "books2.json", package = "solr")
#' cat(readLines(file), sep = "\n")
#' update_json(file)
#' 
#' # Update commands - can include many varying commands
#' ## Add file
#' file <- system.file("examples", "updatecommands_add.json", package = "solr")
#' cat(readLines(file), sep = "\n")
#' update_json(file)
#' 
#' ## Delete file
#' file <- system.file("examples", "updatecommands_delete.json", package = "solr")
#' cat(readLines(file), sep = "\n")
#' update_json(file)
#' 
#' # Add and delete in the same document
#' ## Add a document first, that we can later delete
#' ss <- list(list(id = 456, name = "cat"))
#' add(ss)
#' ## Now add a new document, and delete the one we just made
#' file <- system.file("examples", "add_delete.json", package = "solr")
#' cat(readLines(file), sep = "\n")
#' update_json(file)
#' }
update_json <- function(files, commit = TRUE, optimize = FALSE, max_segments = 1, 
                        expunge_deletes = FALSE, wait_searcher = TRUE, soft_commit = FALSE, 
                        prepare_commit = NULL, wt = 'json', raw = FALSE, 
                        base = 'http://localhost:8983', ...) {
  
  if (is.null(base)) stop("You must provide a url")
  args <- sc(list(commit = asl(commit), optimize = asl(optimize), maxSegments = max_segments,
                  expungeDeletes = asl(expunge_deletes), waitSearcher = asl(wait_searcher), 
                  softCommit = asl(soft_commit), prepareCommit = prepare_commit, wt = 'json'))
  docreate(file.path(base, 'solr/update/json'), files, args, 'json', raw, ...)
}
