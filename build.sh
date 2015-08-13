#!/bin/sh

cd $CI_HOME/solr/solr-4.10.3
bin/solr create -c gettingstarted
bin/post -c gettingstarted example/exampledocs/*.xml
