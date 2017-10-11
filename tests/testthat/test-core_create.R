context("core_create")

test_that("core_create works", {
  skip_on_cran()
  skip_on_travis()
  skip_if_not(is_not_in_cloud_mode(conn))
  
  core_name <- "slamcore"

  # delete if exists
  if (conn$core_exists(core_name)) {
    invisible(conn$core_unload(core_name))
  }
  
  # write files in preparation
  path <- sprintf("~/solr-7.0.0/server/solr/%s/conf", core_name)
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  files <- list.files("~/solr-7.0.0/server/solr/configsets/sample_techproducts_configs/conf/", full.names = TRUE)
  invisible(file.copy(files, path, recursive = TRUE))
  
  # create the core
  aa <- suppressMessages(conn$core_create(
    name = core_name, instanceDir = core_name, configSet = "basic_configs"))

  expect_is(aa, "list")
  expect_is(aa$responseHeader, "list")
  
  # it worked
  expect_equal(aa$responseHeader$status, 0)
  
  # correct name
  expect_is(aa$core, "character")
  expect_equal(aa$core, core_name)
})
