solr
=======

[![Build Status](https://api.travis-ci.org/ropensci/solr.png)](https://travis-ci.org/ropensci/solr)

**A general purpose R interface to [Solr](http://lucene.apache.org/solr/)**

This package only deals with exracting data from a Solr endpoint, not writing data (pull request or holla if you're interested in writing solr data).

### Solr info

+ [Solr home page](http://lucene.apache.org/solr/)
+ [Highlighting help](http://wiki.apache.org/solr/HighlightingParameters)
+ [Faceting help](http://wiki.apache.org/solr/SimpleFacetParameters)
+ [Solr stats](http://wiki.apache.org/solr/StatsComponent)
+ ['More like this' searches](http://wiki.apache.org/solr/MoreLikeThis)
+ [Grouping/Feild collapsing](http://wiki.apache.org/solr/FieldCollapsing)
+ [Install and Setup SOLR in OSX, including running Solr](http://risnandar.wordpress.com/2013/09/08/how-to-install-and-setup-apache-lucene-solr-in-osx/)

### Quick start

**Install**

Install dependencies

```coffee
install.packages(c("rjson","plyr","httr","XML","data.table","assertthat"))
```

Install solr

```coffee
install.packages("devtools")
library(devtools)
install_github("ropensci/solr")
library(solr)
```

**Define stuff** Your base url and a key (if needed). This example should work. You do need to pass a key to the Public Library of Science search API, but it apparently doesn't need to be a real one.

```coffee
url <- 'http://api.plos.org/search'
key <- 'key'
```

**Search**

```coffee
solr_search(q='*:*', rows=2, fl='id', base=url, key=key)
```

```coffee
$response
$response$numFound
[1] 855548

$response$start
[1] 0

$response$docs
$response$docs[[1]]
$response$docs[[1]]$id
[1] "10.1371/journal.pone.0067887/materials_and_methods"


$response$docs[[2]]
$response$docs[[2]]$id
[1] "10.1371/journal.pone.0010659"
```

**Search grouped data**

Most recent publication by journal

```coffee
solr_group(q='*:*', group.field='journal', rows=5, group.limit=1, group.sort='publication_date desc', fl='publication_date, score', base=url, key=key)
```

```coffee
                  groupValue numFound start     publication_date score
1                   plos one   676409     0 2014-01-16T00:00:00Z     1
2                       none    62518     0 2012-10-23T00:00:00Z     1
3             plos pathogens    29623     0 2014-01-16T00:00:00Z     1
4 plos computational biology    25093     0 2014-01-16T00:00:00Z     1
5              plos genetics    33698     0 2014-01-16T00:00:00Z     
```

First publication by journal

```coffee
solr_group(q='*:*', group.field='journal', group.limit=1, group.sort='publication_date asc', fl='publication_date, score', fq="publication_date:[1900-01-01T00:00:00Z TO *]", base=url, key=key)
```


```coffee
                         groupValue numFound start     publication_date score
1                          plos one   676409     0 2006-12-01T00:00:00Z     1
2                              none    57574     0 2012-07-17T00:00:00Z     1
3                    plos pathogens    29623     0 2005-07-22T00:00:00Z     1
4        plos computational biology    25093     0 2005-06-24T00:00:00Z     1
5                     plos genetics    33698     0 2005-06-17T00:00:00Z     1
6  plos neglected tropical diseases    19106     0 2007-08-30T00:00:00Z     1
7                      plos biology    24111     0 2003-08-18T00:00:00Z     1
8                     plos medicine    17118     0 2004-09-07T00:00:00Z     1
9              plos clinical trials      521     0 2006-04-21T00:00:00Z     1
10                     plos medicin        9     0 2012-04-17T00:00:00Z     1
```

Search group query : Last 3 publications of 2013.  

```coffee
solr_group(q='*:*', group.query='publication_date:[2013-01-01T00:00:00Z TO 2013-12-31T00:00:00Z]', group.limit = 3, group.sort='publication_date desc', fl='publication_date', base=url, key=key)
```

```coffee
  numFound start     publication_date
1   299130     0 2013-12-31T00:00:00Z
2   299130     0 2013-12-31T00:00:00Z
3   299130     0 2013-12-31T00:00:00Z
```

Search group with format simple 

```coffee
solr_group(q='*:*', group.field='journal', rows=5, group.limit=3, group.sort='publication_date desc', group.format='simple', fl='journal, publication_date', base=url, key=key)
```

```coffee
  numFound start                          journal     publication_date
1   889099     0                         PLoS ONE 2014-01-17T00:00:00Z
2   889099     0                         PLoS ONE 2014-01-17T00:00:00Z
3   889099     0                         PLoS ONE 2014-01-17T00:00:00Z
4   889099     0 PLoS Neglected Tropical Diseases 2014-01-16T00:00:00Z
5   889099     0 PLoS Neglected Tropical Diseases 2014-01-16T00:00:00Z
```


**Facet**

```coffee
solr_facet(q='*:*', facet.field='journal', facet.query='cell,bird', base=url, key=key)
```

```coffee
$facet_queries
$facet_queries$cell
[1] 77988

$facet_queries$bird
[1] 7832


$facet_fields
$facet_fields$journal
                                 X1     X2
1                          plos one 647009
2                     plos genetics  32758
3                    plos pathogens  28877
4        plos computational biology  24631
5                      plos biology  23822
6  plos neglected tropical diseases  18531
7                     plos medicine  16964
8              plos clinical trials    521
9                      plos medicin      9
10                 plos collections      5


$facet_dates
NULL

$facet_ranges
NULL
```

**Highlight**

```coffee
solr_highlight(q='alcohol', hl.fl = 'abstract', rows=2, base = url, key=key)
```

```coffee
$`10.1371/journal.pmed.0040151`
$`10.1371/journal.pmed.0040151`$abstract
[1] "Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting"

$`10.1371/journal.pone.0027752`
$`10.1371/journal.pone.0027752`$abstract
[1] "Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking"
```

**Stats**

```coffee
out <- solr_stats(q='ecology', stats.field='counter_total_all,alm_twitterCount', stats.facet='journal,volume', base=url, key=key)
```

```coffee
out$data

                  min    max count missing      sum sumOfSquares        mean     stddev
counter_total_all   0 291798 18090       0 58248156 963881969164 3219.909121 6551.11769
alm_twitterCount    0   1288 18090       0    56281      7405549    3.111166   19.99288
```

```coffee
out$facet

$counter_total_all
$counter_total_all$journal
   min    max count missing      sum sumOfSquares      mean    stddev                      facet_field
1    0  37364   404       0  2067577  17667056069  5117.765  4193.130                   plos pathogens
2    0  42118   529       0  3035262  27897585512  5737.735  4455.601                    plos genetics
3    0 291798 13909       0 35301226 539536707572  2538.013  5687.819                         plos one
4 4168   8060     2       0    12228     82335824  6114.000  2752.060             plos clinical trials
5    0  82757   208       0  2158539  42235524521 10377.591  9788.855                    plos medicine
6 1083 156837   746       0  8466420 215069636314 11349.088 12637.618                     plos biology
7    0  53230   365       0  1885392  19166761014  5165.458  5089.271       plos computational biology
8    0 156975   676       0  2144469  35507150823  3172.291  6521.108 plos neglected tropical diseases

$counter_total_all$volume
    min    max count missing      sum sumOfSquares      mean    stddev facet_field
1   816 107405   741       0  5068779  91374456697  6840.457  8753.508           3
2  1132  85278   482       0  3949081  77017836813  8193.114  9636.056           2
3  1372 108353    81       0  1065357  35985240783 13152.556 16572.973           1
4     0  59941    71       0   708999  13064772701  9985.901  9246.450          10
5     0 178757  4823       0 12104091 171718229745  2509.660  5414.029           7
6   505 156975  2946       0  9871464 122011127354  3350.802  5495.292           6
7   470  73727  1538       0  7245872  81747121892  4711.230  5565.611           5
8   493 291798  1010       0  6224943 180702758301  6163.310 11877.159           4
9     0 156837   354       0  1880616  40701877832  5312.475  9327.402           9
10    0 149871  5983       0  9502785 135631792015  1588.298  4488.898           8
11 1147  66540    61       0   626169  13926755031 10265.066 11179.661          11


$alm_twitterCount
$alm_twitterCount$journal
  min  max count missing   sum sumOfSquares     mean    stddev                      facet_field
1   0   73   404       0  1172        30074 2.900990  8.135643                   plos pathogens
2   0   48   529       0  1146        19558 2.166352  5.686800                    plos genetics
3   0  733 13909       0 38274      4148472 2.751743 17.050129                         plos one
4   0    3     2       0     3            9 1.500000  2.121320             plos clinical trials
5   0  201   208       0  1568       138226 7.538462 24.711445                    plos medicine
6   0 1288   746       0  4975      2034243 6.668901 51.826572                     plos biology
7   0  102   365       0  1081        35411 2.961644  9.406781       plos computational biology
8   0  784   676       0  1711       625745 2.531065 30.341619 plos neglected tropical diseases

$alm_twitterCount$volume
   min  max count missing   sum sumOfSquares       mean     stddev facet_field
1    0   17   741       0   292         2136  0.3940621   1.652571           3
2    0   35   482       0   256         3778  0.5311203   2.751689           2
3    0   28    81       0    80         1582  0.9876543   4.334437           1
4    0  201    71       0  1735       140243 24.4366197  37.387061          10
5    0  733  4823       0 16890      1547170  3.5019697  17.566734           7
6    0  784  2946       0  2634       750518  0.8940937  15.938794           6
7    0  110  1538       0  1004        38182  0.6527958   4.941202           5
8    0  142  1010       0   472        25576  0.4673267   5.012909           4
9    0  150   354       0  2871       112269  8.1101695  15.877069           9
10   0  727  5983       0 26011      2785113  4.3474845  21.134769           8
11   1 1288    61       0  4036      1998982 66.1639344 169.899203          11
```

**More like this**

`solr_mlt` is a function to return similar documents to the one 

```coffee
out <- solr_mlt(q='title:"ecology" AND body:"cell"', mlt.fl='title', mlt.mindf=1, mlt.mintf=1, fl='counter_total_all', rows=5, base=url, key=key)
out$docs
                            id counter_total_all
1 10.1371/journal.pbio.0020440             15977
2 10.1371/journal.pone.0040117              1589
3 10.1371/journal.pone.0072525               635
4 10.1371/journal.ppat.1002320              4612
5 10.1371/journal.pone.0015143             11003
```

```coffee
out$mlt

                             id counter_total_all
1  10.1371/journal.pone.0035964              2247
2  10.1371/journal.pone.0003259              1693
3  10.1371/journal.pone.0068814              3953
4  10.1371/journal.pbio.0020148             11186
5  10.1371/journal.pbio.0030105              2761
6  10.1371/journal.pone.0069352               647
7  10.1371/journal.pone.0014065              3311
8  10.1371/journal.pone.0035502              1757
9  10.1371/journal.pone.0078369               455
10 10.1371/journal.pone.0048646              1357
11 10.1371/journal.pone.0060766               831
12 10.1371/journal.pcbi.1002928              6051
13 10.1371/journal.pcbi.0020144             11556
14 10.1371/journal.pcbi.1000350              7925
15 10.1371/journal.pone.0068714              1363
16 10.1371/journal.pbio.1001332             12315
17 10.1371/journal.ppat.1000222              9901
18 10.1371/journal.pone.0052612              1223
19 10.1371/journal.pntd.0001693              2402
20 10.1371/journal.pntd.0001283              3505
21 10.1371/journal.pbio.1001702              1576
22 10.1371/journal.pone.0008413              5687
23 10.1371/journal.pone.0014451              4823
24 10.1371/journal.ppat.1003500              2212
25 10.1371/journal.pone.0035348              5200
```

**Parsing**

`solr_parse` is a general purpose parser function with extension methods `solr_parse.sr_search`, `solr_parse.sr_facet`, and `solr_parse.sr_high`, for parsing `solr_search`, `solr_facet`, and `solr_highlight` function output, respectively. `solr_parse` is used internally within those three functions (`solr_search`, `solr_facet`, `solr_highlight`) to do parsing. You can optionally get back raw `json` or `xml` from `solr_search`, `solr_facet`, and `solr_highlight` setting parameter `raw=TRUE`, and then parsing after the fact with `solr_parse`. All you need to know is `solr_parse` can parse 

For example:

```coffee
(out <- solr_highlight(q='alcohol', hl.fl = 'abstract', rows=2, base = url, key=key, raw=TRUE))
```

```coffee
[1] "{\"response\":{\"numFound\":11001,\"start\":0,\"docs\":[{},{}]},\"highlighting\":{\"10.1371/journal.pmed.0040151\":{\"abstract\":[\"Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting\"]},\"10.1371/journal.pone.0027752\":{\"abstract\":[\"Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking\"]}}}\n"
attr(,"class")
[1] "sr_high"
attr(,"wt")
[1] "json"
```

Then parse

```coffee
solr_parse(out, 'df')
```

```coffee
                         names
1 10.1371/journal.pmed.0040151
2 10.1371/journal.pone.0027752
                                                                                                   abstract
1   Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting
2 Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking
```

**Advanced: Function Queries**

Function Queries allow you to query on actual numeric fields in the SOLR database, and do addition, multiplication, etc on one or many fields to stort results. For example, here, we search on the product of counter_total_all and alm_twitterCount, using a new temporary field "_val_"

```coffee
solr_search(q='_val_:"product(counter_total_all,alm_twitterCount)"', 
  rows=5, fl='id,title', fq='doc_type:full', base=url, key=key)
```

```coffee
                            id                                                                                                         title
1 10.1371/journal.pmed.0020124                                                                Why Most Published Research Findings Are False
2 10.1371/journal.pone.0046362            The Power of Kawaii: Viewing Cute Images Promotes a Careful Behavior and Narrows Attentional Focus
3 10.1371/journal.pntd.0001969 An In-Depth Analysis of a Piece of Shit: Distribution of Schistosoma mansoni and Hookworm Eggs in Human Stool
4 10.1371/journal.pone.0069841                                       Facebook Use Predicts Declines in Subjective Well-Being in Young Adults
5 10.1371/journal.pbio.1001535                                                                An Introduction to Social Media for Scientists
```

Here, we search for the papers with the most citations

```coffee
solr_search(q='_val_:"max(counter_total_all)"', 
    rows=5, fl='id,counter_total_all', fq='doc_type:full', base=url, key=key)
```

```coffee
                            id counter_total_all
1 10.1371/journal.pmed.0020124            778105
2 10.1371/journal.pmed.0050045            299271
3 10.1371/journal.pone.0007595            291798
4 10.1371/journal.pone.0044864            234084
5 10.1371/journal.pone.0033288            200577
```

Or with the most tweets

```coffee
solr_search(q='_val_:"max(alm_twitterCount)"', 
    rows=5, fl='id,alm_twitterCount', fq='doc_type:full', base=url, key=key)
```

```coffee
                           id alm_twitterCount
1 10.1371/journal.pbio.1001535             1288
2 10.1371/journal.pone.0046362             1012
3 10.1371/journal.pmed.0020124              953
4 10.1371/journal.pntd.0001969              784
5 10.1371/journal.pone.0040259              733
```

**Using specific data sources**

*USGS BISON service*

The occurrences service

```coffee
url <- "http://bisonapi.usgs.ornl.gov/solr/occurrences/select"
solr_search(q='*:*', fl='latitude,longitude,scientific_name', base=url)
```

```coffee
   longitude latitude        scientific_name
1  -75.11961 40.22928 Catostomus commersonii
2  -75.11961 40.22928  Ambloplites rupestris
3  -75.11961 40.22928      Anguilla rostrata
4  -75.11961 40.22928      Anguilla rostrata
5  -75.11961 40.22928 Catostomus commersonii
6  -75.11961 40.22928  Ambloplites rupestris
7  -75.11961 40.22928      Lepomis cyanellus
8  -75.11961 40.22928      Lepomis cyanellus
9  -75.11961 40.22928     Fundulus diaphanus
10 -75.11961 40.22928    Etheostoma olmstedi
```

The species names service

```coffee
solr_search(q='*:*', base=url2, raw=TRUE)
```

```coffee
[1] "{\"responseHeader\":{\"status\":0,\"QTime\":1},\"response\":{\"numFound\":53469,\"start\":0,\"docs\":[{\"id\":\"16297945\",\"scientific_name\":\"Aa\",\"common_nameText\":[\"Aa (genre)\",\"Aa (plant)\",\"Aa (planta)\"],\"common_name\":[\"Aa (genre)\",\"Aa (plant)\",\"Aa (planta)\"]},{\"id\":\"7491959\",\"scientific_name\":\"Abagrotis alternata\",\"common_nameText\":[\"greater red dart\"],\"common_name\":[\"greater red dart\"]},{\"id\":\"7491958\",\"scientific_name\":\"Abagrotis placida\",\"common_nameText\":[\"red cutworm\"],\"common_name\":[\"red cutworm\"]},{\"id\":\"9901614\",\"scientific_name\":\"Abalistes stellatus\",\"common_nameText\":[\"Starry triggerfish\",\"Baliste étoilé\"],\"common_name\":[\"Starry triggerfish\",\"Baliste étoilé\"]},{\"id\":\"17181782\",\"scientific_name\":\"Abelia\",\"common_nameText\":[\"Abelia\"],\"common_name\":[\"Abelia\"]},{\"id\":\"10102658\",\"scientific_name\":\"Abelia chinensis\",\"common_nameText\":[\"Chinese abelia\"],\"common_name\":[\"Chinese abelia\"]},{\"id\":\"10102698\",\"scientific_name\":\"Abelia floribunda\",\"common_nameText\":[\"Mexican abelia\"],\"common_name\":[\"Mexican abelia\"]},{\"id\":\"7489450\",\"scientific_name\":\"Abelia grandiflora\",\"common_nameText\":[\"glossy abelia\",\"Abelia\"],\"common_name\":[\"glossy abelia\",\"Abelia\"]},{\"id\":\"10102796\",\"scientific_name\":\"Abeliophyllum distichum\",\"common_nameText\":[\"white forsythia\"],\"common_name\":[\"white forsythia\"]},{\"id\":\"10102827\",\"scientific_name\":\"Abelmoschus esculentus\",\"common_nameText\":[\"gumbo\",\"lady's fingers\",\"Gombo\"],\"common_name\":[\"gumbo\",\"lady's fingers\",\"Gombo\"]}]}}"
attr(,"class")
[1] "sr_search"
attr(,"wt")
[1] "json"
```

*PLOS Search API*

Most of the examples above use the PLOS search API... :)

### Meta

Please report any issues or bugs](https://github.com/ropensci/solr/issues).

License: CC0

This package is part of the [rOpenSci](http://ropensci.org/packages) project.

To cite package `solr` in publications use:

```coffee
To cite package ‘solr’ in publications use:

  Scott Chamberlain (2013). solr: General purpose R interface to Solr. R package version 0.0.5.
  https://github.com/ropensci/solr

A BibTeX entry for LaTeX users is

  @Manual{,
    title = {solr: General purpose R interface to Solr},
    author = {Scott Chamberlain},
    year = {2013},
    note = {R package version 0.0.5},
    base = {https://github.com/ropensci/solr},
  }
```

Get citation information for `solr` in R doing `citation(package = 'solr')`

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
