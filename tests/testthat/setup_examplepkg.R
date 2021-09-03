opts <- c(
  "keep.source" = TRUE,
  "keep.source.pkgs" = TRUE,
  "covr.record_tests" = TRUE
)

withr::with_options(opts, withr::with_temp_libpaths({
  examplepkg_path <- system.file("examplepkg", package = "covtracer")

  cli::cli_alert_info("Installing testing packages")
  remotes::install_local(
    examplepkg_path,
    INSTALL_opts = c("--with-keep.source", "--install-tests"),
    force = TRUE,
    quiet = TRUE
  )

  cli::cli_alert_info("Running testing package test coverage")
  examplepkg_cov <- covr::package_coverage(examplepkg_path)
  examplepkg_ns <- getNamespace("examplepkg")
}))
