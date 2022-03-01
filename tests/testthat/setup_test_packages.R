cli::cli_alert_info("Running covtracer against test packages")
cli::cli_ul()
cli::cli_ul()

Sys.setenv(R_REMOTES_STANDALONE = "true")
opts <- c(
  "keep.source" = TRUE,
  "keep.source.pkgs" = TRUE,
  "covr.record_tests" = TRUE
)

# from inst/examplepkg
withr::with_options(opts, withr::with_temp_libpaths({
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
}))

# from tests/testthat/packages/no.evaluable.code
withr::with_options(opts, withr::with_temp_libpaths({
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
}))
