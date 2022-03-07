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
