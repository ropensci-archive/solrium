solrium
=======



<!-- [![Build Status](https://travis-ci.org/ropensci/solrium.svg?branch=master)](https://travis-ci.org/ropensci/solrium)
[![codecov.io](https://codecov.io/github/ropensci/solrium/coverage.svg?branch=master)](https://codecov.io/github/ropensci/solrium?branch=master) -->
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![cran checks](https://cranchecks.info/badges/worst/solrium)](https://cranchecks.info/pkgs/solrium)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/solrium?color=2ED968)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/solrium)](https://cran.r-project.org/package=solrium)

**A general purpose R interface to [Solr](https://lucene.apache.org/solr/)**

Development is now following Solr v7 and greater - which introduced many changes, which means many functions here may not work with your Solr installation older than v7.

Be aware that currently some functions will only work in certain Solr modes, e.g, `collection_create()` won't work when you are not in Solrcloud mode. But, you should get an error message stating that you aren't.

Currently developing against Solr `v8.2.0`

## Solr info

+ [Solr home page](https://lucene.apache.org/solr/)
+ [Highlighting help](https://lucene.apache.org/solr/guide/8_2/highlighting.html)
+ [Faceting help](https://lucene.apache.org/solr/guide/8_2/faceting.html)
+ [Solr stats](https://lucene.apache.org/solr/guide/8_2/the-stats-component.html)
+ ['More like this' searches](https://lucene.apache.org/solr/guide/8_2/morelikethis.html)
+ [Grouping/Feild collapsing](https://lucene.apache.org/solr/guide/8_2/collapse-and-expand-results.html)
+ [Install and Setup SOLR in OSX, including running Solr](http://risnandar.wordpress.com/2013/09/08/how-to-install-and-setup-apache-lucene-solr-in-osx/)
+ [Solr csv writer](https://lucene.apache.org/solr/guide/8_2/response-writers.html#csv-response-writer)

## Package API and ways of using the package

The first thing to look at is `SolrClient` to instantiate a client connection
to your Solr instance. `ping` and `schema` are helpful functions to look
at after instantiating your client.

There are two ways to use `solrium`:

1. Call functions on the `SolrClient` object
2. Pass the `SolrClient` object to functions

For example, if we instantiate a client like `conn <- SolrClient$new()`, then
to use the first way we can do `conn$search(...)`, and the second way by doing
`solr_search(conn, ...)`. These two ways of using the package hopefully
make the package more user friendly for more people, those that prefer a more
object oriented approach, and those that prefer more of a functional approach.

**Collections**

Functions that start with `collection` work with Solr collections when in
cloud mode. Note that these functions won't work when in Solr standard mode

**Cores**

Functions that start with `core` work with Solr cores when in standard Solr
mode. Note that these functions won't work when in Solr cloud mode

**Documents**

The following functions work with documents in Solr

```
#>  - add
#>  - delete_by_id
#>  - delete_by_query
#>  - update_atomic_json
#>  - update_atomic_xml
#>  - update_csv
#>  - update_json
#>  - update_xml
```

**Search**

Search functions, including `solr_parse` for parsing results from different
functions appropriately

```
#>  - solr_all
#>  - solr_facet
#>  - solr_get
#>  - solr_group
#>  - solr_highlight
#>  - solr_mlt
#>  - solr_parse
#>  - solr_search
#>  - solr_stats
```


## Install

Stable version from CRAN


```r
install.packages("solrium")
```

Or development version from GitHub


```r
devtools::install_github("ropensci/solrium")
```


```r
library("solrium")
```

## Setup

Use `SolrClient$new()` to initialize your connection. These examples use a remote Solr server, but work on any local Solr server.


```r
(cli <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL))
#> <Solr Client>
#>   host: api.plos.org
#>   path: search
#>   port: 
#>   scheme: http
#>   errors: simple
#>   proxy:
```

You can also set whether you want simple or detailed error messages (via `errors`), and whether you want URLs used in each function call or not (via `verbose`), and your proxy settings (via `proxy`) if needed. For example:


```r
SolrClient$new(errors = "complete")
```

Your settings are printed in the print method for the connection object


```r
cli
#> <Solr Client>
#>   host: api.plos.org
#>   path: search
#>   port: 
#>   scheme: http
#>   errors: simple
#>   proxy:
```

For local Solr server setup:

```
bin/solr start -e cloud -noprompt
bin/post -c gettingstarted example/exampledocs/*.xml
```


## Search


```r
cli$search(params = list(q='*:*', rows=2, fl='id'))
#> # A tibble: 2 x 1
#>   id                                                
#>   <chr>                                             
#> 1 10.1371/journal.pone.0058099/materials_and_methods
#> 2 10.1371/journal.pone.0030394/introduction
```

### Search grouped data

Most recent publication by journal


```r
cli$group(params = list(q='*:*', group.field='journal', rows=5, group.limit=1,
                        group.sort='publication_date desc',
                        fl='publication_date, score'))
#>       groupValue numFound start     publication_date score
#> 1       plos one  1877462     0 2019-10-14T00:00:00Z     1
#> 2           none    66782     0 2012-10-23T00:00:00Z     1
#> 3  plos genetics    69734     0 2019-10-14T00:00:00Z     1
#> 4   plos biology    39647     0 2019-10-14T00:00:00Z     1
#> 5 plos pathogens    62807     0 2019-10-14T00:00:00Z     1
```

First publication by journal


```r
cli$group(params = list(q = '*:*', group.field = 'journal', group.limit = 1,
                        group.sort = 'publication_date asc',
                        fl = c('publication_date', 'score'),
                        fq = "publication_date:[1900-01-01T00:00:00Z TO *]"))
#>                          groupValue numFound start     publication_date
#> 1                          plos one  1877462     0 2006-12-20T00:00:00Z
#> 2                              none    57532     0 2005-08-23T00:00:00Z
#> 3                     plos genetics    69734     0 2005-06-17T00:00:00Z
#> 4                      plos biology    39647     0 2003-08-18T00:00:00Z
#> 5                    plos pathogens    62807     0 2005-07-22T00:00:00Z
#> 6        plos computational biology    56327     0 2005-06-24T00:00:00Z
#> 7                     plos medicine    27810     0 2004-09-07T00:00:00Z
#> 8  plos neglected tropical diseases    61180     0 2007-08-30T00:00:00Z
#> 9              plos clinical trials      521     0 2006-04-21T00:00:00Z
#> 10                     plos medicin        9     0 2012-04-17T00:00:00Z
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
gq <- 'publication_date:[2013-01-01T00:00:00Z TO 2013-12-31T00:00:00Z]'
cli$group(
  params = list(q='*:*', group.query = gq,
                group.limit = 3, group.sort = 'publication_date desc',
                fl = 'publication_date'))
#>   numFound start     publication_date
#> 1   307076     0 2013-12-31T00:00:00Z
#> 2   307076     0 2013-12-31T00:00:00Z
#> 3   307076     0 2013-12-31T00:00:00Z
```

Search group with format simple


```r
cli$group(params = list(q='*:*', group.field='journal', rows=5,
                        group.limit=3, group.sort='publication_date desc',
                        group.format='simple', fl='journal, publication_date'))
#>   numFound start  journal     publication_date
#> 1  2262279     0 PLOS ONE 2019-10-14T00:00:00Z
#> 2  2262279     0 PLOS ONE 2019-10-14T00:00:00Z
#> 3  2262279     0 PLOS ONE 2019-10-14T00:00:00Z
#> 4  2262279     0     <NA> 2012-10-23T00:00:00Z
#> 5  2262279     0     <NA> 2012-10-23T00:00:00Z
```

### Facet


```r
cli$facet(params = list(q='*:*', facet.field='journal', facet.query=c('cell', 'bird')))
#> $facet_queries
#> # A tibble: 2 x 2
#>   term   value
#>   <chr>  <int>
#> 1 cell  181326
#> 2 bird   19360
#> 
#> $facet_fields
#> $facet_fields$journal
#> # A tibble: 9 x 2
#>   term                             value  
#>   <fct>                            <fct>  
#> 1 plos one                         1877462
#> 2 plos genetics                    69734  
#> 3 plos pathogens                   62807  
#> 4 plos neglected tropical diseases 61180  
#> 5 plos computational biology       56327  
#> 6 plos biology                     39647  
#> 7 plos medicine                    27810  
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

### Highlight


```r
cli$highlight(params = list(q='alcohol', hl.fl = 'abstract', rows=2))
#> # A tibble: 2 x 2
#>   names                 abstract                                           
#>   <chr>                 <chr>                                              
#> 1 10.1371/journal.pone… "\nAcute <em>alcohol</em> administration can lead …
#> 2 10.1371/journal.pone… Objectives: <em>Alcohol</em>-related morbidity and…
```

### Stats


```r
out <- cli$stats(params = list(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), stats.facet='journal'))
```


```r
out$data
#>                   min     max count missing       sum sumOfSquares
#> counter_total_all   0 1322780 49608       0 264200837 1.119658e+13
#> alm_twitterCount    0    3438 49608       0    304236 8.148536e+07
#>                          mean      stddev
#> counter_total_all 5325.770783 14047.81625
#> alm_twitterCount     6.132801    40.06253
```

### More like this

`solr_mlt` is a function to return similar documents to the one


```r
out <- cli$mlt(params = list(q='title:"ecology" AND body:"cell"', mlt.fl='title', mlt.mindf=1, mlt.mintf=1, fl='counter_total_all', rows=5))
```


```r
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
#> 1     4673     0 10.1371/journal.pone.0098876              4047
#> 2     4673     0 10.1371/journal.pone.0082578              3244
#> 3     4673     0 10.1371/journal.pone.0102159              2434
#> 4     4673     0 10.1371/journal.pone.0193049              1274
#> 5     4673     0 10.1371/journal.pcbi.1003408             11685
#> 
#> $`10.1371/journal.pbio.0020440`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     1373     0 10.1371/journal.pone.0162651              3463
#> 2     1373     0 10.1371/journal.pone.0003259              3417
#> 3     1373     0 10.1371/journal.pntd.0003377              4613
#> 4     1373     0 10.1371/journal.pone.0068814              9701
#> 5     1373     0 10.1371/journal.pone.0101568              6017
#> 
#> $`10.1371/journal.pbio.1002559`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     6285     0 10.1371/journal.pone.0155028              2881
#> 2     6285     0 10.1371/journal.pone.0023086              9361
#> 3     6285     0 10.1371/journal.pone.0041684             26571
#> 4     6285     0 10.1371/journal.pone.0155989              2519
#> 5     6285     0 10.1371/journal.pone.0129394              2111
#> 
#> $`10.1371/journal.pone.0087217`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     5560     0 10.1371/journal.pone.0204743               103
#> 2     5560     0 10.1371/journal.pone.0175497              1088
#> 3     5560     0 10.1371/journal.pone.0159131              4937
#> 4     5560     0 10.1371/journal.pcbi.0020092             26453
#> 5     5560     0 10.1371/journal.pone.0133941              1336
#> 
#> $`10.1371/journal.pbio.1002191`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1    14591     0 10.1371/journal.pbio.1002232              3055
#> 2    14591     0 10.1371/journal.pone.0191705              1040
#> 3    14591     0 10.1371/journal.pone.0070448              2497
#> 4    14591     0 10.1371/journal.pone.0131700              3353
#> 5    14591     0 10.1371/journal.pone.0121680              4980
```

### Parsing

`solr_parse` is a general purpose parser function with extension methods `solr_parse.sr_search`, `solr_parse.sr_facet`, and `solr_parse.sr_high`, for parsing `solr_search`, `solr_facet`, and `solr_highlight` function output, respectively. `solr_parse` is used internally within those three functions (`solr_search`, `solr_facet`, `solr_highlight`) to do parsing. You can optionally get back raw `json` or `xml` from `solr_search`, `solr_facet`, and `solr_highlight` setting parameter `raw=TRUE`, and then parsing after the fact with `solr_parse`. All you need to know is `solr_parse` can parse

For example:


```r
(out <- cli$highlight(params = list(q='alcohol', hl.fl = 'abstract', rows=2),
                      raw=TRUE))
#> [1] "{\n  \"response\":{\"numFound\":31503,\"start\":0,\"maxScore\":4.657826,\"docs\":[\n      {\n        \"id\":\"10.1371/journal.pone.0201042\",\n        \"journal\":\"PLOS ONE\",\n        \"eissn\":\"1932-6203\",\n        \"publication_date\":\"2018-07-26T00:00:00Z\",\n        \"article_type\":\"Research Article\",\n        \"author_display\":[\"Graeme Knibb\",\n          \"Carl. A. Roberts\",\n          \"Eric Robinson\",\n          \"Abi Rose\",\n          \"Paul Christiansen\"],\n        \"abstract\":[\"\\nAcute alcohol administration can lead to a loss of control over drinking. Several models argue that this ‘alcohol priming effect’ is mediated by the effect of alcohol on inhibitory control. Alternatively, beliefs about how alcohol affects behavioural regulation may also underlie alcohol priming and alcohol-induced inhibitory impairments. Here two studies examine the extent to which the alcohol priming effect and inhibitory impairments are moderated by beliefs regarding the effects of alcohol on the ability to control behaviour. In study 1, following a priming drink (placebo or .5g/kg of alcohol), participants were provided with bogus feedback regarding their performance on a measure of inhibitory control (stop-signal task; SST) suggesting that they had high or average self-control. However, the bogus feedback manipulation was not successful. In study 2, before a SST, participants were exposed to a neutral or experimental message suggesting acute doses of alcohol reduce the urge to drink and consumed a priming drink and this manipulation was successful. In both studies craving was assessed throughout and a bogus taste test which measured ad libitum drinking was completed. Results suggest no effect of beliefs on craving or ad lib consumption within either study. However, within study 2, participants exposed to the experimental message displayed evidence of alcohol-induced impairments of inhibitory control, while those exposed to the neutral message did not. These findings do not suggest beliefs about the effects of alcohol moderate the alcohol priming effect but do suggest beliefs may, in part, underlie the effect of alcohol on inhibitory control.\\n\"],\n        \"title_display\":\"The effect of beliefs about alcohol’s acute effects on alcohol priming and alcohol-induced impairments of inhibitory control\",\n        \"score\":4.657826},\n      {\n        \"id\":\"10.1371/journal.pone.0185457\",\n        \"journal\":\"PLOS ONE\",\n        \"eissn\":\"1932-6203\",\n        \"publication_date\":\"2017-09-28T00:00:00Z\",\n        \"article_type\":\"Research Article\",\n        \"author_display\":[\"Jacqueline Willmore\",\n          \"Terry-Lynne Marko\",\n          \"Darcie Taing\",\n          \"Hugues Sampasa-Kanyinga\"],\n        \"abstract\":[\"Objectives: Alcohol-related morbidity and mortality are significant public health issues. The purpose of this study was to describe the prevalence and trends over time of alcohol consumption and alcohol-related morbidity and mortality; and public attitudes of alcohol use impacts on families and the community in Ottawa, Canada. Methods: Prevalence (2013–2014) and trends (2000–2001 to 2013–2014) of alcohol use were obtained from the Canadian Community Health Survey. Data on paramedic responses (2015), emergency department (ED) visits (2013–2015), hospitalizations (2013–2015) and deaths (2007–2011) were used to quantify the acute and chronic health effects of alcohol in Ottawa. Qualitative data were obtained from the “Have Your Say” alcohol survey, an online survey of public attitudes on alcohol conducted in 2016. Results: In 2013–2014, an estimated 595,300 (83%) Ottawa adults 19 years and older drank alcohol, 42% reported binge drinking in the past year. Heavy drinking increased from 15% in 2000–2001 to 20% in 2013–2014. In 2015, the Ottawa Paramedic Service responded to 2,060 calls directly attributable to alcohol. Between 2013 and 2015, there were an average of 6,100 ED visits and 1,270 hospitalizations per year due to alcohol. Annually, alcohol use results in at least 140 deaths in Ottawa. Men have higher rates of alcohol-attributable paramedic responses, ED visits, hospitalizations and deaths than women, and young adults have higher rates of alcohol-attributable paramedic responses. Qualitative data of public attitudes indicate that alcohol misuse has greater repercussions not only on those who drink, but also on the family and community. Conclusions: Results highlight the need for healthy public policy intended to encourage a culture of drinking in moderation in Ottawa to support lower risk alcohol use, particularly among men and young adults. \"],\n        \"title_display\":\"The burden of alcohol-related morbidity and mortality in Ottawa, Canada\",\n        \"score\":4.657525}]\n  },\n  \"highlighting\":{\n    \"10.1371/journal.pone.0201042\":{\n      \"abstract\":[\"\\nAcute <em>alcohol</em> administration can lead to a loss of control over drinking. Several models argue\"]},\n    \"10.1371/journal.pone.0185457\":{\n      \"abstract\":[\"Objectives: <em>Alcohol</em>-related morbidity and mortality are significant public health issues\"]}}}\n"
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

### Progress bars

only supported in the core search methods: `search`, `facet`, `group`, `mlt`, `stats`, `high`, `all`


```r
library(httr)
invisible(cli$search(params = list(q='*:*', rows=100, fl='id'), progress = httr::progress()))
|==============================================| 100%
```

### Advanced: Function Queries

Function Queries allow you to query on actual numeric fields in the SOLR database, and do addition, multiplication, etc on one or many fields to stort results. For example, here, we search on the product of counter_total_all and alm_twitterCount, using a new temporary field "_val_"


```r
cli$search(params = list(q='_val_:"product(counter_total_all,alm_twitterCount)"',
  rows=5, fl='id,title', fq='doc_type:full'))
#> # A tibble: 5 x 2
#>   id                    title                                              
#>   <chr>                 <chr>                                              
#> 1 10.1371/journal.pmed… Why Most Published Research Findings Are False     
#> 2 10.1371/journal.pone… A Multi-Level Bayesian Analysis of Racial Bias in …
#> 3 10.1371/journal.pcbi… Ten simple rules for structuring papers            
#> 4 10.1371/journal.pone… Long-Term Follow-Up of Transsexual Persons Undergo…
#> 5 10.1371/journal.pone… More than 75 percent decline over 27 years in tota…
```

Here, we search for the papers with the most citations


```r
cli$search(params = list(q='_val_:"max(counter_total_all)"',
    rows=5, fl='id,counter_total_all', fq='doc_type:full'))
#> # A tibble: 5 x 2
#>   id                                                      counter_total_all
#>   <chr>                                                               <int>
#> 1 10.1371/journal.pmed.0020124                                      2728832
#> 2 10.1371/journal.pcbi.1003149                                      1322780
#> 3 10.1371/annotation/80bd7285-9d2d-403a-8e6f-9c375bf977ca           1235195
#> 4 10.1371/journal.pone.0141854                                       887162
#> 5 10.1371/journal.pcbi.0030102                                       872604
```

Or with the most tweets


```r
cli$search(params = list(q='_val_:"max(alm_twitterCount)"',
    rows=5, fl='id,alm_twitterCount', fq='doc_type:full'))
#> # A tibble: 5 x 2
#>   id                           alm_twitterCount
#>   <chr>                                   <int>
#> 1 10.1371/journal.pcbi.1005619             4935
#> 2 10.1371/journal.pmed.0020124             3472
#> 3 10.1371/journal.pone.0141854             3438
#> 4 10.1371/journal.pone.0115069             3031
#> 5 10.1371/journal.pmed.1001953             2825
```

### Using specific data sources

__USGS BISON service__

The occurrences service


```r
conn <- SolrClient$new(scheme = "https", host = "bison.usgs.gov", path = "solr/occurrences/select", port = NULL)
conn$search(params = list(q = '*:*', fl = c('decimalLatitude','decimalLongitude','scientificName'), rows = 2))
#> # A tibble: 2 x 3
#>   decimalLongitude scientificName           decimalLatitude
#>              <dbl> <chr>                              <dbl>
#> 1            -121. Petrochelidon pyrrhonota            35.8
#> 2            -102. Spizella arborea                    48.8
```

The species names service


```r
conn <- SolrClient$new(scheme = "https", host = "bison.usgs.gov", path = "solr/scientificName/select", port = NULL)
conn$search(params = list(q = '*:*'))
#> # A tibble: 10 x 2
#>    scientificName              `_version_`
#>    <chr>                             <dbl>
#>  1 Lonicera iberica                1.63e18
#>  2 Dictyopteris polypodioides      1.63e18
#>  3 Epuraea ambigua                 1.63e18
#>  4 Pseudopomala brachyptera        1.63e18
#>  5 Trigonurus crotchi              1.63e18
#>  6 Mactra alata                    1.63e18
#>  7 Reithrodontomys wetmorei        1.63e18
#>  8 Cristellaria orelliana          1.63e18
#>  9 Aster cordifolius alvearius     1.63e18
#> 10 Syringopora rara                1.63e18
```

__PLOS Search API__

Most of the examples above use the PLOS search API... :)

## Solr server management

This isn't as complete as searching functions show above, but we're getting there.

### Cores


```r
conn <- SolrClient$new()
```

Many functions, e.g.:

* `core_create()`
* `core_rename()`
* `core_status()`
* ...

Create a core


```r
conn$core_create(name = "foo_bar")
```

### Collections

Many functions, e.g.:

* `collection_create()`
* `collection_list()`
* `collection_addrole()`
* ...

Create a collection


```r
conn$collection_create(name = "hello_world")
```

### Add documents

Add documents, supports adding from files (json, xml, or csv format), and from R objects (including `data.frame` and `list` types so far)


```r
df <- data.frame(id = c(67, 68), price = c(1000, 500000000))
conn$add(df, name = "books")
```

Delete documents, by id


```r
conn$delete_by_id(name = "books", ids = c(3, 4))
```

Or by query


```r
conn$delete_by_query(name = "books", query = "manu:bank")
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/solrium/issues)
* License: MIT
* Get citation information for `solrium` in R doing `citation(package = 'solrium')`
* Please note that this project is released with a [Contributor Code of Conduct][coc].
By participating in this project you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)

[coc]: https://github.com/ropensci/solrium/blob/master/CODE_OF_CONDUCT.md
