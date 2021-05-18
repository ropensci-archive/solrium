solrium
=======



[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![cran checks](https://cranchecks.info/badges/worst/solrium)](https://cranchecks.info/pkgs/solrium)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/solrium?color=2ED968)](https://github.com/r-hub/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/solrium)](https://cran.r-project.org/package=solrium)

**A general purpose R interface to [Solr](https://solr.apache.org/)**

Development is now following Solr v7 and greater - which introduced many changes, which means many functions here may not work with your Solr installation older than v7.

Be aware that currently some functions will only work in certain Solr modes, e.g, `collection_create()` won't work when you are not in Solrcloud mode. But, you should get an error message stating that you aren't.

Currently developing against Solr `v8.2.0`

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
remotes::install_github("ropensci/solrium")
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
(res <- cli$search(params = list(q='*:*', rows=2, fl='id')))
#> # A tibble: 2 x 1
#>   id                                   
#>   <chr>                                
#> 1 10.1371/journal.pbio.1000146/title   
#> 2 10.1371/journal.pbio.1000146/abstract
```

And you can get search metadata from the attributes:


```r
attributes(res)
#> $names
#> [1] "id"
#> 
#> $row.names
#> [1] 1 2
#> 
#> $class
#> [1] "tbl_df"     "tbl"        "data.frame"
#> 
#> $numFound
#> [1] 2542432
#> 
#> $start
#> [1] 0
```


### Search grouped data

Most recent publication by journal


```r
cli$group(params = list(q='*:*', group.field='journal', rows=5, group.limit=1,
                        group.sort='publication_date desc',
                        fl='publication_date, score'))
#>                   groupValue numFound start     publication_date score
#> 1               plos biology    45430     0 2021-05-18T00:00:00Z     1
#> 2 plos computational biology    68336     0 2021-05-18T00:00:00Z     1
#> 3              plos genetics    78511     0 2021-05-18T00:00:00Z     1
#> 4              plos medicine    33148     0 2021-05-18T00:00:00Z     1
#> 5                       none    57571     0 2012-10-23T00:00:00Z     1
```

First publication by journal


```r
cli$group(params = list(q = '*:*', group.field = 'journal', group.limit = 1,
                        group.sort = 'publication_date asc',
                        fl = c('publication_date', 'score'),
                        fq = "publication_date:[1900-01-01T00:00:00Z TO *]"))
#>                          groupValue numFound start     publication_date score
#> 1                      plos biology    45430     0 2003-08-18T00:00:00Z     1
#> 2        plos computational biology    68336     0 2005-06-24T00:00:00Z     1
#> 3                     plos genetics    78511     0 2005-06-17T00:00:00Z     1
#> 4                     plos medicine    33148     0 2004-09-07T00:00:00Z     1
#> 5                              none    57571     0 2005-08-23T00:00:00Z     1
#> 6              plos clinical trials      521     0 2006-04-21T00:00:00Z     1
#> 7  plos neglected tropical diseases    75150     0 2007-08-30T00:00:00Z     1
#> 8                    plos pathogens    73595     0 2005-07-22T00:00:00Z     1
#> 9                          plos one  2110161     0 2006-12-20T00:00:00Z     1
#> 10                     plos medicin        9     0 2012-04-17T00:00:00Z     1
```

Search group query : Last 3 publications of 2013.


```r
gq <- 'publication_date:[2013-01-01T00:00:00Z TO 2013-12-31T00:00:00Z]'
cli$group(
  params = list(q='*:*', group.query = gq,
                group.limit = 3, group.sort = 'publication_date desc',
                fl = 'publication_date'))
#>   numFound start     publication_date
#> 1   307446     0 2013-12-31T00:00:00Z
#> 2   307446     0 2013-12-31T00:00:00Z
#> 3   307446     0 2013-12-31T00:00:00Z
```

Search group with format simple


```r
cli$group(params = list(q='*:*', group.field='journal', rows=5,
                        group.limit=3, group.sort='publication_date desc',
                        group.format='simple', fl='journal, publication_date'))
#>   numFound start                    journal     publication_date
#> 1  2542432     0               PLOS Biology 2021-05-18T00:00:00Z
#> 2  2542432     0               PLOS Biology 2021-05-18T00:00:00Z
#> 3  2542432     0               PLOS Biology 2021-05-18T00:00:00Z
#> 4  2542432     0 PLOS Computational Biology 2021-05-18T00:00:00Z
#> 5  2542432     0 PLOS Computational Biology 2021-05-18T00:00:00Z
```

### Facet


```r
cli$facet(params = list(q='*:*', facet.field='journal', facet.query=c('cell', 'bird')))
#> $facet_queries
#> # A tibble: 2 x 2
#>   term   value
#>   <chr>  <int>
#> 1 cell  199069
#> 2 bird   21680
#> 
#> $facet_fields
#> $facet_fields$journal
#> # A tibble: 9 x 2
#>   term                             value  
#>   <chr>                            <chr>  
#> 1 plos one                         2110161
#> 2 plos genetics                    78511  
#> 3 plos neglected tropical diseases 75150  
#> 4 plos pathogens                   73595  
#> 5 plos computational biology       68336  
#> 6 plos biology                     45430  
#> 7 plos medicine                    33148  
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
#> 1 10.1371/journal.pone… Background: Binge drinking, an increasingly common form…
#> 2 10.1371/journal.pone… Background and Aim: Harmful <em>alcohol</em> consumptio…
```

### Stats


```r
out <- cli$stats(params = list(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), stats.facet='journal'))
```


```r
out$data
#>                   min     max count missing       sum sumOfSquares        mean
#> counter_total_all   0 2629673 57016       0 372950117 2.403729e+13 6541.148397
#> alm_twitterCount    0    3804 57016       0    322545 8.667376e+07    5.657096
#>                        stddev
#> counter_total_all 19463.00439
#> alm_twitterCount     38.57705
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
#> 1 10.1371/journal.pbio.1001805             26190
#> 2 10.1371/journal.pbio.1002559             15937
#> 3 10.1371/journal.pbio.0020440             26740
#> 4 10.1371/journal.pone.0072451              4734
#> 5 10.1371/journal.pone.0087217             23421
```


```r
out$mlt
#> $`10.1371/journal.pbio.1001805`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     5450     0 10.1371/journal.pone.0098876              4455
#> 2     5450     0 10.1371/journal.pone.0082578              3750
#> 3     5450     0 10.1371/journal.pcbi.1007811               927
#> 4     5450     0 10.1371/journal.pone.0193049              3532
#> 5     5450     0 10.1371/journal.pone.0102159              2889
#> 
#> $`10.1371/journal.pbio.1002559`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     6857     0 10.1371/journal.pone.0155028              5121
#> 2     6857     0 10.1371/journal.pone.0041684             32685
#> 3     6857     0 10.1371/journal.pone.0023086             10853
#> 4     6857     0 10.1371/journal.pone.0155989              4195
#> 5     6857     0 10.1371/journal.pone.0223982              1233
#> 
#> $`10.1371/journal.pbio.0020440`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     1567     0 10.1371/journal.pone.0162651              4238
#> 2     1567     0 10.1371/journal.pone.0003259              3615
#> 3     1567     0 10.1371/journal.pone.0102679              5924
#> 4     1567     0 10.1371/journal.pone.0068814             10451
#> 5     1567     0 10.1371/journal.pntd.0003377              5000
#> 
#> $`10.1371/journal.pone.0072451`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1    30732     0 10.1371/journal.pntd.0004689              8298
#> 2    30732     0 10.1371/journal.pone.0000461             20728
#> 3    30732     0 10.1371/journal.pone.0006532             26214
#> 4    30732     0 10.1371/journal.ppat.0020122             10449
#> 5    30732     0 10.1371/journal.pone.0106526              3821
#> 
#> $`10.1371/journal.pone.0087217`
#> # A tibble: 5 x 4
#>   numFound start id                           counter_total_all
#>      <int> <int> <chr>                                    <int>
#> 1     6320     0 10.1371/journal.pone.0175497              2712
#> 2     6320     0 10.1371/journal.pone.0204743               558
#> 3     6320     0 10.1371/journal.pone.0159131              7088
#> 4     6320     0 10.1371/journal.pone.0220409              2326
#> 5     6320     0 10.1371/journal.pone.0123774              2728
```

### Parsing

`solr_parse` is a general purpose parser function with extension methods `solr_parse.sr_search`, `solr_parse.sr_facet`, and `solr_parse.sr_high`, for parsing `solr_search`, `solr_facet`, and `solr_highlight` function output, respectively. `solr_parse` is used internally within those three functions (`solr_search`, `solr_facet`, `solr_highlight`) to do parsing. You can optionally get back raw `json` or `xml` from `solr_search`, `solr_facet`, and `solr_highlight` setting parameter `raw=TRUE`, and then parsing after the fact with `solr_parse`. All you need to know is `solr_parse` can parse

For example:


```r
(out <- cli$highlight(params = list(q='alcohol', hl.fl = 'abstract', rows=2),
                      raw=TRUE))
#> [1] "{\n  \"response\":{\"numFound\":36140,\"start\":0,\"maxScore\":4.629626,\"docs\":[\n      {\n        \"id\":\"10.1371/journal.pone.0218147\",\n        \"journal\":\"PLOS ONE\",\n        \"eissn\":\"1932-6203\",\n        \"publication_date\":\"2019-12-10T00:00:00Z\",\n        \"article_type\":\"Research Article\",\n        \"author_display\":[\"Victor M. Jimenez Jr.\",\n          \"Erik W. Settles\",\n          \"Bart J. Currie\",\n          \"Paul S. Keim\",\n          \"Fernando P. Monroy\"],\n        \"abstract\":[\"Background: Binge drinking, an increasingly common form of alcohol use disorder, is associated with substantial morbidity and mortality; yet, its effects on the immune system’s ability to defend against infectious agents are poorly understood. Burkholderia pseudomallei, the causative agent of melioidosis can occur in healthy humans, yet binge alcohol intoxication is increasingly being recognized as a major risk factor. Although our previous studies demonstrated that binge alcohol exposure increased B. pseudomallei near-neighbor virulence in vivo and increased paracellular diffusion and intracellular invasion, no experimental studies have examined the extent to which bacterial and alcohol dosage play a role in disease progression. In addition, the temporal effects of a single binge alcohol dose prior to infection has not been examined in vivo. Principal findings: In this study, we used B. thailandensis E264 a close genetic relative of B. pseudomallei, as useful BSL-2 model system. Eight-week-old female C57BL/6 mice were utilized in three distinct animal models to address the effects of 1) bacterial dosage, 2) alcohol dosage, and 3) the temporal effects, of a single binge alcohol episode. Alcohol was administered comparable to human binge drinking (≤ 4.4 g/kg) or PBS intraperitoneally before a non-lethal intranasal infection. Bacterial colonization of lung and spleen was increased in mice administered alcohol even after bacterial dose was decreased 10-fold. Lung and not spleen tissue were colonized even after alcohol dosage was decreased 20 times below the U.S legal limit. Temporally, a single binge alcohol episode affected lung bacterial colonization for more than 24 h after alcohol was no longer detected in the blood. Pulmonary and splenic cytokine expression (TNF-α, GM-CSF) remained suppressed, while IL-12/p40 increased in mice administered alcohol 6 or 24 h prior to infection. Increased lung and not intestinal bacterial invasion was observed in human and murine non-phagocytic epithelial cells exposed to 0.2% v/v alcohol in vitro. Conclusions: Our results indicate that the effects of a single binge alcohol episode are tissue specific. A single binge alcohol intoxication event increases bacterial colonization in mouse lung tissue even after very low BACs and decreases the dose required to colonize the lungs with less virulent B. thailandensis. Additionally, the temporal effects of binge alcohol alters lung and spleen cytokine expression for at least 24 h after alcohol is detected in the blood. Delayed recovery in lung and not spleen tissue may provide a means for B. pseudomallei and near-neighbors to successfully colonize lung tissue through increased intracellular invasion of non-phagocytic cells in patients with hazardous alcohol intake. \"],\n        \"title_display\":\"Persistence of <i>Burkholderia thailandensis</i> E264 in lung tissue after a single binge alcohol episode\",\n        \"score\":4.629626},\n      {\n        \"id\":\"10.1371/journal.pone.0138021\",\n        \"journal\":\"PLOS ONE\",\n        \"eissn\":\"1932-6203\",\n        \"publication_date\":\"2015-09-16T00:00:00Z\",\n        \"article_type\":\"Research Article\",\n        \"author_display\":[\"Pavel Grigoriev\",\n          \"Evgeny M. Andreev\"],\n        \"abstract\":[\"Background and Aim: Harmful alcohol consumption has long been recognized as being the major determinant of male premature mortality in the European countries of the former USSR. Our focus here is on Belarus and Russia, two Slavic countries which continue to suffer enormously from the burden of the harmful consumption of alcohol. However, after a long period of deterioration, mortality trends in these countries have been improving over the past decade. We aim to investigate to what extent the recent declines in adult mortality in Belarus and Russia are attributable to the anti-alcohol measures introduced in these two countries in the 2000s. Data and Methods: We rely on the detailed cause-specific mortality series for the period 1980–2013. Our analysis focuses on the male population, and considers only a limited number of causes of death which we label as being alcohol-related: accidental poisoning by alcohol, liver cirrhosis, ischemic heart diseases, stroke, transportation accidents, and other external causes. For each of these causes we computed age-standardized death rates. The life table decomposition method was used to determine the age groups and the causes of death responsible for changes in life expectancy over time. Conclusion: Our results do not lead us to conclude that the schedule of anti-alcohol measures corresponds to the schedule of mortality changes. The continuous reduction in adult male mortality seen in Belarus and Russia cannot be fully explained by the anti-alcohol policies implemented in these countries, although these policies likely contributed to the large mortality reductions observed in Belarus and Russia in 2005–2006 and in Belarus in 2012. Thus, the effects of these policies appear to have been modest. We argue that the anti-alcohol measures implemented in Belarus and Russia simply coincided with fluctuations in alcohol-related mortality which originated in the past. If these trends had not been underway already, these huge mortality effects would not have occurred. \"],\n        \"title_display\":\"The Huge Reduction in Adult Male Mortality in Belarus and Russia: Is It Attributable to Anti-Alcohol Measures?\",\n        \"score\":4.627285}]\n  },\n  \"highlighting\":{\n    \"10.1371/journal.pone.0218147\":{\n      \"abstract\":[\"Background: Binge drinking, an increasingly common form of <em>alcohol</em> use disorder, is associated\"]},\n    \"10.1371/journal.pone.0138021\":{\n      \"abstract\":[\"Background and Aim: Harmful <em>alcohol</em> consumption has long been recognized as being the major\"]}}}\n"
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
#> 1 10.1371/journal.pone… Background: Binge drinking, an increasingly common form…
#> 2 10.1371/journal.pone… Background and Aim: Harmful <em>alcohol</em> consumptio…
```

### Progress bars

only supported in the core search methods: `search`, `facet`, `group`, `mlt`, `stats`, `high`, `all`


```r
library(httr)
invisible(cli$search(params = list(q='*:*', rows=100, fl='id'), progress = httr::progress()))
|==============================================| 100%
```

### Advanced: Function Queries

Function Queries allow you to query on actual numeric fields in the SOLR database, and do addition, multiplication, etc on one or many fields to sort results. For example, here, we search on the product of counter_total_all and alm_twitterCount, using a new temporary field "_val_"


```r
cli$search(params = list(q='_val_:"product(counter_total_all,alm_twitterCount)"',
  rows=5, fl='id,title', fq='doc_type:full'))
#> # A tibble: 5 x 2
#>   id                     title                                                  
#>   <chr>                  <chr>                                                  
#> 1 10.1371/journal.pmed.… Why Most Published Research Findings Are False         
#> 2 10.1371/journal.pcbi.… Ten simple rules for structuring papers                
#> 3 10.1371/journal.pone.… A Multi-Level Bayesian Analysis of Racial Bias in Poli…
#> 4 10.1371/journal.pone.… Long-Term Follow-Up of Transsexual Persons Undergoing …
#> 5 10.1371/journal.pone.… More than 75 percent decline over 27 years in total fl…
```

Here, we search for the papers with the most citations


```r
cli$search(params = list(q='_val_:"max(counter_total_all)"',
    rows=5, fl='id,counter_total_all', fq='doc_type:full'))
#> # A tibble: 5 x 2
#>   id                           counter_total_all
#>   <chr>                                    <int>
#> 1 10.1371/journal.pmed.0020124           3256592
#> 2 10.1371/journal.pone.0133079           2629673
#> 3 10.1371/journal.pcbi.1003149           1794503
#> 4 10.1371/journal.pmed.1000376           1249497
#> 5 10.1371/journal.pmed.1000097           1012313
```

Or with the most tweets


```r
cli$search(params = list(q='_val_:"max(alm_twitterCount)"',
    rows=5, fl='id,alm_twitterCount', fq='doc_type:full'))
#> # A tibble: 5 x 2
#>   id                           alm_twitterCount
#>   <chr>                                   <int>
#> 1 10.1371/journal.pcbi.1005619             4935
#> 2 10.1371/journal.pmed.0020124             3890
#> 3 10.1371/journal.pone.0141854             3804
#> 4 10.1371/journal.pone.0115069             3083
#> 5 10.1371/journal.pmed.1001953             2825
```

### Using specific data sources

__USGS BISON service__

The occurrences service


```r
conn <- SolrClient$new(scheme = "https", host = "bison.usgs.gov", path = "solr/occurrences/select", port = NULL)
conn$search(params = list(q = '*:*', fl = c('decimalLatitude','decimalLongitude','scientificName'), rows = 2))
#> # A tibble: 2 x 3
#>   decimalLongitude scientificName     decimalLatitude
#>              <dbl> <chr>                        <dbl>
#> 1            -95.7 Oreothlypis celata            30.1
#> 2            -75.9 Oreothlypis celata            45.4
```

The species names service


```r
conn <- SolrClient$new(scheme = "https", host = "bison.usgs.gov", path = "solr/scientificName/select", port = NULL)
conn$search(params = list(q = '*:*'))
#> # A tibble: 10 x 2
#>    scientificName              `_version_`
#>    <chr>                             <dbl>
#>  1 Epuraea ambigua                 1.68e18
#>  2 Dictyopteris polypodioides      1.68e18
#>  3 Lonicera iberica                1.68e18
#>  4 Pseudopomala brachyptera        1.68e18
#>  5 Oceanococcus                    1.68e18
#>  6 Mactra alata                    1.68e18
#>  7 Reithrodontomys wetmorei        1.68e18
#>  8 Cristellaria orelliana          1.68e18
#>  9 Syringopora rara                1.68e18
#> 10 Aster cordifolius alvearius     1.68e18
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
* Please note that this package is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.
