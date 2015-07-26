#' Update documents using CSV
#' 
#' @export
#' @family update
#' @template csvcreate
#' @param conn Connection object. Required.
#' @param files Path to file to load into Solr
#' @param wt (character) One of json (default) or xml. If json, uses 
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to parse
#' @param raw (logical) If TRUE, returns raw data in format specified by wt param
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @note SOLR v1.2 was first version to support csv. See 
#' \url{https://issues.apache.org/jira/browse/SOLR-66}
#' @examples \dontrun{
#' conn <- solr_connect()
#' 
#' mtcars <- data.frame(id=1:NROW(mtcars), mtcars)
#' write.csv(mtcars[,1:3], file="~/mtcars.csv", row.names=FALSE, quote = FALSE)
#' update_csv(conn, "~/mtcars.csv")
#' }
update_csv <- function(conn, files, separator = ',', header = TRUE,
                       fieldnames = NULL, skip = NULL, skipLines = 0, trim = FALSE, 
                       encapsulator = NULL, escape = NULL, keepEmpty = FALSE, literal = NULL,
                       map = NULL, split = NULL, rowid = NULL, rowidOffset = NULL, overwrite = NULL,
                       commit = NULL, wt = 'json', raw = FALSE, ...) {
  
  check_conn(conn)
  if (!is.null(fieldnames)) fieldnames <- paste0(fieldnames, collapse = ",")
  args <- sc(list(separator = separator, header = header, fieldnames = fieldnames, skip = skip, 
                  skipLines = skipLines, trim = trim, encapsulator = encapsulator, escape = escape, 
                  keepEmpty = keepEmpty, literal = literal, map = map, split = split, 
                  rowid = rowid, rowidOffset = rowidOffset, overwrite = overwrite,
                  commit = commit, wt = 'json'))
  docreate(file.path(conn$url, 'solr/update/csv'), files, args, content = "csv", raw, ...)
}
