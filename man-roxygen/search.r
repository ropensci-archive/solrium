#' @param q Query terms, defaults to '*:*', or everything.
#' @param sort Field to sort on. You can specify ascending (e.g., score desc) or 
#' descending (e.g., score asc), sort by two fields (e.g., score desc, price asc), 
#' or sort by a function (e.g., sum(x_f, y_f) desc, which sorts by the sum of 
#' x_f and y_f in a descending order).
#' @param start Record to start at, default to beginning.
#' @param rows Number of records to return. Defaults to 10.
#' @param pageDoc If you expect to be paging deeply into the results (say beyond page 10, 
#' assuming rows=10) and you are sorting by score, you may wish to add the pageDoc 
#' and pageScore parameters to your request. These two parameters tell Solr (and Lucene) 
#' what the last result (Lucene internal docid and score) of the previous page was, 
#' so that when scoring the query for the next set of pages, it can ignore any results 
#' that occur higher than that item. To get the Lucene internal doc id, you will need 
#' to add [docid] to the &fl list. 
#' e.g., q=*:*&start=10&pageDoc=5&pageScore=1.345&fl=[docid],score
#' @param pageScore See pageDoc notes.
#' @param fq Filter query, this does not affect the search, only what gets returned
#' @param fl Fields to return
#' @param defType Specify the query parser to use with this request. 
#' @param timeAllowed The time allowed for a search to finish. This value only applies 
#' to the search and not to requests in general. Time is in milliseconds. Values <= 0 
#' mean no time restriction. Partial results may be returned (if there are any).
#' @param qt Which query handler used.
#' @param wt Data type returned, defaults to 'json'
#' @param NOW Set a fixed time for evaluating Date based expresions 
#' @param TZ Time zone, you can override the default.
#' @param echoHandler If the echoHandler parameter is true, Solr places the name of 
#' the handle used in the response to the client for debugging purposes.
#' @param echoParams The echoParams parameter tells Solr what kinds of Request 
#' parameters should be included in the response for debugging purposes, legal values 
#' include:
#' \itemize{
#'  \item none - don't include any request parameters for debugging
#'  \item explicit - include the parameters explicitly specified by the client in the request
#'  \item all - include all parameters involved in this request, either specified explicitly 
#'  by the client, or implicit because of the request handler configuration.
#' }
#' @param key API key, if needed.
#' @param base URL endpoint.
#' @param callopts Call options passed on to httr::GET
#' @param raw (logical) If TRUE, returns raw data in format specified by wt param
#' @param parsetype (character) One of 'list' or 'df'
#' @param concat (character) Character to concatenate elements of longer than length 1. 
#' Note that this only works reliably when data format is json (wt='json'). The parsing
#' is more complicated in XML format, but you can do that on your own.
#' @param verbose If TRUE (default) the url call used printed to console.
#' @param ... Further args.
