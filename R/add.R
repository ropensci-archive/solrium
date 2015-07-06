#' Add documents from R objects
#' 
#' @param x Documents, either as rows in a data.frame, or a list.
#' @param commit (logical) If \code{TRUE}, documents immediately searchable. 
#' Default: \code{TRUE}
#' @param commit_within (numeric) Milliseconds to commit the change, the document will be added 
#' within that time. Default: NULL
#' @param overwrite (logical) Overwrite documents with matching keys. Default: \code{TRUE}
#' @param boost (numeric) Boost factor. Default: NULL
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
#' ## Simple example
#' df <- data.frame(id = c(67, 68), price = c(1000, 500000000))
#' add(x = df)
#' 
#' ## More complex example, get file from package examples
#' file <- system.file("examples", "books.csv", package = "solr")
#' x <- read.csv(file, stringsAsFactors = FALSE)
#' class(x)
#' head(x)
#' add(x)
#' 
#' # Use modifiers
#' add(x, commit_within = 5000)
#' }
add <- function(x, commit = TRUE, commit_within = NULL, overwrite = TRUE, boost = NULL, 
                wt = 'json', raw = FALSE, base = 'http://localhost:8983', ...) {
  UseMethod("add")
}

#' @export
add.list <- function(x, commit = TRUE, commit_within = NULL, overwrite = TRUE, boost = NULL, 
                     wt = 'json', raw = FALSE, base = 'http://localhost:8983', ...) {
  
  if (is.null(base)) stop("You must provide a url")
  args <- sc(list(commit = asl(commit), commitWithin = commit_within, 
                  overwrite = asl(overwrite), wt = 'json'))
  if (!is.null(boost)) {
    x <- lapply(x, function(z) modifyList(z, list(boost = boost)))
  }
  obj_proc(file.path(base, 'solr/update/json'), x, args, raw, ...)
}

#' @export
add.data.frame <- function(x, commit = TRUE, commit_within = NULL, overwrite = TRUE, boost = NULL, 
                           wt = 'json', raw = FALSE, base = 'http://localhost:8983', ...) {
  
  if (is.null(base)) stop("You must provide a url")
  args <- sc(list(commit = asl(commit), commitWithin = commit_within, 
                  overwrite = asl(overwrite), wt = 'json'))
  if (!is.null(boost)) {
    x$boost <- boost
  }
  x <- apply(x, 1, as.list)
  obj_proc(file.path(base, 'solr/update/json'), x, args, raw, ...)
}
