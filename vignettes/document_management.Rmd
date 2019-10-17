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
(conn <- SolrClient$new())
```

```
#> <Solr Client>
#>   host: 127.0.0.1
#>   path: 
#>   port: 8983
#>   scheme: http
#>   errors: simple
#>   proxy:
```

## Create documents from R objects

For now, only lists and data.frame's supported.

### data.frame


```r
df <- data.frame(id = c(67, 68), price = c(1000, 500000000))
conn$add(df, "books")
```

```
#> $responseHeader
#> $responseHeader$rf
#> [1] 1
#> 
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 319
```

### list




```r
ss <- list(list(id = 1, price = 100), list(id = 2, price = 500))
conn$add(ss, "books")
```

```
#> $responseHeader
#> $responseHeader$rf
#> [1] 1
#> 
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 47
```

## Delete documents

### By id

Add some documents first




```r
docs <- list(list(id = 1, price = 100, name = "brown"),
             list(id = 2, price = 500, name = "blue"),
             list(id = 3, price = 2000L, name = "pink"))
conn$add(docs, "gettingstarted")
```

```
#> $responseHeader
#> $responseHeader$rf
#> [1] 1
#> 
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 206
```

And the documents are now in your Solr database


```r
conn$search(name = "gettingstarted", params = list(q = "*:*", rows = 3))
```

```
#> # A tibble: 3 x 3
#>   id    title   `_version_`
#>   <chr> <chr>         <dbl>
#> 1 10    adfadsf     1.65e18
#> 2 12    though      1.65e18
#> 3 14    animals     1.65e18
```

Now delete those documents just added


```r
conn$delete_by_id(ids = c(1, 2, 3), "gettingstarted")
```

```
#> $responseHeader
#> $responseHeader$rf
#> [1] 1
#> 
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 151
```

And now they are gone


```r
conn$search("gettingstarted", params = list(q = "*:*", rows = 4))
```

```
#> # A tibble: 3 x 3
#>   id    title   `_version_`
#>   <chr> <chr>         <dbl>
#> 1 10    adfadsf     1.65e18
#> 2 12    though      1.65e18
#> 3 14    animals     1.65e18
```

### By query

Add some documents first


```r
conn$add(docs, "gettingstarted")
```

```
#> $responseHeader
#> $responseHeader$rf
#> [1] 1
#> 
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 40
```

And the documents are now in your Solr database


```r
conn$search("gettingstarted", params = list(q = "*:*", rows = 5))
```

```
#> # A tibble: 5 x 5
#>   id    title   `_version_` price name 
#>   <chr> <chr>         <dbl> <int> <chr>
#> 1 10    adfadsf     1.65e18    NA <NA> 
#> 2 12    though      1.65e18    NA <NA> 
#> 3 14    animals     1.65e18    NA <NA> 
#> 4 1     <NA>        1.65e18   100 brown
#> 5 2     <NA>        1.65e18   500 blue
```

Now delete those documents just added


```r
conn$delete_by_query(query = "(name:blue OR name:pink)", "gettingstarted")
```

```
#> $responseHeader
#> $responseHeader$rf
#> [1] 1
#> 
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 74
```

And now they are gone


```r
conn$search("gettingstarted", params = list(q = "*:*", rows = 5))
```

```
#> # A tibble: 4 x 5
#>   id    title   `_version_` price name 
#>   <chr> <chr>         <dbl> <int> <chr>
#> 1 10    adfadsf     1.65e18    NA <NA> 
#> 2 12    though      1.65e18    NA <NA> 
#> 3 14    animals     1.65e18    NA <NA> 
#> 4 1     <NA>        1.65e18   100 brown
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
conn$update_json(file, "books")
```

```
#> $responseHeader
#> $responseHeader$rf
#> [1] 1
#> 
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 61
```

### Add and delete in the same file

Add a document first, that we can later delete


```r
ss <- list(list(id = 456, name = "cat"))
conn$add(ss, "books")
```

```
#> $responseHeader
#> $responseHeader$rf
#> [1] 1
#> 
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 43
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
#> 	    <field name="pages_i">384</field>
#> 	  </doc>
#> 	</add>
#> 	<delete>
#> 		<id>456</id>
#> 	</delete>
#> </update>
```

```r
conn$update_xml(file, "books")
```

```
#> $responseHeader
#> $responseHeader$rf
#> [1] 1
#> 
#> $responseHeader$status
#> [1] 0
#> 
#> $responseHeader$QTime
#> [1] 95
```

### Notes

Note that `update_xml()` and `update_json()` have exactly the same parameters, but simply use different data input formats. `update_csv()` is different in that you can't provide document or field level boosts or other modifications. In addition `update_csv()` can accept not just csv, but tsv and other types of separators.

