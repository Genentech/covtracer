#' Test whether an object is a \code{srcref} object
#'
#' @param x Any object
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
#' @return A `list` of `srcref` objects. Often, has a length of 1, but can be
#'   larger for things like environments, namespaces or generic methods. The
#'   names of the list reflect the name of the Rd name or alias that could be
#'   used to find information related to each `srcref`.
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

#' @importFrom utils getSrcref
#' @rdname srcrefs
srcrefs.default <- function(x, ..., srcref_names = NULL) {
  sr <- getSrcref(x)

  if (!is.null(sr) && !is_srcref(sr) && !identical(sr, x)) {
    # some objects (eg MethodDefinition) do not return srcrefs, so recurse
    return(srcrefs(sr))
  }

  out <- list(sr)
  names(out) <- srcref_names
  out
}

#' @rdname srcrefs
srcrefs.list <- function(x, ..., srcref_names = NULL) {
  flat_map_srcrefs(x)
}

#' @rdname srcrefs
srcrefs.namespace <- function(x, ...) {
  flat_map_srcrefs(as.list(x, all.names = TRUE))
}

#' @rdname srcrefs
srcrefs.environment <- function(x, ...) {
  if (isNamespace(x)) return(srcrefs.namespace(x))
  objs <- as.list(x, all.names = TRUE)
  objs <- Filter(function(i) !identical(i, x), objs)  # prevent direct recursion
  flat_map_srcrefs(objs)
}

### R6

#' @rdname srcrefs
srcrefs.R6ClassGenerator <- function(x, ..., srcref_names = NULL) {
  objs <- c(list(x$new), x$public_methods, x$private_methods, x$active)
  names(objs) <- rep_len(srcref_names, length(objs))
  flat_map_srcrefs(objs)
}

#' @rdname srcrefs
srcrefs.R6 <- function(x, ..., srcref_names = NULL) {
  objs <- c(as.list(x, all.names = TRUE), .subset2(x, "private"))
  names(objs) <- rep_len(srcref_names, length(objs))
  objs <- Filter(function(i) !identical(i, x), objs)  # prevent direct recursion
  flat_map_srcrefs(objs)
}

### S4

#' @importFrom utils getSrcref
#' @rdname srcrefs
srcrefs.MethodDefinition <- function(x, ..., srcref_names = NULL) {
  # as produced by `methods:::.methods_info`
  signatures <- paste0(x@generic, ",", paste0(x@defined, collapse = ","), "-method")
  signatures <- signatures[!duplicated(signatures)]
  objs <- rep_len(list(getSrcref(x)), length(signatures))
  names(objs) <- signatures
  objs
}



#' Map `srcrefs` over an iterable object, Filtering non-srcref results
#'
#' @param xs Any iterable object
#'
flat_map_srcrefs <- function(xs) {
  srcs <- mapply(
    function(i, ...) srcrefs(i, ...),
    xs,
    srcref_names = names(xs),
    SIMPLIFY = FALSE
  )

  srcnames <- mapply(
    function(new, old) names(new) %||% rep_len(old, length(new)),
    srcs,
    names(srcs),
    SIMPLIFY = FALSE
  )

  srcs <- unlist(srcs, recursive = FALSE)
  names(srcs) <- unlist(srcnames, recursive = FALSE, use.names = FALSE)
  Filter(is_srcref, srcs)
}



#' Extract all the srcref objects of objects within a package namespace
#'
#' @param x A package namespace object or similar. One of either a package name,
#'   a namespace environment, or a \code{link[covr]{package_coverage}} result
#'   from which a package name is discovered. When package names are provided, a
#'   namespace available in the current environment is used.
#'
#' @examples
#' pkg <- system.file("examplepkg", package = "covtracer")
#' remotes::install_local(
#'   pkg, 
#'   force = TRUE, 
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
  as_list_of_srcref(srcrefs(x))
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
