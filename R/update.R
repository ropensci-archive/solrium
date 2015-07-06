#' Update documents from R objects
#' 
#' @export
#' @template update
#' @family update
#' @param x Input, only data.frame supported right now
#' @examples \dontrun{
#' row.names(mtcars) <- NULL
#' mtcars <- data.frame(id = 1:NROW(mtcars), mtcars)
#' update(mtcars)
#' 
#' file <- system.file("examples", "books.csv", package = "solr")
#' x <- read.csv(file)
#' update(x)
#' }
update <- function(x, commit = TRUE, wt = 'json',
                   raw = FALSE, base = 'http://localhost:8983', ...) {

  tfile <- tempfile(fileext = ".csv")
  write.csv(x, file = tfile, row.names = FALSE, quote = FALSE)
  update_csv(files = tfile, raw = raw, wt = wt, ...)
}
