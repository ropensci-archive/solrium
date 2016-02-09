#' Add documents from R objects
#' 
#' @export
#' @param x Documents, either as rows in a data.frame, or a list.
#' @param name (character) A collection or core name. Required.
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
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' 
#' @details Works for Collections as well as Cores (in SolrCloud and Standalone 
#' modes, respectively)
#' 
#' @seealso \code{\link{update_json}}, \code{\link{update_xml}}, 
#' \code{\link{update_csv}} for adding documents from files
#' 
#' @examples \dontrun{
#' solr_connect()
#' 
#' # create the boooks collection
#' if (!collection_exists("books")) {
#'   collection_create(name = "books", numShards = 2)
#' }
#' 
#' # Documents in a list
#' ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
#' add(ss, name = "books")
#' 
#' # Documents in a data.frame
#' ## Simple example
#' df <- data.frame(id = c(67, 68), price = c(1000, 500000000))
#' add(x = df, "books")
#' df <- data.frame(id = c(77, 78), price = c(1, 2.40))
#' add(x = df, "books")
#' 
#' ## More complex example, get file from package examples
#' # start Solr in Schemaless mode first: bin/solr start -e schemaless
#' file <- system.file("examples", "books.csv", package = "solrium")
#' x <- read.csv(file, stringsAsFactors = FALSE)
#' class(x)
#' head(x)
#' if (!collection_exists("mybooks")) {
#'   collection_create(name = "mybooks", numShards = 2)
#' }
#' add(x, "mybooks")
#' 
#' # Use modifiers
#' add(x, "mybooks", commit_within = 5000)
#' 
#' # Get back XML instead of a list
#' ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
#' # parsed XML
#' add(ss, name = "books", wt = "xml")
#' # raw XML
#' add(ss, name = "books", wt = "xml", raw = TRUE)
#' }
add <- function(x, name, commit = TRUE, commit_within = NULL, overwrite = TRUE,
                boost = NULL, wt = 'json', raw = FALSE, ...) {
  UseMethod("add")
}

#' @export
add.list <- function(x, name, commit = TRUE, commit_within = NULL, 
                     overwrite = TRUE, boost = NULL, wt = 'json', raw = FALSE, ...) {
  
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(commit = asl(commit), commitWithin = commit_within, 
                  overwrite = asl(overwrite), wt = wt))
  if (!is.null(boost)) {
    x <- lapply(x, function(z) modifyList(z, list(boost = boost)))
  }
  obj_proc(file.path(conn$url, sprintf('solr/%s/update/json/docs', name)), x, args, raw, conn$proxy, ...)
}

#' @export
add.data.frame <- function(x, name, commit = TRUE, commit_within = NULL, 
                           overwrite = TRUE, boost = NULL, wt = 'json', raw = FALSE, ...) {
  
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(commit = asl(commit), commitWithin = commit_within, 
                  overwrite = asl(overwrite), wt = wt))
  if (!is.null(boost)) {
    x$boost <- boost
  }
  x <- apply(x, 1, as.list)
  obj_proc(file.path(conn$url, sprintf('solr/%s/update/json/docs', name)), x, args, raw, conn$proxy, ...)
}
