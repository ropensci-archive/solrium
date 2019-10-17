<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Solr search}
%\VignetteEncoding{UTF-8}
-->



Solr search
===========

**A general purpose R interface to [Apache Solr](https://lucene.apache.org/solr/)**

## Solr info

+ [Solr home page](https://lucene.apache.org/solr/)
+ [Highlighting help](https://lucene.apache.org/solr/guide/8_2/highlighting.html)
+ [Faceting help](https://lucene.apache.org/solr/guide/8_2/faceting.html)
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
(conn <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL))
#> <Solr Client>
#>   host: api.plos.org
#>   path: search
#>   port: 
#>   scheme: http
#>   errors: simple
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
conn$search(params = list(q = '*:*', rows = 2, fl = 'id'))
#> # A tibble: 2 x 1
#>   id                                                
#>   <chr>                                             
#> 1 10.1371/journal.pone.0058099/materials_and_methods
#> 2 10.1371/journal.pone.0030394/introduction
```

__Search in specific fields with `:`__

Search for word ecology in title and cell in the body


```r
conn$search(params = list(q = 'title:"ecology" AND body:"cell"', fl = 'title', rows = 5))
#> # A tibble: 5 x 1
#>   title                                                    
#>   <chr>                                                    
#> 1 The Ecology of Collective Behavior                       
#> 2 Ecology's Big, Hot Idea                                  
#> 3 Chasing Ecological Interactions                          
#> 4 Spatial Ecology of Bacteria at the Microscale in Soil    
#> 5 Biofilm Formation As a Response to Ecological Competition
```

__Wildcards__

Search for word that starts with "cell" in the title field


```r
conn$search(params = list(q = 'title:"cell*"', fl = 'title', rows = 5))
#> # A tibble: 5 x 1
#>   title                                                                    
#>   <chr>                                                                    
#> 1 Cancer Stem Cell-Like Side Population Cells in Clear Cell Renal Cell Car…
#> 2 Tumor Cell Recognition Efficiency by T Cells                             
#> 3 Enhancement of Chemotactic Cell Aggregation by Haptotactic Cell-To-Cell …
#> 4 Cell-Cell Adhesions and Cell Contractility Are Upregulated upon Desmosom…
#> 5 Dcas Supports Cell Polarization and Cell-Cell Adhesion Complexes in Deve…
```

__Proximity search__

Search for words "sports" and "alcohol" within four words of each other


```r
conn$search(params = list(q = 'everything:"stem cell"~7', fl = 'title', rows = 3))
#> # A tibble: 3 x 1
#>   title                                                                    
#>   <chr>                                                                    
#> 1 Effect of Dedifferentiation on Time to Mutation Acquisition in Stem Cell…
#> 2 A Mathematical Model of Cancer Stem Cell Driven Tumor Initiation: Implic…
#> 3 Phenotypic Evolutionary Models in Stem Cell Biology: Replacement, Quiesc…
```

__Range searches__

Search for articles with Twitter count between 5 and 10


```r
conn$search(params = list(q = '*:*', fl = c('alm_twitterCount', 'id'), fq = 'alm_twitterCount:[5 TO 50]', rows = 10))
#> # A tibble: 10 x 2
#>    id                                                  alm_twitterCount
#>    <chr>                                                          <int>
#>  1 10.1371/journal.pbio.0030378/title                                 8
#>  2 10.1371/journal.pbio.0030378/abstract                              8
#>  3 10.1371/journal.pbio.0030378/references                            8
#>  4 10.1371/journal.pone.0184491                                      10
#>  5 10.1371/journal.pone.0184491/title                                10
#>  6 10.1371/journal.pone.0184491/abstract                             10
#>  7 10.1371/journal.pone.0184491/references                           10
#>  8 10.1371/journal.pone.0184491/body                                 10
#>  9 10.1371/journal.pone.0184491/introduction                         10
#> 10 10.1371/journal.pone.0184491/results_and_discussion               10
```

__Boosts__

Assign higher boost to title matches than to body matches (compare the two calls)


```r
conn$search(params = list(q = 'title:"cell" abstract:"science"', fl = 'title', rows = 3))
#> # A tibble: 3 x 1
#>   title                                                                    
#>   <chr>                                                                    
#> 1 I Want More and Better Cells! – An Outreach Project about Stem Cells and…
#> 2 Globalization of Stem Cell Science: An Examination of Current and Past C…
#> 3 Virtual Reconstruction and Three-Dimensional Printing of Blood Cells as …
```


```r
conn$search(params = list(q = 'title:"cell"^1.5 AND abstract:"science"', fl = 'title', rows = 3))
#> # A tibble: 3 x 1
#>   title                                                                    
#>   <chr>                                                                    
#> 1 I Want More and Better Cells! – An Outreach Project about Stem Cells and…
#> 2 Virtual Reconstruction and Three-Dimensional Printing of Blood Cells as …
#> 3 Globalization of Stem Cell Science: An Examination of Current and Past C…
```

## Search all

`solr_all()` differs from `solr_search()` in that it allows specifying facets, mlt, groups,
stats, etc, and returns all of those. It defaults to `parsetype = "list"` and `wt="json"`,
whereas `solr_search()` defaults to `parsetype = "df"` and `wt="csv"`. `solr_all()` returns
by default a list, whereas `solr_search()` by default returns a data.frame.

A basic search, just docs output


```r
conn$all(params = list(q = '*:*', rows = 2, fl = 'id'))
#> $search
#> # A tibble: 2 x 1
#>   id                                                
#>   <chr>                                             
#> 1 10.1371/journal.pone.0058099/materials_and_methods
#> 2 10.1371/journal.pone.0030394/introduction         
#> 
#> $facet
#> list()
#> 
#> $high
#> # A tibble: 0 x 0
#> 
#> $mlt
#> $mlt$docs
#> # A tibble: 2 x 1
#>   id                                                
#>   <chr>                                             
#> 1 10.1371/journal.pone.0058099/materials_and_methods
#> 2 10.1371/journal.pone.0030394/introduction         
#> 
#> $mlt$mlt
#> list()
#> 
#> 
#> $group
#>   numFound start                                                 id
#> 1  2263584     0 10.1371/journal.pone.0058099/materials_and_methods
#> 2  2263584     0          10.1371/journal.pone.0030394/introduction
#> 
#> $stats
#> NULL
```

Get docs, mlt, and stats output


```r
conn$all(params = list(q = 'ecology', rows = 2, fl = 'id', mlt = 'true', mlt.count = 2, mlt.fl = 'abstract', stats = 'true', stats.field = 'counter_total_all'))
#> $search
#> # A tibble: 2 x 1
#>   id                          
#>   <chr>                       
#> 1 10.1371/journal.pone.0001248
#> 2 10.1371/journal.pone.0059813
#> 
#> $facet
#> list()
#> 
#> $high
#> # A tibble: 0 x 0
#> 
#> $mlt
#> $mlt$docs
#> # A tibble: 2 x 1
#>   id                          
#>   <chr>                       
#> 1 10.1371/journal.pone.0001248
#> 2 10.1371/journal.pone.0059813
#> 
#> $mlt$mlt
#> $mlt$mlt$`10.1371/journal.pone.0001248`
#> # A tibble: 2 x 3
#>   numFound start id                          
#>      <int> <int> <chr>                       
#> 1   236603     0 10.1371/journal.pbio.1002448
#> 2   236603     0 10.1371/journal.pone.0155843
#> 
#> $mlt$mlt$`10.1371/journal.pone.0059813`
#> # A tibble: 2 x 3
#>   numFound start id                          
#>      <int> <int> <chr>                       
#> 1   228703     0 10.1371/journal.pone.0204749
#> 2   228703     0 10.1371/journal.pone.0175014
#> 
#> 
#> 
#> $group
#>   numFound start                           id
#> 1    49638     0 10.1371/journal.pone.0001248
#> 2    49638     0 10.1371/journal.pone.0059813
#> 
#> $stats
#> $stats$data
#>                   min     max count missing       sum sumOfSquares    mean
#> counter_total_all   0 1322780 49638       0 264206214 1.119659e+13 5322.66
#>                     stddev
#> counter_total_all 14044.15
#> 
#> $stats$facet
#> NULL
```


## Facet


```r
conn$facet(params = list(q = '*:*', facet.field = 'journal', facet.query = c('cell', 'bird')))
#> $facet_queries
#> # A tibble: 2 x 2
#>   term   value
#>   <chr>  <int>
#> 1 cell  181404
#> 2 bird   19370
#> 
#> $facet_fields
#> $facet_fields$journal
#> # A tibble: 9 x 2
#>   term                             value  
#>   <fct>                            <fct>  
#> 1 plos one                         1878564
#> 2 plos genetics                    69743  
#> 3 plos pathogens                   62807  
#> 4 plos neglected tropical diseases 61216  
#> 5 plos computational biology       56361  
#> 6 plos biology                     39732  
#> 7 plos medicine                    27839  
#> 8 plos clinical trials             521    
#> 9 plos medicin                     9      
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
conn$highlight(params = list(q = 'alcohol', hl.fl = 'abstract', rows = 2))
#> # A tibble: 2 x 2
#>   names                 abstract                                           
#>   <chr>                 <chr>                                              
#> 1 10.1371/journal.pone… "\nAcute <em>alcohol</em> administration can lead …
#> 2 10.1371/journal.pone… Objectives: <em>Alcohol</em>-related morbidity and…
```

## Stats


```r
out <- conn$stats(params = list(q = 'ecology', stats.field = c('counter_total_all', 'alm_twitterCount'), stats.facet = c('journal', 'volume')))
```


```r
out$data
#>                   min     max count missing       sum sumOfSquares
#> counter_total_all   0 1322780 49638       0 264206214 1.119659e+13
#> alm_twitterCount    0    3438 49638       0    304236 8.148536e+07
#>                          mean     stddev
#> counter_total_all 5322.660341 14044.1498
#> alm_twitterCount     6.129095    40.0507
```


```r
out$facet
#> $counter_total_all
#> $counter_total_all$volume
#> # A tibble: 17 x 9
#>    volume   min     max count missing      sum  sumOfSquares   mean stddev
#>    <chr>  <dbl>   <dbl> <int>   <int>    <dbl>         <dbl>  <dbl>  <dbl>
#>  1 11         0  287793  5264       0 18895052  343471377354  3589.  7237.
#>  2 12         0  516798  5076       0 14049766  457686530584  2768.  9084.
#>  3 13         0  153970  4715       0  5936439   86585551129  1259.  4097.
#>  4 14         0  141744  3293       0  2631930   53269058704   799.  3942.
#>  5 15         0   50449   380       0  1602416   24738162692  4217.  6888.
#>  6 16         0   36261   154       0   829924    8698444092  5389.  5255.
#>  7 17         0   42811   108       0   228662    2794636940  2117.  4647.
#>  8 1       2127  331494    81       0  1989864  220314081736 24566. 46291.
#>  9 2       2141  155085   482       0  7419080  277345781732 15392. 18417.
#> 10 3       1621  138038   741       0  9765264  305018983590 13178. 15436.
#> 11 4        866  404016  1010       0 12543775  550954124849 12420. 19790.
#> 12 5        125  248082  1539       0 16437056  451150556196 10680. 13386.
#> 13 6         95  396324  2948       0 25087216  729164435884  8510. 13228.
#> 14 7         62  270034  4825       0 36102767  872710683283  7482. 11176.
#> 15 8         34  611601  6360       0 42214728 1329098761134  6638. 12843.
#> 16 9         57 1322780  6620       0 40933803 3662802686107  6183. 22697.
#> 17 10       428  887162  6042       0 27538472 1820785780330  4558. 16752.
#> 
#> $counter_total_all$journal
#> # A tibble: 9 x 9
#>   journal   min     max count missing       sum  sumOfSquares   mean stddev
#>   <chr>   <dbl>   <dbl> <int>   <int>     <dbl>         <dbl>  <dbl>  <dbl>
#> 1 1           0  391184  1272       0  22099069 1251395524029 17373. 26125.
#> 2 2           0  270034   335       0   6608325  400062632503 19726. 28417.
#> 3 3        1354  221758  1249       0   9088713  227814882055  7277. 11382.
#> 4 4        9348   18512     2       0     27860     430079248 13930   6480.
#> 5 5           0  887162 41465       0 187628028 6833430419632  4525. 12014.
#> 6 6           0  138374   906       0   7870667  145153611759  8687.  9211.
#> 7 7           0  153848  1101       0  10283498  199515141164  9340.  9698.
#> 8 8           0  323752  2290       0  12009181  244148093179  5244.  8897.
#> 9 9           0 1322780  1018       0   8590873 1894639252767  8439. 42328.
#> 
#> 
#> $alm_twitterCount
#> $alm_twitterCount$volume
#> # A tibble: 17 x 9
#>    volume   min   max count missing   sum sumOfSquares  mean stddev
#>    <chr>  <dbl> <dbl> <int>   <int> <dbl>        <dbl> <dbl>  <dbl>
#>  1 11         0  2142  5264       0 52248     11395704  9.93  45.5 
#>  2 12         0  1877  5076       0 38615     10903883  7.61  45.7 
#>  3 13         0   578  4715       0 15920      2404482  3.38  22.3 
#>  4 14         0   984  3293       0 14247      3956965  4.33  34.4 
#>  5 15         0   453   380       0  5640       906810 14.8   46.6 
#>  6 16         0   456   154       0  2830       414458 18.4   48.7 
#>  7 17         0    44   108       0   170         4882  1.57   6.57
#>  8 1          0    47    81       0   208         6306  2.57   8.49
#>  9 2          0   125   482       0  1116        63658  2.32  11.3 
#> 10 3          0   504   741       0  1407       271861  1.90  19.1 
#> 11 4          0   313  1010       0  1655       155545  1.64  12.3 
#> 12 5          0   165  1539       0  2694       142070  1.75   9.45
#> 13 6          0   968  2948       0  5709      1631337  1.94  23.4 
#> 14 7          0   860  4825       0 21860      2578512  4.53  22.7 
#> 15 8          0  2029  6360       0 40719     10854695  6.40  40.8 
#> 16 9          0  1880  6620       0 55292     17030904  8.35  50.0 
#> 17 10         0  3438  6042       0 43906     18763286  7.27  55.3 
#> 
#> $alm_twitterCount$journal
#> # A tibble: 9 x 9
#>   journal   min   max count missing    sum sumOfSquares  mean stddev
#>   <chr>   <dbl> <dbl> <int>   <int>  <dbl>        <dbl> <dbl>  <dbl>
#> 1 1           0  2142  1272       0  39045     15091795 30.7  105.  
#> 2 2           0   831   335       0   5826      1217690 17.4   57.8 
#> 3 3           0   455  1249       0   7368       576290  5.90  20.7 
#> 4 4           0     3     2       0      3            9  1.5    2.12
#> 5 5           0  3438 41465       0 211665     60964301  5.10  38.0 
#> 6 6           0   250   906       0   8476       414748  9.36  19.3 
#> 7 7           0   230  1101       0   9237       461117  8.39  18.7 
#> 8 8           0   968  2290       0  11804      1555638  5.15  25.6 
#> 9 9           0   578  1018       0  10812      1203770 10.6   32.7
```

## More like this

`solr_mlt` is a function to return similar documents to the one


```r
out <- conn$mlt(params = list(q = 'title:"ecology" AND body:"cell"', mlt.fl = 'title', mlt.mindf = 1, mlt.mintf = 1, fl = 'counter_total_all', rows = 5))
out$docs
#> # A tibble: 5 x 2
#>   id                           counter_total_all
#>   <chr>                                    <int>
#> 1 10.1371/journal.pbio.1001805             23958
#> 2 10.1371/journal.pbio.0020440             26090
#> 3 10.1371/journal.pbio.1002559             11628
#> 4 10.1371/journal.pone.0087217             16196
#> 5 10.1371/journal.pbio.1002191             27371
```


```r
out$mlt
#> $`10.1371/journal.pbio.1001805`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     4678     0 10.1371/journal.pone.0098876              4047
#> 2     4678     0 10.1371/journal.pone.0082578              3244
#> 3     4678     0 10.1371/journal.pone.0102159              2434
#> 4     4678     0 10.1371/journal.pone.0193049              1274
#> 5     4678     0 10.1371/journal.pcbi.1003408             11685
#> 
#> $`10.1371/journal.pbio.0020440`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     1375     0 10.1371/journal.pone.0162651              3463
#> 2     1375     0 10.1371/journal.pone.0003259              3417
#> 3     1375     0 10.1371/journal.pntd.0003377              4613
#> 4     1375     0 10.1371/journal.pone.0068814              9701
#> 5     1375     0 10.1371/journal.pone.0101568              6017
#> 
#> $`10.1371/journal.pbio.1002559`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     6288     0 10.1371/journal.pone.0155028              2881
#> 2     6288     0 10.1371/journal.pone.0023086              9361
#> 3     6288     0 10.1371/journal.pone.0041684             26571
#> 4     6288     0 10.1371/journal.pone.0155989              2519
#> 5     6288     0 10.1371/journal.pone.0129394              2111
#> 
#> $`10.1371/journal.pone.0087217`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     5565     0 10.1371/journal.pone.0204743               103
#> 2     5565     0 10.1371/journal.pone.0175497              1088
#> 3     5565     0 10.1371/journal.pone.0159131              4937
#> 4     5565     0 10.1371/journal.pcbi.0020092             26453
#> 5     5565     0 10.1371/journal.pone.0133941              1336
#> 
#> $`10.1371/journal.pbio.1002191`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1    14595     0 10.1371/journal.pbio.1002232              3055
#> 2    14595     0 10.1371/journal.pone.0191705              1040
#> 3    14595     0 10.1371/journal.pone.0070448              2497
#> 4    14595     0 10.1371/journal.pone.0131700              3353
#> 5    14595     0 10.1371/journal.pone.0121680              4980
```

## Groups

`solr_groups()` is a function to return similar documents to the one


```r
conn$group(params = list(q = 'ecology', group.field = 'journal', group.limit = 1, fl = c('id', 'alm_twitterCount')))
#>                         groupValue numFound start
#> 1                         plos one    41465     0
#> 2       plos computational biology     1018     0
#> 3                     plos biology     1272     0
#> 4 plos neglected tropical diseases     2290     0
#> 5                   plos pathogens      906     0
#> 6                    plos genetics     1101     0
#> 7                             none     1249     0
#> 8                    plos medicine      335     0
#> 9             plos clinical trials        2     0
#>                             id alm_twitterCount
#> 1 10.1371/journal.pone.0001248                0
#> 2 10.1371/journal.pcbi.1003594               21
#> 3 10.1371/journal.pbio.0060300                0
#> 4 10.1371/journal.pntd.0004689               13
#> 5 10.1371/journal.ppat.1005780               19
#> 6 10.1371/journal.pgen.1005860              135
#> 7 10.1371/journal.pone.0043894                0
#> 8 10.1371/journal.pmed.1000303                1
#> 9 10.1371/journal.pctr.0020010                0
```

## Parsing

`solr_parse()` is a general purpose parser function with extension methods for parsing outputs from functions in `solr`. `solr_parse()` is used internally within functions to do parsing after retrieving data from the server. You can optionally get back raw `json`, `xml`, or `csv` with the `raw=TRUE`, and then parse afterwards with `solr_parse()`.

For example:


```r
(out <- conn$highlight(params = list(q = 'alcohol', hl.fl = 'abstract', rows = 2), raw = TRUE))
#> [1] "{\n  \"response\":{\"numFound\":31528,\"start\":0,\"maxScore\":4.6573215,\"docs\":[\n      {\n        \"id\":\"10.1371/journal.pone.0201042\",\n        \"journal\":\"PLOS ONE\",\n        \"eissn\":\"1932-6203\",\n        \"publication_date\":\"2018-07-26T00:00:00Z\",\n        \"article_type\":\"Research Article\",\n        \"author_display\":[\"Graeme Knibb\",\n          \"Carl. A. Roberts\",\n          \"Eric Robinson\",\n          \"Abi Rose\",\n          \"Paul Christiansen\"],\n        \"abstract\":[\"\\nAcute alcohol administration can lead to a loss of control over drinking. Several models argue that this ‘alcohol priming effect’ is mediated by the effect of alcohol on inhibitory control. Alternatively, beliefs about how alcohol affects behavioural regulation may also underlie alcohol priming and alcohol-induced inhibitory impairments. Here two studies examine the extent to which the alcohol priming effect and inhibitory impairments are moderated by beliefs regarding the effects of alcohol on the ability to control behaviour. In study 1, following a priming drink (placebo or .5g/kg of alcohol), participants were provided with bogus feedback regarding their performance on a measure of inhibitory control (stop-signal task; SST) suggesting that they had high or average self-control. However, the bogus feedback manipulation was not successful. In study 2, before a SST, participants were exposed to a neutral or experimental message suggesting acute doses of alcohol reduce the urge to drink and consumed a priming drink and this manipulation was successful. In both studies craving was assessed throughout and a bogus taste test which measured ad libitum drinking was completed. Results suggest no effect of beliefs on craving or ad lib consumption within either study. However, within study 2, participants exposed to the experimental message displayed evidence of alcohol-induced impairments of inhibitory control, while those exposed to the neutral message did not. These findings do not suggest beliefs about the effects of alcohol moderate the alcohol priming effect but do suggest beliefs may, in part, underlie the effect of alcohol on inhibitory control.\\n\"],\n        \"title_display\":\"The effect of beliefs about alcohol’s acute effects on alcohol priming and alcohol-induced impairments of inhibitory control\",\n        \"score\":4.6573215},\n      {\n        \"id\":\"10.1371/journal.pone.0185457\",\n        \"journal\":\"PLOS ONE\",\n        \"eissn\":\"1932-6203\",\n        \"publication_date\":\"2017-09-28T00:00:00Z\",\n        \"article_type\":\"Research Article\",\n        \"author_display\":[\"Jacqueline Willmore\",\n          \"Terry-Lynne Marko\",\n          \"Darcie Taing\",\n          \"Hugues Sampasa-Kanyinga\"],\n        \"abstract\":[\"Objectives: Alcohol-related morbidity and mortality are significant public health issues. The purpose of this study was to describe the prevalence and trends over time of alcohol consumption and alcohol-related morbidity and mortality; and public attitudes of alcohol use impacts on families and the community in Ottawa, Canada. Methods: Prevalence (2013–2014) and trends (2000–2001 to 2013–2014) of alcohol use were obtained from the Canadian Community Health Survey. Data on paramedic responses (2015), emergency department (ED) visits (2013–2015), hospitalizations (2013–2015) and deaths (2007–2011) were used to quantify the acute and chronic health effects of alcohol in Ottawa. Qualitative data were obtained from the “Have Your Say” alcohol survey, an online survey of public attitudes on alcohol conducted in 2016. Results: In 2013–2014, an estimated 595,300 (83%) Ottawa adults 19 years and older drank alcohol, 42% reported binge drinking in the past year. Heavy drinking increased from 15% in 2000–2001 to 20% in 2013–2014. In 2015, the Ottawa Paramedic Service responded to 2,060 calls directly attributable to alcohol. Between 2013 and 2015, there were an average of 6,100 ED visits and 1,270 hospitalizations per year due to alcohol. Annually, alcohol use results in at least 140 deaths in Ottawa. Men have higher rates of alcohol-attributable paramedic responses, ED visits, hospitalizations and deaths than women, and young adults have higher rates of alcohol-attributable paramedic responses. Qualitative data of public attitudes indicate that alcohol misuse has greater repercussions not only on those who drink, but also on the family and community. Conclusions: Results highlight the need for healthy public policy intended to encourage a culture of drinking in moderation in Ottawa to support lower risk alcohol use, particularly among men and young adults. \"],\n        \"title_display\":\"The burden of alcohol-related morbidity and mortality in Ottawa, Canada\",\n        \"score\":4.65702}]\n  },\n  \"highlighting\":{\n    \"10.1371/journal.pone.0201042\":{\n      \"abstract\":[\"\\nAcute <em>alcohol</em> administration can lead to a loss of control over drinking. Several models argue\"]},\n    \"10.1371/journal.pone.0185457\":{\n      \"abstract\":[\"Objectives: <em>Alcohol</em>-related morbidity and mortality are significant public health issues\"]}}}\n"
#> attr(,"class")
#> [1] "sr_high"
#> attr(,"wt")
#> [1] "json"
```

Then parse


```r
solr_parse(out, 'df')
#> # A tibble: 2 x 2
#>   names                 abstract                                           
#>   <chr>                 <chr>                                              
#> 1 10.1371/journal.pone… "\nAcute <em>alcohol</em> administration can lead …
#> 2 10.1371/journal.pone… Objectives: <em>Alcohol</em>-related morbidity and…
```

[Please report any issues or bugs](https://github.com/ropensci/solrium/issues).
