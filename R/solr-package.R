#' General purpose R interface to Solr.
#'
#' The solr package is an R interface to Solr. Currently
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
#' See the vignettes for help:
#'
#' \itemize{
#' 	 \item{solr_localsetup}
#' 	 \item{solr_vignette}
#' }
#'
#' @importFrom methods is
#' @importFrom utils URLdecode
#' @name solr-package
#' @aliases solr
#' @docType package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @keywords package
NULL
