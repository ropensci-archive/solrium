#' Create documents
#' 
#' @export
#' @family create
#' @param files Path to file to load into Solr
#' @param base (character) URL endpoint. This is different from the other functions in that we aren't 
#' hitting a search endpoint. Pass in here 
#' @param wt (character) One of json (default) or xml. If json, uses 
#' \code{\link[jsonlite]{fromJSON}} to parse. If xml, uses \code{\link[XML]{xmlParse}} to parse
#' @param verbose If TRUE (default) the url call used printed to console.
#' @param raw (logical) If TRUE, returns raw data in format specified by wt param
#' @param callopts curl options passed on to \code{\link[httr]{GET}}
#' 
#' @details You likely may not be able to run this function against many public Solr 
#' services, but should work locally.
#' 
#' @examples \dontrun{
#' # from files
#' ## from json, json is the default wt value
#' create(files = "~/books.json")
#' ## from xml
#' create(files = "~/hd.xml", wt="xml")
#' }
create_json <- function(base = 'http://localhost:8983', files, wt = 'json', verbose = TRUE, raw = FALSE, 
                        callopts = list()) {
  
  if(is.null(base)) stop("You must provide a url")
  docreate(file.path(base, 'solr/update/json'), files, args, callopts, verbose, raw)
}

docreate <- function(base, files, args, content, callopts, verbose, raw) {
  out <- structure(solr_POST(base, files, args, content, callopts, verbose), class="create", wt=args$wt)
  if(raw) { 
    return(out) 
  } else { 
    solr_parse(out) 
  } 
}
