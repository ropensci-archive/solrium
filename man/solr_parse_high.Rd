\name{solr_parse_high}
\alias{solr_parse_high}
\title{Parse highlight data.}
\usage{
  solr_parse_high(input, parsetype = "list")
}
\arguments{
  \item{input}{Output from solr_facet}
}
\description{
  Parse highlight data.
}
\details{
  This is the parser used internally in solr_facet, but if
  you output raw data from solr_facet using raw=TRUE, then
  you can use this function to parse that data (a sr_facet
  S3 object) after the fact to a list of data.frame's for
  easier consumption. The data format type is detected from
  the attribute "wt" on the sr_facet object.
}

