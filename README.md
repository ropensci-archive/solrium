solr
=======



[![Build Status](https://api.travis-ci.org/ropensci/solr.png)](https://travis-ci.org/ropensci/solr)
[![Build status](https://ci.appveyor.com/api/projects/status/ytgtb62gsgf5hddi/branch/master)](https://ci.appveyor.com/project/sckott/solr/branch/master)
[![Coverage Status](https://coveralls.io/repos/ropensci/solr/badge.svg)](https://coveralls.io/r/ropensci/solr)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/solr?color=2ED968)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/solr)](http://cran.rstudio.com/web/packages/solr)

**A general purpose R interface to [Solr](http://lucene.apache.org/solr/)**

Development is now following Solr v5 and greater - which introduced many changes, which means many functions here may not work with your Solr installation older than v5.

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

Stable version from CRAN


```r
install.packages("solr")
```

Or development version from GitHub


```r
devtools::install_github("ropensci/solr")
```


```r
library("solr")
```

__Define stuff__ Use the `solr_connect()` function to initialize your connection. These examples use a remote Solr server, but work on any local Solr server.


```r
conn <- solr_connect('http://api.plos.org/search')
```

### Search


```r
solr_search(conn, q='*:*', rows=2, fl='id')
#> Source: local data frame [2 x 1]
#> 
#>                                      id
#> 1    10.1371/journal.pone.0123754/title
#> 2 10.1371/journal.pone.0123754/abstract
```

### Search grouped data

Most recent publication by journal


```r
solr_group(conn, q='*:*', group.field='journal', rows=5, group.limit=1, group.sort='publication_date desc', fl='publication_date, score')
#>                         groupValue numFound start     publication_date
#> 1                         plos one  1105630     0 2015-07-28T00:00:00Z
#> 2       plos computational biology    33092     0 2015-07-28T00:00:00Z
#> 3                             none    63670     0 2012-10-23T00:00:00Z
#> 4 plos neglected tropical diseases    29993     0 2015-07-28T00:00:00Z
#> 5                     plos biology    27639     0 2015-07-27T00:00:00Z
#>   score
#> 1     1
#> 2     1
#> 3     1
#> 4     1
#> 5     1
```

First publication by journal


```r
solr_group(conn, q='*:*', group.field='journal', group.limit=1, group.sort='publication_date asc', fl='publication_date, score', fq="publication_date:[1900-01-01T00:00:00Z TO *]")
#>                          groupValue numFound start     publication_date
#> 1                          plos one  1105630     0 2006-12-01T00:00:00Z
#> 2        plos computational biology    33092     0 2005-06-24T00:00:00Z
#> 3                              none    57557     0 2005-08-23T00:00:00Z
#> 4  plos neglected tropical diseases    29993     0 2007-08-30T00:00:00Z
#> 5                      plos biology    27639     0 2003-08-18T00:00:00Z
#> 6                     plos medicine    19250     0 2004-09-07T00:00:00Z
#> 7                    plos pathogens    39841     0 2005-07-22T00:00:00Z
#> 8                     plos genetics    45548     0 2005-06-17T00:00:00Z
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
solr_group(conn, q='*:*', group.query='publication_date:[2013-01-01T00:00:00Z TO 2013-12-31T00:00:00Z]', group.limit = 3, group.sort='publication_date desc', fl='publication_date')
#>   numFound start     publication_date
#> 1   307081     0 2013-12-31T00:00:00Z
#> 2   307081     0 2013-12-31T00:00:00Z
#> 3   307081     0 2013-12-31T00:00:00Z
```

Search group with format simple


```r
solr_group(conn, q='*:*', group.field='journal', rows=5, group.limit=3, group.sort='publication_date desc', group.format='simple', fl='journal, publication_date')
#>   numFound start                    journal     publication_date
#> 1  1365208     0                   PLOS ONE 2015-07-28T00:00:00Z
#> 2  1365208     0                   PLOS ONE 2015-07-28T00:00:00Z
#> 3  1365208     0                   PLOS ONE 2015-07-28T00:00:00Z
#> 4  1365208     0 PLOS Computational Biology 2015-07-28T00:00:00Z
#> 5  1365208     0 PLOS Computational Biology 2015-07-28T00:00:00Z
```

### Facet


```r
solr_facet(conn, q='*:*', facet.field='journal', facet.query='cell,bird')
#> $facet_queries
#>        term value
#> 1 cell,bird    21
#> 
#> $facet_fields
#> $facet_fields$journal
#>                                  X1      X2
#> 1                          plos one 1105630
#> 2                     plos genetics   45548
#> 3                    plos pathogens   39841
#> 4        plos computational biology   33092
#> 5  plos neglected tropical diseases   29993
#> 6                      plos biology   27639
#> 7                     plos medicine   19250
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

### Highlight


```r
solr_highlight(conn, q='alcohol', hl.fl = 'abstract', rows=2)
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
out <- solr_stats(conn, q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), stats.facet='journal')
```


```r
out$data
#>                   min    max count missing       sum sumOfSquares
#> counter_total_all   0 328552 28366       0 101309285 1.985422e+12
#> alm_twitterCount    0   1670 28366       0    124105 2.233775e+07
#>                          mean     stddev
#> counter_total_all 3571.504089 7565.67159
#> alm_twitterCount     4.375132   27.71946
```

### More like this

`solr_mlt` is a function to return similar documents to the one


```r
out <- solr_mlt(conn, q='title:"ecology" AND body:"cell"', mlt.fl='title', mlt.mindf=1, mlt.mintf=1, fl='counter_total_all', rows=5)
```


```r
out$docs
#> Source: local data frame [5 x 2]
#> 
#>                             id counter_total_all
#> 1 10.1371/journal.pbio.1001805             11747
#> 2 10.1371/journal.pbio.0020440             16883
#> 3 10.1371/journal.pone.0087217              4310
#> 4 10.1371/journal.pbio.1002191              3678
#> 5 10.1371/journal.pone.0040117              2967
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
#> 1 10.1371/journal.pone.0131665                 0
#> 2 10.1371/journal.pcbi.0020092             15860
#> 3 10.1371/journal.pone.0133941                 0
#> 4 10.1371/journal.pone.0123774                 0
#> 5 10.1371/journal.pone.0063375              1539
#> 
#> $`10.1371/journal.pbio.1002191`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0131700                 0
#> 2 10.1371/journal.pone.0070448               967
#> 3 10.1371/journal.pone.0044766              1558
#> 4 10.1371/journal.pone.0028737              5186
#> 5 10.1371/journal.pone.0052330              3682
#> 
#> $`10.1371/journal.pone.0040117`
#>                             id counter_total_all
#> 1 10.1371/journal.pone.0069352              1854
#> 2 10.1371/journal.pone.0035502              2848
#> 3 10.1371/journal.pone.0014065              4238
#> 4 10.1371/journal.pone.0113280              1172
#> 5 10.1371/journal.pone.0078369              2474
```

### Parsing

`solr_parse` is a general purpose parser function with extension methods `solr_parse.sr_search`, `solr_parse.sr_facet`, and `solr_parse.sr_high`, for parsing `solr_search`, `solr_facet`, and `solr_highlight` function output, respectively. `solr_parse` is used internally within those three functions (`solr_search`, `solr_facet`, `solr_highlight`) to do parsing. You can optionally get back raw `json` or `xml` from `solr_search`, `solr_facet`, and `solr_highlight` setting parameter `raw=TRUE`, and then parsing after the fact with `solr_parse`. All you need to know is `solr_parse` can parse

For example:


```r
(out <- solr_highlight(conn, q='alcohol', hl.fl = 'abstract', rows=2, raw=TRUE))
#> [1] "{\"response\":{\"numFound\":18121,\"start\":0,\"docs\":[{},{}]},\"highlighting\":{\"10.1371/journal.pmed.0040151\":{\"abstract\":[\"Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting\"]},\"10.1371/journal.pone.0027752\":{\"abstract\":[\"Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking\"]}}}\n"
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
solr_search(conn, q='_val_:"product(counter_total_all,alm_twitterCount)"',
  rows=5, fl='id,title', fq='doc_type:full')
#> Source: local data frame [5 x 2]
#> 
#>                             id
#> 1 10.1371/journal.pmed.0020124
#> 2 10.1371/journal.pone.0115069
#> 3 10.1371/journal.pone.0105948
#> 4 10.1371/journal.pone.0083325
#> 5 10.1371/journal.pone.0069841
#> Variables not shown: title (chr)
```

Here, we search for the papers with the most citations


```r
solr_search(conn, q='_val_:"max(counter_total_all)"',
    rows=5, fl='id,counter_total_all', fq='doc_type:full')
#> Source: local data frame [5 x 2]
#> 
#>                             id counter_total_all
#> 1 10.1371/journal.pmed.0020124           1110803
#> 2 10.1371/journal.pmed.0050045            336537
#> 3 10.1371/journal.pone.0007595            328552
#> 4 10.1371/journal.pone.0069841            316100
#> 5 10.1371/journal.pone.0033288            308133
```

Or with the most tweets


```r
solr_search(conn, q='_val_:"max(alm_twitterCount)"',
    rows=5, fl='id,alm_twitterCount', fq='doc_type:full')
#> Source: local data frame [5 x 2]
#> 
#>                             id alm_twitterCount
#> 1 10.1371/journal.pone.0061981             2381
#> 2 10.1371/journal.pone.0115069             2275
#> 3 10.1371/journal.pmed.0020124             1769
#> 4 10.1371/journal.pbio.1001535             1670
#> 5 10.1371/journal.pone.0083325             1508
```

### Using specific data sources

__USGS BISON service__

The occurrences service


```r
conn <- solr_connect("http://bison.usgs.ornl.gov/solrstaging/occurrences/select")
solr_search(conn, q='*:*', fl=c('decimalLatitude','decimalLongitude','scientificName'), rows=2)
#> Source: local data frame [2 x 3]
#> 
#>   decimalLongitude decimalLatitude    scientificName
#> 1         -73.8053         42.3202 Buteo jamaicensis
#> 2         -73.8053         42.3202    Circus cyaneus
```

The species names service


```r
url2 <- "http://bisonapi.usgs.ornl.gov/solr/scientificName/select"
solr_search(conn, q='*:*', raw=TRUE)
#> [1] "{\"responseHeader\":{\"status\":0,\"QTime\":4147},\"response\":{\"numFound\":243170991,\"start\":0,\"docs\":[{\"computedCountyFips\":\"36039\",\"providerID\":602,\"catalogNumber\":\"OBS108216896\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Buteo jamaicensis\",\"latlon\":\"-73.8053,42.3202\",\"calculatedState\":\"New York\",\"decimalLongitude\":-73.8053,\"year\":2011,\"ITIStsn\":\"175350\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-823961-175280-175349-175350-\",\"geo\":\"-73.8053 42.3202\",\"TSNs\":[\"175350\"],\"calculatedCounty\":\"Greene County\",\"pointPath\":\"/-73.8053,42.3202/observation\",\"computedStateFips\":\"36\",\"providedCounty\":\"Greene\",\"kingdom\":\"Animalia\",\"decimalLatitude\":42.3202,\"collectionID\":\"http://ebird.org/\",\"occurrenceID\":\"581450722\",\"recordedBy\":\"obsr15309\",\"providedScientificName\":\"Buteo jamaicensis (Gmelin, 1788)\",\"eventDate\":\"2011-02-14T00:00Z\",\"providedCommonName\":\"Red-tailed Hawk\",\"ownerInstitutionCollectionCode\":\"EOD - eBird Observation Dataset\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"New York\",\"ITIScommonName\":\"Aguililla cola roja;Buse à queue rousse;Red-tailed Hawk\",\"scientificName\":\"Buteo jamaicensis\",\"institutionID\":\"http://www.birds.cornell.edu\"},{\"computedCountyFips\":\"36039\",\"providerID\":602,\"catalogNumber\":\"OBS108216895\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Circus cyaneus\",\"latlon\":\"-73.8053,42.3202\",\"calculatedState\":\"New York\",\"decimalLongitude\":-73.8053,\"year\":2011,\"ITIStsn\":\"175430\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-823961-175280-175429-175430-\",\"geo\":\"-73.8053 42.3202\",\"TSNs\":[\"175430\"],\"calculatedCounty\":\"Greene County\",\"pointPath\":\"/-73.8053,42.3202/observation\",\"computedStateFips\":\"36\",\"providedCounty\":\"Greene\",\"kingdom\":\"Animalia\",\"decimalLatitude\":42.3202,\"collectionID\":\"http://ebird.org/\",\"occurrenceID\":\"585323403\",\"recordedBy\":\"obsr15309\",\"providedScientificName\":\"Circus cyaneus (Linnaeus, 1766)\",\"eventDate\":\"2011-02-14T00:00Z\",\"providedCommonName\":\"Northern Harrier\",\"ownerInstitutionCollectionCode\":\"EOD - eBird Observation Dataset\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"New York\",\"ITIScommonName\":\"Busard Saint-Martin;Gavilán rastrero;Northern Harrier\",\"scientificName\":\"Circus cyaneus\",\"institutionID\":\"http://www.birds.cornell.edu\"},{\"computedCountyFips\":\"25003\",\"providerID\":602,\"catalogNumber\":\"OBS168651135\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Anthus rubescens\",\"latlon\":\"-73.274,42.3202\",\"calculatedState\":\"Massachusetts\",\"decimalLongitude\":-73.274,\"year\":2012,\"ITIStsn\":\"554127\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-178265-178474-178488-554127-\",\"geo\":\"-73.274 42.3202\",\"TSNs\":[\"554127\"],\"calculatedCounty\":\"Berkshire County\",\"pointPath\":\"/-73.274,42.3202/observation\",\"computedStateFips\":\"25\",\"providedCounty\":\"Berkshire\",\"kingdom\":\"Animalia\",\"decimalLatitude\":42.3202,\"collectionID\":\"http://ebird.org/\",\"occurrenceID\":\"819929403\",\"recordedBy\":\"obsr34603\",\"providedScientificName\":\"Anthus rubescens (Tunstall, 1771)\",\"eventDate\":\"2012-11-05T00:00Z\",\"providedCommonName\":\"American Pipit\",\"ownerInstitutionCollectionCode\":\"EOD - eBird Observation Dataset\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Massachusetts\",\"ITIScommonName\":\"American Pipit;Bisbita de agua;Buff-bellied Pipit;pipit d'Amérique\",\"scientificName\":\"Anthus rubescens\",\"institutionID\":\"http://www.birds.cornell.edu\"},{\"computedCountyFips\":\"25003\",\"providerID\":602,\"catalogNumber\":\"OBS168651134\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Sturnus vulgaris\",\"latlon\":\"-73.274,42.3202\",\"calculatedState\":\"Massachusetts\",\"decimalLongitude\":-73.274,\"year\":2012,\"ITIStsn\":\"179637\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-178265-179635-179636-179637-\",\"geo\":\"-73.274 42.3202\",\"TSNs\":[\"179637\"],\"calculatedCounty\":\"Berkshire County\",\"pointPath\":\"/-73.274,42.3202/observation\",\"computedStateFips\":\"25\",\"providedCounty\":\"Berkshire\",\"kingdom\":\"Animalia\",\"decimalLatitude\":42.3202,\"collectionID\":\"http://ebird.org/\",\"occurrenceID\":\"846897356\",\"recordedBy\":\"obsr34603\",\"providedScientificName\":\"Sturnus vulgaris Linnaeus, 1758\",\"eventDate\":\"2012-11-05T00:00Z\",\"providedCommonName\":\"European Starling\",\"ownerInstitutionCollectionCode\":\"EOD - eBird Observation Dataset\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Massachusetts\",\"ITIScommonName\":\"Common Starling;Estornino pinto;étourneau sansonnet;European Starling\",\"scientificName\":\"Sturnus vulgaris\",\"institutionID\":\"http://www.birds.cornell.edu\"},{\"computedCountyFips\":\"25003\",\"providerID\":602,\"catalogNumber\":\"OBS168651133\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Columba livia\",\"latlon\":\"-73.274,42.3202\",\"calculatedState\":\"Massachusetts\",\"decimalLongitude\":-73.274,\"year\":2012,\"ITIStsn\":\"177071\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-177038-177061-676884-177062-177071-\",\"geo\":\"-73.274 42.3202\",\"TSNs\":[\"177071\"],\"calculatedCounty\":\"Berkshire County\",\"pointPath\":\"/-73.274,42.3202/observation\",\"computedStateFips\":\"25\",\"providedCounty\":\"Berkshire\",\"kingdom\":\"Animalia\",\"decimalLatitude\":42.3202,\"collectionID\":\"http://ebird.org/\",\"occurrenceID\":\"828002449\",\"recordedBy\":\"obsr34603\",\"providedScientificName\":\"Columba livia Gmelin, 1789\",\"eventDate\":\"2012-11-05T00:00Z\",\"providedCommonName\":\"Rock Pigeon\",\"ownerInstitutionCollectionCode\":\"EOD - eBird Observation Dataset\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Massachusetts\",\"ITIScommonName\":\"Common Pigeon;Paloma doméstica;pigeon biset;Rock Dove;Rock Pigeon\",\"scientificName\":\"Columba livia\",\"institutionID\":\"http://www.birds.cornell.edu\"},{\"computedCountyFips\":\"25003\",\"providerID\":602,\"catalogNumber\":\"OBS168651136\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Cardinalis cardinalis\",\"latlon\":\"-73.274,42.3202\",\"calculatedState\":\"Massachusetts\",\"decimalLongitude\":-73.274,\"year\":2012,\"ITIStsn\":\"179124\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-178265-553443-179123-179124-\",\"geo\":\"-73.274 42.3202\",\"TSNs\":[\"179124\"],\"calculatedCounty\":\"Berkshire County\",\"pointPath\":\"/-73.274,42.3202/observation\",\"computedStateFips\":\"25\",\"providedCounty\":\"Berkshire\",\"kingdom\":\"Animalia\",\"decimalLatitude\":42.3202,\"collectionID\":\"http://ebird.org/\",\"occurrenceID\":\"823462501\",\"recordedBy\":\"obsr34603\",\"providedScientificName\":\"Cardinalis cardinalis (Linnaeus, 1758)\",\"eventDate\":\"2012-11-05T00:00Z\",\"providedCommonName\":\"Northern Cardinal\",\"ownerInstitutionCollectionCode\":\"EOD - eBird Observation Dataset\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Massachusetts\",\"ITIScommonName\":\"Cardenal rojo;cardinal rouge;Northern Cardinal\",\"scientificName\":\"Cardinalis cardinalis\",\"institutionID\":\"http://www.birds.cornell.edu\"},{\"computedCountyFips\":\"25003\",\"providerID\":602,\"catalogNumber\":\"OBS198743419\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Anas platyrhynchos\",\"latlon\":\"-73.274,42.3202\",\"calculatedState\":\"Massachusetts\",\"decimalLongitude\":-73.274,\"year\":2013,\"ITIStsn\":\"175063\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-174982-174983-714011-175062-175063-\",\"geo\":\"-73.274 42.3202\",\"TSNs\":[\"175063\"],\"calculatedCounty\":\"Berkshire County\",\"pointPath\":\"/-73.274,42.3202/observation\",\"computedStateFips\":\"25\",\"providedCounty\":\"Berkshire\",\"kingdom\":\"Animalia\",\"decimalLatitude\":42.3202,\"collectionID\":\"http://ebird.org/\",\"occurrenceID\":\"954484938\",\"recordedBy\":\"obsr34603\",\"providedScientificName\":\"Anas platyrhynchos Linnaeus, 1758\",\"eventDate\":\"2013-05-25T00:00Z\",\"providedCommonName\":\"Mallard\",\"ownerInstitutionCollectionCode\":\"EOD - eBird Observation Dataset\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Massachusetts\",\"ITIScommonName\":\"canard colvert;Mallard;Pato de collar\",\"scientificName\":\"Anas platyrhynchos\",\"institutionID\":\"http://www.birds.cornell.edu\"},{\"computedCountyFips\":\"25003\",\"providerID\":602,\"catalogNumber\":\"OBS198743420\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Charadrius vociferus\",\"latlon\":\"-73.274,42.3202\",\"calculatedState\":\"Massachusetts\",\"decimalLongitude\":-73.274,\"year\":2013,\"ITIStsn\":\"176520\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-176445-176479-176503-176520-\",\"geo\":\"-73.274 42.3202\",\"TSNs\":[\"176520\"],\"calculatedCounty\":\"Berkshire County\",\"pointPath\":\"/-73.274,42.3202/observation\",\"computedStateFips\":\"25\",\"providedCounty\":\"Berkshire\",\"kingdom\":\"Animalia\",\"decimalLatitude\":42.3202,\"collectionID\":\"http://ebird.org/\",\"occurrenceID\":\"954515174\",\"recordedBy\":\"obsr34603\",\"providedScientificName\":\"Charadrius vociferus Linnaeus, 1758\",\"eventDate\":\"2013-05-25T00:00Z\",\"providedCommonName\":\"Killdeer\",\"ownerInstitutionCollectionCode\":\"EOD - eBird Observation Dataset\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Massachusetts\",\"ITIScommonName\":\"Chorlo tildío;Killdeer;Pluvier kildir\",\"scientificName\":\"Charadrius vociferus\",\"institutionID\":\"http://www.birds.cornell.edu\"},{\"computedCountyFips\":\"25003\",\"providerID\":602,\"catalogNumber\":\"OBS198743418\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Branta canadensis\",\"latlon\":\"-73.274,42.3202\",\"calculatedState\":\"Massachusetts\",\"decimalLongitude\":-73.274,\"year\":2013,\"ITIStsn\":\"174999\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-174371-174982-174983-714008-174998-174999-\",\"geo\":\"-73.274 42.3202\",\"TSNs\":[\"174999\"],\"calculatedCounty\":\"Berkshire County\",\"pointPath\":\"/-73.274,42.3202/observation\",\"computedStateFips\":\"25\",\"providedCounty\":\"Berkshire\",\"kingdom\":\"Animalia\",\"decimalLatitude\":42.3202,\"collectionID\":\"http://ebird.org/\",\"occurrenceID\":\"954485219\",\"recordedBy\":\"obsr34603\",\"providedScientificName\":\"Branta canadensis (Linnaeus, 1758)\",\"eventDate\":\"2013-05-25T00:00Z\",\"providedCommonName\":\"Canada Goose\",\"ownerInstitutionCollectionCode\":\"EOD - eBird Observation Dataset\",\"provider\":\"Cornell Lab of Ornithology\",\"ambiguous\":false,\"resourceID\":\"602,43\",\"stateProvince\":\"Massachusetts\",\"ITIScommonName\":\"bernache du Canada;Canada Goose;Ganso canadiense\",\"scientificName\":\"Branta canadensis\",\"institutionID\":\"http://www.birds.cornell.edu\"},{\"computedCountyFips\":\"25015\",\"providerID\":407,\"catalogNumber\":\"242130\",\"basisOfRecord\":\"observation\",\"countryCode\":\"US\",\"ITISscientificName\":\"Thamnophis sirtalis sirtalis\",\"latlon\":\"-72.64085,42.3202\",\"calculatedState\":\"Massachusetts\",\"decimalLongitude\":-72.64085,\"year\":2011,\"ITIStsn\":\"174137\",\"hierarchy_homonym_string\":\"-202423-914154-914156-158852-331030-914179-914181-173747-173861-174118-634390-174121-700177-174133-174136-174137-\",\"geo\":\"-72.64085 42.3202\",\"TSNs\":[\"174137\"],\"calculatedCounty\":\"Hampshire County\",\"pointPath\":\"/-72.64085,42.3202/observation\",\"computedStateFips\":\"25\",\"kingdom\":\"Animalia\",\"decimalLatitude\":42.3202,\"collectionID\":\"http://www.inaturalist.org/observations\",\"occurrenceID\":\"891142836\",\"recordedBy\":\"Margaret Liu\",\"providedScientificName\":\"Thamnophis sirtalis subsp. sirtalis\",\"eventDate\":\"2011-09-12T00:00Z\",\"ownerInstitutionCollectionCode\":\"iNaturalist research-grade observations\",\"provider\":\"iNaturalist.org\",\"ambiguous\":false,\"resourceID\":\"407,14026\",\"ITIScommonName\":\"Common Garter Snake\",\"scientificName\":\"Thamnophis sirtalis sirtalis\",\"institutionID\":\"http://www.inaturalist.org\"}]}}\n"
#> attr(,"class")
#> [1] "sr_search"
#> attr(,"wt")
#> [1] "json"
```

__PLOS Search API__

Most of the examples above use the PLOS search API... :)

### Meta

* Please [report any issues or bugs](https://github.com/ropensci/solr/issues).
* License: MIT
* Get citation information for `solr` in R doing `citation(package = 'solr')`

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
