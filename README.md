solr
=======



[![Build Status](https://api.travis-ci.org/ropensci/solr.png)](https://travis-ci.org/ropensci/solr)
[![Build status](https://ci.appveyor.com/api/projects/status/ytgtb62gsgf5hddi/branch/master)](https://ci.appveyor.com/project/sckott/solr/branch/master)
[![Coverage Status](https://coveralls.io/repos/ropensci/solr/badge.svg)](https://coveralls.io/r/ropensci/solr)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/solr?color=2ED968)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/solr)](http://cran.rstudio.com/web/packages/solr)

**A general purpose R interface to [Solr](http://lucene.apache.org/solr/)**

This package only deals with extracting data from a Solr endpoint, not writing data (pull request or holla if you're interested in writing solr data).

## Solr info

+ [Solr home page](http://lucene.apache.org/solr/)
+ [Highlighting help](http://wiki.apache.org/solr/HighlightingParameters)
+ [Faceting help](http://wiki.apache.org/solr/SimpleFacetParameters)
+ [Solr stats](http://wiki.apache.org/solr/StatsComponent)
+ ['More like this' searches](http://wiki.apache.org/solr/MoreLikeThis)
+ [Grouping/Feild collapsing](http://wiki.apache.org/solr/FieldCollapsing)
+ [Installing Solr on Mac using homebrew](http://ramlev.dk/blog/2012/06/02/install-apache-solr-on-your-mac/)
+ [Install and Setup SOLR in OSX, including running Solr](http://risnandar.wordpress.com/2013/09/08/how-to-install-and-setup-apache-lucene-solr-in-osx/)
+ [Solr csv writer](http://wiki.apache.org/solr/CSVResponseWriter)

## Quick start

### Install

Stable version from CRAN 


```r
install.packages("solr")
```

Or development version from GitHub


```r
devtools::install_github("ropensci/solr")
```


```r
library("solr")
```

__Define stuff__ Your base url and a key (if needed). This example should work. You do need to pass a key to the Public Library of Science search API, but it apparently doesn't need to be a real one.


```r
url <- 'http://api.plos.org/search'
key <- 'key'
```

### Search


```r
solr_search(q='*:*', rows=2, fl='id', base=url, key=key)
#> Source: local data frame [2 x 1]
#> 
#>                                      id
#> 1    10.1371/journal.pone.0123754/title
#> 2 10.1371/journal.pone.0123754/abstract
```

### Search grouped data

Most recent publication by journal


```r
solr_group(q='*:*', group.field='journal', rows=5, group.limit=1, group.sort='publication_date desc', fl='publication_date, score', base=url, key=key)
#>                         groupValue numFound start     publication_date
#> 1                         plos one  1085980     0 2015-07-02T00:00:00Z
#> 2       plos computational biology    32847     0 2015-07-02T00:00:00Z
#> 3                             none    63644     0 2012-10-23T00:00:00Z
#> 4 plos neglected tropical diseases    29668     0 2015-07-02T00:00:00Z
#> 5                     plos biology    27477     0 2015-07-02T00:00:00Z
#>   score
#> 1     1
#> 2     1
#> 3     1
#> 4     1
#> 5     1
```

First publication by journal


```r
solr_group(q='*:*', group.field='journal', group.limit=1, group.sort='publication_date asc', fl='publication_date, score', fq="publication_date:[1900-01-01T00:00:00Z TO *]", base=url, key=key)
#>                          groupValue numFound start     publication_date
#> 1                          plos one  1085980     0 2006-12-01T00:00:00Z
#> 2        plos computational biology    32847     0 2005-06-24T00:00:00Z
#> 3                              none    57557     0 2005-08-23T00:00:00Z
#> 4  plos neglected tropical diseases    29668     0 2007-08-30T00:00:00Z
#> 5                      plos biology    27477     0 2003-08-18T00:00:00Z
#> 6                     plos medicine    19179     0 2004-09-07T00:00:00Z
#> 7                    plos pathogens    39488     0 2005-07-22T00:00:00Z
#> 8                     plos genetics    45235     0 2005-06-17T00:00:00Z
#> 9                      plos medicin        9     0 2012-04-17T00:00:00Z
#> 10             plos clinical trials      521     0 2006-04-21T00:00:00Z
#>    score
#> 1      1
#> 2      1
#> 3      1
#> 4      1
#> 5      1
#> 6      1
#> 7      1
#> 8      1
#> 9      1
#> 10     1
```

Search group query : Last 3 publications of 2013.


```r
solr_group(q='*:*', group.query='publication_date:[2013-01-01T00:00:00Z TO 2013-12-31T00:00:00Z]', group.limit = 3, group.sort='publication_date desc', fl='publication_date', base=url, key=key)
#>   numFound start     publication_date
#> 1   307081     0 2013-12-31T00:00:00Z
#> 2   307081     0 2013-12-31T00:00:00Z
#> 3   307081     0 2013-12-31T00:00:00Z
```

Search group with format simple


```r
solr_group(q='*:*', group.field='journal', rows=5, group.limit=3, group.sort='publication_date desc', group.format='simple', fl='journal, publication_date', base=url, key=key)
#>   numFound start                    journal     publication_date
#> 1  1344063     0                   PLOS ONE 2015-07-02T00:00:00Z
#> 2  1344063     0                   PLOS ONE 2015-07-02T00:00:00Z
#> 3  1344063     0                   PLOS ONE 2015-07-02T00:00:00Z
#> 4  1344063     0 PLOS Computational Biology 2015-07-02T00:00:00Z
#> 5  1344063     0 PLOS Computational Biology 2015-07-02T00:00:00Z
```

### Facet


```r
solr_facet(q='*:*', facet.field='journal', facet.query='cell,bird', base=url, key=key)
#> $facet_queries
#>        term value
#> 1 cell,bird    21
#> 
#> $facet_fields
#> $facet_fields$journal
#>                                  X1      X2
#> 1                          plos one 1085980
#> 2                     plos genetics   45235
#> 3                    plos pathogens   39488
#> 4        plos computational biology   32847
#> 5  plos neglected tropical diseases   29668
#> 6                      plos biology   27477
#> 7                     plos medicine   19179
#> 8              plos clinical trials     521
#> 9                  plos collections      15
#> 10                     plos medicin       9
#> 
#> 
#> $facet_dates
#> NULL
#> 
#> $facet_ranges
#> NULL
```

### Highlight


```r
solr_highlight(q='alcohol', hl.fl = 'abstract', rows=2, base = url, key=key)
#> $`10.1371/journal.pmed.0040151`
#> $`10.1371/journal.pmed.0040151`$abstract
#> [1] "Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting"
#> 
#> 
#> $`10.1371/journal.pone.0027752`
#> $`10.1371/journal.pone.0027752`$abstract
#> [1] "Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking"
```

### Stats


```r
out <- solr_stats(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), stats.facet='journal', base=url, key=key)
```


```r
out$data
#>                   min    max count missing       sum sumOfSquares
#> counter_total_all   0 328552 27897       0 101291508 1.985326e+12
#> alm_twitterCount    0   1670 27897       0    124682 2.240976e+07
#>                          mean    stddev
#> counter_total_all 3630.910420 7614.7779
#> alm_twitterCount     4.469369   27.9885
```

### More like this

`solr_mlt` is a function to return similar documents to the one


```r
out <- solr_mlt(q='title:"ecology" AND body:"cell"', mlt.fl='title', mlt.mindf=1, mlt.mintf=1, fl='counter_total_all', rows=5, base=url, key=key)
```


```r
out$docs
#> Source: local data frame [5 x 2]
#> 
#>                             id counter_total_all
#> 1 10.1371/journal.pbio.1001805             11747
#> 2 10.1371/journal.pbio.0020440             16883
#> 3 10.1371/journal.pone.0087217              4310
#> 4 10.1371/journal.pone.0040117              2967
#> 5 10.1371/journal.pone.0072525              1281
```


```r
out$mlt
#> $`10.1371/journal.pbio.1001805`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0082578              1683
#> 2 10.1371/journal.pone.0098876               986
#> 3 10.1371/journal.pone.0102159               645
#> 4 10.1371/journal.pone.0087380              1209
#> 5 10.1371/journal.pcbi.1003408              5081
#> 
#> $`10.1371/journal.pbio.0020440`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0102679              2161
#> 2 10.1371/journal.pone.0035964              3838
#> 3 10.1371/journal.pone.0003259              1890
#> 4 10.1371/journal.pone.0101568              1776
#> 5 10.1371/journal.pntd.0003377              2848
#> 
#> $`10.1371/journal.pone.0087217`
#>                             id counter_total_all
#> 1 10.1371/journal.pcbi.0020092             15860
#> 2 10.1371/journal.pone.0123774                 0
#> 3 10.1371/journal.pone.0063375              1539
#> 4 10.1371/journal.pcbi.1000986              2913
#> 5 10.1371/journal.pone.0015143             13713
#> 
#> $`10.1371/journal.pone.0040117`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0069352              1854
#> 2 10.1371/journal.pone.0035502              2848
#> 3 10.1371/journal.pone.0014065              4238
#> 4 10.1371/journal.pone.0113280              1172
#> 5 10.1371/journal.pone.0078369              2474
#> 
#> $`10.1371/journal.pone.0072525`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0060766              1707
#> 2 10.1371/journal.pcbi.1002928              8040
#> 3 10.1371/journal.pone.0124699               275
#> 4 10.1371/journal.pone.0129588                 0
#> 5 10.1371/journal.pone.0072862              3445
```

### Parsing

`solr_parse` is a general purpose parser function with extension methods `solr_parse.sr_search`, `solr_parse.sr_facet`, and `solr_parse.sr_high`, for parsing `solr_search`, `solr_facet`, and `solr_highlight` function output, respectively. `solr_parse` is used internally within those three functions (`solr_search`, `solr_facet`, `solr_highlight`) to do parsing. You can optionally get back raw `json` or `xml` from `solr_search`, `solr_facet`, and `solr_highlight` setting parameter `raw=TRUE`, and then parsing after the fact with `solr_parse`. All you need to know is `solr_parse` can parse

For example:


```r
(out <- solr_highlight(q='alcohol', hl.fl = 'abstract', rows=2, base = url, key=key, raw=TRUE))
#> [1] "{\"response\":{\"numFound\":17804,\"start\":0,\"docs\":[{},{}]},\"highlighting\":{\"10.1371/journal.pmed.0040151\":{\"abstract\":[\"Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting\"]},\"10.1371/journal.pone.0027752\":{\"abstract\":[\"Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking\"]}}}\n"
#> attr(,"class")
#> [1] "sr_high"
#> attr(,"wt")
#> [1] "json"
```

Then parse


```r
solr_parse(out, 'df')
#>                          names
#> 1 10.1371/journal.pmed.0040151
#> 2 10.1371/journal.pone.0027752
#>                                                                                                    abstract
#> 1   Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting
#> 2 Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking
```

### Advanced: Function Queries

Function Queries allow you to query on actual numeric fields in the SOLR database, and do addition, multiplication, etc on one or many fields to stort results. For example, here, we search on the product of counter_total_all and alm_twitterCount, using a new temporary field "_val_"


```r
solr_search(q='_val_:"product(counter_total_all,alm_twitterCount)"',
  rows=5, fl='id,title', fq='doc_type:full', base=url, key=key)
#> Source: local data frame [5 x 2]
#> 
#>                             id
#> 1 10.1371/journal.pmed.0020124
#> 2 10.1371/journal.pone.0115069
#> 3 10.1371/journal.pone.0105948
#> 4 10.1371/journal.pone.0083325
#> 5 10.1371/journal.pone.0069841
#> Variables not shown: title (chr)
```

Here, we search for the papers with the most citations


```r
solr_search(q='_val_:"max(counter_total_all)"',
    rows=5, fl='id,counter_total_all', fq='doc_type:full', base=url, key=key)
#> Source: local data frame [5 x 2]
#> 
#>                             id counter_total_all
#> 1 10.1371/journal.pmed.0020124           1110803
#> 2 10.1371/journal.pmed.0050045            336537
#> 3 10.1371/journal.pone.0007595            328552
#> 4 10.1371/journal.pone.0069841            316100
#> 5 10.1371/journal.pone.0033288            308133
```

Or with the most tweets


```r
solr_search(q='_val_:"max(alm_twitterCount)"',
    rows=5, fl='id,alm_twitterCount', fq='doc_type:full', base=url, key=key)
#> Source: local data frame [5 x 2]
#> 
#>                             id alm_twitterCount
#> 1 10.1371/journal.pone.0061981             2381
#> 2 10.1371/journal.pone.0115069             2275
#> 3 10.1371/journal.pmed.0020124             1769
#> 4 10.1371/journal.pbio.1001535             1670
#> 5 10.1371/journal.pone.0083325             1508
```

### Using specific data sources

__USGS BISON service__

The occurrences service


```r
url <- "http://bison.usgs.ornl.gov/solrstaging/occurrences/select"
solr_search(q='*:*', base=url2, fl=c('decimalLatitude','decimalLongitude','scientificName'), rows=2)
#> Source: local data frame [0 x 0]
```

The species names service


```r
url2 <- "http://bisonapi.usgs.ornl.gov/solr/scientificName/select"
solr_search(q='*:*', base=url2, raw=TRUE)
#> [1] "{}"
#> attr(,"class")
#> [1] "sr_search"
#> attr(,"wt")
#> [1] "json"
```

__PLOS Search API__

Most of the examples above use the PLOS search API... :)

### Meta

* Please [report any issues or bugs](https://github.com/ropensci/solr/issues).
* License: MIT
* Get citation information for `solr` in R doing `citation(package = 'solr')`

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
