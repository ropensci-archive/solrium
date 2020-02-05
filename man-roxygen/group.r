#' @param name Name of a collection or core. Or leave as \code{NULL} if not needed.
#' @param callopts Call options passed on to [crul::HttpClient]
#' @param raw (logical) If TRUE, returns raw data in format specified by wt param
#' @param parsetype (character) One of 'list' or 'df'
#' @param concat (character) Character to concatenate elements of longer than length 1.
#' Note that this only works reliably when data format is json (wt='json'). The parsing
#' is more complicated in XML format, but you can do that on your own.
#' @param progress a function with logic for printing a progress
#' bar for an HTTP request, ultimately passed down to \pkg{curl}. only supports 
#' \code{httr::progress} for now. See the README for an example.
#' @param ... Further args to be combined into query
#'
#' @section Group parameters:
#' \itemize{
#'  \item q Query terms, defaults to '*:*', or everything.
#'  \item fq Filter query, this does not affect the search, only what gets returned
#'  \item fl Fields to return
#'  \item wt (character) Data type returned, defaults to 'json'. One of json or xml. If json,
#' uses \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to
#' parse. csv is only supported in \code{\link{solr_search}} and \code{\link{solr_all}}.
#'  \item key API key, if needed.
#'  \item group.field (fieldname) Group based on the unique values of a field. The
#' field must currently be single-valued and must be either indexed, or be another
#' field type that has a value source and works in a function query - such as
#' ExternalFileField. Note: for Solr 3.x versions the field must by a string like
#' field such as StrField or TextField, otherwise a http status 400 is returned.
#'  \item group.func (function query) Group based on the unique values of a function
#' query. Solr4.0 This parameter only is supported on 4.0
#'  \item group.query (query) Return a single group of documents that also match the
#' given query.
#'  \item rows (number) The number of groups to return. Defaults to 10.
#'  \item start (number) The offset into the list of groups.
#'  \item group.limit (number) The number of results (documents) to return for each
#' group. Defaults to 1.
#'  \item group.offset (number) The offset into the document list of each group.
#'  \item sort How to sort the groups relative to each other. For example,
#' sort=popularity desc will cause the groups to be sorted according to the highest
#' popularity doc in each group. Defaults to "score desc".
#'  \item group.sort How to sort documents within a single group. Defaults
#' to the same value as the sort parameter.
#'  \item group.format One of grouped or simple. If simple, the grouped documents are
#' presented in a single flat list. The start and rows parameters refer to numbers of
#' documents instead of numbers of groups.
#'  \item group.main (logical) If true, the result of the last field grouping command
#' is used as the main result list in the response, using group.format=simple
#'  \item group.ngroups (logical) If true, includes the number of groups that have
#' matched the query. Default is false. Solr4.1 WARNING: If this parameter is set
#' to true on a sharded environment, all the documents that belong to the same group
#' have to be located in the same shard, otherwise the count will be incorrect. If you
#' are using SolrCloud, consider using "custom hashing"
#'  \item group.cache.percent (0-100) If > 0 enables grouping cache. Grouping is executed
#' actual two searches. This option caches the second search. A value of 0 disables
#' grouping caching. Default is 0. Tests have shown that this cache only improves search
#' time with boolean queries, wildcard queries and fuzzy queries. For simple queries like
#' a term query or a match all query this cache has a negative impact on performance
#' }

