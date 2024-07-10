env_ns_name <- function(e) {
  if (is.null(e) || !isNamespace(e)) {
    return(NA_character_)
  }
  unname(getNamespaceName(e))
}

#' @importFrom utils capture.output
env_name <- function(e) {
  # NOTE:
  #   If this ever becomes problematic, we can embed C call to grab environment
  #   pointer address instead of using output. Plenty of prior art, see
  #   envnames::address or data.table::address for examples.

  # because environment may have attributes, only take first line of output
  sub("<environment: (.*)>", "\\1", capture.output(e)[[1L]])
}



#' Get namespace export namespace name
#'
#' For most objects, this will be identical to the namespace name provided, but
#' reexports will retain their originating package's namespace name. This helper
#' function helps to expose this name to determine which exports are reexports.
#'
#' @param x A value to find within namespace `ns`
#' @param ns A package namespace
#' @return A `character` string representing a namespace or similar
#'
obj_namespace_name <- function(x, ns) {
  UseMethod("obj_namespace_name")
}

#' @exportS3Method
obj_namespace_name.default <- function(x, ns) {
  env_ns_name(environment(x))
}

#' @exportS3Method
obj_namespace_name.character <- function(x, ns) {
  is_exported <- x %in% getNamespaceExports(ns)
  if (!is_exported) {
    return(NA_character_)
  }
  env_ns_name(environment(getExportedValue(ns, x)))
}

#' @exportS3Method
obj_namespace_name.R6ClassGenerator <- function(x, ns) {
  env_ns_name(x$parent_env)
}

#' @importFrom methods packageSlot
#' @exportS3Method
obj_namespace_name.standardGeneric <- function(x, ns) {
  methods::packageSlot(x)
}

#' @exportS3Method
obj_namespace_name.nonstandardGenericFunction <- obj_namespace_name.standardGeneric
