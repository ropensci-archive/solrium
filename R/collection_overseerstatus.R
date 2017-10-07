#' @title Get overseer status
#'
#' @description Returns the current status of the overseer, performance 
#' statistics of various overseer APIs as well as last 10 failures per 
#' operation type.
#'
#' @export
#' @inheritParams collection_create
#' @examples \dontrun{
#' (conn <- SolrClient$new())
#' conn$collection_overseerstatus()
#' res <- conn$collection_overseerstatus()
#' res$responseHeader
#' res$leader
#' res$overseer_queue_size
#' res$overseer_work_queue_size
#' res$overseer_operations
#' res$collection_operations
#' res$overseer_queue
#' res$overseer_internal_queue
#' res$collection_queue
#' }
collection_overseerstatus <- function(conn, raw = FALSE, ...) {
  conn$collection_overseerstatus(raw, ...)
}
