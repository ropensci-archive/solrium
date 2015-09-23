#' @title Split a core
#'
#' @description SPLIT splits an index into two or more indexes. The index being
#' split can continue to handle requests. The split pieces can be placed into
#' a specified directory on the server's filesystem or it can be merged into
#' running Solr cores.
#'
#' @export
#'
#' @param name (character) The name of one of the cores to be swapped. Required
#' @param path (character) Two or more target directory paths in which a piece of the
#' index will be written
#' @param targetCore (character) Two or more target Solr cores to which a piece
#' of the index will be merged
#' @param ranges (character) A list of number ranges, or hash ranges in hexadecimal format.
#' If numbers, they get converted to hexidecimal format before being passed to
#' your Solr server.
#' @param split.key (character) The key to be used for splitting the index
#' @param async	(character) Request ID to track this action which will be processed
#' asynchronously
#' @param raw (logical) If \code{TRUE}, returns raw data
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' @details The core index will be split into as many pieces as the number of \code{path}
#' or \code{targetCore} parameters.
#'
#' Either \code{path} or \code{targetCore} parameter must be specified but not
#' both. The \code{ranges} and \code{split.key} parameters are optional and only one of
#' the two should be specified, if at all required.
#' @examples \dontrun{
#' # start Solr with Schemaless mode via the schemaless eg: bin/solr start -e schemaless
#' # you can create a new core like: bin/solr create -c corename
#' # where <corename> is the name for your core - or creaate as below
#'
#' # connect
#' solr_connect()
#'
#' # Swap a core
#' ## First, create two cores
#' # core_split("splitcoretest0") # or create in the CLI: bin/solr create -c splitcoretest0
#' # core_split("splitcoretest1") # or create in the CLI: bin/solr create -c splitcoretest1
#' # core_split("splitcoretest2") # or create in the CLI: bin/solr create -c splitcoretest2
#'
#' ## check status
#' core_status("splitcoretest0", FALSE)
#' core_status("splitcoretest1", FALSE)
#' core_status("splitcoretest2", FALSE)
#'
#' ## split core using targetCore parameter
#' core_split("splitcoretest0", targetCore = c("splitcoretest1", "splitcoretest2"))
#'
#' ## split core using split.key parameter
#' ### Here all documents having the same route key as the split.key i.e. 'A!'
#' ### will be split from the core index and written to the targetCore
#' core_split("splitcoretest0", targetCore = "splitcoretest1", split.key = "A!")
#'
#' ## split core using ranges parameter
#' ### Solr expects hash ranges in hexidecimal, but since we're in R,
#' ### let's not make our lives any harder, so you can pass in numbers
#' ### but you can still pass in hexidecimal if you want.
#' rgs <- c('0-1f4', '1f5-3e8')
#' core_split("splitcoretest0", targetCore = c("splitcoretest1", "splitcoretest2"), ranges = rgs)
#' rgs <- list(c(0, 500), c(501, 1000))
#' core_split("splitcoretest0", targetCore = c("splitcoretest1", "splitcoretest2"), ranges = rgs)
#' }
core_split <- function(name, path = NULL, targetCore = NULL, ranges = NULL, split.key = NULL,
                       async = NULL, raw = FALSE, callopts=list()) {
  conn <- solr_settings()
  check_conn(conn)
  args <- sc(list(action = 'SPLIT', core = name, ranges = do_ranges(ranges),
                  split.key = split.key, async = async, wt = 'json'))
  args <- c(args, make_args(path), make_args(targetCore))
  res <- solr_GET(file.path(conn$url, 'solr/admin/cores'), args, callopts, conn$proxy)
  if (raw) {
    return(res)
  } else {
    jsonlite::fromJSON(res)
  }
}

make_args <- function(x) {
  if (!is.null(x)) {
    as.list(setNames(x, rep(deparse(substitute(x)), length(x))))
  } else {
    NULL
  }
}

do_ranges <- function(x) {
  if (is.null(x)) {
    NULL
  } else {
    make_hex(x)
  }
}

make_hex <- function(x) {
  if (is(x, "list")) {
    clzz <- sapply(x, class)
    if (clzz[1] == "character") {
      paste0(x, collapse = ",")
    } else {
      zz <- lapply(x, function(z) {
        tmp <- try_as_hex(z)
        paste0(tmp, collapse = "-")
      })
      paste0(zz, collapse = ",")
    }
  } else {
    clzz <- sapply(x, class)
    if (clzz[1] == "character") {
      paste0(x, collapse = ",")
    } else {
      paste0(try_as_hex(x), collapse = ",")
    }
  }
}

try_as_hex <- function(x) {
  tryCatch(as.hexmode(x), error = function(e) e)
}
