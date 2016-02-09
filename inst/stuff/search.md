<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Solr search}
%\VignetteEncoding{UTF-8}
-->



Solr search
===========

**A general purpose R interface to [Apache Solr](http://lucene.apache.org/solr/)**

## Solr info

+ [Solr home page](http://lucene.apache.org/solr/)
+ [Highlighting help](http://wiki.apache.org/solr/HighlightingParameters)
+ [Faceting help](http://wiki.apache.org/solr/SimpleFacetParameters)
+ [Install and Setup SOLR in OSX, including running Solr](http://risnandar.wordpress.com/2013/09/08/how-to-install-and-setup-apache-lucene-solr-in-osx/)

## Installation

Stable version from CRAN


```r
install.packages("solrium")
```

Or the development version from GitHub


```r
install.packages("devtools")
devtools::install_github("ropensci/solrium")
```

Load


```r
library("solrium")
```

## Setup connection

You can setup for a remote Solr instance or on your local machine.


```r
solr_connect('http://api.plos.org/search')
#> <solr_connection>
#>   url:    http://api.plos.org/search
#>   errors: simple
#>   verbose: TRUE
#>   proxy:
```

## Rundown

`solr_search()` only returns the `docs` element of a Solr response body. If `docs` is
all you need, then this function will do the job. If you need facet data only, or mlt
data only, see the appropriate functions for each of those below. Another function,
`solr_all()` has a similar interface in terms of parameter as `solr_search()`, but
returns all parts of the response body, including, facets, mlt, groups, stats, etc.
as long as you request those.

## Search docs

`solr_search()` returns only docs. A basic search:


```r
solr_search(q = '*:*', rows = 2, fl = 'id')
#> Source: local data frame [2 x 1]
#> 
#>                                        id
#>                                     (chr)
#> 1 10.1371/journal.pone.0142243/references
#> 2       10.1371/journal.pone.0142243/body
```

__Search in specific fields with `:`__

Search for word ecology in title and cell in the body


```r
solr_search(q = 'title:"ecology" AND body:"cell"', fl = 'title', rows = 5)
#> Source: local data frame [5 x 1]
#> 
#>                                                       title
#>                                                       (chr)
#> 1                        The Ecology of Collective Behavior
#> 2                                   Ecology's Big, Hot Idea
#> 3     Spatial Ecology of Bacteria at the Microscale in Soil
#> 4 Biofilm Formation As a Response to Ecological Competition
#> 5    Ecology of Root Colonizing Massilia (Oxalobacteraceae)
```

__Wildcards__

Search for word that starts with "cell" in the title field


```r
solr_search(q = 'title:"cell*"', fl = 'title', rows = 5)
#> Source: local data frame [5 x 1]
#> 
#>                                                                         title
#>                                                                         (chr)
#> 1                                Tumor Cell Recognition Efficiency by T Cells
#> 2 Cancer Stem Cell-Like Side Population Cells in Clear Cell Renal Cell Carcin
#> 3 Dcas Supports Cell Polarization and Cell-Cell Adhesion Complexes in Develop
#> 4                  Cell-Cell Contact Preserves Cell Viability via Plakoglobin
#> 5 MS4a4B, a CD20 Homologue in T Cells, Inhibits T Cell Propagation by Modulat
```

__Proximity search__

Search for words "sports" and "alcohol" within four words of each other


```r
solr_search(q = 'everything:"stem cell"~7', fl = 'title', rows = 3)
#> Source: local data frame [3 x 1]
#> 
#>                                                                         title
#>                                                                         (chr)
#> 1 Correction: Reduced Intensity Conditioning, Combined Transplantation of Hap
#> 2                                            A Recipe for Self-Renewing Brain
#> 3  Gene Expression Profile Created for Mouse Stem Cells and Developing Embryo
```

__Range searches__

Search for articles with Twitter count between 5 and 10


```r
solr_search(q = '*:*', fl = c('alm_twitterCount', 'id'), fq = 'alm_twitterCount:[5 TO 50]',
rows = 10)
#> Source: local data frame [10 x 2]
#> 
#>                                                     id alm_twitterCount
#>                                                  (chr)            (int)
#> 1            10.1371/journal.ppat.1005403/introduction                6
#> 2  10.1371/journal.ppat.1005403/results_and_discussion                6
#> 3   10.1371/journal.ppat.1005403/materials_and_methods                6
#> 4  10.1371/journal.ppat.1005403/supporting_information                6
#> 5                         10.1371/journal.ppat.1005401                6
#> 6                   10.1371/journal.ppat.1005401/title                6
#> 7                10.1371/journal.ppat.1005401/abstract                6
#> 8              10.1371/journal.ppat.1005401/references                6
#> 9                    10.1371/journal.ppat.1005401/body                6
#> 10           10.1371/journal.ppat.1005401/introduction                6
```

__Boosts__

Assign higher boost to title matches than to body matches (compare the two calls)


```r
solr_search(q = 'title:"cell" abstract:"science"', fl = 'title', rows = 3)
#> Source: local data frame [3 x 1]
#> 
#>                                                                         title
#>                                                                         (chr)
#> 1 I Want More and Better Cells! – An Outreach Project about Stem Cells and It
#> 2                                   Centre of the Cell: Science Comes to Life
#> 3 Globalization of Stem Cell Science: An Examination of Current and Past Coll
```


```r
solr_search(q = 'title:"cell"^1.5 AND abstract:"science"', fl = 'title', rows = 3)
#> Source: local data frame [3 x 1]
#> 
#>                                                                         title
#>                                                                         (chr)
#> 1                                   Centre of the Cell: Science Comes to Life
#> 2 I Want More and Better Cells! – An Outreach Project about Stem Cells and It
#> 3          Derivation of Hair-Inducing Cell from Human Pluripotent Stem Cells
```

## Search all

`solr_all()` differs from `solr_search()` in that it allows specifying facets, mlt, groups,
stats, etc, and returns all of those. It defaults to `parsetype = "list"` and `wt="json"`,
whereas `solr_search()` defaults to `parsetype = "df"` and `wt="csv"`. `solr_all()` returns
by default a list, whereas `solr_search()` by default returns a data.frame.

A basic search, just docs output


```r
solr_all(q = '*:*', rows = 2, fl = 'id')
#> $response
#> $response$numFound
#> [1] 1502814
#> 
#> $response$start
#> [1] 0
#> 
#> $response$docs
#> $response$docs[[1]]
#> $response$docs[[1]]$id
#> [1] "10.1371/journal.pone.0142243/references"
#> 
#> 
#> $response$docs[[2]]
#> $response$docs[[2]]$id
#> [1] "10.1371/journal.pone.0142243/body"
```

Get docs, mlt, and stats output


```r
solr_all(q = 'ecology', rows = 2, fl = 'id', mlt = 'true', mlt.count = 2, mlt.fl = 'abstract', stats = 'true', stats.field = 'counter_total_all')
#> $response
#> $response$numFound
#> [1] 31467
#> 
#> $response$start
#> [1] 0
#> 
#> $response$docs
#> $response$docs[[1]]
#> $response$docs[[1]]$id
#> [1] "10.1371/journal.pone.0059813"
#> 
#> 
#> $response$docs[[2]]
#> $response$docs[[2]]$id
#> [1] "10.1371/journal.pone.0001248"
#> 
#> 
#> 
#> 
#> $moreLikeThis
#> $moreLikeThis$`10.1371/journal.pone.0059813`
#> $moreLikeThis$`10.1371/journal.pone.0059813`$numFound
#> [1] 152704
#> 
#> $moreLikeThis$`10.1371/journal.pone.0059813`$start
#> [1] 0
#> 
#> $moreLikeThis$`10.1371/journal.pone.0059813`$docs
#> $moreLikeThis$`10.1371/journal.pone.0059813`$docs[[1]]
#> $moreLikeThis$`10.1371/journal.pone.0059813`$docs[[1]]$id
#> [1] "10.1371/journal.pone.0111996"
#> 
#> 
#> $moreLikeThis$`10.1371/journal.pone.0059813`$docs[[2]]
#> $moreLikeThis$`10.1371/journal.pone.0059813`$docs[[2]]$id
#> [1] "10.1371/journal.pone.0143687"
#> 
#> 
#> 
#> 
#> $moreLikeThis$`10.1371/journal.pone.0001248`
#> $moreLikeThis$`10.1371/journal.pone.0001248`$numFound
#> [1] 159058
#> 
#> $moreLikeThis$`10.1371/journal.pone.0001248`$start
#> [1] 0
#> 
#> $moreLikeThis$`10.1371/journal.pone.0001248`$docs
#> $moreLikeThis$`10.1371/journal.pone.0001248`$docs[[1]]
#> $moreLikeThis$`10.1371/journal.pone.0001248`$docs[[1]]$id
#> [1] "10.1371/journal.pone.0001275"
#> 
#> 
#> $moreLikeThis$`10.1371/journal.pone.0001248`$docs[[2]]
#> $moreLikeThis$`10.1371/journal.pone.0001248`$docs[[2]]$id
#> [1] "10.1371/journal.pone.0024192"
#> 
#> 
#> 
#> 
#> 
#> $stats
#> $stats$stats_fields
#> $stats$stats_fields$counter_total_all
#> $stats$stats_fields$counter_total_all$min
#> [1] 16
#> 
#> $stats$stats_fields$counter_total_all$max
#> [1] 367697
#> 
#> $stats$stats_fields$counter_total_all$count
#> [1] 31467
#> 
#> $stats$stats_fields$counter_total_all$missing
#> [1] 0
#> 
#> $stats$stats_fields$counter_total_all$sum
#> [1] 141552408
#> 
#> $stats$stats_fields$counter_total_all$sumOfSquares
#> [1] 3.162032e+12
#> 
#> $stats$stats_fields$counter_total_all$mean
#> [1] 4498.44
#> 
#> $stats$stats_fields$counter_total_all$stddev
#> [1] 8958.45
#> 
#> $stats$stats_fields$counter_total_all$facets
#> named list()
```


## Facet


```r
solr_facet(q = '*:*', facet.field = 'journal', facet.query = c('cell', 'bird'))
#> $facet_queries
#>   term  value
#> 1 cell 128657
#> 2 bird  13063
#> 
#> $facet_fields
#> $facet_fields$journal
#>                                 X1      X2
#> 1                         plos one 1233662
#> 2                    plos genetics   49285
#> 3                   plos pathogens   42817
#> 4       plos computational biology   36373
#> 5 plos neglected tropical diseases   33911
#> 6                     plos biology   28745
#> 7                    plos medicine   19934
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

## Highlight


```r
solr_highlight(q = 'alcohol', hl.fl = 'abstract', rows = 2)
#> $`10.1371/journal.pmed.0040151`
#> $`10.1371/journal.pmed.0040151`$abstract
#> [1] "Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting"
#> 
#> 
#> $`10.1371/journal.pone.0027752`
#> $`10.1371/journal.pone.0027752`$abstract
#> [1] "Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking"
```

## Stats


```r
out <- solr_stats(q = 'ecology', stats.field = c('counter_total_all', 'alm_twitterCount'), stats.facet = c('journal', 'volume'))
```


```r
out$data
#>                   min    max count missing       sum sumOfSquares
#> counter_total_all  16 367697 31467       0 141552408 3.162032e+12
#> alm_twitterCount    0   1756 31467       0    168586 3.267801e+07
#>                          mean     stddev
#> counter_total_all 4498.439889 8958.45030
#> alm_twitterCount     5.357549   31.77757
```


```r
out$facet
#> $counter_total_all
#> $counter_total_all$volume
#>     min    max count missing      sum sumOfSquares      mean    stddev
#> 1    20 166202   887       0  2645927  63864880371  2983.007  7948.200
#> 2   495 103147   105       0  1017325  23587444387  9688.810 11490.287
#> 3  1950  69628    69       0   704216  13763808310 10206.029  9834.333
#> 4   742  13856     9       0    48373    375236903  5374.778  3795.438
#> 5  1871 182622    81       0  1509647  87261688837 18637.617 27185.811
#> 6  1667 117922   482       0  5836186 162503606896 12108.270 13817.754
#> 7  1340 128083   741       0  7714963 188647618509 10411.556 12098.852
#> 8   667 362410  1010       0  9692492 340237069126  9596.527 15653.040
#> 9   103 113220  1539       0 12095764 218958657256  7859.496  8975.188
#> 10   72 243873  2948       0 17699332 327210596846  6003.844  8658.717
#> 11   51 184259  4825       0 24198104 382922818910  5015.151  7363.541
#> 12   16 367697  6360       0 26374352 533183277470  4146.911  8163.790
#> 13   42 287741  6620       0 21003701 612616254755  3172.765  9082.194
#> 14  128 161520  5791       0 11012026 206899109466  1901.576  5667.209
#>    volume
#> 1      11
#> 2      12
#> 3      13
#> 4      14
#> 5       1
#> 6       2
#> 7       3
#> 8       4
#> 9       5
#> 10      6
#> 11      7
#> 12      8
#> 13      9
#> 14     10
#> 
#> $counter_total_all$journal
#>    min    max count missing      sum sumOfSquares      mean    stddev
#> 1  667 117922   243       0  4074303 1.460258e+11 16766.679 17920.074
#> 2  742 265561   884       0 14006081 5.507548e+11 15843.983 19298.065
#> 3 8463  13797     2       0    22260 2.619796e+08 11130.000  3771.708
#> 4   16 367697 25915       0 96069530 1.943903e+12  3707.101  7827.546
#> 5  915  61956   595       0  4788553 6.579963e+10  8047.988  6774.558
#> 6  548  76290   758       0  6326284 9.168443e+10  8346.021  7167.106
#> 7  268 212048  1239       0  5876481 1.010080e+11  4742.923  7686.101
#> 8  495 287741   580       0  4211717 1.411022e+11  7261.581 13815.867
#>                            journal
#> 1                    plos medicine
#> 2                     plos biology
#> 3             plos clinical trials
#> 4                         plos one
#> 5                   plos pathogens
#> 6                    plos genetics
#> 7 plos neglected tropical diseases
#> 8       plos computational biology
#> 
#> 
#> $alm_twitterCount
#> $alm_twitterCount$volume
#>    min  max count missing   sum sumOfSquares      mean     stddev volume
#> 1    0 1756   887       0 12295      4040629 13.861330  66.092178     11
#> 2    0 1045   105       0  6466      1885054 61.580952 119.569402     12
#> 3    0  283    69       0  3478       509732 50.405797  70.128101     13
#> 4    6  274     9       0   647       102391 71.888889  83.575482     14
#> 5    0   42    81       0   176         4996  2.172840   7.594060      1
#> 6    0   74   482       0   628        15812  1.302905   5.583197      2
#> 7    0   48   741       0   652        11036  0.879892   3.760087      3
#> 8    0  239  1010       0  1039        74993  1.028713   8.559485      4
#> 9    0  126  1539       0  1901        90297  1.235218   7.562004      5
#> 10   0  886  2948       0  4357      1245453  1.477951  20.504442      6
#> 11   0  822  4825       0 19646      2037596  4.071710  20.144602      7
#> 12   0 1503  6360       0 35938      6505618  5.650629  31.482092      8
#> 13   0 1539  6620       0 49837     12847207  7.528248  43.408246      9
#> 14   0  863  5791       0 31526      3307198  5.443965  23.271216     10
#> 
#> $alm_twitterCount$journal
#>   min  max count missing    sum sumOfSquares      mean   stddev
#> 1   0  777   243       0   4251      1028595 17.493827 62.79406
#> 2   0 1756   884       0  16405      6088729 18.557692 80.93655
#> 3   0    3     2       0      3            9  1.500000  2.12132
#> 4   0 1539 25915       0 123409     23521391  4.762068 29.74883
#> 5   0  122   595       0   4265       160581  7.168067 14.79428
#> 6   0  178   758       0   4277       148277  5.642480 12.80605
#> 7   0  886  1239       0   4972      1048908  4.012914 28.82956
#> 8   0  285   580       0   4166       265578  7.182759 20.17431
#>                            journal
#> 1                    plos medicine
#> 2                     plos biology
#> 3             plos clinical trials
#> 4                         plos one
#> 5                   plos pathogens
#> 6                    plos genetics
#> 7 plos neglected tropical diseases
#> 8       plos computational biology
```

## More like this

`solr_mlt` is a function to return similar documents to the one


```r
out <- solr_mlt(q = 'title:"ecology" AND body:"cell"', mlt.fl = 'title', mlt.mindf = 1, mlt.mintf = 1, fl = 'counter_total_all', rows = 5)
out$docs
#> Source: local data frame [5 x 2]
#> 
#>                             id counter_total_all
#>                          (chr)             (int)
#> 1 10.1371/journal.pbio.1001805             17081
#> 2 10.1371/journal.pbio.0020440             23882
#> 3 10.1371/journal.pone.0087217              5935
#> 4 10.1371/journal.pbio.1002191             13036
#> 5 10.1371/journal.pone.0040117              4316
```


```r
out$mlt
#> $`10.1371/journal.pbio.1001805`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0082578              2196
#> 2 10.1371/journal.pone.0098876              2448
#> 3 10.1371/journal.pone.0102159              1177
#> 4 10.1371/journal.pcbi.1002652              3102
#> 5 10.1371/journal.pcbi.1003408              6942
#> 
#> $`10.1371/journal.pbio.0020440`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0102679              3112
#> 2 10.1371/journal.pone.0035964              5571
#> 3 10.1371/journal.pone.0003259              2800
#> 4 10.1371/journal.pntd.0003377              3392
#> 5 10.1371/journal.pone.0068814              7522
#> 
#> $`10.1371/journal.pone.0087217`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0131665               409
#> 2 10.1371/journal.pcbi.0020092             19604
#> 3 10.1371/journal.pone.0133941               475
#> 4 10.1371/journal.pone.0123774               997
#> 5 10.1371/journal.pone.0140306               322
#> 
#> $`10.1371/journal.pbio.1002191`
#>                             id counter_total_all
#> 1 10.1371/journal.pbio.1002232              1950
#> 2 10.1371/journal.pone.0131700               979
#> 3 10.1371/journal.pone.0070448              1608
#> 4 10.1371/journal.pone.0028737              7481
#> 5 10.1371/journal.pone.0052330              5595
#> 
#> $`10.1371/journal.pone.0040117`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0069352              2763
#> 2 10.1371/journal.pone.0148280               467
#> 3 10.1371/journal.pone.0035502              4031
#> 4 10.1371/journal.pone.0014065              5764
#> 5 10.1371/journal.pone.0113280              1984
```

## Groups

`solr_groups()` is a function to return similar documents to the one


```r
solr_group(q = 'ecology', group.field = 'journal', group.limit = 1, fl = c('id', 'alm_twitterCount'))
#>                         groupValue numFound start
#> 1                         plos one    25915     0
#> 2       plos computational biology      580     0
#> 3                     plos biology      884     0
#> 4                             none     1251     0
#> 5                    plos medicine      243     0
#> 6 plos neglected tropical diseases     1239     0
#> 7                   plos pathogens      595     0
#> 8                    plos genetics      758     0
#> 9             plos clinical trials        2     0
#>                             id alm_twitterCount
#> 1 10.1371/journal.pone.0059813               56
#> 2 10.1371/journal.pcbi.1003594               21
#> 3 10.1371/journal.pbio.1002358               16
#> 4 10.1371/journal.pone.0046671                2
#> 5 10.1371/journal.pmed.1000303                0
#> 6 10.1371/journal.pntd.0002577                2
#> 7 10.1371/journal.ppat.1003372                2
#> 8 10.1371/journal.pgen.1001197                0
#> 9 10.1371/journal.pctr.0020010                0
```

## Parsing

`solr_parse()` is a general purpose parser function with extension methods for parsing outputs from functions in `solr`. `solr_parse()` is used internally within functions to do parsing after retrieving data from the server. You can optionally get back raw `json`, `xml`, or `csv` with the `raw=TRUE`, and then parse afterwards with `solr_parse()`.

For example:


```r
(out <- solr_highlight(q = 'alcohol', hl.fl = 'abstract', rows = 2, raw = TRUE))
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

[Please report any issues or bugs](https://github.com/ropensci/solrium/issues).
