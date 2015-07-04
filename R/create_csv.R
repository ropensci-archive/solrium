#' Create documents from a CSV file
#' 
#' @export
#' @template csvcreate
#' @param base (character) URL endpoint. This is different from the other functions in that we aren't 
#' hitting a search endpoint. Pass in here 
#' @param files Path to file to load into Solr
#' @param wt (character) One of json (default) or xml. If json, uses 
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to parse
#' @param verbose If TRUE (default) the url call used printed to console.
#' @param raw (logical) If TRUE, returns raw data in format specified by wt param
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' mtcars <- data.frame(id=1:NROW(mtcars), mtcars)
#' write.csv(mtcars[,1:3], file="~/mtcars.csv", row.names=FALSE, quote = FALSE)
#' create_csv(files = "~/mtcars.csv")
#' }
create_csv <- function(base = 'http://localhost:8983', files, separator = ',', header = TRUE,
                       fieldnames = NULL, skip = NULL, skipLines = 0, trim = FALSE, 
                       encapsulator = NULL, escape = NULL, keepEmpty = FALSE, literal = NULL,
                       map = NULL, split = NULL, rowid = NULL, rowidOffset = NULL, overwrite = NULL,
                       commit = NULL, wt = 'json', verbose = TRUE, raw = FALSE, 
                       callopts = list()) {
  
  if (is.null(base)) stop("You must provide a url")
  if (!is.null(fieldnames)) fieldnames <- paste0(fieldnames, collapse = ",")
  args <- sc(list(separator = separator, header = header, fieldnames = fieldnames, skip = skip, 
                  skipLines = skipLines, trim = trim, encapsulator = encapsulator, escape = escape, 
                  keepEmpty = keepEmpty, literal = literal, map = map, split = split, 
                  rowid = rowid, rowidOffset = rowidOffset, overwrite = overwrite,
                  commit = commit, wt = 'json'))
  docreate(file.path(base, 'solr/update/csv'), files, args, content = "csv", callopts, verbose, raw)
}
