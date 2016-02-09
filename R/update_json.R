#' Update documents using JSON
#'
#' @export
#' @family update
#' @template update
#' @template commitcontrol
#' @param files Path to file to load into Solr
#' @examples \dontrun{
#' # start Solr in Schemaless mode: bin/solr start -e schemaless
#' 
#' # connect
#' solr_connect()
#'
#' # Add documents
#' file <- system.file("examples", "books2.json", package = "solrium")
#' cat(readLines(file), sep = "\n")
#' update_json(file, "books")
#'
#' # Update commands - can include many varying commands
#' ## Add file
#' file <- system.file("examples", "updatecommands_add.json", package = "solrium")
#' cat(readLines(file), sep = "\n")
#' update_json(file, "books")
#'
#' ## Delete file
#' file <- system.file("examples", "updatecommands_delete.json", package = "solrium")
#' cat(readLines(file), sep = "\n")
#' update_json(file, "books")
#'
#' # Add and delete in the same document
#' ## Add a document first, that we can later delete
#' ss <- list(list(id = 456, name = "cat"))
#' add(ss, "books")
#' ## Now add a new document, and delete the one we just made
#' file <- system.file("examples", "add_delete.json", package = "solrium")
#' cat(readLines(file), sep = "\n")
#' update_json(file, "books")
#' }
update_json <- function(files, name, commit = TRUE, optimize = FALSE, max_segments = 1,
                        expunge_deletes = FALSE, wait_searcher = TRUE, soft_commit = FALSE,
                        prepare_commit = NULL, wt = 'json', raw = FALSE, ...) {

  conn <- solr_settings()
  check_conn(conn)
  #stop_if_absent(name)
  args <- sc(list(commit = asl(commit), optimize = asl(optimize), maxSegments = max_segments,
                  expungeDeletes = asl(expunge_deletes), waitSearcher = asl(wait_searcher),
                  softCommit = asl(soft_commit), prepareCommit = prepare_commit, wt = wt))
  docreate(file.path(conn$url, sprintf('solr/%s/update/json/docs', name)), files, args, 'json', raw, ...)
}
