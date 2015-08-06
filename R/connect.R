#' Solr connection 
#' 
#' @export
#' @param url Base URL for Solr instance
#' @param proxy List of arguments for a proxy connection, including one or more of:
#' url, port, username, password, and auth. See \code{\link[httr]{use_proxy}} for 
#' help, which is used to construct the proxy connection.
#' @param (character) One of simple or complete. Simple gives http code and 
#' error message on an error, while complete gives both http code and error message, 
#' and stack trace, if available.  
#' @examples \dontrun{
#' prox <- list(url = "187.62.207.130", port = 3128)
#' solr_connect(url = "http://localhost:8983", proxy = prox)
#' }
solr_connect <- function(url = "http://localhost:8983", proxy = NULL, errors = "simple") {
  options(solr_errors = errors)
  structure(list(url = url, proxy = make_proxy(proxy)), class = "solr_connection")
}

print.solr_connection <- function(x, ...) {
  cat("<solr_connection>", sep = "\n")
  cat(paste0("  url: ", x$url), sep = "\n")
  cat("  proxy url: ", cat_proxy(x$proxy))
}

cat_proxy <- function(x) {
  if (is.null(x)) {
    ''
  } else {
    x$options$proxy
  }
}

make_proxy <- function(args) {
  if (is.null(args)) {
    NULL
  } else {
    httr::use_proxy(url = args$url, port = args$port, 
                    username = args$username, password = args$password, 
                    auth = args$auth)
  }
}

# ### R6 version
# library("R6")
# library("httr")
# 
# solr_connect <- function(url, proxy = NULL) {
#   .solr_connection$new(url, proxy)
# }
# 
# .solr_connection <-
#   R6::R6Class("solr_connection",
#     public = list(
#       url = "http://localhost:8983",
#       proxy = NULL,
#       initialize = function(url, proxy) {
#         if (!missing(url)) self$url <- url
#         if (!missing(proxy)) self$proxy <- proxy
#       },
#       status = function(...) {
#         httr::http_status(httr::HEAD(self$url, ...))$message
#       }
#     ),
#     cloneable = FALSE
# )
# 
# conn <- solr_connect("http://scottchamberlain.info/")
# # conn <- solr_connect$new(url = "http://localhost:8983")
# # conn <- solr_connect$new(url = 'http://api.plos.org/search')
# # conn <- solr_connect$new(proxy = use_proxy("64.251.21.73", 8080))
# conn
# conn$url
# conn$proxy
# conn$status()
# conn$status(config = verbose())
# conn$ping()
