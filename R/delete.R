#' Delete documents by ID or query
#' 
#' @name delete
#' @param ids Document IDs, one or more in a vector or list
#' @param query Query to use to delete documents
#' @param commit (logical) If \code{TRUE}, documents immediately searchable. 
#' Deafult: \code{TRUE}
#' @param wt (character) One of json (default) or xml. If json, uses 
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to 
#' parse
#' @param raw (logical) If \code{TRUE}, returns raw data in format specified by 
#' \code{wt} param
#' @param base (character) URL endpoint. This is different from the other functions in 
#' that we aren't hitting a search endpoint. Pass in here 
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # Delete by ID
#' # delete_by_id(ids = 9)
#' ## Many IDs
#' # delete_by_id(ids = c(3, 4))
#' 
#' # Delete by query
#' # delete_by_query(query = "manu:bank")
#' }

#' @export
#' @name delete
delete_by_id <- function(ids, commit = TRUE, wt = 'json', raw = FALSE, base = 'http://localhost:8983', ...) {
  if (is.null(base)) stop("You must provide a url")
  args <- sc(list(commit = asl(commit), wt = 'json'))
  body <- list(delete = lapply(ids, function(z) list(id = z)))
  obj_proc(file.path(base, 'solr/update/json'), body, args, raw, ...)
}

#' @export
#' @name delete
delete_by_query <- function(query, commit = TRUE, wt = 'json', raw = FALSE, base = 'http://localhost:8983', ...) {
  if (is.null(base)) stop("You must provide a url")
  args <- sc(list(commit = asl(commit), wt = 'json'))
  body <- list(delete = list(query = query))
  obj_proc(file.path(base, 'solr/update/json'), body, args, raw, ...)
}

obj_proc <- function(url, body, args, raw, ...) {
  out <- structure(obj_POST(url, body, args, ...), class = "update", wt = args$wt)
  if (raw) {
    out
  } else {
    solr_parse(out) 
  }
}
