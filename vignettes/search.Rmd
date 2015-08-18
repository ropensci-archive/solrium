<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Solr search}
%\VignetteEncoding{UTF-8}
-->



Solr search
===========

**A general purpose R interface to [Apache Solr](http://lucene.apache.org/solr/)**

This package only deals with extracting data from a Solr endpoint, not writing data (pull request or holla if you're interested in writing solr data).

## Solr info

+ [Solr home page](http://lucene.apache.org/solr/)
+ [Highlighting help](http://wiki.apache.org/solr/HighlightingParameters)
+ [Faceting help](http://wiki.apache.org/solr/SimpleFacetParameters)
+ [Installing Solr on Mac using homebrew](http://ramlev.dk/blog/2012/06/02/install-apache-solr-on-your-mac/)
+ [Install and Setup SOLR in OSX, including running Solr](http://risnandar.wordpress.com/2013/09/08/how-to-install-and-setup-apache-lucene-solr-in-osx/)

## Installation

Stable version from CRAN


```r
install.packages("solr")
```

Or the development version from GitHub


```r
install.packages("devtools")
devtools::install_github("ropensci/solr")
```

Load


```r
library("solr")
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
#>                                                              id
#> 1       10.1371/annotation/ec04ad74-63cc-4fbe-9ad8-074a1d62fdf4
#> 2 10.1371/annotation/ec04ad74-63cc-4fbe-9ad8-074a1d62fdf4/title
```

__Search in specific fields with `:`__

Search for word ecology in title and cell in the body


```r
solr_search(q = 'title:"ecology" AND body:"cell"', fl = 'title', rows = 5)
#> Source: local data frame [5 x 1]
#> 
#>                                                       title
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
#> 1                                Tumor Cell Recognition Efficiency by T Cells
#> 2 Cancer Stem Cell-Like Side Population Cells in Clear Cell Renal Cell Carcin
#> 3 Cell-Cell Adhesions and Cell Contractility Are Upregulated upon Desmosome D
#> 4 MS4a4B, a CD20 Homologue in T Cells, Inhibits T Cell Propagation by Modulat
#> 5                  Cell-Cell Contact Preserves Cell Viability via Plakoglobin
```

__Proximity search__

Search for words "sports" and "alcohol" within four words of each other


```r
solr_search(q = 'everything:"stem cell"~7', fl = 'title', rows = 3)
#> Source: local data frame [3 x 1]
#> 
#>                                                                         title
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
#> 1                         10.1371/journal.pgen.1004643                6
#> 2                   10.1371/journal.pgen.1004643/title                6
#> 3                10.1371/journal.pgen.1004643/abstract                6
#> 4              10.1371/journal.pgen.1004643/references                6
#> 5                    10.1371/journal.pgen.1004643/body                6
#> 6            10.1371/journal.pgen.1004643/introduction                6
#> 7  10.1371/journal.pgen.1004643/results_and_discussion                6
#> 8   10.1371/journal.pgen.1004643/materials_and_methods                6
#> 9  10.1371/journal.pgen.1004643/supporting_information                6
#> 10                        10.1371/journal.pone.0041560                9
```

__Boosts__

Assign higher boost to title matches than to body matches (compare the two calls)


```r
solr_search(q = 'title:"cell" abstract:"science"', fl = 'title', rows = 3)
#> Source: local data frame [3 x 1]
#> 
#>                                                                         title
#> 1 I Want More and Better Cells! – An Outreach Project about Stem Cells and It
#> 2 Globalization of Stem Cell Science: An Examination of Current and Past Coll
#> 3          Derivation of Hair-Inducing Cell from Human Pluripotent Stem Cells
```


```r
solr_search(q = 'title:"cell"^1.5 AND abstract:"science"', fl = 'title', rows = 3)
#> Source: local data frame [3 x 1]
#> 
#>                                                                         title
#> 1 I Want More and Better Cells! – An Outreach Project about Stem Cells and It
#> 2          Derivation of Hair-Inducing Cell from Human Pluripotent Stem Cells
#> 3 Globalization of Stem Cell Science: An Examination of Current and Past Coll
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
#> [1] 1381683
#> 
#> $response$start
#> [1] 0
#> 
#> $response$docs
#> $response$docs[[1]]
#> $response$docs[[1]]$id
#> [1] "10.1371/annotation/ec04ad74-63cc-4fbe-9ad8-074a1d62fdf4"
#> 
#> 
#> $response$docs[[2]]
#> $response$docs[[2]]$id
#> [1] "10.1371/annotation/ec04ad74-63cc-4fbe-9ad8-074a1d62fdf4/title"
```

Get docs, mlt, and stats output


```r
solr_all(q = 'ecology', rows = 2, fl = 'id', mlt = 'true', mlt.count = 2, mlt.fl = 'abstract', stats = 'true', stats.field = 'counter_total_all')
#> $response
#> $response$numFound
#> [1] 28722
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
#> [1] 139965
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
#> [1] "10.1371/journal.pone.0009829"
#> 
#> 
#> 
#> 
#> $moreLikeThis$`10.1371/journal.pone.0001248`
#> $moreLikeThis$`10.1371/journal.pone.0001248`$numFound
#> [1] 145996
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
#> [1] 0
#> 
#> $stats$stats_fields$counter_total_all$max
#> [1] 336749
#> 
#> $stats$stats_fields$counter_total_all$count
#> [1] 28722
#> 
#> $stats$stats_fields$counter_total_all$missing
#> [1] 0
#> 
#> $stats$stats_fields$counter_total_all$sum
#> [1] 108516018
#> 
#> $stats$stats_fields$counter_total_all$sumOfSquares
#> [1] 2.202717e+12
#> 
#> $stats$stats_fields$counter_total_all$mean
#> [1] 3778.15
#> 
#> $stats$stats_fields$counter_total_all$stddev
#> [1] 7900.55
#> 
#> $stats$stats_fields$counter_total_all$facets
#> named list()
```


## Facet


```r
solr_facet(q = '*:*', facet.field = 'journal', facet.query = c('cell', 'bird'))
#> $facet_queries
#>   term  value
#> 1 cell 119155
#> 2 bird  11996
#> 
#> $facet_fields
#> $facet_fields$journal
#>                                  X1      X2
#> 1                          plos one 1120581
#> 2                     plos genetics   45898
#> 3                    plos pathogens   40159
#> 4        plos computational biology   33336
#> 5  plos neglected tropical diseases   30425
#> 6                      plos biology   27756
#> 7                     plos medicine   19285
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
#> counter_total_all   0 336749 28722       0 108516018 2.202717e+12
#> alm_twitterCount    0   1689 28722       0    141707 2.531147e+07
#>                          mean     stddev
#> counter_total_all 3778.149781 7900.55016
#> alm_twitterCount     4.933744   29.27363
```


```r
out$facet
#> $counter_total_all
#> $counter_total_all$journal
#>    min    max count missing      sum sumOfSquares      mean    stddev
#> 1    0  48724   557       0  3694151 4.163557e+10  6632.228  5551.446
#> 2  835  64516   701       0  5110914 6.344270e+10  7290.890  6115.506
#> 3    0 336749 23493       0 71935982 1.362959e+12  3062.018  6974.358
#> 4  593 104057   237       0  3245143 9.416814e+10 13692.586 14516.756
#> 5 6244  10764     2       0    17008 1.548512e+08  8504.000  3196.123
#> 6    0 243465   855       0 11799927 3.984940e+11 13801.084 16611.069
#> 7    0 184881   518       0  3355629 7.516263e+10  6478.048 10165.431
#> 8    0 193802  1108       0  4336845 6.701078e+10  3914.120  6723.058
#>                        facet_field
#> 1                   plos pathogens
#> 2                    plos genetics
#> 3                         plos one
#> 4                    plos medicine
#> 5             plos clinical trials
#> 6                     plos biology
#> 7       plos computational biology
#> 8 plos neglected tropical diseases
#> 
#> $counter_total_all$volume
#>     min    max count missing      sum sumOfSquares      mean    stddev
#> 1  1052 122474   741       0  6232619 135428037571  8411.092 10590.977
#> 2  1340 104057   482       0  4744659 111995682443  9843.691 11650.732
#> 3  1511 139476    81       0  1241345  52285112913 15325.247 20390.315
#> 4     0 142350  3824       0  6075450 117495118914  1588.768  5311.205
#> 5     0 183039  4825       0 19352649 293919063521  4010.912  6696.099
#> 6     0 222276  2948       0 14081625 236132508133  4776.671  7569.814
#> 7     0  81546  1539       0  9673414 145329990734  6285.519  7413.461
#> 8   593 336749  1010       0  7864089 265446661241  7786.227 14226.508
#> 9     0 243465  6530       0 15641609 379973976465  2395.346  7242.881
#> 10    0 328862  6360       0 20757905 392032169337  3263.822  7141.132
#> 11    0  57565    46       0   385780   6714995246  8386.522  8793.486
#> 12    0 150737   264       0  1656481  49823712085  6274.549 12244.350
#> 13 1863  83702    72       0   808393  16140017213 11227.681  9974.361
#>    facet_field
#> 1            3
#> 2            2
#> 3            1
#> 4           10
#> 5            7
#> 6            6
#> 7            5
#> 8            4
#> 9            9
#> 10           8
#> 11          13
#> 12          11
#> 13          12
#> 
#> 
#> $alm_twitterCount
#> $alm_twitterCount$journal
#>   min  max count missing    sum sumOfSquares      mean   stddev
#> 1   0   93   557       0   3355       107953  6.023339 12.56241
#> 2   0  171   701       0   3687       131091  5.259629 12.63209
#> 3   0 1401 23493       0 103230     17484240  4.394075 26.92499
#> 4   0  643   237       0   3803       801745 16.046414 56.02362
#> 5   0    3     2       0      3            9  1.500000  2.12132
#> 6   0 1689   855       0  13529      5210605 15.823392 76.49012
#> 7   0  270   518       0   3079       198395  5.944015 18.66395
#> 8   0  865  1108       0   4252       965942  3.837545 29.28884
#>                        facet_field
#> 1                   plos pathogens
#> 2                    plos genetics
#> 3                         plos one
#> 4                    plos medicine
#> 5             plos clinical trials
#> 6                     plos biology
#> 7       plos computational biology
#> 8 plos neglected tropical diseases
#> 
#> $alm_twitterCount$volume
#>    min  max count missing   sum sumOfSquares       mean     stddev
#> 1    0   47   741       0   592         8924  0.7989204   3.379397
#> 2    0   73   482       0   513        13297  1.0643154   5.148725
#> 3    0   42    81       0   170         4756  2.0987654   7.415533
#> 4    0  731  3824       0 18669      2032147  4.8820607  22.532586
#> 5    0  816  4825       0 19238      1993952  3.9871503  19.935880
#> 6    0  865  2948       0  4036      1129470  1.3690638  19.529106
#> 7    0  112  1539       0  1684        72258  1.0942170   6.766366
#> 8    0  229  1010       0   894        67368  0.8851485   8.122982
#> 9    0 1401  6530       0 46504      9196424  7.1215926  36.848681
#> 10   0 1300  6360       0 34551      5381515  5.4325472  28.579118
#> 11   0  216    46       0  1574       189286 34.2173913  54.858976
#> 12   0 1689   264       0  7504      3584852 28.4242424 113.223701
#> 13   0  964    72       0  5778      1637224 80.2500000 128.564090
#>    facet_field
#> 1            3
#> 2            2
#> 3            1
#> 4           10
#> 5            7
#> 6            6
#> 7            5
#> 8            4
#> 9            9
#> 10           8
#> 11          13
#> 12          11
#> 13          12
```

## More like this

`solr_mlt` is a function to return similar documents to the one


```r
out <- solr_mlt(q = 'title:"ecology" AND body:"cell"', mlt.fl = 'title', mlt.mindf = 1, mlt.mintf = 1, fl = 'counter_total_all', rows = 5)
out$docs
#> Source: local data frame [5 x 2]
#> 
#>                             id counter_total_all
#> 1 10.1371/journal.pbio.1001805             13440
#> 2 10.1371/journal.pbio.0020440             16970
#> 3 10.1371/journal.pone.0087217              4723
#> 4 10.1371/journal.pbio.1002191              7190
#> 5 10.1371/journal.pone.0040117              3189
```


```r
out$mlt
#> $`10.1371/journal.pbio.1001805`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0082578              1781
#> 2 10.1371/journal.pone.0098876              1040
#> 3 10.1371/journal.pone.0102159               764
#> 4 10.1371/journal.pone.0087380              1364
#> 5 10.1371/journal.pcbi.1003408              5602
#> 
#> $`10.1371/journal.pbio.0020440`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0035964              3975
#> 2 10.1371/journal.pone.0102679              2394
#> 3 10.1371/journal.pone.0003259              1915
#> 4 10.1371/journal.pone.0101568              1978
#> 5 10.1371/journal.pone.0068814              6698
#> 
#> $`10.1371/journal.pone.0087217`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0131665               147
#> 2 10.1371/journal.pcbi.0020092             16219
#> 3 10.1371/journal.pone.0133941               137
#> 4 10.1371/journal.pone.0123774               709
#> 5 10.1371/journal.pone.0063375              1604
#> 
#> $`10.1371/journal.pbio.1002191`
#>                             id counter_total_all
#> 1 10.1371/journal.pbio.1002232                 0
#> 2 10.1371/journal.pone.0131700               352
#> 3 10.1371/journal.pone.0070448              1033
#> 4 10.1371/journal.pone.0052330              3905
#> 5 10.1371/journal.pone.0044766              1626
#> 
#> $`10.1371/journal.pone.0040117`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0069352              2040
#> 2 10.1371/journal.pone.0035502              3014
#> 3 10.1371/journal.pone.0014065              4446
#> 4 10.1371/journal.pone.0113280              1421
#> 5 10.1371/journal.pone.0078369              2658
```

## Groups

`solr_groups()` is a function to return similar documents to the one


```r
solr_group(q = 'ecology', group.field = 'journal', group.limit = 1, fl = c('id', 'alm_twitterCount'))
#>                         groupValue numFound start
#> 1                         plos one    23493     0
#> 2       plos computational biology      518     0
#> 3                     plos biology      855     0
#> 4                             none     1251     0
#> 5                    plos medicine      237     0
#> 6 plos neglected tropical diseases     1108     0
#> 7                   plos pathogens      557     0
#> 8                    plos genetics      701     0
#> 9             plos clinical trials        2     0
#>                             id alm_twitterCount
#> 1 10.1371/journal.pone.0059813               56
#> 2 10.1371/journal.pcbi.1003594               21
#> 3 10.1371/journal.pbio.0020072                4
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
#> [1] "{\"response\":{\"numFound\":18380,\"start\":0,\"docs\":[{},{}]},\"highlighting\":{\"10.1371/journal.pmed.0040151\":{\"abstract\":[\"Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting\"]},\"10.1371/journal.pone.0027752\":{\"abstract\":[\"Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking\"]}}}\n"
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

[Please report any issues or bugs](https://github.com/ropensci/solr/issues).
