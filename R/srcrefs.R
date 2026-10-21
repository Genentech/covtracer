#' Test whether an object is a \code{srcref} object
#'
#' @param x Any object
#' @return A `logical` indicating whether object is a `srcref`
#'
is_srcref <- function(x) {
  inherits(x, "srcref")
}

#' Get namespace of the \code{srcref} object
#'
#' @param srcref object
#' @return A `character` namespace name
#'
srcref_namespace <- function(srcref) {
  attr(srcref, "namespace", exact = TRUE)
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
srcrefs.default <- function(
  x,
  ...,
  srcref_names = NULL,
  breadcrumbs = character()
) {
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
srcrefs.list <- function(
  x,
  ...,
  srcref_names = NULL,
  breadcrumbs = character()
) {
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
    signatures <- paste0(
      x@generic, ",", paste0(x@defined, collapse = ","), "-method"
    )
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
    srcs <- c(srcs, wrapper_srcrefs(x, exclude = names(srcs)))
    srcs[setdiff(get_namespace_object_names(x), names(srcs))] <- NA
  }

  as_list_of_srcref(srcs)
}



#' Find srcrefs for namespace objects that wrap package functions
#'
#' Wrappers such as `Vectorize(f)` or `memoise::memoise(f)` have no `srcref`
#' of their own, but keep the function they wrap in their environment. Each
#' namespace object without a `srcref` is searched this way, and given the
#' `srcref`s of the wrapped functions that belong to the same namespace. Code
#' from other packages, such as helpers a wrapper uses internally, is left
#' out.
#'
#' @param ns A package namespace environment
#' @param exclude A `character` vector of object names that already have
#'   `srcref`s
#' @return A `list` of `srcref`s, named by the wrapper they belong to
#'
wrapper_srcrefs <- function(ns, exclude = character()) {
  pkg <- env_ns_name(ns)
  obj_names <- setdiff(ls(ns, all.names = TRUE), exclude)

  srcs <- lapply(obj_names, function(name) {
    obj <- get0(name, envir = ns, inherits = FALSE)
    if (!is.function(obj) || is.primitive(obj) || !is.null(getSrcref(obj))) {
      return(list())
    }

    found <- wrapped_srcrefs(obj)
    found <- Filter(function(sr) identical(srcref_namespace(sr), pkg), found)
    found[!duplicated(srcref_span_key(as_list_of_srcref(found)))]
  })

  found_names <- rep(obj_names, lengths(srcs))
  if (!length(found_names)) {
    return(list())
  }

  srcs <- unlist(srcs, recursive = FALSE, use.names = FALSE)
  names(srcs) <- found_names
  srcs
}



#' Collect srcrefs of the functions a wrapper keeps in its environment
#'
#' Functions with a `srcref` are collected. Functions without one may be
#' wrappers themselves, and are searched in turn. Environments shared by many
#' functions (namespaces, the global and base environments, attached
#' packages) are never searched, nor is any environment searched twice.
#'
#' @param f A function without a `srcref`
#' @param seen A `list` of environments already searched
#' @return A `list` of `srcref`s, each with a `"namespace"` attribute of the
#'   namespace of the function it came from
#'
wrapped_srcrefs <- function(f, seen = list()) {
  env <- environment(f)
  if (is_shared_env(env) || any(vapply(seen, identical, logical(1L), env))) {
    return(list())
  }
  seen <- c(seen, env)

  out <- list()
  for (name in ls(env, all.names = TRUE)) {
    obj <- tryCatch(
      get(name, envir = env, inherits = FALSE),
      error = function(e) NULL
    )
    if (!is.function(obj) || is.primitive(obj)) next

    sr <- getSrcref(obj)
    if (is_srcref(sr)) {
      attr(sr, "namespace") <- env_ns_name(environment(obj))
      out <- c(out, list(sr))
    } else {
      out <- c(out, wrapped_srcrefs(obj, seen))
    }
  }

  out
}



#' Test whether an environment is shared by many objects
#'
#' @param env An environment, or `NULL`
#' @return `TRUE` for `NULL`, namespaces, attached package environments and
#'   the global, base and empty environments
#'
is_shared_env <- function(env) {
  is.null(env) ||
    isNamespace(env) ||
    !is.null(attr(env, "name")) ||
    identical(env, globalenv()) ||
    identical(env, baseenv()) ||
    identical(env, emptyenv())
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
      "Package was not installed using `--with-keep.source`. Reinstall using:\n\n", # nolint
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
  re <- "(:\\d+){8}$"
  cov_tests <- attr(x, "tests")
  test_calls <- lapply(cov_tests, function(i) tail(i, 1L)[[1L]])

  # mask for calls with srcref
  m <- grepl(re, names(test_calls))

  test_llocs <- test_files <- character(length(test_calls))
  test_srckeys <- names(test_calls) %||% rep_len("", length(test_calls))

  test_files[m] <- as.list(gsub(re, "", test_srckeys[m]))
  test_llocs[m] <- strsplit(
    gsub("^.*:((\\d+:){7}\\d+)$", "\\1", test_srckeys[m]),
    ":"
  )

  test_llocs <- lapply(test_llocs, as.numeric)
  test_files[!m] <- list(NULL)
  test_llocs[!m] <- list(NULL)

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
