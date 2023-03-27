cli::cli_alert_info("Installing test packages")
cli::cli_ul()
cli::cli_ul()

opts <- list(
  "keep.source" = TRUE,
  "keep.source.pkgs" = TRUE,
  "covr.record_tests" = TRUE
)

# store inbound options and libpaths
init_opts <- options(opts)
init_libs <- .libPaths()

# set temporary libpath for test execution
dir.create(lib <- tempfile("ct_"), recursive = TRUE)
.libPaths(c(lib, .libPaths()))

tests <- normalizePath(testthat::test_path())
pkg_dirs <- list(
 system.file("examplepkg", package = "covtracer"),
 file.path(tests, "packages", "list.obj"),
 file.path(tests, "packages", "no.evaluable.code"),
 file.path(tests, "packages", "reexport.srcref")
)

# install our testing packages into a temp directory
for (i in seq_along(pkg_dirs)) {
  pkg_dir <- pkg_dirs[[i]]
  pkg <- basename(pkg_dir)

  cli::cli_li("{.pkg {pkg}}")

  install.packages(
    pkg_dir,
    type = "source",
    lib = lib,
    repos = NULL,
    dependencies = FALSE,
    INSTALL_opts = c("--with-keep.source", "--install-tests"),
    quiet = TRUE
  )

  assign(paste0(pkg, "_cov"), covr::package_coverage(pkg_dir))
  assign(paste0(pkg, "_ns"), getNamespace(pkg))
}
