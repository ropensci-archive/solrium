<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Local Solr setup}
-->

Local setup of Solr and querying using solr R package, on Mac OSX
======

*This material is based on this blog post: http://risnandar.wordpress.com/2013/09/08/how-to-install-and-setup-apache-lucene-solr-in-osx/*

1. If you don't have homebrew installed, install homebrew by doing ``. If you have homebrew skip to step 2. 
2. Install solr by doing `brew install solr`. This installed solr v.4.5.1
3. Navigate in your terminal to an example Solr database: `cd /usr/local/Cellar/solr/4.5.1/libexec/example/`
4. Start solr: `java -jar start.jar`
5. Navigate in your browser to [http://localhost:8983/solr/#/](http://localhost:8983/solr/#/)
6. Navigate in your terminal to `cd /usr/local/Cellar/solr/4.5.1/libexec/example/exampledocs/`, then execute `./post.sh vidcard.xml` in that directory. This inserts some data into the example database. 

Try this query in your browser: [http://localhost:8983/solr/select?q=*:*&wt=json](http://localhost:8983/solr/select?q=*:*&wt=json)

And we can now use the `solr` R package to query the Solr database to get raw JSON data:

```coffee
url <- 'http://localhost:8983/solr/select'
solr_search(q='*:*', base=url, raw=TRUE)
```

```coffee
[1] "{\"responseHeader\":{\"status\":0,\"QTime\":1,\"params\":{\"start\":\"0\",
\"q\":\"*:*\",\"wt\":\"json\"}},\"response\":{\"numFound\":2,\"start\":0,\"docs\"
:[{\"id\":\"EN7800GTX/2DHTV/256M\",\"name\":\"ASUS Extreme N7800GTX/2DHTV (256 MB)\"
,\"manu\":\"ASUS Computer Inc.\",\"manu_id_s\":\"asus\",\"cat\":[\"electronics\",
\"graphics card\"],\"features\":[\"NVIDIA GeForce 7800 GTX GPU/VPU clocked at 486MHz\"
,\"256MB GDDR3 Memory clocked at 1.35GHz\",\"PCI Express x16\",\"Dual DVI connectors, 
HDTV out, video input\",\"OpenGL 2.0, DirectX 9.0\"],\"weight\":16.0,\"price\":479.95,
\"price_c\":\"479.95,USD\",\"popularity\":7,\"store\":\"40.7143,-74.006\",\"inStock\"
:false,\"manufacturedate_dt\":\"2006-02-13T00:00:00Z\",\"_version_\":1455773551158099968},
{\"id\":\"100-435805\",\"name\":\"ATI Radeon X1900 XTX 512 MB PCIE Video Card\",\"manu\"
:\"ATI Technologies\",\"manu_id_s\":\"ati\",\"cat\":[\"electronics\",\"graphics card\"],
\"features\":[\"ATI RADEON X1900 GPU/VPU clocked at 650MHz\",\"512MB GDDR3 SDRAM 
clocked at 1.55GHz\",\"PCI Express x16\",\"dual DVI, HDTV, svideo, composite out\",
\"OpenGL 2.0, DirectX 9.0\"],\"weight\":48.0,\"price\":649.99,\"price_c\":\"649.99,
USD\",\"popularity\":7,\"inStock\":false,\"manufacturedate_dt\":\"2006-02-13T00:00:00Z\",
\"store\":\"40.7143,-74.006\",\"_version_\":1455773551214723072}]}}\n"
attr(,"class")
[1] "sr_search"
attr(,"wt")
[1] "json"
```

Or parsed data to a data.frame (just looking at a few columns for brevity):

```coffee
solr_search(q='*:*', base=url)[,c(1:3)]
```

```coffee
                    id                                        name               manu
1 EN7800GTX/2DHTV/256M        ASUS Extreme N7800GTX/2DHTV (256 MB) ASUS Computer Inc.
2           100-435805 ATI Radeon X1900 XTX 512 MB PCIE Video Card   ATI Technologies
```

Local setup of Solr on Windows and Linux
======

I'm a Mac user, so I'm not too familiar with Windows and Linux, but will get to this soon, or send a pull request with instructions in this file. 
