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
#'
get_namespace_object_names <- function(ns) {
  out <- getNamespaceExports(ns)
  # filter private S4 methods tables
  out <- out[!grepl("^.__T__", out)]
  # substitute S4 class definitions
  out <- sub("^.__C__", "", out)
  out
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
#'
as.package <- function(x) {
  if (inherits(x, "package")) return(x)
  info <- read.dcf(file.path(x, "DESCRIPTION"))[1L,]
  Encoding(info) <- 'UTF-8'
  desc <- as.list(info)
  names(desc) <- tolower(names(desc))
  desc$path <- x
  structure(desc, class = "package")
}



#' Loading unexported helpers from tools
#'
#' @import tools
#'
.tools <- as.list(getNamespace("tools"), all.names = TRUE)[c(
  "compareDependsPkgVersion",
  "processRdSexprs",
  "initialRdMacros",
  ".Rd_get_metadata"
)]
