#' Update documents using XML
#' 
#' @export
#' @family update
#' @template update
#' @template commitcontrol
#' @param files Path to file to load into Solr
#' @examples \dontrun{
#' # Add documents
#' file <- system.file("examples", "books.xml", package = "solr")
#' cat(readLines(file), sep = "\n")
#' update_xml(file)
#' 
#' # Update commands - can include many varying commands
#' ## Add files
#' file <- system.file("examples", "books2_delete.xml", package = "solr")
#' cat(readLines(file), sep = "\n")
#' update_xml(file)
#' 
#' ## Delete files
#' file <- system.file("examples", "updatecommands_delete.xml", package = "solr")
#' cat(readLines(file), sep = "\n")
#' update_xml(file)
#' 
#' ## Add and delete in the same document
#' ## Add a document first, that we can later delete
#' ss <- list(list(id = 456, name = "cat"))
#' add(ss)
#' ## Now add a new document, and delete the one we just made
#' file <- system.file("examples", "add_delete.xml", package = "solr")
#' cat(readLines(file), sep = "\n")
#' update_xml(file)
#' }
update_xml <- function(files, commit = TRUE, optimize = FALSE, max_segments = 1, 
                       expunge_deletes = FALSE, wait_searcher = TRUE, soft_commit = FALSE, 
                       prepare_commit = NULL, wt = 'json', raw = FALSE, 
                       base = 'http://localhost:8983', ...) {
  
  if (is.null(base)) stop("You must provide a url")
  args <- sc(list(commit = asl(commit), optimize = asl(optimize), maxSegments = max_segments,
                  expungeDeletes = asl(expunge_deletes), waitSearcher = asl(wait_searcher), 
                  softCommit = asl(soft_commit), prepareCommit = prepare_commit, wt = 'json'))
  docreate(file.path(base, 'solr/update'), files, args, 'xml', raw, ...)
}
