#' solr - a general purpose package to interact with Solr endpoints
#' 
#' The solr package is an R interface to Solr. Currently (as of 2013-12-07)
#' this package only does the getting data part, not writing data, but if you
#' want data writing capability do speak up and/or send a pull request. 
#' 
#' There are currently three main functions:
#' 
#' \describe{
#'   \item{solr_search}{General search}
#'   \item{solr_facet}{Faceting only (w/o general search)}
#'   \item{solr_highlight}{Highlighting only (w/o general search)}
#' }
#' 
#' @docType package
#' @name solr
NULL