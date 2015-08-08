#' Delete documents by ID or query
#' 
#' @name delete
#' @param ids Document IDs, one or more in a vector or list
#' @param query Query to use to delete documents
#' @param commit (logical) If \code{TRUE}, documents immediately searchable. 
#' Deafult: \code{TRUE}
#' @param commit_within (numeric) Milliseconds to commit the change, the document will be added 
#' within that time. Default: NULL
#' @param overwrite (logical) Overwrite documents with matching keys. Default: \code{TRUE}
#' @param boost (numeric) Boost factor. Default: NULL 
#' @param wt (character) One of json (default) or xml. If json, uses 
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to 
#' parse
#' @param raw (logical) If \code{TRUE}, returns raw data in format specified by 
#' \code{wt} param
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' conn <- solr_connect()
#' 
#' # Delete by ID
#' # delete_by_id(conn, ids = 9)
#' ## Many IDs
#' # delete_by_id(conn, ids = c(3, 4))
#' 
#' # Delete by query
#' # delete_by_query(conn, query = "manu:bank")
#' }

#' @export
#' @name delete
delete_by_id <- function(conn, ids, commit = TRUE, commit_within = NULL, overwrite = TRUE, 
                         boost = NULL, wt = 'json', raw = FALSE, ...) {
  
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(commit = asl(commit), wt = 'json'))
  body <- list(delete = lapply(ids, function(z) list(id = z)))
  obj_proc(file.path(conn$url, 'solr/update/json'), body, args, raw, conn$proxy, ...)
}

#' @export
#' @name delete
delete_by_query <- function(conn, query, commit = TRUE, commit_within = NULL, overwrite = TRUE, 
                            boost = NULL, wt = 'json', raw = FALSE, ...) {
  
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(commit = asl(commit), wt = 'json'))
  body <- list(delete = list(query = query))
  obj_proc(file.path(conn$url, 'solr/update/json'), body, args, raw, conn$proxy, ...)
}
