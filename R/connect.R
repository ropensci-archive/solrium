#' @title Solr connection 
#' 
#' @description Set Solr options, including base URL, proxy, and errors
#' 
#' @export
#' @param url Base URL for Solr instance. For a local instance, this is likely going
#' to be \code{http://localhost:8983} (also the default), or a different port if you
#' set a different port. 
#' @param proxy List of arguments for a proxy connection, including one or more of:
#' url, port, username, password, and auth. See \code{\link[httr]{use_proxy}} for 
#' help, which is used to construct the proxy connection.
#' @param errors (character) One of simple or complete. Simple gives http code and 
#' error message on an error, while complete gives both http code and error message, 
#' and stack trace, if available.
#' @param verbose (logical) Whether to print help messages or not. E.g., if 
#' \code{TRUE}, we print the URL on each request to a Solr server for your 
#' reference. Default: \code{TRUE}
#' @details This function sets environment variables that we use internally
#' within functions in this package to determine the right thing to do given your
#' inputs. 
#' 
#' In addition, \code{solr_connect} does a quick \code{GET} request to the URL you 
#' provide to make sure the service is up.
#' @examples \dontrun{
#' # set solr settings
#' solr_connect()
#' 
#' # set solr settings with a proxy
#' prox <- list(url = "187.62.207.130", port = 3128)
#' solr_connect(url = "http://localhost:8983", proxy = prox)
#' 
#' # get solr settings
#' solr_settings()
#' 
#' # you can also check your settings via Sys.getenv()
#' Sys.getenv("SOLR_URL")
#' Sys.getenv("SOLR_ERRORS")
#' }
solr_connect <- function(url = "http://localhost:8983", proxy = NULL, 
                         errors = "simple", verbose = TRUE) {
  # checks
  url <- checkurl(url)
  errors <- match.arg(errors, c('simple', 'complete'))
  check_proxy_args(proxy)
  
  # set
  Sys.setenv("SOLR_URL" = url)
  Sys.setenv("SOLR_ERRORS" = errors)
  Sys.setenv("SOLR_VERBOSITY" = verbose)
  options(solr_proxy = proxy)
  
  # ping server
  res <- tryCatch(GET(Sys.getenv("SOLR_URL")), error = function(e) e)
  if (is(res, "error")) {
    stop(sprintf("\n  Failed to connect to %s\n  Remember to start Solr before connecting",
                 url), call. = FALSE)
  }
  
  structure(list(url = Sys.getenv("SOLR_URL"), 
                 proxy = make_proxy(proxy), 
                 errors = Sys.getenv("SOLR_ERRORS"), 
                 verbose = Sys.getenv("SOLR_VERBOSITY")), 
            class = "solr_connection")
}

#' @export
#' @rdname solr_connect
solr_settings <- function() {
  url <- Sys.getenv("SOLR_URL")
  err <- Sys.getenv("SOLR_ERRORS")
  verbose <- Sys.getenv("SOLR_VERBOSITY")
  proxy <- getOption("solr_proxy")
  structure(list(url = url, proxy = make_proxy(proxy), errors = err, verbose = verbose), class = "solr_connection")
}

#' @export
print.solr_connection <- function(x, ...) {
  cat("<solr_connection>", sep = "\n")
  cat(paste0("  url:    ", x$url), sep = "\n")
  cat(paste0("  errors: ", x$errors), sep = "\n")
  cat(paste0("  verbose: ", x$verbose), sep = "\n")
  cat("  proxy:", sep = "\n")
  if (is.null(x$proxy)) {
  } else {
    cat(paste0("      url:     ", x$proxy$options$proxy), sep = "\n")
    cat(paste0("      port:     ", x$proxy$options$proxyport))
  }
}

# cat_proxy <- function(x) {
#   if (is.null(x)) {
#     ''
#   } else {
#     x$options$proxy
#   }
# }

check_proxy_args <- function(x) {
  if (!all(names(x) %in% c('url', 'port', 'username', 'password', 'auth'))) {
    stop("Input to proxy can only contain: url, port, username, password, auth", 
         call. = FALSE)
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

is_url <- function(x){
  grepl("https?://", x, ignore.case = TRUE) || grepl("localhost:[0-9]{4}", x, ignore.case = TRUE)
}

checkurl <- function(x){
  if (!is_url(x)) {
    stop("That does not appear to be a url", call. = FALSE)
  } else {
    if (grepl("https?", x)) {
      x
    } else {
      paste0("http://", x)
    }
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
