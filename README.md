solr
=======



[![Build Status](https://api.travis-ci.org/ropensci/solr.png)](https://travis-ci.org/ropensci/solr)
[![Build status](https://ci.appveyor.com/api/projects/status/ytgtb62gsgf5hddi/branch/master)](https://ci.appveyor.com/project/sckott/solr/branch/master)

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

Install solr


```r
install.packages("devtools")
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
#>                                   id
#> 1 10.1371/journal.pone.0017064/title
#> 2 10.1371/journal.pntd.0001917/title
```

### Search grouped data

Most recent publication by journal


```r
solr_group(q='*:*', group.field='journal', rows=5, group.limit=1, group.sort='publication_date desc', fl='publication_date, score', base=url, key=key)
#>                         groupValue numFound start     publication_date
#> 1                         plos one   913504     0 2014-11-04T00:00:00Z
#> 2 plos neglected tropical diseases    24632     0 2014-10-30T00:00:00Z
#> 3                     plos biology    26050     0 2014-11-04T00:00:00Z
#> 4                   plos pathogens    35156     0 2014-10-30T00:00:00Z
#> 5                             none    63572     0 2012-10-23T00:00:00Z
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
#> 1                          plos one   913504     0 2006-12-01T00:00:00Z
#> 2  plos neglected tropical diseases    24632     0 2007-08-30T00:00:00Z
#> 3                      plos biology    26050     0 2003-08-18T00:00:00Z
#> 4                    plos pathogens    35156     0 2005-07-22T00:00:00Z
#> 5                              none    57566     0 2005-08-23T00:00:00Z
#> 6                     plos genetics    40184     0 2005-06-17T00:00:00Z
#> 7        plos computational biology    29404     0 2005-06-24T00:00:00Z
#> 8                     plos medicine    18449     0 2004-09-07T00:00:00Z
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
#> 1   307050     0 2013-12-31T00:00:00Z
#> 2   307050     0 2013-12-31T00:00:00Z
#> 3   307050     0 2013-12-31T00:00:00Z
```

Search group with format simple


```r
solr_group(q='*:*', group.field='journal', rows=5, group.limit=3, group.sort='publication_date desc', group.format='simple', fl='journal, publication_date', base=url, key=key)
#>   numFound start                          journal     publication_date
#> 1  1151481     0                         PLoS ONE 2014-11-04T00:00:00Z
#> 2  1151481     0                         PLoS ONE 2014-11-04T00:00:00Z
#> 3  1151481     0                         PLoS ONE 2014-11-04T00:00:00Z
#> 4  1151481     0 PLoS Neglected Tropical Diseases 2014-10-30T00:00:00Z
#> 5  1151481     0 PLoS Neglected Tropical Diseases 2014-10-30T00:00:00Z
```

### Facet


```r
solr_facet(q='*:*', facet.field='journal', facet.query='cell,bird', base=url, key=key)
#> $facet_queries
#>        term value
#> 1 cell,bird    16
#> 
#> $facet_fields
#> $facet_fields$journal
#>                                 X1     X2
#> 1                         plos one 913504
#> 2                    plos genetics  40184
#> 3                   plos pathogens  35156
#> 4       plos computational biology  29404
#> 5                     plos biology  26050
#> 6 plos neglected tropical diseases  24632
#> 7                    plos medicine  18449
#> 8             plos clinical trials    521
#> 9                     plos medicin      9
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
out <- solr_stats(q='ecology', stats.field='counter_total_all,alm_twitterCount', stats.facet='journal,volume', base=url, key=key)
#> Error in solr_GET(base, args, callopts, verbose): client error: (400) Bad Request
```


```r
out$data
#> Error in out$data: $ operator is invalid for atomic vectors
```


```r
out$facet
#> Error in out$facet: $ operator is invalid for atomic vectors
```

### More like this

`solr_mlt` is a function to return similar documents to the one


```r
out <- solr_mlt(q='title:"ecology" AND body:"cell"', mlt.fl='title', mlt.mindf=1, mlt.mintf=1, fl='counter_total_all', rows=5, base=url, key=key)
```


```r
out$docs
#>                             id counter_total_all
#> 1 10.1371/journal.pbio.1001805              9909
#> 2 10.1371/journal.pbio.0020440             16593
#> 3 10.1371/journal.pone.0087217              2787
#> 4 10.1371/journal.pone.0040117              2448
#> 5 10.1371/journal.pone.0072525              1077
```


```r
out$mlt
#> $`10.1371/journal.pbio.1001805`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0082578              1380
#> 2 10.1371/journal.pone.0098876               791
#> 3 10.1371/journal.pone.0102159               409
#> 4 10.1371/journal.pone.0076063              1946
#> 5 10.1371/journal.pcbi.1002652              2371
#> 
#> $`10.1371/journal.pbio.0020440`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0102679              1495
#> 2 10.1371/journal.pone.0035964              3407
#> 3 10.1371/journal.pone.0003259              1800
#> 4 10.1371/journal.pone.0101568              1289
#> 5 10.1371/journal.pone.0068814              5791
#> 
#> $`10.1371/journal.pone.0087217`
#>                             id counter_total_all
#> 1 10.1371/journal.pcbi.0020092             14836
#> 2 10.1371/journal.pone.0063375              1369
#> 3 10.1371/journal.pcbi.1000986              2773
#> 4 10.1371/journal.pone.0015143             12688
#> 5 10.1371/journal.pone.0034096              2370
#> 
#> $`10.1371/journal.pone.0040117`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0069352              1603
#> 2 10.1371/journal.pone.0035502              2588
#> 3 10.1371/journal.pone.0014065              3904
#> 4 10.1371/journal.pone.0078369              2106
#> 5 10.1371/journal.pone.0053825              2530
#> 
#> $`10.1371/journal.pone.0072525`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0060766              1411
#> 2 10.1371/journal.pcbi.1002928              7309
#> 3 10.1371/journal.pcbi.1000350              8726
#> 4 10.1371/journal.pcbi.0020144             12731
#> 5 10.1371/journal.pone.0068714              3702
```

### Parsing

`solr_parse` is a general purpose parser function with extension methods `solr_parse.sr_search`, `solr_parse.sr_facet`, and `solr_parse.sr_high`, for parsing `solr_search`, `solr_facet`, and `solr_highlight` function output, respectively. `solr_parse` is used internally within those three functions (`solr_search`, `solr_facet`, `solr_highlight`) to do parsing. You can optionally get back raw `json` or `xml` from `solr_search`, `solr_facet`, and `solr_highlight` setting parameter `raw=TRUE`, and then parsing after the fact with `solr_parse`. All you need to know is `solr_parse` can parse

For example:


```r
(out <- solr_highlight(q='alcohol', hl.fl = 'abstract', rows=2, base = url, key=key, raw=TRUE))
#> [1] "{\"response\":{\"numFound\":15025,\"start\":0,\"docs\":[{},{}]},\"highlighting\":{\"10.1371/journal.pmed.0040151\":{\"abstract\":[\"Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting\"]},\"10.1371/journal.pone.0027752\":{\"abstract\":[\"Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking\"]}}}\n"
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
#>                             id
#> 1 10.1371/journal.pbio.1001535
#> 2 10.1371/journal.pntd.0001969
#> 3 10.1371/journal.pone.0088278
#> 4 10.1371/journal.pone.0025995
#> 5 10.1371/journal.pone.0070182
#>                                                                                                                    title
#> 1                                                                         An Introduction to Social Media for Scientists
#> 2          An In-Depth Analysis of a Piece of Shit: Distribution of Schistosoma mansoni and Hookworm Eggs in Human Stool
#> 3   Nutrition and Health – The Association between Eating Behavior and Various Health Parameters: A Matched Sample Study
#> 4                                                                                The Network of Global Corporate Control
#> 5 Crop Pollination Exposes Honey Bees to Pesticides Which Alters Their Susceptibility to the Gut Pathogen Nosema ceranae
```

Here, we search for the papers with the most citations


```r
solr_search(q='_val_:"max(counter_total_all)"',
    rows=5, fl='id,counter_total_all', fq='doc_type:full', base=url, key=key)
#>                             id counter_total_all
#> 1 10.1371/journal.pmed.0020124            987842
#> 2 10.1371/journal.pmed.0050045            322996
#> 3 10.1371/journal.pone.0007595            312977
#> 4 10.1371/journal.pone.0033288            305732
#> 5 10.1371/journal.pone.0069841            270707
```

Or with the most tweets


```r
solr_search(q='_val_:"max(alm_twitterCount)"',
    rows=5, fl='id,alm_twitterCount', fq='doc_type:full', base=url, key=key)
#>                             id alm_twitterCount
#> 1 10.1371/journal.pone.0061981             2146
#> 2 10.1371/journal.pbio.1001535             1614
#> 3 10.1371/journal.pone.0102172             1289
#> 4 10.1371/journal.pmed.1001747             1096
#> 5 10.1371/journal.pone.0057760             1049
```

### Using specific data sources

__USGS BISON service__

The occurrences service


```r
url <- "http://bisonapi.usgs.ornl.gov/solr/occurrences/select"
solr_search(q='*:*', base=url2, fl=c('decimalLatitude','decimalLongitude','scientificName'), rows=2)
#>               scientificName
#> 1            Catocala editha
#> 2 Dictyopteris polypodioides
```

The species names service


```r
url2 <- "http://bisonapi.usgs.ornl.gov/solr/scientificName/select"
solr_search(q='*:*', base=url2, raw=TRUE)
#> [1] "{\"responseHeader\":{\"status\":0,\"QTime\":14},\"response\":{\"numFound\":373446,\"start\":0,\"docs\":[{\"scientificName\":\"Catocala editha\",\"_version_\":1477163721582182400},{\"scientificName\":\"Dictyopteris polypodioides\",\"_version_\":1477163721583230976},{\"scientificName\":\"Lonicera iberica\",\"_version_\":1477163721583230977},{\"scientificName\":\"Pseudopomala brachyptera\",\"_version_\":1477163721583230978},{\"scientificName\":\"Lycopodium cernuum ingens\",\"_version_\":1477163721583230979},{\"scientificName\":\"Sanoarca\",\"_version_\":1477163721583230980},{\"scientificName\":\"Celleporina ventricosa\",\"_version_\":1477163721583230981},{\"scientificName\":\"Ceraticelus laticeps\",\"_version_\":1477163721583230982},{\"scientificName\":\"Mactra alata\",\"_version_\":1477163721583230983},{\"scientificName\":\"Reithrodontomys wetmorei\",\"_version_\":1477163721584279552}]}}\n"
#> attr(,"class")
#> [1] "sr_search"
#> attr(,"wt")
#> [1] "json"
```

__PLOS Search API__

Most of the examples above use the PLOS search API... :)

### Meta

* Please report any issues or bugs](https://github.com/ropensci/solr/issues).
* License: MIT
* Get citation information for `solr` in R doing `citation(package = 'solr')`

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
