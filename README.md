solr
=======

**A general purpose R interface to [Solr](http://lucene.apache.org/solr/)**

### Information

+ [Solr home page](http://lucene.apache.org/solr/)
+ [Highlighting help](http://wiki.apache.org/solr/HighlightingParameters)
+ [Faceting help](http://wiki.apache.org/solr/SimpleFacetParameters)
+ [Installing Solr on Mac using homebrew](http://ramlev.dk/blog/2012/06/02/install-apache-solr-on-your-mac/)

### Quick start

**Install**

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
sss
```

```coffee
sss
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