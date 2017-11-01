#' @param optimizeMaxRows (logical) If \code{TRUE}, then rows parameter will be
#' adjusted to the number of returned results by the same constraints.
#' It will only be applied if rows parameter is higher
#' than \code{minOptimizedRows}. Default: \code{TRUE}
#' @param minOptimizedRows (numeric) used by \code{optimizedMaxRows} parameter,
#' the minimum optimized rows. Default: 50000
