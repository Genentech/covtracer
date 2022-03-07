# hack to allow this to build from install.packages within R CMD check
# without this, nested install.packages will not find test package dependencies
.libPaths(c(
  # needed to capture R CMD check tmp library
  Sys.getenv("R_LIBRARY_DIR"),
  # needed to capture site library for depednencies of dependencies
  strsplit(Sys.getenv("CALLR_CHILD_R_LIBS"), .Platform$path.sep)[[1L]],
  .libPaths()
))



#' @export
reexport_hypotenuse <- examplepkg::hypotenuse
