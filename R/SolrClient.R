#' Solr connection client
#'
#' @export
#' @param host (character) Host url. Deafault: 127.0.0.1
#' @param port (character/numeric) Port. Default: 8389
#' @param scheme (character) http scheme, one of http or https. Default: http
#' @param proxy List of arguments for a proxy connection, including one or 
#' more of: url, port, username, password, and auth. See 
#' \code{\link[httr]{use_proxy}} for  help, which is used to construct the 
#' proxy connection.
#' @param errors (character) One of simple or complete. Simple gives http code 
#' and  error message on an error, while complete gives both http code and 
#' error message, and stack trace, if available.
#'
#' @return Various output, see help files for each grouping of methods.
#'
#' @details \code{SolrClient} creates a R6 class object. The object is
#' not cloneable and is portable, so it can be inherited across packages
#' without complication.
#'
#' \code{SolrClient} is used to initialize a client that knows about your 
#' Solr instance, with options for setting host, port, http scheme, 
#' and simple vs. complete error reporting
#'
#' @section SolrClient methods:
#' \strong{Methods}
#'   \describe{
#'     \item{\code{ping()}}{
#'      ping the Solr server
#'     }
#'     \item{\code{schema()}}{
#'      get the schema info
#'     }
#'   }
#'
#' @examples \dontrun{
#' # make a client
#' (cli <- SolrClient$new())
#'
#' # ping
#' ## ping to make sure it's up
#' cli$ping("gettingstarted")
#'
#' # version
#' ## get Solr version information
#' cli$schema("gettingstarted")
#' cli$schema("gettingstarted", "fields")
#' cli$schema("gettingstarted", "name")
#' cli$schema("gettingstarted", "version")$version
#'
#' # variables
#' cli$host
#' cli$port
#' cli$scheme
#'
#' # set a different host
#' SolrClient$new(host = 'stuff.com')
#'
#' # set a different port
#' SolrClient$new(host = 3456)
#'
#' # set a different http scheme
#' SolrClient$new(scheme = 'https')
#' 
#' # set a proxy
#' SolrClient$new(proxy = list(url = "187.62.207.130:3128"))
#' 
#' prox <- list(url = "187.62.207.130:3128", user = "foo", pwd = "bar")
#' cli <- SolrClient$new(proxy = prox)
#' cli$proxy
#' 
#' # A remote Solr instance to which you don't have admin access
#' SolrClient$new(host = "http://api.plos.org/search", port = NULL)
#' 
#' # Search
#' cli$search("gettingstarted")
#' cli$search("gettingstarted", params = list(q = "memory"))
#' cli$search("gettingstarted", body = list(q = "memory"))
#' }
SolrClient <- R6::R6Class(
  "SolrClient",
  portable = TRUE,
  cloneable = FALSE,
  public = list(
    host = "127.0.0.1",
    port = 8983,
    scheme = 'http',
    proxy = NULL,
    errors = "simple",
    
    initialize = function(host, port, scheme, proxy, errors) {
      if (!missing(host)) self$host <- host
      if (!missing(port)) self$port <- port
      if (!missing(scheme)) self$scheme <- scheme
      if (!missing(proxy)) self$proxy <- make_proxy(proxy)
      if (!missing(errors)) self$errors <- errors
    },
    
    print = function(...) {
      cat('<Solr Client>', sep = "\n")
      cat(paste0('  host: ', self$host), sep = "\n")
      cat(paste0('  port: ', self$port), sep = "\n")
      cat(paste0('  scheme: ', self$scheme), sep = "\n")
      cat(paste0('  errors: ', self$errors), sep = "\n")
      cat("  proxy:", sep = "\n")
      if (is.null(self$proxy)) {
      } else {
        cat(paste0("    url:  ", self$proxy$proxy), sep = "\n")
        cat(paste0("    port: ", self$proxy$proxyport))
      }
    },
    
    ping = function(name, wt = 'json', raw = FALSE, ...) {
      path <- sprintf('solr/%s/admin/ping', name)
      res <- tryCatch(
        solr_GET(private$make_url(), path = path, args = list(wt = wt), ...),
        error = function(e) e
      )
      if (inherits(res, "error")) {
        return(list(status = "not found"))
      } else {
        out <- structure(res, class = "ping", wt = wt)
        if (raw) {
          return( out )
        } else {
          solr_parse(out)
        }
      }
    },
    
    schema = function(name, what = '', raw = FALSE, ...) {
      res <- solr_GET(private$make_url(), 
                      sprintf('solr/%s/schema/%s', name, what), 
                      list(wt = "json"), ...)
      if (raw) {
        return(res)
      } else {
        jsonlite::fromJSON(res)
      }
    },
    
    search = function(name = NULL, params = list(q = '*:*', fl = NULL, 
                                                 fq = NULL, wt = 'json'), 
      body = NULL, callopts=list(), raw=FALSE,  parsetype='df', concat=',', 
      ...) {
      
      params$wt <- "json"
      #check_wt(params$wt)
      if (!is.null(params$fl)) params$fl <- paste0(params$fl, collapse = ",")
      if (!is.null(params$fq)) params$fq <- list()
      # args <- sc(
      #   list(q = q, sort = sort, start = start, rows = rows, pageDoc = pageDoc,
      #        pageScore = pageScore, fl = fl, defType = defType,
      #        timeAllowed = timeAllowed, qt = qt, wt = wt, NOW = NOW, TZ = TZ,
      #        echoHandler = echoHandler, echoParams = echoParams))
      
      # args that can be repeated
      # todonames <- "fq"
      # args <- c(params, collectargs(todonames))
      
      # additional parameters
      # args <- c(args, list(...))
      # if ('query' %in% names(args)) {
      #   args <- args[!names(args) %in% "q"]
      # }
      
      if (!is.null(body)) {
        out <- structure(solr_POST_body(private$make_url(), url_handle(name),
                                        body, params, callopts, self$proxy), 
                         class = "sr_search", wt = params$wt)
      } else {
        out <- structure(solr_GET(private$make_url(), url_handle(name), params, 
                              callopts, self$proxy), 
                         class = "sr_search", wt = params$wt)
      }
      if (raw) {
        return( out )
      } else {
        parsed <- cont_parse(out, params$wt)
        parsed <- structure(parsed, class = c(class(parsed), "sr_search"))
        solr_parse(parsed, parsetype, concat)
      }
    }
  ),
  
  private = list(
    make_url = function() {
      sprintf("%s://%s:%s", self$scheme, self$host, self$port)
    }
  )
)

url_handle <- function(name) {
  if (is.null(name)) {
    ""
  } else {
    file.path("solr", name, "select")
  }
}
