<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{solr vignette}
-->



solr vignette
======

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
#>                                                              id
#> 1       10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4
#> 2 10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4/title
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
#> 3 Cell-Cell Adhesions and Cell Contractility Are Upregulated upon Desmosome D
#> 4 Dcas Supports Cell Polarization and Cell-Cell Adhesion Complexes in Develop
#> 5                  Cell-Cell Contact Preserves Cell Viability via Plakoglobin
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
#>                                                                    id
#> 1             10.1371/annotation/360ddc68-0313-4eae-af24-043cc040c52d
#> 2       10.1371/annotation/360ddc68-0313-4eae-af24-043cc040c52d/title
#> 3    10.1371/annotation/360ddc68-0313-4eae-af24-043cc040c52d/abstract
#> 4  10.1371/annotation/360ddc68-0313-4eae-af24-043cc040c52d/references
#> 5        10.1371/annotation/360ddc68-0313-4eae-af24-043cc040c52d/body
#> 6             10.1371/annotation/f6708258-1101-40f2-9a91-be36b1b1afd8
#> 7       10.1371/annotation/f6708258-1101-40f2-9a91-be36b1b1afd8/title
#> 8    10.1371/annotation/f6708258-1101-40f2-9a91-be36b1b1afd8/abstract
#> 9  10.1371/annotation/f6708258-1101-40f2-9a91-be36b1b1afd8/references
#> 10       10.1371/annotation/f6708258-1101-40f2-9a91-be36b1b1afd8/body
#> Variables not shown: alm_twitterCount (int)
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
#> [1] 1239067
#> 
#> $response$start
#> [1] 0
#> 
#> $response$docs
#> $response$docs[[1]]
#> $response$docs[[1]]$id
#> [1] "10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4"
#> 
#> 
#> $response$docs[[2]]
#> $response$docs[[2]]$id
#> [1] "10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4/title"
```

Get docs, mlt, and stats output


```r
solr_all(q = 'ecology', rows = 2, fl = 'id', base = url, mlt = 'true', mlt.count = 2, mlt.fl = 'abstract', stats = 'true', stats.field = 'counter_total_all')
#> $response
#> $response$numFound
#> [1] 25763
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
#> [1] 125751
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
#> [1] 131411
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
#> [1] 322423
#> 
#> $stats$stats_fields$counter_total_all$count
#> [1] 25763
#> 
#> $stats$stats_fields$counter_total_all$missing
#> [1] 0
#> 
#> $stats$stats_fields$counter_total_all$sum
#> [1] 97573824
#> 
#> $stats$stats_fields$counter_total_all$sumOfSquares
#> [1] 1.891047e+12
#> 
#> $stats$stats_fields$counter_total_all$mean
#> [1] 3787.363
#> 
#> $stats$stats_fields$counter_total_all$stddev
#> [1] 7685.039
#> 
#> $stats$stats_fields$counter_total_all$facets
#> named list()
```


## Facet


```r
solr_facet(q = '*:*', facet.field = 'journal', facet.query = c('cell', 'bird'), base = url)
#> $facet_queries
#>   term  value
#> 1 cell 108304
#> 2 bird  10860
#> 
#> $facet_fields
#> $facet_fields$journal
#>                                  X1     X2
#> 1                          plos one 990249
#> 2                     plos genetics  42871
#> 3                    plos pathogens  37331
#> 4        plos computational biology  31253
#> 5  plos neglected tropical diseases  27465
#> 6                      plos biology  26856
#> 7                     plos medicine  18851
#> 8              plos clinical trials    521
#> 9                      plos medicin      9
#> 10                 plos collections      5
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
#>                   min    max count missing      sum sumOfSquares
#> counter_total_all   0 322423 25763       0 97573824 1.891047e+12
#> alm_twitterCount    0   1670 25763       0   124535 2.240619e+07
#>                         mean     stddev
#> counter_total_all 3787.36265 7685.03876
#> alm_twitterCount     4.83387   29.09245
```


```r
out$facet
#> $counter_total_all
#> $counter_total_all$journal
#>    min    max count missing      sum sumOfSquares      mean    stddev
#> 1  144  47154   512       0  3375560 3.692662e+10  6592.891  5358.374
#> 2    0  53169   665       0  4721931 5.562759e+10  7100.648  5768.999
#> 3    0 322423 20798       0 63439022 1.136958e+12  3050.246  6735.346
#> 4 5988  10404     2       0    16392 1.440994e+08  8196.000  3122.584
#> 5    0  99346   231       0  3110571 8.596946e+10 13465.675 13844.402
#> 6    0 224075   828       0 11245427 3.594880e+11 13581.434 15811.734
#> 7    0 165149   473       0  3030774 6.264164e+10  6407.556  9569.304
#> 8    0 185202  1003       0  3938229 6.018297e+10  3926.450  6680.603
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
#> 1  1016 120092   741       0  6020159 126747139811  8124.371 10255.989
#> 2  1309  99346   482       0  4600516 104686557740  9544.639 11240.731
#> 3     0  93905  1129       0  2931028  49437450032  2596.128  6089.472
#> 4  1482 133505    81       0  1205797  48789873015 14886.383 19634.128
#> 5     0 182355  4825       0 18081608 269013983816  3747.484  6459.041
#> 6     0 205642  2948       0 13332186 210971821328  4522.451  7150.466
#> 7     0  80456  1539       0  9221241 131199422637  5991.710  7027.182
#> 8   566 322423  1010       0  7562867 244380204681  7487.987 13640.927
#> 9     0 224075  6425       0 13338857 307984439847  2076.087  6605.451
#> 10    0 304156  6360       0 19011532 335747637442  2989.235  6622.830
#> 11    0  27638    19       0   256356   4896107256 13492.421  8935.709
#> 12    0 141618   138       0  1264209  43533636283  9160.935 15271.819
#> 13    0  67886    66       0   747468  13658285696 11325.273  8938.256
#>    facet_field
#> 1            3
#> 2            2
#> 3           10
#> 4            1
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
#> 1   0   93   512       0  2744        86638  5.359375 11.86452
#> 2   0  164   665       0  3280       109258  4.932331 11.83979
#> 3   0 1357 20798       0 90055     15147993  4.329984 26.63877
#> 4   0    3     2       0     3            9  1.500000  2.12132
#> 5   0  634   231       0  3601       774855 15.588745 55.90053
#> 6   0 1670   828       0 11953      4858987 14.435990 75.27807
#> 7   0  142   473       0  2500       114844  5.285412 14.67374
#> 8   0  859  1003       0  3700       910614  3.688933 29.91947
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
#> 3    0  634  1129       0  7902       845242  6.9991143  26.463125
#> 4    0   41    81       0   154         3760  1.9012346   6.583322
#> 5    0  811  4825       0 18760      1917696  3.8880829  19.555358
#> 6    0  859  2948       0  3828      1049464  1.2985075  18.826204
#> 7    0  112  1539       0  1577        67239  1.0246914   6.532059
#> 8    0  197  1010       0   820        51584  0.8118812   7.103807
#> 9    0 1357  6425       0 44769      8516081  6.9679377  35.736630
#> 10   0 1201  6360       0 33911      4994773  5.3319182  27.514203
#> 11   0   87    19       0   247        14999 13.0000000  25.590797
#> 12   0 1670   138       0  6021      3382197 43.6304348 150.897513
#> 13   0  928    66       0  5540      1544376 83.9393939 128.861987
#>    facet_field
#> 1            3
#> 2            2
#> 3           10
#> 4            1
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
#> 1 10.1371/journal.pbio.1001805             11299
#> 2 10.1371/journal.pbio.0020440             16799
#> 3 10.1371/journal.pone.0087217              3475
#> 4 10.1371/journal.pone.0040117              2787
#> 5 10.1371/journal.pone.0072525              1207
```


```r
out$mlt
#> $`10.1371/journal.pbio.1001805`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0082578              1606
#> 2 10.1371/journal.pone.0098876               947
#> 3 10.1371/journal.pone.0102159               578
#> 4 10.1371/journal.pcbi.1002915              6306
#> 5 10.1371/journal.pcbi.1002652              2566
#> 
#> $`10.1371/journal.pbio.0020440`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0035964              3746
#> 2 10.1371/journal.pone.0102679              2031
#> 3 10.1371/journal.pone.0003259              1872
#> 4 10.1371/journal.pntd.0003377              2676
#> 5 10.1371/journal.pone.0101568              1658
#> 
#> $`10.1371/journal.pone.0087217`
#>                             id counter_total_all
#> 1 10.1371/journal.pcbi.0020092             15637
#> 2 10.1371/journal.pone.0063375              1493
#> 3 10.1371/journal.pone.0015143             13504
#> 4 10.1371/journal.pone.0034096              2575
#> 5 10.1371/journal.pcbi.1000986              2881
#> 
#> $`10.1371/journal.pone.0040117`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0069352              1777
#> 2 10.1371/journal.pone.0035502              2762
#> 3 10.1371/journal.pone.0014065              4163
#> 4 10.1371/journal.pone.0078369              2385
#> 5 10.1371/journal.pone.0113280              1050
#> 
#> $`10.1371/journal.pone.0072525`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0060766              1645
#> 2 10.1371/journal.pcbi.1002928              7766
#> 3 10.1371/journal.pone.0072862              3338
#> 4 10.1371/journal.pone.0068714              4506
#> 5 10.1371/journal.pcbi.0020144             13133
```

## Groups

`solr_groups()` is a function to return similar documents to the one


```r
solr_group(q = 'ecology', group.field = 'journal', group.limit = 1, fl = c('id', 'alm_twitterCount'), base = url)
#>                         groupValue numFound start
#> 1                         plos one    20798     0
#> 2       plos computational biology      473     0
#> 3                     plos biology      828     0
#> 4                             none     1251     0
#> 5                    plos medicine      231     0
#> 6 plos neglected tropical diseases     1003     0
#> 7                   plos pathogens      512     0
#> 8                    plos genetics      665     0
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
#> [1] "{\"response\":{\"numFound\":16307,\"start\":0,\"docs\":[{},{}]},\"highlighting\":{\"10.1371/journal.pmed.0040151\":{\"abstract\":[\"Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting\"]},\"10.1371/journal.pone.0027752\":{\"abstract\":[\"Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking\"]}}}\n"
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
