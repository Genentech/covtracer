env_ns_name <- function(e) {
  if (is.null(e) || !isNamespace(e)) return(NA_character_)
  unname(getNamespaceName(e))
}



#' Get namespace export namespace name
#'
#' For most objects, this will be identical to the namespace name provided, but
#' reexports will retain their originating package's namespace name. This helper
#' function helps to expose this name to determine which exports are reexports.
#'
#' @param x A value to find within namespace `ns`
#' @param ns A package namespace
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
  if (!is_exported) return(NA_character_)
  x <- getExportedValue(ns, x)
  obj_namespace_name(x, ns)
}

#' @exportS3Method
obj_namespace_name.R6ClassGenerator <- function(x, ns) {
  env_ns_name(x$parent_env)
}
