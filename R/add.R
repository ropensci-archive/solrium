#' Add documents from R objects
#' 
#' @param x Documents, either as rows in a data.frame, or a list.
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
#' # Documents in a list
#' ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
#' add(x = ss)
#' 
#' # Documents in a data.frame
#' df <- data.frame(id = c(67, 68), price = c(1000, 500000000))
#' add(x = df)
#' }
add <- function(x, commit = TRUE, wt = 'json', raw = FALSE, base = 'http://localhost:8983', ...) {
  UseMethod("add")
}

#' @export
add.list <- function(x, commit = TRUE, wt = 'json', raw = FALSE, base = 'http://localhost:8983', ...) {
  if (is.null(base)) stop("You must provide a url")
  args <- sc(list(commit = asl(commit), wt = 'json'))
  obj_proc(file.path(base, 'solr/update/json'), x, args, raw, ...)
}

#' @export
add.data.frame <- function(x, commit = TRUE, wt = 'json', raw = FALSE, base = 'http://localhost:8983', ...) {
  if (is.null(base)) stop("You must provide a url")
  args <- sc(list(commit = asl(commit), wt = 'json'))
  x <- apply(x, 1, as.list)
  obj_proc(file.path(base, 'solr/update/json'), x, args, raw, ...)
}
