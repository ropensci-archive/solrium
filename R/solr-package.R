#' General purpose R interface to Solr.
#' 
#' @section Important functions:
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
#' @section Vignettes:
#' 
#' See the vignettes for help \code{browseVignettes(package = "solr")}
#' 
#' @section Performance:
#' 
#' \code{v0.2} and above will have \code{wt=csv} as the default. This should give 
#' significant performance improvement over the previous default of \code{wt=json},
#' which pulled down json, parsed to an R list, then to a data.frame. With 
#' \code{wt=csv}, we pull down csv, and read that in directly to a data.frame. 
#' 
#' The http library we use, \code{httr}, sets gzip compression header by default. As
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
#' @importFrom utils URLdecode
#' @importFrom methods is
#' @name solr-package
#' @aliases solr
#' @docType package
#' @title General purpose R interface to Solr.
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @keywords package
NULL
