cli::cli_alert_info("Installing test packages")
cli::cli_ul()
cli::cli_ul()

on_cran <- tryCatch(
  {
    testthat::skip_on_cran()
    FALSE
  },
  condition = function(c) TRUE
)

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
pkg_dirs <- Filter(Negate(is.null), list(
  system.file("examplepkg", package = "covtracer"),
  file.path(tests, "packages", "list.obj"),
  file.path(tests, "packages", "no.evaluable.code"),
  file.path(tests, "packages", "no.exports"),
  if (!on_cran) file.path(tests, "packages", "reexport.srcref")
))

# install our testing packages into a temp directory
install.packages(
  as.character(pkg_dirs),
  type = "source",
  lib = lib,
  repos = NULL,
  dependencies = FALSE,
  INSTALL_opts = c("--with-keep.source", "--install-tests"),
  quiet = TRUE
)

for (i in seq_along(pkg_dirs)) {
  pkg_dir <- pkg_dirs[[i]]
  pkg <- basename(pkg_dir)

  if (pkg == "reexport.srcref") {
    cli::cli_li("{.pkg {pkg}} (derived {.code {pkg}_ns})")
    assign(paste0(pkg, "_ns"), getNamespace(pkg))
  } else {
    cli::cli_li("{.pkg {pkg}} (derived {.code {pkg}_cov}, {.code {pkg}_ns})")
    assign(paste0(pkg, "_cov"), covr::package_coverage(pkg_dir))
    assign(paste0(pkg, "_ns"), getNamespace(pkg))
  }
}
