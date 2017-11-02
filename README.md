solrium
=======



[![Build Status](https://travis-ci.org/ropensci/solrium.svg?branch=master)](https://travis-ci.org/ropensci/solrium)
[![codecov.io](https://codecov.io/github/ropensci/solrium/coverage.svg?branch=master)](https://codecov.io/github/ropensci/solrium?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/solrium?color=2ED968)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/solrium)](https://cran.r-project.org/package=solrium)

**A general purpose R interface to [Solr](https://lucene.apache.org/solr/)**

Development is now following Solr v7 and greater - which introduced many changes, which means many functions here may not work with your Solr installation older than v7.

Be aware that currently some functions will only work in certain Solr modes, e.g, `collection_create()` won't work when you are not in Solrcloud mode. But, you should get an error message stating that you aren't.

> Currently developing against Solr `v7.0.0`

> Note that we recently changed the package name to `solrium`. A previous version of this package is on CRAN as `solr`, but next version will be up as `solrium`.

## Solr info

+ [Solr home page](http://lucene.apache.org/solr/)
+ [Highlighting help](https://lucene.apache.org/solr/guide/7_0/highlighting.html)
+ [Faceting help](http://wiki.apache.org/solr/SimpleFacetParameters)
+ [Solr stats](http://wiki.apache.org/solr/StatsComponent)
+ ['More like this' searches](http://wiki.apache.org/solr/MoreLikeThis)
+ [Grouping/Feild collapsing](http://wiki.apache.org/solr/FieldCollapsing)
+ [Install and Setup SOLR in OSX, including running Solr](http://risnandar.wordpress.com/2013/09/08/how-to-install-and-setup-apache-lucene-solr-in-osx/)
+ [Solr csv writer](https://lucene.apache.org/solr/guide/7_0/response-writers.html#ResponseWriters-CSVResponseWriter)

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
#>                                      id
#>                                   <chr>
#> 1    10.1371/journal.pone.0079536/title
#> 2 10.1371/journal.pone.0079536/abstract
```

### Search grouped data

Most recent publication by journal


```r
cli$group(params = list(q='*:*', group.field='journal', rows=5, group.limit=1,
                        group.sort='publication_date desc',
                        fl='publication_date, score'))
#>                         groupValue numFound start     publication_date
#> 1                         plos one  1572163     0 2017-11-01T00:00:00Z
#> 2 plos neglected tropical diseases    47510     0 2017-11-01T00:00:00Z
#> 3                    plos genetics    59871     0 2017-11-01T00:00:00Z
#> 4                   plos pathogens    53246     0 2017-11-01T00:00:00Z
#> 5                             none    63561     0 2012-10-23T00:00:00Z
#>   score
#> 1     1
#> 2     1
#> 3     1
#> 4     1
#> 5     1
```

First publication by journal


```r
cli$group(params = list(q = '*:*', group.field = 'journal', group.limit = 1,
                        group.sort = 'publication_date asc',
                        fl = c('publication_date', 'score'),
                        fq = "publication_date:[1900-01-01T00:00:00Z TO *]"))
#>                          groupValue numFound start     publication_date
#> 1                          plos one  1572163     0 2006-12-20T00:00:00Z
#> 2  plos neglected tropical diseases    47510     0 2007-08-30T00:00:00Z
#> 3                    plos pathogens    53246     0 2005-07-22T00:00:00Z
#> 4        plos computational biology    45582     0 2005-06-24T00:00:00Z
#> 5                              none    57532     0 2005-08-23T00:00:00Z
#> 6              plos clinical trials      521     0 2006-04-21T00:00:00Z
#> 7                     plos genetics    59871     0 2005-06-17T00:00:00Z
#> 8                     plos medicine    23519     0 2004-09-07T00:00:00Z
#> 9                      plos medicin        9     0 2012-04-17T00:00:00Z
#> 10                     plos biology    32513     0 2003-08-18T00:00:00Z
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
#>   numFound start     publication_date  journal
#> 1  1898495     0 2012-10-23T00:00:00Z     <NA>
#> 2  1898495     0 2012-10-23T00:00:00Z     <NA>
#> 3  1898495     0 2012-10-23T00:00:00Z     <NA>
#> 4  1898495     0 2017-11-01T00:00:00Z PLOS ONE
#> 5  1898495     0 2017-11-01T00:00:00Z PLOS ONE
```

### Facet


```r
cli$facet(params = list(q='*:*', facet.field='journal', facet.query=c('cell', 'bird')))
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

### Highlight


```r
cli$highlight(params = list(q='alcohol', hl.fl = 'abstract', rows=2))
#> # A tibble: 2 x 2
#>                          names
#>                          <chr>
#> 1 10.1371/journal.pone.0185457
#> 2 10.1371/journal.pone.0071284
#> # ... with 1 more variables: abstract <chr>
```

### Stats


```r
out <- cli$stats(params = list(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), stats.facet='journal'))
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

### More like this

`solr_mlt` is a function to return similar documents to the one


```r
out <- cli$mlt(params = list(q='title:"ecology" AND body:"cell"', mlt.fl='title', mlt.mindf=1, mlt.mintf=1, fl='counter_total_all', rows=5))
```


```r
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

### Parsing

`solr_parse` is a general purpose parser function with extension methods `solr_parse.sr_search`, `solr_parse.sr_facet`, and `solr_parse.sr_high`, for parsing `solr_search`, `solr_facet`, and `solr_highlight` function output, respectively. `solr_parse` is used internally within those three functions (`solr_search`, `solr_facet`, `solr_highlight`) to do parsing. You can optionally get back raw `json` or `xml` from `solr_search`, `solr_facet`, and `solr_highlight` setting parameter `raw=TRUE`, and then parsing after the fact with `solr_parse`. All you need to know is `solr_parse` can parse

For example:


```r
(out <- cli$highlight(params = list(q='alcohol', hl.fl = 'abstract', rows=2),
                      raw=TRUE))
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

### Advanced: Function Queries

Function Queries allow you to query on actual numeric fields in the SOLR database, and do addition, multiplication, etc on one or many fields to stort results. For example, here, we search on the product of counter_total_all and alm_twitterCount, using a new temporary field "_val_"


```r
cli$search(params = list(q='_val_:"product(counter_total_all,alm_twitterCount)"',
  rows=5, fl='id,title', fq='doc_type:full'))
#> # A tibble: 5 x 2
#>                             id
#>                          <chr>
#> 1 10.1371/journal.pmed.0020124
#> 2 10.1371/journal.pone.0141854
#> 3 10.1371/journal.pone.0073791
#> 4 10.1371/journal.pone.0153419
#> 5 10.1371/journal.pone.0115069
#> # ... with 1 more variables: title <chr>
```

Here, we search for the papers with the most citations


```r
cli$search(params = list(q='_val_:"max(counter_total_all)"',
    rows=5, fl='id,counter_total_all', fq='doc_type:full'))
#> # A tibble: 5 x 2
#>                                                        id
#>                                                     <chr>
#> 1                            10.1371/journal.pmed.0020124
#> 2 10.1371/annotation/80bd7285-9d2d-403a-8e6f-9c375bf977ca
#> 3                            10.1371/journal.pcbi.1003149
#> 4                            10.1371/journal.pone.0141854
#> 5                            10.1371/journal.pcbi.0030102
#> # ... with 1 more variables: counter_total_all <int>
```

Or with the most tweets


```r
cli$search(params = list(q='_val_:"max(alm_twitterCount)"',
    rows=5, fl='id,alm_twitterCount', fq='doc_type:full'))
#> # A tibble: 5 x 2
#>                             id alm_twitterCount
#>                          <chr>            <int>
#> 1 10.1371/journal.pone.0141854             3401
#> 2 10.1371/journal.pmed.0020124             3207
#> 3 10.1371/journal.pone.0115069             2873
#> 4 10.1371/journal.pmed.1001953             2821
#> 5 10.1371/journal.pone.0061981             2392
```

### Using specific data sources

__USGS BISON service__

The occurrences service


```r
conn <- SolrClient$new(scheme = "https", host = "bison.usgs.gov", path = "solr/occurrences/select", port = NULL)
conn$search(params = list(q = '*:*', fl = c('decimalLatitude','decimalLongitude','scientificName'), rows = 2))
#> # A tibble: 2 x 3
#>   decimalLongitude         scientificName decimalLatitude
#>              <dbl>                  <chr>           <dbl>
#> 1        -116.5694 Zonotrichia leucophrys        34.05072
#> 2        -116.5694    Tyrannus vociferans        34.05072
```

The species names service


```r
conn <- SolrClient$new(scheme = "https", host = "bison.usgs.gov", path = "solr/scientificName/select", port = NULL)
conn$search(params = list(q = '*:*'))
#> # A tibble: 10 x 2
#>                scientificName  `_version_`
#>                         <chr>        <dbl>
#>  1 Dictyopteris polypodioides 1.565325e+18
#>  2           Lonicera iberica 1.565325e+18
#>  3            Epuraea ambigua 1.565325e+18
#>  4   Pseudopomala brachyptera 1.565325e+18
#>  5    Didymosphaeria populina 1.565325e+18
#>  6                   Sanoarca 1.565325e+18
#>  7     Celleporina ventricosa 1.565325e+18
#>  8         Trigonurus crotchi 1.565325e+18
#>  9       Ceraticelus laticeps 1.565325e+18
#> 10           Micraster acutus 1.565325e+18
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
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
