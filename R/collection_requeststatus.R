#' @title Get request status
#'
#' @description Request the status of an already submitted Asynchronous
#' Collection API call. This call is also used to clear up the stored statuses.
#'
#' @export
#' @param requestid (character) Required. The user defined request-id for the
#' request. This can be used to track the status of the submitted asynchronous
#' task. `-1` is a special request id which is used to cleanup the stored
#' states for all of the already completed/failed tasks.
#' @inheritParams collection_create
collection_requeststatus <- function(conn, requestid, raw = FALSE, ...) {
  conn$collection_requeststatus(requestid, raw, ...)
}
