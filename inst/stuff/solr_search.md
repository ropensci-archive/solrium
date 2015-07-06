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

## Define url for Solr instance

This url can be a remote Solr instance or on your local machine.


```r
url <- 'http://api.plos.org/search'
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
solr_search(q = '*:*', rows = 2, fl = 'id', base = url)
#> Source: local data frame [2 x 1]
#> 
#>                                      id
#> 1    10.1371/journal.pone.0123754/title
#> 2 10.1371/journal.pone.0123754/abstract
```

__Search in specific fields with `:`__ 

Search for word ecology in title and cell in the body


```r
solr_search(q = 'title:"ecology" AND body:"cell"', fl = 'title', rows = 5, base = url)
#> Source: local data frame [5 x 1]
#> 
#>                                                    title
#> 1                     The Ecology of Collective Behavior
#> 2                                Ecology's Big, Hot Idea
#> 3  Spatial Ecology of Bacteria at the Microscale in Soil
#> 4 Ecology of Root Colonizing Massilia (Oxalobacteraceae)
#> 5  Allometry and Dissipation of Ecological Flow Networks
```

__Wildcards__ 

Search for word that starts with "cell" in the title field


```r
solr_search(q = 'title:"cell*"', fl = 'title', rows = 5, base = url)
#> Source: local data frame [5 x 1]
#> 
#>                                                                         title
#> 1                                Tumor Cell Recognition Efficiency by T Cells
#> 2 Cancer Stem Cell-Like Side Population Cells in Clear Cell Renal Cell Carcin
#> 3                  Cell-Cell Contact Preserves Cell Viability via Plakoglobin
#> 4 Dcas Supports Cell Polarization and Cell-Cell Adhesion Complexes in Develop
#> 5 Cell-Cell Adhesions and Cell Contractility Are Upregulated upon Desmosome D
```

__Proximity search__

Search for words "sports" and "alcohol" within four words of each other


```r
solr_search(q = 'everything:"stem cell"~7', fl = 'title', rows = 3, base = url)
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
rows = 10, base = url)
#> Source: local data frame [10 x 2]
#> 
#>                                                     id alm_twitterCount
#> 1                   10.1371/journal.pone.0092203/title               10
#> 2                10.1371/journal.pone.0092203/abstract               10
#> 3              10.1371/journal.pone.0092203/references               10
#> 4                    10.1371/journal.pone.0092203/body               10
#> 5            10.1371/journal.pone.0092203/introduction               10
#> 6  10.1371/journal.pone.0092203/results_and_discussion               10
#> 7   10.1371/journal.pone.0092203/materials_and_methods               10
#> 8  10.1371/journal.pone.0092203/supporting_information               10
#> 9                         10.1371/journal.pone.0092196                6
#> 10                  10.1371/journal.pone.0092196/title                6
```

__Boosts__

Assign higher boost to title matches than to body matches (compare the two calls)


```r
solr_search(q = 'title:"cell" abstract:"science"', fl = 'title', rows = 3, base = url)
#> Source: local data frame [3 x 1]
#> 
#>                                                                         title
#> 1 Globalization of Stem Cell Science: An Examination of Current and Past Coll
#> 2          Derivation of Hair-Inducing Cell from Human Pluripotent Stem Cells
#> 3 Crucial Ignored Parameters on Nanotoxicology: The Importance of Toxicity As
```


```r
solr_search(q = 'title:"cell"^1.5 AND abstract:"science"', fl = 'title', rows = 3, base = url)
#> Source: local data frame [3 x 1]
#> 
#>                                                                         title
#> 1          Derivation of Hair-Inducing Cell from Human Pluripotent Stem Cells
#> 2 Globalization of Stem Cell Science: An Examination of Current and Past Coll
#> 3 Crucial Ignored Parameters on Nanotoxicology: The Importance of Toxicity As
```

## Search all

`solr_all()` differs from `solr_search()` in that it allows specifying facets, mlt, groups, 
stats, etc, and returns all of those. It defaults to `parsetype = "list"` and `wt="json"`, 
whereas `solr_search()` defaults to `parsetype = "df"` and `wt="csv"`. `solr_all()` returns 
by default a list, whereas `solr_search()` by default returns a data.frame.

A basic search, just docs output


```r
solr_all(q = '*:*', rows = 2, fl = 'id', base = url)
#> $response
#> $response$numFound
#> [1] 1344046
#> 
#> $response$start
#> [1] 0
#> 
#> $response$docs
#> $response$docs[[1]]
#> $response$docs[[1]]$id
#> [1] "10.1371/journal.pone.0123754/title"
#> 
#> 
#> $response$docs[[2]]
#> $response$docs[[2]]$id
#> [1] "10.1371/journal.pone.0123754/abstract"
```

Get docs, mlt, and stats output


```r
solr_all(q = 'ecology', rows = 2, fl = 'id', base = url, mlt = 'true', mlt.count = 2, mlt.fl = 'abstract', stats = 'true', stats.field = 'counter_total_all')
#> $response
#> $response$numFound
#> [1] 27897
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
#> [1] 136233
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
#> [1] 142155
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
#> [1] 328552
#> 
#> $stats$stats_fields$counter_total_all$count
#> [1] 27897
#> 
#> $stats$stats_fields$counter_total_all$missing
#> [1] 0
#> 
#> $stats$stats_fields$counter_total_all$sum
#> [1] 101291508
#> 
#> $stats$stats_fields$counter_total_all$sumOfSquares
#> [1] 1.985326e+12
#> 
#> $stats$stats_fields$counter_total_all$mean
#> [1] 3630.91
#> 
#> $stats$stats_fields$counter_total_all$stddev
#> [1] 7614.778
#> 
#> $stats$stats_fields$counter_total_all$facets
#> named list()
```


## Facet


```r
solr_facet(q = '*:*', facet.field = 'journal', facet.query = c('cell', 'bird'), base = url)
#> $facet_queries
#>   term  value
#> 1 cell 116325
#> 2 bird  11684
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

## Highlight


```r
solr_highlight(q = 'alcohol', hl.fl = 'abstract', rows = 2, base = url)
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
out <- solr_stats(q = 'ecology', stats.field = c('counter_total_all', 'alm_twitterCount'), stats.facet = c('journal', 'volume'), base = url)
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


```r
out$facet
#> $counter_total_all
#> $counter_total_all$journal
#>    min    max count missing      sum sumOfSquares      mean    stddev
#> 1    0  47836   539       0  3479799 3.868944e+10  6456.028  5491.420
#> 2    0  56218   695       0  4862266 5.834175e+10  6996.066  5920.342
#> 3    0 328552 22743       0 66413378 1.202736e+12  2920.168  6660.208
#> 4 6076  10524     2       0    16600 1.476724e+08  8300.000  3145.211
#> 5    0 101262   234       0  3119262 8.752157e+10 13330.179 14041.822
#> 6    0 233291   846       0 11346628 3.722628e+11 13412.090 16138.484
#> 7    0 173635   506       0  3156624 6.741663e+10  6238.387  9721.304
#> 8    0 188311  1081       0  4079141 6.276351e+10  3773.488  6622.836
#>                        facet_field
#> 1                   plos pathogens
#> 2                    plos genetics
#> 3                         plos one
#> 4             plos clinical trials
#> 5                    plos medicine
#> 6                     plos biology
#> 7       plos computational biology
#> 8 plos neglected tropical diseases
#> 
#> $counter_total_all$volume
#>     min    max count missing      sum sumOfSquares      mean    stddev
#> 1  1028 120882   741       0  6101366 130028307888  8233.962 10383.842
#> 2  1322 101262   482       0  4659774 107774833770  9667.581 11419.618
#> 3  1492 136385    81       0  1219797  50307792101 15059.222 19980.803
#> 4     0  94928  3074       0  3886725  62416346799  1264.387  4325.739
#> 5     0 182594  4825       0 18560589 277907058719  3846.754  6542.834
#> 6     0 210081  2948       0 13619499 219744348231  4619.911  7294.835
#> 7     0  80934  1539       0  9402958 136990113038  6109.784  7191.423
#> 8   576 328552  1010       0  7684757 253392332449  7608.670 13899.025
#> 9     0 233291  6503       0 14187961 331347716675  2181.756  6797.065
#> 10    0 316100  6360       0 19673267 355104993009  3093.281  6802.427
#> 11    0  38922    37       0   201847   2743736297  5455.324  6754.824
#> 12    0 145211   228       0  1367104  44491682708  5996.070 12644.657
#> 13    0  72552    69       0   725864  13076308242 10519.768  8944.590
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
#>   min  max count missing   sum sumOfSquares      mean   stddev
#> 1   0   93   539       0  2745        86667  5.092764 11.62354
#> 2   0  164   695       0  3282       109260  4.722302 11.62338
#> 3   0 1357 22743       0 90251     15156189  3.968298 25.50867
#> 4   0    3     2       0     3            9  1.500000  2.12132
#> 5   0  634   234       0  3601       774855 15.388889 55.56729
#> 6   0 1670   846       0 11957      4858993 14.133570 74.50029
#> 7   0  142   506       0  2444       110174  4.830040 13.95675
#> 8   0  859  1081       0  3700       910614  3.422757 28.83461
#>                        facet_field
#> 1                   plos pathogens
#> 2                    plos genetics
#> 3                         plos one
#> 4             plos clinical trials
#> 5                    plos medicine
#> 6                     plos biology
#> 7       plos computational biology
#> 8 plos neglected tropical diseases
#> 
#> $alm_twitterCount$volume
#>    min  max count missing   sum sumOfSquares       mean     stddev
#> 1    0   46   741       0   532         7312  0.7179487   3.060218
#> 2    0   70   482       0   474        11470  0.9834025   4.782997
#> 3    0   41    81       0   154         3760  1.9012346   6.583322
#> 4    0  634  3074       0  8018       842210  2.6083279  16.348153
#> 5    0  811  4825       0 18759      1917695  3.8878756  19.555394
#> 6    0  859  2948       0  3828      1049464  1.2985075  18.826204
#> 7    0  112  1539       0  1577        67239  1.0246914   6.532059
#> 8    0  197  1010       0   820        51584  0.8118812   7.103807
#> 9    0 1357  6503       0 44780      8517770  6.8860526  35.533056
#> 10   0 1203  6360       0 33913      4999581  5.3322327  27.527878
#> 11   0   87    37       0   251        15005  6.7837838  19.222578
#> 12   0 1670   228       0  6036      3382290 26.4736842 119.147021
#> 13   0  928    69       0  5540      1544376 80.2898551 127.161905
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
out <- solr_mlt(q = 'title:"ecology" AND body:"cell"', mlt.fl = 'title', mlt.mindf = 1, mlt.mintf = 1, fl = 'counter_total_all', rows = 5, base = url)
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

## Groups

`solr_groups()` is a function to return similar documents to the one


```r
solr_group(q = 'ecology', group.field = 'journal', group.limit = 1, fl = c('id', 'alm_twitterCount'), base = url)
#>                         groupValue numFound start
#> 1                         plos one    22743     0
#> 2       plos computational biology      506     0
#> 3                     plos biology      846     0
#> 4                             none     1251     0
#> 5                    plos medicine      234     0
#> 6 plos neglected tropical diseases     1081     0
#> 7                   plos pathogens      539     0
#> 8                    plos genetics      695     0
#> 9             plos clinical trials        2     0
#>                             id alm_twitterCount
#> 1 10.1371/journal.pone.0059813               56
#> 2 10.1371/journal.pcbi.1003594               20
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
(out <- solr_highlight(q = 'alcohol', hl.fl = 'abstract', rows = 2, base = url, raw = TRUE))
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

[Please report any issues or bugs](https://github.com/ropensci/solr/issues).
