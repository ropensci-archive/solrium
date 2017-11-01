#' Update documents with JSON data
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
#' # Add documents
#' file <- system.file("examples", "books2.json", package = "solrium")
#' cat(readLines(file), sep = "\n")
#' conn$update_json(files = file, name = "books")
#' update_json(conn, files = file, name = "books")
#'
#' # Update commands - can include many varying commands
#' ## Add file
#' file <- system.file("examples", "updatecommands_add.json",
#'   package = "solrium")
#' cat(readLines(file), sep = "\n")
#' conn$update_json(file, "books")
#'
#' ## Delete file
#' file <- system.file("examples", "updatecommands_delete.json",
#'   package = "solrium")
#' cat(readLines(file), sep = "\n")
#' conn$update_json(file, "books")
#'
#' # Add and delete in the same document
#' ## Add a document first, that we can later delete
#' ss <- list(list(id = 456, name = "cat"))
#' conn$add(ss, "books")
#' }
update_json <- function(conn, files, name, commit = TRUE, optimize = FALSE,
  max_segments = 1, expunge_deletes = FALSE, wait_searcher = TRUE,
  soft_commit = FALSE, prepare_commit = NULL, wt = 'json', raw = FALSE, ...) {

	check_sr(conn)
  conn$update_json(files, name, commit, optimize, max_segments,
                   expunge_deletes, wait_searcher, soft_commit, prepare_commit,
                   wt, raw, ...)
}
