#' Update documents from R objects
#' 
#' @export
#' @template update
#' @family update
#' @param x Input, only data.frame supported right now
#' @details Note that you have to have a unique field named \code{id}
#' for each document. The example below already has that field. If you
#' don't have it, add it in.
#' @examples \dontrun{
#' file <- system.file("examples", "books.csv", package = "solr")
#' x <- read.csv(file)
#' class(x)
#' head(x)
#' update(x)
#' }
update <- function(x, commit = TRUE, wt = 'json',
                   raw = FALSE, base = 'http://localhost:8983', ...) {

  tfile <- tempfile(fileext = ".csv")
  write.csv(x, file = tfile, row.names = FALSE, quote = FALSE)
  update_csv(files = tfile, raw = raw, wt = wt, ...)
}
