<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{solr vignette}
-->

solr vignette
======

**A general purpose R interface to [Solr](http://lucene.apache.org/solr/)**

This package only deals with extracting data from a Solr endpoint, not writing data (pull request or holla if you're interested in writing solr data).

### Solr info

+ [Solr home page](http://lucene.apache.org/solr/)
+ [Highlighting help](http://wiki.apache.org/solr/HighlightingParameters)
+ [Faceting help](http://wiki.apache.org/solr/SimpleFacetParameters)
+ [Installing Solr on Mac using homebrew](http://ramlev.dk/blog/2012/06/02/install-apache-solr-on-your-mac/)
+ [Install and Setup SOLR in OSX, including running Solr](http://risnandar.wordpress.com/2013/09/08/how-to-install-and-setup-apache-lucene-solr-in-osx/)

### Quick start

**Install**

Install dependencies


```r
install.packages(c("rjson","plyr","httr","XML","assertthat"))
```

Install solr


```r
install.packages("devtools")
library(devtools)
install_github("ropensci/solr")
```


```r
library(solr)
```

**Define stuff** Your base url and a key (if needed). This example should work. You do need to pass a key to the Public Library of Science search API, but it apparently doesn't need to be a real one.


```r
url <- 'http://api.plos.org/search'
key <- 'key'
```

**Search**


```r
solr_search(q='*:*', rows=2, fl='id', base=url, key=key)
```

```
## http://api.plos.org/search?q=*:*&rows=2&fl=id&wt=json
```

```
##                                                              id
## 1       10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4
## 2 10.1371/annotation/856f0890-9d85-4719-8e54-c27530ac94f4/title
```

**Facet**


```r
solr_facet(q='*:*', facet.field='journal', facet.query=c('cell','bird'), base=url, key=key)
```

```
## http://api.plos.org/search?q=*:*&facet.query=cell&facet.query=bird&facet.field=journal&key=key&wt=json&fl=DOES_NOT_EXIST&facet=true
```

```
## $facet_queries
##   term  value
## 1 cell 107110
## 2 bird  10737
## 
## $facet_fields
## $facet_fields$journal
##                                  X1     X2
## 1                          plos one 976664
## 2                     plos genetics  42509
## 3                    plos pathogens  37019
## 4        plos computational biology  31041
## 5  plos neglected tropical diseases  26926
## 6                      plos biology  26749
## 7                     plos medicine  18800
## 8              plos clinical trials    521
## 9                      plos medicin      9
## 10                 plos collections      5
## 
## 
## $facet_dates
## NULL
## 
## $facet_ranges
## NULL
```

**Highlight**


```r
solr_highlight(q='alcohol', hl.fl = 'abstract', rows=2, base = url, key=key)
```

```
## http://api.plos.org/search?wt=json&q=alcohol&start=0&rows=2&hl=true&fl=DOES_NOT_EXIST&hl.fl=abstract
```

```
## $`10.1371/journal.pmed.0040151`
## $`10.1371/journal.pmed.0040151`$abstract
## [1] "Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting"
## 
## 
## $`10.1371/journal.pone.0027752`
## $`10.1371/journal.pone.0027752`$abstract
## [1] "Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking"
```

**Stats**


```r
out <- solr_stats(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), stats.facet=c('journal','volume'), base=url, key=key)
```

```
## http://api.plos.org/search?q=ecology&stats.field=counter_total_all&stats.field=alm_twitterCount&stats.facet=journal&stats.facet=volume&start=0&rows=0&key=key&wt=json&stats=true
```


```r
out$data
```

```
##                   min    max count missing      sum sumOfSquares
## counter_total_all   0 321893 25467       0 96774010 1.870367e+12
## alm_twitterCount    0   1669 25467       0   124059 2.230500e+07
##                          mean     stddev
## counter_total_all 3799.976833 7681.48772
## alm_twitterCount     4.871363   29.19148
```


```r
out$facet
```

```
## $counter_total_all
## $counter_total_all$journal
##    min    max count missing      sum sumOfSquares      mean    stddev
## 1  291  46999   508       0  3355085 3.658732e+10  6604.498  5334.689
## 2    0  52927   661       0  4689480 5.503211e+10  7094.523  5742.252
## 3    0 321893 20533       0 62841527 1.123853e+12  3060.514  6735.686
## 4 5963  10361     2       0    16324 1.429077e+08  8162.000  3109.856
## 5  553 162541   469       0  3010961 6.145344e+10  6419.959  9487.192
## 6  562  98828   230       0  3092997 8.506865e+10 13447.813 13778.441
## 7  433 222483   824       0 11188574 3.559376e+11 13578.367 15744.582
## 8  154 184710   989       0  3909643 5.968779e+10  3953.127  6691.017
##                        facet_field
## 1                   plos pathogens
## 2                    plos genetics
## 3                         plos one
## 4             plos clinical trials
## 5       plos computational biology
## 6                    plos medicine
## 7                     plos biology
## 8 plos neglected tropical diseases
## 
## $counter_total_all$volume
##     min    max count missing      sum sumOfSquares      mean    stddev
## 1  1015 119973   741       0  6002232 126045584784  8100.178 10228.896
## 2  1307  98828   482       0  4587872 104045273408  9518.407 11203.656
## 3     0  93599   864       0  2807670  48317888956  3249.618  6739.142
## 4  1480 132738    81       0  1202447  48380022503 14845.025 19535.118
## 5     0 182288  4825       0 17971599 266966854903  3724.684  6439.351
## 6     0 204441  2948       0 13265425 208987077509  4499.805  7117.589
## 7     0  80394  1539       0  9180495 129943033321  5965.234  6991.507
## 8   562 321893  1010       0  7536947 243059200941  7462.324 13606.973
## 9     0 222483  6411       0 13138681 302281193255  2049.397  6554.164
## 10    0 301443  6360       0 18856916 331240574436  2964.924  6580.113
## 11  433  27163    15       0   244842   4748571900 16322.800  7329.319
## 12    0 140903   126       0  1242452  43046879826  9860.730 15695.960
## 13 1695  66819    65       0   736432  13304629696 11329.723  8804.348
##    facet_field
## 1            3
## 2            2
## 3           10
## 4            1
## 5            7
## 6            6
## 7            5
## 8            4
## 9            9
## 10           8
## 11          13
## 12          11
## 13          12
## 
## 
## $alm_twitterCount
## $alm_twitterCount$journal
##   min  max count missing   sum sumOfSquares      mean   stddev
## 1   0   93   508       0  2742        86612  5.397638 11.90128
## 2   0  164   661       0  3259       108547  4.930408 11.83720
## 3   0 1357 20533       0 89710     15088944  4.369064 26.75461
## 4   0    3     2       0     3            9  1.500000  2.12132
## 5   0  142   469       0  2499       114813  5.328358 14.72667
## 6   0  619   230       0  3570       755676 15.521739 55.29845
## 7   0 1669   824       0 11881      4836811 14.418689 75.29208
## 8   0  859   989       0  3697       910593  3.738119 30.12748
##                        facet_field
## 1                   plos pathogens
## 2                    plos genetics
## 3                         plos one
## 4             plos clinical trials
## 5       plos computational biology
## 6                    plos medicine
## 7                     plos biology
## 8 plos neglected tropical diseases
## 
## $alm_twitterCount$volume
##    min  max count missing   sum sumOfSquares       mean     stddev
## 1    0   46   741       0   531         7299  0.7165992   3.057663
## 2    0   70   482       0   473        11457  0.9813278   4.780598
## 3    0  619   864       0  7639       819955  8.8414352  29.527277
## 4    0   41    81       0   154         3760  1.9012346   6.583322
## 5    0  811  4825       0 18745      1916585  3.8849741  19.550086
## 6    0  859  2948       0  3826      1049432  1.2978290  18.825963
## 7    0  112  1539       0  1575        67195  1.0233918   6.530072
## 8    0  197  1010       0   817        51519  0.8089109   7.099611
## 9    0 1357  6411       0 44725      8506155  6.9762908  35.753839
## 10   0 1184  6360       0 33871      4952819  5.3256289  27.395270
## 11   0   87    15       0   189        11635 12.6000000  25.709365
## 12   0 1669   126       0  6003      3378665 47.6428571 157.293736
## 13   0  920    65       0  5511      1528519 84.7846154 128.772509
##    facet_field
## 1            3
## 2            2
## 3           10
## 4            1
## 5            7
## 6            6
## 7            5
## 8            4
## 9            9
## 10           8
## 11          13
## 12          11
## 13          12
```

**More like this**

`solr_mlt` is a function to return similar documents to the one 


```r
out <- solr_mlt(q='title:"ecology" AND body:"cell"', mlt.fl='title', mlt.mindf=1, mlt.mintf=1, fl='counter_total_all', rows=5, base=url, key=key)
```

```
## http://api.plos.org/search?q=title:"ecology" AND body:"cell"&mlt=true&fl=id,counter_total_all&mlt.fl=title&mlt.mintf=1&mlt.mindf=1&start=0&rows=5&wt=json
```

```r
out$docs
```

```
##                             id counter_total_all
## 1 10.1371/journal.pbio.1001805             11140
## 2 10.1371/journal.pbio.0020440             16782
## 3 10.1371/journal.pone.0087217              3413
## 4 10.1371/journal.pone.0040117              2758
## 5 10.1371/journal.pone.0072525              1189
```


```r
out$mlt
```

```
## $`10.1371/journal.pbio.1001805`
##                             id counter_total_all
## 1 10.1371/journal.pone.0082578              1594
## 2 10.1371/journal.pone.0098876               941
## 3 10.1371/journal.pone.0102159               570
## 4 10.1371/journal.pone.0076063              2183
## 5 10.1371/journal.pcbi.1003408              4655
## 
## $`10.1371/journal.pbio.0020440`
##                             id counter_total_all
## 1 10.1371/journal.pone.0035964              3723
## 2 10.1371/journal.pone.0102679              1996
## 3 10.1371/journal.pone.0003259              1869
## 4 10.1371/journal.pone.0068814              6453
## 5 10.1371/journal.pntd.0003377              2582
## 
## $`10.1371/journal.pone.0087217`
##                             id counter_total_all
## 1 10.1371/journal.pcbi.0020092             15581
## 2 10.1371/journal.pone.0063375              1491
## 3 10.1371/journal.pone.0015143             13449
## 4 10.1371/journal.pone.0034096              2566
## 5 10.1371/journal.pcbi.1000986              2878
## 
## $`10.1371/journal.pone.0040117`
##                             id counter_total_all
## 1 10.1371/journal.pone.0069352              1754
## 2 10.1371/journal.pone.0035502              2748
## 3 10.1371/journal.pone.0014065              4151
## 4 10.1371/journal.pone.0113280              1007
## 5 10.1371/journal.pone.0078369              2373
## 
## $`10.1371/journal.pone.0072525`
##                             id counter_total_all
## 1 10.1371/journal.pone.0060766              1630
## 2 10.1371/journal.pcbi.1002928              7708
## 3 10.1371/journal.pone.0068714              4411
## 4 10.1371/journal.pone.0072862              3319
## 5 10.1371/journal.pcbi.1000350              9019
```

**Parsing**

`solr_parse` is a general purpose parser function with extension methods `solr_parse.sr_search`, `solr_parse.sr_facet`, and `solr_parse.sr_high`, for parsing `solr_search`, `solr_facet`, and `solr_highlight` function output, respectively. `solr_parse` is used internally within those three functions (`solr_search`, `solr_facet`, `solr_highlight`) to do parsing. You can optionally get back raw `json` or `xml` from `solr_search`, `solr_facet`, and `solr_highlight` setting parameter `raw=TRUE`, and then parsing after the fact with `solr_parse`. All you need to know is `solr_parse` can parse 

For example:


```r
(out <- solr_highlight(q='alcohol', hl.fl = 'abstract', rows=2, base = url, key=key, raw=TRUE))
```

```
## http://api.plos.org/search?wt=json&q=alcohol&start=0&rows=2&hl=true&fl=DOES_NOT_EXIST&hl.fl=abstract
```

```
## [1] "{\"response\":{\"numFound\":16075,\"start\":0,\"docs\":[{},{}]},\"highlighting\":{\"10.1371/journal.pmed.0040151\":{\"abstract\":[\"Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting\"]},\"10.1371/journal.pone.0027752\":{\"abstract\":[\"Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking\"]}}}\n"
## attr(,"class")
## [1] "sr_high"
## attr(,"wt")
## [1] "json"
```

Then parse


```r
solr_parse(out, 'df')
```

```
##                          names
## 1 10.1371/journal.pmed.0040151
## 2 10.1371/journal.pone.0027752
##                                                                                                    abstract
## 1   Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting
## 2 Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking
```

**Using specific data sources**

*USGS BISON service*

The occurrences service


```r
url2 <- "http://bison.usgs.ornl.gov/solrstaging/occurrences/select"
solr_search(q='*:*', fl=c('decimalLatitude','decimalLongitude','scientificName'), base=url2)
```

```
## http://bison.usgs.ornl.gov/solrstaging/occurrences/select?q=*:*&fl=decimalLatitude,decimalLongitude,scientificName&wt=json
```

```
##    decimalLongitude decimalLatitude        scientificName
## 1         -76.66100        34.72440     Corvus ossifragus
## 2         -76.66100        34.72440 Leucophaeus atricilla
## 3         -76.66100        34.72440   Cyanocitta cristata
## 4         -76.66100        34.72440     Passer domesticus
## 5         -76.66100        34.72440       Sterna forsteri
## 6         -76.66100        34.72440   Sternula antillarum
## 7         -76.66100        34.72440 Streptopelia decaocto
## 8         -76.66100        34.72440      Zenaida macroura
## 9         -76.65791        34.72442   Ophidion marginatum
## 10        -76.65791        34.72442   Hypsoblennius hentz
```

*PLOS Search API*

Most of the examples above use the PLOS search API... :)


[Please report any issues or bugs](https://github.com/ropensci/solr/issues).
