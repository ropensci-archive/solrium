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
solr_GET <- function(base, args, callopts = NULL, ...){
  tt <- GET(base, query = args, callopts, ...)
  if (solr_settings()$verbose) message(URLdecode(tt$url))
  if (tt$status_code > 201) {
    solr_error(tt)
  } else {
    content(tt, as = "text", encoding = "UTF-8")
  }
}

solr_error <- function(x) {
  if (grepl("html", x$headers$`content-type`)) {
    stop(http_status(x)$message, call. = FALSE)
  } else { 
    err <- jsonlite::fromJSON(content(x, "text", encoding = "UTF-8"))
    erropt <- Sys.getenv("SOLR_ERRORS")
    if (erropt == "simple" || erropt == "") {
      stop(err$error$code, " - ", err$error$msg, call. = FALSE)
    } else {
      stop(err$error$code, " - ", err$error$msg, 
           "\nAPI stack trace\n", 
           pluck_trace(err$error$trace), call. = FALSE)
    }
  }
}

pluck_trace <- function(x) {
  if (is.null(x)) {
    " - no stack trace"
  } else {
    x
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

# POST helper fxn - just a body
solr_POST_body <- function(base, body, args, ...) {
  invisible(match.arg(args$wt, c("xml", "json")))
  tt <- POST(base, query = args, body = body, 
             content_type_json(), encode = "json", ...)
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

# check if core/collection exists, if not stop
stop_if_absent <- function(x) {
  tmp <- vapply(list(core_exists, collection_exists), function(z) {
    tmp <- tryCatch(z(x), error = function(e) e)
    if (is(tmp, "error")) FALSE else tmp
  }, logical(1))
  if (!any(tmp)) {
    stop(x, " doesn't exist - create it first.\n See core_create() or collection_create()", 
         call. = FALSE)
  }
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
         csv = content_type("application/csv; charset=utf-8")
  )
}

get_response <- function(x, as = "text") {
  if (x$status_code > 201) {
    err <- jsonlite::fromJSON(httr::content(x, "text", encoding = "UTF-8"))$error
    stop(sprintf("%s: %s", err$code, err$msg), call. = FALSE)
  } else {
    content(x, as = as, encoding = "UTF-8")
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
  if (is.null(z)) {
    NULL
  } else {
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
}

docreate <- function(base, files, args, content, raw, ...) {
  out <- structure(solr_POST(base, files, args, content, ...), class = "update", wt = args$wt)
  if (raw) { 
    return(out) 
  } else { 
    solr_parse(out) 
  } 
}

objcreate <- function(base, dat, args, raw, ...) {
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

check_defunct <- function(...) {
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- "verbose" %in% calls
  if (any(calls_vec)) {
    stop("The parameter verbose has been removed - see ?solr_connect", 
         call. = FALSE)
  }
}

is_in_cloud_mode <- function(x) {
  res <- GET(file.path(x$url, "solr/admin/collections"), 
             query = list(wt = 'json'))
  if (res$status_code > 201) return(FALSE)
  msg <- jsonlite::fromJSON(content(res, "text", encoding = "UTF-8"))$error$msg
  if (grepl("not running", msg)) {
    FALSE
  } else {
    TRUE
  }
}

json_parse <- function(x, raw) {
  if (raw) {
    x
  } else {
    jsonlite::fromJSON(x)
  }
}

unbox_if <- function(x, recursive = FALSE) {
  if (!is.null(x)) {
    if (recursive) {
      rapply(x, jsonlite::unbox, how = "list")
    } else {
      lapply(x, jsonlite::unbox)
    }
  } else {
    NULL
  }
}
