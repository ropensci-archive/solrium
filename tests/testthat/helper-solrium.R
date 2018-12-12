conn <- SolrClient$new()
conn_plos <- SolrClient$new(host = "api.plos.org", path = "search", port = NULL)
conn_simp <- SolrClient$new(host = 'api.plos.org', path = 'search', port = NULL)
conn_comp <- SolrClient$new(host = 'api.plos.org', path = 'search',
                            port = NULL, errors = "complete")
conn_hathi <- SolrClient$new(
  host = "chinkapin.pti.indiana.edu", path = "solr/meta/select", port = 9994)
conn_dc <- SolrClient$new(scheme = "https", host = "search.datacite.org", 
    path = "api", port = NULL)
conn_dryad <- SolrClient$new(host = "datadryad.org", path = "solr/search/select",
                             port = NULL)

# cloud mode: create collection "gettingstarted"
up <- tryCatch(conn$collection_exists("gettingstarted"), error = function(e) e)
if (!inherits(up, "error")) {
  if (!conn$collection_exists("gettingstarted")) {
    conn$collection_create("gettingstarted")
  }
}
