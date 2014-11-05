#' Function to make make multiple args of the same name from a 
#' single input with length > 1
#' @param x Value
makemultiargs <- function(x){
  value <- get(x, envir = parent.frame(n = 2))
  if( length(value) == 0 ){ NULL } else {
    if( any(sapply(value, is.na)) ){ NULL } else {
      if( !is.character(value) ){ 
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
  for(i in seq_along(x)){
    outlist[[i]] <- makemultiargs(x[[i]])
  }
  as.list(unlist(sc(outlist)))
}

# GET helper fxn
solr_GET <- function(base, args, callopts, verbose){
  tt <- GET(base, query = args, callopts)
  if(verbose) message(URLdecode(tt$url))
  stop_for_status(tt)
  content(tt, as="text")
}

# small function to replace elements of length 0 with NULL
replacelen0 <- function(x) if(length(x) < 1){ NULL } else { x }

sc <- function (l) Filter(Negate(is.null), l)
