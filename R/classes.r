#' Test for sr_facet class
#' @export
#' @param x Input
#' @rdname is-sr
is.sr_facet <- function(x) inherits(x, "sr_facet")

#' Test for sr_high class
#' @export
#' @rdname is-sr
is.sr_high <- function(x) inherits(x, "sr_high")

#' Test for sr_search class
#' @export
#' @rdname is-sr
is.sr_search <- function(x) inherits(x, "sr_search")