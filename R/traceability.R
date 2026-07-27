# Set of helpers used by Rd_df to determine if an alias is covr-traceable

traceable_aliases <- function(package, ns = NULL) {
  if (is.null(ns)) {
    getNamespace(package)
  }
  
  srcs <- srcrefs(ns)
  direct <- vlapply(
    srcs, function(src) {
      is_srcref(src) && identical(srcref_namespace(src), package)
    }
  )

  aliases <- names(srcs)[direct]
  unique(aliases[!is.na(aliases) & nzchar(aliases)])
}

is_covr_traceable <- function(x) {
  regular <- is.function(x) && !is.primitive(x)
  
  # Based on:
  # https://github.com/r-lib/covr/blob/f1866d296c00884d1f085ff245669de01bc864c4/R/covr.R#L90-L102 # nolint
  supported_container <-
    inherits(x,
             c(
               "R6ClassGenerator",
               "refObjectGenerator",
               "S7_generic",
               "S7_class"
             )) ||
    inherits(attr(x, "spec", exact = TRUE), "box$mod_spec")
  
  regular || supported_container
}

is_alias_traceable <- function(alias, ns) {
  # S4 naming convention support
  if (grepl("-class$", alias)) {
    unique(alias <- c(
      alias,
      sub("-class$", "", alias)
    ))
  }
  
  alias_exists <- vlapply(alias, exists, envir = ns, inherits = FALSE)
  alias <- alias[alias_exists]
  
  is_traceable <- vlapply(alias, function(a) {
    obj <- get(a, envir = ns, inherits = FALSE)
    is_covr_traceable(obj)
  })

  any(is_traceable)
}
