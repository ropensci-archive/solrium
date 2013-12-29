#' Parse raw data from solr_search, solr_facet, or solr_highlight.
#' 
#' See details.
#' 
#' @import XML rjson assertthat data.table
#' @param input Output from solr_facet
#' @param parsetype One of 'list' or 'df' (data.frame)
#' @param concat Character to conactenate strings by, e.g,. ',' (character). Used
#' in solr_parse.sr_search only.
#' @details This is the parser used internally in solr_facet, but if you output raw 
#' data from solr_facet using raw=TRUE, then you can use this function to parse that
#' data (a sr_facet S3 object) after the fact to a list of data.frame's for easier 
#' consumption. The data format type is detected from the attribute "wt" on the 
#' sr_facet object.
#' @export
solr_parse <- function(input, parsetype, concat){
  UseMethod("solr_parse")
}

#' @method solr_parse sr_facet
#' @export
#' @rdname solr_parse
solr_parse.sr_facet <- function(input, parsetype=NULL, concat=',')
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
solr_parse.sr_high <- function(input, parsetype='list', concat=',')
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
solr_parse.sr_search <- function(input, parsetype='list', concat=',')
{
  assert_that(is(input, "sr_search"))
  wt <- attributes(input)$wt
  input <- switch(wt, 
                  xml = xmlParse(input),
                  json = rjson::fromJSON(input))
  
  if(wt=='json'){
    if(parsetype=='df'){
      dat <- input$response$docs
      dat2 <- lapply(dat, function(x){
        lapply(x, function(y){
          if(length(y) > 1){
            paste(y, collapse=concat)
          } else { y  }
        })
      })
      datout <- data.frame(rbindlist(dat2))
    } else
    {
      datout <- input$response$docs
    }
  } else
  {
    temp <- xpathApply(input, '//doc')
    tmptmp <- lapply(temp, function(x){
      tt <- xmlToList(x)
      uu <- lapply(tt, function(y){
        u <- y$text[[1]]
        names(u) <- y$.attrs[[1]]
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

#' @method solr_parse sr_mlt
#' @export
#' @rdname solr_parse
solr_parse.sr_mlt <- function(input, parsetype='list', concat=',')
{
  assert_that(is(input, "sr_mlt"))
  wt <- attributes(input)$wt
  input <- switch(wt, 
                  xml = xmlParse(input),
                  json = rjson::fromJSON(input))
  
  if(wt=='json'){
    if(parsetype=='df'){
      res <- input$response
      reslist <- lapply(res$docs, function(y){
        lapply(y, function(z){
          if(length(z) > 1){
            paste(z, collapse=concat)
          } else { z  }
        })
      })
      resdat <- data.frame(rbindlist(lapply(reslist, data.frame)))
      
      dat <- input$moreLikeThis
      dat2 <- lapply(dat, function(x){
        lapply(x$docs, function(y){
          lapply(y, function(z){
            if(length(z) > 1){
              paste(z, collapse=concat)
            } else { z  }
          })
        })
      })
      foo <- function(x) data.frame(rbindlist(x))
      datmlt <- do.call(rbind, lapply(dat2, foo))
      row.names(datmlt) <- NULL
      datout <- list(docs=resdat, mlt=datmlt)
    } else
    {
      datout <- input$moreLikeThis
    }
  } else
  {
    res <- xpathApply(input, '//result[@name="response"]//doc')
    resdat <- rbindlist(lapply(res, function(x){
      tmp <- xmlChildren(x)
      tmp2 <- sapply(tmp, xmlValue)
      names2 <- sapply(tmp, xmlGetAttr, name="name")
      names(tmp2) <- names2
      as.list(tmp2)
    }))
    
    temp <- xpathApply(input, '//doc')
    tmptmp <- lapply(temp, function(x){
      tt <- xmlToList(x)
      uu <- lapply(tt, function(y){
        u <- y$text[[1]]
        names(u) <- y$.attrs[[1]]
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

#' @method solr_parse sr_stats
#' @export
#' @rdname solr_parse
solr_parse.sr_stats <- function(input, parsetype='list', concat=',')
{
  assert_that(is(input, "sr_stats"))
  wt <- attributes(input)$wt
  input <- switch(wt, 
                  xml = xmlParse(input),
                  json = rjson::fromJSON(input))
  
  if(wt=='json'){
    if(parsetype=='df'){
      dat <- input$stats$stats_fields
      if(length(dat)==1){
        datout <- data.frame(dat[[1]][!names(dat[[1]]) %in% 'facets'])
      } else {
        dat2 <- lapply(dat, function(x){
          data.frame(x[!names(x) %in% 'facets'])
        })
        dat_reg <- do.call(rbind, dat2)
        
        # facets
        dat_facet <- lapply(dat, function(x){
          facetted <- x[names(x) %in% 'facets'][[1]]
          if(length(facetted) == 1){
            df <- do.call(rbind, lapply(facetted[[1]], function(z) data.frame(z[!names(z) %in% 'facets'])))
            df <- data.frame(df, row.names(df))
            names(df)[ncol(df)] <- names(facetted)
          } else {
            df <- lapply(facetted, function(z){
              dd <- do.call(rbind, lapply(z, function(zz) data.frame(zz[!names(zz) %in% 'facets'])))
              dd <- data.frame(dd, row.names(dd))
              row.names(dd) <- NULL
              names(dd)[ncol(dd)] <- "facet_field"
              dd
            })
          }
        })
        datout <- list(data=dat_reg, facet=dat_facet)
      }
    } else
    {
      dat <- input$stats$stats_fields
      # w/o facets
      dat_reg <- lapply(dat, function(x){
        x[!names(x) %in% 'facets']
      })
      # just facets
      dat_facet <- lapply(dat, function(x){
        facetted <- x[names(x) %in% 'facets'][[1]]
        if(length(facetted) == 1){
          lapply(facetted[[1]], function(z) z[!names(z) %in% 'facets'])
        } else {
          df <- lapply(facetted, function(z){
            lapply(z, function(zz) zz[!names(zz) %in% 'facets'])
          })
        }
      })
      
      datout <- list(data=dat_reg, facet=dat_facet)
    }
  } else
  {
    temp <- xpathApply(input, '//lst/lst[@name="stats_fields"]/lst')
    if(parsetype=='df'){
      # w/o facets
      dat_reg <- data.frame(rbindlist(lapply(temp, function(h){
        tt <- xmlChildren(h)
        uu <- tt[!names(tt) %in% 'lst']
        vals <- sapply(uu, xmlValue)
        names2 <- sapply(uu, xmlGetAttr, name="name")
        names(vals) <- names2
        data.frame(rbind(vals))
      })))
      # just facets
      dat_facet <- lapply(temp, function(e){
        tt <- xmlChildren(e)
        uu <- tt[names(tt) %in% 'lst']
        lapply(xmlChildren(uu$lst), function(f){
          data.frame(rbindlist(lapply(xmlChildren(f), function(g){
            ttt <- xmlChildren(g)
            uuu <- ttt[!names(ttt) %in% 'lst']
            vals <- sapply(uuu, xmlValue)
            names2 <- sapply(uuu, xmlGetAttr, name="name")
            names(vals) <- names2
            data.frame(rbind(vals))
          })))
        })
      })
      datout <- list(data=dat_reg, facet=dat_facet)
    } else
    {
      dat_reg <- lapply(temp, function(h){
        title <- xmlAttrs(h)[[1]]
        tt <- xmlChildren(h)
        uu <- tt[!names(tt) %in% 'lst']
        vals <- sapply(uu, xmlValue)
        names2 <- sapply(uu, xmlGetAttr, name="name")
        names(vals) <- names2
        ss <- list(x=as.list(vals))
        names(ss) <- title
        ss
      })
      # just facets
      dat_facet <- lapply(temp, function(e){
        title1 <- xmlAttrs(e)[[1]]
        tt <- xmlChildren(e)
        uu <- tt[names(tt) %in% 'lst']
        ssss <- lapply(xmlChildren(uu$lst), function(f){
          title2 <- xmlAttrs(f)[[1]]
          sss <- lapply(xmlChildren(f), function(g){
            title3 <- xmlAttrs(g)[[1]]
            ttt <- xmlChildren(g)
            uuu <- ttt[!names(ttt) %in% 'lst']
            vals <- sapply(uuu, xmlValue)
            names2 <- sapply(uuu, xmlGetAttr, name="name")
            names(vals) <- names2
            ss <- list(x=as.list(vals))
            names(ss) <- eval(title3)
            ss
          })
          names(sss) <- rep(eval(title2), length(names(sss)))
          sss
        })
        names(ssss) <- rep(eval(title1), length(names(ssss)))
        ssss
      })
      datout <- list(data=dat_reg, facet=dat_facet)
    }
  }
  
  return( datout )
}

# small function to replace elements of length 0 with NULL
replacelen0 <- function(x) if(length(x) < 1){ NULL } else { x }