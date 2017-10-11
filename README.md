solrium
=======



[![Build Status](https://api.travis-ci.org/ropensci/solrium.png)](https://travis-ci.org/ropensci/solrium)
[![codecov.io](https://codecov.io/github/ropensci/solrium/coverage.svg?branch=master)](https://codecov.io/github/ropensci/solrium?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/solrium?color=2ED968)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/solrium)](https://cran.r-project.org/package=solrium)

**A general purpose R interface to [Solr](http://lucene.apache.org/solr/)**

Development is now following Solr v7 and greater - which introduced many changes, which means many functions here may not work with your Solr installation older than v7.

Be aware that currently some functions will only work in certain Solr modes, e.g, `collection_create()` won't work when you are not in Solrcloud mode. But, you should get an error message stating that you aren't.

> Currently developing against Solr `v7.0.0`

> Note that we recently changed the package name to `solrium`. A previous version of this package is on CRAN as `solr`, but next version will be up as `solrium`.

## Solr info

+ [Solr home page](http://lucene.apache.org/solr/)
+ [Highlighting help](http://wiki.apache.org/solr/HighlightingParameters)
+ [Faceting help](http://wiki.apache.org/solr/SimpleFacetParameters)
+ [Solr stats](http://wiki.apache.org/solr/StatsComponent)
+ ['More like this' searches](http://wiki.apache.org/solr/MoreLikeThis)
+ [Grouping/Feild collapsing](http://wiki.apache.org/solr/FieldCollapsing)
+ [Install and Setup SOLR in OSX, including running Solr](http://risnandar.wordpress.com/2013/09/08/how-to-install-and-setup-apache-lucene-solr-in-osx/)
+ [Solr csv writer](http://wiki.apache.org/solr/CSVResponseWriter)

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
#>                                        id
#>                                     <chr>
#> 1       10.1371/journal.pone.0079968/body
#> 2 10.1371/journal.pone.0093791/references
```

### Search grouped data

Most recent publication by journal


```r
cli$group(params = list(q='*:*', group.field='journal', rows=5, group.limit=1,
                        group.sort='publication_date desc', 
                        fl='publication_date, score'))
#>                         groupValue numFound start     publication_date
#> 1                         plos one  1559942     0 2017-10-06T00:00:00Z
#> 2                   plos pathogens    52939     0 2017-10-06T00:00:00Z
#> 3 plos neglected tropical diseases    46912     0 2017-10-06T00:00:00Z
#> 4       plos computational biology    45166     0 2017-10-06T00:00:00Z
#> 5                             none    63551     0 2012-10-23T00:00:00Z
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
#> 1                          plos one  1559942     0 2006-12-20T00:00:00Z
#> 2                    plos pathogens    52939     0 2005-07-22T00:00:00Z
#> 3  plos neglected tropical diseases    46912     0 2007-08-30T00:00:00Z
#> 4        plos computational biology    45166     0 2005-06-24T00:00:00Z
#> 5                              none    57532     0 2005-08-23T00:00:00Z
#> 6                     plos genetics    59539     0 2005-06-17T00:00:00Z
#> 7                      plos biology    32411     0 2003-08-18T00:00:00Z
#> 8                     plos medicine    23375     0 2004-09-07T00:00:00Z
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
#>   numFound start        journal     publication_date
#> 1  1884365     0       PLOS ONE 2017-10-06T00:00:00Z
#> 2  1884365     0       PLOS ONE 2017-10-06T00:00:00Z
#> 3  1884365     0       PLOS ONE 2017-10-06T00:00:00Z
#> 4  1884365     0 PLOS Pathogens 2017-10-06T00:00:00Z
#> 5  1884365     0 PLOS Pathogens 2017-10-06T00:00:00Z
```

### Facet


```r
cli$facet(params = list(q='*:*', facet.field='journal', facet.query=c('cell', 'bird')))
#> $facet_queries
#> # A tibble: 2 x 2
#>    term  value
#>   <chr>  <int>
#> 1  cell 156660
#> 2  bird  16271
#> 
#> $facet_fields
#> $facet_fields$journal
#> # A tibble: 9 x 2
#>                               term   value
#>                              <chr>   <chr>
#> 1                         plos one 1559942
#> 2                    plos genetics   59539
#> 3                   plos pathogens   52939
#> 4 plos neglected tropical diseases   46912
#> 5       plos computational biology   45166
#> 6                     plos biology   32411
#> 7                    plos medicine   23375
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
#> 1 10.1371/journal.pmed.0040151
#> 2 10.1371/journal.pone.0027752
#> # ... with 1 more variables: abstract <chr>
```

### Stats


```r
out <- cli$stats(params = list(q='ecology', stats.field=c('counter_total_all','alm_twitterCount'), stats.facet='journal'))
```


```r
out$data
#>                   min    max count missing       sum sumOfSquares
#> counter_total_all   0 880122 40152       0 214426319 7.214749e+12
#> alm_twitterCount    0   3391 40152       0    276142 6.975651e+07
#>                          mean      stddev
#> counter_total_all 5340.364590 12295.12865
#> alm_twitterCount     6.877416    41.11027
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
#> 1 10.1371/journal.pbio.1001805             21600
#> 2 10.1371/journal.pbio.0020440             25228
#> 3 10.1371/journal.pbio.1002559              9542
#> 4 10.1371/journal.pone.0087217             11113
#> 5 10.1371/journal.pbio.1002191             21732
```


```r
out$mlt
#> $`10.1371/journal.pbio.1001805`
#> # A tibble: 5 x 4
#>   numFound start                           id counter_total_all
#>      <int> <int>                        <chr>             <int>
#> 1     3790     0 10.1371/journal.pone.0082578              2860
#> 2     3790     0 10.1371/journal.pone.0098876              3545
#> 3     3790     0 10.1371/journal.pone.0102159              1979
#> 4     3790     0 10.1371/journal.pcbi.1003408              9803
#> 5     3790     0 10.1371/journal.pone.0087380              2997
#> 
#> $`10.1371/journal.pbio.0020440`
#> # A tibble: 5 x 4
#>   numFound start                           id counter_total_all
#>      <int> <int>                        <chr>             <int>
#> 1     1103     0 10.1371/journal.pone.0162651              2761
#> 2     1103     0 10.1371/journal.pone.0035964              7548
#> 3     1103     0 10.1371/journal.pone.0102679              4540
#> 4     1103     0 10.1371/journal.pone.0003259              3204
#> 5     1103     0 10.1371/journal.pntd.0003377              4249
#> 
#> $`10.1371/journal.pbio.1002559`
#> # A tibble: 5 x 4
#>   numFound start                           id counter_total_all
#>      <int> <int>                        <chr>             <int>
#> 1     5445     0 10.1371/journal.pone.0155989              2455
#> 2     5445     0 10.1371/journal.pbio.0060300             17247
#> 3     5445     0 10.1371/journal.pone.0012852              2915
#> 4     5445     0 10.1371/journal.pone.0173249               851
#> 5     5445     0 10.1371/journal.pone.0164330               924
#> 
#> $`10.1371/journal.pone.0087217`
#> # A tibble: 5 x 4
#>   numFound start                           id counter_total_all
#>      <int> <int>                        <chr>             <int>
#> 1     4543     0 10.1371/journal.pone.0175497              1005
#> 2     4543     0 10.1371/journal.pone.0159131              4616
#> 3     4543     0 10.1371/journal.pone.0131665              1171
#> 4     4543     0 10.1371/journal.pcbi.0020092             24524
#> 5     4543     0 10.1371/journal.pone.0133941              1303
#> 
#> $`10.1371/journal.pbio.1002191`
#> # A tibble: 5 x 4
#>   numFound start                           id counter_total_all
#>      <int> <int>                        <chr>             <int>
#> 1    12500     0 10.1371/journal.pbio.1002232              3029
#> 2    12500     0 10.1371/journal.pone.0131700              2405
#> 3    12500     0 10.1371/journal.pone.0070448              2184
#> 4    12500     0 10.1371/journal.pone.0052330              9467
#> 5    12500     0 10.1371/journal.pone.0028737             11044
```

### Parsing

`solr_parse` is a general purpose parser function with extension methods `solr_parse.sr_search`, `solr_parse.sr_facet`, and `solr_parse.sr_high`, for parsing `solr_search`, `solr_facet`, and `solr_highlight` function output, respectively. `solr_parse` is used internally within those three functions (`solr_search`, `solr_facet`, `solr_highlight`) to do parsing. You can optionally get back raw `json` or `xml` from `solr_search`, `solr_facet`, and `solr_highlight` setting parameter `raw=TRUE`, and then parsing after the fact with `solr_parse`. All you need to know is `solr_parse` can parse

For example:


```r
(out <- cli$highlight(params = list(q='alcohol', hl.fl = 'abstract', rows=2),
                      raw=TRUE))
#> [1] "{\"response\":{\"numFound\":25768,\"start\":0,\"maxScore\":1.0931722,\"docs\":[{\"id\":\"10.1371/journal.pmed.0040151\",\"journal\":\"PLoS Medicine\",\"eissn\":\"1549-1676\",\"publication_date\":\"2007-04-24T00:00:00Z\",\"article_type\":\"Research Article\",\"author_display\":[\"Donald A Brand\",\"Michaela Saisana\",\"Lisa A Rynn\",\"Fulvia Pennoni\",\"Albert B Lowenfels\"],\"abstract\":[\"Background: Alcohol consumption causes an estimated 4% of the global disease burden, prompting goverments to impose regulations to mitigate the adverse effects of alcohol. To assist public health leaders and policymakers, the authors developed a composite indicator—the Alcohol Policy Index—to gauge the strength of a country's alcohol control policies. Methods and Findings: The Index generates a score based on policies from five regulatory domains—physical availability of alcohol, drinking context, alcohol prices, alcohol advertising, and operation of motor vehicles. The Index was applied to the 30 countries that compose the Organization for Economic Cooperation and Development and regression analysis was used to examine the relationship between policy score and per capita alcohol consumption. Countries attained a median score of 42.4 of a possible 100 points, ranging from 14.5 (Luxembourg) to 67.3 (Norway). The analysis revealed a strong negative correlation between score and consumption (r = −0.57; p = 0.001): a 10-point increase in the score was associated with a one-liter decrease in absolute alcohol consumption per person per year (95% confidence interval, 0.4–1.5 l). A sensitivity analysis demonstrated the robustness of the Index by showing that countries' scores and ranks remained relatively stable in response to variations in methodological assumptions. Conclusions: The strength of alcohol control policies, as estimated by the Alcohol Policy Index, varied widely among 30 countries located in Europe, Asia, North America, and Australia. The study revealed a clear inverse relationship between policy strength and alcohol consumption. The Index provides a straightforward tool for facilitating international comparisons. In addition, it can help policymakers review and strengthen existing regulations aimed at minimizing alcohol-related harm and estimate the likely impact of policy changes. \\n        Using an index that gauges the strength of national alcohol policies, a clear inverse relationship was found between policy strength and alcohol consumption.\\n      Background.: Alcohol drinking is now recognized as one of the most important risks to human health. Previous research studies (see the research article by Rodgers et al., linked below) have predicted that around 4% of the burden of disease worldwide comes about as a result of drinking alcohol, which can be a factor in a wide range of health problems. These include chronic diseases such as cirrhosis of the liver and certain cancers, as well as poor health resulting from trauma, violence, and accidental injuries. For these reasons, most governments try to control the consumption of alcohol through laws, although very few countries ban alcohol entirely. Why Was This Study Done?: Although bodies such as the World Health Assembly have recommended that its member countries develop national control policies to prevent excessive alcohol use, there is a huge variation between national policies. It is also very unclear whether there is any link between the strictness of legislation regarding alcohol control in any given country and how much people in that country actually drink. What Did the Researchers Do and Find?: The researchers carrying out this study had two broad goals. First, they wanted to develop an index (or scoring system) that would allow them and others to rate the strength of any given country's alcohol control policy. Second, they wanted to see whether there is any link between the strength of control policies on this index and the amount of alcohol that is drunk by people on average in each country. In order to develop the alcohol control index, the researchers chose five main areas relating to alcohol control. These five areas related to the availability of alcohol, the “drinking context,” pricing, advertising, and vehicles. Within each policy area, specific policy topics relating to prevention of alcohol consumption and harm were identified. Then, each of 30 countries within the OECD (Organization for Economic Cooperation and Development) were rated on this index using recent data from public reports and databases. The researchers also collected data on alcohol consumption within each country from the World Health Organization and used this to estimate the average amount drunk per person in a year. When the researchers plotted scores on their index against the average amount drunk per person per year, they saw a negative correlation. That is, the stronger the alcohol control policy in any given country, the less people seemed to drink. This worked out at around roughly a 10-point increase on the index equating to a one-liter drop in alcohol consumption per person per year. However, some countries did not seem to fit these predictions very well. What Do These Findings Mean?: The finding that there is a link between the strength of alcohol control policies and amount of alcohol drinking does not necessarily mean that greater government control causes lower drinking rates. The relationship might just mean that some other variable (e.g., some cultural factor) plays a role in determining the amount that people drink as well as affecting national policies for alcohol control. However, the index developed here is a useful method for researchers and policy makers to measure changes in alcohol controls and therefore understand more clearly the factors that affect drinking rates. This study looked only at the connection between control measures and extent of alcohol consumption, and did not examine alcohol-related harm. Future research might focus on the links between controls and the harms caused by alcohol. Additional Information.: Please access these Web sites via the online version of this summary at http://dx.doi.org/10.1371/journal.pmed.0040151. \"],\"title_display\":\"Comparative Analysis of Alcohol Control Policies in 30 Countries\",\"score\":1.0931722},{\"id\":\"10.1371/journal.pone.0027752\",\"journal\":\"PLoS ONE\",\"eissn\":\"1932-6203\",\"publication_date\":\"2011-11-21T00:00:00Z\",\"article_type\":\"Research Article\",\"author_display\":[\"Beena Thomas\",\"Mohanarani Suhadev\",\"Jamuna Mani\",\"B. Gopala Ganapathy\",\"Asaithambi Armugam\",\"F. Faizunnisha\",\"Mohanasundari Chelliah\",\"Fraser Wares\"],\"abstract\":[\"Background: The negative influences of alcohol on TB management with regard to delays in seeking care as well as non compliance for treatment has been well documented. This study is part of a larger study on the prevalence of AUD (Alcohol Use Disorder) among TB patients which revealed that almost a quarter of TB patients who consumed alcohol could be classified as those who had AUD. However there is dearth of any effective alcohol intervention programme for TB patients with Alcohol Use Disorder (AUD). Methodology: This qualitative study using the ecological system model was done to gain insights into the perceived effect of alcohol use on TB treatment and perceived necessity of an intervention programme for TB patients with AUD. We used purposive sampling to select 44 men from 73 TB patients with an AUDIT score >8. Focus group discussions (FGDs) and interviews were conducted with TB patients with AUD, their family members and health providers. Results: TB patients with AUD report excessive alcohol intake as one of the reasons for their vulnerability for TB. Peer pressure has been reported by many as the main reason for alcohol consumption. The influences of alcohol use on TB treatment has been elaborated especially with regard to the fears around the adverse effects of alcohol on TB drugs and the fear of being reprimanded by health providers. The need for alcohol intervention programs was expressed by the TB patients, their families and health providers. Suggestions for the intervention programmes included individual and group sessions, involvement of family members, audiovisual aids and the importance of sensitization by health staff. Conclusions: The findings call for urgent need based interventions which need to be pilot tested with a randomized control trial to bring out a model intervention programme for TB patients with AUD. \"],\"title_display\":\"Feasibility of an Alcohol Intervention Programme for TB Patients with Alcohol Use Disorder (AUD) - A Qualitative Study from Chennai, South India\",\"score\":1.0918049}]},\"highlighting\":{\"10.1371/journal.pmed.0040151\":{\"abstract\":[\"Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting\"]},\"10.1371/journal.pone.0027752\":{\"abstract\":[\"Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking\"]}}}\n"
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
#> 1 10.1371/journal.pmed.0040151
#> 2 10.1371/journal.pone.0027752
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
#> 3 10.1371/journal.pone.0153419
#> 4 10.1371/journal.pone.0073791
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
#> 1 10.1371/journal.pone.0141854             3391
#> 2 10.1371/journal.pmed.0020124             3164
#> 3 10.1371/journal.pone.0115069             2867
#> 4 10.1371/journal.pmed.1001953             2820
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
