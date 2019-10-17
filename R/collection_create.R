#' Add a collection
#'
#' @export
#' @param conn A solrium connection object, see [SolrClient]
#' @param name (character) The name of the core to be created. Required
#' @param numShards (integer) The number of shards to be created as part of the
#' collection. This is a required parameter when using the 'compositeId' router.
#' @param maxShardsPerNode (integer) When creating collections, the shards and/or replicas
#' are spread across all available (i.e., live) nodes, and two replicas of the same shard
#' will never be on the same node. If a node is not live when the CREATE operation is called,
#' it will not get any parts of the new collection, which could lead to too many replicas
#' being created on a single live node. Defining maxShardsPerNode sets a limit on the number
#' of replicas CREATE will spread to each node. If the entire collection can not be fit into
#' the live nodes, no collection will be created at all. Default: 1
#' @param createNodeSet (logical) Allows defining the nodes to spread the new collection
#' across. If not provided, the CREATE operation will create shard-replica spread across all
#' live Solr nodes. The format is a comma-separated list of node_names, such as
#' localhost:8983_solr, localhost:8984_solr, localhost:8985_solr. Default: `NULL`
#' @param collection.configName (character) Defines the name of the configurations (which
#' must already be stored in ZooKeeper) to use for this collection. If not provided, Solr
#' will default to the collection name as the configuration name. Default: `compositeId`
#' @param replicationFactor (integer) The number of replicas to be created for each shard.
#' Default: 1
#' @param router.name (character) The router name that will be used. The router defines
#' how documents will be distributed among the shards. The value can be either `implicit`,
#' which uses an internal default hash, or `compositeId`, which allows defining the specific
#' shard to assign documents to. When using the 'implicit' router, the shards parameter is
#' required. When using the 'compositeId' router, the numShards parameter is required.
#' For more information, see also the section Document Routing. Default: `compositeId`
#' @param shards (character) A comma separated list of shard names, e.g.,
#' shard-x,shard-y,shard-z . This is a required parameter when using the 'implicit' router.
#' @param createNodeSet.shuffle	(logical)	Controls whether or not the shard-replicas created
#' for this collection will be assigned to the nodes specified by the createNodeSet in a
#' sequential manner, or if the list of nodes should be shuffled prior to creating individual
#' replicas.  A 'false' value makes the results of a collection creation predictible and
#' gives more exact control over the location of the individual shard-replicas, but 'true'
#' can be a better choice for ensuring replicas are distributed evenly across nodes. Ignored
#' if createNodeSet is not also specified. Default: `TRUE`
#' @param router.field (character) If this field is specified, the router will look at the
#' value of the field in an input document to compute the hash and identify a shard instead of
#' looking at the uniqueKey field. If the field specified is null in the document, the document
#' will be rejected. Please note that RealTime Get or retrieval by id would also require the
#' parameter _route_ (or shard.keys) to avoid a distributed search.
#' @param autoAddReplicas	(logical)	When set to true, enables auto addition of replicas on
#' shared file systems. See the section autoAddReplicas Settings for more details on settings
#' and overrides. Default: `FALSE`
#' @param async	(character) Request ID to track this action which will be processed
#' asynchronously
#' @param raw (logical) If `TRUE`, returns raw data
#' @param callopts curl options passed on to [crul::HttpClient]
#' @param ... You can pass in parameters like `property.name=value`	to set
#' core property name to value. See the section Defining core.properties for
#' details on supported properties and values.
#' (https://lucene.apache.org/solr/guide/8_2/defining-core-properties.html)
#' @examples \dontrun{
#' # connect
#' (conn <- SolrClient$new())
#'
#' if (!conn$collection_exists("helloWorld")) {
#'   conn$collection_create(name = "helloWorld")
#' }
#' if (!conn$collection_exists("tablesChairs")) {
#'   conn$collection_create(name = "tablesChairs")
#' }
#' }
collection_create <- function(conn, name, numShards = 1, maxShardsPerNode = 1,
                       createNodeSet = NULL, collection.configName = NULL,
                       replicationFactor = 1, router.name = NULL, shards = NULL,
                       createNodeSet.shuffle = TRUE, router.field = NULL,
                       autoAddReplicas = FALSE, async = NULL,
                       raw = FALSE, callopts=list(), ...) {

  conn$collection_create(
    name, numShards = numShards, maxShardsPerNode = maxShardsPerNode,
    createNodeSet = createNodeSet, collection.configName = collection.configName,
    replicationFactor = replicationFactor, router.name = router.name,
    shards = shards, createNodeSet.shuffle = createNodeSet.shuffle,
    router.field = router.field, autoAddReplicas = autoAddReplicas, async = async,
    raw = raw, callopts = callopts, ...)
}
