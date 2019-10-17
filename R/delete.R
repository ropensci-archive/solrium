#' Delete documents by ID or query
#'
#' @name delete
#' @param conn A solrium connection object, see [SolrClient]
#' @param ids Document IDs, one or more in a vector or list
#' @param name (character) A collection or core name. Required.
#' @param query Query to use to delete documents
#' @param commit (logical) If `TRUE`, documents immediately searchable.
#' Deafult: `TRUE`
#' @param commit_within (numeric) Milliseconds to commit the change, the
#' document will be added within that time. Default: `NULL`
#' @param overwrite (logical) Overwrite documents with matching keys.
#' Default: `TRUE`
#' @param boost (numeric) Boost factor. Default: `NULL`
#' @param wt (character) One of json (default) or xml. If json, uses
#' [jsonlite::fromJSON()] to parse. If xml, uses [xml2::read_xml()] to
#' parse
#' @param raw (logical) If `TRUE`, returns raw data in format specified by
#' `wt` param
#' @param ... curl options passed on to [crul::HttpClient]
#' @details We use json internally as data interchange format for this function.
#' @examples \dontrun{
#' (cli <- SolrClient$new())
#'
#' # add some documents first
#' ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
#' cli$add(ss, name = "gettingstarted")
#'
#' # Now, delete them
#' # Delete by ID
#' cli$delete_by_id(ids = 1, "gettingstarted")
#' ## Many IDs
#' cli$delete_by_id(ids = c(3, 4), "gettingstarted")
#'
#' # Delete by query
#' cli$delete_by_query(query = "title:animals", "gettingstarted")
#' }

#' @export
#' @name delete
delete_by_id <- function(conn, ids, name, commit = TRUE, commit_within = NULL,
  overwrite = TRUE, boost = NULL, wt = 'json', raw = FALSE, ...) {

	check_sr(conn)
  conn$delete_by_id(ids, name, commit, commit_within, overwrite, boost,
                    wt, raw, ...)
}

#' @export
#' @name delete
delete_by_query <- function(conn, query, name, commit = TRUE,
  commit_within = NULL, overwrite = TRUE, boost = NULL, wt = 'json',
  raw = FALSE, ...) {

  check_sr(conn)
  conn$delete_by_query(query, name, commit, commit_within, overwrite, boost,
                    wt, raw, ...)
}
