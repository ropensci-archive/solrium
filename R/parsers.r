#' Parse facet data.
#' 
#' @import XML rjson assertthat data.table
#' @param input Output from solr_facet
#' @param parsetype One of 'list' or 'df' (data.frame)
#' @details This is the parser used internally in solr_facet, but if you output raw 
#' data from solr_facet using raw=TRUE, then you can use this function to parse that
#' data (a sr_facet S3 object) after the fact to a list of data.frame's for easier 
#' consumption. The data format type is detected from the attribute "wt" on the 
#' sr_facet object.
#' @export
solr_parse <- function(input, parsetype){
  UseMethod("solr_parse")
}

#' @method solr_parse sr_facet
#' @export
#' @rdname solr_parse
solr_parse.sr_facet <- function(input, parsetype=NULL)
{
  assert_that(is(input, "sr_facet"))
  wt <- attributes(input)$wt
  input <- switch(wt, 
                  xml = xmlParse(input),
                  json = rjson::fromJSON(input))
  
  # Facet queries
  if(wt=='json'){
    fqdat <- input$facet_counts$facet_queries
    fqout <- data.frame(term=names(fqdat), value=do.call(c, fqdat), stringsAsFactors=FALSE)
    row.names(fqout) <- NULL
  } else
  {
    nodes <- xpathApply(input, '//lst[@name="facet_queries"]//int')
    if(length(nodes)==0){ fqout <- NULL } else { fqout <- nodes }
  }
  
  # facet fields
  if(wt=='json'){
    ffout <- lapply(input$facet_counts$facet_fields, function(x){
      data.frame(do.call(rbind, lapply(seq(1, length(x), by=2), function(y){
        x[c(y, y+1)]
      })), stringsAsFactors=FALSE)
    })
  } else
  {
    nodes <- xpathApply(input, '//lst[@name="facet_fields"]//lst')
    parselist <- function(x){
      tmp <- xmlToList(x)
      data.frame(rbindlist(tmp[!names(tmp) %in% ".attrs"]))
    }
    ffout <- lapply(nodes, parselist)
    names(ffout) <- sapply(nodes, xmlAttrs)
  }
  
  # Facet dates
  if(wt=='json'){
    datesout <- lapply(input$facet_counts$facet_dates, function(x){
      x <- x[!names(x) %in% c('gap','start','end')]
      x <- data.frame(date=names(x), value=do.call(c, x), stringsAsFactors=FALSE)
      row.names(x) <- NULL
      x
    })
  } else
  {
    nodes <- xpathApply(input, '//lst[@name="facet_dates"]//int')
    if(length(nodes)==0){ datesout <- NULL } else { datesout <- nodes }
  }
  
  # Facet ranges
  if(wt=='json'){
    rangesout <- lapply(input$facet_counts$facet_ranges, function(x){
      x <- x[!names(x) %in% c('gap','start','end')]$counts
      data.frame(do.call(rbind, lapply(seq(1, length(x), by=2), function(y){
        x[c(y, y+1)]
      })), stringsAsFactors=FALSE)
    })
  } else
  {
    nodes <- xpathApply(input, '//lst[@name="facet_ranges"]//int')
    if(length(nodes)==0){ rangesout <- NULL } else { rangesout <- nodes }
  }
  
  # output
  return( list(facet_queries = replacelen0(fqout), 
               facet_fields = replacelen0(ffout), 
               facet_dates = replacelen0(datesout), 
               facet_ranges = replacelen0(rangesout)) )
}

#' @method solr_parse sr_high
#' @export
#' @rdname solr_parse
solr_parse.sr_high <- function(input, parsetype='list')
{
  assert_that(is(input, "sr_high"))
  wt <- attributes(input)$wt
  input <- switch(wt, 
                  xml = xmlParse(input),
                  json = rjson::fromJSON(input))
  
  if(wt=='json'){
    if(parsetype=='df'){
      dat <- input$highlight
#       highout <- data.frame(term=names(dat), value=do.call(c, dat), stringsAsFactors=FALSE)
      highout <- data.frame(cbind(names=names(dat), do.call(rbind, dat)))
      row.names(highout) <- NULL
    } else
    {
      highout <- input$highlight
    }
  } else
  {
    highout <- xpathApply(input, '//lst[@name="highlighting"]//lst', xmlToList)
    tmptmp <- lapply(highout, function(x){
      meta <- x$.attrs[[1]]
      names(x) <- NULL
      as.list(c(meta = meta, 
                sapply(x[-length(x)], function(y){
                  tmp <- y$str[[1]]
                  names(tmp) <- y$.attrs[[1]]
                  tmp
                })
      ))
    })
    if(parsetype=='df'){
      highout <- data.frame(rbindlist(tmptmp))
#       dois <- xpathApply(input, '//lst[@name="highlighting"]//lst')
#       dois <- sapply(dois, function(x) xmlAttrs(x)['name'], USE.NAMES=FALSE)
#       nodes <- xpathApply(input, '//arr')
#       nn <- unique(sapply(nodes, function(x) xmlAttrs(x)['name'], USE.NAMES=FALSE))
#       data <- lapply(nn, function(x) xpathApply(input, sprintf('//arr[@name="%s"]', x), xmlValue))
#       highout <- data.frame(do.call(cbind, data))
#       names(highout) <- nn
    } else
    {
      highout <- tmptmp
    }
  }
  
  return( highout )
}

#' @method solr_parse sr_search
#' @export
#' @rdname solr_parse
solr_parse.sr_search <- function(input, parsetype='list')
{
  assert_that(is(input, "sr_search"))
  wt <- attributes(input)$wt
  input <- switch(wt, 
                  xml = xmlParse(input),
                  json = rjson::fromJSON(input))
  
  if(wt=='json'){
    if(parsetype=='df'){
      dat <- input$response$docs
      datout <- data.frame(rbindlist(dat))
    } else
    {
      datout <- input$response$docs
    }
  } else
  {
    temp <- xpathApply(input, '//doc')
    tmptmp <- lapply(temp, function(x){
      tt <- xmlToList(x)
      uu <- lapply(tt, function(x){
        u <- x$text[[1]]
        names(u) <- x$.attrs[[1]]
        u
      })
      names(uu) <- NULL
      as.list(unlist(uu))
    })
    if(parsetype=='df'){
      datout <- data.frame(rbindlist(tmptmp))
    } else
    {
      datout <- tmptmp
    }
  }
  
  return( datout )
}

# small function to replace elements of length 0 with NULL
replacelen0 <- function(x) if(length(x) < 1){ NULL } else { x }