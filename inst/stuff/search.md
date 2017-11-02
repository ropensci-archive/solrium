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
#>                                   id
#>                                <chr>
#> 1       10.1371/journal.pone.0039573
#> 2 10.1371/journal.pone.0039573/title
```

__Search in specific fields with `:`__

Search for word ecology in title and cell in the body


```r
conn$search(params = list(q = 'title:"ecology" AND body:"cell"', fl = 'title', rows = 5))
#> # A tibble: 5 x 1
#>                                                       title
#>                                                       <chr>
#> 1                        The Ecology of Collective Behavior
#> 2                                   Ecology's Big, Hot Idea
#> 3                           Chasing Ecological Interactions
#> 4     Spatial Ecology of Bacteria at the Microscale in Soil
#> 5 Biofilm Formation As a Response to Ecological Competition
```

__Wildcards__

Search for word that starts with "cell" in the title field


```r
conn$search(params = list(q = 'title:"cell*"', fl = 'title', rows = 5))
#> # A tibble: 5 x 1
#>                                                                         title
#>                                                                         <chr>
#> 1 Cancer Stem Cell-Like Side Population Cells in Clear Cell Renal Cell Carcin
#> 2                                Tumor Cell Recognition Efficiency by T Cells
#> 3 Cell-Cell Adhesions and Cell Contractility Are Upregulated upon Desmosome D
#> 4 Enhancement of Chemotactic Cell Aggregation by Haptotactic Cell-To-Cell Int
#> 5 MS4a4B, a CD20 Homologue in T Cells, Inhibits T Cell Propagation by Modulat
```

__Proximity search__

Search for words "sports" and "alcohol" within four words of each other


```r
conn$search(params = list(q = 'everything:"stem cell"~7', fl = 'title', rows = 3))
#> # A tibble: 3 x 1
#>                                                                         title
#>                                                                         <chr>
#> 1 Effect of Dedifferentiation on Time to Mutation Acquisition in Stem Cell-Dr
#> 2 A Mathematical Model of Cancer Stem Cell Driven Tumor Initiation: Implicati
#> 3 Phenotypic Evolutionary Models in Stem Cell Biology: Replacement, Quiescenc
```

__Range searches__

Search for articles with Twitter count between 5 and 10


```r
conn$search(params = list(q = '*:*', fl = c('alm_twitterCount', 'id'), fq = 'alm_twitterCount:[5 TO 50]', rows = 10))
#> # A tibble: 10 x 2
#>                                                     id alm_twitterCount
#>                                                  <chr>            <int>
#>  1                        10.1371/journal.pone.0151003               15
#>  2                  10.1371/journal.pone.0151003/title               15
#>  3               10.1371/journal.pone.0151003/abstract               15
#>  4             10.1371/journal.pone.0151003/references               15
#>  5                   10.1371/journal.pone.0151003/body               15
#>  6           10.1371/journal.pone.0095353/introduction               12
#>  7 10.1371/journal.pone.0095353/results_and_discussion               12
#>  8  10.1371/journal.pone.0095353/materials_and_methods               12
#>  9 10.1371/journal.pone.0095353/supporting_information               12
#> 10            10.1371/journal.pone.0095353/conclusions               12
```

__Boosts__

Assign higher boost to title matches than to body matches (compare the two calls)


```r
conn$search(params = list(q = 'title:"cell" abstract:"science"', fl = 'title', rows = 3))
#> # A tibble: 3 x 1
#>                                                                         title
#>                                                                         <chr>
#> 1 I Want More and Better Cells! – An Outreach Project about Stem Cells and It
#> 2 Globalization of Stem Cell Science: An Examination of Current and Past Coll
#> 3 Virtual Reconstruction and Three-Dimensional Printing of Blood Cells as a T
```


```r
conn$search(params = list(q = 'title:"cell"^1.5 AND abstract:"science"', fl = 'title', rows = 3))
#> # A tibble: 3 x 1
#>                                                                         title
#>                                                                         <chr>
#> 1 I Want More and Better Cells! – An Outreach Project about Stem Cells and It
#> 2 Virtual Reconstruction and Three-Dimensional Printing of Blood Cells as a T
#> 3 Globalization of Stem Cell Science: An Examination of Current and Past Coll
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
#>                                   id
#>                                <chr>
#> 1       10.1371/journal.pone.0095608
#> 2 10.1371/journal.pone.0081656/title
#> 
#> $facet
#> NULL
#> 
#> $high
#> # A tibble: 0 x 0
#> 
#> $mlt
#> $mlt$docs
#> # A tibble: 2 x 1
#>                                   id
#>                                <chr>
#> 1       10.1371/journal.pone.0095608
#> 2 10.1371/journal.pone.0081656/title
#> 
#> $mlt$mlt
#> list()
#> 
#> 
#> $group
#>   numFound start                                 id
#> 1  1898495     0       10.1371/journal.pone.0095608
#> 2  1898495     0 10.1371/journal.pone.0081656/title
#> 
#> $stats
#> NULL
```

Get docs, mlt, and stats output


```r
conn$all(params = list(q = 'ecology', rows = 2, fl = 'id', mlt = 'true', mlt.count = 2, mlt.fl = 'abstract', stats = 'true', stats.field = 'counter_total_all'))
#> $search
#> # A tibble: 2 x 1
#>                             id
#>                          <chr>
#> 1 10.1371/journal.pone.0001248
#> 2 10.1371/journal.pone.0059813
#> 
#> $facet
#> NULL
#> 
#> $high
#> # A tibble: 0 x 0
#> 
#> $mlt
#> $mlt$docs
#> # A tibble: 2 x 1
#>                             id
#>                          <chr>
#> 1 10.1371/journal.pone.0001248
#> 2 10.1371/journal.pone.0059813
#> 
#> $mlt$mlt
#> $mlt$mlt$`10.1371/journal.pone.0001248`
#> # A tibble: 2 x 3
#>   numFound start                           id
#>      <int> <int>                        <chr>
#> 1   199364     0 10.1371/journal.pbio.1002448
#> 2   199364     0 10.1371/journal.pone.0155843
#> 
#> $mlt$mlt$`10.1371/journal.pone.0059813`
#> # A tibble: 2 x 3
#>   numFound start                           id
#>      <int> <int>                        <chr>
#> 1   192063     0 10.1371/journal.pone.0175014
#> 2   192063     0 10.1371/journal.pone.0152802
#> 
#> 
#> 
#> $group
#>   numFound start                           id
#> 1    40497     0 10.1371/journal.pone.0001248
#> 2    40497     0 10.1371/journal.pone.0059813
#> 
#> $stats
#> $stats$data
#>                   min    max count missing       sum sumOfSquares     mean
#> counter_total_all   0 920716 40497       0 219020039 7.604567e+12 5408.303
#>                     stddev
#> counter_total_all 12591.07
#> 
#> $stats$facet
#> NULL
```


## Facet


```r
conn$facet(params = list(q = '*:*', facet.field = 'journal', facet.query = c('cell', 'bird')))
#> $facet_queries
#> # A tibble: 2 x 2
#>    term  value
#>   <chr>  <int>
#> 1  cell 157652
#> 2  bird  16385
#> 
#> $facet_fields
#> $facet_fields$journal
#> # A tibble: 9 x 2
#>                               term   value
#>                              <chr>   <chr>
#> 1                         plos one 1572163
#> 2                    plos genetics   59871
#> 3                   plos pathogens   53246
#> 4 plos neglected tropical diseases   47510
#> 5       plos computational biology   45582
#> 6                     plos biology   32513
#> 7                    plos medicine   23519
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
conn$highlight(params = list(q = 'alcohol', hl.fl = 'abstract', rows = 2))
#> # A tibble: 2 x 2
#>                          names
#>                          <chr>
#> 1 10.1371/journal.pone.0185457
#> 2 10.1371/journal.pone.0071284
#> # ... with 1 more variables: abstract <chr>
```

## Stats


```r
out <- conn$stats(params = list(q = 'ecology', stats.field = c('counter_total_all', 'alm_twitterCount'), stats.facet = c('journal', 'volume')))
```


```r
out$data
#>                   min    max count missing       sum sumOfSquares
#> counter_total_all   0 920716 40497       0 219020039 7.604567e+12
#> alm_twitterCount    0   3401 40497       0    281128 7.300081e+07
#>                          mean      stddev
#> counter_total_all 5408.302813 12591.07462
#> alm_twitterCount     6.941946    41.88646
```


```r
out$facet
#> $counter_total_all
#> $counter_total_all$volume
#> # A tibble: 15 x 9
#>    volume   min    max count missing      sum sumOfSquares      mean
#>     <chr> <dbl>  <dbl> <int>   <int>    <dbl>        <dbl>     <dbl>
#>  1     11     0 256074  5228       0 14743805 2.497370e+11  2820.162
#>  2     12     0 351313  4151       0  8599407 2.347067e+11  2071.647
#>  3     13     0 120383   317       0  2103017 4.576415e+10  6634.123
#>  4     14  1901  60943    88       0  1031347 1.987305e+10 11719.852
#>  5     15     0  40959    65       0   686794 1.158216e+10 10566.062
#>  6      1  2053 251589    81       0  1797446 1.527725e+11 22190.691
#>  7      2  2036 144049   482       0  6846601 2.307506e+11 14204.566
#>  8      3  1536 135005   741       0  9044463 2.600687e+11 12205.753
#>  9      4   866 391765  1010       0 11508282 4.670832e+11 11394.339
#> 10      5   125 195413  1539       0 14872531 3.531712e+11  9663.763
#> 11      6    95 362994  2948       0 22450122 5.859788e+11  7615.374
#> 12      7    62 205162  4825       0 31821133 6.511283e+11  6595.053
#> 13      8    34 519510  6360       0 36582389 9.960596e+11  5751.948
#> 14      9    57 920716  6620       0 33638931 2.091045e+12  5081.410
#> 15     10   428 835766  6042       0 23293771 1.254846e+12  3855.308
#> # ... with 1 more variables: stddev <dbl>
#> 
#> $counter_total_all$journal
#> # A tibble: 9 x 9
#>   journal   min    max count missing       sum sumOfSquares      mean
#>     <chr> <dbl>  <dbl> <int>   <int>     <dbl>        <dbl>     <dbl>
#> 1       1  1226 195132  1249       0   8078256 1.904049e+11  6467.779
#> 2       2  9025  17316     2       0     26341 3.812945e+08 13170.500
#> 3       3   866 170954   273       0   5427002 2.692278e+11 19879.128
#> 4       4     0 344164  1015       0  18651466 9.333559e+11 18375.829
#> 5       5     0 835766 33795       0 155570717 4.795980e+12  4603.365
#> 6       6  1186 114833   739       0   6658316 1.139544e+11  9009.900
#> 7       7     0 133212   914       0   8657163 1.565039e+11  9471.732
#> 8       8     0 300246  1752       0   9288823 1.937582e+11  5301.840
#> 9       9     0 920716   758       0   6661955 9.510000e+11  8788.859
#> # ... with 1 more variables: stddev <dbl>
#> 
#> 
#> $alm_twitterCount
#> $alm_twitterCount$volume
#> # A tibble: 15 x 9
#>    volume   min   max count missing   sum sumOfSquares       mean
#>     <chr> <dbl> <dbl> <int>   <int> <dbl>        <dbl>      <dbl>
#>  1     11     0  2123  5228       0 51052     11012280   9.765111
#>  2     12     0  1621  4151       0 34339      9148615   8.272464
#>  3     13     0   557   317       0  9556      1498004  30.145110
#>  4     14     3   978    88       0 11286      3607818 128.250000
#>  5     15     0   444    65       0  4542       804654  69.876923
#>  6      1     0    46    81       0   199         6007   2.456790
#>  7      2     0   125   482       0  1069        60391   2.217842
#>  8      3     0   492   741       0  1345       258315   1.815115
#>  9      4     0   292  1010       0  1515       128111   1.500000
#> 10      5     0   160  1539       0  2564       133208   1.666017
#> 11      6     0   957  2948       0  5464      1558858   1.853460
#> 12      7     0   855  4825       0 21303      2341973   4.415130
#> 13      8     0  2028  6360       0 39472      9314728   6.206289
#> 14      9     0  1845  6620       0 54695     16505877   8.262085
#> 15     10     0  3401  6042       0 42727     16621967   7.071665
#> # ... with 1 more variables: stddev <dbl>
#> 
#> $alm_twitterCount$journal
#> # A tibble: 9 x 9
#>   journal   min   max count missing    sum sumOfSquares      mean
#>     <chr> <dbl> <dbl> <int>   <int>  <dbl>        <dbl>     <dbl>
#> 1       1     0   333  1249       0   7163       448465  5.734988
#> 2       2     0     3     2       0      3            9  1.500000
#> 3       3     0   819   273       0   5372      1172458 19.677656
#> 4       4     0  2123  1015       0  34626     13980034 34.114286
#> 5       5     0  3401 33795       0 198539     54213549  5.874804
#> 6       6     0   212   739       0   7415       326697 10.033829
#> 7       7     0   229   914       0   8049       391235  8.806346
#> 8       8     0   957  1752       0  10851      1508045  6.193493
#> 9       9     0   513   758       0   9110       960314 12.018470
#> # ... with 1 more variables: stddev <dbl>
```

## More like this

`solr_mlt` is a function to return similar documents to the one


```r
out <- conn$mlt(params = list(q = 'title:"ecology" AND body:"cell"', mlt.fl = 'title', mlt.mindf = 1, mlt.mintf = 1, fl = 'counter_total_all', rows = 5))
out$docs
#> # A tibble: 5 x 2
#>                             id counter_total_all
#>                          <chr>             <int>
#> 1 10.1371/journal.pbio.1001805             21824
#> 2 10.1371/journal.pbio.0020440             25424
#> 3 10.1371/journal.pbio.1002559              9746
#> 4 10.1371/journal.pone.0087217             11502
#> 5 10.1371/journal.pbio.1002191             22013
```


```r
out$mlt
#> $`10.1371/journal.pbio.1001805`
#> # A tibble: 5 x 4
#>   numFound start                           id counter_total_all
#>      <int> <int>                        <chr>             <int>
#> 1     3822     0 10.1371/journal.pone.0098876              3590
#> 2     3822     0 10.1371/journal.pone.0082578              2893
#> 3     3822     0 10.1371/journal.pone.0102159              2028
#> 4     3822     0 10.1371/journal.pcbi.1002652              3819
#> 5     3822     0 10.1371/journal.pcbi.1003408              9920
#> 
#> $`10.1371/journal.pbio.0020440`
#> # A tibble: 5 x 4
#>   numFound start                           id counter_total_all
#>      <int> <int>                        <chr>             <int>
#> 1     1115     0 10.1371/journal.pone.0162651              2828
#> 2     1115     0 10.1371/journal.pone.0003259              3225
#> 3     1115     0 10.1371/journal.pntd.0003377              4267
#> 4     1115     0 10.1371/journal.pone.0101568              4603
#> 5     1115     0 10.1371/journal.pone.0068814              9042
#> 
#> $`10.1371/journal.pbio.1002559`
#> # A tibble: 5 x 4
#>   numFound start                           id counter_total_all
#>      <int> <int>                        <chr>             <int>
#> 1     5482     0 10.1371/journal.pone.0155989              2519
#> 2     5482     0 10.1371/journal.pone.0023086              8442
#> 3     5482     0 10.1371/journal.pone.0155028              1547
#> 4     5482     0 10.1371/journal.pone.0041684             22057
#> 5     5482     0 10.1371/journal.pone.0164330               969
#> 
#> $`10.1371/journal.pone.0087217`
#> # A tibble: 5 x 4
#>   numFound start                           id counter_total_all
#>      <int> <int>                        <chr>             <int>
#> 1     4576     0 10.1371/journal.pone.0175497              1088
#> 2     4576     0 10.1371/journal.pone.0159131              4937
#> 3     4576     0 10.1371/journal.pcbi.0020092             24786
#> 4     4576     0 10.1371/journal.pone.0133941              1336
#> 5     4576     0 10.1371/journal.pone.0131665              1207
#> 
#> $`10.1371/journal.pbio.1002191`
#> # A tibble: 5 x 4
#>   numFound start                           id counter_total_all
#>      <int> <int>                        <chr>             <int>
#> 1    12585     0 10.1371/journal.pbio.1002232              3055
#> 2    12585     0 10.1371/journal.pone.0070448              2203
#> 3    12585     0 10.1371/journal.pone.0131700              2493
#> 4    12585     0 10.1371/journal.pone.0121680              4980
#> 5    12585     0 10.1371/journal.pone.0041534              5701
```

## Groups

`solr_groups()` is a function to return similar documents to the one


```r
conn$group(params = list(q = 'ecology', group.field = 'journal', group.limit = 1, fl = c('id', 'alm_twitterCount')))
#>                         groupValue numFound start
#> 1                         plos one    33795     0
#> 2       plos computational biology      758     0
#> 3                     plos biology     1015     0
#> 4 plos neglected tropical diseases     1752     0
#> 5                   plos pathogens      739     0
#> 6                    plos genetics      914     0
#> 7                             none     1249     0
#> 8                    plos medicine      273     0
#> 9             plos clinical trials        2     0
#>                             id alm_twitterCount
#> 1 10.1371/journal.pone.0001248                0
#> 2 10.1371/journal.pcbi.1003594               21
#> 3 10.1371/journal.pbio.0060300                0
#> 4 10.1371/journal.pntd.0004689               13
#> 5 10.1371/journal.ppat.1005780               19
#> 6 10.1371/journal.pgen.1005860              129
#> 7 10.1371/journal.pone.0043894                0
#> 8 10.1371/journal.pmed.1000303                1
#> 9 10.1371/journal.pctr.0020010                0
```

## Parsing

`solr_parse()` is a general purpose parser function with extension methods for parsing outputs from functions in `solr`. `solr_parse()` is used internally within functions to do parsing after retrieving data from the server. You can optionally get back raw `json`, `xml`, or `csv` with the `raw=TRUE`, and then parse afterwards with `solr_parse()`.

For example:


```r
(out <- conn$highlight(params = list(q = 'alcohol', hl.fl = 'abstract', rows = 2), raw = TRUE))
#> [1] "{\"response\":{\"numFound\":25987,\"start\":0,\"maxScore\":4.705177,\"docs\":[{\"id\":\"10.1371/journal.pone.0185457\",\"journal\":\"PLOS ONE\",\"eissn\":\"1932-6203\",\"publication_date\":\"2017-09-28T00:00:00Z\",\"article_type\":\"Research Article\",\"author_display\":[\"Jacqueline Willmore\",\"Terry-Lynne Marko\",\"Darcie Taing\",\"Hugues Sampasa-Kanyinga\"],\"abstract\":[\"Objectives: Alcohol-related morbidity and mortality are significant public health issues. The purpose of this study was to describe the prevalence and trends over time of alcohol consumption and alcohol-related morbidity and mortality; and public attitudes of alcohol use impacts on families and the community in Ottawa, Canada. Methods: Prevalence (2013–2014) and trends (2000–2001 to 2013–2014) of alcohol use were obtained from the Canadian Community Health Survey. Data on paramedic responses (2015), emergency department (ED) visits (2013–2015), hospitalizations (2013–2015) and deaths (2007–2011) were used to quantify the acute and chronic health effects of alcohol in Ottawa. Qualitative data were obtained from the “Have Your Say” alcohol survey, an online survey of public attitudes on alcohol conducted in 2016. Results: In 2013–2014, an estimated 595,300 (83%) Ottawa adults 19 years and older drank alcohol, 42% reported binge drinking in the past year. Heavy drinking increased from 15% in 2000–2001 to 20% in 2013–2014. In 2015, the Ottawa Paramedic Service responded to 2,060 calls directly attributable to alcohol. Between 2013 and 2015, there were an average of 6,100 ED visits and 1,270 hospitalizations per year due to alcohol. Annually, alcohol use results in at least 140 deaths in Ottawa. Men have higher rates of alcohol-attributable paramedic responses, ED visits, hospitalizations and deaths than women, and young adults have higher rates of alcohol-attributable paramedic responses. Qualitative data of public attitudes indicate that alcohol misuse has greater repercussions not only on those who drink, but also on the family and community. Conclusions: Results highlight the need for healthy public policy intended to encourage a culture of drinking in moderation in Ottawa to support lower risk alcohol use, particularly among men and young adults. \"],\"title_display\":\"The burden of alcohol-related morbidity and mortality in Ottawa, Canada\",\"score\":4.705177},{\"id\":\"10.1371/journal.pone.0071284\",\"journal\":\"PLoS ONE\",\"eissn\":\"1932-6203\",\"publication_date\":\"2013-08-20T00:00:00Z\",\"article_type\":\"Research Article\",\"author_display\":[\"Petra Suchankova\",\"Pia Steensland\",\"Ida Fredriksson\",\"Jörgen A. Engel\",\"Elisabet Jerlhag\"],\"abstract\":[\"\\nAlcohol dependence is a heterogeneous disorder where several signalling systems play important roles. Recent studies implicate that the gut-brain hormone ghrelin, an orexigenic peptide, is a potential mediator of alcohol related behaviours. Ghrelin increases whereas a ghrelin receptor (GHS-R1A) antagonist decreases alcohol consumption as well as operant self-administration of alcohol in rodents that have consumed alcohol for twelve weeks. In the present study we aimed at investigating the effect of acute and repeated treatment with the GHS-R1A antagonist JMV2959 on alcohol intake in a group of rats following voluntarily alcohol consumption for two, five and eight months. After approximately ten months of voluntary alcohol consumption the expression of the GHS-R1A gene (Ghsr) as well as the degree of methylation of a CpG island found in Ghsr was examined in reward related brain areas. In a separate group of rats, we examined the effect of the JMV2959 on alcohol relapse using the alcohol deprivation paradigm. Acute JMV2959 treatment was found to decrease alcohol intake and the effect was more pronounced after five, compared to two months of alcohol exposure. In addition, repeated JMV2959 treatment decreased alcohol intake without inducing tolerance or rebound increase in alcohol intake after the treatment. The GHS-R1A antagonist prevented the alcohol deprivation effect in rats. There was a significant down-regulation of the Ghsr expression in the ventral tegmental area (VTA) in high- compared to low-alcohol consuming rats after approximately ten months of voluntary alcohol consumption. Further analysis revealed a negative correlation between Ghsr expression in the VTA and alcohol intake. No differences in methylation degree were found between high- compared to low-alcohol consuming rats. These findings support previous studies showing that the ghrelin signalling system may constitute a potential target for development of novel treatment strategies for alcohol dependence.\\n\"],\"title_display\":\"Ghrelin Receptor (GHS-R1A) Antagonism Suppresses Both Alcohol Consumption and the Alcohol Deprivation Effect in Rats following Long-Term Voluntary Alcohol Consumption\",\"score\":4.7050986}]},\"highlighting\":{\"10.1371/journal.pone.0185457\":{\"abstract\":[\"Objectives: <em>Alcohol</em>-related morbidity and mortality are significant public health issues\"]},\"10.1371/journal.pone.0071284\":{\"abstract\":[\"\\n<em>Alcohol</em> dependence is a heterogeneous disorder where several signalling systems play important\"]}}}\n"
#> attr(,"class")
#> [1] "sr_high"
#> attr(,"wt")
#> [1] "json"
```

Then parse


```r
solr_parse(out, 'df')
#> # A tibble: 2 x 2
#>                          names
#>                          <chr>
#> 1 10.1371/journal.pone.0185457
#> 2 10.1371/journal.pone.0071284
#> # ... with 1 more variables: abstract <chr>
```

[Please report any issues or bugs](https://github.com/ropensci/solrium/issues).
