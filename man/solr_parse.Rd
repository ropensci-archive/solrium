\name{solr_parse}
\alias{solr_parse}
\alias{solr_parse.sr_facet}
\alias{solr_parse.sr_high}
\title{Parse facet data.}
\usage{
solr_parse(input, parsetype)

\method{solr_parse}{sr_facet}(input, parsetype = NULL)

\method{solr_parse}{sr_high}(input, parsetype = "list")
}
\arguments{
  \item{input}{Output from solr_facet}

  \item{parsetype}{One of 'list' or 'df' (data.frame)}
}
\description{
Parse facet data.
}
\details{
This is the parser used internally in solr_facet, but if
you output raw data from solr_facet using raw=TRUE, then
you can use this function to parse that data (a sr_facet S3
object) after the fact to a list of data.frame's for easier
consumption. The data format type is detected from the
attribute "wt" on the sr_facet object.
}

