#' Test whether an object is a \code{srcref} object
#'
#' @param x Any object
#' @return A `logical` indicating whether object is a `srcref`
#'
is_srcref <- function(x) {
  inherits(x, "srcref")
}



#' Retrieve \code{srcref}s
#'
#' This function takes a code collection and returns a `list` of related
#' `srcref` objects with `list` names that associate the `srcref` with a name or
#' alias that could be used to find documentation. Code collections include
#' structures such as package namespaces, environments, function definitions,
#' methods tables or class generators - any object which enapsulates a single or
#' set of `srcref` objects.
#'
#' For most objects, this is a one-to-one mapping of exported object names to
#' their `srcref`, just like you would get using `getNamespace()`. However, for
#' classes and methods, this can be a one-to-many mapping of related
#' documentation to the multiple `srcref`s that are described there. This is the
#' case for S3 generics, S4 objects and R6 objects.
#'
#' Objects without any related `srcref`s, such as any datasets or objects
#' created at package build time will be omitted from the results.
#'
#' @param x An object to source srcrefs from
#' @param ... Additional arguments passed to methods
#' @param srcref_names An optional field used to supercede any discovered object
#'   names when choosing which names to provide in the returned list.
#' @param breadcrumbs Recursive methods are expected to propegate a vector of
#'   "breadcrumbs" (a character vector of namespace names encountered while
#'   traversing the namespace used as a memory of what we've seen already),
#'   which is used for short-circuiting recursive environment traversal.
#' @return A `list` of `srcref` objects. Often, has a length of 1, but can be
#'   larger for things like environments, namespaces or generic methods. The
#'   names of the list reflect the name of the Rd name or alias that could be
#'   used to find information related to each `srcref`. Elements of the `list`
#'   will have attribute `"namespace"` denoting the source environment namespace
#'   if one can be determined for the srcref object.
#'
#' @examples
#' # examples use `with` to execute within namespace as function isn't exported
#' ns <- getNamespace("covtracer")
#'
#' # load and extract srcrefs for a package
#' with(ns, srcrefs(getNamespace("covtracer")))
#'
#' # extract srcrefs for functions
#' with(ns, srcrefs(srcrefs))
#'
#' @rdname srcrefs
srcrefs <- function(x, ...) {
  UseMethod("srcrefs")
}

#' @exportS3Method
#' @importFrom utils getSrcref
#' @rdname srcrefs
srcrefs.default <- function(x, ..., srcref_names = NULL, breadcrumbs = character()) {
  sr <- getSrcref(x)

  if (!is.null(sr) && !is_srcref(sr) && !identical(sr, x)) {
    # some objects (eg MethodDefinition) do not return srcrefs, so recurse
    return(srcrefs(sr))
  }

  env <- environment(x)
  if (!is.null(sr) && !is.null(env)) {
    attr(sr, "namespace") <- env_ns_name(env)
  }

  out <- list(sr)
  names(out) <- srcref_names
  out
}

#' @exportS3Method
#' @rdname srcrefs
srcrefs.list <- function(x, ..., srcref_names = NULL, breadcrumbs = character()) {
  # The method is designed to handle lists and is later passed to the mapper
  # However if the object has other classes than list with set .[[ methods
  # it could lead to unexpected results returned by the mapper. Thus, if
  # list was the class used for dispatch, we remove other classes.
  x <- unclass(x)

  # propagate srcref names as element names
  if (!is.null(srcref_names)) names(x) <- rep_len(srcref_names, length(x))

  flat_map_srcrefs(x, breadcrumbs = breadcrumbs)
}

#' @exportS3Method
#' @rdname srcrefs
srcrefs.namespace <- function(x, ..., breadcrumbs = character()) {
  # short circuit on recursive environment traversal
  if (env_name(x) %in% breadcrumbs) {
    return(NULL)
  }

  flat_map_srcrefs(
    as.list(x, all.names = TRUE),
    ns = env_ns_name(x),
    breadcrumbs = c(breadcrumbs, env_name(x))
  )
}

#' @exportS3Method
#' @rdname srcrefs
srcrefs.environment <- function(x, ..., breadcrumbs = character()) {
  if (isNamespace(x)) {
    return(srcrefs.namespace(x, ..., breadcrumbs = breadcrumbs))
  }

  # short circuit on recursive environment traversal
  if (env_name(x) %in% breadcrumbs) {
    return(NULL)
  }

  objs <- as.list(x, all.names = TRUE)
  objs <- Filter(function(i) !identical(i, x), objs) # prevent direct recursion
  flat_map_srcrefs(
    objs,
    ns = env_ns_name(x),
    breadcrumbs = c(breadcrumbs, env_name(x))
  )
}

### R6

#' @exportS3Method
#' @rdname srcrefs
srcrefs.R6ClassGenerator <- function(
    x, ..., srcref_names = NULL,
    breadcrumbs = character()) {
  objs <- c(list(x$new), x$public_methods, x$private_methods, x$active)
  names(objs) <- rep_len(srcref_names, length(objs))
  flat_map_srcrefs(
    objs,
    ns = env_ns_name(x$parent_env),
    breadcrumbs = breadcrumbs
  )
}

### S4

#' @exportS3Method
#' @importFrom utils getSrcref
#' @rdname srcrefs
srcrefs.standardGeneric <- function(x, ..., srcref_names = NULL) {
  if (is.null(sr <- getSrcref(x))) {
    return(sr)
  }

  attr(sr, "namespace") <- obj_namespace_name(x)

  objs <- list(sr)
  names(objs) <- srcref_names
  objs
}

#' @exportS3Method
#' @importFrom utils getSrcref
#' @rdname srcrefs
srcrefs.nonstandardGenericFunction <- srcrefs.standardGeneric

#' @exportS3Method
#' @importFrom utils getSrcref
#' @importFrom methods getPackageName
#' @rdname srcrefs
srcrefs.MethodDefinition <- function(x, ..., srcref_names = NULL) {
  # catch methods in methods tables from packages without srcref data
  if (is.null(sr <- getSrcref(x))) {
    return(sr)
  }

  # generic source package
  generic_origin_ns <- attr(x@generic, "package")
  ns <- methods::getPackageName(environment(x))

  # if method is defined in same package as generic, use generic name as
  # signature alias, otherwise use methods_info-style method alias name
  if (identical(generic_origin_ns, ns)) {
    signatures <- x@generic
  } else {
    # as produced by `methods:::.methods_info`
    signatures <- paste0(x@generic, ",", paste0(x@defined, collapse = ","), "-method")
  }

  signatures <- signatures[!duplicated(signatures)]
  objs <- rep_len(list(sr), length(signatures))

  names(objs) <- signatures
  for (i in seq_along(objs)) attr(objs[[i]], "namespace") <- ns
  objs
}



#' Map `srcrefs` over an iterable object, Filtering non-srcref results
#'
#' @param xs Any iterable object
#' @param ns A `character` namespace name to attribute to objects in `xs`. If
#'   `xs` objects themselves have namespaces attributed already to them, the
#'   namespace will not be replaced.
#' @inheritParams srcrefs
#' @return A `list` of `srcref`s
#'
flat_map_srcrefs <- function(xs, ns = NULL, breadcrumbs = character()) {
  srcs <- mapply(
    srcrefs,
    xs,
    srcref_names = names(xs) %||% rep_len("", length(xs)),
    breadcrumbs = rep_len(list(breadcrumbs), length(xs)),
    SIMPLIFY = FALSE
  )

  # remove NULL srcrefs, otherwise they cause problematic unlisting.
  srcs <- Filter(Negate(is.null), srcs)

  srcnames <- mapply(
    function(new, old) names(new) %||% rep_len(old, length(new)),
    srcs,
    names(srcs) %||% rep_len("", length(srcs)),
    SIMPLIFY = FALSE
  )

  srcs <- unlist(srcs, recursive = FALSE)
  names(srcs) <- unlist(srcnames, recursive = FALSE, use.names = FALSE)
  srcs <- Filter(is_srcref, srcs)

  if (!is.null(ns)) {
    for (i in seq_along(srcs)) {
      if (!is.null(attr(srcs[[i]], "namespace"))) next
      attr(srcs[[i]], "namespace") <- ns
    }
  }

  srcs
}



#' Extract all the srcref objects of objects within a package namespace
#'
#' @param x A package namespace object or similar. One of either a package name,
#'   a namespace environment, or a \code{link[covr]{package_coverage}} result
#'   from which a package name is discovered. When package names are provided, a
#'   namespace available in the current environment is used.
#' @return A `list_of_srcref`
#'
#' @examples
#' pkg <- system.file("examplepkg", package = "covtracer")
#' install.packages(
#'   pkg,
#'   type = "source",
#'   repos = NULL,
#'   quiet = TRUE,
#'   INSTALL_opts = "--with-keep.source"
#' )
#' pkg_srcrefs("examplepkg")
#'
#' @family srcrefs
#' @seealso as.data.frame.list_of_srcref
#'
#' @rdname pkg_srcrefs
#' @export
#'
pkg_srcrefs <- function(x) {
  UseMethod("pkg_srcrefs")
}

#' @param x A package environment
#'
#' @rdname pkg_srcrefs
#' @export
pkg_srcrefs.environment <- function(x) {
  package_check_has_keep_source(x)
  srcs <- srcrefs(x)

  if (isNamespace(x)) {
    srcs[setdiff(get_namespace_object_names(x), names(srcs))] <- NA
  }

  as_list_of_srcref(srcs)
}

#' @param x A \code{character} package name, which can be used with
#'   `getNamespace()` to retrieve a package namespace environment.
#'
#' @rdname pkg_srcrefs
#' @export
pkg_srcrefs.character <- function(x) {
  pkg_srcrefs(getNamespace(x))
}

#' @param x A \code{\link[covr]{package_coverage}} coverage object, from which
#'   the name of the package used is extracted.
#'
#' @rdname pkg_srcrefs
#' @export
pkg_srcrefs.coverage <- function(x) {
  pkg <- attr(x, "package")
  pkg_srcrefs(pkg$package)
}



#' Verify that the package collection contains srcref information
#'
#' Test whether the package object collection contains srcref attributes.
#'
#' @param env A package namespace environment or iterable collection of package
#'   objects
#' @return Used for side effect of throwing an error when a package was not
#'   installed with `srcref`s.
#'
package_check_has_keep_source <- function(env) {
  has_srcref <- function(x) !is.null(getSrcref(x))
  obj_has_srcref <- vapply(env, has_srcref, logical(1L))
  if (length(obj_has_srcref) > 0L && !any(obj_has_srcref)) {
    stop(
      "Package was not installed using `--with-keep.source`. Reinstall using:\n\n",
      "    `R_KEEP_PKG_SOURCE=yes` environment variable or \n",
      "    `R CMD INSTALL --with-keep.source ... `  or \n",
      "    `install.packages(..., INSTALL_opts = \"--with-keep.source\")`\n\n"
    )
  }
}



#' Extract test srcref objects
#'
#' @param x A package coverage object or similar.
#' @return A `list_of_srcref`
#'
#' @examples
#' options(covr.record_tests = TRUE)
#' pkg_path <- system.file("examplepkg", package = "covtracer")
#' cov <- covr::package_coverage(pkg_path)
#' test_srcrefs(cov)
#'
#' @family srcrefs
#' @seealso as.data.frame.list_of_srcref
#'
#' @rdname test_srcrefs
#' @export
test_srcrefs <- function(x) {
  UseMethod("test_srcrefs")
}

#' @param x A \code{\link[covr]{package_coverage}} coverage object, from which
#'   the test \code{srcref}s are extracted.
#'
#' @rdname test_srcrefs
#' @export
test_srcrefs.coverage <- function(x) {
  cov_tests <- attr(x, "tests")
  test_calls <- lapply(cov_tests, function(i) tail(i, 1L)[[1L]])
  test_srckeys <- names(test_calls) %||% rep_len("", length(test_calls))
  test_files <- as.list(gsub("(:\\d+){8}$", "", test_srckeys))
  test_llocs <- strsplit(gsub("^.*:((\\d+:){7}\\d+)$", "\\1", test_srckeys), ":")
  test_llocs <- lapply(test_llocs, as.numeric)
  test_files[test_srckeys == ""] <- list(NULL)
  test_llocs[test_srckeys == ""] <- list(NULL)
  as_list_of_srcref(mapply(
    function(call, file, lloc) with_pseudo_srcref(call, file, lloc),
    test_calls,
    test_files,
    test_llocs,
    SIMPLIFY = FALSE
  ))
}



#' Extract srcref objects from coverage object traces
#'
#' @param x (\code{link[covr]{package_coverage}}) A \code{\link[covr]{covr}}
#'   coverage object produced with \code{options(covr.record_tests = TRUE)}.
#' @return A `list_of_srcref`
#'
#' @family srcrefs
#' @seealso as.data.frame.list_of_srcref
#'
#' @rdname trace_srcrefs
#' @export
trace_srcrefs <- function(x) {
  UseMethod("trace_srcrefs")
}

#' @rdname trace_srcrefs
#' @export
trace_srcrefs.coverage <- function(x) {
  as_list_of_srcref(lapply(x, `[[`, "srcref"))
}
