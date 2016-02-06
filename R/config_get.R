#' Get Solr configuration details
#' 
#' @export
#' 
#' @param name (character) The name of the core. If not given, all cores.
#' @param what (character) What you want to look at. One of solrconfig or
#' schema. Default: solrconfig
#' @param wt (character) One of json (default) or xml. Data type returned.
#' If json, uses \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses
#' \code{\link[XML]{xmlParse}} to parse.
#' @param raw (logical) If \code{TRUE}, returns raw data in format specified by 
#' \code{wt}
#' @param ... curl options passed on to \code{\link[httr]{GET}}
#' @return A list, XMLInternalDocument/XMLInternalElementNode, or character 
#' string.
#' @details Note that if \code{raw=TRUE}, \code{what} is ignored. That is, 
#' you get all the data when \code{raw=TRUE}.
#' @examples \dontrun{
#' # start Solr with Cloud mode via the schemaless eg: bin/solr -e cloud
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#' 
#' # connect
#' solr_connect()
#' 
#' # all config settings
#' config_get("gettingstarted")
#' 
#' # just znodeVersion
#' config_get("gettingstarted", "znodeVersion")
#' 
#' # just znodeVersion
#' config_get("gettingstarted", "luceneMatchVersion")
#' 
#' # just updateHandler
#' config_get("gettingstarted", "updateHandler")
#' 
#' # just updateHandler
#' config_get("gettingstarted", "requestHandler")
#' 
#' ## Get XML
#' config_get("gettingstarted", wt = "xml")
#' config_get("gettingstarted", "updateHandler", wt = "xml")
#' config_get("gettingstarted", "requestHandler", wt = "xml")
#' 
#' ## Raw data - what param ignored when raw=TRUE
#' config_get("gettingstarted", raw = TRUE)
#' }
config_get <- function(name, what = NULL, wt = "json", raw = FALSE, ...) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(wt = wt))
  res <- solr_GET(file.path(conn$url, sprintf('solr/%s/config', name)), args, conn$proxy, ...)
  config_parse(res, what, wt, raw)
}

config_parse <- function(x, what = NULL, wt, raw) {
  if (raw) {
    return(x)
  } else {
    switch(wt, 
           json = {
             tt <- jsonlite::fromJSON(x)
             if (is.null(what)) {
               tt
             } else {
               tt$config[what]
             }
           },
           xml = {
             tt <- XML::xmlParse(x)
             if (is.null(what)) {
               tt
             } else {
               XML::xpathSApply(tt, sprintf('//lst[@name="%s"]', what))
             }
           }
    )
  } 
}
