#' Update documents using CSV
#' 
#' @export
#' @family update
#' @template csvcreate
#' @param files Path to file to load into Solr
#' @param name (character) Name of the core or collection
#' @param wt (character) One of json (default) or xml. If json, uses 
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to parse
#' @param raw (logical) If TRUE, returns raw data in format specified by wt param
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @note SOLR v1.2 was first version to support csv. See 
#' \url{https://issues.apache.org/jira/browse/SOLR-66}
#' @examples \dontrun{
#' # start Solr in Schemaless mode: bin/solr start -e schemaless
#' 
#' # connect
#' solr_connect()
#' 
#' df <- data.frame(id=1:3, name=c('red', 'blue', 'green'))
#' write.csv(df, file="df.csv", row.names=FALSE, quote = FALSE)
#' update_csv("df.csv", "books")
#' 
#' # give back xml
#' update_csv("df.csv", "books", wt = "xml")
#' ## raw xml
#' update_csv("df.csv", "books", wt = "xml", raw = FALSE)
#' }
update_csv <- function(files, name, separator = ',', header = TRUE,
                       fieldnames = NULL, skip = NULL, skipLines = 0, trim = FALSE, 
                       encapsulator = NULL, escape = NULL, keepEmpty = FALSE, literal = NULL,
                       map = NULL, split = NULL, rowid = NULL, rowidOffset = NULL, overwrite = NULL,
                       commit = NULL, wt = 'json', raw = FALSE, ...) {
  
  conn <- solr_settings()
  check_conn(conn)
  stop_if_absent(name)
  if (!is.null(fieldnames)) fieldnames <- paste0(fieldnames, collapse = ",")
  args <- sc(list(separator = separator, header = header, fieldnames = fieldnames, skip = skip, 
                  skipLines = skipLines, trim = trim, encapsulator = encapsulator, escape = escape, 
                  keepEmpty = keepEmpty, literal = literal, map = map, split = split, 
                  rowid = rowid, rowidOffset = rowidOffset, overwrite = overwrite,
                  commit = commit, wt = wt))
  docreate(file.path(conn$url, sprintf('solr/%s/update/csv', name)), files, args, content = "csv", raw, ...)
}
