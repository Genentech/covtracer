# Example reexports, to ensure that reexports are flagged properly in the
# test-trace data.frame

#' @importFrom utils help
#' @export
utils::help

#' Manually redefining a function from another package
#'
#' @importFrom utils example
#' @export
reexport_example <- utils::example

#' @importFrom utils person
#' @export person
NULL

#' Reexport with srcref
#'
#' @importFrom covtracer test_trace_df
#' @export
#'
reexport_pkg_srcrefs <- if (
  require("covtracer", quietly = TRUE) &&
  !is.null(getSrcref(getExportedValue("covtracer", "test_trace_df")))
) {
  covtracer::test_trace_df
} else {
  NULL
}
