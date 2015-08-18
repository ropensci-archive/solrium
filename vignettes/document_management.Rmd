<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Document management}
%\VignetteEncoding{UTF-8}
-->



Document management
===================

## Installation

Stable version from CRAN


```r
install.packages("solr")
```

Or the development version from GitHub


```r
install.packages("devtools")
devtools::install_github("ropensci/solr")
```

Load


```r
library("solr")
```

Initialize connection. By default, you connect to `http://localhost:8983`


```r
solr_connect()
```

```
#> <solr_connection>
#>   url:    http://localhost:8983
#>   errors: simple
#>   verbose: TRUE
#>   proxy:
```

## Create documents from R objects

For now, only lists and data.frame's supported.

### data.frame


```r
file <- system.file("examples", "books.csv", package = "solr")
(x <- read.csv(file))
```

```
#>            id  cat                  name price inStock             author
#> 1  0553573403 book     A Game of Thrones  7.99    true George R.R. Martin
#> 2  0553579908 book      A Clash of Kings  7.99    true George R.R. Martin
#> 3  055357342X book     A Storm of Swords  7.99    true George R.R. Martin
#> 4  0553293354 book            Foundation  7.99    true       Isaac Asimov
#> 5  0812521390 book     The Black Company  6.99   false          Glen Cook
#> 6  0812550706 book          Ender's Game  6.99    true   Orson Scott Card
#> 7  0441385532 book                Jhereg  7.95   false       Steven Brust
#> 8  0380014300 book Nine Princes In Amber  6.99    true      Roger Zelazny
#> 9  0805080481 book     The Book of Three  5.99    true    Lloyd Alexander
#> 10 080508049X book    The Black Cauldron  5.99    true    Lloyd Alexander
#>                               series_t sequence_i genre_s
#> 1               A Song of Ice and Fire          1 fantasy
#> 2               A Song of Ice and Fire          2 fantasy
#> 3               A Song of Ice and Fire          3 fantasy
#> 4                    Foundation Novels          1   scifi
#> 5  The Chronicles of The Black Company          1 fantasy
#> 6                                Ender          1   scifi
#> 7                          Vlad Taltos          1 fantasy
#> 8              the Chronicles of Amber          1 fantasy
#> 9            The Chronicles of Prydain          1 fantasy
#> 10           The Chronicles of Prydain          2 fantasy
```


```r
add(x, "gettingstarted")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 58
```

### list




```r
ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
add(ss, "gettingstarted")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 24
```

## Delete documents

### By id

Add some documents first




```r
docs <- list(list(id = 1, price = 100, name = "brown"),
             list(id = 2, price = 500, name = "blue"),
             list(id = 3, price = 2000L, name = "pink"))
add(docs, "gettingstarted")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 17
```

And the documents are now in your Solr database


```r
tail(solr_search(name = "gettingstarted", "*:*", base = "http://localhost:8983/solr/select", rows = 100))
```

```
#> Source: local data frame [6 x 10]
#> 
#>           id  cat                  name   price inStock          author
#> 1 0380014300 book Nine Princes In Amber    6.99    TRUE   Roger Zelazny
#> 2 0805080481 book     The Book of Three    5.99    TRUE Lloyd Alexander
#> 3 080508049X book    The Black Cauldron    5.99    TRUE Lloyd Alexander
#> 4          1   NA                 brown  100.00      NA              NA
#> 5          2   NA                  blue  500.00      NA              NA
#> 6          3   NA                  pink 2000.00      NA              NA
#> Variables not shown: series_t (chr), sequence_i (int), genre_s (chr),
#>   _version_ (dbl)
```

Now delete those documents just added


```r
delete_by_id(ids = c(1, 2, 3), "gettingstarted")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 9
```

And now they are gone


```r
tail(solr_search("gettingstarted", "*:*", base = "http://localhost:8983/solr/select", rows = 100))
```

```
#> Source: local data frame [6 x 10]
#> 
#>           id  cat                  name price inStock           author
#> 1 0812521390 book     The Black Company  6.99   FALSE        Glen Cook
#> 2 0812550706 book          Ender's Game  6.99    TRUE Orson Scott Card
#> 3 0441385532 book                Jhereg  7.95   FALSE     Steven Brust
#> 4 0380014300 book Nine Princes In Amber  6.99    TRUE    Roger Zelazny
#> 5 0805080481 book     The Book of Three  5.99    TRUE  Lloyd Alexander
#> 6 080508049X book    The Black Cauldron  5.99    TRUE  Lloyd Alexander
#> Variables not shown: series_t (chr), sequence_i (int), genre_s (chr),
#>   _version_ (dbl)
```

### By query

Add some documents first


```r
add(docs, "gettingstarted")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 19
```

And the documents are now in your Solr database


```r
tail(solr_search("gettingstarted", "*:*", base = "http://localhost:8983/solr/select", rows = 100))
```

```
#> Source: local data frame [6 x 10]
#> 
#>           id  cat                  name   price inStock          author
#> 1 0380014300 book Nine Princes In Amber    6.99    TRUE   Roger Zelazny
#> 2 0805080481 book     The Book of Three    5.99    TRUE Lloyd Alexander
#> 3 080508049X book    The Black Cauldron    5.99    TRUE Lloyd Alexander
#> 4          1   NA                 brown  100.00      NA              NA
#> 5          2   NA                  blue  500.00      NA              NA
#> 6          3   NA                  pink 2000.00      NA              NA
#> Variables not shown: series_t (chr), sequence_i (int), genre_s (chr),
#>   _version_ (dbl)
```

Now delete those documents just added


```r
delete_by_query(query = "(name:blue OR name:pink)", "gettingstarted")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 11
```

And now they are gone


```r
tail(solr_search("gettingstarted", "*:*", base = "http://localhost:8983/solr/select", rows = 100))
```

```
#> Source: local data frame [6 x 10]
#> 
#>           id  cat                  name  price inStock           author
#> 1 0812550706 book          Ender's Game   6.99    TRUE Orson Scott Card
#> 2 0441385532 book                Jhereg   7.95   FALSE     Steven Brust
#> 3 0380014300 book Nine Princes In Amber   6.99    TRUE    Roger Zelazny
#> 4 0805080481 book     The Book of Three   5.99    TRUE  Lloyd Alexander
#> 5 080508049X book    The Black Cauldron   5.99    TRUE  Lloyd Alexander
#> 6          1   NA                 brown 100.00      NA               NA
#> Variables not shown: series_t (chr), sequence_i (int), genre_s (chr),
#>   _version_ (dbl)
```

## Update documents from files

This approach is best if you have many different things you want to do at once, e.g., delete and add files and set any additional options. The functions are:

* `update_xml()`
* `update_json()`
* `update_csv()`

There are separate functions for each of the data types as they take slightly different parameters - and to make it more clear that those are the three input options for data types.

### XML


```r
file <- system.file("examples", "books.xml", package = "solr")
update_xml(file, "books")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 64
```

### JSON


```r
file <- system.file("examples", "books.json", package = "solr")
update_json(file, "books")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 40
```

### CSV


```r
file <- system.file("examples", "books.csv", package = "solr")
update_csv(file, "books")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 16
```

### Add and delete in the same file

Add a document first, that we can later delete


```r
ss <- list(list(id = 456, name = "cat"))
add(ss, "books")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 23
```

Now add a new document, and delete the one we just made


```r
file <- system.file("examples", "add_delete.xml", package = "solr")
cat(readLines(file), sep = "\n")
```

```
#> <update>
#> 	<add>
#> 	  <doc>
#> 	    <field name="id">978-0641723445</field>
#> 	    <field name="cat">book,hardcover</field>
#> 	    <field name="name">The Lightning Thief</field>
#> 	    <field name="author">Rick Riordan</field>
#> 	    <field name="series_t">Percy Jackson and the Olympians</field>
#> 	    <field name="sequence_i">1</field>
#> 	    <field name="genre_s">fantasy</field>
#> 	    <field name="inStock">TRUE</field>
#> 	    <field name="price">12.5</field>
#> 	    <field name="pages_i">384</field>
#> 	  </doc>
#> 	</add>
#> 	<delete>
#> 		<id>456</id>
#> 	</delete>
#> </update>
```

```r
update_xml(file, "books")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 20
```

### Notes

Note that `update_xml()` and `update_json()` have exactly the same parameters, but simply use different data input formats. `update_csv()` is different in that you can't provide document or field level boosts or other modifications. In addition `update_csv()` can accept not just csv, but tsv and other types of separators.

