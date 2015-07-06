library("R6")
library("httr")

solr_connect <-
  R6::R6Class("solr_connection",
    public = list(
      url = "http://localhost:8983/solr",
      proxy = NULL,
      initialize = function(url, proxy) {
        if (!missing(url)) self$url <- url
        if (!missing(proxy)) self$proxy <- proxy
      },
      status = function(...) {
        httr::http_status(httr::HEAD(self$url, ...))$message
      }
    ),
    cloneable = FALSE
)

conn <- solr_connect$new()
conn
conn$url
conn$proxy
conn$status()
conn$status(config = verbose())
