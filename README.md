solr
=======

[![Build Status](https://api.travis-ci.org/ropensci/solr.png)](https://travis-ci.org/ropensci/solr)

**A general purpose R interface to [Solr](http://lucene.apache.org/solr/)**

This package only deals with exracting data from a Solr endpoint, not writing data (pull request or holla if you're interested in writing solr data).

### Solr info

+ [Solr home page](http://lucene.apache.org/solr/)
+ [Highlighting help](http://wiki.apache.org/solr/HighlightingParameters)
+ [Faceting help](http://wiki.apache.org/solr/SimpleFacetParameters)
+ [Installing Solr on Mac using homebrew](http://ramlev.dk/blog/2012/06/02/install-apache-solr-on-your-mac/)
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
solr_search(q='*:*', rows=2, fl='id', url=url, key=key)
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

**Facet**

```coffee
solr_facet(q='*:*', facet.field='journal', facet.query='cell,bird', url=url, key=key)
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
solr_highlight(q='alcohol', hl.fl = 'abstract', rows=2, url = url, key=key)
```

```coffee
$`10.1371/journal.pmed.0040151`
$`10.1371/journal.pmed.0040151`$abstract
[1] "Background: <em>Alcohol</em> consumption causes an estimated 4% of the global disease burden, prompting"

$`10.1371/journal.pone.0027752`
$`10.1371/journal.pone.0027752`$abstract
[1] "Background: The negative influences of <em>alcohol</em> on TB management with regard to delays in seeking"
```

**Parsing**

`solr_parse` is a general purpose parser function with extension methods `solr_parse.sr_search`, `solr_parse.sr_facet`, and `solr_parse.sr_high`, for parsing `solr_search`, `solr_facet`, and `solr_highlight` function output, respectively. `solr_parse` is used internally within those three functions (`solr_search`, `solr_facet`, `solr_highlight`) to do parsing. You can optionally get back raw `json` or `xml` from `solr_search`, `solr_facet`, and `solr_highlight` setting parameter `raw=TRUE`, and then parsing after the fact with `solr_parse`. All you need to know is `solr_parse` can parse 

For example:

```coffee
url <- 'http://api.plos.org/search'
key <- getOption('PlosApiKey')

(out <- solr_highlight(q='alcohol', hl.fl = 'abstract', rows=2, url = url, key=key, raw=TRUE))
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

**Using specific data sources**

*USGS BISON service*

The occurrences service

```coffee
url <- "http://bisonapi.usgs.ornl.gov/solr/occurrences/select"
solr_search(q='*:*', fl='latitude,longitude,scientific_name', url=url)
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
solr_search(q='*:*', url=url2, raw=TRUE)
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
    url = {https://github.com/ropensci/solr},
  }
```

Get citation information for `solr` in R doing `citation(package = 'solr')`

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)