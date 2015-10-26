solrium
=======



[![Build Status](https://api.travis-ci.org/ropensci/solrium.png)](https://travis-ci.org/ropensci/solrium)
[![codecov.io](https://codecov.io/github/ropensci/solrium/coverage.svg?branch=master)](https://codecov.io/github/ropensci/solrium?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/solrium?color=2ED968)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/solrium)](http://cran.rstudio.com/web/packages/solrium)

**A general purpose R interface to [Solr](http://lucene.apache.org/solr/)**

Development is now following Solr v5 and greater - which introduced many changes, which means many functions here may not work with your Solr installation older than v5.

Be aware that currently some functions will only work in certain Solr modes, e.g, `collection_create()` won't work when you are not in Solrcloud mode. But, you should get an error message stating that you aren't.

Some notes: 

* Currently developing against Solr `v5.3.0`
* Note that we recently changed the package name to `solrium`. A previous version of this package is on CRAN as `solr`, but next version will be up as `solrium`.
* I'm holding off on pushing this revamped version of this R client until I think the next version of Solr comes out with hopefully HTTP API access to manipulating cores/collections better.

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

## Install

Stable version from CRAN


```r
install.packages("solr")
```

Or development version from GitHub


```r
devtools::install_github("ropensci/solrium")
```


```r
library("solrium")
```

## Setup

Use `solr_connect()` to initialize your connection. These examples use a remote Solr server, but work on any local Solr server.


```r
invisible(solr_connect('http://api.plos.org/search'))
```

You can also set whether you want simple or detailed error messages (via `errors`), and whether you want URLs used in each function call or not (via `verbose`), and your proxy settings (via `proxy`) if needed. For example:


```r
solr_connect("localhost:8983", errors = "complete", verbose = FALSE)
```

Then you can get your settings like


```r
solr_settings()
#> <solr_connection>
#>   url:    localhost:8983
#>   errors: complete
#>   verbose: FALSE
#>   proxy:
```

## Search


```r
solr_search(q='*:*', rows=2, fl='id')
#> Source: local data frame [2 x 1]
#> 
#>                                                              id
#>                                                           (chr)
#> 1       10.1371/annotation/ec04ad74-63cc-4fbe-9ad8-074a1d62fdf4
#> 2 10.1371/annotation/ec04ad74-63cc-4fbe-9ad8-074a1d62fdf4/title
```

### Search grouped data

Most recent publication by journal


```r
solr_group(q='*:*', group.field='journal', rows=5, group.limit=1, group.sort='publication_date desc', fl='publication_date, score')
#>                   groupValue numFound start     publication_date score
#> 1                   plos one  1127931     0 2015-08-26T00:00:00Z     1
#> 2             plos pathogens    40309     0 2015-08-25T00:00:00Z     1
#> 3               plos biology    27807     0 2015-08-26T00:00:00Z     1
#> 4              plos medicine    19322     0 2015-08-25T00:00:00Z     1
#> 5 plos computational biology    33498     0 2015-08-26T00:00:00Z     1
```

First publication by journal


```r
solr_group(q='*:*', group.field='journal', group.limit=1, group.sort='publication_date asc', fl='publication_date, score', fq="publication_date:[1900-01-01T00:00:00Z TO *]")
#>                          groupValue numFound start     publication_date
#> 1                          plos one  1127931     0 2006-12-20T00:00:00Z
#> 2                    plos pathogens    40309     0 2005-07-22T00:00:00Z
#> 3                      plos biology    27807     0 2003-08-18T00:00:00Z
#> 4                     plos medicine    19322     0 2004-09-07T00:00:00Z
#> 5        plos computational biology    33498     0 2005-06-24T00:00:00Z
#> 6                     plos genetics    46143     0 2005-06-17T00:00:00Z
#> 7                  plos collections       20     0 2014-07-02T00:00:00Z
#> 8  plos neglected tropical diseases    30625     0 2007-08-30T00:00:00Z
#> 9                              none    57557     0 2005-08-23T00:00:00Z
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
solr_group(q='*:*', group.query='publication_date:[2013-01-01T00:00:00Z TO 2013-12-31T00:00:00Z]', group.limit = 3, group.sort='publication_date desc', fl='publication_date')
#>   numFound start     publication_date
#> 1   307081     0 2013-12-31T00:00:00Z
#> 2   307081     0 2013-12-31T00:00:00Z
#> 3   307081     0 2013-12-31T00:00:00Z
```

Search group with format simple


```r
solr_group(q='*:*', group.field='journal', rows=5, group.limit=3, group.sort='publication_date desc', group.format='simple', fl='journal, publication_date')
#>   numFound start        journal     publication_date
#> 1  1389877     0       PLOS ONE 2015-08-26T00:00:00Z
#> 2  1389877     0       PLOS ONE 2015-08-26T00:00:00Z
#> 3  1389877     0       PLOS ONE 2015-08-26T00:00:00Z
#> 4  1389877     0 PLOS Pathogens 2015-08-25T00:00:00Z
#> 5  1389877     0 PLOS Pathogens 2015-08-25T00:00:00Z
```

### Facet


```r
solr_facet(q='*:*', facet.field='journal', facet.query='cell,bird')
#> $facet_queries
#>        term value
#> 1 cell,bird    21
#> 
#> $facet_fields
#> $facet_fields$journal
#>                                  X1      X2
#> 1                          plos one 1127931
#> 2                     plos genetics   46143
#> 3                    plos pathogens   40309
#> 4        plos computational biology   33498
#> 5  plos neglected tropical diseases   30625
#> 6                      plos biology   27807
#> 7                     plos medicine   19322
#> 8              plos clinical trials     521
#> 9                  plos collections      20
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
solr_highlight(q='alcohol', hl.fl = 'abstract', rows=2)
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
out <- solr_stats(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), stats.facet='journal')
```


```r
out$data
#>                   min    max count missing       sum sumOfSquares
#> counter_total_all   0 337257 28897       0 109466738 2.226977e+12
#> alm_twitterCount    0   1691 28897       0    143795 2.587437e+07
#>                          mean     stddev
#> counter_total_all 3788.169637 7919.46856
#> alm_twitterCount     4.976122   29.50709
```

### More like this

`solr_mlt` is a function to return similar documents to the one


```r
out <- solr_mlt(q='title:"ecology" AND body:"cell"', mlt.fl='title', mlt.mindf=1, mlt.mintf=1, fl='counter_total_all', rows=5)
```


```r
out$docs
#> Source: local data frame [5 x 2]
#> 
#>                             id counter_total_all
#>                          (chr)             (int)
#> 1 10.1371/journal.pbio.1001805             13766
#> 2 10.1371/journal.pbio.0020440             16995
#> 3 10.1371/journal.pone.0087217              4763
#> 4 10.1371/journal.pbio.1002191              8551
#> 5 10.1371/journal.pone.0040117              3211
```


```r
out$mlt
#> $`10.1371/journal.pbio.1001805`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0082578              1784
#> 2 10.1371/journal.pone.0098876              1055
#> 3 10.1371/journal.pone.0102159               781
#> 4 10.1371/journal.pone.0087380              1386
#> 5 10.1371/journal.pcbi.1003408              5670
#> 
#> $`10.1371/journal.pbio.0020440`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0102679              2414
#> 2 10.1371/journal.pone.0035964              3997
#> 3 10.1371/journal.pone.0003259              1919
#> 4 10.1371/journal.pone.0101568              2002
#> 5 10.1371/journal.pone.0068814              6714
#> 
#> $`10.1371/journal.pone.0087217`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0131665               170
#> 2 10.1371/journal.pcbi.0020092             16263
#> 3 10.1371/journal.pone.0133941               172
#> 4 10.1371/journal.pone.0123774               722
#> 5 10.1371/journal.pone.0063375              1614
#> 
#> $`10.1371/journal.pbio.1002191`
#>                             id counter_total_all
#> 1 10.1371/journal.pbio.1002232               867
#> 2 10.1371/journal.pone.0131700               390
#> 3 10.1371/journal.pone.0070448              1035
#> 4 10.1371/journal.pone.0052330              3939
#> 5 10.1371/journal.pone.0062824              1602
#> 
#> $`10.1371/journal.pone.0040117`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0069352              2072
#> 2 10.1371/journal.pone.0035502              3036
#> 3 10.1371/journal.pone.0014065              4471
#> 4 10.1371/journal.pone.0113280              1442
#> 5 10.1371/journal.pone.0078369              2677
```

### Parsing

`solr_parse` is a general purpose parser function with extension methods `solr_parse.sr_search`, `solr_parse.sr_facet`, and `solr_parse.sr_high`, for parsing `solr_search`, `solr_facet`, and `solr_highlight` function output, respectively. `solr_parse` is used internally within those three functions (`solr_search`, `solr_facet`, `solr_highlight`) to do parsing. You can optionally get back raw `json` or `xml` from `solr_search`, `solr_facet`, and `solr_highlight` setting parameter `raw=TRUE`, and then parsing after the fact with `solr_parse`. All you need to know is `solr_parse` can parse

For example:


```r
(out <- solr_highlight(q='alcohol', hl.fl = 'abstract', rows=2, raw=TRUE))
#> [1] "{\"response\":{\"numFound\":18501,\"start\":0,\"docs\":[{},{}]},\"highlighting\":{\"10.1371/journal.pmed.0040151\":{\"abstract\":[\"Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting\"]},\"10.1371/journal.pone.0027752\":{\"abstract\":[\"Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking\"]}}}\n"
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
  rows=5, fl='id,title', fq='doc_type:full')
#> Source: local data frame [5 x 2]
#> 
#>                             id
#>                          (chr)
#> 1 10.1371/journal.pmed.0020124
#> 2 10.1371/journal.pone.0115069
#> 3 10.1371/journal.pone.0069841
#> 4 10.1371/journal.pone.0105948
#> 5 10.1371/journal.pone.0046362
#> Variables not shown: title (chr)
```

Here, we search for the papers with the most citations


```r
solr_search(q='_val_:"max(counter_total_all)"',
    rows=5, fl='id,counter_total_all', fq='doc_type:full')
#> Source: local data frame [5 x 2]
#> 
#>                             id counter_total_all
#>                          (chr)             (int)
#> 1 10.1371/journal.pmed.0020124           1178768
#> 2 10.1371/journal.pmed.0050045            341152
#> 3 10.1371/journal.pone.0007595            337257
#> 4 10.1371/journal.pone.0069841            330639
#> 5 10.1371/journal.pone.0033288            309175
```

Or with the most tweets


```r
solr_search(q='_val_:"max(alm_twitterCount)"',
    rows=5, fl='id,alm_twitterCount', fq='doc_type:full')
#> Source: local data frame [5 x 2]
#> 
#>                             id alm_twitterCount
#>                          (chr)            (int)
#> 1 10.1371/journal.pone.0061981             2382
#> 2 10.1371/journal.pone.0115069             2325
#> 3 10.1371/journal.pmed.0020124             1926
#> 4 10.1371/journal.pbio.1001535             1691
#> 5 10.1371/journal.pmed.1001747             1526
```

### Using specific data sources

__USGS BISON service__

The occurrences service


```r
invisible(solr_connect("http://bison.usgs.ornl.gov/solrstaging/occurrences/select"))
solr_search(q='*:*', fl=c('decimalLatitude','decimalLongitude','scientificName'), rows=2)
#> Source: local data frame [2 x 3]
#> 
#>   decimalLongitude decimalLatitude    scientificName
#>              (dbl)           (dbl)             (chr)
#> 1         -73.8053         42.3202 Buteo jamaicensis
#> 2         -73.8053         42.3202    Circus cyaneus
```

The species names service


```r
invisible(solr_connect("http://bisonapi.usgs.ornl.gov/solr/scientificName/select"))
solr_search(q='*:*', raw=TRUE)
#> [1] "{\"responseHeader\":{\"status\":0,\"QTime\":7},\"response\":{\"numFound\":380493,\"start\":0,\"docs\":[{\"scientificName\":\"Pinus rigida globosa\",\"_version_\":1509960226766323717},{\"scientificName\":\"Cestrum intermedium\",\"_version_\":1509960226767372288},{\"scientificName\":\"Tachyempis\",\"_version_\":1509960226767372289},{\"scientificName\":\"Arabis codyi\",\"_version_\":1509960226767372290},{\"scientificName\":\"Gaudryinella\",\"_version_\":1509960226767372291},{\"scientificName\":\"Virginia elegans\",\"_version_\":1509960226767372292},{\"scientificName\":\"Helicogloea contorta\",\"_version_\":1509960226767372293},{\"scientificName\":\"Partulina fusoidea\",\"_version_\":1509960226767372294},{\"scientificName\":\"Ectemnius scaber\",\"_version_\":1509960226767372295},{\"scientificName\":\"Cerithiopsis stejnegeri dina\",\"_version_\":1509960226767372296}]}}\n"
#> attr(,"class")
#> [1] "sr_search"
#> attr(,"wt")
#> [1] "json"
```

__PLOS Search API__

Most of the examples above use the PLOS search API... :)

## Solr server management

This isn't as complete as searching functions show above, but we're getting there.

### Cores

Many functions, e.g.:

* `core_create()`
* `core_rename()`
* `core_status()`
* ...

Create a core


```r
core_create(name = "foo_bar")
```

### Collections

Many functions, e.g.:

* `collection_create()`
* `collection_list()`
* `collection_addrole()`
* ...

Create a collection


```r
collection_create(name = "hello_world")
```

### Add documents

Add documents, supports adding from files (json, xml, or csv format), and from R objects (including `data.frame` and `list` types so far)


```r
df <- data.frame(id = c(67, 68), price = c(1000, 500000000))
add(df, name = "books")
```

Delete documents, by id


```r
delete_by_id(ids = c(3, 4))
```

Or by query


```r
delete_by_query(query = "manu:bank")
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/solrium/issues)
* License: MIT
* Get citation information for `solrium` in R doing `citation(package = 'solrium')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
