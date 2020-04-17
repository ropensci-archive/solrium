# CONTRIBUTING #

## Do not send the maintainer an email

Please open an issue instead of e-mailing the maintainer. E-mails will be a very low priority to answer.

## Bugs?

* Submit an issue on the [Issues page](https://github.com/ropensci/solrium/issues) - be sure to include R session information and a reproducible example.

## Code contributions

### Broad overview of contributing workflow

* Fork this repo to your Github account
* Clone your version on your account down to your machine from your account, e.g,. `git clone git@github.com:<yourgithubusername>/solrium.git`
* Make sure to track progress upstream (i.e., on our version of `solrium` at `ropensci/solrium`) by doing `git remote add upstream git@github.com:ropensci/solrium.git`. Before making changes make sure to pull changes in from upstream by doing either `git fetch upstream` then merge later or `git pull upstream` to fetch and merge in one step
* Make your changes (bonus points for making changes on a new feature branch)
* Please do write a test(s) for your changes if they affect code and not just docs (see Tests below)
* Push up to your account
* Submit a pull request to home base at `ropensci/solrium`

### Tests

To add tests, go to the folder `tests/testthat/`. Tests are generally organized as individual files for each exported function from the package (that is, listed as an export in the `NAMESPACE` file). If you are adding a new exported function, add a new test file. If you are changing an existing function, work in the tests file for that function, unless it doesn't have tests, in which case make a new test file.

The book R packages book provides [a chapter on testing in general](http://r-pkgs.had.co.nz/tests.html). Do consult that first if you aren't familiar with testing in R.

The easiest set up to run tests is from within an R session:

```r
library(devtools)
library(testthat)
# loads the package
load_all()
```

To test an individual test file

```r
test_file("tests/testthat/test-foobar.R")
```

To run all tests

```r
devtools::test()
```

Or you can run from the CLI like `Rscript -e "devtools::test()"`

If you are running tests that have `skip_on_cran()` in them, set `Sys.setenv(NOT_CRAN = "true")` prior to running tests.


### Making changes

In addition to changing the code, do make sure to udpate the documentation if applicable. The R packages book book has a [chapter on documentation](http://r-pkgs.had.co.nz/man.html) you should read if you aren't familiar.

After code and documentation has been changed, update documentation by running either `devtools::document()` or `roxygen2::roxygenise()`.

Make sure if you change what packages or even functions within packages are imported, most likely add the package to Imports in the DESCRIPTION file and list what functions are imported in the `solrium-package.R` file.

Be very conservative about adding new dependencies.

### Style

* Make sure code, documentation, and comments are no more than 80 characters in width.
* Use `<-` instead of `=` for assignment
* Always use `snake_case` (and all lowercase) instead of `camelCase`

## Also, check out our [discussion forum](https://discuss.ropensci.org)
