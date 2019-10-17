#' Update documents with CSV data
#'
#' @export
#' @family update
#' @template csvcreate
#' @param conn A solrium connection object, see [SolrClient]
#' @param files Path to a single file to load into Solr
#' @param name (character) Name of the core or collection
#' @param wt (character) One of json (default) or xml. If json, uses
#' [jsonlite::fromJSON()] to parse. If xml, uses [xml2::read_xml()] to parse
#' @param raw (logical) If `TRUE`, returns raw data in format specified by
#' `wt` param
#' @param ... curl options passed on to [crul::HttpClient]
#' @note SOLR v1.2 was first version to support csv. See
#' https://issues.apache.org/jira/browse/SOLR-66
#' @examples \dontrun{
#' # start Solr: bin/solr start -f -c -p 8983
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' if (!conn$collection_exists("helloWorld")) {
#'   conn$collection_create(name = "helloWorld", numShards = 2)
#' }
#'
#' df <- data.frame(id=1:3, name=c('red', 'blue', 'green'))
#' write.csv(df, file="df.csv", row.names=FALSE, quote = FALSE)
#' conn$update_csv("df.csv", "helloWorld", verbose = TRUE)
#'
#' # give back raw xml
#' conn$update_csv("df.csv", "helloWorld", wt = "xml")
#' ## raw json
#' conn$update_csv("df.csv", "helloWorld", wt = "json", raw = TRUE)
#' }
update_csv <- function(conn, files, name, separator = ',', header = TRUE,
  fieldnames = NULL, skip = NULL, skipLines = 0, trim = FALSE,
  encapsulator = NULL, escape = NULL, keepEmpty = FALSE, literal = NULL,
  map = NULL, split = NULL, rowid = NULL, rowidOffset = NULL, overwrite = NULL,
  commit = NULL, wt = 'json', raw = FALSE, ...) {

  check_sr(conn)
  conn$update_csv(files, name, separator, header, fieldnames, skip,
                   skipLines, trim, encapsulator, escape, keepEmpty, literal,
                   map, split, rowid, rowidOffset, overwrite, commit,
                   wt, raw, ...)
}
