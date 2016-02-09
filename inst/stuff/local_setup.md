<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Local Solr setup}
%\VignetteEncoding{UTF-8}
-->

Local Solr setup 
======

### OSX

__Based on http://lucene.apache.org/solr/quickstart.html__

1. Download most recent version from an Apache mirror http://www.apache.org/dyn/closer.cgi/lucene/solr/5.4.1
2. Unzip/untar the file. Move to your desired location. Now you have Solr `v.5.4.1`
3. Go into the directory you just created: `cd solr-5.4.1`
4. Launch Solr: `bin/solr start -e cloud -noprompt` - Sets up SolrCloud mode, rather
than Standalone mode. As far as I can tell, SolrCloud mode seems more common.
5. Once Step 4 completes, you can go to `http://localhost:8983/solr/` now, which is
the admin interface for Solr.
6. Load some documents: `bin/post -c gettingstarted docs/`
7. Once Step 6 is complete (will take a few minutes), navigate in your browser to `http://localhost:8983/solr/gettingstarted/select?q=*:*&wt=json` and you should see a
bunch of documents


### Linux

> You should be able to use the above instructions for OSX on a Linux machine.

#### Linuxbrew

[Linuxbrew](http://brew.sh/linuxbrew/) is a port of Mac OS homebrew to linux.  Operation is essentially the same as for homebrew.  Follow the [installation instructions for linuxbrew](http://brew.sh/linuxbrew/#installation) and then the instructions for using homebrew (above) should work without modification.

### Windows

You should be able to use the above instructions for OSX on a Windows machine, but with some slight differences. For example, the `bin/post` tool for OSX and Linux doesn't work on Windows, but see https://cwiki.apache.org/confluence/display/solr/Post+Tool#PostTool-Windows for an equivalent.

### `solrium` usage

And we can now use the `solrium` R package to query the Solr database to get raw JSON data:


```r
solr_connect('http://localhost:8983')
solr_search("gettingstarted", q = '*:*', raw = TRUE, rows = 3)

#> [1] "{\"responseHeader\":{\"status\":0,\"QTime\":8,\"params\":{\"q\":\"*:*\",\"rows\":\"3\",\"wt\":\"json\"}},\"response\":{\"numFound\":3577,\"start\":0,\"maxScore\":1.0,\"docs\":[{\"id\":\"/Users/sacmac/solr-5.2.1/docs/solr-core/org/apache/solr/highlight/class-use/SolrFragmenter.html\",\"stream_size\":[9016],\"date\":[\"2015-06-10T00:00:00Z\"],\"x_parsed_by\":[\"org.apache.tika.parser.DefaultParser\",\"org.apache.tika.parser.html.HtmlParser\"],\"stream_content_type\":[\"text/html\"],\"dc_title\":[\"Uses of Interface org.apache.solr.highlight.SolrFragmenter (Solr 5.2.1 API)\"],\"content_encoding\":[\"UTF-8\"],\"resourcename\":[\"/Users/sacmac/solr-5.2.1/docs/solr-core/org/apache/solr/highlight/class-use/SolrFragmenter.html\"],\"title\":[\"Uses of Interface org.apache.solr.highlight.SolrFragmenter (Solr 5.2.1 API)\"],\"content_type\":[\"text/html\"],\"_version_\":1507965023127863296},{\"id\":\"/Users/sacmac/solr-5.2.1/docs/solr-core/org/apache/solr/highlight/class-use/SolrFragmentsBuilder.html\",\"stream_size\":[10336],\"date\":[\"2015-06-10T00:00:00Z\"],\"x_parsed_by\":[\"org.apache.tika.parser.DefaultParser\",\"org.apache.tika.parser.html.HtmlParser\"],\"stream_content_type\":[\"text/html\"],\"dc_title\":[\"Uses of Class org.apache.solr.highlight.SolrFragmentsBuilder (Solr 5.2.1 API)\"],\"content_encoding\":[\"UTF-8\"],\"resourcename\":[\"/Users/sacmac/solr-5.2.1/docs/solr-core/org/apache/solr/highlight/class-use/SolrFragmentsBuilder.html\"],\"title\":[\"Uses of Class org.apache.solr.highlight.SolrFragmentsBuilder (Solr 5.2.1 API)\"],\"content_type\":[\"text/html\"],\"_version_\":1507965023153029120},{\"id\":\"/Users/sacmac/solr-5.2.1/docs/solr-core/org/apache/solr/internal/csv/CSVParser.html\",\"stream_size\":[32427],\"date\":[\"2015-06-10T00:00:00Z\"],\"x_parsed_by\":[\"org.apache.tika.parser.DefaultParser\",\"org.apache.tika.parser.html.HtmlParser\"],\"stream_content_type\":[\"text/html\"],\"dc_title\":[\"CSVParser (Solr 5.2.1 API)\"],\"content_encoding\":[\"UTF-8\"],\"resourcename\":[\"/Users/sacmac/solr-5.2.1/docs/solr-core/org/apache/solr/internal/csv/CSVParser.html\"],\"title\":[\"CSVParser (Solr 5.2.1 API)\"],\"content_type\":[\"text/html\"],\"_version_\":1507965023221186560}]}}\n"
#> attr(,"class")
#> [1] "sr_search"
#> attr(,"wt")
#> [1] "json"
```

Or parsed data to a data.frame (just looking at a few columns for brevity):


```r
solr_search("gettingstarted", q = '*:*', fl = c('date', 'title'))

#> Source: local data frame [10 x 2]
#>
#>                    date                                                                         title
#> 1  2015-06-10T00:00:00Z   Uses of Interface org.apache.solr.highlight.SolrFragmenter (Solr 5.2.1 API)
#> 2  2015-06-10T00:00:00Z Uses of Class org.apache.solr.highlight.SolrFragmentsBuilder (Solr 5.2.1 API)
#> 3  2015-06-10T00:00:00Z                                                    CSVParser (Solr 5.2.1 API)
#> 4  2015-06-10T00:00:00Z                                                     CSVUtils (Solr 5.2.1 API)
#> 5  2015-06-10T00:00:00Z                                 org.apache.solr.internal.csv (Solr 5.2.1 API)
#> 6  2015-06-10T00:00:00Z                 org.apache.solr.internal.csv Class Hierarchy (Solr 5.2.1 API)
#> 7  2015-06-10T00:00:00Z       Uses of Class org.apache.solr.internal.csv.CSVStrategy (Solr 5.2.1 API)
#> 8  2015-06-10T00:00:00Z          Uses of Class org.apache.solr.internal.csv.CSVUtils (Solr 5.2.1 API)
#> 9  2015-06-10T00:00:00Z                                                    CSVConfig (Solr 5.2.1 API)
#> 10 2015-06-10T00:00:00Z                                             CSVConfigGuesser (Solr 5.2.1 API)
```

See the other vignettes for more thorough examples:

* `Document management`
* `Cores/collections management`
* `Solr Search`
