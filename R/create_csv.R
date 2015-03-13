#' Create documents from a CSV file
#' 
#' @export
#' @template csvcreate
#' @examples \dontrun{
#' mtcars <- data.frame(id=1:NROW(mtcars), mtcars)
#' write.csv(mtcars[,1:3], file="~/mtcars.csv", row.names=FALSE, quote = FALSE)
#' create(files = "~/mtcars.csv")
#' }
create_csv <- function(base = 'http://localhost:8983', files, separator = ',', header = TRUE,
                       fieldnames = NULL, skip = NULL, skipLines = 0, trim = FALSE, 
                       encapsulator = NULL, escape = NULL, keepEmpty = FALSE, literal = NULL,
                       map = NULL, split = NULL, rowid = NULL, rowidOffset = NULL, overwrite = NULL,
                       commit = NULL, wt = 'json', verbose = TRUE, raw = FALSE, 
                       callopts = list()) {
  
  if(is.null(base)) stop("You must provide a url")
  args <- sc(list(separator = separator, header = header, fieldnames = fieldnames, skip = skip, 
                  skipLines = skipLines, trim = trim, encapsulator = encapsulator, escape = escape, 
                  keepEmpty = keepEmpty, literal = literal, map = map, split = split, 
                  rowid = rowid, rowidOffset = rowidOffset, overwrite = overwrite,
                  commit = commit, wt = 'json'))
  docreate(file.path(base, 'solr/update/csv'), files, args, content="csv", callopts, verbose, raw)
}
