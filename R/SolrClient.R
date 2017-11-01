#' Solr connection client
#'
#' @export
#' @param host (character) Host url. Deafault: 127.0.0.1
#' @param path (character) url path.
#' @param port (character/numeric) Port. Default: 8389
#' @param scheme (character) http scheme, one of http or https. Default: http
#' @param proxy List of arguments for a proxy connection, including one or
#' more of: url, port, username, password, and auth. See
#' [crul::proxy] for  help, which is used to construct the
#' proxy connection.
#' @param errors (character) One of `"simple"` or `"complete"`. Simple gives
#' http code and  error message on an error, while complete gives both http
#' code and error message, and stack trace, if available.
#'
#' @return Various output, see help files for each grouping of methods.
#'
#' @details `SolrClient` creates a R6 class object. The object is
#' not cloneable and is portable, so it can be inherited across packages
#' without complication.
#'
#' `SolrClient` is used to initialize a client that knows about your
#' Solr instance, with options for setting host, port, http scheme,
#' and simple vs. complete error reporting
#'
#' @section SolrClient methods:
#'
#' Each of these methods also has a matching standalone exported
#' function that you can use by passing in the connection object made
#' by calling `SolrClient$new()`. Also, see the docs for each method for
#' parameter definitions and their default values.
#'
#' * `ping(name, wt = 'json', raw = FALSE, ...)`
#' * `schema(name, what = '', raw = FALSE, ...)`
#' * `commit(name, expunge_deletes = FALSE, wait_searcher = TRUE,
#' soft_commit = FALSE, wt = 'json', raw = FALSE, ...)`
#' * `optimize(name, max_segments = 1, wait_searcher = TRUE,
#' soft_commit = FALSE, wt = 'json', raw = FALSE, ...)`
#' * `config_get(name, what = NULL, wt = "json", raw = FALSE, ...)`
#' * `config_params(name, param = NULL, set = NULL, unset = NULL,
#' update = NULL, ...)`
#' * `config_overlay(name, omitHeader = FALSE, ...)`
#' * `config_set(name, set = NULL, unset = NULL, ...)`
#' * `collection_exists(name, ...)`
#' * `collection_list(raw = FALSE, ...)`
#' * `collection_create(name, numShards = 1, maxShardsPerNode = 1,
#' createNodeSet = NULL, collection.configName = NULL, replicationFactor = 1,
#' router.name = NULL, shards = NULL, createNodeSet.shuffle = TRUE,
#' router.field = NULL, autoAddReplicas = FALSE, async = NULL, raw = FALSE,
#' callopts=list(), ...)`
#' * `collection_addreplica(name, shard = NULL, route = NULL, node = NULL,
#' instanceDir = NULL, dataDir = NULL, async = NULL, raw = FALSE,
#' callopts=list(), ...)`
#' * `collection_addreplicaprop(name, shard, replica, property, property.value,
#' shardUnique = FALSE, raw = FALSE, callopts=list())`
#' * `collection_addrole(role = "overseer", node, raw = FALSE, ...)`
#' * `collection_balanceshardunique(name, property, onlyactivenodes = TRUE,
#' shardUnique = NULL, raw = FALSE, ...)`
#' * `collection_clusterprop(name, val, raw = FALSE, callopts=list())`
#' * `collection_clusterstatus(name = NULL, shard = NULL, raw = FALSE, ...)`
#' * `collection_createalias(alias, collections, raw = FALSE, ...)`
#' * `collection_createshard(name, shard, createNodeSet = NULL,
#' raw = FALSE, ...)`
#' * `collection_delete(name, raw = FALSE, ...)`
#' * `collection_deletealias(alias, raw = FALSE, ...)`
#' * `collection_deletereplica(name, shard = NULL, replica = NULL,
#' onlyIfDown = FALSE, raw = FALSE, callopts=list(), ...)`
#' * `collection_deletereplicaprop(name, shard, replica, property, raw = FALSE,
#' callopts=list())`
#' * `collection_deleteshard(name, shard, raw = FALSE, ...)`
#' * `collection_migrate(name, target.collection, split.key,
#' forward.timeout = NULL, async = NULL, raw = FALSE, ...)`
#' * `collection_overseerstatus(raw = FALSE, ...)`
#' * `collection_rebalanceleaders(name, maxAtOnce = NULL, maxWaitSeconds = NULL,
#' raw = FALSE, ...)`
#' * `collection_reload(name, raw = FALSE, ...)`
#' * `collection_removerole(role = "overseer", node, raw = FALSE, ...)`
#' * `collection_requeststatus(requestid, raw = FALSE, ...)`
#' * `collection_splitshard(name, shard, ranges = NULL, split.key = NULL,
#' async = NULL, raw = FALSE, ...)`
#' * `core_status(name = NULL, indexInfo = TRUE, raw = FALSE, callopts=list())`
#' * `core_exists(name, callopts = list())`
#' * `core_create(name, instanceDir = NULL, config = NULL, schema = NULL,
#' dataDir = NULL, configSet = NULL, collection = NULL, shard = NULL,
#' async=NULL, raw = FALSE, callopts=list(), ...)`
#' * `core_unload(name, deleteIndex = FALSE, deleteDataDir = FALSE,
#' deleteInstanceDir = FALSE, async = NULL, raw = FALSE, callopts = list())`
#' * `core_rename(name, other, async = NULL, raw = FALSE, callopts=list())`
#' * `core_reload(name, raw = FALSE, callopts=list())`
#' * `core_swap(name, other, async = NULL, raw = FALSE, callopts=list())`
#' * `core_mergeindexes(name, indexDir = NULL, srcCore = NULL, async = NULL,
#' raw = FALSE, callopts = list())`
#' * `core_requeststatus(requestid, raw = FALSE, callopts = list())`
#' * `core_split(name, path = NULL, targetCore = NULL, ranges = NULL,
#' split.key = NULL, async = NULL, raw = FALSE, callopts=list())`
#' * `search(name = NULL, params = NULL, body = NULL, callopts = list(),
#' raw = FALSE,  parsetype = 'df', concat = ',', optimizeMaxRows = TRUE,
#' minOptimizedRows = 50000L, ...)`
#' * `facet(name = NULL, params = NULL, body = NULL, callopts = list(),
#' raw = FALSE,  parsetype = 'df', concat = ',', ...)`
#' * `stats(name = NULL, params = list(q = '*:*', stats.field = NULL,
#' stats.facet = NULL), body = NULL, callopts=list(), raw = FALSE,
#' parsetype = 'df', ...)`
#' * `highlight(name = NULL, params = NULL, body = NULL, callopts=list(),
#' raw = FALSE, parsetype = 'df', ...)`
#' * `group(name = NULL, params = NULL, body = NULL, callopts=list(),
#' raw=FALSE, parsetype='df', concat=',', ...)`
#' * `mlt(name = NULL, params = NULL, body = NULL, callopts=list(),
#' raw=FALSE, parsetype='df', concat=',', optimizeMaxRows = TRUE,
#' minOptimizedRows = 50000L, ...)`
#' * `all(name = NULL, params = NULL, body = NULL, callopts=list(),
#' raw=FALSE, parsetype='df', concat=',', optimizeMaxRows = TRUE,
#' minOptimizedRows = 50000L, ...)`
#' * `get(ids, name, fl = NULL, wt = 'json', raw = FALSE, ...)`
#' * `add(x, name, commit = TRUE, commit_within = NULL, overwrite = TRUE,
#' boost = NULL, wt = 'json', raw = FALSE, ...)`
#' * `delete_by_id(ids, name, commit = TRUE, commit_within = NULL,
#' overwrite = TRUE, boost = NULL, wt = 'json', raw = FALSE, ...)`
#' * `delete_by_query(query, name, commit = TRUE, commit_within = NULL,
#' overwrite = TRUE, boost = NULL, wt = 'json', raw = FALSE, ...)`
#' * `update_json(files, name, commit = TRUE, optimize = FALSE,
#' max_segments = 1, expunge_deletes = FALSE, wait_searcher = TRUE,
#' soft_commit = FALSE, prepare_commit = NULL, wt = 'json', raw = FALSE, ...)`
#' * `update_xml(files, name, commit = TRUE, optimize = FALSE, max_segments = 1,
#' expunge_deletes = FALSE, wait_searcher = TRUE, soft_commit = FALSE,
#' prepare_commit = NULL, wt = 'json', raw = FALSE, ...)`
#' * `update_csv(files, name, separator = ',', header = TRUE, fieldnames = NULL,
#' skip = NULL, skipLines = 0, trim = FALSE, encapsulator = NULL,
#' escape = NULL, keepEmpty = FALSE, literal = NULL, map = NULL, split = NULL,
#' rowid = NULL, rowidOffset = NULL, overwrite = NULL, commit = NULL,
#' wt = 'json', raw = FALSE, ...)`
#' * `update_atomic_json(body, name, wt = 'json', raw = FALSE, ...)`
#' * `update_atomic_xml(body, name, wt = 'json', raw = FALSE, ...)`
#'
#' @format NULL
#' @usage NULL
#'
#' @examples \dontrun{
#' # make a client
#' (cli <- SolrClient$new())
#'
#' # variables
#' cli$host
#' cli$port
#' cli$path
#' cli$scheme
#'
#' # ping
#' ## ping to make sure it's up
#' cli$ping("gettingstarted")
#'
#' # version
#' ## get Solr version information
#' cli$schema("gettingstarted")
#' cli$schema("gettingstarted", "fields")
#' cli$schema("gettingstarted", "name")
#' cli$schema("gettingstarted", "version")$version
#'
#' # Search
#' cli$search("gettingstarted", params = list(q = "*:*"))
#' cli$search("gettingstarted", body = list(query = "*:*"))
#'
#' # set a different host
#' SolrClient$new(host = 'stuff.com')
#'
#' # set a different port
#' SolrClient$new(host = 3456)
#'
#' # set a different http scheme
#' SolrClient$new(scheme = 'https')
#'
#' # set a proxy
#' SolrClient$new(proxy = list(url = "187.62.207.130:3128"))
#'
#' prox <- list(url = "187.62.207.130:3128", user = "foo", pwd = "bar")
#' cli <- SolrClient$new(proxy = prox)
#' cli$proxy
#'
#' # A remote Solr instance to which you don't have admin access
#' (cli <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL))
#' cli$search(params = list(q = "memory"))
#' }
SolrClient <- R6::R6Class(
  "SolrClient",
  portable = TRUE,
  cloneable = FALSE,
  public = list(
    host = "127.0.0.1",
    port = 8983,
    path = NULL,
    scheme = 'http',
    proxy = NULL,
    errors = "simple",

    initialize = function(host, path, port, scheme, proxy, errors) {
      if (!missing(host)) self$host <- host
      if (!missing(path)) self$path <- path
      if (!missing(port)) self$port <- port
      if (!missing(scheme)) self$scheme <- scheme
      if (!missing(proxy)) self$proxy <- private$make_proxy(proxy)
      if (!missing(errors)) self$errors <- private$lint_errors(errors)
    },

    print = function(...) {
      cat('<Solr Client>', sep = "\n")
      cat(paste0('  host: ', self$host), sep = "\n")
      cat(paste0('  path: ', self$path), sep = "\n")
      cat(paste0('  port: ', self$port), sep = "\n")
      cat(paste0('  scheme: ', self$scheme), sep = "\n")
      cat(paste0('  errors: ', self$errors), sep = "\n")
      cat("  proxy:", sep = "\n")
      if (is.null(self$proxy)) {
      } else {
        cat(paste0("    url:  ", self$proxy$proxy), sep = "\n")
        cat(paste0("    port: ", self$proxy$proxyport))
      }
    },

    # Admin methods
    ping = function(name, wt = 'json', raw = FALSE, ...) {
      path <- sprintf('solr/%s/admin/ping', name)
      res <- tryCatch(
        solr_GET(self$make_url(), path = path, args = list(wt = wt),
                 callopts = list(...)),
        error = function(e) e
      )
      if (inherits(res, "error")) {
        return(list(status = "not found"))
      } else {
        out <- structure(res, class = "ping", wt = wt)
        if (raw) return( out )
        solr_parse(out)
      }
    },

    schema = function(name, what = '', raw = FALSE, ...) {
      res <- solr_GET(self$make_url(), sprintf('solr/%s/schema/%s', name, what),
                      list(wt = "json"), ...)
      if (raw) return(res)
      jsonlite::fromJSON(res)
    },

    commit = function(name, expunge_deletes = FALSE, wait_searcher = TRUE,
                      soft_commit = FALSE, wt = 'json', raw = FALSE, ...) {

      obj_proc(self$make_url(), sprintf('solr/%s/update', name),
               body = list(commit =
                             list(expungeDeletes = asl(expunge_deletes),
                                  waitSearcher = asl(wait_searcher),
                                  softCommit = asl(soft_commit))),
               args = list(wt = wt),
               raw = raw,
               self$proxy, ...)
    },

    optimize = function(name, max_segments = 1, wait_searcher = TRUE,
                        soft_commit = FALSE, wt = 'json', raw = FALSE, ...) {

      obj_proc(self$make_url(), sprintf('solr/%s/update', name),
               body = list(optimize =
                             list(maxSegments = max_segments,
                                  waitSearcher = asl(wait_searcher),
                                  softCommit = asl(soft_commit))),
               args = list(wt = wt),
               raw = raw,
               self$proxy, ...)
    },



    config_get = function(name, what = NULL, wt = "json", raw = FALSE, ...) {
      res <- solr_GET(self$make_url(), sprintf('solr/%s/config', name),
                      sc(list(wt = wt)), self$proxy, ...)
      config_parse(res, what, wt, raw)
    },

    config_params = function(name, param = NULL, set = NULL,
                              unset = NULL, update = NULL, ...) {

      if (all(vapply(list(set, unset, update), is.null, logical(1)))) {
        if (is.null(param)) {
          url <- sprintf('solr/%s/config/params', name)
        } else {
          url <- sprintf('solr/%s/config/params/%s', name, param)
        }
        res <- solr_GET(self$make_url(),
                        sprintf('solr/%s/config/params/%s', name, param),
                        list(wt = "json"), list(...), self$proxy)
      } else {
        path <- sprintf('solr/%s/config/params', name)
        body <- sc(c(name_by(unbox_if(set, TRUE), "set"),
                     name_by(unbox_if(unset, TRUE), "unset"),
                     name_by(unbox_if(update, TRUE), "update")))
        res <- solr_POST_body(self$make_url(), path,
                              body, list(wt = "json"),
                              ctype_json(), list(...), self$proxy)
      }
      jsonlite::fromJSON(res)
    },

    config_overlay = function(name, omitHeader = FALSE, ...) {
      args <- sc(list(wt = "json", omitHeader = asl(omitHeader)))
      res <- solr_GET(self$make_url(),
                      sprintf('solr/%s/config/overlay', name), args,
                      self$proxy, ...)
      jsonlite::fromJSON(res)
    },

    config_set = function(name, set = NULL, unset = NULL, ...) {
      body <- sc(list(`set-property` = unbox_if(set),
                      `unset-property` = unset))
      res <- solr_POST_body(self$make_url(),
                            sprintf('solr/%s/config', name),
                            body, list(wt = "json"), ctype_json(),
                            list(...), self$proxy)
      jsonlite::fromJSON(res)
    },


    # Collection methods
    collection_exists = function(name, ...) {
      name %in% suppressMessages(self$collection_list(...))$collections
    },

    collection_list = function(raw = FALSE, callopts = list()) {
      private$coll_h(sc(list(action = 'LIST', wt = 'json')), callopts, raw)
    },

    collection_create = function(name, numShards = 1, maxShardsPerNode = 1,
      createNodeSet = NULL, collection.configName = NULL, replicationFactor = 1,
      router.name = NULL, shards = NULL, createNodeSet.shuffle = TRUE,
      router.field = NULL, autoAddReplicas = FALSE, async = NULL,
      raw = FALSE, callopts=list()) {

      args <- sc(list(action = 'CREATE', name = name, numShards = numShards,
                      replicationFactor = replicationFactor,
                      maxShardsPerNode = maxShardsPerNode, createNodeSet = createNodeSet,
                      collection.configName = collection.configName,
                      router.name = router.name, shards = shards,
                      createNodeSet.shuffle = asl(createNodeSet.shuffle),
                      router.field = router.field, autoAddReplicas = asl(autoAddReplicas),
                      async = async, wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_addreplica = function(name, shard = NULL, route = NULL,
      node = NULL, instanceDir = NULL, dataDir = NULL, async = NULL,
      raw = FALSE, callopts=list()) {

      args <- sc(list(action = 'ADDREPLICA', collection = name, shard = shard,
                      route = route, node = node, instanceDir = instanceDir,
                      dataDir = dataDir, async = async, wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_addreplicaprop = function(name, shard, replica, property,
      property.value, shardUnique = FALSE, raw = FALSE, callopts=list()) {

      args <- sc(list(action = 'ADDREPLICAPROP', collection = name,
                      shard = shard, replica = replica, property = property,
                      property.value = property.value,
                      shardUnique = asl(shardUnique), wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_addrole = function(role = "overseer", node, raw = FALSE,
      callopts = list(), ...) {

      args <- sc(list(action = 'ADDROLE', role = role, node = node,
                      wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_balanceshardunique = function(name, property, onlyactivenodes = TRUE,
                        shardUnique = NULL, raw = FALSE, callopts = list()) {

      args <- sc(list(action = 'BALANCESHARDUNIQUE', collection = name,
                      property = property,
                      onlyactivenodes = asl(onlyactivenodes),
                      shardUnique = asl(shardUnique),
                      wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_clusterprop = function(name, val, raw = FALSE, callopts=list()) {

      args <- sc(list(action = 'CLUSTERPROP', name = name,
                      val = if (is.null(val)) "" else val, wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_clusterstatus = function(name = NULL, shard = NULL, raw = FALSE,
                                        callopts = list()) {
      shard <- check_shard(shard)
      args <- sc(list(action = 'CLUSTERSTATUS', collection = name,
                      shard = shard, wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_createalias = function(alias, collections, raw = FALSE,
      callopts = list()) {

      collections <- check_shard(collections)
      args <- sc(list(action = 'CREATEALIAS', name = alias,
                      collections = collections, wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_createshard = function(name, shard, createNodeSet = NULL,
                                       raw = FALSE, callopts = list()) {

      args <- sc(list(action = 'CREATESHARD', collection = name, shard = shard,
                      createNodeSet = createNodeSet, wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_delete = function(name, raw = FALSE, callopts = list()) {
      args <- sc(list(action = 'DELETE', name = name, wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_deletealias = function(alias, raw = FALSE, callopts = list()) {
      args <- sc(list(action = 'DELETEALIAS', name = alias, wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_deletereplica = function(name, shard = NULL, replica = NULL,
      onlyIfDown = FALSE, raw = FALSE, callopts=list(), ...) {

      args <- sc(list(action = 'DELETEREPLICA', collection = name,
                      shard = shard, replica = replica,
                      onlyIfDown = asl(onlyIfDown), wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_deletereplicaprop = function(name, shard, replica, property,
                                             raw = FALSE, callopts=list()) {
      args <- sc(list(action = 'DELETEREPLICAPROP', collection = name,
                      shard = shard, replica = replica, property = property,
                      wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_deleteshard = function(name, shard, raw = FALSE, callopts = list()) {
      args <- sc(list(action = 'DELETESHARD', collection = name, shard = shard,
                      wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_migrate = function(name, target.collection, split.key, forward.timeout = NULL,
                                   async = NULL, raw = FALSE, callopts = list()) {
      args <- sc(list(action = 'MIGRATE', collection = name,
                      target.collection = target.collection,
                      split.key = split.key, forward.timeout = forward.timeout,
                      async = async, wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_overseerstatus = function(raw = FALSE, callopts = list()) {
      args <- sc(list(action = 'OVERSEERSTATUS', wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_rebalanceleaders = function(name, maxAtOnce = NULL,
      maxWaitSeconds = NULL, raw = FALSE, callopts = list()) {

      args <- sc(list(action = 'REBALANCELEADERS', collection = name,
                      maxAtOnce = maxAtOnce,
                      maxWaitSeconds = maxWaitSeconds, wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_reload = function(name, raw = FALSE, callopts = list()) {
      args <- sc(list(action = 'RELOAD', name = name, wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_removerole = function(role = "overseer", node, raw = FALSE,
                                     callopts = list()) {

      args <- sc(list(action = 'REMOVEROLE', role = role, node = node,
                      wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_requeststatus = function(requestid, raw = FALSE, callopts = list()) {
      args <- sc(list(action = 'REQUESTSTATUS', requestid = requestid,
                      wt = 'json'))
      private$coll_h(args, callopts, raw)
    },

    collection_splitshard = function(name, shard, ranges = NULL, split.key = NULL,
                                      async = NULL, raw = FALSE, callopts = list()) {
      args <- sc(list(action = 'SPLITSHARD', collection = name, shard = shard,
                      ranges = do_ranges(ranges), split.key = split.key,
                      async = async, wt = 'json'))
      private$coll_h(args, callopts, raw)
    },


    # Core methods
    core_status = function(name = NULL, indexInfo = TRUE, raw = FALSE,
                           callopts=list()) {
      args <- sc(list(action = 'STATUS', core = name,
                      indexInfo = asl(indexInfo), wt = 'json'))
      res <- solr_GET(self$make_url(), 'solr/admin/cores', args, callopts,
                      self$proxy)
      if (raw) res else jsonlite::fromJSON(res)
    },

    core_exists = function(name, callopts = list()) {
      tmp <- suppressMessages(self$core_status(name = name, callopts = callopts))
      length(tmp$status[[1]]) > 0
    },

    core_create = function(name, instanceDir = NULL, config = NULL,
      schema = NULL, dataDir = NULL, configSet = NULL, collection = NULL,
      shard = NULL, async=NULL, raw = FALSE, callopts=list(), ...) {

      args <- sc(list(action = 'CREATE', name = name, instanceDir = instanceDir,
                      config = config, schema = schema, dataDir = dataDir,
                      configSet = configSet, collection = collection,
                      shard = shard, async = async, wt = 'json'))
      res <- solr_GET(self$make_url(), 'solr/admin/cores', args, callopts,
                      self$proxy)
      if (raw) res else jsonlite::fromJSON(res)
    },

    core_unload = function(name, deleteIndex = FALSE, deleteDataDir = FALSE,
                           deleteInstanceDir = FALSE, async = NULL,
                           raw = FALSE, callopts = list()) {

      args <- sc(list(action = 'UNLOAD', core = name,
                      deleteIndex = asl(deleteIndex),
                      deleteDataDir = asl(deleteDataDir),
                      deleteInstanceDir = asl(deleteInstanceDir),
                      async = async, wt = 'json'))
      res <- solr_GET(self$make_url(), 'solr/admin/cores', args, callopts,
                      self$proxy)
      if (raw) res else jsonlite::fromJSON(res)
    },

    core_rename = function(name, other, async = NULL, raw = FALSE,
                           callopts=list()) {
      args <- sc(list(action = 'RENAME', core = name, other = other,
                      async = async, wt = 'json'))
      res <- solr_GET(self$make_url(), 'solr/admin/cores', args, callopts,
                      self$proxy)
      if (raw) res else jsonlite::fromJSON(res)
    },

    core_reload = function(name, raw = FALSE, callopts=list()) {
      args <- sc(list(action = 'RELOAD', core = name, wt = 'json'))
      res <- solr_GET(self$make_url(), 'solr/admin/cores', args, callopts,
                      self$proxy)
      if (raw) res else jsonlite::fromJSON(res)
    },

    core_swap = function(name, other, async = NULL, raw = FALSE, callopts=list()) {
      if (is_in_cloud_mode(self)) stop("You are in SolrCloud mode, stopping",
                                       call. = FALSE)
      args <- sc(list(action = 'SWAP', core = name, other = other,
                      async = async, wt = 'json'))
      res <- solr_GET(self$make_url(), 'solr/admin/cores', args, callopts,
                      self$proxy)
      if (raw) res else jsonlite::fromJSON(res)
    },

    core_mergeindexes = function(name, indexDir = NULL, srcCore = NULL,
                                 async = NULL, raw = FALSE, callopts = list()) {

      args <- sc(list(action = 'MERGEINDEXES', core = name, indexDir = indexDir,
                      srcCore = srcCore, async = async, wt = 'json'))
      res <- solr_GET(self$make_url(), 'solr/admin/cores', args, callopts,
                      self$proxy)
      if (raw) res else jsonlite::fromJSON(res)
    },

    core_requeststatus = function(requestid, raw = FALSE, callopts = list()) {
      args <- sc(list(action = 'REQUESTSTATUS', requestid = requestid,
                      wt = 'json'))
      res <- solr_GET(self$make_url(), 'solr/admin/cores', args, callopts,
                      self$proxy)
      if (raw) res else jsonlite::fromJSON(res)
    },

    core_split = function(name, path = NULL, targetCore = NULL, ranges = NULL,
                          split.key = NULL, async = NULL, raw = FALSE,
                          callopts=list()) {
      args <- sc(list(action = 'SPLIT', core = name, ranges = do_ranges(ranges),
                      split.key = split.key, async = async, wt = 'json'))
      args <- c(args, make_args(path), make_args(targetCore))
      res <- solr_GET(self$make_url(), 'solr/admin/cores', args, callopts,
                      self$proxy)
      if (raw) res else jsonlite::fromJSON(res)
    },


    # Search methods
    search = function(name = NULL, params = NULL, body = NULL, callopts = list(),
                      raw = FALSE,  parsetype = 'df', concat = ',',
                      optimizeMaxRows = TRUE, minOptimizedRows = 50000L, ...) {

      if (is.null(params)) {
        if (is.null(body)) stop("if 'params' NULL, body must be given")
      }
      stopifnot(inherits(params, "list") || is.null(params))
      stopifnot(inherits(body, "list") || is.null(body))
      if (!is.null(params) && length(params) > 0) {
        params$rows <- private$adjust_rows(params, optimizeMaxRows, minOptimizedRows, name)
      }
      if (!is.null(body) && length(body) > 0) {
        body$rows <- private$adjust_rows(body, optimizeMaxRows, minOptimizedRows, name)
      }
      if (!is.null(params)) params <- check_args_search(params, "fq", ...)
      if (!is.null(body)) body <- check_args_search(body, "fq", ...)
      if (!is.null(body)) {
        res <- solr_POST_body(self$make_url(),
            if (!is.null(name)) url_handle(name) else self$path,
            body, params, ctype_json(), callopts, self$proxy)
        out <- structure(res, class = "sr_search", wt = params$wt)
      } else {
        res <- solr_GET(self$make_url(),
                 if (!is.null(name)) url_handle(name) else self$path,
                 params, callopts, self$proxy)
        out <- structure(res, class = "sr_search", wt = params$wt)
      }
      if (raw) {
        return( out )
      } else {
        parsed <- cont_parse(out, params$wt %||% body$wt %||% "json")
        parsed <- structure(parsed, class = c(class(parsed), "sr_search"))
        solr_parse(parsed, parsetype, concat)
      }
    },

    facet = function(name = NULL, params = NULL, body = NULL, callopts = list(),
                     raw = FALSE,  parsetype = 'df', concat = ',', ...) {

      if (is.null(params)) {
        if (is.null(body)) stop("if 'params' NULL, body must be given")
      }
      stopifnot(inherits(params, "list") || is.null(params))
      stopifnot(inherits(body, "list") || is.null(body))
      if (!is.null(params)) params <- check_args_facet(params, keys_facet, ...)
      if (!is.null(body)) body <- check_args_facet(body, keys_facet, ...)

      if (!is.null(body)) {
        res <- solr_POST_body(self$make_url(),
          if (!is.null(name)) url_handle(name) else self$path,
          body, params, ctype_json(), callopts, self$proxy)
        out <- structure(res, class = "sr_facet", wt = params$wt)
      } else {
        res <- solr_GET(self$make_url(),
                        if (!is.null(name)) url_handle(name) else self$path,
                        params, callopts, self$proxy)
        out <- structure(res, class = "sr_facet", wt = params$wt)
      }
      if (raw) {
        return( out )
      } else {
        parsed <- cont_parse(out, params$wt %||% body$wt %||% "json")
        parsed <- structure(parsed, class = c(class(parsed), "sr_facet"))
        solr_parse(parsed)
      }
    },

    stats = function(name = NULL,
      params = list(q = '*:*', stats.field = NULL, stats.facet = NULL), body = NULL,
      callopts=list(), raw = FALSE, parsetype = 'df', ...) {

      if (is.null(params)) {
        if (is.null(body)) stop("if 'params' NULL, body must be given")
      }
      stopifnot(inherits(params, "list") || is.null(body))
      stopifnot(inherits(body, "list") || is.null(body))
      if (!is.null(params)) params <- check_args_stats(params, keys_stats, ...)
      if (!is.null(body)) body <- check_args_stats(body, keys_stats, ...)
      if (!is.null(body)) {
        res <- solr_POST_body(self$make_url(),
          if (!is.null(name)) url_handle(name) else self$path,
          body, params, ctype_json(), callopts, self$proxy)
        out <- structure(res, class = "sr_stats", wt = params$wt)
      } else {
        res <- solr_GET(self$make_url(),
                        if (!is.null(name)) url_handle(name) else self$path,
                        params, callopts, self$proxy)
        out <- structure(res, class = "sr_stats", wt = params$wt)
      }
      if (raw) {
        return( out )
      } else {
        parsed <- cont_parse(out, params$wt %||% body$wt %||% "json")
        parsed <- structure(parsed, class = c(class(parsed), "sr_stats"))
        solr_parse(out, parsetype)
      }
    },

    highlight = function(name = NULL, params = NULL, body = NULL,
                         callopts=list(), raw = FALSE, parsetype = 'df', ...) {

      if (is.null(params)) {
        if (is.null(body)) stop("if 'params' NULL, body must be given")
      }
      stopifnot(inherits(params, "list") || is.null(body))
      stopifnot(inherits(body, "list") || is.null(body))
      if (!is.null(params)) params <- check_args_high(params, keys_high, ...)
      if (!is.null(body)) body <- check_args_high(body, keys_high, ...)
      if (!is.null(body)) {
        res <- solr_POST_body(self$make_url(),
          if (!is.null(name)) url_handle(name) else self$path,
          body, params, callopts, self$proxy)
        out <- structure(res, class = "sr_high", wt = params$wt)
      } else {
        res <- solr_GET(self$make_url(),
                        if (!is.null(name)) url_handle(name) else self$path,
                        params, callopts, self$proxy)
        out <- structure(res, class = "sr_high", wt = params$wt)
      }
      if (raw) {
        return(out)
      } else {
        parsed <- cont_parse(out, params$wt %||% body$wt %||% "json")
        parsed <- structure(parsed, class = c(class(parsed), "sr_high"))
        solr_parse(out, parsetype)
      }
    },

    group = function(name = NULL, params = NULL, body = NULL,
                     callopts=list(), raw=FALSE, parsetype='df', concat=',',
                     ...) {

      if (is.null(params)) {
        if (is.null(body)) stop("if 'params' NULL, body must be given")
      }
      stopifnot(inherits(params, "list") || is.null(params))
      stopifnot(inherits(body, "list") || is.null(body))
      if (!is.null(params)) params <- check_args_group(params, keys_group, ...)
      if (!is.null(body)) body <- check_args_group(body, keys_group, ...)

      if (!is.null(body)) {
        res <- solr_POST_body(
          self$make_url(),
          if (!is.null(name)) url_handle(name) else self$path,
          body, params, ctype_json(), callopts, self$proxy)
        out <- structure(res, class = "sr_group", wt = body$wt)
      } else {
        res <- solr_GET(self$make_url(),
                        if (!is.null(name)) url_handle(name) else self$path,
                        params, callopts, self$proxy)
        out <- structure(res, class = "sr_group", wt = params$wt)
      }
      if (raw) {
        return(out)
      } else {
        parsed <- cont_parse(out, params$wt %||% body$wt %||% "json")
        parsed <- structure(parsed, class = c(class(parsed), "sr_group"))
        solr_parse(out, parsetype)
      }
    },

    mlt = function(name = NULL, params = NULL, body = NULL,
                   callopts=list(), raw=FALSE, parsetype='df', concat=',',
                   optimizeMaxRows = TRUE, minOptimizedRows = 50000L, ...) {

      if (is.null(params)) {
        if (is.null(body)) stop("if 'params' NULL, body must be given")
      }
      stopifnot(inherits(params, "list") || is.null(params))
      stopifnot(inherits(body, "list") || is.null(body))
      if (!is.null(params) && length(params) > 0) {
        params$rows <- private$adjust_rows(params, optimizeMaxRows, minOptimizedRows, name)
      }
      if (!is.null(body) && length(body) > 0) {
        body$rows <- private$adjust_rows(body, optimizeMaxRows, minOptimizedRows, name)
      }
      if (!is.null(params)) params <- check_args_mlt(params, keys_mlt, ...)
      if (!is.null(body)) body <- check_args_mlt(body, keys_mlt, ...)

      if (!is.null(body)) {
        res <- solr_POST_body(
          self$make_url(),
          if (!is.null(name)) url_handle(name) else self$path,
          body, params, ctype_json(), callopts, self$proxy)
        out <- structure(res, class = "sr_mlt", wt = body$wt)
      } else {
        res <- solr_GET(self$make_url(),
                        if (!is.null(name)) url_handle(name) else self$path,
                        params, callopts, self$proxy)
        out <- structure(res, class = "sr_mlt", wt = params$wt)
      }
      if (raw) {
        return( out )
      } else {
        parsed <- cont_parse(out, params$wt %||% body$wt %||% "json")
        parsed <- structure(parsed, class = c(class(parsed), "sr_mlt"))
        solr_parse(parsed, parsetype, concat)
      }
    },

    all = function(name = NULL, params = NULL, body = NULL,
                   callopts=list(), raw=FALSE, parsetype='df', concat=',',
                   optimizeMaxRows = TRUE, minOptimizedRows = 50000L, ...) {

      if (is.null(params)) {
        if (is.null(body)) stop("if 'params' NULL, body must be given")
      }
      stopifnot(inherits(params, "list") || is.null(params))
      stopifnot(inherits(body, "list") || is.null(body))
      if (!is.null(params) && length(params) > 0) {
        params$rows <- private$adjust_rows(params, optimizeMaxRows, minOptimizedRows, name)
      }
      if (!is.null(body) && length(body) > 0) {
        body$rows <- private$adjust_rows(body, optimizeMaxRows, minOptimizedRows, name)
      }
      if (!is.null(params)) params <- check_args_search(params, keys_all, ...)
      if (!is.null(body)) body <- check_args_search(body, keys_all, ...)

      if (!is.null(body)) {
        res <- solr_POST_body(
          self$make_url(),
          if (!is.null(name)) url_handle(name) else self$path,
          body, params, ctype_json(), callopts, self$proxy)
        out <- structure(res, class = "sr_all", wt = body$wt)
      } else {
        res <- solr_GET(self$make_url(),
                        if (!is.null(name)) url_handle(name) else self$path,
                        params, callopts, self$proxy)
        out <- structure(res, class = "sr_all", wt = params$wt)
      }
      if (raw) {
        return( out )
      } else {
        parsed <- cont_parse(out, params$wt %||% body$wt %||% "json")
        parsed <- structure(parsed, class = c(class(parsed), "sr_all"))
        solr_parse(parsed, parsetype, concat)
      }
    },


    # documents methods
    get = function(ids, name, fl = NULL, wt = 'json', raw = FALSE, ...) {
      if (!is.null(fl)) fl <- paste0(fl, collapse = ",")
      args <- sc(list(ids = paste0(ids, collapse = ","), fl = fl, wt = wt))
      res <- solr_GET(self$make_url(), sprintf('solr/%s/get', name),
                      args, self$proxy, ...)
      config_parse(res, wt = wt, raw = raw)
    },

    add = function(x, name, commit = TRUE, commit_within = NULL, overwrite = TRUE,
                    boost = NULL, wt = 'json', raw = FALSE, ...) {
      args <- sc(list(commit = asl(commit), commitWithin = commit_within,
                      overwrite = asl(overwrite), wt = wt))
      obj_proc(self$make_url(), sprintf('solr/%s/update/json/docs', name),
               x, args, raw, self$proxy, ...)
    },

    delete_by_id = function(ids, name, commit = TRUE, commit_within = NULL,
                            overwrite = TRUE, boost = NULL, wt = 'json',
                            raw = FALSE, ...) {
      args <- sc(list(commit = asl(commit), wt = wt))
      body <- list(delete = lapply(ids, function(z) list(id = z)))
      obj_proc(self$make_url(), sprintf('solr/%s/update/json', name), body,
               args, raw, self$proxy, ...)
    },

    delete_by_query = function(query, name, commit = TRUE, commit_within = NULL,
                               overwrite = TRUE, boost = NULL, wt = 'json',
                               raw = FALSE, ...) {
      args <- sc(list(commit = asl(commit), wt = wt))
      body <- list(delete = list(query = query))
      obj_proc(self$make_url(), sprintf('solr/%s/update/json', name), body,
               args, raw, self$proxy, ...)
    },

    update_json = function(files, name, commit = TRUE, optimize = FALSE,
      max_segments = 1, expunge_deletes = FALSE, wait_searcher = TRUE,
      soft_commit = FALSE, prepare_commit = NULL, wt = 'json',
      raw = FALSE, ...) {

      private$stop_if_absent(name)
      args <- sc(list(commit = asl(commit), optimize = asl(optimize),
                      maxSegments = max_segments,
                      expungeDeletes = asl(expunge_deletes),
                      waitSearcher = asl(wait_searcher),
                      softCommit = asl(soft_commit),
                      prepareCommit = prepare_commit, wt = wt))
      docreate(self$make_url(), sprintf('solr/%s/update/json/docs', name),
               crul::upload(files), args, ctype_json(), raw, self$proxy,
               ...)
    },

    update_xml = function(files, name, commit = TRUE, optimize = FALSE,
      max_segments = 1, expunge_deletes = FALSE, wait_searcher = TRUE,
      soft_commit = FALSE, prepare_commit = NULL, wt = 'json',
      raw = FALSE, ...) {

      private$stop_if_absent(name)
      args <- sc(
        list(commit = asl(commit), optimize = asl(optimize),
             maxSegments = max_segments, expungeDeletes = asl(expunge_deletes),
             waitSearcher = asl(wait_searcher), softCommit = asl(soft_commit),
             prepareCommit = prepare_commit, wt = wt))
      docreate(self$make_url(), sprintf('solr/%s/update', name),
               crul::upload(files), args, ctype_xml(), raw, self$proxy, ...)
    },

    update_csv = function(files, name, separator = ',', header = TRUE,
      fieldnames = NULL, skip = NULL, skipLines = 0, trim = FALSE,
      encapsulator = NULL, escape = NULL, keepEmpty = FALSE, literal = NULL,
      map = NULL, split = NULL, rowid = NULL, rowidOffset = NULL,
      overwrite = NULL, commit = NULL, wt = 'json', raw = FALSE, ...) {

      private$stop_if_absent(name)
      if (!is.null(fieldnames)) fieldnames <- paste0(fieldnames, collapse = ",")
      args <- sc(
        list(separator = separator, header = header, fieldnames = fieldnames,
             skip = skip, skipLines = skipLines, trim = trim,
             encapsulator = encapsulator, escape = escape, keepEmpty = keepEmpty,
             literal = literal, map = map, split = split, rowid = rowid,
             rowidOffset = rowidOffset, overwrite = overwrite,
             commit = commit, wt = wt))
      docreate(self$make_url(), sprintf('solr/%s/update/csv', name),
               crul::upload(files), args, ctype_csv(), raw, self$proxy, ...)
    },

    update_atomic_json = function(body, name, wt = 'json', raw = FALSE, ...) {
      private$stop_if_absent(name)
      doatomiccreate(self$make_url(), sprintf('solr/%s/update', name),
                     body, list(wt = wt), "json", raw, self$proxy, ...)
    },

    update_atomic_xml = function(body, name, wt = 'json', raw = FALSE, ...) {
      private$stop_if_absent(name)
      doatomiccreate(self$make_url(), sprintf('solr/%s/update', name),
                     body, list(wt = wt), "xml", raw, self$proxy, ...)
    },



    # utility functions
    make_url = function() {
      if (is.null(self$port)) {
        #sprintf("%s://%s/%s", self$scheme, self$host, self$path)
        sprintf("%s://%s", self$scheme, self$host)
      } else {
        #sprintf("%s://%s:%s/%s", self$scheme, self$host, self$port, self$path)
        sprintf("%s://%s:%s", self$scheme, self$host, self$port)
      }
    }
  ),

  private = list(
    stop_if_absent = function(x) {
      tmp <- vapply(list(self$core_exists, self$collection_exists), function(z) {
        tmp <- tryCatch(z(x), error = function(e) e)
        if (inherits(tmp, "error")) FALSE else tmp
      }, logical(1))
      if (!any(tmp)) {
        stop(
          x,
          " doesn't exist - create it first.\n See core_create()/collection_create()",
          call. = FALSE)
      }
    },

    give_data = function(x, y) {
      if (x) return(y) else jsonlite::fromJSON(y)
    },

    coll_h = function(args, callopts = list(), raw) {
      res <- solr_GET(self$make_url(), 'solr/admin/collections', args,
                      callopts,  self$proxy)
      private$give_data(raw, res)
    },

    make_proxy = function(args) {
      if (is.null(args)) {
        NULL
      } else {
        crul::proxy(url = args$url, user = args$user,
                    pwd = args$pwd, auth = args$auth %||% "basic")
      }
    },

    lint_errors = function(x) {
      if (!x %in% c('simple', 'complete')) {
        stop("errors must be one of 'simple' or 'complete'")
      }
      return(x)
    },

    adjust_rows = function(x, optimizeMaxRows, minOptimizedRows, name) {
      rows <- x$rows %||% NULL
      rows <- cn(rows)
      if (!is.null(rows) && optimizeMaxRows) {
        if (rows > minOptimizedRows || rows < 0) {
          out <- self$search(
            name = name,
            params = list(q = x$q %||% NULL, rows = 0, wt = 'json'),
            raw = TRUE, optimizeMaxRows = FALSE)
          oj <- jsonlite::fromJSON(out)
          if (rows > oj$response$numFound || rows < 0) {
            rows <- as.double(oj$response$numFound)
          }
        }
      }

      return(rows)
    }

  )
)
