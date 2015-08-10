#' Function to make make multiple args of the same name from a 
#' single input with length > 1
#' @param x Value
makemultiargs <- function(x){
  value <- get(x, envir = parent.frame(n = 2))
  if ( length(value) == 0 ) { 
    NULL 
  } else {
    if ( any(sapply(value, is.na)) ) { 
      NULL 
    } else {
      if ( !is.character(value) ) { 
        value <- as.character(value)
      }
      names(value) <- rep(x, length(value))
      value
    }
  }
}

#' Function to make a list of args passing arg names through multiargs function.
#' @param x Value
collectargs <- function(x){
  outlist <- list()
  for (i in seq_along(x)) {
    outlist[[i]] <- makemultiargs(x[[i]])
  }
  as.list(unlist(sc(outlist)))
}

# GET helper fxn
solr_GET <- function(base, args, callopts = NULL, verbose, ...){
  tt <- GET(base, query = args, callopts, ...)
  if (verbose) message(URLdecode(tt$url))
  if (tt$status_code > 201) {
    solr_error(tt)
#     err <- content(tt)
#     erropt <- Sys.getenv("SOLR_ERRORS")
#     if (erropt == "simple" || erropt == "") {
#       stop(err$error$code, " - ", err$error$msg, call. = FALSE)
#     } else {
#       stop(err$error$code, " - ", err$error$msg, "\nAPI stack trace\n", err$error$trace, call. = FALSE)
#     }
  } else {
    content(tt, as = "text")
  }
}

solr_error <- function(x) {
  err <- content(x)
  erropt <- Sys.getenv("SOLR_ERRORS")
  if (erropt == "simple" || erropt == "") {
    stop(err$error$code, " - ", err$error$msg, call. = FALSE)
  } else {
    stop(err$error$code, " - ", err$error$msg, "\nAPI stack trace\n", err$error$trace, call. = FALSE)
  }
}

# POST helper fxn
solr_POST <- function(base, body, args, content, ...) {
  invisible(match.arg(args$wt, c("xml", "json", "csv")))
  ctype <- get_ctype(content)
  args <- lapply(args, function(x) if (is.logical(x)) tolower(x) else x)
  tt <- POST(base, query = args, body = upload_file(path = body), ctype)
  get_response(tt)
}

# POST helper fxn for R objects
obj_POST <- function(base, body, args, ...) {
  invisible(match.arg(args$wt, c("xml", "json", "csv")))
  args <- lapply(args, function(x) if (is.logical(x)) tolower(x) else x)
  body <- jsonlite::toJSON(body, auto_unbox = TRUE)
  tt <- POST(base, query = args, body = body, content_type_json(), ...)
  get_response(tt)
}

# helper for POSTing from R objects
obj_proc <- function(url, body, args, raw, ...) {
  out <- structure(obj_POST(url, body, args, ...), class = "update", wt = args$wt)
  if (raw) {
    out
  } else {
    solr_parse(out) 
  }
}

get_ctype <- function(x) {
  switch(x, 
         xml = content_type_xml(),
         json = content_type_json(),
         csv = content_type("text/plain; charset=utf-8")
  )
}

get_response <- function(x, as = "text") {
  if (x$status_code > 201) {
    err <- jsonlite::fromJSON(httr::content(x))$error
    stop(sprintf("%s: %s", err$code, err$msg), call. = FALSE)
  } else {
    content(x, as = as)
  }
}

# small function to replace elements of length 0 with NULL
replacelen0 <- function(x) {
  if (length(x) < 1) { 
    NULL 
  } else { 
    x 
  }
}
  
sc <- function(l) Filter(Negate(is.null), l)

asl <- function(z) {
  if (is.logical(z) || tolower(z) == "true" || tolower(z) == "false") {
    if (z) {
      return('true')
    } else {
      return('false')
    }
  } else {
    return(z)
  }
}

docreate <- function(base, files, args, content, raw, ...) {
  out <- structure(solr_POST(base, files, args, content, ...), class = "update", wt = args$wt)
  if (raw) { 
    return(out) 
  } else { 
    solr_parse(out) 
  } 
}

objcreate <- function(base, dat, args, verbose, raw, ...) {
  out <- structure(solr_POST(base, dat, args, "json", ...), class = "update", wt = args$wt)
  if (raw) { 
    return(out) 
  } else { 
    solr_parse(out) 
  } 
}

check_conn <- function(x) {
  if (!is(x, "solr_connection")) {
    stop("Input to conn parameter must be an object of class solr_connection", 
         call. = FALSE)
  }
  if (is.null(x)) {
    stop("You must provide a connection object", 
         call. = FALSE)
  }
}

check_wt <- function(x) {
  if (!x %in% c('json', 'xml', 'csv')) {
    stop("wt must be one of: json, xml, csv", 
         call. = FALSE)
  }  
}
