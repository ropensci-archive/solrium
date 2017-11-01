#' Update documents with XML data
#'
#' @export
#' @family update
#' @template update
#' @template commitcontrol
#' @param conn A solrium connection object, see [SolrClient]
#' @param files Path to a single file to load into Solr
#' @examples \dontrun{
#' # start Solr: bin/solr start -f -c -p 8983
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' # create a collection
#' if (!conn$collection_exists("books")) {
#'   conn$collection_create(name = "books", numShards = 2)
#' }
#'
#' # Add documents
#' file <- system.file("examples", "books.xml", package = "solrium")
#' cat(readLines(file), sep = "\n")
#' conn$update_xml(file, "books")
#'
#' # Update commands - can include many varying commands
#' ## Add files
#' file <- system.file("examples", "books2_delete.xml", package = "solrium")
#' cat(readLines(file), sep = "\n")
#' conn$update_xml(file, "books")
#'
#' ## Delete files
#' file <- system.file("examples", "updatecommands_delete.xml",
#' package = "solrium")
#' cat(readLines(file), sep = "\n")
#' conn$update_xml(file, "books")
#'
#' ## Add and delete in the same document
#' ## Add a document first, that we can later delete
#' ss <- list(list(id = 456, name = "cat"))
#' conn$add(ss, "books")
#' ## Now add a new document, and delete the one we just made
#' file <- system.file("examples", "add_delete.xml", package = "solrium")
#' cat(readLines(file), sep = "\n")
#' conn$update_xml(file, "books")
#' }
update_xml <- function(conn, files, name, commit = TRUE, optimize = FALSE,
  max_segments = 1, expunge_deletes = FALSE, wait_searcher = TRUE,
  soft_commit = FALSE, prepare_commit = NULL, wt = 'json', raw = FALSE, ...) {

	check_sr(conn)
  conn$update_xml(files, name, commit, optimize, max_segments,
                  expunge_deletes, wait_searcher, soft_commit, prepare_commit,
                  wt, raw, ...)
}
