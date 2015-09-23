#' @title Rebalance leaders
#'
#' @description Reassign leaders in a collection according to the preferredLeader
#' property across active nodes
#'
#' @export
#' @param name (character) Required. The name of the collection rebalance preferredLeaders on.
#' @param maxAtOnce (integer) The maximum number of reassignments to have queue up at once.
#' Values <=0 are use the default value Integer.MAX_VALUE. When this number is reached, the
#' process waits for one or more leaders to be successfully assigned before adding more
#' to the queue.
#' @param maxWaitSeconds (integer) Timeout value when waiting for leaders to be reassigned.
#' NOTE: if maxAtOnce is less than the number of reassignments that will take place,
#' this is the maximum interval that any single wait for at least one reassignment.
#' For example, if 10 reassignments are to take place and maxAtOnce is 1 and maxWaitSeconds
#' is 60, the upper bound on the time that the command may wait is 10 minutes. Default: 60
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' solr_connect()
#'
#' # create collection
#' collection_create(name = "mycollection2") # bin/solr create -c mycollection2
#'
#' # balance preferredLeader property
#' collection_balanceshardunique("mycollection2", property = "preferredLeader")
#'
#' # balance preferredLeader property
#' collection_rebalanceleaders("mycollection2")
#'
#' # examine cluster status
#' collection_clusterstatus()$cluster$collections$mycollection2
#' }
collection_rebalanceleaders <- function(name, maxAtOnce = NULL, maxWaitSeconds = NULL,
                                          raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'REBALANCELEADERS', collection = name, maxAtOnce = maxAtOnce,
                  maxWaitSeconds = maxWaitSeconds, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/collections'), args, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}
