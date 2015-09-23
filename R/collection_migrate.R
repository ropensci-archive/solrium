#' Migrate documents to another collection
#'
#' @export
#' @param name (character) Required. The name of the source collection from which
#' documents will be split
#' @param target.collection (character) Required. The name of the target collection
#' to which documents will be migrated
#' @param split.key (character) Required. The routing key prefix. For example, if
#' uniqueKey is a!123, then you would use split.key=a!
#' @param forward.timeout (integer) The timeout (seconds), until which write requests
#' made to the source collection for the given \code{split.key} will be forwarded to the
#' target shard. Default: 60
#' @param async	(character) Request ID to track this action which will be processed
#' asynchronously
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#'
#' # create collection
#' collection_create(name = "migrate_from") # bin/solr create -c migrate_from
#'
#' # create another collection
#' collection_create(name = "migrate_to") # bin/solr create -c migrate_to
#'
#' # add some documents
#' file <- system.file("examples", "books.csv", package = "solr")
#' x <- read.csv(file, stringsAsFactors = FALSE)
#' add(x, "migrate_from")
#'
#' # migrate some documents from one collection to the other
#' ## FIXME - not sure if this is actually working....
#' collection_migrate("migrate_from", "migrate_to", split.key = "05535")
#' }
collection_migrate <- function(name, target.collection, split.key, forward.timeout = NULL,
                               async = NULL, raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'MIGRATE', collection = name, target.collection = target.collection,
                  split.key = split.key, forward.timeout = forward.timeout,
                  async = async, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
