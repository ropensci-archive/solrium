#' General purpose R interface to Solr.
#' 
#' This package has support for all the search endpoints, as well as a suite
#' of functions for managing a Solr database, including adding and deleting 
#' documents. 
#'
#' @section Important search functions:
#'
#' \itemize{
#'   \item \code{\link{solr_search}} - General search, only returns documents
#'   \item \code{\link{solr_all}} - General search, including all non-documents
#'   in addition to documents: facets, highlights, groups, mlt, stats.
#'   \item \code{\link{solr_facet}} - Faceting only (w/o general search)
#'   \item \code{\link{solr_highlight}} - Highlighting only (w/o general search)
#'   \item \code{\link{solr_mlt}} - More like this (w/o general search)
#'   \item \code{\link{solr_group}} - Group search (w/o general search)
#'   \item \code{\link{solr_stats}} - Stats search (w/o general search)
#' }
#' 
#' @section Important Solr management functions:
#'
#' \itemize{
#'   \item \code{\link{update_json}} - Add or delete documents using json in a file
#'   \item \code{\link{add}} - Add documents via an R list or data.frame
#'   \item \code{\link{delete_by_id}} - Delete documents by ID
#'   \item \code{\link{delete_by_query}} - Delete documents by query
#' } 
#'
#' @section Vignettes:
#'
#' See the vignettes for help \code{browseVignettes(package = "solrium")}
#'
#' @section Performance:
#'
#' \code{v0.2} and above of this package will have \code{wt=csv} as the default. This 
#' should give significant performance improvement over the previous default of \code{wt=json},
#' which pulled down json, parsed to an R list, then to a data.frame. With
#' \code{wt=csv}, we pull down csv, and read that in directly to a data.frame.
#'
#' The http library we use, \pkg{httr}, sets gzip compression header by default. As
#' long as compression is used server side, you're good to go on compression, which
#' should be a good peformance boost. See
#' \url{https://wiki.apache.org/solr/SolrPerformanceFactors#Query_Response_Compression}
#' for notes on how to enable compression.
#'
#' There are other notes about Solr performance at
#' \url{https://wiki.apache.org/solr/SolrPerformanceFactors} that can be used server
#' side/in your Solr config, but aren't things to tune here in this R client.
#'
#' Let us know if there's any further performance improvements we can make.
#'
#' @importFrom stats setNames
#' @importFrom utils URLdecode head modifyList read.table
#' @importFrom methods is
#' @importFrom httr GET POST stop_for_status content content_type_json
#' content_type_xml content_type upload_file http_condition http_status
#' @importFrom XML xmlParse xpathApply xmlToList xmlAttrs xmlChildren xmlValue
#' xmlGetAttr
#' @importFrom jsonlite fromJSON
#' @importFrom plyr rbind.fill
#' @importFrom dplyr rbind_all as_data_frame tbl_df
#' @name solrium-package
#' @aliases solrium
#' @docType package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @keywords package
NULL
