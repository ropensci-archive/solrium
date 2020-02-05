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
#' @section Parameters:
#' \itemize{
#'  \item q Query terms, defaults to '*:*', or everything.
#'  \item sort Field to sort on. You can specify ascending (e.g., score desc) or
#' descending (e.g., score asc), sort by two fields (e.g., score desc, price asc),
#' or sort by a function (e.g., sum(x_f, y_f) desc, which sorts by the sum of
#' x_f and y_f in a descending order).
#'  \item start Record to start at, default to beginning.
#'  \item rows Number of records to return. Default: 10.
#'  \item pageDoc If you expect to be paging deeply into the results (say beyond page 10,
#' assuming rows=10) and you are sorting by score, you may wish to add the pageDoc
#' and pageScore parameters to your request. These two parameters tell Solr (and Lucene)
#' what the last result (Lucene internal docid and score) of the previous page was,
#' so that when scoring the query for the next set of pages, it can ignore any results
#' that occur higher than that item. To get the Lucene internal doc id, you will need
#' to add \code{docid} to the &fl list.
#'  \item pageScore See pageDoc notes.
#'  \item fq Filter query, this does not affect the search, only what gets returned.
#' This parameter can accept multiple items in a lis or vector. You can't pass more than
#' one parameter of the same name, so we get around it by passing multiple queries
#' and we parse internally
#'  \item fl Fields to return, can be a character vector like \code{c('id', 'title')},
#' or a single character vector with one or more comma separated names, like
#' \code{'id,title'}
#'  \item defType Specify the query parser to use with this request.
#'  \item timeAllowed The time allowed for a search to finish. This value only applies
#' to the search and not to requests in general. Time is in milliseconds. Values \code{<= 0}
#' mean no time restriction. Partial results may be returned (if there are any).
#'  \item qt Which query handler used. Options: dismax, others?
#'  \item NOW Set a fixed time for evaluating Date based expresions
#'  \item TZ Time zone, you can override the default.
#'  \item echoHandler If \code{TRUE}, Solr places the name of the handle used in the
#' response to the client for debugging purposes. Default:
#'  \item echoParams The echoParams parameter tells Solr what kinds of Request
#' parameters should be included in the response for debugging purposes, legal values
#' include:
#'   \itemize{
#'    \item none - don't include any request parameters for debugging
#'    \item explicit - include the parameters explicitly specified by the client in the request
#'    \item all - include all parameters involved in this request, either specified explicitly
#'    by the client, or implicit because of the request handler configuration.
#'  }
#' \item wt (character) One of json, xml, or csv. Data type returned, defaults
#'   to 'csv'. If json, uses [jsonlite::fromJSON()] to parse. If xml,
#'   uses [xml2::read_xml()] to parse. If csv, uses [read.table()] to parse.
#'   `wt=csv` gives the fastest performance at least in all the cases we have
#'   tested in, thus it's the default value for `wt`
#' }
