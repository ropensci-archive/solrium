check_args_search <- function(x, reps, ...) {
  if (deparse(substitute(x)) == "params") {
    if (is.null(x$wt)) x$wt <- "json"
    check_wt(x$wt)
  }
  if (!is.null(x$fl)) x$fl <- paste0(x$fl, collapse = ",")
  # args that can be repeated
  tmp <- x
  for (i in reps) tmp[[i]] <- NULL
  x <- c(tmp, collectargs(z = reps, lst = x))
  # additional parameters
  x <- c(x, list(...))
  return(x)
}

check_args_facet <- function(x, reps, ...) {
  if (deparse(substitute(x)) == "params") {
    if (is.null(x$wt)) x$wt <- "json"
    check_wt(x$wt)
  }
  if (!is.null(x$fl)) x$fl <- paste0(x$fl, collapse = ",")
  # args that can be repeated
  x <- collectargs(reps, x)
  # additional parameters
  x <- c(x, list(...))
  x$fl <- 'DOES_NOT_EXIST'
  x$facet <- 'true'
  if (length(x[names(x) %in% "facet.pivot"]) > 1) {
    xx <- paste0(unlist(unname(x[names(x) %in% "facet.pivot"])),
                 collapse = ",")
    x[names(x) %in% "facet.pivot"] <- NULL
    x$facet.pivot <- xx
  }
  # check if any facet.* fields - if none, stop with message
  if (!any(grepl("facet\\.", names(x)))) {
    stop("didn't detect any facet. fields - at least 1 required")
  }
  return(x)
}

check_args_stats <- function(x, reps, ...) {
  if (deparse(substitute(x)) == "params") {
    if (is.null(x$wt)) x$wt <- "json"
    check_wt(x$wt)
  }
  if (!is.null(x$fl)) x$fl <- paste0(x$fl, collapse = ",")
  # args that can be repeated
  x <- collectargs(reps, x)
  # additional parameters
  x <- c(x, list(...))
  x$stats <- 'true'
  return(x)
}

check_args_high <- function(x, reps, ...) {
  if (deparse(substitute(x)) == "params") {
    if (is.null(x$wt)) x$wt <- "json"
    check_wt(x$wt)
  }
  if (!is.null(x$fl)) x$fl <- paste0(x$fl, collapse = ",")
  if (!is.null(x$hl.fl)) names(x$hl.fl) <- rep("hl.fl", length(x$hl.fl))
  x <- c(popp(x, "hl.fl"), x$hl.fl)
  # additional parameters
  x <- c(x, list(...))
  x$hl <- 'true'
  # check that args are in acceptable set
  if (!all(names(x) %in% reps)) stop("some keys not in acceptable set for highlight")
  return(x)
}

check_args_mlt <- function(x, reps, ...) {
  if (deparse(substitute(x)) == "params") {
    if (is.null(x$wt)) x$wt <- "json"
    check_wt(x$wt)
  }
  fl_str <- paste0(x$fl, collapse = ",")
  if (any(grepl('id', x$fl))) {
    x$fl <- fl_str
  } else {
    x$fl <- sprintf('id,%s', fl_str)
  }
  # additional parameters
  x <- c(x, list(...))
  x$mlt <- 'true'
  # check that args are in acceptable set
  if (!all(names(x) %in% reps)) stop("some keys not in acceptable set for mlt")
  return(x)
}

check_args_group <- function(x, reps, ...) {
  if (deparse(substitute(x)) == "params") {
    if (is.null(x$wt)) x$wt <- "json"
    check_wt(x$wt)
  }
  if (!is.null(x$fl)) x$fl <- paste0(x$fl, collapse = ",")
  # args that can be repeated
  x <- collectargs(reps, x)
  # additional parameters
  x <- c(x, list(...))
  x$group <- 'true'
  return(x)
}
