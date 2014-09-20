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
## http://api.plos.org/search?q=*:*&rows=2&wt=json&fl=id
```

```
##                                   id
## 1       10.1371/journal.pone.0067462
## 2 10.1371/journal.pone.0067462/title
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
##   term value
## 1 cell 98474
## 2 bird  9884
## 
## $facet_fields
## $facet_fields$journal
##                                  X1     X2
## 1                          plos one 882064
## 2                     plos genetics  39058
## 3                    plos pathogens  34452
## 4        plos computational biology  28934
## 5                      plos biology  25764
## 6  plos neglected tropical diseases  23765
## 7                     plos medicine  18180
## 8              plos clinical trials    521
## 9                  plos collections     10
## 10                     plos medicin      9
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
##                   min    max count missing      sum sumOfSquares mean
## counter_total_all   0 309638 23113       0 81884468    1.489e+12 3543
## alm_twitterCount    0      0 23113       0        0    0.000e+00    0
##                   stddev
## counter_total_all   7203
## alm_twitterCount       0
```


```r
out$facet
```

```
## $counter_total_all
## $counter_total_all$journal
##    min    max count missing      sum sumOfSquares  mean stddev
## 1    0      0     1       0        0    0.000e+00     0      0
## 2    0  42773   474       0  2885195    2.830e+10  6087   4766
## 3    0  47925   612       0  4090571    4.379e+10  6684   5188
## 4    0 309638 18452       0 52363620    8.907e+11  2838   6342
## 5 5505   9690     2       0    15195    1.242e+08  7598   2959
## 6  547  91978   225       0  2732864    6.812e+10 12146  12486
## 7  576 198640   794       0  9913287    2.854e+11 12485  14274
## 8    0 116988   436       0  2582299    4.153e+10  5923   7766
## 9    0 175006   866       0  3150653    4.917e+10  3638   6602
##                        facet_field
## 1                 plos collections
## 2                   plos pathogens
## 3                    plos genetics
## 4                         plos one
## 5             plos clinical trials
## 6                    plos medicine
## 7                     plos biology
## 8       plos computational biology
## 9 plos neglected tropical diseases
## 
## $counter_total_all$volume
##     min    max count missing      sum sumOfSquares  mean stddev
## 1   954 111543   741       0  5619619    1.088e+11  7584   9455
## 2  1233  91978   482       0  4334710    9.231e+10  8993  10529
## 3     0 121127    82       0  1147071    4.262e+10 13989  18112
## 4     0  88678   295       0  1796960    3.449e+10  6091   8948
## 5     0 180861  4825       0 15945062    2.293e+11  3305   6051
## 6     0 185873  2948       0 12035676    1.745e+11  4083   6523
## 7     0  77788  1539       0  8464255    1.100e+11  5500   6424
## 8   547 309638  1010       0  7041915    2.168e+11  6972  12892
## 9     0 198640  4782       0  8438481    1.971e+11  1765   6173
## 10    0 251648  6284       0 15730408    2.514e+11  2503   5809
## 11  729  92764    78       0   949374    2.570e+10 12171  13552
## 12  576  55617    47       0   380937    6.072e+09  8105   8055
##    facet_field
## 1            3
## 2            2
## 3            1
## 4           10
## 5            7
## 6            6
## 7            5
## 8            4
## 9            9
## 10           8
## 11          11
## 12          12
## 
## 
## $alm_twitterCount
## $alm_twitterCount$journal
##   min max count missing sum sumOfSquares mean stddev
## 1   0   0     1       0   0            0    0      0
## 2   0   0   474       0   0            0    0      0
## 3   0   0   612       0   0            0    0      0
## 4   0   0 18452       0   0            0    0      0
## 5   0   0     2       0   0            0    0      0
## 6   0   0   225       0   0            0    0      0
## 7   0   0   794       0   0            0    0      0
## 8   0   0   436       0   0            0    0      0
## 9   0   0   866       0   0            0    0      0
##                        facet_field
## 1                 plos collections
## 2                   plos pathogens
## 3                    plos genetics
## 4                         plos one
## 5             plos clinical trials
## 6                    plos medicine
## 7                     plos biology
## 8       plos computational biology
## 9 plos neglected tropical diseases
## 
## $alm_twitterCount$volume
##    min max count missing sum sumOfSquares mean stddev facet_field
## 1    0   0   741       0   0            0    0      0           3
## 2    0   0   482       0   0            0    0      0           2
## 3    0   0    82       0   0            0    0      0           1
## 4    0   0   295       0   0            0    0      0          10
## 5    0   0  4825       0   0            0    0      0           7
## 6    0   0  2948       0   0            0    0      0           6
## 7    0   0  1539       0   0            0    0      0           5
## 8    0   0  1010       0   0            0    0      0           4
## 9    0   0  4782       0   0            0    0      0           9
## 10   0   0  6284       0   0            0    0      0           8
## 11   0   0    78       0   0            0    0      0          11
## 12   0   0    47       0   0            0    0      0          12
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
## 1 10.1371/journal.pbio.1001805              9414
## 2 10.1371/journal.pbio.0020440             16445
## 3 10.1371/journal.pone.0087217              2512
## 4 10.1371/journal.pone.0040117              2324
## 5 10.1371/journal.pone.0072525               999
```


```r
out$mlt
```

```
## $`10.1371/journal.pbio.1001805`
##                             id counter_total_all
## 1 10.1371/journal.pone.0082578              1177
## 2 10.1371/journal.pone.0098876               735
## 3 10.1371/journal.pone.0102159               318
## 4 10.1371/journal.pone.0076063              1883
## 5 10.1371/journal.pone.0087380               776
## 
## $`10.1371/journal.pbio.0020440`
##                             id counter_total_all
## 1 10.1371/journal.pone.0035964              3203
## 2 10.1371/journal.pone.0102679              1242
## 3 10.1371/journal.pone.0003259              1785
## 4 10.1371/journal.pone.0101568              1058
## 5 10.1371/journal.pone.0068814              5497
## 
## $`10.1371/journal.pone.0087217`
##                             id counter_total_all
## 1 10.1371/journal.pcbi.0020092             14412
## 2 10.1371/journal.pone.0063375              1279
## 3 10.1371/journal.pcbi.1000986              2757
## 4 10.1371/journal.pone.0034096              2310
## 5 10.1371/journal.pone.0015143             12424
## 
## $`10.1371/journal.pone.0040117`
##                                                        id
## 1                            10.1371/journal.pone.0069352
## 2                            10.1371/journal.pone.0035502
## 3                            10.1371/journal.pone.0014065
## 4                            10.1371/journal.pone.0078369
## 5 10.1371/annotation/8b818c15-3fe0-4e56-9be2-e44fd1ed3fae
##   counter_total_all
## 1              1501
## 2              2516
## 3              3832
## 4              1955
## 5                 0
## 
## $`10.1371/journal.pone.0072525`
##                             id counter_total_all
## 1 10.1371/journal.pone.0060766              1308
## 2 10.1371/journal.pcbi.1002928              7066
## 3 10.1371/journal.pcbi.1000350              8615
## 4 10.1371/journal.pcbi.0020144             12517
## 5 10.1371/journal.pone.0068714              3338
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
## [1] "{\"response\":{\"numFound\":14529,\"start\":0,\"docs\":[{},{}]},\"highlighting\":{\"10.1371/journal.pmed.0040151\":{\"abstract\":[\"Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting\"]},\"10.1371/journal.pone.0027752\":{\"abstract\":[\"Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking\"]}}}\n"
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
url2 <- "http://bisonapi.usgs.ornl.gov/solr/occurrences/select"
solr_search(q='*:*', fl=c('latitude','longitude','scientific_name'), base=url2)
```

```
## http://bisonapi.usgs.ornl.gov/solr/occurrences/select?q=*:*&wt=json&fl=latitude&fl=longitude&fl=scientific_name
```

```
## data frame with 0 columns and 0 rows
```

The species names service


```r
solr_search(q='*:*', base=url2, raw=TRUE)
```

```
## http://bisonapi.usgs.ornl.gov/solr/occurrences/select?q=*:*&wt=json
```

```
## [1] "{\"responseHeader\":{\"status\":0,\"QTime\":2782},\"response\":{\"numFound\":168063755,\"start\":0,\"docs\":[{\"computedCountyFips\":\"16027\",\"providerID\":602,\"catalogNumber\":\"OBS101299944\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Ardea herodias\",\"latlon\":\"-116.55315,43.53494\",\"calculatedState\":\"Idaho\",\"decimalLongitude\":-116.55315,\"year\":2010,\"ITIStsn\":\"174773\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-174670-174771-823967-174772-174773-\",\"TSNs\":[\"174773\"],\"calculatedCounty\":\"Canyon County\",\"pointPath\":\"/-116.55315,43.53494/observation\",\"computedStateFips\":\"16\",\"providedCounty\":\"Canyon\",\"kingdom\":\"Animalia\",\"decimalLatitude\":43.53494,\"occurrenceID\":\"576630651\",\"providedScientificName\":\"Ardea herodias Linnaeus, 1758\",\"eventDate\":\"2010-11-13T00:00Z\",\"ownerInstitutionCollectionCode\":\"eBird\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Idaho\",\"ITIScommonName\":\"Garza morena;Grand Héron;Great Blue Heron\",\"scientificName\":\"Ardea herodias\",\"institutionID\":\"http://www.birds.cornell.edu\",\"_version_\":1478443095511007236},{\"computedCountyFips\":\"20163\",\"providerID\":602,\"catalogNumber\":\"OBS153056407\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Ardea herodias\",\"latlon\":\"-99.31812,39.3988\",\"calculatedState\":\"Kansas\",\"decimalLongitude\":-99.31812,\"year\":2012,\"ITIStsn\":\"174773\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-174670-174771-823967-174772-174773-\",\"TSNs\":[\"174773\"],\"calculatedCounty\":\"Rooks County\",\"pointPath\":\"/-99.31812,39.3988/observation\",\"computedStateFips\":\"20\",\"providedCounty\":\"Rooks\",\"kingdom\":\"Animalia\",\"decimalLatitude\":39.3988,\"occurrenceID\":\"820777443\",\"providedScientificName\":\"Ardea herodias Linnaeus, 1758\",\"eventDate\":\"2012-05-15T00:00Z\",\"ownerInstitutionCollectionCode\":\"eBird\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Kansas\",\"ITIScommonName\":\"Garza morena;Grand Héron;Great Blue Heron\",\"scientificName\":\"Ardea herodias\",\"institutionID\":\"http://www.birds.cornell.edu\",\"_version_\":1478443095512055808},{\"computedCountyFips\":\"39095\",\"providerID\":602,\"catalogNumber\":\"OBS89980032\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Ardea herodias\",\"latlon\":\"-83.23742,41.64981\",\"calculatedState\":\"Ohio\",\"decimalLongitude\":-83.23742,\"year\":2010,\"ITIStsn\":\"174773\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-174670-174771-823967-174772-174773-\",\"TSNs\":[\"174773\"],\"calculatedCounty\":\"Lucas County\",\"pointPath\":\"/-83.23742,41.64981/observation\",\"computedStateFips\":\"39\",\"providedCounty\":\"Lucas\",\"kingdom\":\"Animalia\",\"decimalLatitude\":41.64981,\"occurrenceID\":\"273879609\",\"providedScientificName\":\"Ardea herodias Linnaeus, 1758\",\"eventDate\":\"2010-04-17T00:00Z\",\"ownerInstitutionCollectionCode\":\"eBird\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Ohio\",\"ITIScommonName\":\"Garza morena;Grand Héron;Great Blue Heron\",\"scientificName\":\"Ardea herodias\",\"institutionID\":\"http://www.birds.cornell.edu\",\"_version_\":1478443095512055809},{\"computedCountyFips\":\"24005\",\"providerID\":602,\"catalogNumber\":\"OBS52292507\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Ardea herodias\",\"latlon\":\"-76.36528,39.24874\",\"calculatedState\":\"Maryland\",\"decimalLongitude\":-76.36528,\"year\":1983,\"ITIStsn\":\"174773\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-174670-174771-823967-174772-174773-\",\"TSNs\":[\"174773\"],\"calculatedCounty\":\"Baltimore County\",\"pointPath\":\"/-76.36528,39.24874/observation\",\"computedStateFips\":\"24\",\"providedCounty\":\"Baltimore\",\"kingdom\":\"Animalia\",\"decimalLatitude\":39.24874,\"occurrenceID\":\"575555258\",\"providedScientificName\":\"Ardea herodias Linnaeus, 1758\",\"eventDate\":\"1983-09-05T00:00Z\",\"ownerInstitutionCollectionCode\":\"eBird\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Maryland\",\"ITIScommonName\":\"Garza morena;Grand Héron;Great Blue Heron\",\"scientificName\":\"Ardea herodias\",\"institutionID\":\"http://www.birds.cornell.edu\",\"_version_\":1478443095512055810},{\"computedCountyFips\":\"39093\",\"providerID\":602,\"catalogNumber\":\"OBS76741209\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Ardea herodias\",\"latlon\":\"-82.04889,41.39448\",\"calculatedState\":\"Ohio\",\"decimalLongitude\":-82.04889,\"year\":2008,\"ITIStsn\":\"174773\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-174670-174771-823967-174772-174773-\",\"TSNs\":[\"174773\"],\"calculatedCounty\":\"Lorain County\",\"pointPath\":\"/-82.04889,41.39448/observation\",\"computedStateFips\":\"39\",\"providedCounty\":\"Lorain\",\"kingdom\":\"Animalia\",\"decimalLatitude\":41.39448,\"occurrenceID\":\"272999782\",\"providedScientificName\":\"Ardea herodias Linnaeus, 1758\",\"eventDate\":\"2008-08-30T00:00Z\",\"ownerInstitutionCollectionCode\":\"eBird\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Ohio\",\"ITIScommonName\":\"Garza morena;Grand Héron;Great Blue Heron\",\"scientificName\":\"Ardea herodias\",\"institutionID\":\"http://www.birds.cornell.edu\",\"_version_\":1478443095513104384},{\"computedCountyFips\":\"42069\",\"providerID\":602,\"catalogNumber\":\"OBS96855953\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Ardea herodias\",\"latlon\":\"-75.73191,41.48545\",\"calculatedState\":\"Pennsylvania\",\"decimalLongitude\":-75.73191,\"year\":2010,\"ITIStsn\":\"174773\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-174670-174771-823967-174772-174773-\",\"TSNs\":[\"174773\"],\"calculatedCounty\":\"Lackawanna County\",\"pointPath\":\"/-75.73191,41.48545/observation\",\"computedStateFips\":\"42\",\"providedCounty\":\"Lackawanna\",\"kingdom\":\"Animalia\",\"decimalLatitude\":41.48545,\"occurrenceID\":\"576920771\",\"providedScientificName\":\"Ardea herodias Linnaeus, 1758\",\"eventDate\":\"2010-08-14T00:00Z\",\"ownerInstitutionCollectionCode\":\"eBird\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Pennsylvania\",\"ITIScommonName\":\"Garza morena;Grand Héron;Great Blue Heron\",\"scientificName\":\"Ardea herodias\",\"institutionID\":\"http://www.birds.cornell.edu\",\"_version_\":1478443095513104385},{\"computedCountyFips\":\"48363\",\"providerID\":602,\"catalogNumber\":\"OBS168043612\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Ardea herodias\",\"latlon\":\"-98.36886,32.63366\",\"calculatedState\":\"Texas\",\"decimalLongitude\":-98.36886,\"year\":2012,\"ITIStsn\":\"174773\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-174670-174771-823967-174772-174773-\",\"TSNs\":[\"174773\"],\"calculatedCounty\":\"Palo Pinto County\",\"pointPath\":\"/-98.36886,32.63366/observation\",\"computedStateFips\":\"48\",\"providedCounty\":\"Palo Pinto\",\"kingdom\":\"Animalia\",\"decimalLatitude\":32.63366,\"occurrenceID\":\"820788710\",\"providedScientificName\":\"Ardea herodias Linnaeus, 1758\",\"eventDate\":\"2012-10-30T00:00Z\",\"ownerInstitutionCollectionCode\":\"eBird\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Texas\",\"ITIScommonName\":\"Garza morena;Grand Héron;Great Blue Heron\",\"scientificName\":\"Ardea herodias\",\"institutionID\":\"http://www.birds.cornell.edu\",\"_version_\":1478443095513104386},{\"computedCountyFips\":\"17031\",\"providerID\":602,\"catalogNumber\":\"OBS70671059\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Ardea herodias\",\"latlon\":\"-87.75948,41.53685\",\"calculatedState\":\"Illinois\",\"decimalLongitude\":-87.75948,\"year\":2009,\"ITIStsn\":\"174773\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-174670-174771-823967-174772-174773-\",\"TSNs\":[\"174773\"],\"calculatedCounty\":\"Cook County\",\"pointPath\":\"/-87.75948,41.53685/observation\",\"computedStateFips\":\"17\",\"providedCounty\":\"Cook\",\"kingdom\":\"Animalia\",\"decimalLatitude\":41.53685,\"occurrenceID\":\"273716486\",\"providedScientificName\":\"Ardea herodias Linnaeus, 1758\",\"eventDate\":\"2009-05-21T00:00Z\",\"ownerInstitutionCollectionCode\":\"eBird\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Illinois\",\"ITIScommonName\":\"Garza morena;Grand Héron;Great Blue Heron\",\"scientificName\":\"Ardea herodias\",\"institutionID\":\"http://www.birds.cornell.edu\",\"_version_\":1478443095513104387},{\"computedCountyFips\":\"20117\",\"providerID\":602,\"catalogNumber\":\"OBS95755244\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Ardea herodias\",\"latlon\":\"-96.59008,39.65117\",\"calculatedState\":\"Kansas\",\"decimalLongitude\":-96.59008,\"year\":2008,\"ITIStsn\":\"174773\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-174670-174771-823967-174772-174773-\",\"TSNs\":[\"174773\"],\"calculatedCounty\":\"Marshall County\",\"pointPath\":\"/-96.59008,39.65117/observation\",\"computedStateFips\":\"20\",\"providedCounty\":\"Marshall\",\"kingdom\":\"Animalia\",\"decimalLatitude\":39.65117,\"occurrenceID\":\"576012967\",\"providedScientificName\":\"Ardea herodias Linnaeus, 1758\",\"eventDate\":\"2008-08-03T00:00Z\",\"ownerInstitutionCollectionCode\":\"eBird\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Kansas\",\"ITIScommonName\":\"Garza morena;Grand Héron;Great Blue Heron\",\"scientificName\":\"Ardea herodias\",\"institutionID\":\"http://www.birds.cornell.edu\",\"_version_\":1478443095513104388},{\"computedCountyFips\":\"17031\",\"providerID\":602,\"catalogNumber\":\"OBS74126241\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Ardea herodias\",\"latlon\":\"-87.60807,41.66977\",\"calculatedState\":\"Illinois\",\"decimalLongitude\":-87.60807,\"year\":2009,\"ITIStsn\":\"174773\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-174670-174771-823967-174772-174773-\",\"TSNs\":[\"174773\"],\"calculatedCounty\":\"Cook County\",\"pointPath\":\"/-87.60807,41.66977/observation\",\"computedStateFips\":\"17\",\"providedCounty\":\"Cook\",\"kingdom\":\"Animalia\",\"decimalLatitude\":41.66977,\"occurrenceID\":\"270910937\",\"providedScientificName\":\"Ardea herodias Linnaeus, 1758\",\"eventDate\":\"2009-08-23T00:00Z\",\"ownerInstitutionCollectionCode\":\"eBird\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Illinois\",\"ITIScommonName\":\"Garza morena;Grand Héron;Great Blue Heron\",\"scientificName\":\"Ardea herodias\",\"institutionID\":\"http://www.birds.cornell.edu\",\"_version_\":1478443095514152960}]}}\n"
## attr(,"class")
## [1] "sr_search"
## attr(,"wt")
## [1] "json"
```

*PLOS Search API*

Most of the examples above use the PLOS search API... :)


[Please report any issues or bugs](https://github.com/ropensci/solr/issues).
