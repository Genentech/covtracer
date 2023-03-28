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
  examplepkg = system.file("examplepkg", package = "covtracer"),
  list.obj = file.path(tests, "packages", "list.obj"),
  no.evaluable.code = file.path(tests, "packages", "no.evaluable.code"),
  reexport.srcref = file.path(tests, "packages", "reexport.srcref")
)

# install our testing packages into a temp directory
for (i in seq_along(pkg_dirs)) {
  install.packages(
    pkg_dirs[[i]],
    type = "source",
    lib = lib,
    repos = NULL,
    dependencies = FALSE,
    INSTALL_opts = c("--with-keep.source", "--install-tests"),
    quiet = TRUE
  )
}

# from inst/examplepkg
cli::cli_li("{.pkg examplepkg}")
examplepkg_cov <- covr::package_coverage(pkg_dirs$examplepkg)
examplepkg_ns <- getNamespace("examplepkg")

# from tests/testthat/packages/list.obj
cli::cli_li("{.pkg list.obj}")
list.obj_cov <- covr::package_coverage(pkg_dirs$list.obj)
list.obj_ns <- getNamespace("list.obj")

# from tests/testthat/packages/no.evaluable.code
cli::cli_li("{.pkg no.evaluable.code}")
no.evaluable.code_cov <- covr::package_coverage(pkg_dirs$no.evaluable.code)
no.evaluable.code_ns <- getNamespace("no.evaluable.code")

# from tests/testthat/packages/reexport.srcref
cli::cli_li("{.pkg reexport.srcref}")
reexport.srcref_ns <- getNamespace("reexport.srcref")
