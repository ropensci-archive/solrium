#' Migrate documents to another collection
#'
#' @export
#' @inheritParams collection_create
#' @param target.collection (character) Required. The name of the target collection
#' to which documents will be migrated
#' @param split.key (character) Required. The routing key prefix. For example, if
#' uniqueKey is a!123, then you would use split.key=a!
#' @param forward.timeout (integer) The timeout (seconds), until which write requests
#' made to the source collection for the given \code{split.key} will be forwarded to the
#' target shard. Default: 60
#' @param async	(character) Request ID to track this action which will be processed
#' asynchronously
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#'
#' # create collection
#' if (!conn$collection_exists("migrate_from")) {
#'   conn$collection_create(name = "migrate_from")
#'   # OR: bin/solr create -c migrate_from
#' }
#'
#' # create another collection
#' if (!conn$collection_exists("migrate_to")) {
#'   conn$collection_create(name = "migrate_to")
#'   # OR bin/solr create -c migrate_to
#' }
#'
#' # add some documents
#' file <- system.file("examples", "books.csv", package = "solrium")
#' x <- read.csv(file, stringsAsFactors = FALSE)
#' conn$add(x, "migrate_from")
#'
#' # migrate some documents from one collection to the other
#' ## FIXME - not sure if this is actually working....
#' # conn$collection_migrate("migrate_from", "migrate_to", split.key = "05535")
#' }
collection_migrate <- function(conn, name, target.collection, split.key,
                               forward.timeout = NULL, async = NULL,
                               raw = FALSE, callopts = list()) {
  conn$collection_migrate(name, target.collection, split.key,
                          forward.timeout, async, raw = FALSE, callopts)
}
