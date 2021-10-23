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
  # filter private S4 methods tables and class definitions
  out[!grepl("^\\.__(T|C)__", out)]
}



#' Get namespace export namespace name
#'
#' For most objects, this will be identical to the namespace name provided, but
#' reexports will retain their originating package's namespace name. This helper
#' function helps to expose this name to determine which exports are reexports.
#'
#' @inheritParams base::getExportedValue
#'
get_obj_namespace_name <- function(ns, name) {
  is_exported <- name %in% getNamespaceExports(ns)
  if (!is_exported) return(NA_character_)
  obj <- getExportedValue(ns, name)
  env <- environment(obj)
  if (is.null(env) || !isNamespace(env)) return(NA_character_)
  unname(getNamespaceName(env))
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
  info <- read.dcf(file.path(x, "DESCRIPTION"))[1L, ]
  Encoding(info) <- "UTF-8"
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
