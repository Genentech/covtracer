`%||%` <- function(x, y) {
  if (!is.null(x)) {
    x
  } else {
    y
  }
}



#' Get namespace exports, filtering methods tables and definitions
#'
#' @param ns A namespace object
#' @return The names of exported objects, filtering internal method tables and
#'   metadata.
#'
get_namespace_object_names <- function(ns) {
  out <- getNamespaceExports(ns)
  # filter private S4 methods tables and class definitions
  out[!grepl("^\\.__[TC]__", out)]
}



#' Build an empty covr-style test trace mapping
#'
#' @return An empty test-trace matrix, as provided by `covr`
#'
#' @importFrom utils packageVersion
new_empty_test_trace_tally <- function() {
  # version needs to be updated until changes are merged
  if (utils::packageVersion("covr") <= "3.6.4.9000") {
    matrix(
      integer(0L),
      ncol = 4L,
      dimnames = list(c(), c("test", "depth", "i", "trace"))
    )
  } else {
    matrix(
      integer(0L),
      ncol = 5L,
      dimnames = list(c(), c("test", "call", "depth", "i", "trace"))
    )
  }
}



#' A simple alternative to `devtools::as.package`
#'
#' Functionally identical to `devtools`' `as.package`, but without interactive
#' options for package creation.
#'
#' @note Code inspired by `devtools` `load_pkg_description` with very minor
#' edits to further reduce `devtools` dependencies.
#'
#' @param x A package object to coerce
#' @return A `package` object
#'
as.package <- function(x) {
  if (inherits(x, "package")) {
    return(x)
  }
  info <- read.dcf(file.path(x, "DESCRIPTION"))[1L, ]
  Encoding(info) <- "UTF-8"
  desc <- as.list(info)
  names(desc) <- tolower(names(desc))
  desc$path <- x
  structure(desc, class = "package")
}



#' Loading select unexported helpers from tools
#' @noRd
#' @import tools
.tools <- as.list(getNamespace("tools"), all.names = TRUE)[c(
  ".Rd_get_metadata"
)]
