#' @param optimize Should index optimization be performed before the method returns. 
#' Default: \code{FALSE}
#' @param max_segments optimizes down to at most this number of segments. Default: 1 
#' @param expunge_deletes merge segments with deletes away. Default: \code{FALSE}
#' @param wait_searcher block until a new searcher is opened and registered as the 
#' main query searcher, making the changes visible. Default: \code{TRUE}
#' @param soft_commit  perform a soft commit - this will refresh the 'view' of the 
#' index in a more performant manner, but without "on-disk" guarantees. 
#' Default: \code{FALSE}
#' @param prepare_commit The prepareCommit command is an expert-level API that 
#' calls Lucene's IndexWriter.prepareCommit(). Not passed by default 
