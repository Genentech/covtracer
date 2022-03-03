cli::cli_alert_info("Running covtracer against test packages")
cli::cli_ul()
cli::cli_ul()

Sys.setenv(R_REMOTES_STANDALONE = "true")
opts <- list(
  "keep.source" = TRUE,
  "keep.source.pkgs" = TRUE,
  "covr.record_tests" = TRUE
)

# store inbound options and libpaths
init_opts <- options(opts)
init_libs <- .libPaths()

# set temporary libpath for test execution
dir.create(lib <- tempfile("covtracer_test_lib_"))
.libPaths(c(lib, .libPaths()))

# defer restoration of original libpaths
withr::defer(envir = teardown_env(), {
  options(init_opts)
  .libPaths(init_libs)
})


# from inst/examplepkg
cli::cli_li("{.pkg examplepkg}")
examplepkg_path <- system.file("examplepkg", package = "covtracer")

suppressMessages(remotes::install_local(
  examplepkg_path,
  INSTALL_opts = c("--with-keep.source", "--install-tests"),
  force = TRUE,
  quiet = TRUE
))

examplepkg_cov <- covr::package_coverage(examplepkg_path)
examplepkg_ns <- getNamespace("examplepkg")


# from tests/testthat/packages/no.evaluable.code
cli::cli_li("{.pkg no.evaluable.code}")
no_evaluable_code_pkg_path <- file.path(
  testthat::test_path(),
  "packages",
  "no.evaluable.code"
)

suppressMessages(remotes::install_local(
  no_evaluable_code_pkg_path,
  INSTALL_opts = c("--with-keep.source", "--install-tests"),
  force = TRUE,
  quiet = TRUE
))

no_evaluable_code_pkg_cov <- covr::package_coverage(no_evaluable_code_pkg_path)
no_evaluable_code_pkg_ns <- getNamespace("no.evaluable.code")
