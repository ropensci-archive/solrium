#' General purpose R interface to Solr.
#'
#' This package has support for all the search endpoints, as well as a suite
#' of functions for managing a Solr database, including adding and deleting
#' documents.
#'
#' @section Important search functions:
#'
#' - [solr_search()] - General search, only returns documents
#' - [solr_all()] - General search, including all non-documents
#'   in addition to documents: facets, highlights, groups, mlt, stats.
#' - [solr_facet()] - Faceting only (w/o general search)
#' - [solr_highlight()] - Highlighting only (w/o general search)
#' - [solr_mlt()] - More like this (w/o general search)
#' - [solr_group()] - Group search (w/o general search)
#' - [solr_stats()] - Stats search (w/o general search)
#'
#' @section Important Solr management functions:
#'
#' - [update_json()] - Add or delete documents using json in a file
#' - [add()] - Add documents via an R list or data.frame
#' - [delete_by_id()] - Delete documents by ID
#' - [delete_by_query()] - Delete documents by query
#'
#' @section Vignettes:
#'
#' See the vignettes for help `browseVignettes(package = "solrium")`
#'
#' @section Performance:
#'
#' `v0.2` and above of this package will have `wt=csv` as the default.
#' This  should give significant performance improvement over the previous
#' default of `wt=json`, which pulled down json, parsed to an R list,
#' then to a data.frame. With `wt=csv`, we pull down csv, and read that
#' in directly to a data.frame.
#'
#' The http library we use, \pkg{crul}, sets gzip compression header by
#' default. As long as compression is used server side, you're good to go on
#' compression, which should be a good peformance boost. See
#' https://wiki.apache.org/solr/SolrPerformanceFactors#Query_Response_Compression
#' for notes on how to enable compression.
#'
#' There are other notes about Solr performance at
#' https://wiki.apache.org/solr/SolrPerformanceFactors that can be
#' used server side/in your Solr config, but aren't things to tune here in
#' this R client.
#'
#' Let us know if there's any further performance improvements we can make.
#'
#' @importFrom utils URLdecode head modifyList read.table
#' @importFrom crul HttpClient
#' @importFrom xml2 read_xml xml_children xml_find_first xml_find_all
#' xml_name xml_text xml_attr xml_attrs
#' @importFrom jsonlite fromJSON
#' @importFrom plyr rbind.fill
#' @importFrom dplyr bind_rows
#' @importFrom tibble as_tibble add_column
#' @importFrom R6 R6Class
#' @name solrium-package
#' @aliases solrium
#' @docType package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @keywords package
NULL
