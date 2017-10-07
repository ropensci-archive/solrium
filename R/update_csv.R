#' Update documents with CSV data
#'
#' @export
#' @family update
#' @template csvcreate
#' @param conn A solrium connection object, see [SolrClient]
#' @param files Path to a single file to load into Solr
#' @param name (character) Name of the core or collection
#' @param wt (character) One of json (default) or xml. If json, uses
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses
#' \code{\link[xml2]{read_xml}} to parse
#' @param raw (logical) If TRUE, returns raw data in format specified by
#' \code{wt} param
#' @param ... curl options passed on to [crul::HttpClient]
#' @note SOLR v1.2 was first version to support csv. See
#' \url{https://issues.apache.org/jira/browse/SOLR-66}
#' @examples \dontrun{
#' # start Solr in Schemaless mode: bin/solr start -e schemaless
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' path <- "~/solr-6.4.0/server/solr/newcore/conf"
#' dir.create(path, recursive = TRUE)
#' files <- list.files("~/solr-6.4.0/server/solr/configsets/data_driven_schema_configs/conf/",
#' full.names = TRUE)
#' invisible(file.copy(files, path, recursive = TRUE))
#' core_create(name = "books", instanceDir = "newcore", configSet = "basic_configs")
#'
#' df <- data.frame(id=1:3, name=c('red', 'blue', 'green'))
#' write.csv(df, file="df.csv", row.names=FALSE, quote = FALSE)
#' conn$update_csv("df.csv", "books", verbose = TRUE)
#'
#' # give back xml
#' update_csv("df.csv", "books", wt = "xml")
#' ## raw xml
#' update_csv("df.csv", "books", wt = "xml", raw = FALSE)
#' }
update_csv <- function(conn, files, name, separator = ',', header = TRUE,
  fieldnames = NULL, skip = NULL, skipLines = 0, trim = FALSE,
  encapsulator = NULL, escape = NULL, keepEmpty = FALSE, literal = NULL,
  map = NULL, split = NULL, rowid = NULL, rowidOffset = NULL, overwrite = NULL,
  commit = NULL, wt = 'json', raw = FALSE, ...) {
  
  conn$update_csv(files, name, separator, header, fieldnames, skip, 
                   skipLines, trim, encapsulator, escape, keepEmpty, literal,
                   map, split, rowid, rowidOffset, overwrite, commit, 
                   wt, raw, ...)
}
