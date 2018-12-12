#' Parse raw data from solr_search, solr_facet, or solr_highlight.
#'
#' @param input Output from solr_facet
#' @param parsetype One of 'list' or 'df' (data.frame)
#' @param concat Character to conactenate strings by, e.g,. ',' (character).
#' Used in solr_parse.sr_search only.
#' @details This is the parser used internally in solr_facet, but if you
#' output raw data from solr_facet using raw=TRUE, then you can use this
#' function to parse that data (a sr_facet S3 object) after the fact to a
#' list of data.frame's for easier consumption. The data format type is
#' detected from the attribute "wt" on the sr_facet object.
#' @export
solr_parse <- function(input, parsetype = NULL, concat) {
  UseMethod("solr_parse")
}

#' @export
solr_parse.default <- function(input, parsetype=NULL, concat=',') {
  stop("no 'solr_parse' method for ", class(input), call. = FALSE)
}

#' @export
solr_parse.ping <- function(input, parsetype=NULL, concat=',') {
  wt <- attributes(input)$wt
  parse_it(input, wt)
}

#' @export
solr_parse.update <- function(input, parsetype=NULL, concat=',') {
  wt <- attributes(input)$wt
  switch(wt,
         xml = xml2::read_xml(unclass(input)),
         json = jsonlite::fromJSON(input, simplifyDataFrame = FALSE,
                                   simplifyMatrix = FALSE),
         csv = jsonlite::fromJSON(input, simplifyDataFrame = FALSE,
                                  simplifyMatrix = FALSE)
  )
}

#' @export
solr_parse.sr_facet <- function(input, parsetype = NULL, concat = ',') {
  if (inherits(unclass(input), "character")) {
    input <- parse_ch(input, parsetype, concat)
  }
  # collect attributes
  wt <- attributes(input)$wt
  next_cursor_mark <- input$nextCursorMark
  response_header <- input$responseHeader

  # Facet queries
  if (wt == 'json') {
    fqdat <- input$facet_counts$facet_queries
    if (length(fqdat) == 0) {
      fqout <- NULL
    } else {
      fqout <- data_frame(
        term = names(fqdat),
        value = do.call(c, fqdat)
      )
    }
    row.names(fqout) <- NULL
  } else {
    nodes <- xml2::xml_find_all(input, '//lst[@name="facet_queries"]//int')
    if (length(nodes) == 0) {
      fqout <- NULL
    } else {
      fqout <- data_frame(
        term = xml2::xml_attr(nodes, "name"),
        value = xml2::xml_text(nodes)
      )
    }
  }

  # facet fields
  if (wt == 'json') {
    ffout <- lapply(input$facet_counts$facet_fields, function(x) {
      tibble::as_data_frame(
        stats::setNames(
          do.call(rbind.data.frame, lapply(seq(1, length(x), by = 2), function(y) {
            x[c(y, y + 1)]
          })), c('term', 'value')))
    })
  } else {
    nodes <- xml_find_all(input, '//lst[@name="facet_fields"]//lst')
    ffout <- lapply(nodes, function(z) {
      ch <- xml_children(z)
      data_frame(term = vapply(ch, xml_attr, "", attr = "name"), value = vapply(ch, xml_text, ""))
    })
    names(ffout) <- xml_attr(nodes, "name")
  }

  # facet pivot
  if (wt == 'json') {
    fpout <- NULL
    pivot_input <- jsonlite::fromJSON(jsonlite::toJSON(input))$facet_count$facet_pivot[[1]]
    if (length(pivot_input) != 0) {
      fpout <- list()
      pivots_left <- ('pivot' %in% names(pivot_input))
      if (pivots_left) {
        infinite_loop_check <- 1
        while (pivots_left & infinite_loop_check < 100) {
          stopifnot(is.data.frame(pivot_input))
          flattened_result <- pivot_flatten_tabular(pivot_input)
          fpout <- c(fpout, list(flattened_result$parent))
          pivot_input <- flattened_result$flattened_pivot
          pivots_left <- ('pivot' %in% names(pivot_input))
          infinite_loop_check <- infinite_loop_check + 1
        }
        fpout <- c(fpout, list(flattened_result$flattened_pivot))
      } else {
        fpout <- c(fpout, list(pivot_input))
      }
      fpout <- lapply(fpout, collapse_pivot_names)
      names(fpout) <- sapply(fpout, FUN = function(x) {
        paste(head(names(x), -1), collapse = ",")
      })
    }
  } else {
    message('facet.pivot results are not supported with XML response types, use wt="json"')
    fpout <- NULL
  }

  # Facet dates
  if (wt == 'json') {
    datesout <- NULL
    if (length(input$facet_counts$facet_dates) != 0) {
      datesout <- lapply(input$facet_counts$facet_dates, function(x) {
        x <- x[!names(x) %in% c('gap','start','end')]
        data_frame(date = names(x), value = do.call(c, x))
      })
    }
  } else {
    nodes <- xml_find_all(input, '//lst[@name="facet_dates"]')[[1]]
    if (length(nodes) != 0) {
      datesout <- stats::setNames(lapply(xml_children(nodes), function(z) {
        z <- xml_find_all(z, 'int')
        data_frame(
          date = xml2::xml_attr(z, "name"),
          value = xml2::xml_text(z)
        )
      }), xml_attr(xml_children(nodes), "name"))
    }
  }

  # Facet ranges
  rangesout <- NULL
  if (wt == 'json') {
    if (length(input$facet_counts$facet_ranges) != 0) {
      rangesout <- lapply(input$facet_counts$facet_ranges, function(x){
        x <- x[!names(x) %in% c('gap','start','end')]$counts
        tibble::as_data_frame(
          stats::setNames(
            do.call(rbind.data.frame, lapply(seq(1, length(x), by = 2), function(y){
              x[c(y, y + 1)]
            })), 
            c('term', 'value')
          )
        )
      })
    }
  } else {
    nodes <- xml_find_all(input, '//lst[@name="facet_ranges"]//lst[not(@name="counts")]')
    if (length(nodes) != 0) {
      rangesout <- stats::setNames(lapply(nodes, function(z) {
        z <- xml_children(xml_find_first(z, 'lst[@name="counts"]'))
        data_frame(
          term = xml2::xml_attr(z, "name"),
          value = xml2::xml_text(z)
        )
      }), xml_attr(nodes, "name"))
    }
  }

  # output
  res <- list(facet_queries = replacelen0(fqout),
              facet_fields = replacelen0(ffout),
              facet_pivot = replacelen0(fpout),
              facet_dates = replacelen0(datesout),
              facet_ranges = replacelen0(rangesout))
  res <- if (length(sc(res)) == 0) list() else res

  # attributes
  if (!is.null(next_cursor_mark)) {
    res <- add_atts(res, list(nextCursorMark = next_cursor_mark))
  }
  if (!is.null(response_header)) {
    res <- add_atts(res, list(responseHeader = response_header))
  }

  return( res )
}

#' @export
#' @rdname solr_parse
solr_parse.sr_high <- function(input, parsetype='list', concat=',') {
  if (inherits(unclass(input), "character")) input <- parse_ch(input, parsetype, concat)
  # collect attributes
  wt <- attributes(input)$wt
  next_cursor_mark <- input$nextCursorMark
  response_header <- input$responseHeader
  if (wt == 'json') {
    if (parsetype == 'df') {
      dat <- input$highlight
      df <- dplyr::bind_rows(lapply(dat, function(z) {
        dplyr::as_data_frame(lapply(z, function(w) {
          if (length(w) > 1) paste0(w, collapse = "") else w
        }))
      }))
      if (NROW(df) == 0) {
        highout <- tibble::data_frame()
      } else {
        highout <- tibble::add_column(df, names = names(dat), .before = TRUE)
      }
    } else {
      highout <- input$highlight
    }
  } else {
    highout <- xml_children(xml_find_all(input, '//lst[@name="highlighting"]'))
    tmptmp <- lapply(highout, function(z) {
      c(
        names = xml_attr(z, "name"),
        sapply(
          xml_children(z),
          function(w) as.list(stats::setNames(xml_text(w), xml_attr(w, "name"))))
      )
    })
    if (parsetype == 'df') {
      highout <- dplyr::bind_rows(lapply(tmptmp, dplyr::as_data_frame))
    } else {
      highout <- tmptmp
    }
  }

  # attributes
  if (!is.null(next_cursor_mark)) {
    highout <- add_atts(highout, list(nextCursorMark = next_cursor_mark))
  }
  if (!is.null(response_header)) {
    highout <- add_atts(highout, list(responseHeader = response_header))
  }

  return( highout )
}

#' @export
#' @rdname solr_parse
solr_parse.sr_search <- function(input, parsetype = 'list', concat = ',') {
  if (inherits(unclass(input), "character")) input <- parse_ch(input, parsetype, concat)
  # collect attributes
  wt <- attributes(input)$wt
  next_cursor_mark <- input$nextCursorMark
  response_header <- input$responseHeader
  if (wt == 'json') {
    if (parsetype == 'df') {
      dat <- input$response$docs
      dat2 <- lapply(dat, function(x) {
        lapply(x, function(y) {
          tmp <- if (length(y) > 1) {
            paste(y, collapse = concat)
          } else {
            y
          }
          if (inherits(y, "list")) unlist(tmp) else tmp
        })
      })
      datout <- dplyr::bind_rows(lapply(dat2, as_data_frame))
    } else {
      datout <- input$response$docs
    }
    datout <- add_atts(datout, popp(input$response, "docs"))
  } else if (wt == "xml") {
    temp <- xml2::xml_find_all(input, '//doc')
    tmptmp <- lapply(temp, function(x) {
      sapply(xml2::xml_children(x), nmtxt)
    })
    if (parsetype == 'df') {
      datout <- dplyr::bind_rows(lapply(tmptmp, as_data_frame))
    } else {
      datout <- tmptmp
    }
    datout <- add_atts(datout, as.list(xml2::xml_attrs(xml2::xml_find_first(input, "result"))))
  } else {
    datout <- input
  }

  if (!is.null(next_cursor_mark)) {
    datout <- add_atts(datout, list(nextCursorMark = next_cursor_mark))
  }
  if (!is.null(response_header)) {
    datout <- add_atts(datout, list(responseHeader = response_header))
  }

  return( datout )
}

#' @export
#' @rdname solr_parse
solr_parse.sr_all <- function(input, parsetype = 'list', concat = ',') {
  tmp <- list(
    search = solr_parse.sr_search(unclass(input), parsetype, concat),
    facet = solr_parse.sr_facet(unclass(input), parsetype, concat),
    high = solr_parse.sr_high(unclass(input), parsetype, concat),
    mlt = solr_parse.sr_mlt(unclass(input), parsetype, concat),
    group = solr_parse.sr_group(unclass(input), parsetype, concat),
    stats = solr_parse.sr_stats(unclass(input), parsetype, concat)
  )
  # drop attributes within each result, add to top level list
  tmp <- lapply(tmp, function(z) {
    attr(z, "nextCursorMark") <- NULL
    attr(z, "responseHeader") <- NULL
    z
  })
  next_cursor_mark <- input$nextCursorMark
  response_header <- input$responseHeader
  if (!is.null(next_cursor_mark)) {
    tmp <- add_atts(tmp, list(nextCursorMark = next_cursor_mark))
  }
  if (!is.null(response_header)) {
    tmp <- add_atts(tmp, list(responseHeader = response_header))
  }
  return(tmp)
}

#' @export
#' @rdname solr_parse
solr_parse.sr_mlt <- function(input, parsetype = 'list', concat = ',') {
  if (inherits(unclass(input), "character")) input <- parse_ch(input, parsetype, concat)
  # collect attributes
  wt <- attributes(input)$wt
  next_cursor_mark <- input$nextCursorMark
  response_header <- input$responseHeader
  if (wt == 'json') {
    if (parsetype == 'df') {
      res <- input$response
      reslist <- lapply(res$docs, function(y) {
        lapply(y, function(z) {
          if (length(z) > 1) {
            paste(z, collapse = concat)
          } else {
            z
          }
        })
      })
      resdat <- dplyr::bind_rows(lapply(reslist, as_data_frame))

      dat <- input$moreLikeThis
      dat2 <- lapply(dat, function(x){
        lapply(x$docs, function(y){
          lapply(y, function(z){
            if (length(z) > 1) {
              paste(z, collapse = concat)
            } else {
              z
            }
          })
        })
      })

      datmlt <- list()
      for (i in seq_along(dat)) {
        attsdf <- as_data_frame(popp(dat[[i]], "docs"))
        df <- dplyr::bind_rows(lapply(dat[[i]]$docs, function(y) {
          as_data_frame(lapply(y, function(z) {
            if (length(z) > 1) {
              paste(z, collapse = concat)
            } else {
              z
            }
          }))
        }))
        if (NROW(df) == 0) {
          df <- attsdf
        } else {
          df <- as_tibble(cbind(attsdf, df))
        }
        datmlt[[names(dat[i])]] <- df
      }

      datout <- list(docs = resdat, mlt = datmlt)
    } else {
      datout <- input$moreLikeThis
    }
  } else {
    res <- xml_find_all(input, '//result[@name="response"]//doc')
    resdat <- dplyr::bind_rows(lapply(res, function(x){
      tmp <- sapply(xml_children(x), nmtxt)
      as_data_frame(tmp)
    }))

    temp <- xml_find_all(input, '//lst[@name="moreLikeThis"]')
    tmptmp <- stats::setNames(lapply(xml_children(temp), function(z) {
      lapply(xml_find_all(z, "doc"), function(w) {
        sapply(xml_children(w), nmtxt)
      })
    }), xml_attr(xml_children(temp), "name"))
    tmptmp <- Map(function(x, y) {
      atts <- as.list(xml_attrs(y))
      for (i in seq_along(atts)) {
        attr(x, names(atts)[i]) <- atts[[i]]
      }
      x
    },
      tmptmp,
      xml_children(temp)
    )

    if (parsetype == 'df') {
      datmlt <- lapply(tmptmp, function(z) {
        df <- dplyr::bind_rows(lapply(z, as_data_frame))
        atts <- attributes(z)
        attsdf <- as_data_frame(atts)
        if (NROW(df) == 0) {
          attsdf
        } else {
          as_tibble(cbind(attsdf, df))
        }
      })
      datout <- list(docs = resdat, mlt = datmlt)
    } else {
      datout <- list(docs = resdat, mlt = tmptmp)
    }
  }

  if (!is.null(next_cursor_mark)) {
    datout <- add_atts(datout, list(nextCursorMark = next_cursor_mark))
  }
  if (!is.null(response_header)) {
    datout <- add_atts(datout, list(responseHeader = response_header))
  }

  return( datout )
}

#' @export
#' @rdname solr_parse
solr_parse.sr_stats <- function(input, parsetype = 'list', concat = ',') {
  if (inherits(unclass(input), "character")) input <- parse_ch(input, parsetype, concat)
  # collect attributes
  wt <- attributes(input)$wt
  next_cursor_mark <- input$nextCursorMark
  response_header <- input$responseHeader
  if (wt == 'json') {
    if (parsetype == 'df') {
      dat <- input$stats$stats_fields

      dat2 <- lapply(dat, function(x) {
        # fill null's first
        tmp <- x[!names(x) %in% 'facets']
        tmp[sapply(tmp, class) == "NULL"] <- NA_character_
        data.frame(tmp, stringsAsFactors = FALSE)
      })
      dat_reg <- do.call(rbind, dat2)

      # parse the facets
      if (length(dat[[1]]$facets) == 0) {
        dat_facet <- NULL
      } else {
        dat_facet <- lapply(dat, function(x){
          facetted <- x[names(x) %in% 'facets'][[1]]
          if (length(facetted) == 1) {
            df <- dplyr::bind_rows(
              lapply(facetted[[1]], function(z) {
                as_data_frame(
                  lapply(z[!names(z) %in% 'facets'], function(w) {
                    if (length(w) == 0) "" else w
                  })
                )
              })
            , .id = names(facetted))
          } else {
            df <- stats::setNames(lapply(seq.int(length(facetted)), function(n) {
              dplyr::bind_rows(lapply(facetted[[n]], function(b) {
                as_data_frame(
                  lapply(b[!names(b) %in% 'facets'], function(w) {
                    if (length(w) == 0) "" else w
                  })
                )
              }), .id = names(facetted)[n])
            }), names(facetted))
          }
          return(df)
        })
      }

      datout <- list(data = dat_reg, facet = dat_facet)

    } else {
      dat <- input$stats$stats_fields
      # w/o facets
      dat_reg <- lapply(dat, function(x) {
        # fill null's first
        tmp <- x[!names(x) %in% 'facets']
        tmp[sapply(tmp, class) == "NULL"] <- NA_character_
        tmp
      })
      # just facets
      dat_facet <- lapply(dat, function(x){
        if (!'facets' %in% names(x)) return(list())
        facetted <- x[names(x) %in% 'facets'][[1]]
        if (length(facetted) == 1) {
          lapply(facetted[[1]], function(z) z[!names(z) %in% 'facets'])
        } else {
          df <- lapply(facetted, function(z){
            lapply(z, function(zz) zz[!names(zz) %in% 'facets'])
          })
        }
      })

      datout <- list(data = dat_reg, facet = dat_facet)
    }
  } else {
    temp <- xml_find_all(input, '//lst/lst[@name="stats_fields"]/lst')
    if (parsetype == 'df') {
      # w/o facets
      dat_reg <- dplyr::bind_rows(stats::setNames(lapply(temp, function(h){
        as_data_frame(popp(sapply(xml_children(h), nmtxt), "facets"))
      }), xml_attr(temp, "name")), .id = "stat")
      # just facets
      dat_facet <- stats::setNames(lapply(temp, function(e){
        tt <- xml_find_first(e, 'lst[@name="facets"]')
        stats::setNames(lapply(xml_children(tt), function(f){
          dplyr::bind_rows(stats::setNames(lapply(xml_children(f), function(g){
            as_data_frame(popp(sapply(xml_children(g), nmtxt), "facets"))
          }), xml_attr(xml_children(f), "name")), .id = xml_attr(f, "name"))
        }), xml_attr(xml_children(tt), "name"))
      }), xml_attr(temp, "name"))
      datout <- list(data = dat_reg, facet = dat_facet)
    } else {
      # w/o facets
      dat_reg <- stats::setNames(lapply(temp, function(h){
        popp(sapply(xml_children(h), nmtxt), "facets")
      }), xml_attr(temp, "name"))
      # just facets
      dat_facet <- stats::setNames(lapply(temp, function(e){
        tt <- xml_find_first(e, 'lst[@name="facets"]')
        stats::setNames(lapply(xml_children(tt), function(f){
          stats::setNames(lapply(xml_children(f), function(g){
            popp(sapply(xml_children(g), nmtxt), "facets")
          }), xml_attr(xml_children(f), "name"))
        }), xml_attr(xml_children(tt), "name"))
      }), xml_attr(temp, "name"))
      datout <- list(data = dat_reg, facet = dat_facet)
    }
  }

  if (!is.null(next_cursor_mark)) {
    datout <- add_atts(datout, list(nextCursorMark = next_cursor_mark))
  }
  if (!is.null(response_header)) {
    datout <- add_atts(datout, list(responseHeader = response_header))
  }

  datout <- if (length(Filter(length, datout)) == 0) NULL else datout
  return( datout )
}

#' @export
#' @rdname solr_parse
solr_parse.sr_group <- function(input, parsetype = 'list', concat = ',') {
  if (inherits(unclass(input), "character")) input <- parse_ch(input, parsetype, concat)
  # collect attributes
  wt <- attributes(input)$wt
  next_cursor_mark <- input$nextCursorMark
  response_header <- input$responseHeader

  if (wt == 'json') {
    if (parsetype == 'df') {
      if ('response' %in% names(input)) {
        datout <- cbind(data.frame(
          numFound = input[[1]]$numFound,
          start = input[[1]]$start),
          do.call(rbind.fill, lapply(input[[1]]$docs,
                                     data.frame,
                                     stringsAsFactors = FALSE))
        )
      } else {
        dat <- input$grouped
        if (length(dat) == 1) {
          if ('groups' %in% names(dat[[1]])) {
            datout <- dat[[1]]$groups
            datout <- do.call(rbind.fill, lapply(datout, function(x){
              df <- data.frame(groupValue = ifelse(is.null(x$groupValue),"none",x$groupValue),
                               numFound = x$doclist$numFound,
                               start = x$doclist$start)
              cbind(df, do.call(rbind.fill,
                lapply(x$doclist$docs, function(z) {
                  data.frame(lapply(z, function(zz) {
                    if (length(zz) > 1) {
                      paste(zz, collapse = concat)
                    } else {
                      zz
                    }
                  }), stringsAsFactors = FALSE)
                })
              ))
            }))
          } else {
            datout <- cbind(data.frame(numFound = dat[[1]]$doclist$numFound,
                                       start = dat[[1]]$doclist$start),
                            do.call(rbind.fill, lapply(dat[[1]]$doclist$docs,
                                                       data.frame,
                                                       stringsAsFactors = FALSE)))
          }
        } else {
          if ('groups' %in% names(dat[[1]])) {
            datout <- lapply(dat, function(y) {
              y <- y$groups
              do.call(rbind.fill, lapply(y, function(x){
                df <- data.frame(
                  groupValue = ifelse(is.null(x$groupValue), "none", x$groupValue),
                  numFound = x$doclist$numFound,
                  start = x$doclist$start,
                  stringsAsFactors = FALSE
                )
                cbind(df, do.call(rbind.fill, lapply(x$doclist$docs,
                                                     data.frame,
                                                     stringsAsFactors = FALSE)))
              }))
            })
          } else {
            datout <- do.call(rbind.fill, lapply(dat, function(x){
              df <- data.frame(
                numFound = x$doclist$numFound,
                start = x$doclist$start,
                stringsAsFactors = FALSE
              )
              cbind(df, do.call(rbind.fill, lapply(x$doclist$docs,
                                                   data.frame,
                                                   stringsAsFactors = FALSE)))
            }))
          }
        }
      }
    } else {
      datout <- input$grouped
    }
  } else {
    temp <- xml_find_all(input, '//lst[@name="grouped"]/lst')
    if (parsetype == 'df') {
      datout <- stats::setNames(lapply(temp, function(e){
        tt <- xml_find_first(e, 'arr[@name="groups"]')
        dplyr::bind_rows(stats::setNames(lapply(xml_children(tt), function(f){
          docc <- xml_find_all(f, 'result[@name="doclist"]/doc')
          df <- dplyr::bind_rows(lapply(docc, function(g){
            as_data_frame(sapply(xml_children(g), nmtxt))
          }))
          add_column(
            df,
            numFound = xml_attr(xml_find_first(f, "result"), "numFound"),
            start = xml_attr(xml_find_first(f, "result"), "start"),
            .before = TRUE
          )
        }), vapply(xml_children(tt), function(z) xml_text(xml_find_first(z, "str")) %||% "", "")),
        .id = "group"
        )
      }), xml_attr(temp, "name"))
    } else {
      datout <- stats::setNames(lapply(temp, function(e){
        tt <- xml_find_first(e, 'arr[@name="groups"]')
        stats::setNames(lapply(xml_children(tt), function(f){
          docc <- xml_find_all(f, 'result[@name="doclist"]/doc')
          lst <- lapply(docc, function(g){
            sapply(xml_children(g), nmtxt)
          })
          list(
            docs = lst,
            numFound = xml_attr(xml_find_first(f, "result"), "numFound"),
            start = xml_attr(xml_find_first(f, "result"), "start")
          )
        }), vapply(xml_children(tt), function(z) xml_text(xml_find_first(z, "str")) %||% "", ""))
      }), xml_attr(temp, "name"))
    }
  }

  if (!is.null(next_cursor_mark)) {
    datout <- add_atts(datout, list(nextCursorMark = next_cursor_mark))
  }
  if (!is.null(response_header)) {
    datout <- add_atts(datout, list(responseHeader = response_header))
  }

  return( datout )
}

# helper fxns ---------------------
nmtxt <- function(x) {
  as.list(stats::setNames(xml2::xml_text(x), xml2::xml_attr(x, "name")))
}

add_atts <- function(x, atts = NULL) {
  if (!is.null(atts)) {
    for (i in seq_along(atts)) {
      attr(x, names(atts)[i]) <- atts[[i]]
    }
    return(x)
  } else {
    return(x)
  }
}

parse_it <- function(x, wt) {
  switch(
    wt,
    xml = {
      xml2::read_xml(unclass(x))
    },
    json = {
      jsonlite::fromJSON(x, simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
    },
    csv = {
      tibble::as_data_frame(
        read.table(text = x, sep = ",", stringsAsFactors = FALSE,
                   header = TRUE, fill = TRUE, comment.char = "")
      )
    }
  )
}

parse_ch <- function(x, parsetype, concat) {
  parsed <- cont_parse(x, attr(x, "wt"))
  structure(parsed, class = c(class(parsed), class(x)))
}

cont_parse <- function(x, wt) {
  structure(parse_it(x, wt), wt = wt)
}

# facet.pivot helpers --------------
#' Flatten facet.pivot responses
#'
#' Convert a nested hierarchy of facet.pivot elements
#' to tabular data (rows and columns)
#'
#' @param df_w_pivot a \code{data.frame} with another
#' \code{data.frame} nested inside representing a
#' pivot reponse
#' @return a \code{data.frame}
#'
#' @keywords internal
pivot_flatten_tabular <- function(df_w_pivot){
  # drop last column assumed to be named "pivot"
  parent <- df_w_pivot[head(names(df_w_pivot),-1)]
  pivot <- df_w_pivot$pivot
  pp <- list()
  for (i in 1:nrow(parent)) {
    if ((!is.null(pivot[[i]])) && (nrow(pivot[[i]]) > 0)) {
      # from parent drop last column assumed to be named "count" to not create duplicate columns of information
      pp[[i]] <- data.frame(cbind(parent[i,], pivot[[i]], row.names = NULL))
    }
  }
  flattened_pivot <- do.call('rbind', pp)
  # return a tbl_df to flatten again if necessary
  return(list(parent = parent, flattened_pivot = flattened_pivot))
}

#' Collapse Pivot Field and Value Columns
#'
#' Convert a table consisting of columns in sets of 3
#' into 2 columns assuming that the first column of every set of 3
#' (field) is duplicated throughout all rows and should be removed.
#' This type of structure is usually returned by facet.pivot responses.
#'
#' @param data a \code{data.frame} with every 2 columns
#' representing a field and value and the final representing
#' a count
#' @return a \code{data.frame}
#'
#' @keywords internal
collapse_pivot_names <- function(data){

  # shift field name to the column name to its right
  for (i in seq(1, ncol(data) - 1, by = 3)) {
    names(data)[i + 1] <- data[1, i]
  }

  # remove columns with duplicating information (anything named field)
  data <- data[-c(seq(1, ncol(data) - 1, by = 3))]

  # remove vestigial count columns
  if (ncol(data) > 2) {
    data <- data[-c(seq(0, ncol(data) - 1, by = 2))]
  }

  names(data)[length(data)] <- 'count'
  return(data)
}
