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
#> 4 Cell-Cell Contact Preserves Cell Viability via Plakoglobin               
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
#> 1  2113280     0 10.1371/journal.pone.0058099/materials_and_methods
#> 2  2113280     0          10.1371/journal.pone.0030394/introduction
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
#> 1   221302     0 10.1371/journal.pbio.1002448
#> 2   221302     0 10.1371/journal.pone.0155843
#> 
#> $mlt$mlt$`10.1371/journal.pone.0059813`
#> # A tibble: 2 x 3
#>   numFound start id                          
#>      <int> <int> <chr>                       
#> 1   213642     0 10.1371/journal.pone.0204749
#> 2   213642     0 10.1371/journal.pone.0175014
#> 
#> 
#> 
#> $group
#>   numFound start                           id
#> 1    45873     0 10.1371/journal.pone.0001248
#> 2    45873     0 10.1371/journal.pone.0059813
#> 
#> $stats
#> $stats$data
#>                   min     max count missing       sum sumOfSquares
#> counter_total_all   0 1113107 45873       0 244364194  9.57388e+12
#>                       mean   stddev
#> counter_total_all 5326.972 13428.75
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
#> 1 cell  171895
#> 2 bird   18193
#> 
#> $facet_fields
#> $facet_fields$journal
#> # A tibble: 9 x 2
#>   term                             value  
#>   <fct>                            <fct>  
#> 1 plos one                         1754116
#> 2 plos genetics                    65482  
#> 3 plos pathogens                   58879  
#> 4 plos neglected tropical diseases 55287  
#> 5 plos computational biology       51118  
#> 6 plos biology                     36181  
#> 7 plos medicine                    25913  
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
#> counter_total_all   0 1113107 45873       0 244364194  9.57388e+12
#> alm_twitterCount    0    3437 45873       0    297821  7.89253e+07
#>                          mean      stddev
#> counter_total_all 5326.972162 13428.74994
#> alm_twitterCount     6.492294    40.96833
```


```r
out$facet
#> $counter_total_all
#> $counter_total_all$volume
#> # A tibble: 16 x 9
#>    volume   min     max count missing      sum  sumOfSquares   mean stddev
#>    <chr>  <dbl>   <dbl> <int>   <int>    <dbl>         <dbl>  <dbl>  <dbl>
#>  1 11         0  287793  5264       0 18005610  316118998184  3421.  6954.
#>  2 12         0  516798  5066       0 12958645  425618775537  2558.  8803.
#>  3 13         0  133733  4271       0  4607026   65316779956  1079.  3759.
#>  4 14         0  104122   389       0  1869920   33268717178  4807.  7911.
#>  5 15         0   45500   111       0   933611   15842926657  8411.  8523.
#>  6 16         0   18492   124       0   352043    2210563125  2839.  3138.
#>  7 1       2053  264368    81       0  1836798  163415872138 22677. 39013.
#>  8 2       2100  150921   482       0  7149303  253950042209 14833. 17536.
#>  9 3       1588  136426   741       0  9458178  286252040290 12764. 14956.
#> 10 4        866  399549  1010       0 12097742  517132809490 11978. 19207.
#> 11 5        125  218447  1539       0 15724071  402125818643 10217. 12530.
#> 12 6         95  396324  2948       0 23618894  670045150068  8012. 12773.
#> 13 7         62  222011  4825       0 33643746  758715844502  6973. 10424.
#> 14 8         34  579345  6360       0 38939478 1162223832632  6123. 12053.
#> 15 9         57 1113107  6620       0 36705411 2774620446321  5545. 19709.
#> 16 10       428  878333  6042       0 26463718 1727021174586  4380. 16331.
#> 
#> $counter_total_all$journal
#> # A tibble: 9 x 9
#>   journal   min     max count missing       sum  sumOfSquares   mean stddev
#>   <chr>   <dbl>   <dbl> <int>   <int>     <dbl>         <dbl>  <dbl>  <dbl>
#> 1 1        1226  216898  1249       0   8518485  211216111507  6820. 11077.
#> 2 2           0  344164  1157       0  19856612 1017916307738 17162. 24202.
#> 3 3           0  216934   311       0   6019228  336436112198 19354. 26636.
#> 4 4        9142   18132     2       0     27274     412345588 13637   6357.
#> 5 5           0  878333 38352       0 174567149 6106563200525  4552. 11769.
#> 6 6           0  137398   833       0   7591498  139525368974  9113.  9195.
#> 7 7           0  146147  1020       0   9497241  179862111621  9311.  9473.
#> 8 8           0  316872  2059       0  10721687  221814167179  5207.  8981.
#> 9 9           0 1113107   890       0   7565020 1360134066186  8500. 38179.
#> 
#> 
#> $alm_twitterCount
#> $alm_twitterCount$volume
#> # A tibble: 16 x 9
#>    volume   min   max count missing   sum sumOfSquares  mean stddev
#>    <chr>  <dbl> <dbl> <int>   <int> <dbl>        <dbl> <dbl>  <dbl>
#>  1 11         0  2138  5264       0 52016     11337738  9.88  45.3 
#>  2 12         0  1877  5066       0 38209     10648781  7.54  45.2 
#>  3 13         0   565  4271       0 15400      2332646  3.61  23.1 
#>  4 14         0   984   389       0 12925      3815533 33.2   93.4 
#>  5 15         0   451   111       0  5168       868780 46.6   75.6 
#>  6 16         0   170   124       0  1054        90480  8.5   25.7 
#>  7 1          0    47    81       0   202         6176  2.49   8.42
#>  8 2          0   125   482       0  1105        62759  2.29  11.2 
#>  9 3          0   503   741       0  1396       270608  1.88  19.0 
#> 10 4          0   311  1010       0  1631       153541  1.61  12.2 
#> 11 5          0   165  1539       0  2671       141665  1.74   9.44
#> 12 6          0   968  2948       0  5646      1629158  1.92  23.4 
#> 13 7          0   860  4825       0 21690      2546258  4.50  22.5 
#> 14 8          0  2029  6360       0 39800      9467280  6.26  38.1 
#> 15 9          0  1880  6620       0 55061     16814671  8.32  49.7 
#> 16 10         0  3437  6042       0 43847     18739223  7.26  55.2 
#> 
#> $alm_twitterCount$journal
#> # A tibble: 9 x 9
#>   journal   min   max count missing    sum sumOfSquares  mean stddev
#>   <chr>   <dbl> <dbl> <int>   <int>  <dbl>        <dbl> <dbl>  <dbl>
#> 1 1           0   451  1249       0   7345       569821  5.88  20.5 
#> 2 2           0  2138  1157       0  36580     14375218 31.6  107.  
#> 3 3           0   830   311       0   5529      1201645 17.8   59.7 
#> 4 4           0     3     2       0      3            9  1.5    2.12
#> 5 5           0  3437 38352       0 209648     59279156  5.47  38.9 
#> 6 6           0   248   833       0   8439       412835 10.1   19.8 
#> 7 7           0   229  1020       0   8584       419352  8.42  18.5 
#> 8 8           0   968  2059       0  11517      1543659  5.59  26.8 
#> 9 9           0   558   890       0  10176      1123602 11.4   33.7
```

## More like this

`solr_mlt` is a function to return similar documents to the one


```r
out <- conn$mlt(params = list(q = 'title:"ecology" AND body:"cell"', mlt.fl = 'title', mlt.mindf = 1, mlt.mintf = 1, fl = 'counter_total_all', rows = 5))
out$docs
#> # A tibble: 5 x 2
#>   id                           counter_total_all
#>   <chr>                                    <int>
#> 1 10.1371/journal.pbio.1001805             22378
#> 2 10.1371/journal.pbio.0020440             25560
#> 3 10.1371/journal.pbio.1002559             11150
#> 4 10.1371/journal.pone.0087217             11502
#> 5 10.1371/journal.pbio.1002191             24483
```


```r
out$mlt
#> $`10.1371/journal.pbio.1001805`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     4319     0 10.1371/journal.pone.0098876              3857
#> 2     4319     0 10.1371/journal.pone.0082578              3140
#> 3     4319     0 10.1371/journal.pone.0102159              2329
#> 4     4319     0 10.1371/journal.pcbi.1002915             11767
#> 5     4319     0 10.1371/journal.pcbi.1003408             10700
#> 
#> $`10.1371/journal.pbio.0020440`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     1254     0 10.1371/journal.pone.0162651              3311
#> 2     1254     0 10.1371/journal.pone.0003259              3310
#> 3     1254     0 10.1371/journal.pntd.0003377              4406
#> 4     1254     0 10.1371/journal.pone.0068814              9416
#> 5     1254     0 10.1371/journal.pone.0101568              5600
#> 
#> $`10.1371/journal.pbio.1002559`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     5962     0 10.1371/journal.pone.0023086              8442
#> 2     5962     0 10.1371/journal.pone.0041684             24475
#> 3     5962     0 10.1371/journal.pone.0155028              2662
#> 4     5962     0 10.1371/journal.pone.0155989              2519
#> 5     5962     0 10.1371/journal.pone.0129394              2111
#> 
#> $`10.1371/journal.pone.0087217`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     5111     0 10.1371/journal.pone.0204743                 0
#> 2     5111     0 10.1371/journal.pone.0175497              1088
#> 3     5111     0 10.1371/journal.pone.0159131              4937
#> 4     5111     0 10.1371/journal.pcbi.0020092             25551
#> 5     5111     0 10.1371/journal.pone.0133941              1336
#> 
#> $`10.1371/journal.pbio.1002191`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1    13747     0 10.1371/journal.pbio.1002232              3055
#> 2    13747     0 10.1371/journal.pone.0070448              2203
#> 3    13747     0 10.1371/journal.pone.0191705               800
#> 4    13747     0 10.1371/journal.pone.0131700              3051
#> 5    13747     0 10.1371/journal.pone.0121680              4980
```

## Groups

`solr_groups()` is a function to return similar documents to the one


```r
conn$group(params = list(q = 'ecology', group.field = 'journal', group.limit = 1, fl = c('id', 'alm_twitterCount')))
#>                         groupValue numFound start
#> 1                         plos one    38352     0
#> 2       plos computational biology      890     0
#> 3                     plos biology     1157     0
#> 4 plos neglected tropical diseases     2059     0
#> 5                   plos pathogens      833     0
#> 6                    plos genetics     1020     0
#> 7                             none     1249     0
#> 8                    plos medicine      311     0
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
#> [1] "{\n  \"response\":{\"numFound\":29215,\"start\":0,\"maxScore\":4.6769786,\"docs\":[\n      {\n        \"id\":\"10.1371/journal.pone.0201042\",\n        \"journal\":\"PLOS ONE\",\n        \"eissn\":\"1932-6203\",\n        \"publication_date\":\"2018-07-26T00:00:00Z\",\n        \"article_type\":\"Research Article\",\n        \"author_display\":[\"Graeme Knibb\",\n          \"Carl. A. Roberts\",\n          \"Eric Robinson\",\n          \"Abi Rose\",\n          \"Paul Christiansen\"],\n        \"abstract\":[\"\\nAcute alcohol administration can lead to a loss of control over drinking. Several models argue that this ‘alcohol priming effect’ is mediated by the effect of alcohol on inhibitory control. Alternatively, beliefs about how alcohol affects behavioural regulation may also underlie alcohol priming and alcohol-induced inhibitory impairments. Here two studies examine the extent to which the alcohol priming effect and inhibitory impairments are moderated by beliefs regarding the effects of alcohol on the ability to control behaviour. In study 1, following a priming drink (placebo or .5g/kg of alcohol), participants were provided with bogus feedback regarding their performance on a measure of inhibitory control (stop-signal task; SST) suggesting that they had high or average self-control. However, the bogus feedback manipulation was not successful. In study 2, before a SST, participants were exposed to a neutral or experimental message suggesting acute doses of alcohol reduce the urge to drink and consumed a priming drink and this manipulation was successful. In both studies craving was assessed throughout and a bogus taste test which measured ad libitum drinking was completed. Results suggest no effect of beliefs on craving or ad lib consumption within either study. However, within study 2, participants exposed to the experimental message displayed evidence of alcohol-induced impairments of inhibitory control, while those exposed to the neutral message did not. These findings do not suggest beliefs about the effects of alcohol moderate the alcohol priming effect but do suggest beliefs may, in part, underlie the effect of alcohol on inhibitory control.\\n\"],\n        \"title_display\":\"The effect of beliefs about alcohol’s acute effects on alcohol priming and alcohol-induced impairments of inhibitory control\",\n        \"score\":4.6769786},\n      {\n        \"id\":\"10.1371/journal.pone.0185457\",\n        \"journal\":\"PLOS ONE\",\n        \"eissn\":\"1932-6203\",\n        \"publication_date\":\"2017-09-28T00:00:00Z\",\n        \"article_type\":\"Research Article\",\n        \"author_display\":[\"Jacqueline Willmore\",\n          \"Terry-Lynne Marko\",\n          \"Darcie Taing\",\n          \"Hugues Sampasa-Kanyinga\"],\n        \"abstract\":[\"Objectives: Alcohol-related morbidity and mortality are significant public health issues. The purpose of this study was to describe the prevalence and trends over time of alcohol consumption and alcohol-related morbidity and mortality; and public attitudes of alcohol use impacts on families and the community in Ottawa, Canada. Methods: Prevalence (2013–2014) and trends (2000–2001 to 2013–2014) of alcohol use were obtained from the Canadian Community Health Survey. Data on paramedic responses (2015), emergency department (ED) visits (2013–2015), hospitalizations (2013–2015) and deaths (2007–2011) were used to quantify the acute and chronic health effects of alcohol in Ottawa. Qualitative data were obtained from the “Have Your Say” alcohol survey, an online survey of public attitudes on alcohol conducted in 2016. Results: In 2013–2014, an estimated 595,300 (83%) Ottawa adults 19 years and older drank alcohol, 42% reported binge drinking in the past year. Heavy drinking increased from 15% in 2000–2001 to 20% in 2013–2014. In 2015, the Ottawa Paramedic Service responded to 2,060 calls directly attributable to alcohol. Between 2013 and 2015, there were an average of 6,100 ED visits and 1,270 hospitalizations per year due to alcohol. Annually, alcohol use results in at least 140 deaths in Ottawa. Men have higher rates of alcohol-attributable paramedic responses, ED visits, hospitalizations and deaths than women, and young adults have higher rates of alcohol-attributable paramedic responses. Qualitative data of public attitudes indicate that alcohol misuse has greater repercussions not only on those who drink, but also on the family and community. Conclusions: Results highlight the need for healthy public policy intended to encourage a culture of drinking in moderation in Ottawa to support lower risk alcohol use, particularly among men and young adults. \"],\n        \"title_display\":\"The burden of alcohol-related morbidity and mortality in Ottawa, Canada\",\n        \"score\":4.676675}]\n  },\n  \"highlighting\":{\n    \"10.1371/journal.pone.0201042\":{\n      \"abstract\":[\"\\nAcute <em>alcohol</em> administration can lead to a loss of control over drinking. Several models argue\"]},\n    \"10.1371/journal.pone.0185457\":{\n      \"abstract\":[\"Objectives: <em>Alcohol</em>-related morbidity and mortality are significant public health issues\"]}}}\n"
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
