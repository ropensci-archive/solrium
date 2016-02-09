context("core_create")

test_that("core_create works", {
  skip_on_cran()
  
  solr_connect(verbose = FALSE)
  
  core_name <- "slamcore"

  # delete if exists
  if (core_exists(core_name)) {
    invisible(core_unload(core_name))
  }
  
  # write files in preparation
  path <- sprintf("~/solr-5.4.1/server/solr/%s/conf", core_name)
  dir.create(path, recursive = TRUE)
  files <- list.files("~/solr-5.4.1/server/solr/configsets/data_driven_schema_configs/conf/", full.names = TRUE)
  invisible(file.copy(files, path, recursive = TRUE))
  
  # create the core
  aa <- suppressMessages(core_create(name = core_name, instanceDir = core_name, configSet = "basic_configs"))

  expect_is(aa, "list")
  expect_is(aa$responseHeader, "list")
  
  # it worked
  expect_equal(aa$responseHeader$status, 0)
  
  # correct name
  expect_is(aa$core, "character")
  expect_equal(aa$core, core_name)
})
