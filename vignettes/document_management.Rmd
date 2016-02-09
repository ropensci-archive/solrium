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
install.packages("solrium")
```

Or the development version from GitHub


```r
install.packages("devtools")
devtools::install_github("ropensci/solrium")
```

Load


```r
library("solrium")
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
df <- data.frame(id = c(67, 68), price = c(1000, 500000000))
add(df, "books")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 112
```

### list




```r
ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
add(ss, "books")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 16
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
#> [1] 18
```

And the documents are now in your Solr database


```r
tail(solr_search(name = "gettingstarted", "*:*", base = "http://localhost:8983/solr/select", rows = 100))
```

```
#> Source: local data frame [3 x 4]
#> 
#>      id price  name    _version_
#>   (chr) (int) (chr)        (dbl)
#> 1     1   100 brown 1.525729e+18
#> 2     2   500  blue 1.525729e+18
#> 3     3  2000  pink 1.525729e+18
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
#> [1] 24
```

And now they are gone


```r
tail(solr_search("gettingstarted", "*:*", base = "http://localhost:8983/solr/select", rows = 100))
```

```
#> Source: local data frame [0 x 0]
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
#> Source: local data frame [3 x 4]
#> 
#>      id price  name    _version_
#>   (chr) (int) (chr)        (dbl)
#> 1     1   100 brown 1.525729e+18
#> 2     2   500  blue 1.525729e+18
#> 3     3  2000  pink 1.525729e+18
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
#> [1] 12
```

And now they are gone


```r
tail(solr_search("gettingstarted", "*:*", base = "http://localhost:8983/solr/select", rows = 100))
```

```
#> Source: local data frame [1 x 4]
#> 
#>      id price  name    _version_
#>   (chr) (int) (chr)        (dbl)
#> 1     1   100 brown 1.525729e+18
```

## Update documents from files

This approach is best if you have many different things you want to do at once, e.g., delete and add files and set any additional options. The functions are:

* `update_xml()`
* `update_json()`
* `update_csv()`

There are separate functions for each of the data types as they take slightly different parameters - and to make it more clear that those are the three input options for data types.

### JSON


```r
file <- system.file("examples", "books.json", package = "solrium")
update_json(file, "books")
```

```
#> $responseHeader
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 39
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
#> [1] 19
```

Now add a new document, and delete the one we just made


```r
file <- system.file("examples", "add_delete.xml", package = "solrium")
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
#> [1] 23
```

### Notes

Note that `update_xml()` and `update_json()` have exactly the same parameters, but simply use different data input formats. `update_csv()` is different in that you can't provide document or field level boosts or other modifications. In addition `update_csv()` can accept not just csv, but tsv and other types of separators.

