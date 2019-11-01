## Test environments

* local OS X install, R 3.6.1 patched
* ubuntu 14.04 (on travis-ci), R 3.6.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

* I have run R CMD check on the 4 downstream dependencies.
  (Summary at <https://github.com/ropensci/solrium/blob/master/revdep/README.md>), with no problems found.

-----

This release includes a bug fix that prevented successful execution of delete by query in Solr.

Thanks!
Scott Chamberlain
