solrium
=======



[![Build Status](https://api.travis-ci.org/ropensci/solrium.png)](https://travis-ci.org/ropensci/solrium)
[![codecov.io](https://codecov.io/github/ropensci/solrium/coverage.svg?branch=master)](https://codecov.io/github/ropensci/solrium?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/solrium?color=2ED968)](https://github.com/metacran/cranlogs.app)

**A general purpose R interface to [Solr](http://lucene.apache.org/solr/)**

Development is now following Solr v5 and greater - which introduced many changes, which means many functions here may not work with your Solr installation older than v5.

Be aware that currently some functions will only work in certain Solr modes, e.g, `collection_create()` won't work when you are not in Solrcloud mode. But, you should get an error message stating that you aren't.

> Currently developing against Solr `v5.4.1`

> Note that we recently changed the package name to `solrium`. A previous version of this package is on CRAN as `solr`, but next version will be up as `solrium`.

## Solr info

+ [Solr home page](http://lucene.apache.org/solr/)
+ [Highlighting help](http://wiki.apache.org/solr/HighlightingParameters)
+ [Faceting help](http://wiki.apache.org/solr/SimpleFacetParameters)
+ [Solr stats](http://wiki.apache.org/solr/StatsComponent)
+ ['More like this' searches](http://wiki.apache.org/solr/MoreLikeThis)
+ [Grouping/Feild collapsing](http://wiki.apache.org/solr/FieldCollapsing)
+ [Install and Setup SOLR in OSX, including running Solr](http://risnandar.wordpress.com/2013/09/08/how-to-install-and-setup-apache-lucene-solr-in-osx/)
+ [Solr csv writer](http://wiki.apache.org/solr/CSVResponseWriter)

## Install

Stable version from CRAN


```r
install.packages("solrium")
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
#> 1       10.1371/annotation/d090733e-1f34-43c5-a06a-255456946303
#> 2 10.1371/annotation/d090733e-1f34-43c5-a06a-255456946303/title
```

### Search grouped data

Most recent publication by journal


```r
solr_group(q='*:*', group.field='journal', rows=5, group.limit=1, group.sort='publication_date desc', fl='publication_date, score')
#>                         groupValue numFound start     publication_date
#> 1                         plos one  1233651     0 2016-02-05T00:00:00Z
#> 2                   plos pathogens    42827     0 2016-02-05T00:00:00Z
#> 3                     plos biology    28755     0 2016-02-04T00:00:00Z
#> 4 plos neglected tropical diseases    33921     0 2016-02-05T00:00:00Z
#> 5                    plos genetics    49295     0 2016-02-05T00:00:00Z
#>   score
#> 1     1
#> 2     1
#> 3     1
#> 4     1
#> 5     1
```

First publication by journal


```r
solr_group(q='*:*', group.field='journal', group.limit=1, group.sort='publication_date asc', fl='publication_date, score', fq="publication_date:[1900-01-01T00:00:00Z TO *]")
#>                          groupValue numFound start     publication_date
#> 1                          plos one  1233651     0 2006-12-20T00:00:00Z
#> 2                    plos pathogens    42827     0 2005-07-22T00:00:00Z
#> 3                      plos biology    28755     0 2003-08-18T00:00:00Z
#> 4  plos neglected tropical diseases    33921     0 2007-08-30T00:00:00Z
#> 5                     plos genetics    49295     0 2005-06-17T00:00:00Z
#> 6                     plos medicine    19944     0 2004-09-07T00:00:00Z
#> 7        plos computational biology    36383     0 2005-06-24T00:00:00Z
#> 8                              none    57557     0 2005-08-23T00:00:00Z
#> 9              plos clinical trials      521     0 2006-04-21T00:00:00Z
#> 10                     plos medicin        9     0 2012-04-17T00:00:00Z
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
#> 1  1508973     0       PLOS ONE 2016-02-05T00:00:00Z
#> 2  1508973     0       PLOS ONE 2016-02-05T00:00:00Z
#> 3  1508973     0       PLOS ONE 2016-02-05T00:00:00Z
#> 4  1508973     0 PLOS Pathogens 2016-02-05T00:00:00Z
#> 5  1508973     0 PLOS Pathogens 2016-02-05T00:00:00Z
```

### Facet


```r
solr_facet(q='*:*', facet.field='journal', facet.query='cell,bird')
#> $facet_queries
#>        term value
#> 1 cell,bird    24
#>
#> $facet_fields
#> $facet_fields$journal
#>                                 X1      X2
#> 1                         plos one 1233651
#> 2                    plos genetics   49295
#> 3                   plos pathogens   42827
#> 4       plos computational biology   36383
#> 5 plos neglected tropical diseases   33921
#> 6                     plos biology   28755
#> 7                    plos medicine   19944
#> 8             plos clinical trials     521
#> 9                     plos medicin       9
#>
#>
#> $facet_pivot
#> NULL
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
#> counter_total_all   0 366453 31467       0 140736717 3.127644e+12
#> alm_twitterCount    0   1753 31467       0    166651 3.225792e+07
#>                          mean     stddev
#> counter_total_all 4472.517781 8910.30381
#> alm_twitterCount     5.296056   31.57718
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
#> 1 10.1371/journal.pbio.1001805             17004
#> 2 10.1371/journal.pbio.0020440             23871
#> 3 10.1371/journal.pone.0087217              5904
#> 4 10.1371/journal.pbio.1002191             12846
#> 5 10.1371/journal.pone.0040117              4294
```


```r
out$mlt
#> $`10.1371/journal.pbio.1001805`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0082578              2192
#> 2 10.1371/journal.pone.0098876              2434
#> 3 10.1371/journal.pone.0102159              1166
#> 4 10.1371/journal.pone.0076063              3217
#> 5 10.1371/journal.pone.0087380              1883
#>
#> $`10.1371/journal.pbio.0020440`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0035964              5524
#> 2 10.1371/journal.pone.0102679              3085
#> 3 10.1371/journal.pone.0003259              2784
#> 4 10.1371/journal.pone.0068814              7503
#> 5 10.1371/journal.pone.0101568              2648
#>
#> $`10.1371/journal.pone.0087217`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0131665               403
#> 2 10.1371/journal.pcbi.0020092             19563
#> 3 10.1371/journal.pone.0133941               463
#> 4 10.1371/journal.pone.0123774               990
#> 5 10.1371/journal.pone.0140306               321
#>
#> $`10.1371/journal.pbio.1002191`
#>                             id counter_total_all
#> 1 10.1371/journal.pbio.1002232              1936
#> 2 10.1371/journal.pone.0131700               972
#> 3 10.1371/journal.pone.0070448              1607
#> 4 10.1371/journal.pone.0144763               483
#> 5 10.1371/journal.pone.0062824              2531
#>
#> $`10.1371/journal.pone.0040117`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0069352              2743
#> 2 10.1371/journal.pone.0148280                 0
#> 3 10.1371/journal.pone.0035502              4016
#> 4 10.1371/journal.pone.0014065              5744
#> 5 10.1371/journal.pone.0113280              1977
```

### Parsing

`solr_parse` is a general purpose parser function with extension methods `solr_parse.sr_search`, `solr_parse.sr_facet`, and `solr_parse.sr_high`, for parsing `solr_search`, `solr_facet`, and `solr_highlight` function output, respectively. `solr_parse` is used internally within those three functions (`solr_search`, `solr_facet`, `solr_highlight`) to do parsing. You can optionally get back raw `json` or `xml` from `solr_search`, `solr_facet`, and `solr_highlight` setting parameter `raw=TRUE`, and then parsing after the fact with `solr_parse`. All you need to know is `solr_parse` can parse

For example:


```r
(out <- solr_highlight(q='alcohol', hl.fl = 'abstract', rows=2, raw=TRUE))
#> [1] "{\"response\":{\"numFound\":20268,\"start\":0,\"docs\":[{},{}]},\"highlighting\":{\"10.1371/journal.pmed.0040151\":{\"abstract\":[\"Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting\"]},\"10.1371/journal.pone.0027752\":{\"abstract\":[\"Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking\"]}}}\n"
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
#> 2 10.1371/journal.pone.0073791
#> 3 10.1371/journal.pone.0115069
#> 4 10.1371/journal.pone.0046362
#> 5 10.1371/journal.pone.0069841
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
#> 1 10.1371/journal.pmed.0020124           1553063
#> 2 10.1371/journal.pmed.0050045            378855
#> 3 10.1371/journal.pcbi.0030102            374783
#> 4 10.1371/journal.pone.0069841            366453
#> 5 10.1371/journal.pone.0007595            362047
```

Or with the most tweets


```r
solr_search(q='_val_:"max(alm_twitterCount)"',
    rows=5, fl='id,alm_twitterCount', fq='doc_type:full')
#> Source: local data frame [5 x 2]
#>
#>                             id alm_twitterCount
#>                          (chr)            (int)
#> 1 10.1371/journal.pone.0061981             2383
#> 2 10.1371/journal.pone.0115069             2338
#> 3 10.1371/journal.pmed.0020124             2169
#> 4 10.1371/journal.pbio.1001535             1753
#> 5 10.1371/journal.pone.0073791             1624
```

### Using specific data sources

__USGS BISON service__

The occurrences service


```r
invisible(solr_connect("http://bison.usgs.ornl.gov/solrstaging/occurrences/select"))
solr_search(q='*:*', fl=c('decimalLatitude','decimalLongitude','scientificName'), rows=2)
#> Source: local data frame [2 x 3]
#>
#>   decimalLongitude decimalLatitude        scientificName
#>              (dbl)           (dbl)                 (chr)
#> 1         -98.2376         29.5502   Nyctanassa violacea
#> 2         -98.2376         29.5502 Myiarchus cinerascens
```

The species names service


```r
invisible(solr_connect("http://bisonapi.usgs.ornl.gov/solr/scientificName/select"))
solr_search(q='*:*', raw=TRUE)
#> [1] "{\"responseHeader\":{\"status\":0,\"QTime\":12},\"response\":{\"numFound\":401329,\"start\":0,\"docs\":[{\"scientificName\":\"Catocala editha\",\"_version_\":1518645306257833984},{\"scientificName\":\"Dictyopteris polypodioides\",\"_version_\":1518645306259931136},{\"scientificName\":\"Lonicera iberica\",\"_version_\":1518645306259931137},{\"scientificName\":\"Pseudopomala brachyptera\",\"_version_\":1518645306259931138},{\"scientificName\":\"Lycopodium cernuum ingens\",\"_version_\":1518645306259931139},{\"scientificName\":\"Sanoarca\",\"_version_\":1518645306259931140},{\"scientificName\":\"Celleporina ventricosa\",\"_version_\":1518645306259931141},{\"scientificName\":\"Mactra alata\",\"_version_\":1518645306259931142},{\"scientificName\":\"Ceraticelus laticeps\",\"_version_\":1518645306259931143},{\"scientificName\":\"Reithrodontomys wetmorei\",\"_version_\":1518645306259931144}]}}\n"
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
