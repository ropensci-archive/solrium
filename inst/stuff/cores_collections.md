<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Cores/collections management}
%\VignetteEncoding{UTF-8}
-->



Cores/collections management
============================

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

Initialize connection


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

## Cores

There are many operations you can do on cores, including:

* `core_create()` - create a core
* `core_exists()` - check if a core exists
* `core_mergeindexes()` - merge indexes
* `core_reload()` - reload a core
* `core_rename()` - rename a core
* `core_requeststatus()` - check request status
* `core_split()` - split a core
* `core_status()` - check core status
* `core_swap()` - core swap
* `core_unload()` - delete a core

### Create a core


```r
conn$core_create()
```

### Delete a core


```r
conn$core_unload()
```

## Collections

There are many operations you can do on collections, including:

* `collection_addreplica()`
* `collection_addreplicaprop()`
* `collection_addrole()`
* `collection_balanceshardunique()`
* `collection_clusterprop()`
* `collection_clusterstatus()`
* `collection_create()`
* `collection_createalias()`
* `collection_createshard()`
* `collection_delete()`
* `collection_deletealias()`
* `collection_deletereplica()`
* `collection_deletereplicaprop()`
* `collection_deleteshard()`
* `collection_list()`
* `collection_migrate()`
* `collection_overseerstatus()`
* `collection_rebalanceleaders()`
* `collection_reload()`
* `collection_removerole()`
* `collection_requeststatus()`
* `collection_splitshard()`

### Create a collection


```r
conn$collection_create()
```

### Delete a collection


```r
conn$collection_delete()
```
