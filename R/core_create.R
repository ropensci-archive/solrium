#' Create a core
#'
#' @export
#'
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) The name of the core to be created. Required
#' @param instanceDir (character) Path to instance directory
#' @param config (character) Path to config file
#' @param schema (character) Path to schema file
#' @param dataDir (character) Name of the data directory relative to
#' instanceDir.
#' @param configSet (character) Name of the configset to use for this core.
#' For more information, see
#' https://lucene.apache.org/solr/guide/6_6/config-sets.html
#' @param collection (character) The name of the collection to which this core
#' belongs. The default is the name of the core. collection.<param>=<val ue>
#' causes a property of <param>=<value> to be set if a new collection is being
#' created. Use collection.configNa me=<configname> to point to the
#' configuration for a new collection.
#' @param shard (character) The shard id this core represents. Normally you
#' want to be auto-assigned a shard id.
#' @param async	(character) Request ID to track this action which will be
#' processed asynchronously
#' @param raw (logical) If `TRUE`, returns raw data
#' @param callopts curl options passed on to [crul::HttpClient]
#' @param ... You can pass in parameters like `property.name=value`	to set
#' core property name to value. See the section Defining core.properties for
#' details on supported properties and values.
#' (https://lucene.apache.org/solr/guide/6_6/defining-core-properties.html)
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg:
#' #   bin/solr start -e schemaless
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or create as below
#'
#' # connect
#' (conn <- SolrClient$new())
#'
#' # Create a core
#' path <- "~/solr-7.0.0/server/solr/newcore/conf"
#' dir.create(path, recursive = TRUE)
#' files <- list.files("~/solr-7.0.0/server/solr/configsets/sample_techproducts_configs/conf/",
#' full.names = TRUE)
#' invisible(file.copy(files, path, recursive = TRUE))
#' conn$core_create(name = "newcore", instanceDir = "newcore",
#'   configSet = "sample_techproducts_configs")
#' }
core_create <- function(conn, name, instanceDir = NULL, config = NULL,
  schema = NULL, dataDir = NULL, configSet = NULL, collection = NULL,
  shard = NULL, async=NULL, raw = FALSE, callopts=list(), ...) {

  conn$core_create(name, instanceDir, config, schema, dataDir, configSet,
                   collection, shard, async, raw, callopts, ...)
}
