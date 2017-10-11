filter_keys <- function(lst, keys) lst[names(lst) %in% keys] # nocov start
keys_search <- c("q", "sort", "start", "rows", "pageDoc", "pageScore", "fl",
                 "defType", "timeAllowed", "qt", "wt", "NOW", "TZ",
                 "echoHandler", "echoParams")
keys_facet <- c(
  "q",  "facet.query",  "facet.field",
  "facet.prefix", "facet.sort", "facet.limit", "facet.offset",
  "facet.mincount", "facet.missing", "facet.method", "facet.enum.cache.minDf",
  "facet.threads", "facet.date", "facet.date.start", "facet.date.end",
  "facet.date.gap", "facet.date.hardend", "facet.date.other",
  "facet.date.include", "facet.range", "facet.range.start", "facet.range.end",
  "facet.range.gap", "facet.range.hardend", "facet.range.other",
  "facet.range.include", "facet.pivot", "facet.pivot.mincount",
  "start", "rows", "key", "wt")
keys_stats <- c("q", "stats.field", "stats.facet", "start", "rows", "key", "wt")
keys_high <- c("fl", "fq", "hl", "hl.fl", "hl.alternateField", "hl.alternateField ",
               "hl.boundaryScanner", "hl.boundaryScanner ", "hl.bs.chars",
               "hl.bs.chars", "hl.bs.country", "hl.bs.country ",
               "hl.bs.language", "hl.bs.language ", "hl.bs.maxScan",
               "hl.bs.maxScan", "hl.bs.type", "hl.bs.type ", "hl.formatter",
               "hl.formatter", "hl.fragListBuilder", "hl.fragListBuilder ",
               "hl.fragmenter", "hl.fragmenter ", "hl.fragmentsBuilder",
               "hl.fragmentsBuilder", "hl.fragsize", "hl.highlightMultiTerm",
               "hl.highlightMultiTerm", "hl.maxAlternateFieldLength",
               "hl.maxAlternateFieldLength", "hl.maxAnalyzedChars",
               "hl.maxAnalyzedChars", "hl.maxMultiValuedToExamine",
               "hl.maxMultiValuedToExamine", "hl.maxMultiValuedToMatch",
               "hl.maxMultiValuedToMatch", "hl.mergeContiguous",
               "hl.mergeContiguous", "hl.preserveMulti", "hl.preserveMulti",
               "hl.regex.maxAnalyzedChars", "hl.regex.maxAnalyzedChars",
               "hl.regex.pattern", "hl.regex.pattern ", "hl.regex.slop",
               "hl.regex.slop", "hl.requireFieldMatch", "hl.requireFieldMatch",
               "hl.simple.post", "hl.simple.post", "hl.simple.pre",
               "hl.simple.pre", "hl.snippets", "hl.useFastVectorHighlighter",
               "hl.useFastVectorHighlighter", "hl.usePhraseHighlighter",
               "hl.usePhraseHighlighter", "q", "rows", "start", "wt")
keys_group <- c("group.query","group.field", 'q', 'start', 'rows', 'sort',
                'fq', 'wt', 'group.limit', 'group.offset', 'group.sort',
                'group.sort', 'group.format', 'group.func', 'group.main',
                'group.ngroups', 'group.cache.percent', 'group.cache.percent',
                'fl')
keys_all <- c("q", "sort", "start", "rows", "pageDoc", "pageScore", "fl", "fq",
              "defType", "timeAllowed", "qt", "wt", "NOW", "TZ", "echoHandler")
keys_mlt <- c("q", "fq", "fl", "mlt.count", "mlt.fl", "mlt.mintf", "mlt.mindf",
              "mlt.minwl", "mlt.maxwl", "mlt.maxqt", "mlt.maxntp", "mlt.boost",
              "mlt.qf", "start", "rows", "wt", "mlt") # nocov end
