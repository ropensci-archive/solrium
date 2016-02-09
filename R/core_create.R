#' Create a core
#'
#' @export
#'
#' @param name (character) The name of the core to be created. Required
#' @param instanceDir (character) Path to instance directory
#' @param config (character) Path to config file
#' @param schema (character) Path to schema file
#' @param dataDir (character) Name of the data directory relative to instanceDir.
#' @param configSet (character) Name of the configset to use for this core. For more
#' information, see https://cwiki.apache.org/confluence/display/solr/Config+Sets
#' @param collection (character) The name of the collection to which this core belongs.
#' The default is the name of the core. collection.<param>=<val ue> causes a property of
#' <param>=<value> to be set if a new collection is being created. Use collection.configNa
#' me=<configname> to point to the configuration for a new collection.
#' @param shard (character) The shard id this core represents. Normally you want to be
#' auto-assigned a shard id.
#' @param async	(character) Request ID to track this action which will be
#' processed asynchronously
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' @param ... You can pass in parameters like \code{property.name=value}	to set
#' core property name to value. See the section Defining core.properties for details on
#' supported properties and values.
#' (https://cwiki.apache.org/confluence/display/solr/Defining+core.properties)
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg: bin/solr start -e schemaless
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or create as below
#'
#' # connect
#' solr_connect()
#'
#' # Create a core
#' path <- "~/solr-5.4.1/server/solr/newcore/conf"
#' dir.create(path, recursive = TRUE)
#' files <- list.files("~/solr-5.4.1/server/solr/configsets/data_driven_schema_configs/conf/",
#' full.names = TRUE)
#' file.copy(files, path, recursive = TRUE)
#' core_create(name = "newcore", instanceDir = "newcore", configSet = "basic_configs")
#' }
core_create <- function(name, instanceDir = NULL, config = NULL, schema = NULL, dataDir = NULL,
                        configSet = NULL, collection = NULL, shard = NULL, async = NULL,
                        raw = FALSE, callopts=list(), ...) {

  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'CREATE', name = name, instanceDir = instanceDir,
                  config = config, schema = schema, dataDir = dataDir,
                  configSet = configSet, collection = collection, shard = shard,
                  async = async, wt = 'json'))
  res <- solr_GET(file.path(conn$url, 'solr/admin/cores'), args, callopts, conn$proxy, ...)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}

